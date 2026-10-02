@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Testing for unions'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_basics_union_testing
  as select from zmrg_cds_02
{
  key abap.char'A' as Field1,
      abap.char'B' as Field2
}
union select from zmrg_cds_02
{
  key abap.char'B' as Field1,
      abap.char'C' as Field2
}
union all select from zmrg_cds_02
{
  key abap.char'A' as Field1,
      abap.char'B' as Field2
}
