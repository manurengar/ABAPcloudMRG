CLASS zmrg_cla_statustext_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zmrg_cla_statustext_generator IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA: lt_status TYPE TABLE OF zmrg_status_t.

    " Clear existing data to prevent duplicate key dumps on re-execution
    DELETE FROM zmrg_status_t.

    " Populate English texts based on image_3bcb0a.png
    lt_status = VALUE #(
      ( status = '01' spras = 'E' statustxt = 'New' )
      ( status = '02' spras = 'E' statustxt = 'Active' )
      ( status = '03' spras = 'E' statustxt = 'Inactive' )
      ( status = '04' spras = 'E' statustxt = 'Partially Active' )
      ( status = '05' spras = 'E' statustxt = 'Open' )

      " Populate Spanish texts to maintain the bilingual structure of your original class
      ( status = '01' spras = 'S' statustxt = 'Nuevo' )
      ( status = '02' spras = 'S' statustxt = 'Activo' )
      ( status = '03' spras = 'S' statustxt = 'Inactivo' )
      ( status = '04' spras = 'S' statustxt = 'Parcialmente Activo' )
      ( status = '05' spras = 'S' statustxt = 'Abierto' )
    ).

    INSERT zmrg_status_t FROM TABLE @lt_status.

    IF sy-subrc = 0.
      out->write( |Successfully inserted { lines( lt_status ) } records into ZMRG_STATUS_T.| ).
    ELSE.
      out->write( 'Error: Could not insert records.' ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
