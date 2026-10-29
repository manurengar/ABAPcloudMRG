CLASS zmrg_cla_amdp_chapter_04 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    "DATA TYPES DOCU
    " https://help.sap.com/docs/SAP_ASE/cbed2190ee2d4486b0bbe0e75bf4b636/120d06d76d6642fb8824b791a94d2a04.html

    " STRING PROCESSING
    METHODS string_functions_basic
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS string_conversion
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS string_functions_regexp
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS string_functions_trim_pad
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS string_functions_similarity
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS string_functions_unicode_conv
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    METHODS split_sqlscript_string_lib
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS format_sqlscript_string_lib
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS summary_sqlscript_string_lib
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    " DATE & TIME
    METHODS possible_date_formats
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS possible_time_formats
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS date_time_conversion
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS timestamp_formats
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS now_and_today_functions
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS add_functions
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS between_functions
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
ENDCLASS.



CLASS zmrg_cla_amdp_chapter_04 IMPLEMENTATION.

  METHOD between_functions BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.
    dummy_select
    =
    select
    -- Exact 100ns difference (last digit .0000001 vs .0000005 -> returns 4)
      nano100_between( to_timestamp( '2026-10-29 12:00:00.0000001' ),
                       to_timestamp( '2026-10-29 12:00:00.0000005' ) ) as diff_400ns,

    -- 1 full second difference -> returns 10,000,000
      nano100_between( to_timestamp( '2026-10-29 12:00:00.0000000' ),
                       to_timestamp( '2026-10-29 12:00:01.0000000' ) ) as diff_1_sec,

      seconds_between( '2026-10-29 12:00:00', '2026-10-29 12:01:00' ) as diff_seconds,
      days_between( '2026-10-01', '2026-10-29' )                      as diff_days,
      months_between( '2026-01-01', '2026-10-01' )                    as diff_months,
      years_between( '2021-01-01', '2026-01-01' )                     as diff_years
      from dummy;
  ENDMETHOD.

  METHOD add_functions BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.

    -- Where <date> appears, all data types that contain a date are allowed
    -- Where <time> appears, all data types that contain a time are allowed

    -- add_months( <date>, <months> )
    dummy_select1
    =
    select
    add_months( '2025/01/31', 1 ) as addMonth1,
    add_months( '2025/02/27', 1 ) as addMonth2,
    add_months_last( '2025/02/28', 1 ) as addMonthLast1  -- Round to last day if your day is last day of curr the month
    from dummy;

    -- add_workdays(  ) We can calculate using calendars ( factory ) from SCAL

    -- last_day( <date> ) is last day of a month
    -- next_day( <date> ), add_days( <date>, days ) Adds 1 day or any number of days
    dummy_select2
    =
    select
    next_day( '2026/10/29' ) as nxtday,
    add_days( '2026/10/29', -1 ) as prevDay,
    last_day( '2026-10-08' ) as lastDay
    from dummy;

    -- add_seconds( <time>, seconds ) & add_years( <date>, years )

    dummy_select3
    =
    select
    add_seconds( '17:59:59', '121' ) as scndsAdded,
    add_years( '20210101', 5 ) as yearsAdded
    from dummy;
  ENDMETHOD.

  METHOD now_and_today_functions BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.

    -- There some variables to get time information
    dummy_select
    =
    select current_date,         -- local system date
           current_time,         -- local system time
           current_timestamp,    -- local system timestamp
           now( ) as now_timstamp, -- Same as current_timestamp
           current_utcdate,      -- Date on UTC
           current_utctime,      -- Time on UTC
           current_utctimestamp,  -- Timestamp UTC
           to_seconddate( current_utctimestamp ) as seconddate_tim
    from dummy;


  ENDMETHOD.

  METHOD timestamp_formats BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.
    -- There are 2 types for timestamps

    -- SECONDDATE: YYYY-MM-DD HH24:MI:SS
    -- TIMESTAMP:  YYYY-MM-DD HH24:MI:SS.F7

    dummy_select
    =
    select to_seconddate( '2026-10-29 14:30:59', 'YYYY-MM-DD HH24:MI:SS' ) as second_date_val,
           to_timestamp( '2026-10-29 14:30:59.1234567', 'YYYY-MM-DD HH24:MI:SS.FF7' ) as timestamp_val,
           to_seconddate( current_timestamp ) as curr_seconddate,
           current_timestamp as curr_timestamp
    from dummy;

  ENDMETHOD.

  METHOD date_time_conversion BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.

    -- We can convert from ABAP DATS into DATE using to_date
    -- and viceversa using to_dats

    dummy_select
    =
    select to_date( '20050101' ) as conv_to_date,
    to_dats( to_date( '2005/01/01' ) ) as conv_to_dats
    from dummy;

    -- For converting between string and time information on SQLSCRIPT
    -- we use to_time( <value>, <format> )

    dummy_select1
    =
    select to_time( '9:9:9AM' ) as conv_to_time
    from dummy;

  ENDMETHOD.

  METHOD possible_time_formats BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.

    declare dummy_tab table ( t time );

    -- The extended format HH24/12:MI:SS[AM|PM]
    -- HH from 0 to 23
    -- MI from 0 to 59
    -- SS from 0 to 59

    insert into :dummy_tab values ( '23:59:59' );
    insert into :dummy_tab values ( to_time( '09:01:01 PM', 'HH12:MI:SS PM' ) );
    insert into :dummy_tab values ( to_time( '05:01', 'HH24:MI' ) );
    insert into :dummy_tab values ( '09:09:09 AM' );

    dummy_select
    =
    select *
    from :dummy_tab;
  ENDMETHOD.


  METHOD possible_date_formats BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.

    -- The possible ways to instance a date type are

    declare dummy_tab table ( d date );
    declare date_dummy_tab table ( line int, date_val date );

    -- YYYY-MM-DD
    insert into :dummy_tab values ( '1957-06-13' );

    -- YYYY/MM/DD , YYYY/MM-DD, YYYY-MM/DD
    insert into :dummy_tab values ( '1957/06-13' );
    insert into :dummy_tab values ( '1957-06/13' );
    insert into :dummy_tab values ( '1957/06/13' );

    -- YYYYMMDD ABAP
    insert into :dummy_tab values ( '19570613' );

    -- YYYY-MON-DD -> Short named month
    insert into :dummy_tab values ( to_date('1957-JUN-13',
                                            'YYYY-MON-DD' ) );

    -- Long named month
    insert into :dummy_tab values ( to_date('1957-June-13',
                                            'YYYY-MONTH-DD' ) );

    insert into :dummy_tab values ( to_date('1957-JULY-13',
                                            'YYYY-MONTH-DD' ) );

    insert into :dummy_tab values ( to_date('January-13',
                                            'MONTH-DD' ) );

    -- Roman numerical months
    insert into :dummy_tab values ( to_date('1957-IV-13',
                                            'YYYY-RM-DD' ) );

    -- Custom formats
    insert into :dummy_tab values ( to_date('1750=05=01',
                                            'YYYY=MM=DD' ) );


    -- Calendar week & Quarter (extracting from a DATE into string)
    dummy_week_quarter
    =
    select to_nvarchar( to_date('20261028', 'YYYYMMDD'), 'WW' ) as calendar_week,
           to_nvarchar( to_date('20261028', 'YYYYMMDD'), 'Q' )  as quarter
    from dummy;


    dummy_select1
    =
    select *
    from :dummy_tab;

    -- The lowest date corresponds to 01.01.0001 which can be represented as 00.00.0000
    -- on string format it is displayed as 31.12.-1

    insert into :date_dummy_tab values ( 1, '' );
    insert into :date_dummy_tab values ( 2, '0' );
    insert into :date_dummy_tab values ( 3, '0000-00-00' );
    insert into :date_dummy_tab values ( 4, '00000000' );
    insert into :date_dummy_tab values ( 5, '0001-01-01' );

    dummy_select
    =
    select line, date_val,
           to_nvarchar( date_val ) as as_char,
           days_between( date_val, '0001-01-10' ) as delta
    from :date_dummy_tab;
  ENDMETHOD.


  METHOD summary_sqlscript_string_lib BY DATABASE PROCEDURE
    FOR HDB LANGUAGE SQLSCRIPT.
    /*
    -- The function table_summary returns a CSV string and for each row, it is break using UNIX line feed
    using "PUBLIC"."SQLSCRIPT_STRING" as lib;
    declare lv_string nvarchar( 5000 );

    dummy_select
    =
    select * from pa0000 limit 30;

    lv_string = lib:table_summary( :dummy_select, 10 );
    */

    select * from dummy;
  endmethod.

  METHOD format_sqlscript_string_lib BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.
    /*
    -- Formatting functions follows python string formatting rules
    -- **This function cannot be used on the field declaration of a select clause
    using "PUBLIC"."SQLSCRIPT_STRING" as lib;

    declare formatted_string nvarchar( 50 );
    declare formatted_table table ( result nvarchar( 5000 ) );
    declare arr nvarchar( 200 ) array;


   tt = select 'Sutherland' as lname, 'Jhon'   as fname, to_double( 29.8 ) as age from dummy
     union all
     select 'Stark'      as lname, 'Edward' as fname, to_double( 46.1 ) as age from dummy;

    formatted_string = lib:format( '{1}, {0} is {2:.2f} years old', 'Miller', 'Peter', 21.3 );

    -- However this function FORMAT_TO_TABLE can be used instead to save results on a table
    -- This table contains just a column named 'result'
    formatted_table = lib:format_to_table( 'Complete name: {fname}, {lname}. AGE: {age:.2f}', :tt );

    -- Also there is a variant for creating arrays
    arr = lib:format_to_array( 'Complete name: {fname}, {lname}. AGE: {age}', :tt );
    */

    select * from dummy;
  endmethod.

  METHOD split_sqlscript_string_lib BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.
    /*
    using "PUBLIC"."SQLSCRIPT_STRING" as "LIB";

    -- SPLITTING: SPLIT and SPLIT_REGEXPR
    -- If the number of sections in  the tuple is too much or too few, it dumps
    DECLARE a1 nvarchar( 20 );
    DECLARE a2 nvarchar( 20 );
    DECLARE a3 nvarchar( 20 );

    DECLARE arr nvarchar( 20 ) ARRAY;


    ( a1, a2, a3 ) = "LIB":SPLIT( 'ABC-DEF-GHI', '-' );

    dummy_select
    =
    select a1, a2, a3 from dummy;

    ( a1, a2, a3 ) = "LIB":SPLIT( 'ABC-DEF-GHI-JKF-LMN', '-', 2 ); -- Limited to 3 so it also works fine

    dummy_select
    =
    select a1, a2, a3 from dummy;

    -- When using the SPLIT_REGEXPR the regexp expression is used as separator and thus removed from the decomposition

    ( a1, a2 ) = "LIB":SPLIT_REGEXPR( 'ABC-DEF', '\w-\w' );

    dummy_select1
    =
    select a1, a2 from dummy;


    -- If instead of decomposing, we want to create a table, with a row for each regexp occurrence or delimitator found,
    -- we can use SPLIT( _REGEXPR )_TO_TABLE

    dummy_select2
    =
    select *
    from "LIB":SPLIT_TO_TABLE( 'ABC-DEF-GHI-JKL-MNO', '-' );

    -- or just using regexpr

    dummy_select3
    =
    select *
    from "LIB":SPLIT_REGEXPR_TO_TABLE( 'ABC-DEF-GHI-JKL-MNO', '\w-\w' );


    -- Also we can apply the splitting to create arrays
    arr = "LIB":SPLIT_REGEXPR_TO_ARRAY( 'ABC-DEF-GHI-JKL-MNO', '\w-\w' );

    -- Then convert the array into table
    dummy_select4 = unnest ( :arr ) as ( result );
    */

    select * from dummy;
  ENDMETHOD.

  METHOD string_conversion
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    -- The data types we are using are NVARCHAR and NCLOB
    -- For NCLOB we can use only LIKE, Regexpr or contains on the where clause

    dummy_select
    =
    select to_nvarchar( to_date( '1999-01/01' ) ) as conv_char from dummy;

  ENDMETHOD.

  METHOD string_functions_basic
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    declare my_dummy_table table ( sampleText nvarchar( 50 ) );
    declare emails_table table ( emails nvarchar( 50 ) );

    insert into :my_dummy_table values ( 'String Example Pattern' );
    insert into :my_dummy_table values ( '123456789 ABC DEFG 987XXX321' );

    insert into :emails_table values ( 'manuel.rentero@hotmail.com' );
    insert into :emails_table values ( '123SArentero@alight.com' );

    -- Here some basic string functions
    -- for processing text
    dummy_select
    =
    select
    'A ' || ', B' || 'C .' as Concat,                                -- CONCATENATION
    LENGTH( 'asoidjaoisjdas' ) as strLength,                         -- String Length
    ABAP_LOWER( 'PC' ) as lowerCase,                                 -- LOWER CASE
    ABAP_UPPER( 'pc' ) as upperCase,                                 -- UPPER CASE
    INITCAP( 'manuel' ) || INITCAP( 'ramirez' ) as captialLetters,   -- 1st Letter CAPITAL
    LEFT( sampleText, 8 ) as leftResult,                             -- LEFT side STR from Nth
    RIGHT( sampleText, 8 ) as rightResult,                           -- RIGHT side STR from Nth
    SUBSTR_BEFORE( sampleText, 'E' )  as subStringBefore,            -- SubSTR before char
    SUBSTR_BEFORE( sampleText, '' )  as subStringBeforeEmpty,        -- All SubSTR
    SUBSTR_AFTER( sampleText, 'E' )  as subStringAfter               -- SubSTR after char
    from :my_dummy_table;

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    me->string_functions_basic( ).
    me->string_conversion( ).
    me->string_functions_regexp( ).
    me->string_functions_trim_pad( ).
    me->string_functions_similarity( ).
    me->string_functions_unicode_conv( ).

    me->split_sqlscript_string_lib( ).
    me->format_sqlscript_string_lib( ).
    me->summary_sqlscript_string_lib( ).

    me->possible_date_formats( ).
    me->possible_time_formats( ).
    me->timestamp_formats( ).
    me->date_time_conversion( ).
    me->now_and_today_functions( ).
    me->add_functions( ).
    me->between_functions( ).
  ENDMETHOD.

  METHOD string_functions_regexp
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.
    -- Now lets use substr_regexpr whose signature is
    -- substr_regexpr( <patter> [FLAG <flag>] in <string> [from <start> ] [occurrence <nth>] [group <group>] )

    declare my_dummy_table table ( sampleText nvarchar( 50 ) );
    declare emails_table table ( emails nvarchar( 50 ) );

    insert into :my_dummy_table values ( 'String Example Pattern' );
    insert into :my_dummy_table values ( '123456789 ABC DEFG 987XXX321' );

    insert into :emails_table values ( 'manuel.rentero@hotmail.com' );
    insert into :emails_table values ( '123SArentero@alight.com' );

    -- For flags check chapter 4.1
    dummy_select_2
    =
    select
    SUBSTR_REGEXPR( '\b([A-Z0-9.-_+&%]+)@([A-Z0-9.-_+&%]+)\b' flag 'i' in emails group 1 ) as senderName,
    SUBSTR_REGEXPR( '\b([A-Z0-9.-_+&%]+)@([A-Z0-9.-_+&%]+)\b' flag 'i' in emails group 2 ) as hostName
    from :emails_table;

    dummy_select_3
    =
    select
    SUBSTR_REGEXPR( '\b\s\w+\s\b' in sampleText occurrence 1 ) as REGX1
    from :my_dummy_table;

    -- Replacement through regexp
    dummy_select_4
    =
    select
    REPLACE_REGEXPR( '(\d{4})-(\d{2})-((?2))' in '2026-04-03'  with '\3/\2/\1' ) as dateFormatted,
    REPLACE_REGEXPR( '(^\s?\w+)\s(\w+\s?$)' in 'Richard Volnik'  with 'First Name: \1, Last Name: \2' ) as namesFormatted
    from dummy;

    -- Number of occurrences of pattern
    dummy_select_5
    =
    select
    OCCURRENCES_REGEXPR( '\b\s?\w+\s?\b' in sampleText ) AS REGX1
    FROM :my_dummy_table;

    -- Locate
    dummy_select_6
    =
    select
    LOCATE_REGEXPR( '\b\s\w+\s\b' in sampleText occurrence 1 ) AS REGX1
    FROM :my_dummy_table;
  ENDMETHOD.

  METHOD string_functions_similarity
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  using /dmo/agency.
    -- The hamming distance give us -1 when the length of the words are different,
    -- and the number of different characters if the lengths are the same.
    dummy_select
    =
    select *
    from "/DMO/AGENCY"
    where hamming_distance( name, 'canny') between 0 and 1;


    -- For english, if two strings sound equally, they return the same phonetic code
    SELECT SOUNDEX ('Smith'), SOUNDEX ('Smythe') FROM DUMMY;
  ENDMETHOD.

  METHOD string_functions_trim_pad
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.
    -- PAD, 2nd parameter is the total length of the output string
   dummy_select_7
   =
   select
   LPAD( 'IHate', 15, 'nigga' ) as leftPade,
   RPAD( 'IHate', 15, 'nigga'  ) as rightPade
   from dummy;

   -- TRIM, finds the output starting from left or right then trims from start to occurrence
   dummy_select_8
   =
   select
   trim( both 'HIA' from 'ABCDEFGHI' ) as trim_both,
   trim( leading 'HIA' from 'ABCDEFGHI' ) as trim_leading,
   trim( trailing 'HIA' from 'ABCDEFGHI' ) as trim_trailing,
   RTRIM( 'ABCDEFGHI','HIA' ) as rightTrim,
   LTRIM( 'ABCDEFGHI','HIA' ) as leftTrim
   from dummy;
  ENDMETHOD.

  METHOD string_functions_unicode_conv
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    dummy_select
    =
    select
   -- unicode( '' ) as uni_Code,
    nchar( '30908' ) as uni_code_char
from dummy;
  ENDMETHOD.

ENDCLASS.
