@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Aggregation functions showcase'
@Metadata.ignorePropagatedAnnotations: false
define view entity zmrg_i_basics_group_functions
  as select from zmrg_i_basics_group_source1
{
  key personnel_number,
  key wage_type,
      currency,
      @Semantics.amount.currencyCode: 'currency'
      sum( amount )                   as SumAmount,
      sum(quantity)                   as SumQuantity,
      min(quantity)                   as MinQuantity,
      max(quantity)                   as MaxQuantity,
      count(*)                        as NumberOfEntriesPerGroup,
      @Semantics.amount.currencyCode: 'currency'
      avg( amount as abap.curr(6,2) ) as AverageAmount
}
group by
  personnel_number,
  wage_type,
  currency
