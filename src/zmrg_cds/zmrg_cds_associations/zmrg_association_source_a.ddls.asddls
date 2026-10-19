@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Source association A'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_association_source_a
  as select from zmrg_cds_01
{
  key abap.char'NIG' as KeyColumn,
      abap.cuky'EUR' as Currency,
      abap.int1'1'   as ColNumber
}
union select from zmrg_cds_01
{
  key abap.char'USA' as KeyColumn,
      abap.cuky'USD' as Currency,
      abap.int1'2'   as ColNumber
}
union select from zmrg_cds_01
{
  key abap.char'GBR' as KeyColumn,
      abap.cuky'GBP' as Currency,
      abap.int1'3'   as ColNumber
}
union select from zmrg_cds_01
{
  key abap.char'JPN' as KeyColumn,
      abap.cuky'JPY' as Currency,
      abap.int1'4'   as ColNumber
}
union select from zmrg_cds_01
{
  key abap.char'CHE' as KeyColumn,
      abap.cuky'CHF' as Currency,
      abap.int1'5'   as ColNumber
}
union select from zmrg_cds_01
{
  key abap.char'CAN' as KeyColumn,
      abap.cuky'CAD' as Currency,
      abap.int1'6'   as ColNumber
}
union select from zmrg_cds_01
{
  key abap.char'AUS' as KeyColumn,
      abap.cuky'AUD' as Currency,
      abap.int1'7'   as ColNumber
}
union select from zmrg_cds_01
{
  key abap.char'BRA' as KeyColumn,
      abap.cuky'BRL' as Currency,
      abap.int1'8'   as ColNumber
}
union select from zmrg_cds_01
{
  key abap.char'MEX' as KeyColumn,
      abap.cuky'MXN' as Currency,
      abap.int1'9'   as ColNumber
}
union select from zmrg_cds_01
{
  key abap.char'IND' as KeyColumn,
      abap.cuky'INR' as Currency,
      abap.int1'10'  as ColNumber
}
