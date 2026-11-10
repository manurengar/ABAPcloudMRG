CLASS zmrg_cla_amdp_chapter_05 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    " INSERTION
    METHODS insert_data_declarative
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS insert_data_imperative
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS insert_default_data
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

    " UPDATE
    METHODS update_column_subset
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.
    METHODS update_from_other_table
        AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT.

        """ TAB M9

*@EndUserText.label : 'dummy'
*@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
*@AbapCatalog.tableCategory : #TRANSPARENT
*@AbapCatalog.deliveryClass : #A
*@AbapCatalog.dataMaintenance : #RESTRICTED
*define table zfrpa_tab_dio_m9 {
*
*  key client          : abap.clnt not null;
*  key employee_number : pernr_d not null;
*  employee_name       : abap.sstring(50);
*  birth_date          : abap.dats;
*
*}

    """ TAB M8
*@EndUserText.label : 'dummy'
*@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
*@AbapCatalog.tableCategory : #TRANSPARENT
*@AbapCatalog.deliveryClass : #A
*@AbapCatalog.dataMaintenance : #RESTRICTED
*define table zfrpa_tab_dio_m8 {
*
*  key client        : abap.clnt not null;
*  key serial_number : abap.int8 not null;
*  key initials      : abap.char(2) not null;
*  custom_date       : abap.dats;
*
*}



    METHODS insert_data_database_tab AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT..
    METHODS update_data_database_tab AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT..
    METHODS upsert_data_database_tab AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT..
    METHODS merge_data_database_tab AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT..
    METHODS delete_data_database_tab AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT..
    METHODS truncate_data_database_tab AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT..
ENDCLASS.



