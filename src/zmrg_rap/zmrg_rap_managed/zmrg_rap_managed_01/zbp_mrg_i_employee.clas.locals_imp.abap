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
    METHODS precheck_create FOR PRECHECK
      IMPORTING entities FOR CREATE employee.

    METHODS:
      is_created_granted IMPORTING iv_country TYPE land1 OPTIONAL RETURNING VALUE(is_granted) TYPE abap_bool,
      is_updated_granted IMPORTING iv_country TYPE land1 OPTIONAL RETURNING VALUE(is_granted) TYPE abap_bool,
      is_deleted_granted IMPORTING iv_country TYPE land1 OPTIONAL RETURNING VALUE(is_granted) TYPE abap_bool.
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
    IF iv_country IS SUPPLIED.
      key_values = VALUE #( ( auth_field   = 'ACTVT'   auth_value = '01' )
                              ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_EMPLOYEE' )
                              ( auth_field = 'Z_NATIO' auth_value = iv_country ) ).
    ELSE.
      key_values = VALUE #( ( auth_field = 'ACTVT'   auth_value = '01' )
                            ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_EMPLOYEE' )
                            ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_CHILD' )
                            ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_SALARY' ) ).

      is_granted = o_auth_ref->is_authorized( auth_obj          = 'ZMRG_EMP'
                                              field_value_pairs = key_values ).
    ENDIF.
  ENDMETHOD.

  METHOD is_deleted_granted.
    DATA key_values TYPE zmrg_cla_auth_util=>ty_field_value_tab.
    IF iv_country IS SUPPLIED.
      key_values = VALUE #( ( auth_field   = 'ACTVT'   auth_value = '03' )
                              ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_EMPLOYEE' )
                              ( auth_field = 'Z_NATIO' auth_value = iv_country ) ).
    ELSE.
      key_values = VALUE #( ( auth_field = 'ACTVT'   auth_value = '03' )
                            ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_EMPLOYEE' )
                            ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_CHILD' )
                            ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_SALARY' ) ).
    ENDIF.

    is_granted = o_auth_ref->is_authorized( auth_obj          = 'ZMRG_EMP'
                                            field_value_pairs = key_values ).
  ENDMETHOD.

  METHOD is_updated_granted.
    DATA key_values TYPE zmrg_cla_auth_util=>ty_field_value_tab.

    IF iv_country IS SUPPLIED.
      key_values = VALUE #( ( auth_field   = 'ACTVT'   auth_value = '02' )
                          ( auth_field     = 'S_TABU'  auth_value = 'ZMRG_TAB_EMPLOYEE' )
                          ( auth_field     = 'Z_NATIO' auth_value = iv_country ) ).
    ELSE.
      key_values = VALUE #( ( auth_field = 'ACTVT'   auth_value = '02' )
                            ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_EMPLOYEE' )
                            ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_CHILD' )
                            ( auth_field = 'S_TABU'  auth_value = 'ZMRG_TAB_SALARY' ) ).
    ENDIF.
    is_granted = o_auth_ref->is_authorized( auth_obj          = 'ZMRG_EMP'
                                            field_value_pairs = key_values ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
    " Scenario: User is only entitle to modify or delete employees for 1 nationality
    " This applies also to child entities
    DATA:
      update_requested TYPE abap_bool,
      delete_requested TYPE abap_bool,
      update_granted   TYPE abap_bool,
      delete_granted   TYPE abap_bool.

    READ ENTITIES OF zmrg_i_employee IN LOCAL MODE
        ENTITY Employee
            FIELDS ( EmployeeId Nationality )
        WITH CORRESPONDING #( keys )
    RESULT DATA(employees_data)
    FAILED DATA(employee_read_failed).

    CHECK employees_data IS NOT INITIAL.

    update_requested = COND #( WHEN requested_authorizations-%action-Edit EQ if_abap_behv=>mk-on
                                 OR requested_authorizations-%update EQ if_abap_behv=>mk-on
                               THEN abap_true ELSE abap_false ).
    delete_requested = COND #( WHEN requested_authorizations-%delete EQ if_abap_behv=>mk-on
                               THEN abap_true ELSE abap_false ).

    LOOP AT employees_data ASSIGNING FIELD-SYMBOL(<employee>).
      " UPDATE check
      IF update_requested EQ abap_true.
        update_granted = me->is_updated_granted( <employee>-Nationality ).
        IF update_granted EQ abap_false.
          APPEND VALUE #( %tky = <employee>-%tky
                          %element-employeeid = if_abap_behv=>mk-on
                          %msg = NEW zcx_mrg_rap_01_messages( textid = zcx_mrg_rap_01_messages=>not_authorized_for_nationality
                                                              severity = if_abap_behv_message=>severity-error
                                                              activity = '02'
                                                              nationality = <employee>-Nationality
                                                              employee_id = <employee>-EmployeeId ) ) TO reported-employee.
        ENDIF.
      ENDIF.

      " DELETE check
      IF delete_requested EQ abap_true.
        delete_granted = me->is_updated_granted( <employee>-Nationality ).
        IF delete_granted EQ abap_false.
          APPEND VALUE #( %tky = <employee>-%tky
                          %element-employeeid = if_abap_behv=>mk-on
                          %msg = NEW zcx_mrg_rap_01_messages( textid = zcx_mrg_rap_01_messages=>not_authorized_for_nationality
                                                              severity = if_abap_behv_message=>severity-error
                                                              activity = '03'
                                                              nationality = <employee>-Nationality
                                                              employee_id = <employee>-EmployeeId ) ) TO reported-employee.
        ENDIF.
      ENDIF.

      APPEND VALUE #( LET upd_auth = COND #( WHEN update_granted EQ abap_true
                                             THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized
                                           )
                          del_auth = COND #( WHEN delete_granted EQ abap_true
                                             THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized
                                           )
                      IN
                          %tky = <employee>-%tky
                          %update = upd_auth
                          %action-Edit = upd_auth
                          %delete = del_auth
                     ) TO result.
    ENDLOOP.

  ENDMETHOD.

  METHOD precheck_create.
  ENDMETHOD.

ENDCLASS.
