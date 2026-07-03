CLASS zcx_mrg_rap_01_messages DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_abap_behv_message.


    CONSTANTS:
      BEGIN OF not_authorized,
        msgid TYPE symsgid VALUE 'ZMRG_RAP_01',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'ACTIVITY',
        attr2 TYPE scx_attrname VALUE 'TABLE_NAME_01',
        attr3 TYPE scx_attrname VALUE 'TABLE_NAME_02',
        attr4 TYPE scx_attrname VALUE 'TABLE_NAME_03',
      END OF not_authorized,

      BEGIN OF not_authorized_for_nationality,
        msgid TYPE symsgid VALUE 'ZMRG_RAP_01',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'ACTIVITY',
        attr2 TYPE scx_attrname VALUE 'NATIONALITY',
        attr3 TYPE scx_attrname VALUE 'EMPLOYEE_ID',
        attr4 TYPE scx_attrname VALUE '',
      END OF not_authorized_for_nationality,

      BEGIN OF no_range_key_found,
        msgid TYPE symsgid VALUE 'ZMRG_RAP_01',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'RANGE_KEY',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF no_range_key_found,

      BEGIN OF age_out_of_bounds,
        msgid TYPE symsgid VALUE 'ZMRG_RAP_01',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE 'AGE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF age_out_of_bounds,

      BEGIN OF percentage_out_of_bounds,
        msgid TYPE symsgid VALUE 'ZMRG_RAP_01',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE 'PERCENTAGE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF percentage_out_of_bounds,

      BEGIN OF incorrect_gross_salary,
        msgid TYPE symsgid VALUE 'ZMRG_RAP_01',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE 'GROSS_SALARY',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF incorrect_gross_salary,

      BEGIN OF incorrect_start_date,
        msgid TYPE symsgid VALUE 'ZMRG_RAP_01',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE 'START_DATE',
        attr2 TYPE scx_attrname VALUE 'END_DATE',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF incorrect_start_date,

      BEGIN OF split_collision,
        msgid TYPE symsgid VALUE 'ZMRG_RAP_01',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE 'START_DATE',
        attr2 TYPE scx_attrname VALUE 'END_DATE',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF split_collision.

    DATA:
      activity      TYPE zmrg_auth_field_value,
      table_name_01 TYPE zmrg_auth_field_value,
      table_name_02 TYPE zmrg_auth_field_value,
      table_name_03 TYPE zmrg_auth_field_value,
      nationality   TYPE land1,
      employee_id   TYPE zmrg_employee_id,
      range_key     TYPE zmrg_emp_char02,
      age           TYPE zmrg_employee_age,
      start_date    TYPE begda,
      end_date      TYPE endda,
      gross_salary  TYPE betrg,
      percentage    TYPE zmrg_employee_percentage.


    METHODS constructor
      IMPORTING
        textid        LIKE if_t100_message=>t100key OPTIONAL
        previous      LIKE previous                 OPTIONAL
        severity      TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        activity      TYPE zmrg_auth_field_value           OPTIONAL
        table_name_01 TYPE zmrg_auth_field_value           OPTIONAL
        table_name_02 TYPE zmrg_auth_field_value           OPTIONAL
        table_name_03 TYPE zmrg_auth_field_value           OPTIONAL
        age           TYPE zmrg_employee_age OPTIONAL
        nationality   TYPE land1 OPTIONAL
        employee_id   TYPE zmrg_employee_id OPTIONAL
        start_date    TYPE begda OPTIONAL
        end_date      TYPE endda OPTIONAL
        gross_salary  TYPE betrg OPTIONAL
        range_key     TYPE zmrg_emp_char02 OPTIONAL
        percentage    TYPE zmrg_employee_percentage OPTIONAL.
ENDCLASS.

CLASS zcx_mrg_rap_01_messages IMPLEMENTATION.
  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).
    me->activity       = activity.
    me->table_name_01  = table_name_01.
    me->table_name_02  = table_name_02.
    me->table_name_03  = table_name_03.
    me->nationality    = nationality.
    me->start_date     = start_date.
    me->employee_id    = employee_id.
    me->range_key      = range_key.
    me->end_date       = end_date.
    me->percentage     = percentage.
    me->gross_salary   = gross_salary.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    me->if_abap_behv_message~m_severity = severity.
  ENDMETHOD.
ENDCLASS.
