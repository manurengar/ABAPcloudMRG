CLASS zmrg_cla_amdp_chapter_04 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS string_functions
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
ENDCLASS.



CLASS zmrg_cla_amdp_chapter_04 IMPLEMENTATION.
  METHOD string_functions
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

    -- Now lets use substr_regexpr whose signature is
    -- substr_regexpr( <patter> [FLAG <flag>] in <string> [from <start> ] [occurrence <nth>] [group <group>] )

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
    RTRIM( 'endabAabbabab','ab' ) as rightTrim,
    LTRIM( 'babababAabend','ab' ) as leftTrim
    from dummy;

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    me->string_functions( ).
  ENDMETHOD.
ENDCLASS.
