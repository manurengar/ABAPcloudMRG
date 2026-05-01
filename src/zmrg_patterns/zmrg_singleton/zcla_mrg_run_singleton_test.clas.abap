CLASS zcla_mrg_run_singleton_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcla_mrg_run_singleton_test IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(o_test1) = NEW zcla_mrg_blob_test_class_1( ).
    DATA(o_test2) = NEW zcla_mrg_blob_test_class_2( ).
    DATA(o_blob_reader) = CAST zmrg_if_blob_reader( zcla_mrg_blob_reader=>get_instance( ) ).

    o_test1->test_1( out = out blob_reader = o_blob_reader ).
    " is the same instance?
    DATA(o_blob_reader_2) = CAST zmrg_if_blob_reader( zcla_mrg_blob_reader=>get_instance( ) ).
    o_test2->test_2( out = out blob_reader = o_blob_reader ).
  ENDMETHOD.

ENDCLASS.
