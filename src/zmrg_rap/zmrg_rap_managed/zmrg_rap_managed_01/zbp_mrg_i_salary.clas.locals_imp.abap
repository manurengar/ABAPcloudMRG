CLASS lhc_salary DEFINITION INHERITING FROM cl_abap_behavior_handler.

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
  ENDMETHOD.

  METHOD validateOverlappingSplits.
  ENDMETHOD.

  METHOD calculate_net_salary.
    net_salary = gross_salary * position_type * ( 1 - '0.37' - '0.2' * ( 1 - exp( -1 * num_of_child ) ) ).
  ENDMETHOD.

ENDCLASS.


