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

    TYPES:
      t_entities_create   TYPE TABLE FOR CREATE zmrg_i_employee\\Employee,
      t_entities_update   TYPE TABLE FOR UPDATE zmrg_i_employee\\Employee,
      t_failed_employee   TYPE TABLE FOR FAILED EARLY zmrg_i_employee\\Employee,
      t_reported_employee TYPE TABLE FOR REPORTED EARLY zmrg_i_employee\\Employee.

    METHODS precheck_auths
      IMPORTING
        entities_create TYPE t_entities_create OPTIONAL
        entities_update TYPE t_entities_update OPTIONAL
      CHANGING
        failed          TYPE t_failed_employee
        reported        TYPE t_reported_employee.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Employee RESULT result.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Employee RESULT result.
    METHODS precheck_create FOR PRECHECK
      IMPORTING entities FOR CREATE employee.
    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE employee.
    METHODS createdefaultsalary FOR DETERMINE ON MODIFY
      IMPORTING keys FOR employee~createdefaultsalary.
    METHODS earlynumbering_cba_salary FOR NUMBERING
      IMPORTING entities FOR CREATE employee\_salary.
    METHODS earlynumbering_create FOR NUMBERING
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

  METHOD earlynumbering_create.
    " I cannot create number range here on trial, so I have my range on table zmrg_rang_emp_id
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
      TRY.
          DATA(new_employee_id) = NEW zcl_mrg_range_ids( )->get_next_number( range_key = '01' ).

          APPEND VALUE #( %cid       = <entity>-%cid
                          %is_draft  = <entity>-%is_draft
                          EmployeeId = new_employee_id ) TO mapped-employee.

        CATCH zcx_mrg_rap_01_messages INTO DATA(ex_ranges).

          APPEND VALUE #( %cid       = <entity>-%cid
                            %is_draft  = <entity>-%is_draft ) TO failed-employee.

          APPEND VALUE #( %cid       = <entity>-%cid
                          %is_draft  = <entity>-%is_draft
                          %msg       = ex_ranges ) TO reported-employee.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

  METHOD precheck_create.
    me->precheck_auths( EXPORTING
                          entities_create = entities
                        CHANGING
                          failed = failed-employee
                          reported = reported-employee ).
  ENDMETHOD.

  METHOD precheck_update.
    me->precheck_auths( EXPORTING
                            entities_update = entities
                        CHANGING
                            failed = failed-employee
                            reported = reported-employee ).
  ENDMETHOD.

  METHOD precheck_auths.
    DATA:
      entities       TYPE t_entities_update,
      operation      TYPE if_abap_behv=>t_char01,
      access_granted TYPE abap_bool,
      actvt          TYPE zmrg_emp_char02.

    " Either entities create or entities update are provided, not both
    ASSERT NOT ( entities_create IS INITIAL EQUIV entities_update IS INITIAL ).

    IF entities_create IS NOT INITIAL.
      entities = CORRESPONDING #( entities_create MAPPING %cid_ref = %cid ).
      operation = if_abap_behv=>op-m-create.
    ELSE.
      entities = entities_update.
      operation = if_abap_behv=>op-m-update.
    ENDIF.

    DELETE entities WHERE %control-Nationality EQ if_abap_behv=>mk-off.


    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
      CASE operation.
        WHEN if_abap_behv=>op-m-create.
          access_granted = me->is_created_granted( <entity>-Nationality ).
          actvt = '01'.
        WHEN if_abap_behv=>op-m-update.
          access_granted = me->is_updated_granted( <entity>-Nationality ).
          actvt = '02'.
      ENDCASE.

      IF access_granted EQ abap_false.
        APPEND VALUE #( %cid = COND #( WHEN operation EQ if_abap_behv=>op-m-create THEN <entity>-%cid_ref )
                        %tky = <entity>-%tky ) TO failed.

        APPEND VALUE #( %cid  = COND #( WHEN operation EQ if_abap_behv=>op-m-create THEN <entity>-%cid_ref )
                        %tky = <entity>-%tky
                        %element-Nationality = if_abap_behv=>mk-on
                        %msg = NEW zcx_mrg_rap_01_messages( textid = zcx_mrg_rap_01_messages=>not_authorized_for_nationality
                                                            severity = if_abap_behv_message=>severity-error
                                                            activity = CONV #( actvt )
                                                            employee_id = <entity>-EmployeeId
                                                            nationality = <entity>-Nationality ) ) TO reported.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD CreateDefaultSalary.
    DATA salary_create_tab TYPE TABLE FOR CREATE zmrg_i_employee\_Salary.

    READ ENTITIES OF zmrg_i_employee IN LOCAL MODE
      ENTITY Employee
        FIELDS ( Children )
      WITH CORRESPONDING #( keys )
      RESULT DATA(employees).

    LOOP AT employees ASSIGNING FIELD-SYMBOL(<employee>).

      DATA(temp_cid) = |SALARY_{ <employee>-EmployeeId }|.

      APPEND VALUE #( %tky    = <employee>-%tky
                      %target = VALUE #( ( %is_draft          = <employee>-%is_draft
                                           %cid               = temp_cid
                                           StartDate          = cl_abap_context_info=>get_system_date( )
                                           EndDate            = CONV d( '99991231' )
                                           PositionType       = '1'
                                           GrossAnnualSalary  = 10000
                                           NetAnnualSalary    = 10000
                                           Currency           = 'EUR'
                                           %control           = VALUE #( StartDate         = if_abap_behv=>mk-on
                                                                         EndDate           = if_abap_behv=>mk-on
                                                                         PositionType      = if_abap_behv=>mk-on
                                                                         GrossAnnualSalary = if_abap_behv=>mk-on
                                                                         NetAnnualSalary   = if_abap_behv=>mk-on
                                                                         Currency          = if_abap_behv=>mk-on
                                                                       )
                                          )
                                        )
                    ) TO salary_create_tab.
    ENDLOOP.

    IF salary_create_tab IS NOT INITIAL.
      MODIFY ENTITIES OF zmrg_i_employee IN LOCAL MODE
      ENTITY Employee
      CREATE BY \_Salary
      FROM salary_create_tab.
    ENDIF.
  ENDMETHOD.

  METHOD earlynumbering_cba_Salary.
    DATA: lo_range_ids TYPE REF TO zcl_mrg_range_ids.
    lo_range_ids = NEW zcl_mrg_range_ids( ).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
      LOOP AT <entity>-%target ASSIGNING FIELD-SYMBOL(<salary>).
        DATA(new_position_id) = lo_range_ids->get_next_number( range_key = '02' ).

        APPEND VALUE #( %cid       = <salary>-%cid
                        %is_draft  = <salary>-%is_draft
                        PositionId = new_position_id
                        startdate  = <salary>-StartDate " Provided on EML
                        enddate   = <salary>-EndDate    " Provided on EML
                      ) TO mapped-salary.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
