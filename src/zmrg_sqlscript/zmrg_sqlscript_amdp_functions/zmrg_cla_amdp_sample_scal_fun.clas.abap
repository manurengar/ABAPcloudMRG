CLASS zmrg_cla_amdp_sample_scal_fun DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    INTERFACES if_oo_adt_classrun.

    METHODS test_amdp_table_function
      AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT
      IMPORTING VALUE(iv_langu)       TYPE zmrg_cla_amdp_sample_procedure=>t_langu
      EXPORTING VALUE(rv_country_des) TYPE zmrg_employee_natio.
  PROTECTED SECTION.
  PRIVATE SECTION.

    "To be reused on another AMDP method (procedure or function)
    METHODS get_country_text
      AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT
      IMPORTING VALUE(iv_langu)        TYPE zmrg_cla_amdp_sample_procedure=>t_langu
      RETURNING VALUE(rv_country_desc) TYPE zmrg_employee_natio.
ENDCLASS.



CLASS zmrg_cla_amdp_sample_scal_fun IMPLEMENTATION.
  METHOD get_country_text
  BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY
  USING zmrg_tab_natio.
    -- LOAD first CLASS zcl_mrg_load_nationalities
    SELECT coalesce(MAX(natdescr), '')
    INTO rv_country_desc
    FROM (
    SELECT natdescr
    FROM zmrg_tab_natio
    WHERE client = session_context( 'CDS_CLIENT' )
      AND spras = :iv_langu
    ORDER BY natkey
    limit 1
    ) as country_selected;

  ENDMETHOD.

  METHOD test_amdp_table_function
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY
  USING zmrg_cla_amdp_sample_scal_fun=>get_country_text.
    -- No matter if the method is instance, you call it like static
    -- Name on upper case always
    rv_country_des = "ZMRG_CLA_AMDP_SAMPLE_SCAL_FUN=>GET_COUNTRY_TEXT"(  :iv_langu  );

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    me->test_amdp_table_function( EXPORTING iv_langu = sy-langu
                                  IMPORTING rv_country_des = DATA(country_description) ).

    out->write( |Country: { country_description }| ).
  ENDMETHOD.

ENDCLASS.
