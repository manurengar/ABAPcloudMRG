CLASS lhc_Certificate DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    TYPES tt_certificate_read_result TYPE TABLE FOR READ RESULT zmrg_i_certificate\\Certificate.
    TYPES tt_update_certificate TYPE TABLE FOR UPDATE zmrg_i_certificate.
    TYPES tt_create_certificate_state TYPE TABLE FOR CREATE zmrg_i_certificate\_CertificateState.
    TYPES tt_products TYPE SORTED TABLE OF matnr WITH UNIQUE KEY table_line.
    TYPES: BEGIN OF t_material_type,
             product      TYPE matnr,
             product_type TYPE mtart,
           END OF t_material_type.
    TYPES tt_material_type TYPE TABLE OF t_material_type WITH NON-UNIQUE KEY product.
    TYPES tt_hashed_material_type TYPE HASHED TABLE OF t_material_type WITH UNIQUE KEY primary_key COMPONENTS product.

    CONSTANTS:
      state_area_validate_product TYPE string VALUE 'VALIDATE_PRODUCT',
      state_area_product_type     TYPE string VALUE 'PRODUCT_TYPE'.

  PRIVATE SECTION.
    DATA: authorization_checker TYPE REF TO zmrg_cla_auth_util.

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

    METHODS is_update_granted
      IMPORTING
                material_type     TYPE mtart OPTIONAL
      RETURNING VALUE(is_granted) TYPE abap_bool.

    METHODS is_deletion_granted
      IMPORTING
                material_type     TYPE mtart OPTIONAL
      RETURNING VALUE(is_granted) TYPE abap_bool.
ENDCLASS.

