CLASS zcx_mrg_rap_02_messages DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_abap_behv_message .

    CONSTANTS:
      BEGIN OF product_unkown,
        msgid TYPE symsgid VALUE 'ZMRG_RAP_02_MESS',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'PRODUCT',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF product_unkown,

      BEGIN OF update_product_typ_not_allowed,
        msgid TYPE symsgid VALUE 'ZMRG_RAP_02_MESS',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'PRODUCTTYPE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF update_product_typ_not_allowed,

      BEGIN OF delete_product_typ_not_allowed,
        msgid TYPE symsgid VALUE 'ZMRG_RAP_02_MESS',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'PRODUCTTYPE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF delete_product_typ_not_allowed.

    DATA:
      product     TYPE matnr,
      producttype TYPE mtart.

    METHODS constructor
      IMPORTING
        textid      LIKE if_t100_message=>t100key OPTIONAL
        previous    LIKE previous                 OPTIONAL
        severity    TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        product     TYPE matnr OPTIONAL
        producttype TYPE mtart OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcx_mrg_rap_02_messages IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).

    me->product = product.
    me->producttype = producttype.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    me->if_abap_behv_message~m_severity = severity.
  ENDMETHOD.

ENDCLASS.
