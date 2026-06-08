"! <strong>Authorization utility for MRG package custom developments</strong>
"!
"! <p>Provides a per-user (multiton) entry point for granting authorization roles
"! and authorization-object field values. On instantiation, the current user's
"! valid authorizations and their resolved authorization objects are loaded and
"! cached on the instance.</p>
"!
"! <p>Example usage:</p>
"!
"! <p>DATA(o_auth_ref) = zmrg_cla_auth_util=>get_instance( xco_cp=>sy->user( )->name ).</p>
"!
"! <p>o_auth_ref->grant_user_role( role_name = 'ZMRG_APP_EMP_USER' ).</p>
"!
"! <p>o_auth_ref->grant_field_to_role( role_name  = 'ZMRG_APP_EMP_USER'
"!                                  auth_obj   = 'ZMRG_EMP'
"!                                  auth_field = 'Z_NATIO'
"!                                  auth_value = 'ES' ).</p>
"!     DATA key_values TYPE zmrg_cla_auth_util=>ty_field_value_tab.
"!
"!    key_values = VALUE #( ( auth_field = 'ACTVT' auth_value = '02' )
"!                          ( auth_field = 'Z_NATIO' auth_value = 'ES' ) ).
"!
"!    o_auth_ref->is_authorized( auth_obj = 'ZMRG_EMP'
"!                               field_value_pairs = key_values ).
CLASS zmrg_cla_auth_util DEFINITION
  PUBLIC
  CREATE PRIVATE .

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_field_value_str,
             auth_field TYPE zmrg_auth_field,
             auth_value TYPE zmrg_auth_field_value,
           END OF ty_field_value_str,
           ty_field_value_tab TYPE TABLE OF ty_field_value_str WITH DEFAULT KEY.
    CLASS-DATA:
        co_end_date TYPE d VALUE '99991231'.

    CLASS-METHODS:
      "! Singleton instance per user name (multiton)
      "!
      "! @parameter user_name | User name can be obtained with xco_cp=>sy->user( )->name
      get_instance
        IMPORTING user_name          TYPE zmrg_auth_user_name
        RETURNING VALUE(ro_instance) TYPE REF TO zmrg_cla_auth_util.


    METHODS:
      "! <strong>Grant or update a user authorization role</strong>
      "!
      "! Grants an authorization role to the current user instance, or updates the
      "! validity dates if the role is already assigned. The full set of user
      "! authorizations is persisted to table <em>ZMRG_AUTH_USER</em> and committed.
      "!
      "! <p>If the role already exists for the user, only <em>start_date</em> and
      "! <em>end_date</em> are updated. Otherwise a new entry is inserted, with
      "! defaulting applied only on insert: an initial <em>start_date</em> defaults
      "! to <em>me->curr_date</em> and an initial <em>end_date</em> to <em>co_end_date</em>.</p>
      "!
      "! @parameter role_name | Name of the authorization role to grant or update
      "! @parameter start_date | Validity start date. If initial on insert, defaults to me->curr_date
      "! @parameter end_date | Validity end date. If initial on insert, defaults to co_end_date
      grant_user_role
        IMPORTING
          role_name  TYPE zmrg_auth_role_name
          start_date TYPE begda OPTIONAL
          end_Date   TYPE endda OPTIONAL,
      "! Grants an authorization field value to a role within an authorization object.
      "!
      "! <p>If the authorization object does not yet exist on the role, a new entry is
      "! created with sequence number '00'. If the exact field/value combination already
      "! exists, its value is reassigned. If the field exists with a different value, the
      "! sequence number is incremented and a new entry is added.</p>
      "!
      "! @parameter role_name  | Target role to which the authorization field is granted.
      "! @parameter auth_obj   | Authorization object name.
      "! @parameter auth_field | Authorization field within the object.
      "! @parameter auth_value | Value to assign to the authorization field.
      grant_field_to_role
        IMPORTING
          role_name  TYPE zmrg_auth_role_name
          auth_obj   TYPE zmrg_auth_object_name
          auth_field TYPE zmrg_auth_field
          auth_value TYPE zmrg_auth_field_value,

      is_authorized
        IMPORTING
                  auth_obj             TYPE zmrg_auth_object_name
                  field_value_pairs    TYPE ty_field_value_tab
        RETURNING VALUE(is_authorized) TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      constructor IMPORTING user_name TYPE zmrg_auth_user_name,
      calculate_auth_objects.

    CLASS-DATA:
        instances_tab TYPE ty_instance_tab.
    DATA:
      user_name                  TYPE zmrg_auth_user_name,
      curr_date                  TYPE d,
      user_authorizations        TYPE TABLE OF zmrg_auth_user WITH DEFAULT KEY,
      authorization_objects      TYPE HASHED TABLE OF zmrg_auth_object WITH UNIQUE KEY primary_key COMPONENTS role_name auth_obj auth_field seqnr,
      user_authorization_objects TYPE ty_auth_tab.
ENDCLASS.