CLASS zmrg_cla_amdp_chapter_05 IMPLEMENTATION.

  METHOD update_from_other_table
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    -- We can update our sorce table from other(s) tables using
    -- This statement is only supported for DATABASE tables

    declare dummy_tab1 table ( col1 int, col2 nvarchar( 2 ), col3 date );
    declare dummy_tab2 table ( name nvarchar( 50 ), birth_date date );

    insert into :dummy_tab1 values ( 1, 'XX', to_date( '19000101' ) );
    insert into :dummy_tab1 values ( 2, 'XX', to_date( '19000101' ) );
    insert into :dummy_tab1 values ( 3, 'XX', to_date( '19000101' ) );

    insert into :dummy_tab2 values ( 'Jean Paultier',   to_date( '19890911' ) );
    insert into :dummy_tab2 values ( 'Sarah Allatolah', to_date( '20150501' ) );
    insert into :dummy_tab2 values ( 'Niggasus Pensus', to_date( '20020221' ) );

    /*
 This damn statement is not supported would be like this:

     CREATE TABLE dummy_tab1(
        col1 INT,
        col2 NVARCHAR(2),
        col3 DATE
    );
    CREATE TABLE dummy_tab2(
        col1 INT,
        name NVARCHAR(50),
        birth_date DATE
    );
    INSERT INTO dummy_tab1 VALUES(1, 'XX', to_date('19000101'));
    INSERT INTO dummy_tab1 VALUES(2, 'XX', to_date('19000101'));
    INSERT INTO dummy_tab1 VALUES(3, 'XX', to_date('19000101'));
    INSERT INTO dummy_tab2 VALUES(1, 'Jean Paultier', to_date('19890911'));
    INSERT INTO dummy_tab2 VALUES(2, 'Sarah Allatolah', to_date('20150501'));
    INSERT INTO dummy_tab2 VALUES(3, 'Niggasus Pensus', to_date('20020221'));
    UPDATE dummy_tab1
    SET
        t1.col2 = LEFT( t2.name, 1 ) || LEFT( SUBSTR_AFTER( t2.name, ' ' ), 1 ),
        t1.col3 = t2.birth_date
    FROM
        dummy_tab1 AS t1,
        dummy_tab2 AS t2
    WHERE (dummy_tab1.col1 IN (1, 2, 3))
        AND dummy_tab1.col1 = t2.col1;
    -- assuming col1 is the join key


    SELECT *
    FROM dummy_tab1;
    drop table dummy_tab1;
    drop table dummy_tab2;


    */

  endmethod.

  METHOD update_column_subset
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.
    -- We can update a subset of the database by applying a WHERE condition to restrict records
    -- also specify which columns and with which values to update

    declare dummy_tab table ( col1 int, col2 nvarchar( 3 ), col3 date );

    insert into :dummy_tab values( 1, 'abc', to_date( '19000101' ) );
    insert into :dummy_tab values( 2, 'erf', to_date( '19100101' ) );
    insert into :dummy_tab values( 3, 'zfx', to_date( '19200101' ) );

    update :dummy_tab
    set col2 = 'abc',
        col3 = current_date
    where col1 >= 2;
  ENDMETHOD.


  METHOD insert_default_data
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    -- We can create tables specifying the primary_key and defaulting its value to not be null

    -- 1. Create table with a composite PRIMARY KEY (col1, col2) and DEFAULT values
   /*
    create column table zdemo_table (  col1 nvarchar(3) default 'DEF' not null,
                                       col2 int         default 1     not null,
                                       col3 date        default '2026-01-01',
                                       primary key ( col1, col2 )  );
    */

    -- Case A: Omit ALL key columns (col1 and col2 take their defaults: 'DEF' and 1)
    -- Result: SUCCESS -> Inserts ('DEF', 1, '2025-05-10')

    /*
    insert into zdemo_table ( col3 ) values ( to_date('20250510', 'YYYYMMDD') );
    */

    -- Case B: Omit only ONE key column (col1 takes default 'DEF', col2 is explicitly 2)
     -- Result: SUCCESS -> Inserts ('DEF', 2, '2026-01-01') because ('DEF', 2) is unique

    /*
    insert into zdemo_table ( col2 )  values ( 2 );
    */

    -- Case C: Omit ALL key columns a SECOND time
    -- Result: ERROR! (SQL Code 301: unique constraint violated)
    -- Because it tries to insert ('DEF', 1) again, which already exists from Case A!
    /*
    insert into zdemo_table ( col3 )  values ( to_date('20261231', 'YYYYMMDD') );
    */

    -- Case D: Explicitly pass NULL into a defaulted PRIMARY KEY column
    -- Result: ERROR! (cannot insert NULL or update to NULL)
    -- Note: DEFAULT is only triggered when the column is OMITTED, not when NULL is passed!
    /*
    insert into zdemo_table ( col1, col2, col3 )  values ( null, 3, to_date('20261231', 'YYYYMMDD') );
    */


    -- Auto-Incrementing Key (GENERATED BY DEFAULT AS IDENTITY)

    /*
      create column table zdemo_identity (  id   int generated by default as identity primary key,
                                            col1 nvarchar(3) default 'ABC' );
    */
    -- Both succeed! 'id' automatically increments (1, 2, ...) when omitted:

    /*
    insert into zdemo_identity ( col1 ) values ( 'XYZ' ); -- Inserts (1, 'XYZ')
    insert into zdemo_identity ( col1 ) values ( 'MNX' ); -- Inserts (2, 'MNX')
    */

    -- Omit ALL columns using DEFAULT VALUES:
    /*
    insert into zdemo_identity default values;            -- Inserts (3, 'ABC')
    */

  ENDMETHOD.



  METHOD insert_data_imperative
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    -- IMPERATIVE DML statement, CANNOT BE USED ON DATAASE TABLES

    -- <table_var>.INSERT(:<source_table_var>, <index>);
    declare dummy_tab table ( col1 nvarchar( 3 ), col2 int, col3 date );
    declare dummy_tab2 table ( col1 nvarchar( 3 ), col2 int, col3 date );

    -- SINGLE ROW insertion
    -- Appends at the end
    :dummy_tab.insert(( 'abc', 2, to_date('19000101') ));

    -- Inserts at position 1 (shifts existing rows down)
    :dummy_tab.insert(( 'xyz', 10, to_date('20260101') ), 1);

    -- MULTIPLE ROW insertion
    :dummy_tab2.insert(( 'MNX', 15, to_date('20250101') ));

    -- Append all rows of dummy_tab2 into dummy_tab
    :dummy_tab.insert( :dummy_tab2 );

    -- Or insert dummy_tab2 starting at row 2 of dummy_tab
    :dummy_tab.insert( :dummy_tab2, 2 );

  ENDMETHOD.


  METHOD insert_data_declarative
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.

    -- This method should not contain READ-ONLY but here is not permitted
    -- We will work with local tables instead

    -- DECLARATIVE DML statement, CAN BE USED ON DATABASE TABLES

    -- INSERT INTO <TABLE> <column sequence> VALUES ( <column values> )
    declare dummy_tab table ( col1 nvarchar( 3 ), col2 int, col3 date );
    declare dummy_tab2 table ( col1 nvarchar( 3 ), col2 int, col3 date );

    insert into :dummy_tab values ( 'abc', 2, to_date( '19000101' ) );                       -- Without column specification
    insert into :dummy_tab ( col2, col3, col1 ) values ( 10, to_date( '20260101' ), 'xyz' ); -- Wiwth column specification ( recommended )

    -- Inserting multiple records simultaneously

    -- INSERT INTO <TABLE> <COLUMNORDER> <QUERY>;

    insert into :dummy_tab ( col3, col2, col1 )
        select to_date( '01/01/2025', 'DD/MM/YYYY' ) as col3,
               15                                    as col2,
               'MNX'                                 as col1
               from dummy;

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.

    " INSERT
    me->insert_data_declarative( ).
    me->insert_data_imperative( ).

    " UPDATE
    me->update_column_subset( ).
    me->update_from_other_table( ).

    " Database operations
