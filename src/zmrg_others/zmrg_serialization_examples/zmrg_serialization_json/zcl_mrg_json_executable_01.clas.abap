CLASS zcl_mrg_json_executable_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      serialize_object,
      deserialize_object.
ENDCLASS.



CLASS zcl_mrg_json_executable_01 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    me->deserialize_object( ).
  ENDMETHOD.

  METHOD deserialize_object.
    SELECT * FROM zmrg_obj_state
    INTO TABLE @DATA(obj_state_tab).

    ASSIGN obj_state_tab[ 1 ] TO FIELD-SYMBOL(<obj_state>).
    IF sy-subrc IS INITIAL.

      TRY.
          cl_abap_gzip=>decompress_text(
            EXPORTING
              gzip_in  = <obj_state>-state_data
            IMPORTING
              text_out = DATA(unzipped_json)
          ) ##TYPE. " Suppresses the generic type warning

        CATCH cx_root INTO DATA(lx_err).
          " Handle decompression error (e.g., write to application log)
          RETURN.
      ENDTRY.


      DATA lo_parent TYPE REF TO lcl_parent.
      lo_parent = NEW #( ).

      /ui2/cl_json=>deserialize(
        EXPORTING
          json = unzipped_json
        CHANGING
          data = lo_parent
      ).
    ENDIF.

  ENDMETHOD.

  METHOD serialize_object.
    DATA(lo_parent) = NEW lcl_parent( ).
    lo_parent->parent_name = 'Root Parent'.

    " 2. Serialize the object to a JSON string
    DATA(lv_json) = /ui2/cl_json=>serialize(
        data        = lo_parent
        pretty_name = /ui2/cl_json=>pretty_mode-low_case ).


    TRY.
        cl_abap_gzip=>compress_text(
          EXPORTING
            text_in  = lv_json
          IMPORTING
            gzip_out = DATA(zipped_json)
        ) ##TYPE.
      CATCH cx_root INTO DATA(lx_err).
        " Handle compression error
        RETURN.
    ENDTRY.

    DATA ls_state TYPE zmrg_obj_state.

    ls_state-uuid       = cl_system_uuid=>create_uuid_x16_static( ).
    ls_state-class_name = 'LCL_PARENT'.
    ls_state-created_by = cl_abap_context_info=>get_user_technical_name( ).
    ls_state-created_at = cl_abap_tstmp=>utclong2tstmp( utclong = utclong_current( ) ).
    ls_state-state_data = zipped_json.

    " 4. Insert into the database
    INSERT zmrg_obj_state FROM @ls_state.
    IF sy-subrc = 0.
      COMMIT WORK.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
