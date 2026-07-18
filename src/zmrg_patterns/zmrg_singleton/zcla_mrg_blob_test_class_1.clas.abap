CLASS zcla_mrg_blob_test_class_1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      constructor,
      test_1 IMPORTING out         TYPE REF TO if_oo_adt_classrun_out
                       blob_reader TYPE REF TO zmrg_if_blob_reader.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcla_mrg_blob_test_class_1 IMPLEMENTATION.
  METHOD constructor.

  ENDMETHOD.

  METHOD test_1.
    out->write( |BLOB1: { blob_reader->get_blob_from_pernr( '00002122' ) }| ).
  ENDMETHOD.

ENDCLASS.