*    me->truncate_data_database_tab( ).
*
*    me->insert_data_database_tab( ).
*    me->update_data_database_tab( ).
*    me->upsert_data_database_tab( ).
*
*    me->truncate_data_database_tab( ).
*    me->insert_data_database_tab( ).
*
*    me->merge_data_database_tab( ).
*    me->delete_data_database_tab( ).
  ENDMETHOD.


   METHOD truncate_data_database_tab
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.
  --USING zfrpa_tab_dio_m9 zfrpa_tab_dio_m8.
/*
    -- CAREFULL with this, erases all database, no ROLLBACK allowed
    -- NOT ALLOWED ON AMDP
    -- truncate table zfrpa_tab_dio_m9;
    -- truncate table zfrpa_tab_dio_m8;

    -- Alternative
    delete from zfrpa_tab_dio_m9 where client = SESSION_CONTEXT('CLIENT');
    delete from zfrpa_tab_dio_m8 where client = SESSION_CONTEXT('CLIENT');

    dummy_select2
    =
    select * from  zfrpa_tab_dio_m8;
    dummy_select1
    =
    select * from  zfrpa_tab_dio_m9;
    */
  endmethod.

  METHOD delete_data_database_tab
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.
  --USING zfrpa_tab_dio_m9.

/*
    -- Here if you omit the where clause the all the database will be erased.
    -- However you can use ROLLBACK in this case to undo the deletion.

    delete from zfrpa_tab_dio_m9
    where client = SESSION_CONTEXT('CLIENT')
    and employee_number like '9%';

    -- commit; NOT PERMITTED

    delete from zfrpa_tab_dio_m9
    where client = SESSION_CONTEXT('CLIENT')
    and employee_number = '00002986';

    -- rollback; NOT PERMITTED

    dummy_select1
    =
    select * from  zfrpa_tab_dio_m9;

    */
  endmethod.


  METHOD upsert_data_database_tab
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.
  --USING zfrpa_tab_dio_m9 zfrpa_tab_dio_m8.

