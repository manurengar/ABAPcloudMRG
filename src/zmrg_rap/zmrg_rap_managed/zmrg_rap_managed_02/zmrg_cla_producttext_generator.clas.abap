CLASS zmrg_cla_producttext_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zmrg_cla_producttext_generator IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA: lt_matnr TYPE TABLE OF zmrg_matnr_t.

    " Clear existing data to prevent duplicate key dumps on re-execution
    DELETE FROM zmrg_matnr_t.

    " Populate English texts
    lt_matnr = VALUE #(
      ( matnr = 'MAT-0001' mtart = 'HAWA' spras = 'E' maktx = 'Laptop Pro 15' )
      ( matnr = 'MAT-0002' mtart = 'HAWA' spras = 'E' maktx = 'Wireless Mouse' )
      ( matnr = 'MAT-0003' mtart = 'HAWA' spras = 'E' maktx = 'Mechanical Keyboard' )
      ( matnr = 'MAT-0004' mtart = 'HAWA' spras = 'E' maktx = '27-inch 4K Monitor' )
      ( matnr = 'MAT-0005' mtart = 'HAWA' spras = 'E' maktx = 'USB-C Docking Station' )
      ( matnr = 'MAT-0006' mtart = 'HAWA' spras = 'E' maktx = 'Noise Cancelling Headphones' )
      ( matnr = 'MAT-0007' mtart = 'HAWA' spras = 'E' maktx = 'Ergonomic Office Chair' )
      ( matnr = 'MAT-0008' mtart = 'HAWA' spras = 'E' maktx = 'Standing Desk' )
      ( matnr = 'MAT-0009' mtart = 'HAWA' spras = 'E' maktx = 'Webcam 1080p' )
      ( matnr = 'MAT-0010' mtart = 'HAWA' spras = 'E' maktx = '1TB NVMe SSD' )

      " Populate Spanish texts
      ( matnr = 'MAT-0001' mtart = 'HAWA' spras = 'S' maktx = 'Portátil Pro 15' )
      ( matnr = 'MAT-0002' mtart = 'HAWA' spras = 'S' maktx = 'Ratón Inalámbrico' )
      ( matnr = 'MAT-0003' mtart = 'HAWA' spras = 'S' maktx = 'Teclado Mecánico' )
      ( matnr = 'MAT-0004' mtart = 'HAWA' spras = 'S' maktx = 'Monitor 4K 27 pulgadas' )
      ( matnr = 'MAT-0005' mtart = 'HAWA' spras = 'S' maktx = 'Estación de acoplamiento USB-C' )
      ( matnr = 'MAT-0006' mtart = 'HAWA' spras = 'S' maktx = 'Auriculares con cancelación de ruido' )
      ( matnr = 'MAT-0007' mtart = 'HAWA' spras = 'S' maktx = 'Silla ergonómica de oficina' )
      ( matnr = 'MAT-0008' mtart = 'HAWA' spras = 'S' maktx = 'Escritorio elevable' )
      ( matnr = 'MAT-0009' mtart = 'HAWA' spras = 'S' maktx = 'Cámara web 1080p' )
      ( matnr = 'MAT-0010' mtart = 'HAWA' spras = 'S' maktx = 'SSD NVMe 1TB' )
    ).

    INSERT zmrg_matnr_t FROM TABLE @lt_matnr.

    IF sy-subrc = 0.
      out->write( |Successfully inserted { lines( lt_matnr ) } records into ZMRG_MATNR_T.| ).
    ELSE.
      out->write( 'Error: Could not insert records.' ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
