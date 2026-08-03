CLASS zcl_run_set_intervals DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

    METHODS:
      generate_intervals RETURNING VALUE(is_ok) TYPE abap_bool,
      test_intervals IMPORTING out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.

CLASS zcl_run_set_intervals IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    "me->generate_intervals( out ).
    "me->test_intervals( out ).
  ENDMETHOD.
  METHOD generate_intervals.
    TRY.
        cl_numberrange_intervals=>create(
          interval = VALUE #( ( nrrangenr = '01' fromnumber = '10000000' tonumber = '50000000' ) )
          object   = 'ZMRG_EMPID' ).

        is_ok = abap_true.

      CATCH cx_nr_object_not_found.
        is_ok = abap_false.
      CATCH cx_number_ranges INTO DATA(lx_error).
        is_ok = abap_false.
    ENDTRY.
  ENDMETHOD.

  METHOD test_intervals.

    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr = '01'
            object      = 'ZMRG_EMPID'
          IMPORTING
            number      = DATA(lv_next_number) ).

        out->write( lv_next_number ).
      CATCH cx_number_ranges INTO DATA(lx_nr_error).
        " Handle the exception (e.g., interval exhausted)
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
