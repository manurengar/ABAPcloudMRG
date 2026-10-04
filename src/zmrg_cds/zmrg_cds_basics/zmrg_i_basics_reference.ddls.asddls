@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reference quantities and amounts'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_basics_reference
  as select from zmrg_i_basics_reference_source
{
  @Semantics.quantity.unitOfMeasure: 'Unit'
  Quantity,
  Unit,
  @Semantics.amount.currencyCode: 'Currency'
  TotalAmount,
  Currency,
  get_numeric_value(TotalAmount) as NumericValueTotal,
  @Semantics.amount.currencyCode: 'Currency'
  curr_to_decfloat_amount(TotalAmount) * 6                                 as CurrencyAsDecFloat,
  @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
  get_numeric_value(TotalAmount) / $projection.quantity                    as PricePerUnit,
  cast( concat(Currency, concat('/', Unit) ) as zmrg_cds_unit_of_measure ) as UnitOfMeasure
}
