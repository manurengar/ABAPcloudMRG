CLASS zmrg_cla_amdp_chapter_04 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS string_functions_basic
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
ENDCLASS.



CLASS zmrg_cla_amdp_chapter_04 IMPLEMENTATION.


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
    'A ' || ', B' || 'C .' as Concat,
    ABAP_LOWER( 'PC' ) as lowerCase,
    ABAP_UPPER( 'pc' ) as upperCase,
    INITCAP( 'manuel' ) || INITCAP( 'ramirez' ) as captialLetters,
    LEFT( sampleText, 8 ) as leftResult,
    RIGHT( sampleText, 8 ) as rightResult,
    SUBSTR_BEFORE( sampleText, 'E' )  as subStringBefore,
    SUBSTR_BEFORE( sampleText, '' )  as subStringBeforeEmpty,
    SUBSTR_AFTER( sampleText, 'E' )  as subStringAfter
    from :my_dummy_table;

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    me->string_functions_basic( ).
    me->string_functions_regexp( ).
    me->string_functions_trim_pad( ).
    me->string_functions_similarity( ).
    me->string_functions_unicode_conv( ).
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
