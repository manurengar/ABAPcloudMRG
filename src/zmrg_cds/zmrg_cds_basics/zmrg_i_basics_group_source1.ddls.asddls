@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Source cds for grouping example'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_basics_group_source1
  as select distinct from zmrg_cds_01
{
  key abap.numc'1820001'  as personnel_number,
  key abap.dats'18000101' as start_date,
  key abap.dats'99991231' as end_date,
  key abap.char'9E01'     as wage_type,
      abap.cuky'EUR'      as currency,
      @Semantics.amount.currencyCode: 'currency'
      abap.curr'1899.00'  as amount,
      abap.dec'10.00'     as quantity
}
union select from zmrg_cds_01
{
  key abap.numc'1820001'  as personnel_number,
  key abap.dats'20230101' as start_date,
  key abap.dats'20230630' as end_date,
  key abap.char'9E02'     as wage_type,
      abap.cuky'EUR'      as currency,

      abap.curr'1500.00'  as amount,
      abap.dec'8.00'      as quantity
}
union all select from zmrg_cds_01
{
  key abap.numc'1820001'  as personnel_number,
  key abap.dats'20230701' as start_date,
  key abap.dats'20231231' as end_date,
  key abap.char'9E01'     as wage_type,
      abap.cuky'EUR'      as currency,

      abap.curr'1650.50'  as amount,
      abap.dec'9.50'      as quantity
}
union all select from zmrg_cds_01
{
  key abap.numc'1820001'  as personnel_number,
  key abap.dats'20240101' as start_date,
  key abap.dats'20241231' as end_date,
  key abap.char'9E03'     as wage_type,
      abap.cuky'EUR'      as currency,

      abap.curr'1899.00'  as amount,
      abap.dec'10.00'     as quantity
}
union all select from zmrg_cds_01
{
  key abap.numc'1820001'  as personnel_number,
  key abap.dats'20250101' as start_date,
  key abap.dats'99991231' as end_date,
  key abap.char'9E03'     as wage_type,
      abap.cuky'EUR'      as currency,

      abap.curr'2050.75'  as amount,
      abap.dec'12.00'     as quantity
}
union all select from zmrg_cds_01
{
  key abap.numc'1820002'  as personnel_number,
  key abap.dats'20220101' as start_date,
  key abap.dats'20221231' as end_date,
  key abap.char'9E02'     as wage_type,
      abap.cuky'EUR'      as currency,

      abap.curr'1200.00'  as amount,
      abap.dec'5.00'      as quantity
}
union all select from zmrg_cds_01
{
  key abap.numc'1820002'  as personnel_number,
  key abap.dats'20230101' as start_date,
  key abap.dats'20231231' as end_date,
  key abap.char'9E01'     as wage_type,
      abap.cuky'EUR'      as currency,

      abap.curr'1400.25'  as amount,
      abap.dec'7.50'      as quantity
}
union all select from zmrg_cds_01
{
  key abap.numc'1820002'  as personnel_number,
  key abap.dats'20240101' as start_date,
  key abap.dats'99991231' as end_date,
  key abap.char'9E01'     as wage_type,
      abap.cuky'EUR'      as currency,

      abap.curr'1750.00'  as amount,
      abap.dec'11.00'     as quantity
}
union all select from zmrg_cds_01
{
  key abap.numc'1820003'  as personnel_number,
  key abap.dats'20210601' as start_date,
  key abap.dats'20220531' as end_date,
  key abap.char'9E01'     as wage_type,
      abap.cuky'EUR'      as currency,

      abap.curr'980.50'   as amount,
      abap.dec'4.00'      as quantity
}
union all select from zmrg_cds_01
{
  key abap.numc'1820003'  as personnel_number,
  key abap.dats'20220601' as start_date,
  key abap.dats'20230531' as end_date,
  key abap.char'9E01'     as wage_type,
      abap.cuky'EUR'      as currency,
      abap.curr'1120.00'  as amount,
      abap.dec'6.50'      as quantity
}
union all select from zmrg_cds_01
{
  key abap.numc'1820003'  as personnel_number,
  key abap.dats'20230601' as start_date,
  key abap.dats'99991231' as end_date,
  key abap.char'9E02'     as wage_type,
      abap.cuky'EUR'      as currency,

      abap.curr'1350.80'  as amount,
      abap.dec'15.00'     as quantity
}