/*
    -- Upsert is a combination of insert and modify
    -- WITH PRIMARY KEY is needed otherwise it will insert first record and overwrite it after

    declare my_dummy_tab table ( client nvarchar( 3 ), employee_number nvarchar( 8 ), employee_name nvarchar( 50 ), birth_date nvarchar( 8 ) );

    -- UPSERT single records
    upsert zfrpa_tab_dio_m8 values ( SESSION_CONTEXT('CLIENT'), 00002984, 'XX', '20001010' ) with primary key;
    upsert zfrpa_tab_dio_m9 values ( SESSION_CONTEXT('CLIENT'), 00002984, 'DUMMY NAME', '20001010' ) with primary key;

    -- If the records does not exists, then it insert it.
    upsert zfrpa_tab_dio_m8 values ( SESSION_CONTEXT('CLIENT'), 00002988, 'XX', '20001010' ) with primary key;

    -- We can also update/insert using another table as data source / query or local table
     insert into :my_dummy_tab values ( SESSION_CONTEXT('CLIENT'), 00002986, 'DUMMY EMP', to_dats( current_date ) );
     insert into :my_dummy_tab values ( SESSION_CONTEXT('CLIENT'), 99009900, 'DUMMY EMP', to_dats( current_date ) );
     insert into :my_dummy_tab values ( SESSION_CONTEXT('CLIENT'), 99009901, 'DUMMY EMP', to_dats( current_date ) );
     insert into :my_dummy_tab values ( SESSION_CONTEXT('CLIENT'), 99009902, 'DUMMY EMP', to_dats( current_date ) );

     upsert zfrpa_tab_dio_m9 ( client, employee_number, employee_name, birth_date )
     select * from :my_dummy_tab;

    dummy_select1
    =
    select * from  zfrpa_tab_dio_m9;

    dummy_select2
    =
    select * from  zfrpa_tab_dio_m8;
    */
  endmethod.


  METHOD merge_data_database_tab
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.
  --USING zfrpa_tab_dio_m9 zfrpa_tab_dio_m8.

    -- The syntax is clearer on this one than on UPDATE FROM

    -- MERGE INTO <target_table> [ <partition_restriction> ] [ [ AS ] <alias> ]
    -- USING <table_reference>
    -- ON <search_condition> <merge_operation_specification>
    -- WHEN MATCHED THEN UPDATE SET <column updates>
    -- WHEN NOT MATCHED THEN INSERT <column list> value(<values>)

    -- WHEN [NOT] MATCHED are optional, if you omit one of then the syntax corresponds to an update or insert.

    -- Tables are reset, look at main method
    -- Lets insert a new dummy one
    /*
    insert into zfrpa_tab_dio_m9 ( client, employee_number, employee_name, birth_date )
        values (  SESSION_CONTEXT('CLIENT'), 00002990, 'DUMMY ENTRY', '20000101' );


    dummy_select1
    =
    select * from  zfrpa_tab_dio_m9;

    merge into zfrpa_tab_dio_m8 as target_db_table
    using zfrpa_tab_dio_m9 as source_db_table
    on ( target_db_table.serial_number = source_db_table.employee_number )
    when matched then
        update set  target_db_table.initials = INITCAP( LEFT( SUBSTR_BEFORE( source_db_table.employee_name, ' ' ), 1 ) ) || INITCAP( LEFT( SUBSTR_AFTER( source_db_table.employee_name, ' ' ), 1 ) ),
                    target_db_table.custom_date = source_db_table.birth_date
    when not matched then
        insert values ( source_db_table.client, source_db_table.employee_number, 'XX', to_dats( current_date ) );

    dummy_select2
    =
    select * from  zfrpa_tab_dio_m8;
    */
  endmethod.


  METHOD update_data_database_tab
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.
  --USING zfrpa_tab_dio_m9 zfrpa_tab_dio_m8.
 /*
    -- Cross join will be performed on the update statement

    update target_db_table
    set target_db_table.initials = INITCAP( LEFT( SUBSTR_BEFORE( source_db_table.employee_name, ' ' ), 1 ) ) || INITCAP( LEFT( SUBSTR_AFTER( source_db_table.employee_name, ' ' ), 1 ) ),
        target_db_table.custom_date = source_db_table.birth_date
    from zfrpa_tab_dio_m9 as source_db_table,
         zfrpa_tab_dio_m8 as target_db_table
    where source_db_table.employee_number = target_db_table.serial_number;

    dummy_select1
    =
    select * from  zfrpa_tab_dio_m9;

    dummy_select2
    =
    select * from  zfrpa_tab_dio_m8;
    */
  ENDMETHOD.


  METHOD insert_data_database_tab
  BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT.
  --USING zfrpa_tab_dio_m9 zfrpa_tab_dio_m8.
    /*
    -- On this example, the code was tested on SAP ON PREMISE machine
    -- modifying real db tables.

    -- M9 Table
    insert into zfrpa_tab_dio_m9 ( client, employee_number, employee_name, birth_date )
        values (  SESSION_CONTEXT('CLIENT'), 00002984, 'Nangus Dongus', '19871121' );
   insert into zfrpa_tab_dio_m9 ( client, employee_number, employee_name, birth_date )
        values (  SESSION_CONTEXT('CLIENT'), 00002985, 'Mangus Dongus', '19940112' );
   insert into zfrpa_tab_dio_m9 ( client, employee_number, employee_name, birth_date )
        values (  SESSION_CONTEXT('CLIENT'), 00002986, 'Tangus Dongus', '20061225' );
   insert into zfrpa_tab_dio_m9 ( client, employee_number, employee_name, birth_date )
        values (  SESSION_CONTEXT('CLIENT'), 00002987, 'Cangus Dongus', '20210317' );


    dummy_select1
    =
    select * from  zfrpa_tab_dio_m9;

    -- M8 table
   insert into zfrpa_tab_dio_m8 ( client, serial_number, custom_date )
        values (  SESSION_CONTEXT('CLIENT'), 00002984, '19000101' );
   insert into zfrpa_tab_dio_m8 ( client, serial_number, custom_date )
        values (  SESSION_CONTEXT('CLIENT'), 00002985, '19000101' );
   insert into zfrpa_tab_dio_m8 ( client, serial_number, custom_date )
        values (  SESSION_CONTEXT('CLIENT'), 00002986,  '19000101' );
   insert into zfrpa_tab_dio_m8 ( client, serial_number, custom_date )
        values (  SESSION_CONTEXT('CLIENT'), 00002987, '19000101' );

    dummy_select2
    =
    select * from  zfrpa_tab_dio_m8;
    */
  ENDMETHOD.



ENDCLASS.
