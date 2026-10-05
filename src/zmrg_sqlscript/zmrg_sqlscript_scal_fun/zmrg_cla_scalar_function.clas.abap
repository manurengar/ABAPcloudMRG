CLASS zmrg_cla_scalar_function DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .

    CLASS-METHODS add_values
        FOR SCALAR FUNCTION zmrg_scal_add_values.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zmrg_cla_scalar_function IMPLEMENTATION.
  METHOD add_values
  BY DATABASE FUNCTION FOR HDB
  LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY.
    -- This method is used on CDS: zmrg_basics_scalar_function_01
    result = :p_left + :p_right;
  ENDMETHOD.

ENDCLASS.
