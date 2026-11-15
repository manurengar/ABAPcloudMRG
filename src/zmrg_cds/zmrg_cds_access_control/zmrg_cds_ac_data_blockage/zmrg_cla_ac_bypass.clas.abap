CLASS zmrg_cla_ac_bypass DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zmrg_cla_ac_bypass IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  " In case we need to select from a restricted CDS we can do it on 2 ways

  " 1) If we only need to read from CDS then use: with privilege access
    SELECT FROM zmrg_i_salesorder_data_blockag WITH PRIVILEGED ACCESS
    FIELDS *
    INTO TABLE @DATA(lt_salesorders).


  " 2) If path expressions also need to be accessed bypassing the Access Control then
  " use the variant: PRIVILEGED ACCESS
    SELECT FROM zmrg_i_salesorder_data_blockag
    FIELDS *
    INTO TABLE @lt_salesorders
    PRIVILEGED ACCESS.

  ENDMETHOD.
ENDCLASS.
