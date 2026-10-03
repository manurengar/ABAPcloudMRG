@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Testing for unions'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMRG_I_BASICS_UNION_TESTING2
  as select from zmrg_cds_02
{
  key abap.char'A' as Field1,
      abap.char'1' as Field2,
      abap.dats'20250101' as Field3
}
union select from zmrg_cds_02
{
  key abap.char'B' as Field1,
      abap.char'C' as Field2,
      abap.dats'20260101' as Field3
}
union  select from zmrg_cds_02
{
  key abap.char'B' as Field1,
      abap.char'X' as Field2,
      abap.dats'20260601' as Field3
}
union select from zmrg_cds_02
{
  key abap.char'A' as Field1,
      abap.char'2' as Field2,
      abap.dats'20250701' as Field3
}
union  select from zmrg_cds_02
{
  key abap.char'T' as Field1,
      abap.char'M' as Field2,
      abap.dats'20261231' as Field3
}
