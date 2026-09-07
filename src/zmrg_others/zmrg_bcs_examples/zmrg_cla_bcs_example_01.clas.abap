CLASS zmrg_cla_bcs_example_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS send_text_email
      IMPORTING
        out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.



CLASS zmrg_cla_bcs_example_01 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    me->send_text_email( out ).
  ENDMETHOD.

  METHOD send_text_email.
    DATA email_content TYPE string.
    TRY.
        DATA(mail) = cl_bcs_mail_message=>create_instance( ).

        mail->set_sender( 'manuelrus15@gmail.com' ).
        mail->add_recipient( iv_address = 'manu69rus@gmail.com'
                             iv_copy    = cl_bcs_mail_message=>to  ).
        mail->add_recipient( iv_address = 'manuelrentero25@gmail.com'
                             iv_copy    = cl_bcs_mail_message=>cc  ).
        mail->add_recipient( iv_address = 'renterogarciamanuel@gmail.com'
                             iv_copy    = cl_bcs_mail_message=>bcc  ).

        mail->set_subject( 'Test new API - SAMPLE TEXT' ).
        email_content = |This is a normal text generated on { cl_abap_context_info=>get_system_date( ) DATE = USER }|.

        mail->set_main( cl_bcs_mail_textpart=>create_instance( iv_content = email_content
                                                               iv_content_type = `text/plain` ) ).
        mail->send( IMPORTING
                     et_status      = DATA(status)
                     ev_mail_status = DATA(mail_status) ).

        out->write( 'Test: Sent email plain text' ).
        out->write( status ).
        out->write( mail_status ).

      CATCH cx_bcs_mail INTO DATA(exception).
        out->write( exception->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
