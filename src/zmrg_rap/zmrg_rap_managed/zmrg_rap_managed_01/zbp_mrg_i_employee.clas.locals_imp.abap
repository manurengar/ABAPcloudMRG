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
      is_updated_granted RETURNING VALUE(is_granted) TYPE abap_bool,
      is_deleted_granted RETURNING VALUE(is_granted) TYPE abap_bool.
ENDCLASS.

CLASS lhc_Employee IMPLEMENTATION.

  METHOD get_global_authorizations.
    " Utility class for MRG packages authorizations management
    me->o_auth_ref = zmrg_cla_auth_util=>get_instance( xco_cp=>sy->user( )->name ).

    " Creation of entries - ACTVT 01
    IF requested_authorizations-%create EQ if_abap_behv=>mk-on.
      IF me->is_created_granted(  ) EQ abap_true.
        result-%create = if_abap_behv=>auth-allowed.
      ELSE.
        result-%create = if_abap_behv=>auth-unauthorized.
        APPEND VALUE #( %msg    = NEW zcx_mrg_rap_01_messages( textid        = zcx_mrg_rap_01_messages=>not_authorized
                                                               severity      = if_abap_behv_message=>severity-error
                                                               activity      = '01'
                                                               table_name_01 = 'ZMRG_TAB_EMPLOYEE'
                                                               table_name_02 = 'ZMRG_TAB_CHILD'
                                                               table_name_03 = 'ZMRG_TAB_SALARY'
                                                             )
                        %global = if_abap_behv=>mk-on
                      ) TO reported-employee.
      ENDIF.
    ENDIF.

    " Update of entries - ACTVT 02
    IF requested_authorizations-%action-Edit EQ if_abap_behv=>mk-on
    OR requested_authorizations-%update EQ if_abap_behv=>mk-on.
      IF me->is_updated_granted(  ) EQ abap_true.
        result-%create = if_abap_behv=>auth-allowed.
      ELSE.
        result-%create = if_abap_behv=>auth-unauthorized.
        APPEND VALUE #( %msg    = NEW zcx_mrg_rap_01_messages( textid        = zcx_mrg_rap_01_messages=>not_authorized
                                                               severity      = if_abap_behv_message=>severity-error
                                                               activity      = '02'
                                                               table_name_01 = 'ZMRG_TAB_EMPLOYEE'
                                                               table_name_02 = 'ZMRG_TAB_CHILD'
                                                               table_name_03 = 'ZMRG_TAB_SALARY'
                                                             )
                        %global = if_abap_behv=>mk-on
                      ) TO reported-employee.
      ENDIF.
    ENDIF.

    " Deletion of entries - ACTVT 03
    IF requested_authorizations-%action-Edit EQ if_abap_behv=>mk-on
    OR requested_authorizations-%update EQ if_abap_behv=>mk-on.
      IF me->is_deleted_granted(  ) EQ abap_true.
        result-%create = if_abap_behv=>auth-allowed.
      ELSE.
        result-%create = if_abap_behv=>auth-unauthorized.
        APPEND VALUE #( %msg    = NEW zcx_mrg_rap_01_messages( textid        = zcx_mrg_rap_01_messages=>not_authorized
                                                               severity      = if_abap_behv_message=>severity-error
                                                               activity      = '03'
                                                               table_name_01 = 'ZMRG_TAB_EMPLOYEE'
                                                               table_name_02 = 'ZMRG_TAB_CHILD'
                                                               table_name_03 = 'ZMRG_TAB_SALARY'
                                                             )
                        %global = if_abap_behv=>mk-on
                      ) TO reported-employee.
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

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD is_deleted_granted.
    DATA key_values TYPE zmrg_cla_auth_util=>ty_field_value_tab.

    key_values = VALUE #( ( auth_field = 'ACTVT'   auth_value = '03' )
                          ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_EMPLOYEE' )
                          ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_CHILD' )
                          ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_SALARY' ) ).

    is_granted = o_auth_ref->is_authorized( auth_obj          = 'ZMRG_EMP'
                                            field_value_pairs = key_values ).
  ENDMETHOD.

  METHOD is_updated_granted.
    DATA key_values TYPE zmrg_cla_auth_util=>ty_field_value_tab.

    key_values = VALUE #( ( auth_field = 'ACTVT'   auth_value = '02' )
                          ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_EMPLOYEE' )
                          ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_CHILD' )
                          ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_SALARY' ) ).

    is_granted = o_auth_ref->is_authorized( auth_obj          = 'ZMRG_EMP'
                                            field_value_pairs = key_values ).
  ENDMETHOD.

ENDCLASS.
