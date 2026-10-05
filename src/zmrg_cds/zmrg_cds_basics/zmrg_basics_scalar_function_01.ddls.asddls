@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Example for scalar function'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_basics_scalar_function_01
  as select from zmrg_cds_01
{
  key username                                                                                   as Username,
      first_name                                                                                 as FirstName,
      last_name                                                                                  as LastName,
      abap.int4'16'                                                                              as LeftValue,
      abap.int4'4'                                                                               as RightValue,
      zmrg_scal_add_values( p_left => $projection.LeftValue, p_right => $projection.RightValue ) as ScalarResult
}
