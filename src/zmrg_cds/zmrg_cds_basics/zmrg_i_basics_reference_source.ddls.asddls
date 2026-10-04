@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reference fields source'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_basics_reference_source
  as select from zmrg_cds_01
{
  @Semantics.quantity.unitOfMeasure: 'Unit'
  abap.quan'2000.00'  as Quantity,
  abap.unit'PC'       as Unit,
  @Semantics.amount.currencyCode: 'Currency'
  abap.curr'38499.53' as TotalAmount,
  abap.cuky'EUR'      as Currency
}
