CLASS lhc_salary DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    CONSTANTS:
      state_area_gross_validation TYPE string VALUE 'GROSS_VALIDATION'       ##NO_TEXT,
      state_area_overlap_split    TYPE string VALUE 'VALIDATE_OVERLAP_SPLIT' ##NO_TEXT.

  PRIVATE SECTION.

    CLASS-METHODS calculate_net_salary
      IMPORTING position_type     TYPE zmrg_employee_position_type
                gross_salary      TYPE betrg
                num_of_child      TYPE zmrg_employee_children
      RETURNING VALUE(net_salary) TYPE betrg.

    METHODS newSplit FOR MODIFY
      IMPORTING keys FOR ACTION Salary~newSplit.

    METHODS ReCalculateNetSalary FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Salary~ReCalculateNetSalary.

    METHODS validateGrossAnnualSalary FOR VALIDATE ON SAVE
      IMPORTING keys FOR Salary~validateGrossAnnualSalary.

    METHODS validateOverlappingSplits FOR VALIDATE ON SAVE
      IMPORTING keys FOR Salary~validateOverlappingSplits.

ENDCLASS.

CLASS lhc_salary IMPLEMENTATION.

  METHOD newSplit.
    " Delimit old to  split & create new split
    " This code just considers the 1st entry on the parameter table provided
    DATA:
      update_salary TYPE TABLE FOR UPDATE zmrg_i_employee\\Salary,
      read_employee TYPE TABLE FOR READ IMPORT zmrg_i_employee\\Employee.

    " Retrieve all the salary entities from the employee id
    READ ENTITIES OF zmrg_i_employee IN LOCAL MODE
    ENTITY salary
    FIELDS ( EmployeeId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(input_salary_entities).

    LOOP AT input_salary_entities ASSIGNING FIELD-SYMBOL(<salary>).
      read_employee = CORRESPONDING #( input_salary_entities MAPPING EmployeeId = EmployeeId
                                                                     %is_draft  = %is_draft ).
    ENDLOOP.

    READ ENTITIES OF zmrg_i_employee IN LOCAL MODE
    ENTITY Employee
    FIELDS ( EmployeeId )
    WITH CORRESPONDING #( read_employee )
    RESULT DATA(employee_entities).

    " Likely we will end up with only 1 employee
    SORT employee_entities BY %tky DESCENDING.
    DELETE ADJACENT DUPLICATES FROM employee_entities COMPARING %tky.

    " Retrieve the salary entities from these
    READ ENTITIES OF zmrg_i_employee IN LOCAL MODE
    ENTITY Employee BY \_Salary
    ALL FIELDS WITH CORRESPONDING #( employee_entities )
    RESULT DATA(entities_2b_delimited).

    SORT entities_2b_delimited BY EmployeeId EndDate DESCENDING.

    " Consider only the last split
    ASSIGN entities_2b_delimited[ 1 ] TO FIELD-SYMBOL(<entity_2b_delimited>).
    IF sy-subrc IS INITIAL.
      DATA(delimited_end_date) = keys[ 1 ]-%param-start_date - 1.

      " TODO: THE ENDDA MUST NOT BE KEY, RAP CANNOT CHANGE IT

      APPEND VALUE #( %tky = <entity_2b_delimited>-%tky
                      enddate = delimited_end_date
                      %control-enddate = if_abap_behv=>mk-on ) TO update_salary.

    ENDIF.
  ENDMETHOD.

  METHOD ReCalculateNetSalary.
    DATA update_salary_Tab TYPE TABLE FOR UPDATE zmrg_i_employee\\Salary.

    READ ENTITIES OF zmrg_i_employee IN LOCAL MODE
    ENTITY salary
    FIELDS ( EmployeeId GrossAnnualSalary PositionType )
    WITH CORRESPONDING #( keys )
    RESULT DATA(salary_entities).

    CHECK salary_entities IS NOT INITIAL.

    " Reading of Employee parent entity from Salary child
    DATA employee_key_tab TYPE TABLE FOR READ IMPORT zmrg_i_employee\\Employee.
    employee_key_tab = CORRESPONDING #( salary_entities MAPPING EmployeeId = EmployeeId
                                                                %is_draft  = %is_draft
                                      ).

    SORT employee_key_tab BY EmployeeId.
    DELETE ADJACENT DUPLICATES FROM employee_key_tab COMPARING EmployeeId.

    READ ENTITIES OF zmrg_i_employee IN LOCAL MODE
    ENTITY Employee
    FIELDS ( Children )
    WITH employee_key_tab
    RESULT DATA(employee_entities).

    " Calculate the net salary for each salary entity.
    LOOP AT salary_entities ASSIGNING FIELD-SYMBOL(<salary>).

      ASSIGN employee_entities[  KEY id %key-EmployeeId = <salary>-EmployeeId
                                        %is_draft  = <salary>-%is_draft ] TO FIELD-SYMBOL(<employee_entity>).

      IF <employee_entity> IS ASSIGNED.
        DATA(number_of_children) = <employee_entity>-Children.
      ELSE.
        number_of_children = 0.
      ENDIF.

      DATA(calculated_net_salary) = me->calculate_net_salary(
                                      position_type = <salary>-PositionType
                                      gross_salary  = <salary>-GrossAnnualSalary
                                      num_of_child  = number_of_children
                                    ).
      APPEND VALUE #( %tky                     = <salary>-%tky
                      netAnnualSalary          = calculated_net_salary
                      %control-netannualsalary = if_abap_behv=>mk-on ) TO update_salary_Tab.
    ENDLOOP.

    IF update_salary_tab IS NOT INITIAL.
      MODIFY ENTITIES OF zmrg_i_employee IN LOCAL MODE
      ENTITY salary
      UPDATE FIELDS ( NetAnnualSalary )
      WITH update_salary_tab
      REPORTED DATA(update_reported).

      reported-salary = CORRESPONDING #( update_reported-salary ).
    ENDIF.
  ENDMETHOD.

  METHOD validateGrossAnnualSalary.
    " Check that the gross amount introduced is never lower than 1000
    READ ENTITIES OF zmrg_i_employee IN LOCAL MODE
    ENTITY Salary
    FIELDS ( GrossAnnualSalary )
    WITH CORRESPONDING #( keys )
    RESULT DATA(salary_entities).

    LOOP AT salary_entities ASSIGNING FIELD-SYMBOL(<salary>).
      " Invalidate state message
      APPEND VALUE #( %tky        = <salary>-%tky
                      %state_area = state_area_gross_validation ) TO reported-salary.

      IF <salary>-GrossAnnualSalary LT 1000.
        APPEND VALUE #( %tky = <salary>-%tky ) TO failed-salary.

        APPEND VALUE #( %tky                       = <salary>-%tky
                        %path                      = VALUE #( employee-%tky = VALUE #( EmployeeId = <salary>-EmployeeId
                                                                                       %is_draft  = <salary>-%is_draft ) )
                        %state_area                = state_area_gross_validation
                        %element-grossannualsalary = if_abap_behv=>mk-on
                        %msg                       = NEW zcx_mrg_rap_01_messages( textid       = zcx_mrg_rap_01_messages=>incorrect_gross_salary
                                                                                  severity     = if_abap_behv_message=>severity-error
                                                                                  gross_salary = <salary>-GrossAnnualSalary ) ) TO reported-salary.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateOverlappingSplits.
    " Check:
    " 1) That start_date lt end_date
    " 2) Salary splits for 1 employee do not overlap

    READ ENTITIES OF zmrg_i_employee IN LOCAL MODE
    ENTITY salary
    FIELDS ( PositionId StartDate EndDate EmployeeId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(salary_entities).

    CHECK salary_entities IS NOT INITIAL.

    DATA employee_entities TYPE TABLE FOR READ IMPORT zmrg_i_employee\\Employee.

    employee_entities = CORRESPONDING #( salary_entities MAPPING EmployeeId = EmployeeId
                                                                 %is_draft  = %is_draft EXCEPT * ).
    SORT employee_entities BY EmployeeId DESCENDING.
    DELETE ADJACENT DUPLICATES FROM employee_entities COMPARING EmployeeId.

    " Read all existing salary entities for this employees
    READ ENTITIES OF zmrg_i_employee IN LOCAL MODE
    ENTITY Employee BY \_Salary
    FIELDS ( PositionId StartDate EndDate EmployeeId )
    WITH CORRESPONDING #( employee_entities )
    RESULT DATA(employee_salaries).

    LOOP AT salary_entities ASSIGNING FIELD-SYMBOL(<salary_2b_checked>).
      " Invalidate status message
      APPEND VALUE #( %tky        = <salary_2b_checked>-%tky
                      %state_area = state_area_overlap_split ) TO reported-salary.

      IF <salary_2b_checked>-StartDate GT <salary_2b_checked>-EndDate.
        APPEND VALUE #( %tky = <salary_2b_checked>-%tky ) TO failed-salary.

        APPEND VALUE #( %tky               = <salary_2b_checked>-%tky
                        %path              = VALUE #( employee-%tky = VALUE #( EmployeeId = <salary_2b_checked>-EmployeeId
                                                                               %is_draft  = <salary_2b_checked>-%is_draft ) )
                        %state_area        = state_area_overlap_split
                        %element-startdate = if_abap_behv=>mk-on
                        %msg               = NEW zcx_mrg_rap_01_messages( textid     = zcx_mrg_rap_01_messages=>incorrect_gross_salary
                                                                          severity   = if_abap_behv_message=>severity-error
                                                                          start_date = <salary_2b_checked>-StartDate
                                                                          end_date   = <salary_2b_checked>-EndDate ) ) TO reported-salary.
        CONTINUE.
      ENDIF.

      " Check over the rest of salaries for this employee
      LOOP AT employee_salaries ASSIGNING FIELD-SYMBOL(<existing_salary>)
       WHERE EmployeeId = <salary_2b_checked>-EmployeeId
         AND PositionId <> <salary_2b_checked>-PositionId
         AND %is_draft  = <salary_2b_checked>-%is_draft.

        IF <salary_2b_checked>-StartDate <= <existing_salary>-EndDate AND
           <salary_2b_checked>-EndDate   >= <existing_salary>-StartDate.

          APPEND VALUE #( %tky = <salary_2b_checked>-%tky ) TO failed-salary.

          APPEND VALUE #( %tky               = <salary_2b_checked>-%tky
                          %path              = VALUE #( employee-%tky = VALUE #( EmployeeId = <salary_2b_checked>-EmployeeId
                                                                                 %is_draft  = <salary_2b_checked>-%is_draft ) )
                          %state_area        = state_area_overlap_split
                          %element-startdate = if_abap_behv=>mk-on
                          %msg               = NEW zcx_mrg_rap_01_messages( textid     = zcx_mrg_rap_01_messages=>split_collision
                                                                            severity   = if_abap_behv_message=>severity-error
                                                                            start_date = <salary_2b_checked>-StartDate
                                                                            end_date   = <salary_2b_checked>-EndDate ) ) TO reported-salary.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD calculate_net_salary.
    net_salary = gross_salary * position_type * ( 1 - '0.37' - '0.2' * ( 1 - exp( -1 * num_of_child ) ) ).
  ENDMETHOD.

ENDCLASS.