CLASS lhc_Certificate IMPLEMENTATION.

  METHOD get_instance_authorizations.
    " Check if the user is entitled to the incoming material type
    DATA: update_requested   TYPE abap_bool,
          update_granted     TYPE abap_bool,
          deletion_requested TYPE abap_bool,
          deletion_granted   TYPE abap_bool.

    me->authorization_checker = zmrg_cla_auth_util=>get_instance( xco_cp=>sy->user( )->name ).

    update_requested = COND #( WHEN requested_authorizations-%action-Edit EQ if_abap_behv=>mk-on
                                 OR requested_authorizations-%action-archiveVersion EQ if_abap_behv=>mk-on
                                 OR requested_authorizations-%action-releaseVersion EQ if_abap_behv=>mk-on
                                 OR requested_authorizations-%action-newVersion EQ if_abap_behv=>mk-on
                                 OR requested_authorizations-%update EQ if_abap_behv=>mk-on  THEN abap_true
                               ELSE abap_false ).

    deletion_requested = COND #( WHEN requested_authorizations-%delete EQ if_abap_behv=>mk-on THEN abap_true ELSE abap_false ).

    READ ENTITIES OF zmrg_i_certificate IN LOCAL MODE
    ENTITY Certificate
    FIELDS ( Product ) WITH CORRESPONDING #( keys )
    RESULT DATA(certificate_entities).

    CHECK certificate_entities IS NOT INITIAL.

    DATA products TYPE tt_products.
    LOOP AT certificate_entities ASSIGNING FIELD-SYMBOL(<certificate>) WHERE Product IS NOT INITIAL.
      INSERT <certificate>-Product INTO TABLE products.
    ENDLOOP.

    DATA products_types_db TYPE tt_material_type.
    IF products IS NOT INITIAL.
      SELECT DISTINCT matnr, mtart
      FROM zmrg_matnr_t
      FOR ALL ENTRIES IN @products
      WHERE matnr = @products-table_line
      INTO TABLE @products_types_db.

      SORT products_types_db.
      DELETE ADJACENT DUPLICATES FROM products_types_db COMPARING product.

      DATA(products_types) = CORRESPONDING tt_hashed_material_type( products_types_db ).
      CLEAR products_types_db.
    ENDIF.

    LOOP AT certificate_entities ASSIGNING <certificate>.
      DATA(material_type) = VALUE #( products_types[ KEY primary_key COMPONENTS product = <certificate>-Product ]-product_type OPTIONAL ).

      " Area invalidation
      APPEND VALUE #( %tky = <certificate>-%tky
                      %state_area = state_area_product_type ) TO reported-certificate.

      IF update_requested EQ abap_true.
        update_granted = me->is_update_granted( material_type ).
        IF update_granted EQ abap_false.
          APPEND VALUE #( %tky = <certificate>-%tky
                          %element-Product = if_abap_behv=>mk-on
                          %state_area = state_area_product_type
                          %msg = NEW zcx_mrg_rap_02_messages( textid = zcx_mrg_rap_02_messages=>update_product_typ_not_allowed
                                                              severity = if_abap_behv_message=>severity-error
                                                              producttype = material_type ) ) TO reported-certificate.
        ENDIF.
      ENDIF.

      IF deletion_requested EQ abap_true.
        deletion_granted = me->is_deletion_granted( material_type ).
        IF deletion_granted EQ abap_false.
          APPEND VALUE #( %tky = <certificate>-%tky
                %element-Product = if_abap_behv=>mk-on
                %state_area = state_area_product_type
                %msg = NEW zcx_mrg_rap_02_messages( textid = zcx_mrg_rap_02_messages=>delete_product_typ_not_allowed
                                                    severity = if_abap_behv_message=>severity-error
                                                    producttype = material_type ) ) TO reported-certificate.
        ENDIF.
      ENDIF.

      APPEND VALUE #( LET update_authorized = COND #( WHEN update_granted EQ abap_true
                                                      THEN if_abap_behv=>auth-allowed
                                                      ELSE if_abap_behv=>auth-unauthorized )
                          deletion_authorized = COND #( WHEN deletion_granted EQ abap_true
                                                        THEN if_abap_behv=>auth-allowed
                                                        ELSE if_abap_behv=>auth-unauthorized )
                      IN %tky    = <certificate>-%tky
                         %update = update_authorized
                         %delete = deletion_authorized
                         %action-Edit = update_authorized
                         %action-archiveVersion = update_authorized
                         %action-releaseVersion = update_authorized
                         %action-newVersion = update_authorized ) TO result.
    ENDLOOP.

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
        CONTINUE.
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

  METHOD is_deletion_granted.
    DATA key_values TYPE zmrg_cla_auth_util=>ty_field_value_tab.

    IF material_type IS SUPPLIED.
      key_values = VALUE #( ( auth_field = 'ACTVT'   auth_value = '03' )
                            ( auth_field = 'MTART'   auth_value = 'HAWA' ) ).
    ELSE.
      key_values = VALUE #( ( auth_field = 'ACTVT'   auth_value = '03' )
                            ( auth_field = 'DDLS'  auth_value = 'ZMRG_I_CERTIFICATE' ) ).
    ENDIF.

    is_granted = me->authorization_checker->is_authorized( auth_obj          = 'ZMRG_CER'
                                                           field_value_pairs = key_values ).
  ENDMETHOD.

  METHOD is_update_granted.
    DATA key_values TYPE zmrg_cla_auth_util=>ty_field_value_tab.

    IF material_type IS SUPPLIED.
      key_values = VALUE #( ( auth_field = 'ACTVT'   auth_value = '02' )
                            ( auth_field = 'MTART'   auth_value = 'HAWA' ) ).
    ELSE.
      key_values = VALUE #( ( auth_field = 'ACTVT'   auth_value = '02' )
                            ( auth_field = 'DDLS'  auth_value = 'ZMRG_I_CERTIFICATE' ) ).
    ENDIF.

    is_granted = me->authorization_checker->is_authorized( auth_obj          = 'ZMRG_CER'
                                                           field_value_pairs = key_values ).
  ENDMETHOD.

ENDCLASS.