CLASS zmrg_cla_auth_util IMPLEMENTATION.
  METHOD constructor.
    me->curr_date = xco_cp=>sy->date( xco_cp_time=>time_zone->user )->as( io_format =  xco_cp_time=>format->abap )->value.
    me->user_name = user_name.
    me->calculate_auth_objects( ).
  ENDMETHOD.

  METHOD get_instance.
    ASSIGN instances_tab[ KEY primary_key COMPONENTS user_name = user_name ] TO FIELD-SYMBOL(<instance>).
    IF sy-subrc IS INITIAL.
      ro_instance = <instance>-instance.
    ELSE.
      INSERT VALUE #( user_name = user_name
                      instance  = NEW zmrg_cla_auth_util( user_name ) ) INTO TABLE instances_tab ASSIGNING <instance>.
      ro_instance = <instance>-instance.
    ENDIF.
  ENDMETHOD.

  METHOD calculate_auth_objects.

    " Prepare the data by singleton instance to perform the auth. calculations
    SELECT *
    FROM zmrg_auth_user
    WHERE user_name = @me->user_name
      AND start_date LE @me->curr_date
      AND end_Date GE @me->curr_date
    INTO TABLE @me->user_authorizations.

    SELECT *
    FROM zmrg_auth_object
    FOR ALL ENTRIES IN @me->user_authorizations
    WHERE role_name = @me->user_authorizations-role_name
    INTO TABLE @me->authorization_objects.

    SORT me->authorization_objects BY role_name auth_obj auth_field seqnr DESCENDING.

    LOOP AT me->authorization_objects ASSIGNING FIELD-SYMBOL(<auth_object>)
        GROUP BY ( authorization_object = <auth_object>-auth_obj )
        ASSIGNING FIELD-SYMBOL(<auth_obj_group>).


      INSERT VALUE #( user_name = me->user_name
                      auth_object = <auth_obj_group>-authorization_object
                      auth_values = REDUCE string( INIT field_chain = ``
                                                   FOR <field> IN GROUP <auth_obj_group>
                                                   NEXT field_chain = field_chain && |{ <field>-auth_field }={ <field>-auth_value };| ) ) INTO TABLE user_authorization_objects.
    ENDLOOP.
  ENDMETHOD.

  METHOD grant_user_role.
    ASSIGN me->user_authorizations[ role_name = role_name ] TO FIELD-SYMBOL(<rol>).
    IF sy-subrc IS INITIAL.
      <rol>-start_Date = start_date.
      <rol>-end_date = end_date.
    ELSE.
      INSERT VALUE #( user_name = me->user_name
                      start_date = COND #( WHEN start_date IS INITIAL THEN me->curr_date ELSE start_date )
                      end_Date   = COND #( WHEN end_Date IS INITIAL THEN co_end_date ELSE end_date )
                      role_name  = role_name ) INTO TABLE me->user_authorizations.
    ENDIF.

    MODIFY zmrg_auth_user FROM TABLE @me->user_authorizations.
    COMMIT WORK.
  ENDMETHOD.

  METHOD grant_field_to_role.
    DATA:
      filtered_auth_obj_tab LIKE me->authorization_objects,
      new_auth_obj_line     LIKE LINE OF me->authorization_objects.

    CHECK auth_field IS NOT INITIAL.

    filtered_auth_obj_tab = VALUE #( FOR wa IN me->authorization_objects
                                     WHERE ( role_name  = role_name
                                       AND   auth_obj   = auth_obj )
                                     ( wa ) ).

    " Auth. object does not exists on role
    IF filtered_auth_obj_tab IS INITIAL.
      INSERT VALUE #( auth_obj    = auth_obj
                      role_name   = role_name
                      auth_field  = auth_field
                      seqnr       = '00'
                      auth_value  = auth_value  ) INTO TABLE me->authorization_objects.

      MODIFY zmrg_auth_object FROM TABLE @me->authorization_objects.
      COMMIT WORK.
      RETURN.
    ENDIF.

    ASSIGN filtered_auth_obj_tab[ auth_obj   = auth_obj
                                  auth_field = auth_field ] TO FIELD-SYMBOL(<auth_obj>).
    IF sy-subrc IS INITIAL.

      DATA(max_seqnr) = COND zmrg_auth_seqnr( WHEN sy-subrc IS INITIAL THEN <auth_obj>-seqnr + 1 ELSE '00' ).

      new_auth_obj_line = VALUE #( auth_obj   = cond #( when <auth_obj> is assigned then <auth_obj>-auth_obj else auth_obj )
                                   auth_field = cond #( when <auth_obj> is assigned then <auth_obj>-auth_field else auth_field )
                                   auth_value = auth_value
                                   role_name  = role_name
                                   seqnr      = max_seqnr ).

      INSERT new_auth_obj_line INTO TABLE me->authorization_objects.

      SORT me->authorization_objects BY role_name auth_obj auth_field auth_value DESCENDING.
      DELETE ADJACENT DUPLICATES FROM me->authorization_objects COMPARING auth_value.
    ENDIF.

    MODIFY zmrg_auth_object FROM TABLE @me->authorization_objects.
    COMMIT WORK.
  ENDMETHOD.

  METHOD is_authorized.
    DATA:
      field_values_string_table TYPE TABLE OF string WITH DEFAULT KEY,
      field_values_table        TYPE ty_field_value_tab.

    " Check if the user is authorized for this auth. object / fields
    ASSIGN me->user_authorization_objects[ KEY primary_key
                                           COMPONENTS user_name   = user_name
                                                      auth_object = auth_obj ] TO FIELD-SYMBOL(<auth_obj>).
    SPLIT <auth_obj>-auth_values AT ';' INTO TABLE field_values_string_table.

    field_values_table = VALUE #( BASE field_values_table
                                  FOR <row> IN field_values_string_table
                                  ( auth_field = segment( val = <row> index = 1 sep = `=` )
                                    auth_value = segment( val = <row> index = 2 sep = `=` )
                                   )
                                 ).

    LOOP AT field_value_pairs ASSIGNING FIELD-SYMBOL(<input_field_value>).
      IF NOT line_exists( field_values_table[ auth_field = <input_field_value>-auth_field
                                              auth_value = <input_field_value>-auth_value ] ).
        is_authorized = abap_false.
        RETURN.
      ENDIF.
    ENDLOOP.

    is_authorized = abap_true.

  ENDMETHOD.

ENDCLASS.
