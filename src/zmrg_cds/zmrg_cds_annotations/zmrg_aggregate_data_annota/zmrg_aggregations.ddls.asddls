@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Aggregation anntotations'
@Metadata.ignorePropagatedAnnotations: true

// @Aggregation.default is a metadata annotation evaluated by analytical and UI frameworks rather than the database/SQL layer:

// •  ABAP Analytical Engine / Analytical Queries (`@Analytics.query: true` / `provider contract analytical_query`):

//When you expose `ZMRG_AGGREGATIONS` in a RAP OData V4 service (UI or Web API), SADL translates @Aggregation.default into Org.OData.Aggregation.V1 annotations in $metadata:

//    •  Fields with #SUM, #AVG, #MIN, #MAX, #COUNT_DISTINCT are exposed as aggregatable measures (CustomAggregate / AggregatableProperties).
//    •  #NONE explicitly tells OData V4 / UI clients not to aggregate AmountNone by default.
//    •  Unannotated fields (Username, LastName, Currency) can be used as groupable dimensions (GroupableProperties).
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
