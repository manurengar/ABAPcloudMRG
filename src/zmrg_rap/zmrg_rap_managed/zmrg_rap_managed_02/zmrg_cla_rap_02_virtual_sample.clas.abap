CLASS zmrg_cla_rap_02_virtual_sample DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zmrg_cla_rap_02_virtual_sample IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    " Use the populated fields to perform the business logic
    DATA certificate TYPE TABLE OF zmrg_c_certificate.

    certificate = CORRESPONDING #( it_original_data ).

    LOOP AT certificate ASSIGNING FIELD-SYMBOL(<certificate>).
      <certificate>-virtualSampleText = |VIRTUAL_{ <certificate>-ProductName }|.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( certificate ).
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    "Here to take which elements do we need populated for our business logic
    LOOP AT it_requested_calc_elements ASSIGNING FIELD-SYMBOL(<element>).
      CASE <element>.
        WHEN 'VIRTUALSAMPLETEXT'.
          APPEND 'PRODUCTNAME' TO et_requested_orig_elements.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
