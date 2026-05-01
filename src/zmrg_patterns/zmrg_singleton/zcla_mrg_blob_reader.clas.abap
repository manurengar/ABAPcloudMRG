CLASS zcla_mrg_blob_reader DEFINITION PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.

    INTERFACES zmrg_if_blob_reader.

    " Needed on the singleton pattern
    CLASS-METHODS: get_instance RETURNING VALUE(ro_blob_reader) TYPE REF TO zmrg_if_blob_reader.

  PRIVATE SECTION.

    DATA buffered_blom_table TYPE zmrg_if_blob_reader=>ty_hash_blob_tab.

    " Needed on the singleton pattern
    CLASS-DATA: o_blob_reader TYPE REF TO zmrg_if_blob_reader.
    METHODS: constructor.

ENDCLASS.



CLASS zcla_mrg_blob_reader IMPLEMENTATION.


  METHOD zmrg_if_blob_reader~get_blob_from_pernr.
    ASSIGN me->buffered_blom_table[ KEY primary_key COMPONENTS pernr = iv_pernr ] TO FIELD-SYMBOL(<blob>).
    IF <blob> IS ASSIGNED.
      rx_blob = <blob>-blob.
    ELSE.
      DATA(random_number_generator) = cl_abap_random_int=>create( seed = cl_abap_random=>seed( )
                                                                  min  = 1
                                                                  max  = 1000 ).
      DATA(random_number) = random_number_generator->get_next( ).

      INSERT VALUE #( pernr = iv_pernr
                      blob  = random_number ) INTO TABLE me->buffered_blom_table.

      rx_blob = random_number.
    ENDIF.
  ENDMETHOD.

  METHOD constructor.
    " Default constructor
  ENDMETHOD.

  METHOD get_instance.
    zcla_mrg_blob_reader=>o_blob_reader = COND #( WHEN zcla_mrg_blob_reader=>o_blob_reader IS NOT BOUND THEN NEW zcla_mrg_blob_reader( )
                                                  ELSE zcla_mrg_blob_reader=>o_blob_reader ).
    ro_blob_reader = zcla_mrg_blob_reader=>o_blob_reader.
  ENDMETHOD.

ENDCLASS.
