CLASS lhc_child DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validatePercentage FOR VALIDATE ON SAVE
      IMPORTING keys FOR Child~validatePercentage.

ENDCLASS.

CLASS lhc_child IMPLEMENTATION.

  METHOD validatePercentage.
    " Ensure the percentage does not fall out of bounds (0 to 1).
    READ ENTITIES OF zmrg_i_employee IN LOCAL MODE
    ENTITY Child
    FIELDS ( DiscapacityPercentage )
    WITH CORRESPONDING #( keys )
    RESULT DATA(child_entities).

    LOOP AT child_entities ASSIGNING FIELD-SYMBOL(<child>)
        WHERE DiscapacityPercentage LT 0 OR DiscapacityPercentage GT 1.

      APPEND VALUE #( %tky = <child>-%tky ) TO failed-child.

      APPEND VALUE #( %tky = <child>-%tky
                      %element-DiscapacityPercentage = if_abap_behv=>mk-on
                      %msg = NEW zcx_mrg_rap_01_messages( textid = zcx_mrg_rap_01_messages=>percentage_out_of_bounds
                                                          severity = if_abap_behv_message=>severity-error
                                                          percentage = <child>-DiscapacityPercentage ) ) TO reported-child.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

