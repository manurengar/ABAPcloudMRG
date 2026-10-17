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

    METHODS case_expression
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

  METHOD case_expression
    BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
    using zmrg_basics_grouping_source.
    declare dummy_number smallint default 3;

    dummy_select = select '1' as "Col1",
                   case dummy_number        -- Expression case
                   when 3 then 'A'
                   else 'B' end as "Col2",
                   case                     -- Case with conditions
                   when MOD(( :dummy_number + 2 ), 2) = 0 then 'X1'
                   when MOD(( :dummy_number + 3 ), 2) = 0 then 'X2'
                   else 'X3' end as "Col3" from dummy;

   -- Be aware that when doing case expressions on group statements we need to repeat the whole case
   -- In this case its better to do a query apart with the case and then group by on another one
    select case
            when amount > 1500 then 'A'
            else 'B'
           end as "Col1",
           count( * )
    from zmrg_basics_grouping_source
    group by case
               when amount > 1500 then 'A'
               else 'B'
             end;
  ENDMETHOD.

  METHOD dummy_table
    BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    dum_var = select * from dummy;


  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    me->case_expression( ).
    me->the_like_on_where( ).
    me->the_null_value( ).
    me->coalesce_function( ).
    me->dummy_table( ).
  ENDMETHOD.

ENDCLASS.
