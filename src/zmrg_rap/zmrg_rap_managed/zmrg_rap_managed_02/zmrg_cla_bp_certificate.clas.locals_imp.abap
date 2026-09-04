CLASS lhc_Certificate DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    TYPES tt_certificate_read_result TYPE TABLE FOR READ RESULT zmrg_i_certificate\\Certificate.
    TYPES tt_update_certificate TYPE TABLE FOR UPDATE zmrg_i_certificate.
    TYPES tt_create_certificate_state TYPE TABLE FOR CREATE zmrg_i_certificate\_CertificateState.
    TYPES tt_products TYPE SORTED TABLE OF matnr WITH UNIQUE KEY table_line.
    CONSTANTS:
      state_area_validate_product  TYPE string VALUE 'VALIDATE_PRODUCT'.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR Certificate RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR Certificate RESULT result.

    METHODS setInitialValues FOR DETERMINE ON MODIFY
       keys FOR Certificate~setInitialValues.
    METHODS get_instance_features FOR INSTANCE FEATURES
      keys REQUEST requested_features FOR Certificate RESULT result.

    METHODS archiveVersion FOR MODIFY
       keys FOR ACTION Certificate~archiveVersion RESULT result.

    METHODS newVersion FOR MODIFY
       keys FOR ACTION Certificate~newVersion RESULT result.

    METHODS releaseVersion FOR MODIFY
       keys FOR ACTION Certificate~releaseVersion RESULT result.
    METHODS checkProduct FOR VALIDATE ON SAVE
       keys FOR Certificate~checkProduct.

    METHODS changeCertificateVersion
      IMPORTING
        new_version               TYPE zmrg_status
        keys                      TYPE data
      EXPORTING
        update_certificates       TYPE tt_update_certificate
        create_certificate_status TYPE tt_create_certificate_state.

    METHODS filter_non_existing_products
      IMPORTING
                products                 TYPE tt_products
      RETURNING VALUE(existing_products) TYPE tt_products.

ENDCLASS.

