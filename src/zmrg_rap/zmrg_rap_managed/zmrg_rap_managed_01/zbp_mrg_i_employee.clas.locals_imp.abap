CLASS lhc_Employee DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_auth_str,
             field TYPE zmrg_field_or_value,
             value TYPE zmrg_field_or_value,
           END OF TY_AUTH_str,
           ty_auth_tab TYPE TABLE OF ty_auth_str WITH DEFAULT KEY.

  PRIVATE SECTION.
    DATA:
         o_auth_ref TYPE REF TO zmrg_cla_auth_util.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Employee RESULT result.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Employee RESULT result.

    METHODS:
      is_created_granted RETURNING VALUE(is_granted) TYPE abap_bool,
      check_auth_table IMPORTING activity            TYPE zmrg_emp_activity
                                 auth_obj            TYPE zmrg_emp_auth_obj
                                 field_values        TYPE ty_auth_tab
                       RETURNING VALUE(entry_exists) TYPE abap_bool.
ENDCLASS.

CLASS lhc_Employee IMPLEMENTATION.

  METHOD get_global_authorizations.
    " Utility class for MRG packages authorizations management
    me->o_auth_ref = zmrg_cla_auth_util=>get_instance( xco_cp=>sy->user( )->name ).

    IF requested_authorizations-%create EQ if_abap_behv=>mk-on.
      IF me->is_created_granted(  ) EQ abap_true.
        result-%create = if_abap_behv=>auth-allowed.
      ELSE.
        result-%create = if_abap_behv=>auth-unauthorized.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD is_created_granted.
    DATA key_values TYPE zmrg_cla_auth_util=>ty_field_value_tab.

*    AUTHORITY-CHECK OBJECT 'Z_EMP_AUTH' " Will be false, as I cannot maintain my roles
*      ID auth_obj_id    FIELD country_code
*      ID 'ACTVT'        FIELD '01'.
    " We will simulate an auth. check with ZMRG auth. class

    key_values = VALUE #( ( auth_field = 'ACTVT'   auth_value = '01' )
                          ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_EMPLOYEE' )
                          ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_CHILD' )
                          ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_SALARY' ) ).

    is_granted = o_auth_ref->is_authorized( auth_obj          = 'ZMRG_EMP'
                                            field_value_pairs = key_values ).
  ENDMETHOD.

  METHOD check_auth_table.
    DATA(current_user) = cl_abap_context_info=>get_user_technical_name( ).

    SELECT * FROM zmrg_emp_auth
        WHERE user_name EQ @current_user
         AND  actvt EQ @activity
         AND auth_obj EQ @auth_obj
     INTO TABLE @DATA(authorizations_by_user).

    ASSIGN authorizations_by_user[ 1 ] TO FIELD-SYMBOL(<user_auth>).
    IF <user_auth> IS NOT ASSIGNED.
      APPEND INITIAL LINE TO authorizations_by_user ASSIGNING <user_auth>.
      <user_auth>-actvt = activity.
      <user_auth>-auth_obj = auth_obj.
      <user_auth>-user_name = cl_abap_context_info=>get_user_technical_name( ).
      <user_auth>-fields_values = REDUCE string(
                                                  INIT auths = ``
                                                  FOR <fields> IN field_values
                                                  NEXT auths = |{ auths }{ <fields>-field }={ <fields>-value };|
                                                ).
      MODIFY zmrg_emp_auth FROM  TABLE @authorizations_by_user.
      entry_exists = abap_false.
      RETURN.
    ENDIF.

    LOOP AT field_values ASSIGNING FIELD-SYMBOL(<field_values>).
      DATA(field_matched) = match( val = <user_auth>-fields_values pcre = |{ <field_values>-field }={ <field_values>-value }| ).

      IF field_matched IS INITIAL.
        <user_auth>-fields_values = |{ <user_auth>-fields_values }{ <field_values>-field }={ <field_values>-value };|.
        MODIFY zmrg_emp_auth FROM  TABLE @authorizations_by_user.
        entry_exists = abap_false.
        RETURN.
      ENDIF.

    ENDLOOP.

    entry_exists = abap_true.

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
