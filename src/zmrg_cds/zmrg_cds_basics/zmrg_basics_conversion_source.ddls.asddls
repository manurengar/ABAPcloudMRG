@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unit & currency conversions source'
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.entityBuffer.definitionAllowed: true
define view entity zmrg_basics_conversion_source
  as select from zmrg_cds_01
{
  key abap.int4'1'                         as DummyKey,
      @Semantics.quantity.unitOfMeasure: 'SourceUnit'
      cast( 6.2 as zmrg_typ_quantity_6_2 ) as SourceQuantity,
      cast('KG' as zmrg_typ_unit)          as SourceUnit,
      @Semantics.amount.currencyCode: 'SourceCurrency'
      cast( 3002.12 as abap.curr( 6, 2 ) ) as SourceAmount,
      cast( 'USD' as abap.cuky( 5 ) )      as SourceCurrency

}
union all select from zmrg_cds_01
{
  key abap.int4'2'                          as DummyKey,
      cast( 10.5 as zmrg_typ_quantity_6_2 ) as SourceQuantity,
      cast( 'KG' as zmrg_typ_unit )         as SourceUnit,
      cast( 1500.50 as abap.curr( 6, 2 ) )  as SourceAmount,
      cast( 'EUR' as abap.cuky( 5 ) )       as SourceCurrency
}
union all select from zmrg_cds_01
{
  key abap.int4'3'                          as DummyKey,
      cast( 2.75 as zmrg_typ_quantity_6_2 ) as SourceQuantity,
      cast( 'KG' as zmrg_typ_unit )         as SourceUnit,
      cast( 750.25 as abap.curr( 6, 2 ) )   as SourceAmount,
      cast( 'GBP' as abap.cuky( 5 ) )       as SourceCurrency
}
union all select from zmrg_cds_01
{
  key abap.int4'4'                          as DummyKey,
      cast( 15.0 as zmrg_typ_quantity_6_2 ) as SourceQuantity,
      cast( 'KG' as zmrg_typ_unit )          as SourceUnit,
      cast( 4200.00 as abap.curr( 6, 2 ) )  as SourceAmount,
      cast( 'EUR' as abap.cuky( 5 ) )       as SourceCurrency
}
union all select from zmrg_cds_01
{
  key abap.int4'5'                          as DummyKey,
      cast( 8.25 as zmrg_typ_quantity_6_2 ) as SourceQuantity,
      cast( 'M' as zmrg_typ_unit )          as SourceUnit,
      cast( 2300.75 as abap.curr( 6, 2 ) )  as SourceAmount,
      cast( 'EUR' as abap.cuky( 5 ) )       as SourceCurrency
}