CLASS lhc_Certificate IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD setInitialValues.
    " When a new entity is created, initialize the status and version fields
    READ ENTITIES OF zmrg_i_certificate IN LOCAL MODE
    ENTITY Certificate
        FIELDS ( CertificationStatus ) WITH CORRESPONDING #( keys )
    RESULT DATA(certificate_entities).

    DATA update_certificates TYPE TABLE FOR UPDATE zmrg_i_certificate.
    DATA create_certificate_status TYPE TABLE FOR CREATE zmrg_i_certificate\_CertificateState.

    LOOP AT certificate_entities ASSIGNING FIELD-SYMBOL(<certificate>).
      APPEND VALUE #( %tky = <certificate>-%tky
                      version = '00001'
                      certificationstatus = <certificate>-CertificationStatus ) TO update_certificates.

      APPEND VALUE #( %tky = <certificate>-%tky
                      %target = VALUE #( ( %cid = |NEW_STATE_{ sy-tabix }|
                                           status = '01'
                                           statusold = space
                                           version = '00001' ) ) ) TO create_certificate_status.
    ENDLOOP.

    MODIFY ENTITIES OF zmrg_i_certificate IN LOCAL MODE
    ENTITY Certificate
    UPDATE FIELDS ( version CertificationStatus )
        WITH update_certificates
    CREATE BY \_CertificateState
        FIELDS ( status statusold version )
        WITH create_certificate_status
    MAPPED DATA(mapped_modify)
    REPORTED DATA(reported_modify)
    FAILED DATA(failed_modify).

    reported = CORRESPONDING #( DEEP BASE ( reported ) reported_modify ).

  ENDMETHOD.

  METHOD get_instance_features.
    " Enable actions based on the current status of the certificate
    READ ENTITIES OF zmrg_i_certificate IN LOCAL MODE
    ENTITY Certificate
    FIELDS ( CertificationStatus ) WITH CORRESPONDING #( keys )
    RESULT DATA(certificate_entities).

    result = VALUE #( FOR <certificate> IN certificate_entities
                      ( %tky = <certificate>-%tky
                        %features-%action-newVersion = COND #( WHEN <certificate>-CertificationStatus EQ '02' THEN if_abap_behv=>fc-o-enabled
                                                               ELSE if_abap_behv=>fc-o-disabled )
                        %features-%action-archiveVersion = COND #( WHEN ( <certificate>-CertificationStatus EQ '02' OR
                                                                          <certificate>-CertificationStatus EQ '01' ) THEN if_abap_behv=>fc-o-enabled
                                                                   ELSE if_abap_behv=>fc-o-disabled )
                        %features-%action-releaseVersion = COND #( WHEN ( <certificate>-CertificationStatus EQ '01' OR
                                                                          <certificate>-CertificationStatus EQ '03' ) THEN if_abap_behv=>fc-o-enabled
                                                                   ELSE if_abap_behv=>fc-o-disabled  ) ) ).
  ENDMETHOD.

  METHOD archiveVersion.
    me->changecertificateversion(
  EXPORTING
    new_version               = '03'
    keys                      = keys
  IMPORTING
    update_certificates       = DATA(update_certificates)
    create_certificate_status = DATA(create_certificate_status) ).

    MODIFY ENTITIES OF zmrg_i_certificate IN LOCAL MODE
    ENTITY certificate
        UPDATE FROM update_certificates
    CREATE BY \_CertificateState FROM create_certificate_status
    FAILED failed
    REPORTED reported.

    READ ENTITIES OF zmrg_i_certificate IN LOCAL MODE
    ENTITY certificate
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(updated_certificate_entities).

    result = VALUE #( FOR <updated_entity> IN updated_certificate_entities ( %tky = <updated_entity>-%tky
                                                                             %param = <updated_entity> ) ).
  ENDMETHOD.

  METHOD newVersion.

    me->changecertificateversion(
      EXPORTING
        new_version               = '01'
        keys                      = keys
      IMPORTING
        update_certificates       = DATA(update_certificates)
        create_certificate_status = DATA(create_certificate_status) ).

    MODIFY ENTITIES OF zmrg_i_certificate IN LOCAL MODE
    ENTITY certificate
        UPDATE FROM update_certificates
    CREATE BY \_CertificateState FROM create_certificate_status
    FAILED failed
    REPORTED reported.

    READ ENTITIES OF zmrg_i_certificate IN LOCAL MODE
    ENTITY certificate
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(updated_certificate_entities).

    result = VALUE #( FOR <updated_entity> IN updated_certificate_entities ( %tky = <updated_entity>-%tky
                                                                             %param = <updated_entity> ) ).
  ENDMETHOD.

  METHOD releaseVersion.
    me->changecertificateversion(
  EXPORTING
    new_version               = '02'
    keys                      = keys
  IMPORTING
    update_certificates       = DATA(update_certificates)
    create_certificate_status = DATA(create_certificate_status) ).

    MODIFY ENTITIES OF zmrg_i_certificate IN LOCAL MODE
    ENTITY certificate
        UPDATE FROM update_certificates
    CREATE BY \_CertificateState FROM create_certificate_status
    FAILED failed
    REPORTED reported.

    READ ENTITIES OF zmrg_i_certificate IN LOCAL MODE
    ENTITY certificate
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(updated_certificate_entities).

    result = VALUE #( FOR <updated_entity> IN updated_certificate_entities ( %tky = <updated_entity>-%tky
                                                                             %param = <updated_entity> ) ).
  ENDMETHOD.

  METHOD changecertificateversion.
    READ ENTITIES OF zmrg_i_certificate IN LOCAL MODE
    ENTITY Certificate
    FIELDS ( CertificationStatus Version ) WITH CORRESPONDING #( keys )
    RESULT DATA(certificate_entities).

    LOOP AT certificate_entities ASSIGNING FIELD-SYMBOL(<certificate>).
      DATA(newVersion) =  <certificate>-Version .
      newVersion += 1.

      APPEND VALUE #( %tky = <certificate>-%tky
                      CertificationStatus = new_version
                      version = newVersion
                      %control-CertificationStatus = if_abap_behv=>mk-on
                      %control-version = if_abap_behv=>mk-on ) TO update_certificates.

      APPEND VALUE #( %tky = <certificate>-%tky
                      %target = VALUE #( ( %cid = |CERT_STATE_{ sy-tabix }|
                                           status = new_version
                                           statusOld = <certificate>-CertificationStatus
                                           version = newVersion
                                           %control-status = if_abap_behv=>mk-on
                                           %control-statusOld = if_abap_behv=>mk-on
                                           %control-version = if_abap_behv=>mk-on
                                         ) ) ) TO create_certificate_status.
    ENDLOOP.
  ENDMETHOD.

  METHOD checkProduct.
    " Entered product must exist on ZMRG_I_PRODUCTTEXT
    READ ENTITIES OF zmrg_i_certificate IN LOCAL MODE
    ENTITY certificate
    FIELDS ( Product ) WITH CORRESPONDING #( keys )
    RESULT DATA(certificate_entities).

    DATA products TYPE tt_products.
    LOOP AT certificate_entities ASSIGNING FIELD-SYMBOL(<certificate>) WHERE Product IS NOT INITIAL.
      INSERT <certificate>-Product INTO TABLE products.
    ENDLOOP.

    IF products IS NOT INITIAL.
      DATA(existing_products) = me->filter_non_existing_products( products ).
    ENDIF.

    LOOP AT certificate_entities ASSIGNING <certificate>.
      " Area invalidation
      APPEND VALUE #( %tky = <certificate>-%tky
                      %state_area = state_area_validate_product ) TO reported-certificate.

      IF <certificate>-Product IS INITIAL.
        CONTINUE. " Check on precheck
      ENDIF.

      IF NOT line_exists( existing_products[ table_line = <certificate>-Product ] ).
        APPEND VALUE #( %tky = <certificate>-%tky ) TO failed-certificate.

        APPEND VALUE #( %tky = <certificate>-%tky
                        %state_area = me->state_area_validate_product
                        %msg = NEW zcx_mrg_rap_02_messages(  textid = zcx_mrg_rap_02_messages=>product_unkown
                                                             product = <certificate>-product  )
                        %element-product = if_abap_behv=>mk-on ) TO reported-certificate.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD filter_non_existing_products.
    IF products IS NOT INITIAL.
      SELECT DISTINCT material FROM zmrg_i_producttext
          FOR ALL ENTRIES IN @products
          WHERE Material = @products-table_line
          INTO TABLE @existing_products.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
