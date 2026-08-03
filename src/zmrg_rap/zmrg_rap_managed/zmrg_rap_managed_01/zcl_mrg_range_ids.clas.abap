CLASS zcl_mrg_range_ids DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS:
        co_employee_id TYPE c LENGTH 2 VALUE '01'.

    METHODS:
      create_interval RETURNING VALUE(is_created)  TYPE abap_bool,
      get_next_number IMPORTING range_key          TYPE cl_numberrange_runtime=>nr_object
                      RETURNING VALUE(next_number) TYPE cl_numberrange_runtime=>nr_number
                      RAISING   zcx_mrg_rap_01_messages.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mrg_range_ids IMPLEMENTATION.
  METHOD get_next_number.

    me->create_interval( ).

    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr = '01'
            object      = range_key
          IMPORTING
            number      = next_number ).


      CATCH cx_number_ranges INTO DATA(lx_nr_error).
        RAISE EXCEPTION TYPE zcx_mrg_rap_01_messages
          EXPORTING
            textid    = zcx_mrg_rap_01_messages=>no_range_key_found
            severity  = if_abap_behv_message=>severity-error
            range_key = CONV #( range_key ).
    ENDTRY.

  ENDMETHOD.

  METHOD create_interval.
    " If fails, likely it means it was already created (1st execution only).
    DATA(interval_created) = NEW zcl_run_set_intervals( )->generate_intervals( ).
  ENDMETHOD.

ENDCLASS.
