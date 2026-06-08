CLASS zmrg_cla_auth_run DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zmrg_cla_auth_run IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA(o_auth_ref) = zmrg_cla_auth_util=>get_instance( xco_cp=>sy->user( )->name ).


*    o_auth_ref->grant_field_to_role( role_name = 'ZMRG_APP_EMP_USER'
*                                     auth_obj  = 'ZMRG_EMP'
*                                     auth_field = 'ACTVT'
*                                     auth_value = '03' ).

    DATA key_values TYPE zmrg_cla_auth_util=>ty_field_value_tab.

    key_values = VALUE #( ( auth_field = 'ACTVT' auth_value = '02' )
                          ( auth_field = 'Z_NATIO' auth_value = 'ES' ) ).

    o_auth_ref->is_authorized( auth_obj = 'ZMRG_EMP'
                               field_value_pairs = key_values ).
    "o_auth_ref->grant_user_role( role_name = 'ZMRG_APP_EMP_USER' ).

  ENDMETHOD.
ENDCLASS.
