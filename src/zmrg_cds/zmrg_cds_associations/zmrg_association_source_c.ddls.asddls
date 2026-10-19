@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Source association C'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMRG_ASSOCIATION_SOURCE_C
  as select from zmrg_cds_01
{
  key abap.int1'1'        as Col1,
  key abap.char'A'        as Col2,
      abap.string'MassNe' as Col3
}
union all select from zmrg_cds_01
{
  key abap.int1'1'        as Col1,
  key abap.char'B'        as Col2,
      abap.string'Alpha1' as Col3
}
union all select from zmrg_cds_01
{
  key abap.int1'2'        as Col1,
  key abap.char'A'        as Col2,
      abap.string'Beta01' as Col3
}
union all select from zmrg_cds_01
{
  key abap.int1'2'        as Col1,
  key abap.char'B'        as Col2,
      abap.string'Beta02' as Col3
}
union all select from zmrg_cds_01
{
  key abap.int1'3'        as Col1,
  key abap.char'A'        as Col2,
      abap.string'Gamma1' as Col3
}
union all select from zmrg_cds_01
{
  key abap.int1'3'        as Col1,
  key abap.char'C'        as Col2,
      abap.string'Gamma2' as Col3
}
union all select from zmrg_cds_01
{
  key abap.int1'5'        as Col1,
  key abap.char'A'        as Col2,
      abap.string'Delta1' as Col3
}
union all select from zmrg_cds_01
{
  key abap.int1'5'        as Col1,
  key abap.char'B'        as Col2,
      abap.string'Delta2' as Col3
}
union all select from zmrg_cds_01
{
  key abap.int1'8'        as Col1,
  key abap.char'A'        as Col2,
      abap.string'Epsil1' as Col3
}
union all select from zmrg_cds_01
{
  key abap.int1'8'        as Col1,
  key abap.char'D'        as Col2,
      abap.string'Epsil2' as Col3
}
