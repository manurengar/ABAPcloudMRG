CLASS zmrg_cla_amdp_sample_procedure DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    INTERFACES if_oo_adt_classrun.

    TYPES: tt_natio_tab TYPE TABLE OF zmrg_tab_natio WITH EMPTY KEY.
    TYPES t_langu TYPE c LENGTH 1.

    METHODS get_countries
      AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT
      IMPORTING
        VALUE(iv_langu)          TYPE t_langu
      EXPORTING
        VALUE(et_nations)        TYPE tt_natio_tab
      CHANGING
        VALUE(requested_entries) TYPE i.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zmrg_cla_amdp_sample_procedure IMPLEMENTATION.
  METHOD get_countries
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING zmrg_tab_natio.
    -- Load first class zcl_mrg_load_nationalities
    if requested_entries >= 1 then
        et_nations = select *
                     from zmrg_tab_natio
                     where client = SESSION_CONTEXT('CDS_CLIENT')
                       and spras  = :iv_langu
                     order by natkey
                     limit :requested_entries;
    else
        et_nations = select *
                     from zmrg_tab_natio
                     where client = SESSION_CONTEXT('CLIENT')
                       and spras  = :iv_langu
                     order by natkey;
        requested_entries = ::ROWCOUNT;

    end if;

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    DATA(entries) = 20.
    me->get_countries( EXPORTING iv_langu = sy-langu
                       IMPORTING et_nations = DATA(nations_tab)
                       CHANGING  requested_entries = entries ).

    out->write( |Entries: { entries }| ).
    LOOP AT nations_tab ASSIGNING FIELD-SYMBOL(<fs>).
      out->write( |Entry #{ sy-tabix }: { <fs>-natdescr }| ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
