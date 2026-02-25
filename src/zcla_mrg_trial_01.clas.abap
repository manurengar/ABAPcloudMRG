CLASS zcla_mrg_trial_01 DEFINITION
    INHERITING FROM cl_demo_classrun
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS main REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      read_entities_example,
      read_by_assoc,
      read_multi_entity,
      create_new_record,
      create_by_assoc.
ENDCLASS.



CLASS zcla_mrg_trial_01 IMPLEMENTATION.


  METHOD main.

    me->read_entities_example( ).
    me->read_by_assoc(  ).
    me->read_multi_entity( ).
    "me->create_new_record( ).
    me->create_by_assoc( ).
*    out->next_section( 'Read Entities using association' ).
*    out->write( data = read_by_asso name = '/DMO/I_Booking_U' ).
*    out->write( data = links name = 'Links' ).
  ENDMETHOD.
  METHOD read_entities_example.
    " Method to use statement READ ENTITIES
    DATA keys TYPE TABLE FOR READ IMPORT /DMO/I_Travel_M\\travel.

    keys = VALUE #( ( travel_id = '00000011' )
                    ( travel_id = '00000015' ) ).

    READ ENTITIES OF /DMO/I_Travel_M
        ENTITY travel
        FIELDS ( travel_id
                 agency_id
                 customer_id
                 booking_fee
                 total_price
                 currency_code )
       WITH     keys
       RESULT   DATA(lt_read_result)
       FAILED   DATA(lt_failed)
       REPORTED DATA(lt_reported).
  ENDMETHOD.

  METHOD read_by_assoc.
    " Read by association entities
    DATA keys TYPE TABLE FOR READ IMPORT /DMO/I_Travel_M\\travel.

    keys = VALUE #( ( travel_id = '00000011' )
                    ( travel_id = '00000015' ) ).

    READ ENTITIES OF /DMO/I_Travel_M
        ENTITY travel BY \_Booking
        FIELDS ( booking_id
                 flight_price
                 currency_code )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_bookings).
  ENDMETHOD.

  METHOD read_multi_entity.
    " Read multiple entities at once
    DATA keys TYPE TABLE FOR READ IMPORT /DMO/I_Travel_M\\travel.

    keys = VALUE #( ( travel_id = '00000011' )
                    ( travel_id = '00000015' ) ).

    READ ENTITIES OF /DMO/I_Travel_M
        ENTITY travel
            FIELDS ( agency_id customer_id )
            WITH keys
            RESULT DATA(lt_travel_result)
        ENTITY travel BY \_Booking
            FIELDS ( booking_id flight_price )
            WITH CORRESPONDING #( keys )
            RESULT DATA(lt_booking_result)
       FAILED   DATA(ls_failed)
       REPORTED DATA(ls_reported).

  ENDMETHOD.

  METHOD create_new_record.
    " Creates new record using EML Modify
    DATA lt_create TYPE TABLE FOR CREATE /DMO/I_Travel_M.

    " We use %cid (Content ID) to identify the record in the mapped/failed structures later
    lt_create = VALUE #( (
        %cid            = 'CID_NEW_TRAVEL_1'
        agency_id       = '070001'
        customer_id     = '000001'
        begin_date      = cl_abap_context_info=>get_system_date( )
        end_date        = cl_abap_context_info=>get_system_date( ) + 10
        booking_fee     = '20.00'
        total_price     = '1000.00'
        currency_code   = 'EUR'
        description     = 'Business Trip to Berlin'
        overall_status  = 'O' " Open
    ) ).

    MODIFY ENTITIES OF /DMO/I_Travel_M
        ENTITY travel
            CREATE
                FIELDS ( agency_id
                         customer_id
                         begin_date
                         end_date
                         booking_fee
                         total_price
                         currency_code
                         description
                         overall_status )
            WITH lt_create
            MAPPED      DATA(mapped)
            FAILED      DATA(failed)
            REPORTED    DATA(reported).

    IF failed IS INITIAL.
      COMMIT ENTITIES
        RESPONSE OF /DMO/I_Travel_M
        FAILED     DATA(commit_failed)
        REPORTED   DATA(commit_reported).

      IF commit_failed IS INITIAL.
        " Success! The record is saved.
        out->write( 'Travel record created successfully.' ).
      ELSE.
        out->write( 'Failed during commit.' ).
      ENDIF.
    ELSE.
      out->write( 'Failed during modify.' ).
    ENDIF.
  ENDMETHOD.

  METHOD create_by_assoc.
    " Creation of 2 child instances and a parent one at once
    DATA lt_create          TYPE TABLE FOR CREATE /DMO/I_Travel_M.
    DATA lt_booking_cba     TYPE TABLE FOR CREATE /DMO/I_Travel_M\_Booking.

    " Populate root entity
    lt_create = VALUE #( (
        %cid            = 'CID_NEW_TRAVEL_2'
        agency_id       = '070002'
        customer_id     = '000002'
        begin_date      = cl_abap_context_info=>get_system_date( )
        end_date        = cl_abap_context_info=>get_system_date( ) + 10
        booking_fee     = '27.00'
        total_price     = '2500.00'
        currency_code   = 'EUR'
        description     = 'Business Trip to Rus'
        overall_status  = 'O'  ) ).

    " Populate child entity with data
    lt_booking_cba = VALUE #( (
        %cid_ref = 'CID_NEW_TRAVEL_2'

        "%target contains the actual child records to create
        %target  = VALUE #(
            " First Booking
            ( %cid           = 'CID_BOOKING_1'
              booking_date   = cl_abap_context_info=>get_system_date( )
              customer_id    = '000001'
              carrier_id     = 'AA'
              connection_id  = '0018'
              flight_date    = conv d( '20251024' )
              booking_status = 'N' " New
              currency_code  = 'EUR' )

            " Second Booking
            ( %cid           = 'CID_BOOKING_2'
              booking_date   = cl_abap_context_info=>get_system_date( )
              customer_id    = '000002'
              carrier_id     = 'LH'
              connection_id  = '0400'
              flight_date    = conv d( '20251026' )
              booking_status = 'N' " New
              currency_code  = 'EUR' )
        )
    ) ).

    MODIFY ENTITIES OF /dmo/i_travel_m
        ENTITY travel
        CREATE
            FIELDS     ( agency_id
                         customer_id
                         begin_date
                         end_date
                         booking_fee
                         total_price
                         currency_code
                         description
                         overall_status )
        WITH lt_create
        CREATE BY \_Booking
            FIELDS       ( booking_date
                           customer_id
                           carrier_id
                           connection_id
                           flight_date
                           booking_status
                           currency_code )
       WITH lt_booking_cba
       MAPPED   DATA(mapped)
       FAILED   DATA(failed)
       REPORTED DATA(reported).

    IF failed IS INITIAL.
      COMMIT ENTITIES
        RESPONSE OF /DMO/I_Travel_M
        FAILED     DATA(commit_failed)
        REPORTED   DATA(commit_reported).

      IF commit_failed IS INITIAL.
        out->write( 'Travel and Bookings created successfully.' ).
      ELSE.
        out->write( 'Failed during commit.' ).
      ENDIF.
    ELSE.
      out->write( 'Failed during modify.' ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
