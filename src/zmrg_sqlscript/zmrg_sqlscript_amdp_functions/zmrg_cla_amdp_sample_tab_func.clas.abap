CLASS zmrg_cla_amdp_sample_tab_func DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    INTERFACES if_oo_adt_classrun.

    METHODS test_amdp_table_function
      AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT
      IMPORTING VALUE(iv_langu)   TYPE zmrg_cla_amdp_sample_procedure=>t_langu
      EXPORTING VALUE(rt_country) TYPE zmrg_cla_amdp_sample_procedure=>tt_natio_tab.
  PROTECTED SECTION.
  PRIVATE SECTION.

    "To be reused on another AMDP method (procedure or function)
    METHODS get_country_text
      AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT
      IMPORTING VALUE(iv_langu)   TYPE zmrg_cla_amdp_sample_procedure=>t_langu
      RETURNING VALUE(rt_country) TYPE zmrg_cla_amdp_sample_procedure=>tt_natio_tab.
ENDCLASS.



CLASS zmrg_cla_amdp_sample_tab_func IMPLEMENTATION.
  METHOD get_country_text
  BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY
  USING zmrg_tab_natio.
    -- LOAD first CLASS zcl_mrg_load_nationalities
    RETURN select *
           from zmrg_tab_natio
           where client = session_context('CDS_CLIENT')
                       and spras  = :iv_langu
                     order by natkey;
  ENDMETHOD.

  METHOD test_amdp_table_function
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY
  USING zmrg_cla_amdp_sample_tab_func=>get_country_text.
    -- No matter if the method is instance, you call it like static
    -- Name on upper case always
    rt_country = select *
                 from "ZMRG_CLA_AMDP_SAMPLE_TAB_FUNC=>GET_COUNTRY_TEXT"( iv_langu => :iv_langu );
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    me->test_amdp_table_function( EXPORTING iv_langu = sy-langu
                                  IMPORTING rt_country = DATA(tab_natio) ).

    LOOP AT tab_natio ASSIGNING FIELD-SYMBOL(<fs>).
      out->write( |Entry #{ sy-tabix }: { <fs>-natdescr }| ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
