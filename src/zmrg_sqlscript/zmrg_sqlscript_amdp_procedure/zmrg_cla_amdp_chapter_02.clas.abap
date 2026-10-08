CLASS zmrg_cla_amdp_chapter_02 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    " The SQLSCRIPT reference:
    " https://help.sap.com/docs/hana-cloud-database/sap-hana-cloud-sap-hana-sqlscript-reference/create-type

    " The SQL Reference:
    " https://help.sap.com/docs/SAP_HANA_PLATFORM/4fe29514fd584807ac9f2a04f6754767/b40d483dd34d47aa9cc89b4d8a6e617e.html

    INTERFACES if_amdp_marker_hdb .
    INTERFACES if_oo_adt_classrun.

    METHODS primitive_variable_declaration
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS the_like_on_where
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS the_null_value
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS coalesce_function
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS dummy_table
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zmrg_cla_amdp_chapter_02 IMPLEMENTATION.


  METHOD the_null_value
    BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    dum_var = select null as A1, 'A' as A2 from dummy union
              select 1 as A1, 'B' as A2 from dummy union
              select 2 as A1, 'C' as A2 from dummy union
              select 3 as A1, null as A2 from dummy;

    not_null_values = select * from :dum_var
                       where A1 is not null;
  ENDMETHOD.

  METHOD the_like_on_where
   BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    dum_var = select 'Marisa' as A1, 'Garcia' as A2 from dummy union
              select 'Rosa' as A1, 'Perez' as A2 from dummy union
              select 'Martin' as A1, 'D1ego' as A2 from dummy union
              select 'Ana' as A1, 'Maga' as A2 from dummy;

    like_stat = select * from :dum_var where A1 like 'M%';
    like_regex_stat = select * from :dum_var where A1 LIKE_REGEXPR '[aA].*[aA]' flag 's';

  ENDMETHOD.

  METHOD primitive_variable_declaration
    BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.
    -- See for more info: https://help.sap.com/docs/SAP_HANA_PLATFORM/4fe29514fd584807ac9f2a04f6754767/20a1569875191014b507cf392724b7eb.html

    -- To declare primitive data types
    declare lv_text VARCHAR(50);
    declare counter INT default 1;
    declare my_date DATE default '20260115';
  ENDMETHOD.

  METHOD coalesce_function
    BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    dum_var = select coalesce( null, 1, 2 ) as A1 from dummy;
  ENDMETHOD.

  METHOD dummy_table
    BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    dum_var = select * from dummy;
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    me->the_like_on_where( ).
    me->the_null_value( ).
    me->coalesce_function( ).
    me->dummy_table( ).
  ENDMETHOD.

ENDCLASS.
