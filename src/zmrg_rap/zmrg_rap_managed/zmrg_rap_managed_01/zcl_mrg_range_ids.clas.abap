CLASS zcl_mrg_range_ids DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS:
        co_employee_id TYPE c LENGTH 2 VALUE '01'.

    METHODS:
      get_next_number IMPORTING range_key       TYPE zmrg_emp_char02
                      RETURNING VALUE(rv_range) TYPE zmrg_emp_range_value
                      RAISING
                                zcx_mrg_rap_01_messages.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mrg_range_ids IMPLEMENTATION.
  METHOD get_next_number.
    SELECT * FROM zmrg_ranges
        WHERE range_key EQ @range_key
        INTO TABLE @DATA(range_tab).

    ASSIGN range_tab[ 1 ] TO FIELD-SYMBOL(<range>).
    IF sy-subrc IS INITIAL.
      rv_range = <range>-range_value.

      <range>-range_value = 1 + CONV i( <range>-range_value ).
      MODIFY zmrg_ranges FROM @<range>.
      COMMIT WORK.
    ELSE.
      RAISE EXCEPTION TYPE zcx_mrg_rap_01_messages
        EXPORTING
          textid    = zcx_mrg_rap_01_messages=>no_range_key_found
          severity  = if_abap_behv_message=>severity-error
          range_key = range_key.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
