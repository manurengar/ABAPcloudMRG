CLASS zcla_mrg_xco_samples DEFINITION
PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      "! Review of ways to access time information
      "!
      "! <strong>
      "!  Usage of class CL_ABAP_CONTEXT_INFO
      "! </strong>
      "!
      time_info_access IMPORTING out TYPE REF TO if_oo_adt_classrun_out,

      "! Check if interface is released or not for C1 contract
      "!
      interface_is_released IMPORTING out               TYPE REF TO if_oo_adt_classrun_out
                                      iv_interface_name TYPE sxco_ao_object_name,

      "! Get the ABAP stack
      "!
      get_abap_stack IMPORTING  out TYPE REF TO if_oo_adt_classrun_out,
      use_identity_class IMPORTING  out TYPE REF TO if_oo_adt_classrun_out,
      "! Example to get information about the user
      "! using classes like <strong>CL_ABAP_CONTEXT_INFO</strong>
      "!
      get_user_data IMPORTING  out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.



CLASS zcla_mrg_xco_samples IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    me->time_info_access( out ).
    me->interface_is_released(  out               = out
                                iv_interface_name = 'if_oo_adt_classrun' ).

    me->use_identity_class( out = out ).
    me->get_user_data( out ).
  ENDMETHOD.
  METHOD time_info_access.
    " System Date
    out->write( |Date in UTC { cl_abap_context_info=>get_system_date( ) DATE = USER }| ).

    " System Time
    out->write( |Date in UTC { cl_abap_context_info=>get_system_time( ) TIME = USER }| ).

    " Current user time and date (old way)
    DATA(user_timezone) = cl_abap_context_info=>get_user_time_zone( ).

    GET TIME STAMP FIELD DATA(current_timestamp).
    CONVERT TIME STAMP current_timestamp TIME ZONE user_timezone
        INTO DATE DATA(converted_user_date)
             TIME DATA(converted_user_time).

    out->write( |User Date: { converted_user_date DATE = USER } Time: { converted_user_time TIME = USER }| ).

    " Timestamps: domain TZNTSTMPL (data element TZNTSTMPL) for ABAP RAP & utclong
    DATA now TYPE tzntstmpl.
    GET TIME STAMP FIELD now.
    out->write( |Timestamp UTC TZNTSTMPL DEC(21, 7): { now  TIMESTAMP = USER }| ).

    GET TIME STAMP FIELD DATA(now_timestamp).
    out->write( |Timestamp UTC TIMESTAMP DEC(15,0): { now_timestamp  TIMESTAMP = USER }| ).

    " Getting the timestamp in one line
    DATA(now_one_line) = cl_abap_tstmp=>utclong2tstmp( utclong = utclong_current( ) ).
    out->write( |Timestamp UTC UTCLONG DEC(21,7): { now_one_line  TIMESTAMP = USER }| ).

    " Using the XCO class
    DATA(xco_system_date) = CONV d( xco_cp=>sy->date( xco_cp_time=>time_zone->user )->as( io_format =  xco_cp_time=>format->abap )->value ).
    DATA(xco_system_time) = CONV t( xco_cp=>sy->time( xco_cp_time=>time_zone->user )->as( xco_cp_time=>format->abap )->value ).
    out->write( |XCO Current Date & Time : { xco_system_date DATE = USER } { xco_system_time TIME = USER } | ).

    DATA(xco_tomorrow_date) = CONV d( xco_cp=>sy->date( xco_cp_time=>time_zone->user )->add( iv_day = 1 )->as( io_format =  xco_cp_time=>format->abap )->value ).
    DATA(xco_yesterday_date) = CONV d( xco_cp=>sy->date( xco_cp_time=>time_zone->user )->subtract( iv_day = 1 )->as( io_format =  xco_cp_time=>format->abap )->value ).

    DATA(xco_one_hour_later) = CONV t( xco_cp=>sy->time( xco_cp_time=>time_zone->user )->add( iv_hour = 1 )->as( xco_cp_time=>format->abap )->value ).
    DATA(xco_40_mins_before) = CONV t( xco_cp=>sy->time( xco_cp_time=>time_zone->user )->subtract( iv_minute = 40 )->as( xco_cp_time=>format->abap )->value ).

    out->write( |XCO Tomorrow: { xco_tomorrow_date DATE = USER }| ).
    out->write( |XCO Yesterday: { xco_yesterday_date DATE = USER }| ).
    out->write( |XCO 1h later: { xco_one_hour_later TIME = USER }| ).
    out->write( |XCO 40mins before: { xco_40_mins_before TIME = USER }| ).

    "  Small example using XCO for time processing
    DATA(moment) = xco_cp=>sy->moment( xco_cp_time=>time_zone->utc ).
    DATA(now_xco) = EXACT timestamp( moment->as( io_format =  xco_cp_time=>format->abap )->value ).
    DATA(tomorrow) = xco_cp=>sy->date( xco_cp_time=>time_zone->user )->add( iv_day = 1 ).

    DATA(tomorrow_3pm) = tomorrow->get_moment(
                           iv_hour   = '15'
                           iv_minute = '00'
                           iv_second = '00'
                         ).

    DATA(in_24_hours) = moment->add( iv_hour = '24' ).
    DATA(interval) = moment->interval_to( io_moment = tomorrow_3pm ).

    IF interval->contains( io_moment = in_24_hours ).
      out->write( |There are more than 24h until 3pm tomorrow| ).
    ELSE.
      out->write( |There are less than 24h until 3pm tomorrow| ).
    ENDIF.
  ENDMETHOD.

  METHOD interface_is_released.
    " Using the XCO library to check if interface is released


    DATA(xco_interface) = xco_cp_abap=>interface( iv_name = iv_interface_name ).
    DATA(xco_content) = xco_interface->content( ).
    DATA(xco_api_State) = xco_interface->get_api_state(  ).
    DATA(interface_is_released) = xco_api_State->get_release_state( ).
    out->write( |Contract C1: { interface_is_released->value } | ).
  ENDMETHOD.

  METHOD get_abap_stack.
    DATA(callstack) = xco_cp=>current->call_stack->full( ).
    DATA(xco_abap_stack) = callstack->as_text( io_format = xco_cp_call_stack=>format->adt( ) ).
    DATA(abap_stack) = xco_abap_stack->get_lines( )->value. " Get full list

    " Get a certain program / pattern name
    DATA(filtered_call_stack) =  callstack->to->last_occurrence_of( xco_cp_call_stack=>line_pattern->method( )->where_class_name_matches( 'Z\D{4}_CLA_DIO_.*' ) ).
    out->write( | { filtered_call_stack->as_text( xco_cp_call_stack=>format->adt( ) )->get_lines( )->join( |\n| )->value } | ).
  ENDMETHOD.

  METHOD use_identity_class.

  ENDMETHOD.

  METHOD get_user_data.
    " Get user name on current system (remember sy-uname is available)
    out->write( |Logged user: { cl_abap_context_info=>get_user_technical_name( ) }| ).
    out->write( |User alias: { cl_abap_context_info=>get_user_alias( ) }| ).
    TRY.
        out->write( |Formatted user: { cl_abap_context_info=>get_user_formatted_name( ) }| ).
      CATCH cx_abap_context_info_error.
        "handle exception
    ENDTRY.
    TRY.
        out->write( |User timezone: { cl_abap_context_info=>get_user_time_zone( ) }| ).
      CATCH cx_abap_context_info_error.
        "handle exception
    ENDTRY.
    TRY.
        out->write( |User business part. id: { cl_abap_context_info=>get_user_business_partner_id( ) }| ).
      CATCH cx_abap_context_info_error.
        "handle exception
    ENDTRY.

    " Also we can use XCO library
    out->write( |User using XCO { xco_cp=>sy->user( )->name }| ).
    " Or for another user...
    out->write( |XCO another user: {  xco_cp_system=>user( iv_name = sy-uname )->name }| ).

    " Language
    TRY.
        out->write( |User language: { cl_abap_context_info=>get_user_language_abap_format( sy-uname ) }| ).
      CATCH cx_abap_context_info_error.
        "handle exception
    ENDTRY.

    " Language using XCO
    data(language) =  xco_cp=>sy->language( ).
    out->write( |Language XCO: { language->get_name( ) }, { language->get_long_text_description( ) }, { language->value }, { language->as( io_format = xco_cp_language=>format->iso_639 ) }| ).
  ENDMETHOD.
ENDCLASS.
