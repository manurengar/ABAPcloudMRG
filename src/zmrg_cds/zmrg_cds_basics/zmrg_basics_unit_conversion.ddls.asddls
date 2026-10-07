@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for unit conversion_example'
define view entity zmrg_basics_unit_conversion
  as select from zmrg_basics_conversion_source
  // Units found at T006 table
{
  key DummyKey,
      SourceQuantity,
      SourceUnit,
      @Semantics.quantity.unitOfMeasure: 'ConvertedUnit'
      unit_conversion( source_unit => SourceUnit,
                       quantity => SourceQuantity,
                       target_unit => abap.unit'G',
                       error_handling => 'SET_TO_NULL' )         as ConvertedQuantity,
      cast('G' as zmrg_typ_unit)                                 as ConvertedUnit,
      SourceCurrency,
      SourceAmount,
      abap.cuky'USD'                                             as ConvertedCurrency,
      @Semantics.amount.currencyCode: 'ConvertedCurrency'
      currency_conversion( amount => SourceAmount,
                           source_currency => SourceCurrency,
                           target_currency => $projection.ConvertedCurrency,
                           exchange_rate_date => $session.system_date,
                           exchange_rate_type => 'M',
                           error_handling     => 'SET_TO_NULL' ) as ConvertedAmount
}
where
      SourceUnit     = abap.unit'KG'
  and SourceCurrency = abap.cuky'EUR'
