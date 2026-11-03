CLASS zmrg_cla_amdp_chapter_04 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    INTERFACES if_oo_adt_classrun .

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
    METHODS extrac_components_from_date
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS week_from_date
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS time_zones_conversion
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    " Some practical examples using date & time
    METHODS calculate_runtime
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS calculate_date_info
      AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT
      IMPORTING VALUE(iv_date)   TYPE d
      EXPORTING VALUE(rt_result) TYPE tt_day_info.

    " Numerical data
    METHODS numerical_data_types
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS basic_numerical_operations
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS rounding_operations
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS trigonometry_functions
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS random_numbers
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS number_signs
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS unit_and_quantity_conversion
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    " Binary data types
    METHODS binary_data
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
ENDCLASS.



CLASS zmrg_cla_amdp_chapter_04 IMPLEMENTATION.

  METHOD binary_data BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.

    -- Binary data has the types: VARBINARY( N ) and for 2GB large datasets
    -- we have the BLOB data type.

    -- When we input binary data from string we must do it like X'' ( with the X )
    -- This is in hexadecimal value. So the binary representation into a string will always be
    -- an hexadecimal.

    -- Some functions are:

    -- BINTOSTR( ): Converts binary data to character string.
    -- BINTOHEX( ): Converts binary into hexadecimal representation
    -- BINTONHEX( ): Like BINTOHEX but output NVARCHAR, unicode.
    -- HEXTOBIN( ): Converts hexadecimal to binary

    declare character_table table ( ascii_int int, ascii_char nvarchar( 1 ), ascii_hex varbinary( 1 ) );
    declare i int;

    for i in 33..127 do
        :character_table.insert( ( :i, char( :i ), bintohex( char( :i ) ) ), :i );
    end for;

    selection_character_tab
    =
    select ascii_int as "Int", ascii_char as "char", ascii_hex as "Hex"
    from :character_table;


    /*
    -- BITSET( <target_num>, <start_bit> [, <num_to_set> ] )
    -- BITUNSET( <target_num>, <start_bit> [, <num_to_unset> ] )
    -- BITCOUNT: Count  how many bits are on a  binary number

    Parameters

        1. `<target_num>`: The input value (VARBINARY or positive integer). Note: If you pass an integer, HANA converts
           it to a `VARBINARY` representation.
        2. `<start_bit>`: The 1-based position of the first bit to modify, counted from left to right
           (most significant bit = position 1). It starts at 1.
        3. `<num_to_set>` / `<num_to_unset>` (optional): How many consecutive bits to set to 1 (or 0), starting from <start_bit>.
           Defaults to `1` if omitted.
    */

        dummy_bits =
          SELECT
            -- Starting with 1 byte of all zeros: X'00' (0000 0000)
            -- Set bit 1 (leftmost) to 1 -> 1000 0000 = X'80' (128)
            BITSET( hextobin( '00' ), 1, 1 )    AS "set_bit_1",

            -- Set bit 8 (rightmost) to 1 -> 0000 0001 = X'01' (1)
            BITSET( hextobin( '00' ), 8, 1 )    AS "set_bit_8",

            -- Set 4 bits starting at position 5 -> 0000 1111 = X'0F' (15)
            BITSET( hextobin( '00' ), 5, 4 )    AS "set_bits_5_to_8",

            -- Starting with 1 byte of all ones: X'FF' (1111 1111)
            -- Unset bit 1 (leftmost) to 0 -> 0111 1111 = X'7F' (127)
            BITUNSET( hextobin( 'FF' ), 1, 1 )  AS "unset_bit_1",

            -- Unset 4 bits starting at position 1 -> 0000 1111 = X'0F' (15)
            BITUNSET( hextobin( 'FF' ), 1, 4 )  AS "unset_bits_1_to_4",

            -- Bonus: BITCOUNT counts how many bits are set to 1
            BITCOUNT( hextobin( '0F' ) )        AS "ones_in_0F" -- Returns 4
          FROM dummy;

    /*
    -- Bitwise Logical Operations:
    -- BITAND( <val1>, <val2> ): Bitwise AND. Returns 1 at each bit position where BOTH inputs have 1.
    --                           (Accepts INTEGER/BIGINT or VARBINARY; returns INTEGER/BIGINT for numbers, VARBINARY for binary).
    -- BITOR( <val1>, <val2> ) : Bitwise OR. Returns 1 at each bit position where AT LEAST ONE input has 1.
    -- BITXOR( <val1>, <val2> ): Bitwise EXCLUSIVE OR (XOR). Returns 1 at each bit position where the inputs have DIFFERENT bits (one is 1, the other is 0).
    -- BITNOT( <val> )         : Bitwise NOT (One s complement). Inverts all bits (0 -> 1, 1 -> 0).
    --                           Note: For signed integers, BITNOT( x ) equals -(x + 1) due to twos complement representation.
    */

 -- Examples using Binary / Hexadecimal values:
    -- Let A = X'F0' (1111 0000 in binary = 240)
    -- Let B = X'CC' (1100 1100 in binary = 204)
    dummy_bitwise_hex =
      SELECT
        -- 1111 0000 AND 1100 1100 -> 1100 0000 = X'C0' (192)
        BITAND( hextobin( 'F0' ), hextobin( 'CC' ) ) AS "bitand_hex",

        -- 1111 0000 OR  1100 1100 -> 1111 1100 = X'FC' (252)
        BITOR(  hextobin( 'F0' ), hextobin( 'CC' ) ) AS "bitor_hex",

        -- 1111 0000 XOR 1100 1100 -> 0011 1100 = X'3C' (60)
        BITXOR( hextobin( 'F0' ), hextobin( 'CC' ) ) AS "bitxor_hex",

        -- NOT 1111 0000           -> 0000 1111 = X'0F' (15)
        BITNOT( hextobin( 'F0' ) )                   AS "bitnot_hex"
      FROM dummy;

    -- Examples using Integers:
    -- Let 12 = 1100 in binary
    -- Let 10 = 1010 in binary
    dummy_bitwise_int =
      SELECT
        BITAND( 12, 10 ) AS "bitand_int", -- 1100 & 1010 = 1000 (8)
        BITOR(  12, 10 ) AS "bitor_int",  -- 1100 | 1010 = 1110 (14)
        BITXOR( 12, 10 ) AS "bitxor_int", -- 1100 ^ 1010 = 0110 (6)
        BITNOT( 12 )     AS "bitnot_int"  -- ~12         = -13
      FROM dummy;
  ENDMETHOD.

  METHOD unit_and_quantity_conversion BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.
    -- For QUANTITY CONVERSION
    -- We have function CONVERT_UNIT( ) with parameters:

    -- Quantity
    -- SOURCE_UNIT
    -- TARGET_UNIT
    -- CLIENT: Client from which the conversion is going to be performed
    -- SCHEMA: Database schema in which conversion factors are stored
    -- ERROR_HANDLING: 'fail on error', 'set to null', 'keep unconverted'
    -- RATES_TABLE: Database table with the conversion factors
    -- DIMENSION_TABLE: Database table with the dimension information

    -- Tables used on ERP are:
    -- T006: Contains all units of measurement and assign them to dimension. Also contains
    --       conversion factors.
    -- T006D: Contains all dimensions to which the units of measurement can be assigned.

    declare quantities_table table ( quantity decimal( 15,2 ),  unit nvarchar( 3 ) );

    declare amounts_table table (  amount   decimal( 15, 2 ),
                                   source   nvarchar( 5 ),
                                   target   nvarchar( 5 ),
                                   ref_date date );

    insert into :quantities_table values ( 1.0, 'MG' );
    insert into :quantities_table values ( 1.0, 'G' );
    insert into :quantities_table values ( 1.0, 'KG' );
    insert into :quantities_table values ( 1.0, 'TO' );
    insert into :quantities_table values ( 1.0, 'XYZ' );

    dummy_select
    =
    select
    quantity as "Quantity",
    unit     as "Unit",
    CONVERT_UNIT(
        QUANTITY          => quantity,
        SOURCE_UNIT       => unit,
        TARGET_UNIT       => 'KG',
        SCHEMA            => CURRENT_SCHEMA,
        --RATES_TABLE       => 'T006',
        --DIMENSION_TABLE   => 'T006D',
        CLIENT            => SESSION_CONTEXT('CDS_CLIENT'),
        ERROR_HANDLING    => 'set to null' ) as "Quantity in KG",
    'KG' as "KG"
    from :quantities_table;

    -- For CURRENCY CONVERSION
    -- We have function CONVERT_CURRENCY with parameters:

    -- AMOUNT
    -- SOURCE_UNIT
    -- TARGET_UNIT
    -- REFERENCE_DATE: Date for exchange rate determination
    -- SCHEMA: Database schema where conversion factors are stored
    -- CLIENT: Client where conversion is determined
    -- ERROR_HANDLING: 'fail on error', 'set to null', 'keep unconverted'
    -- *_TABLE: Name of the database table for the conversion information. These are:
    -- CONVERSION_TYPE: Defines the exchange rate type (from TCURV, e.g., 'M' for standard average rate,
    --                  'B' for bank selling, 'G' for bank buying).
    -- ACCURACY:        Controls intermediate rounding precision during conversion:
    --                  - 'compatibility' (default): Mimics classic ERP ABAP behavior (rounds intermediate results).
    --                  - 'highest': Keeps maximum floating-point precision until the final step.
    -- LOOKUP:          Defines how the exchange rate is searched in TCURR:
    --                  - 'regular' (default): Standard lookup (direct rate, or inverted/reference currency if configured).
    --                  - 'reverse': Searches for the inverted currency pair (target to source).
    -- STEPS:           Comma-separated list defining the exact processing steps to perform:
    --                  - 'shift': Shifts decimal places according to source currency decimals (TCURX) to internal 2 decimals.
    --                  - 'convert': Applies the exchange rate and conversion factors (TCURR / TCURF).
    --                  - 'shift_back': Shifts decimal places from internal 2 decimals to target currency decimals (TCURX).
    --                  - 'round': Rounds the final result to the precision of the target currency.

    -- PRECISIONS_TABLE: Default TCURX. Decimals of individual currencies
    -- CONFIGURATION_TABLE: Default TCURV. Exchange rates types for currency conversion
    -- NOTATION_TABLE: Default TCURN. Definition of the notation direction of a currency pair.
    -- RATES_TABLE: Default TCURR. Exchanges rates.
    -- PREFACTORS_TABLE: Default TCURF. Conversion factors.

    -- See example at: cl_demo_sqlscript_curr_conv->convert and cl_demo_sqlscript_curr_cnvrsn for execution.

    insert into :amounts_table values ( 100.00, 'EUR', 'USD', '2026-01-01' );

    dummy_currency_select
    =
    SELECT
        amount   AS "Amount",
        source   AS "SourceCurrency",
        target   AS "TargetCurrency",
        CONVERT_CURRENCY(
          AMOUNT          => amount,
          SOURCE_UNIT     => source,
          TARGET_UNIT     => target,
          REFERENCE_DATE  => to_dats( ref_date ),
          SCHEMA          => CURRENT_SCHEMA,
          CLIENT          => SESSION_CONTEXT('CDS_CLIENT'),
          CONVERSION_TYPE => 'M',
          ERROR_HANDLING  => 'set to null',
          ACCURACY        => 'highest',
          LOOKUP          => 'regular',
          STEPS           => 'convert,shift_back,shift,round'
        ) AS "ConvertedAmount"
    FROM :amounts_table;

  ENDMETHOD.



  METHOD number_signs BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.

    -- SIGN( <value> ): Returns 1 if number is positive and -1 if negative
    -- ABS( <value> ) : Returns the absolute value of the number
    -- UMINUS( <VALUE> ): Reverses the sign of the number

    dummy_select
    =
    select
    SIGN( -900 ) as "sign1",
    SIGN( 90 )   as "sign2",
    abs( -1.45 ) as "abs",
    uminus( -1.2 ) as "reversedVal"
    from dummy;

  endmethod.

  METHOD random_numbers BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.

    -- Functions RAND y RAND_SECURE both use DOUBLE types between 0 and 1.

    dummy_select
    =
    select RAND( ) as random,
           RAND_SECURE( ) as randomSecure
    from dummy;

  ENDMETHOD.

  METHOD trigonometry_functions BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.

    -- Here some trigonometry functions
    -- pi = ACOS( -1 ) (~3.141592653589793)

    dummy_select
    =
    select
      -- Standard Trigonometric Functions (input in radians)
      SIN( ACOS( -1 ) / 2 )       as "sin_90_deg",   -- sin(pi/2) = 1
      COS( 0 )                    as "cos_0_deg",    -- cos(0)    = 1
      TAN( ACOS( -1 ) / 4 )       as "tan_45_deg",   -- tan(pi/4) = 1
      COT( ACOS( -1 ) / 4 )       as "cot_45_deg",   -- cot(pi/4) = 1

      -- Inverse Trigonometric Functions (output in radians)
      ASIN( 1 )                   as "asin_1",       -- pi/2 (~1.570796)
      ACOS( -1 )                  as "acos_minus_1", -- pi   (~3.141592)
      ATAN( 1 )                   as "atan_1",       -- pi/4 (~0.785398)
      ATAN2( 1, 1 )               as "atan2_y_x",    -- atan(1/1) = pi/4

      -- Hyperbolic Functions
      SINH( 1 )                   as "sinh_1",       -- Hyperbolic sine
      COSH( 0 )                   as "cosh_0",       -- Hyperbolic cosine (= 1)
      TANH( 1 )                   as "tanh_1"        -- Hyperbolic tangent
    from dummy;

  endmethod.

  METHOD rounding_operations BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.

    -- ROUND( <value>, <place>, [<model>] ): Allows to reduce precision of a number
    -- <place>: if 0 means round to whole number, 2 to 2 decimal places.
    -- if <place> is negative like -3, it will make 1, 10 and 100 values on number 6389 -> 6000 to 0.

    -- <mode> defines the rounding mode:
    -- ROUND_HALF_UP  : Value is always rounded to the closest straight value. If in the middle, it is always rounded UP.
    -- ROUND_HALF_DOWN: Same as HALF_UP but when in doubt it rounds to the closest straight but DOWN.
    -- ROUND_HALF_EVEN: Similar to the previous two, but when in doubt, it rounds to the value that after rounding becomes EVEN
    -- ROUND_UP       : Always round up the amount
    -- ROUND_DOWN     : Always round down the amount
    -- ROUND_CEILING  : Always round up.
    -- ROUND_FLOOR    : Always round down

    -- Also to mention we have the functions FLOOR( ) and CEIL( ).

    declare dummy_tab table ( val DOUBLE );

    insert into :dummy_tab values ( 1 );
    insert into :dummy_tab values ( 1.1 );
    insert into :dummy_tab values ( -1.1 );
    insert into :dummy_tab values ( 1.499999 );
    insert into :dummy_tab values ( 1.500000 );
    insert into :dummy_tab values ( -1.499999 );
    insert into :dummy_tab values ( -1.500000 );
    insert into :dummy_tab values ( 1.749999 );
    insert into :dummy_tab values ( 1.750000 );
    insert into :dummy_tab values ( 175 );

    dummy_select
    =
    select
    val,
    CEIL( VAL ) as ceiling,
    FLOOR( val ) as floor,
    ROUND( val, 0, ROUND_HALF_UP ) as rhu_0,
    ROUND( val, 0, ROUND_UP ) as ru_0,
    ROUND( val, 1, ROUND_HALF_UP ) as rhu_1,
    ROUND( val, 1, ROUND_UP ) as ru_1,
    ROUND( val, -1 ) as  rhu_m1
    from :dummy_tab;

  endmethod.


  METHOD basic_numerical_operations BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.

    -- Basic numerical operations include + / * -
    -- Also the NDIV0( <numerator>, <denominator> ) --> Returns 0 if the denominator is 0


    dummy_select
    =
    select 1 + 3 as "summatory",
           1 - 3 as "subtractrion",
           NDIV0( 1, 3 ) as "division",
           1 / 3 as "division1",
           NDIV0( 1, 0 ) as "division2",
           1 * 3 as "multiplication",
           MOD( 1, 3 ) as "modulo"
    from dummy;


    -- To do the exponentiation of a number or square root we do
    -- POWER( <basis>, <exponent> )
    -- SQRT( <number> )
    -- EXP( <value> ) Power in base Euler
    -- PI( ) is number  pi

    dummy_select1
    =
    select POWER( 2, 4 ) as "examplePower",
           SQRT( 9 )     as "squareRoot",
           EXP( 3 )      as "EulerToThe3",
           ACOS( -1 )    as "piNumber"
    from dummy;

    -- For logarithms we have
    -- LN( <value> ) base e
    -- LOG( <basis>, <value> )
    dummy_select2
    =
    select LN( EXP( 4 ) ) as "naturalLogarithim",
           LOG( 10, POWER( 10, 3 ) ) as "base10Logarithm"
    from dummy;
  ENDMETHOD.

  METHOD numerical_data_types BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.
    declare dummy_tab table ( a TINYINT,  -- Integer from 0 to 255
                              b SMALLINT, -- Integer from +/- 32,767
                              c INTEGER,  -- Integer from +/- 2,147,483,647
                              d BIGINT,   -- Integer from +/- 9,223,372,036,854,775,807
                              e DECIMAL( 6, 2 ), -- Fixed point, p from 1 to 38 places, s from 0 to p places
                              f DECIMAL, -- Decimal floating point. Decimal part up to 34 places. Exponent +/- ~6000
                              g SMALLDECIMAL, -- Decimal floating point. Decimal part up to 16 places. Exponent +/- 368--
                              h REAL, -- Binary floating point  32 bit
                              i DOUBLE, -- Binary floating point 64 bit
                              j FLOAT(1), -- Equivalent to REAL
                              K FLOAT( 25 ) -- Equivalent to double
                            );
  ENDMETHOD.


  METHOD calculate_date_info BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.
    date_selection
    =
    select
      to_date( :iv_date ) as d_date,
      weekday( to_date( :iv_date ) ) as weekNumber
    from dummy;

    rt_result
    =
    select
      to_dats( d_date )  as d,
      initcap( abap_lower( dayname( d_date ) ) )  as weekDayEn,
      case weekNumber
        when 0 then 'Lunes'
        when 1 then 'Martes'
        when 2 then 'Mi' || nchar( 233 ) || 'rcoles'
        when 3 then 'Jueves'
        when 4 then 'Viernes'
        when 5 then 'S'  || nchar( 225 ) || 'bado'
        when 6 then 'Domingo'
      end                as weekDayLocale,
      week( d_date )     as weekNumber
    from :date_selection;
  ENDMETHOD.


  METHOD calculate_runtime BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.

    -- Imagine we have 2 begda/endda from ABAP & 2 beguz/endduz
    -- They represent program start and end times
    -- Calculate the runtime between those 2

    declare runtime_information table ( begda nvarchar( 8 ), beguz nvarchar( 6 ), endda nvarchar( 8 ), enduz nvarchar( 6 ) );

     :runtime_information.insert( ( '20261015', '091655', '20261018', '050319' ), 1 );
     :runtime_information.insert( ( '20261015', '100000', '20261015', '113000' ), 2 );
     :runtime_information.insert( ( '20261231', '100000', '20270101', '110000' ), 3 );

     -- Converted units
     converted_time_units
     =
     select
     to_seconddate( begda || ' ' || beguz, 'YYYYMMDDHH24MISS' ) as start_time,
     to_seconddate( endda || ' ' || enduz, 'YYYYMMDDHH24MISS' ) as end_time
     from :runtime_information;

     -- Calculate difference
     calculated_timespawn_seconds
     =
     select
     abs( seconds_between( end_time, start_time ) ) as spawn_seconds
     from :converted_time_units;

     calculated_timespawn
     =
     select
     floor( mod( spawn_seconds, 60 ) )        as "seconds",
     floor( mod( spawn_seconds, 3600 ) / 60 ) as "minutes",
     floor( spawn_seconds / 3600 )            as "hours"
     from :calculated_timespawn_seconds;


  ENDMETHOD.

  METHOD time_zones_conversion BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.

    -- There are 2 functions:
    -- UTCTOLOCAL( <timestamp>, <timezone>, <origin> )
    -- LOCALTOUTC( <timestamp>, <timezone>, <origin> )

    dummy_select
    =
    select
    CURRENT_UTCTIMESTAMP as "utc",
    CURRENT_TIMESTAMP as "timestamp",
    utctolocal( to_timestamp( '2026-10-01 19:45:00', 'YYYY-MM-DD HH24:MI:SS' ), 'CET', 'sap' ) as "conv1",
    utctolocal( CURRENT_UTCTIMESTAMP, 'CET', 'SAP' ) as "conv2",
    utctolocal( CURRENT_UTCTIMESTAMP, 'UTC+1', 'SAP' ) as "conv3"
    from dummy;
  ENDMETHOD.

  METHOD week_from_date BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.

    -- There are 2 ways of obtaining the week from a date. With the function WEEK and the function ISOWEEK
    -- WEEK: Returns from 1st january that year ( counted as 1 ) the number of weeks from that date
    -- ISOWEEK: Returns from the 1st week containing the 1st Thursday, the number of weeks in a format: <YEAR>-W<WEEK>
    -- WEEKDAY: 0 means Monday and 6 means Sunday.
    -- QUARTER( <date>, <first_month> ): Return the quarter of that date, we can also specify a month for setting the start there
    -- DAYOFYEAR: Returns the number of calendar days for that date
    -- DAYNAME: Returns the

    dummy_select
    =
    select week( current_date ) as "week",
           isoweek( current_date )    as "isoWeek",
           weekday( current_date )    as "weekDay",
           quarter( current_date )    as "quarter",
           quarter( current_date, 2 ) as "quarterStartingMarch",
           dayofyear( current_date )  as "dayOfYear",
           dayname( current_date )    as "dayName",
           monthname( current_date )  as "monthName"
           from dummy;

  ENDMETHOD.

  METHOD extrac_components_from_date BY DATABASE PROCEDURE
  FOR HDB LANGUAGE SQLSCRIPT.

    -- We can use EXTRACT( <component> from <value> ) using a series of <component>
    -- YEAR, MONTH, DAY, HOUR, MINUTE, SECOND
    -- Apart from EXTRACT, there are other SQL functions for this tiask

    dummy_select
    =
    select 1                          as "Row",
           year( current_date )       as "Year",
           month( current_date )      as "Month",
           dayofmonth( current_date ) as "Day",
           hour( current_time )       as "hour",
           minute( current_time )     as "minute",
           second( current_time )     as "second"
    from dummy
    union all
    select 2                          as "Row",
           extract( year from current_date )       as "Year",
           extract( month from current_date )      as "Month",
           extract( day from current_date )        as "Day",
           extract( hour from current_time )       as "hour",
           extract( minute from current_time )     as "minute",
           extract( second from current_time )     as "second"
    from dummy;
  ENDMETHOD.


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
    select current_date,           -- local system date
           current_time,           -- local system time
           current_timestamp,      -- local system timestamp
           now( ) as now_timstamp, -- Same as current_timestamp
           current_utcdate,        -- Date on UTC
           current_utctime,        -- Time on UTC
           current_utctimestamp,   -- Timestamp UTC
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
    " Basic String functions
    me->string_functions_basic( ).
    me->string_conversion( ).
    me->string_functions_regexp( ).
    me->string_functions_trim_pad( ).
    me->string_functions_similarity( ).
    me->string_functions_unicode_conv( ).

    " Library: SQLSCRIPT_STRING
    me->split_sqlscript_string_lib( ).
    me->format_sqlscript_string_lib( ).
    me->summary_sqlscript_string_lib( ).

    " Date & time
    me->possible_date_formats( ).
    me->possible_time_formats( ).
    me->timestamp_formats( ).
    me->date_time_conversion( ).
    me->now_and_today_functions( ).
    me->add_functions( ).
    me->between_functions( ).
    me->extrac_components_from_date( ).
    me->week_from_date( ).
    me->time_zones_conversion( ).

    " Time & date exercises
    me->calculate_runtime( ).
    me->calculate_date_info( EXPORTING iv_date = CONV d( xco_cp=>sy->date( xco_cp_time=>time_zone->user )->as( io_format =  xco_cp_time=>format->abap )->value )
                             IMPORTING rt_result = DATA(date_info) ).

    " Integers / Numeric data
    me->numerical_data_types( ).
    me->rounding_operations( ).
    me->trigonometry_functions( ).
    me->random_numbers( ).
    me->number_signs( ).


    " Units and quantities
    me->unit_and_quantity_conversion( ).

    SELECT FROM I_UnitOfMeasure
      FIELDS UnitOfMeasure, UnitOfMeasureDimension, SIUnitCnvrsnRateNumerator, SIUnitCnvrsnRateDenominator
      WHERE UnitOfMeasure IN ('MG', 'G', 'KG', 'TO')
      INTO TABLE @DATA(lt_units).
    out->write( lt_units ).

    " API For exchange rates: CL_EXCHANGE_RATES=>PUT . This table is empty
    SELECT FROM I_ExchangeRateRawData
       FIELDS ExchangeRateType, SourceCurrency, TargetCurrency, ValidityStartDate, ExchangeRate
       INTO TABLE @DATA(lt_rates)
       UP TO 20 ROWS.
    out->write( lt_rates ).

    " Binary data types
    me->binary_data( ).

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
