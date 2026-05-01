INTERFACE zmrg_if_blob_reader
  PUBLIC .
  TYPES: BEGIN OF ty_hash_blob_str,
           pernr TYPE pernr_d,
           blob  TYPE xstring,
         END OF ty_HASH_BLOB_STR,
         ty_hash_blob_tab TYPE HASHED TABLE OF ty_hash_blob_str WITH UNIQUE KEY primARY_KEY COMPONENTS pernr.

  METHODS: get_blob_from_pernr IMPORTING iv_pernr       TYPE pernr_d
                               RETURNING VALUE(rx_blob) TYPE xstring.
ENDINTERFACE.
