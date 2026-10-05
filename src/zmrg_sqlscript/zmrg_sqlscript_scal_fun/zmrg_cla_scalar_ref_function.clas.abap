CLASS zmrg_cla_scalar_ref_function DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .

    CLASS-METHODS ternary_operator
        FOR SCALAR FUNCTION zmrg_scal_ternary_operator.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zmrg_cla_scalar_ref_function IMPLEMENTATION.
  METHOD ternary_operator
  BY DATABASE FUNCTION FOR HDB
  LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY.
    -- This METHOD is used ON CDS: zmrg_scal_ternary_operator
      result =
                CASE :operator
                  WHEN '+' THEN :q1 + :q2
                  WHEN '-' THEN :q1 - :q2
                  WHEN '*' THEN :q1 * :q2
                  when '/' then :q1 / nullif( :q2, 0 )
                  ELSE NULL
                END;
  ENDMETHOD.

ENDCLASS.
