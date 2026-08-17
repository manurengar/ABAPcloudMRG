*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


CLASS lcl_parent IMPLEMENTATION.

  METHOD constructor.
    child_ref = NEW #( ).
  ENDMETHOD.

ENDCLASS.

CLASS lcl_child IMPLEMENTATION.

  METHOD constructor.
    ref_sflight = NEW #( ).

    SELECT * FROM /dmo/flight INTO TABLE @ref_sflight->*.

    CREATE DATA ref_sflight_gen TYPE STANDARD TABLE OF /dmo/flight.
    ASSIGN ref_sflight_gen->* TO FIELD-SYMBOL(<fs_flight_table>).

    SELECT *
        FROM /dmo/flight
        INTO TABLE @<fs_flight_table>
        UP TO 100 ROWS.

  ENDMETHOD.

ENDCLASS.
