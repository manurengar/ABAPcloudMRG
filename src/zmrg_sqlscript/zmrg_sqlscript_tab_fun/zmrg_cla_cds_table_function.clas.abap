CLASS zmrg_cla_cds_table_function DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    INTERFACES if_oo_adt_classrun .

    CLASS-METHODS get_countries_text
        FOR TABLE FUNCTION zmrg_fun_get_countries_text.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zmrg_cla_cds_table_function IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    SELECT FROM zmrg_fun_get_countries_text( language = @sy-langu )
     FIELDS langu, natkey, natdescr
     ORDER BY natkey
     INTO TABLE @DATA(countries).

    IF countries IS INITIAL.
      out->write( 'No countries found for the current language.' ).
      RETURN.
    ENDIF.

    LOOP AT countries INTO DATA(country).
      out->write(
        |Entry #{ sy-tabix }: { country-natkey } - | &&
        |{ country-natdescr } (Language: { country-langu })|
      ).
    ENDLOOP.

  ENDMETHOD.

  METHOD get_countries_text
     BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
     OPTIONS READ-ONLY
     USING zmrg_tab_natio.

    RETURN
      select client AS client_element_name,
             spras as langu,
             natkey,
             natdescr
        FROM zmrg_tab_natio
       WHERE client = session_context('CDS_CLIENT')
         AND spras = :language;

  ENDMETHOD.

ENDCLASS.
