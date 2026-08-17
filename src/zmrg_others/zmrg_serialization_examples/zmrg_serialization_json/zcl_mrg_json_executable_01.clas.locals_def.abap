CLASS lcl_child DEFINITION FRIENDS /ui2/cl_json.
  PUBLIC SECTION.
    TYPES tt_sflight TYPE STANDARD TABLE OF /dmo/flight WITH DEFAULT KEY.

    DATA:
        pub_attr TYPE string VALUE 'public_att'.

    METHODS: constructor.
  PRIVATE SECTION.
    DATA:
      priv_attr       TYPE string VALUE 'private_att',
      ref_sflight_gen TYPE REF TO data,
      ref_sflight     TYPE REF TO tt_sflight.


ENDCLASS.

CLASS lcl_parent DEFINITION FRIENDS /ui2/cl_json.
  PUBLIC SECTION.
    DATA: parent_name TYPE string.
    DATA: child_ref   TYPE REF TO lcl_child.

    METHODS constructor.
  PRIVATE SECTION.
    DATA: parent_secret TYPE string VALUE 'Secret state'.
ENDCLASS.
