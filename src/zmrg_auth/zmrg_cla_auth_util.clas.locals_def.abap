TYPES: BEGIN OF ty_instance_str,
         user_name TYPE zmrg_auth_user_name,
         instance  TYPE REF TO zmrg_cla_auth_util,
       END OF ty_instance_str,
       ty_instance_tab TYPE HASHED TABLE OF ty_instance_Str WITH UNIQUE KEY primary_key COMPONENTS user_name.


TYPES: BEGIN OF ty_auth_str,
         user_name   TYPE zmrg_auth_user_name,
         auth_object TYPE zmrg_auth_object_name,
         auth_values TYPE string,
       END OF TY_AUTH_str,
       ty_auth_tab TYPE HASHED TABLE OF ty_auth_str WITH UNIQUE KEY primary_key COMPONENTS user_name auth_object.
