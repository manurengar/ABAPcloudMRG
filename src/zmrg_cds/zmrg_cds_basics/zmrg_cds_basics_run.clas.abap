CLASS zmrg_cds_basics_run DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS fill_zmrg_cds_02.
ENDCLASS.



CLASS zmrg_cds_basics_run IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  ENDMETHOD.

  METHOD fill_zmrg_cds_02.
    DATA(o_ramdon) = cl_abap_random_int=>create( min = 1 max = 5 ).
    DATA to_insert_tab TYPE TABLE OF zmrg_cds_02 WITH EMPTY KEY.

    DO 30 TIMES.
      APPEND INITIAL LINE TO to_insert_tab ASSIGNING FIELD-SYMBOL(<fs>).
      <fs>-client = sy-mandt.
      <fs>-tab_index = sy-index.
      <fs>-col1 = o_ramdon->get_next( ).
      <fs>-col2 = o_ramdon->get_next( ).
      <fs>-col3 = o_ramdon->get_next( ).
    ENDDO.

    MODIFY zmrg_cds_02 FROM TABLE @to_insert_tab.
  ENDMETHOD.

ENDCLASS.
