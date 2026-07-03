CLASS lhc_child DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validatePercentage FOR VALIDATE ON SAVE
      IMPORTING keys FOR Child~validatePercentage.
    METHODS validateAge FOR VALIDATE ON SAVE
      IMPORTING keys FOR Child~validateAge.
    METHODS CalculateChildrenCount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Child~CalculateChildrenCount.

ENDCLASS.

CLASS lhc_child IMPLEMENTATION.

  METHOD validatePercentage.
    " Ensure the percentage does not fall out of bounds (0 to 1).
    READ ENTITIES OF zmrg_i_employee IN LOCAL MODE
    ENTITY Child
    FIELDS ( DiscapacityPercentage )
    WITH CORRESPONDING #( keys )
    RESULT DATA(child_entities).

    LOOP AT child_entities ASSIGNING FIELD-SYMBOL(<child>).
      APPEND VALUE #( %tky          = <child>-%tky
                      %state_area   = 'VALIDATE_PERCENTAGE' ) TO reported-child.

      IF <child>-DiscapacityPercentage LT 0 OR <child>-DiscapacityPercentage GT 1.

        APPEND VALUE #( %tky = <child>-%tky ) TO failed-child.

        APPEND VALUE #( %tky = <child>-%tky
                        %state_area         = 'VALIDATE_PERCENTAGE'
                        %element-DiscapacityPercentage = if_abap_behv=>mk-on
                        %path       = VALUE #( employee-%tky = VALUE #( EmployeeId = <child>-EmployeeId
                                                                        %is_draft  = <child>-%is_draft ) )
                        %msg = NEW zcx_mrg_rap_01_messages( textid = zcx_mrg_rap_01_messages=>percentage_out_of_bounds
                                                            severity = if_abap_behv_message=>severity-error
                                                            percentage = <child>-DiscapacityPercentage ) ) TO reported-child.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateAge.
    " Only kids between 0 and 17 will apply for salary increase
    READ ENTITIES OF zmrg_i_employee IN LOCAL MODE
    ENTITY Child
    FIELDS ( Age )
    WITH CORRESPONDING #( keys )
    RESULT DATA(child_entities).

    LOOP AT child_entities ASSIGNING FIELD-SYMBOL(<child>).
      APPEND VALUE #( %tky        = <child>-%tky
                      %state_area = 'VALIDATE_AGE' ) TO reported-child.

      IF <child>-age LT 0 OR <child>-age GE 18.

        APPEND VALUE #( %tky = <child>-%tky ) TO failed-child.

        APPEND VALUE #( %tky = <child>-%tky
                        %state_area = 'VALIDATE_AGE'
                        %element-age = if_abap_behv=>mk-on
                        %path        = VALUE #( employee-%tky = VALUE #( EmployeeId = <child>-EmployeeId
                                                                         %is_draft  = <child>-%is_draft ) )
                        %msg = NEW zcx_mrg_rap_01_messages( textid   = zcx_mrg_rap_01_messages=>age_out_of_bounds
                                                            severity = if_abap_behv_message=>severity-error
                                                            age      = <child>-age ) ) TO reported-child.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD CalculateChildrenCount.
    DATA:
      employee_key    TYPE TABLE FOR READ IMPORT zmrg_i_employee\\Employee,
      update_employee TYPE TABLE FOR UPDATE zmrg_i_employee\\Employee.

    " From the parent Employee entity, count the current number of Children entities
    READ ENTITIES OF zmrg_i_employee IN LOCAL MODE
    ENTITY Employee
    FIELDS ( EmployeeId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(employees_entities). " We should only have one parent

    employee_key = CORRESPONDING #( employees_entities MAPPING %tky = %tky EXCEPT * ).
    SORT employee_key BY %tky.
    DELETE ADJACENT DUPLICATES FROM employee_key COMPARING %tky.

    ASSIGN employee_key[ 1 ] TO FIELD-SYMBOL(<employee_key>).
    IF sy-subrc IS INITIAL.
      " Count how many children the root entity has right now
      READ ENTITIES OF zmrg_i_employee IN LOCAL MODE
      ENTITY Child
      FIELDS ( uuid )
      WITH VALUE #( ( EmployeeId = <employee_key>-EmployeeId ) )
      RESULT FINAL(child_entities).

      DATA(number_of_child) = lines( child_entities ).

      APPEND VALUE #( %tky = <employee_key>-%tky
                      children = number_of_child ) TO update_employee.

      MODIFY ENTITIES OF zmrg_i_employee IN LOCAL MODE
      ENTITY Employee
      UPDATE FIELDS ( Children )
      WITH update_employee.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

