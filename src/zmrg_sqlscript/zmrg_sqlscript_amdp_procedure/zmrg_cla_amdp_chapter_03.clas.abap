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

    METHODS calling_cds_with_parameters
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS using_window_functions
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS cross_join_example
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS inner_join_example
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS left_join_example
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS right_join_example
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS full_outer_join_example
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS lateral_join_example
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS where_clause_some_any_all
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS where_clause_in
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS where_clause_exists
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS where_clause_case
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS where_clause_fuzzy_search
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS with_clause
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS grouping_sets
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS intersect_execpt_union
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS using_map_merge
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS using_map_reduce
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    " Example for map-merge / map-reduce
    METHODS get_days_between_udf
      AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT
      IMPORTING VALUE(str_key)           TYPE string
                VALUE(start_date)        TYPE d
                VALUE(end_date)          TYPE d
      RETURNING VALUE(computed_days_tab) TYPE tt_map_merge_sample.

    METHODS reduce_days_udf
      AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT
      IMPORTING VALUE(iv_key)           TYPE string
                VALUE(it_grouped_rows)  TYPE tt_grouped_days
      RETURNING VALUE(reduced_days_tab) TYPE tt_map_merge_sample.
ENDCLASS.



CLASS zmrg_cla_amdp_chapter_03 IMPLEMENTATION.

  METHOD intersect_execpt_union
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING zmrg_basics_grouping_source
        zmrg_basics_currency_texts.

    -- Intersect is equivalent to a inner join
    -- We need same number of columns for it to work, as with unions
    dummy_select
    =
    select Currency
    from zmrg_basics_grouping_source
    intersect
    select Currency
    from ZMRG_BASICS_CURRENCY_TEXTS;

    -- The equivalent would be
    dummy_select_1
    =
    select distinct f.Currency
    from zmrg_basics_grouping_source as f
    inner join ZMRG_BASICS_CURRENCY_TEXTS as e
    on f.currency = e.currency;


    -- Except is to subtract one set from the other
    -- It is equivalent to use where not exists ( <subquery> )

    dummy_select_2
    =
    select Currency
    from zmrg_basics_grouping_source
    except
    select Currency
    from ZMRG_BASICS_CURRENCY_TEXTS;

    -- This is equivalent to
    dummy_select_3
    =
    select distinct f.currency
    from zmrg_basics_grouping_source as f
    where not exists ( select e.currency
                       from ZMRG_BASICS_CURRENCY_TEXTS as e
                       where e.currency = f.currency );
  ENDMETHOD.

  METHOD get_days_between_udf
  BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY.

    RETURN select str_key as my_key, days_between( to_date( nullif( :start_date, '00000000' ), 'YYYYMMDD' ),
                                                   to_date( nullif( :end_date, '00000000' ), 'YYYYMMDD' ) ) as days_diff
           from dummy;

  ENDMETHOD.


  METHOD reduce_days_udf
    BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY.

    RETURN select :iv_key as my_key,
                  sum( days_diff ) as days_diff
           from :it_grouped_rows;

  ENDMETHOD.

  METHOD using_map_reduce
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING zmrg_cla_amdp_chapter_03=>get_days_between_udf
        zmrg_cla_amdp_chapter_03=>reduce_days_udf.

    -- map_reduce applies a map_merge to a table, then the result is UNION ALL, after that
    -- another function applies over this temporal table ( the reduce function ) and eventually, the final result
    -- is again UNION ALL
    -- SEE: https://help.sap.com/docs/hana-cloud-database/sap-hana-cloud-sap-hana-sqlscript-reference/map-reduce-operator?q=map_reduce

    declare my_dummy_tab table (  my_key varchar(50), start_date nvarchar( 8 ), end_date nvarchar( 8 ) );

    :my_dummy_tab.insert( ( 'A1', '20260101', '20260111' ), 1 );
    :my_dummy_tab.insert( ( 'A1', '20260101', '20260106' ), 2 );
    :my_dummy_tab.insert( ( 'B1', '20260101', '20260121' ), 3 );
    :my_dummy_tab.insert( ( 'B1', '20260101', '20260103' ), 4 );

    dummy_select
    =
    map_reduce( :my_dummy_tab,
                "ZMRG_CLA_AMDP_CHAPTER_03=>GET_DAYS_BETWEEN_UDF"( :my_dummy_tab.my_key,
                                                                  :my_dummy_tab.start_date,
                                                                  :my_dummy_tab.end_date )
                group by my_key as mapped_group,
                "ZMRG_CLA_AMDP_CHAPTER_03=>REDUCE_DAYS_UDF"( mapped_group.my_key,
                                                             mapped_group ) );


  ENDMETHOD.

  METHOD using_map_merge
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING zmrg_cla_amdp_chapter_03=>get_days_between_udf.

    -- map_merge applies a function to each row of a table and returns a table for each row, which is
    -- union with each result
    declare my_dummy_tab table ( my_key varchar(50), start_date nvarchar( 8 ), end_date nvarchar( 8 ) );

    :my_dummy_tab.insert( ( 'A1', '20260101', '20260616' ), 1 );
    :my_dummy_tab.insert( ( 'A1', '20260101', '20260825' ), 2 );
    :my_dummy_tab.insert( ( 'A1', '20260101', '20260320' ), 3 );
    :my_dummy_tab.insert( ( 'A1', '20260101', '20260102' ), 4 );
    :my_dummy_tab.insert( ( 'A1', '20260101', '20260113' ), 5 );
    :my_dummy_tab.insert( ( 'A1', '20260101', '20260311' ), 6 );

    dummy_select
    =
    map_merge( :my_dummy_tab, "ZMRG_CLA_AMDP_CHAPTER_03=>GET_DAYS_BETWEEN_UDF"( :my_dummy_tab.my_key,
                                                                                :my_dummy_tab.start_date,
                                                                                :my_dummy_tab.end_date  ) );


  ENDMETHOD.

  METHOD grouping_sets
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING zmrg_basics_grouping_source.

    -- Grouping sets allow for the combination of 2 different groupings in just 1 query
    -- The equivalet is doing 2 separate normal groupings and doing UNION ALL on both, where the columns of one grouping
    -- that do not exists on the other are filled with NULL values

    dummy_query
    =
    select KeyGroup, sum(Amount) as TotalAmount, Currency
    from zmrg_basics_grouping_source
    group by grouping sets ( ( KeyGroup ), ( KeyGroup, Currency ) )
    order by Currency desc nulls first;
  ENDMETHOD.

  METHOD with_clause
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING zmrg_basics_grouping_source.

    -- With clause allow you to store a subquery for only one select statement
    -- Same as doing subqueries and storing on table variables
    -- However they table variables are better

    dummy_query
    =
    with my_dummy_select_query as ( select * from zmrg_basics_grouping_source )
    select *
    from my_dummy_select_query
    where Text = 'NIG';
  ENDMETHOD.

  METHOD where_clause_fuzzy_search
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    -- Fuzzy search can be done with contains - see section 3.2.5
    declare dummy_param nvarchar( 15 ) = 'raed OR graen';

    declare my_dummy_tab table( color varchar( 15 ), number INTEGER );

    :my_dummy_tab.insert( ( 'red',    1000 ), 1 );
    :my_dummy_tab.insert( ( 'blue',   2000 ), 2 );
    :my_dummy_tab.insert( ( 'green',  3000 ), 3 );
    :my_dummy_tab.insert( ( 'purple', 4000 ), 4 );
    :my_dummy_tab.insert( ( 'cyan',   5000 ), 5 );
    :my_dummy_tab.insert( ( 'magenta',6000 ), 6 );

    dummy_select
    =
    select *
    from :my_dummy_tab
    where contains( ( color ), :dummy_param, FUZZY( 0.7 ) );
  ENDMETHOD.


  METHOD where_clause_case
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    -- Case expression can be used on the where clasue
    declare dummy_param nvarchar( 15 ) = '';

    declare my_dummy_tab table( color varchar( 15 ), number INTEGER );

    :my_dummy_tab.insert( ( 'red',    1000 ), 1 );
    :my_dummy_tab.insert( ( 'blue',   2000 ), 2 );
    :my_dummy_tab.insert( ( 'green',  3000 ), 3 );
    :my_dummy_tab.insert( ( 'purple', 4000 ), 4 );
    :my_dummy_tab.insert( ( 'cyan',   5000 ), 5 );
    :my_dummy_tab.insert( ( 'magenta',6000 ), 6 );

    dummy_select
    =
    select *
    from :my_dummy_tab
    where color LIKE_REGEXPR
    case
    when :dummy_param = '' then '.*'
    else :dummy_param end flag 's';
  ENDMETHOD.

  METHOD where_clause_exists
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING zmrg_basics_grouping_source
        zmrg_basics_currency_texts.

    -- Similar to the IN operator. Allow you to know if the subquery returns at least one entry
    -- Diference resides in that EXISTS checks all row existence, IN checks one column of a table

    dummy_select
    =
    select *
    from zmrg_basics_grouping_source as f
    where exists ( select currency
                   from zmrg_basics_currency_texts
                   where currency = f.currency );

    dummy_select_2
    =
    select *
    from zmrg_basics_grouping_source as f
    where not exists ( select currency
                       from zmrg_basics_currency_texts
                       where currency = f.currency );

  ENDMETHOD.


  METHOD where_clause_in
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    -- IN can be used to check if values belong to a dataset

    declare my_dummy_tab table( color varchar( 15 ), number INTEGER );

    :my_dummy_tab.insert( ( 'red',    1000 ), 1 );
    :my_dummy_tab.insert( ( 'blue',   2000 ), 2 );
    :my_dummy_tab.insert( ( 'green',  3000 ), 3 );
    :my_dummy_tab.insert( ( 'purple', 4000 ), 4 );
    :my_dummy_tab.insert( ( 'cyan',   5000 ), 5 );
    :my_dummy_tab.insert( ( 'magenta',6000 ), 6 );

    dummy_select
    =
    select *
    from :my_dummy_tab
    where color in ( 'red', 'blue', 'yellow');

    dummy_select_1
    =
    select *
    from :my_dummy_tab
    where color not in ( 'red', 'blue', 'green');

  ENDMETHOD.

  METHOD where_clause_some_any_all
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    -- SOME and ANY are synonims. They mean that the comparison is set to true if at least one of the conditions are
    -- met

    declare my_dummy_tab table( color varchar( 15 ), number INTEGER );

    :my_dummy_tab.insert( ( 'red',    1000 ), 1 );
    :my_dummy_tab.insert( ( 'blue',   2000 ), 2 );
    :my_dummy_tab.insert( ( 'green',  3000 ), 3 );
    :my_dummy_tab.insert( ( 'purple', 4000 ), 4 );
    :my_dummy_tab.insert( ( 'cyan',   5000 ), 5 );
    :my_dummy_tab.insert( ( 'magenta',6000 ), 6 );

    dummy_select
    =
    select *
    from :my_dummy_tab
    where color = any ( 'cyan', 'red', 'green' );

    -- All in the other hand will take only entries which met the condition for all the results of the subquery
    -- Often used with <> ( not equal )
    dummy_select_1
    =
    select *
    from :my_dummy_tab
    where color <> all ( 'cyan', 'red', 'green' );

  ENDMETHOD.

  METHOD select_up_to_entries
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING zmrg_i_basics_group_source1.

    limited_entries_1 = select * from zmrg_i_basics_group_source1 limit 2 offset 1;
    limited_entries_2 = select top 3 * from zmrg_i_basics_group_source1;

  ENDMETHOD.



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

  METHOD calling_cds_with_parameters
    BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
    using ZMRG_BASICS_LIKE_PARAMETER
          zmrg_basics_grouping_source.

    declare input_text varchar( 3 );

    -- CDS with parameters
    dummy_select = select *
                   from "ZMRG_BASICS_LIKE_PARAMETER"( p_text => 'NIG' );

    -- Calling an anonymous function block on the from clause
    input_text = :dummy_select.KeyGroup[1];

    anonymous_function_block =

    select f.RandomKey,
           f.KeyGroup,
           f.Text
           from SQL FUNCTION ( in iv_group INTEGER => :input_text )
                    returns table ( RandomKey VARCHAR( 10 ), KeyGroup INTEGER, Text VARCHAR( 3 ) )
                begin
                    return select RandomKey, KeyGroup, Text
                           from "ZMRG_BASICS_GROUPING_SOURCE"
                           where KeyGroup = :iv_group;
                end as f;
  ENDMETHOD.

  METHOD inner_join_example
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING zmrg_i_basics_group_source1.

    -- The inner join include the lines that match on both tables
    -- specified on the ON condition

    declare dummy_table table ( curr varchar( 3 ), curr_text nvarchar( 50 ) );

    :dummy_table.insert( ( 'EUR', 'Euro' ), 1 );
    :dummy_table.insert( ( 'USD', 'Dollar' ), 2 );

    -- Be aware not to mix two columns with the same column
    inner_join_1 =
    select *
    from zmrg_i_basics_group_source1 as t
    inner join :dummy_table as c
    on t.currency = c.curr;

    -- Another way would be to do it like this
    inner_join_2 =
    select t.*, c.curr_text
    from zmrg_i_basics_group_source1 as t
    join :dummy_table as c
    on t.currency = c.curr;
  ENDMETHOD.



  METHOD cross_join_example
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING zmrg_i_basics_group_source1.
    -- Cross joins give us the cartesian product of a table
    -- There are 2 ways of defining a cross join

    cross_join_1  =
    select *
    from zmrg_i_basics_group_source1
    cross join ( select 'A' as col1, 1 as col2 from dummy );

    cross_join_2 =
    select *
    from zmrg_i_basics_group_source1,
    ( select 'A' as col1, 1 as col2 from dummy );
  ENDMETHOD.

  METHOD left_join_example
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING zmrg_basics_grouping_source.

    declare dummy_table table ( curr varchar( 3 ), curr_text nvarchar( 50 ) );

    :dummy_table.insert( ( 'EUR', 'Euro' ), 1 );
    :dummy_table.insert( ( 'USD', 'Dollar' ), 2 );
   -- Left outer join always returns all the entries of left table
   -- and in the case the condition match for more than 1 entry on the right
   -- table, the left entries are duplicated acordingly

   dummy_select =
   select f.*, c.curr_text
   from zmrg_basics_grouping_source as f
   left outer join :dummy_table as c
   on f.currency = c.curr;

  ENDMETHOD.

  METHOD right_join_example
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING zmrg_basics_grouping_source.

    declare dummy_table table ( curr varchar( 3 ), curr_text nvarchar( 50 ) );

    :dummy_table.insert( ( 'EUR', 'Euro' ), 1 );
    :dummy_table.insert( ( 'SOL', 'Sol' ), 2 );
   -- Left outer join always returns all the entries of left table
   -- and in the case the condition match for more than 1 entry on the right
   -- table, the left entries are duplicated acordingly

   dummy_select =
   select f.*, c.curr_text
   from zmrg_basics_grouping_source as f
   right outer join :dummy_table as c
   on f.currency = c.curr;

  ENDMETHOD.

  METHOD full_outer_join_example
    BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
    USING zmrg_basics_grouping_source.

    declare dummy_table table ( curr varchar( 3 ), curr_text nvarchar( 50 ) );

    :dummy_table.insert( ( 'EUR', 'Euro' ), 1 );
    :dummy_table.insert( ( 'SOL', 'Sol' ), 2 );

   -- Full outer join is like a right and left outer joins combined. When the condition met, the right or left line
   -- is repeated by the number of occurrences on the ON condition. Otherwise if no condition is met, lines are shown
   -- with null values

   dummy_select =
   select f.*, c.curr_text
   from zmrg_basics_grouping_source as f
   full outer join :dummy_table as c
   on f.currency = c.curr;

  ENDMETHOD.

  METHOD lateral_join_example
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING /dmo/flight
        /dmo/carrier.

    -- IS DUMPING SOMEHOW

    -- Lateral joins use the keyword LATERAL over the already known joins. They use a subquery or function for each row
    -- of the left table. I have seen them combined with CROSS JOINS and LEFT OUTER JOINS

    -- In this case, if no currency is found on the subquery, the left table line wont show up

     dummy_select =
       select f.carrier_id, f.connection_id, f.flight_date, c.name as CarrierName
       from "/DMO/FLIGHT" as f
       cross join lateral ( select ct.name
                            from "/DMO/CARRIER" as ct
                            where ct.client     = f.client
                              and ct.carrier_id = f.carrier_id ) as c;


     -- If we want it to show up we need to do a left outer join. However here we need to specify a condition that
     -- always evaluate to true so we use 1 = 1.
     dummy_select_2 =
       select f.carrier_id, f.connection_id, f.flight_date, c.name as CarrierName
       from "/DMO/FLIGHT" as f
       left outer join lateral ( select ct.name
                                 from "/DMO/CARRIER" as ct
                                 where ct.client     = f.client
                                   and ct.carrier_id = f.carrier_id ) as c
       on 1 = 1;

  ENDMETHOD.

  METHOD using_window_functions
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  USING zmrg_basics_grouping_source.
    -- See Section 3.2.2 ( last one )
    declare lag_lead_table table( class VARCHAR( 1 ), val INTEGER, offset INTEGER );

    -- Window functions perform aggregations but keeping the rows of the table without being aggregated
    window_example_1 = select RandomKey,
                              KeyGroup,
                              Amount,
                              sum( Amount ) over ( partition by KeyGroup, Currency ) as AmountWindow,
                              Currency,
                              Text from zmrg_basics_grouping_source order by KeyGroup, Currency;

    -- When we provide a sort ( order by ), then only the records that precede the current in the sorting
    -- plus the current record are considered
    window_example_2 = select RandomKey,
                              KeyGroup,
                              Amount,
                              sum( Amount ) over ( partition by KeyGroup, Currency order by Amount ) as AmountWindow,
                              Currency,
                              Text from zmrg_basics_grouping_source order by KeyGroup, Currency;

    -- With the ROWS statement we can modify the range of records to be considered when doing an Order By
    -- For example, consider all preceding ( not current one )
    window_example_3 = select RandomKey,
                              KeyGroup,
                              Amount,
                              sum(  Amount ) over ( partition by KeyGroup, Currency
                                                   order by Amount
                                                   rows between UNBOUNDED PRECEDING and 1 preceding ) as AmountWindow,
                              Currency,
                              Text from zmrg_basics_grouping_source order by KeyGroup, Currency;

    -- Also we can use ROWS BETWEEN to just consider one value after and before our current value
    window_example_4 = select RandomKey,
                              KeyGroup,
                              Amount,
                              sum( Amount ) over ( partition by KeyGroup, Currency
                                                   order by Amount
                                                   rows between 1 preceding and 1 FOLLOWING ) as AmountWindow,
                              Currency,
                              Text from zmrg_basics_grouping_source order by KeyGroup, Currency;

    -- Apart from SUM, AVG, MIN, MAX, COUNT, FIRST_VALUE, NTH_VALUE and LAST_VALUE
    -- We also have LEAD and LAG

    -- LEAD: lead( val, offset, default_value ) --> Returns the NEXT value on offset ( default = 1 ), if offset is out of
    -- bounds then return default_value ( if not set, then null )

    -- LAG: lag val, offset, default_value ) --> Returns the PREVIOUS value on offset ( default = 1 ), if offset is out of
    -- bounds then return default_value ( if not set, then null )
    :lag_lead_table.insert( ( 'A', 1, 1  ), 1);
    :lag_lead_table.INSERT( ( 'A',  3,    3 ), 2 );
    :lag_lead_table.INSERT( ( 'A',  5, NULL ), 3 );
    :lag_lead_table.INSERT( ( 'A',  5,    2 ), 4 );
    :lag_lead_table.INSERT( ( 'A', 10,    0 ), 5 );
    :lag_lead_table.INSERT( ( 'B',  1,    3 ), 6 );
    :lag_lead_table.INSERT( ( 'B',  1,    1 ), 7 );
    :lag_lead_table.INSERT( ( 'B',  7,    1 ), 8 );

    example_lag_lead = select class,
                            val,
                            offset,
                            lead( val ) over ( partition by class order by val ) as lead,
                            lead( val, offset, -val ) over ( partition by class order by val ) as lead2,
                            lag( val ) over ( partition by class order by val ) as lag,
                            lag( val, offset, -val) over ( partition by class order by val ) as lag2
                     FROM :lag_lead_table
                     ORDER BY class, val;
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
    me->using_map_reduce( ).
    me->using_map_merge( ).
    me->intersect_execpt_union( ).
    me->grouping_sets( ).
    me->with_clause( ).
    me->where_clause_fuzzy_search( ).
    me->where_clause_case( ).
    me->where_clause_exists( ).
    me->where_clause_in( ).
    me->where_clause_some_any_all( ).
    "me->lateral_join_example( ).
    me->full_outer_join_example( ).
    me->right_join_example( ).
    me->left_join_example( ).
    me->inner_join_example( ).
    me->cross_join_example( ).
    me->calling_cds_with_parameters( ).
    me->using_window_functions( ).
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
    -- Used ON METHOD scalar_function_call
    SELECT name
    INTO rv_carrier_name
    FROM "/DMO/CARRIER"
    where CLIENT = session_context('CDS_CLIENT') and
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
