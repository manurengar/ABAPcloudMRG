CLASS zmrg_cla_amdp_chapter_03 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS get_carrier_name
      AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT
      IMPORTING VALUE(iv_carrier)      TYPE /dmo/carrier_id
      RETURNING VALUE(rv_carrier_name) TYPE /dmo/carrier_name.

    METHODS scalar_function_call
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS select_up_to_entries
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS table_type_decalaration
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS using_aggregate_functions
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS using_subqueries
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
ENDCLASS.



CLASS zmrg_cla_amdp_chapter_03 IMPLEMENTATION.
  METHOD table_type_decalaration
    BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    -- Tables types can be declared directly or inferred from select clause or other functions
    declare my_dummy_table table( col1 NVARCHAR(60), col2 INTEGER, col3 DOUBLE, col4 DATE, col5 BOOLEAN );

    -- If we declare it as constant the ideal would be to assign values to it initially
    declare my_constant_table constant table( col1 VARCHAR( 10 ), col2 SMALLINT )
     =
     select cast( 'a' as VARCHAR( 10) ) as col1, cast( 1 as SMALLINT) as col2 from dummy;

    -- Way 1 of inserting entries into a local table
    :my_dummy_table.INSERT(  ('Example', 10, 12.5, '2026-10-10', TRUE),  1 );

     -- Way 2 of inserting entries into a local table
     my_dummy_table =  SELECT 'Example' AS col1,  10 AS col2, CAST(12.5 AS DOUBLE) AS col3, DATE'2026-10-10' AS col4, TRUE AS col5
                       FROM dummy;

  ENDMETHOD.

  METHOD select_up_to_entries
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  using zmrg_i_basics_group_source1.

    limited_entries_1 = select * from zmrg_i_basics_group_source1 limit 2 offset 1;
    limited_entries_2 = select top 3 * from zmrg_i_basics_group_source1;

  ENDMETHOD.

  METHOD using_subqueries
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING zmrg_basics_grouping_source.

    dummy_table = select 1 as col1, 'A' as col2 from dummy union all
                  select 2 as col1, 'B' as col2 from dummy union all
                  select 1 as col1, 'C' as col2 from dummy union all
                  select 4 as col1, 'H' as col2 from dummy;

     dummy_result = select f.*,
                           ( select count( distinct col1 ) from :dummy_table )  as col1
                    from zmrg_basics_grouping_source as f
                    where f.KeyGroup in ( select col1 from :dummy_table );

  ENDMETHOD.

  METHOD using_aggregate_functions
    BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
    USING zmrg_basics_grouping_source.

    -- Using count( distinct ), returns all combinations where both are not null
    declare example_table table( col1 INTEGER, col2 INTEGER );

    :example_table.insert( ( null, null ), 1 );
    :example_table.insert( ( 1, null ), 2 );
    :example_table.insert( ( null, 1 ), 3 );
    :example_table.insert( ( 1, 1 ), 4 );
    :example_table.insert( ( 1, 1 ), 5 );

    example_count = select count( distinct col1, col2 ) as NumbOfDistinct,
                           count( col1 ) as Col1Count,
                           count( distinct col1 ) as Col1Distinct
                    from :example_table;

    -- Other grouping functions
    example_grouping = select KeyGroup,
                              sum( Amount ) as SumAmount,
                              avg( Amount ) as AvgAmount,
                              median( Amount ) as MedianAmount,
                              min( Amount ) as MinAmount,
                              max( Amount ) as MaxAmount,
                              -- Returns the first/last Text that belongs to the higest amount
                              first_value( Text order by Amount desc, RandomKey asc ) as FirstTextOfHighestAmount,
                              last_value( Text order by Amount desc, RandomKey asc ) as LastTextOfHighestAmount,
                              nth_value( Text, 2 order by Amount desc, RandomKey asc ) as NthTextValue,
                              string_agg( Text, ',' ) as StringAggregate,
                              Currency
                       from zmrg_basics_grouping_source
                       where KeyGroup in ( 1, 2, 4 )
                       group by KeyGroup, Currency;
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    me->using_aggregate_functions( ).
    me->using_subqueries( ).
    me->select_up_to_entries( ).
    me->table_type_decalaration( ).
    me->scalar_function_call( ).
  ENDMETHOD.


  METHOD get_carrier_name
  BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY
  USING /dmo/carrier.
    -- Example of scalar FUNCTION for FIELD list ON SELECT
    select name
    into rv_carrier_name
    from "/DMO/CARRIER"
    where client = session_context('CDS_CLIENT') and
     carrier_id = :iv_carrier;
  ENDMETHOD.

  METHOD scalar_function_call
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING zmrg_cla_amdp_chapter_03=>get_carrier_name
        zmrg_i_basics_avg_flight_price.

    dummy_select = select f.AirlineID as Airline_ID,
                          "ZMRG_CLA_AMDP_CHAPTER_03=>GET_CARRIER_NAME"( iv_carrier => f.AirlineID ) as CarrierName,
                          f.AveragePrice,
                          f.CurrencyCode
                   from "ZMRG_I_BASICS_AVG_FLIGHT_PRICE" as f;
  ENDMETHOD.

ENDCLASS.
