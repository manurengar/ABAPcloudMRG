@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Average flight price per company and connection'
@Metadata.ignorePropagatedAnnotations: true
define view entity Zmrg_i_basics_avg_flight_price
  as select from /dmo/flight
{
  key carrier_id                         as AirlineID,
  key connection_id                      as ConnectionId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      avg( price as abap.curr( 16, 2 ) ) as AveragePrice,
      currency_code                      as CurrencyCode
}
group by
  carrier_id,
  connection_id,
  currency_code
