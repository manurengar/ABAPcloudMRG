@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Aggregation anntotations'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZMRG_AGGREGATIONS
  as select from zmrg_cds_01
{
  key username                          as Username,

      @Aggregation.default: #COUNT_DISTINCT
      first_name                        as FirstName,

      last_name                         as LastName,

      cast( 'EUR' as abap.cuky( 5 ) )   as Currency,

      @Semantics.amount.currencyCode: 'Currency'
      @Aggregation.default: #SUM
      cast( 100 as abap.curr( 15, 2 ) ) as AmountSum,

      @Semantics.amount.currencyCode: 'Currency'
      @Aggregation.default: #AVG
      cast( 100 as abap.curr( 15, 2 ) ) as AmountAvg,

      @Semantics.amount.currencyCode: 'Currency'
      @Aggregation.default: #MIN
      cast( 100 as abap.curr( 15, 2 ) ) as AmountMin,

      @Semantics.amount.currencyCode: 'Currency'
      @Aggregation.default: #MAX
      cast( 100 as abap.curr( 15, 2 ) ) as AmountMax,

      @Semantics.amount.currencyCode: 'Currency'
      @Aggregation.default: #NONE
      cast( 100 as abap.curr( 15, 2 ) ) as AmountNone
}
union all select from zmrg_cds_01
{
  key username                          as Username,
      first_name                        as FirstName,
      last_name                         as LastName,
      cast( 'USD' as abap.cuky( 5 ) )   as Currency,
      cast( 200 as abap.curr( 15, 2 ) ) as AmountSum,
      cast( 200 as abap.curr( 15, 2 ) ) as AmountAvg,
      cast( 200 as abap.curr( 15, 2 ) ) as AmountMin,
      cast( 200 as abap.curr( 15, 2 ) ) as AmountMax,
      cast( 200 as abap.curr( 15, 2 ) ) as AmountNone
}
