@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Case statement example'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_basics_case_statement
  as select from /DMO/I_Flight
  association [1..1] to Zmrg_i_basics_avg_flight_price as _AvgPrice on  $projection.AirlineID    = _AvgPrice.AirlineID
                                                                    and $projection.ConnectionID = _AvgPrice.ConnectionId

{
  key AirlineID,
  key ConnectionID,
      FlightDate,
      case
        when OccupiedSeats < MaximumSeats then cast( 'X' as abap_boolean )
        else cast( '' as abap_boolean )
      end  as IsFlightAvailable,
      case
        when Price is initial or Price = 0 then cast( 0 as zmrg_cds_budget )
        when get_numeric_value(Price) < get_numeric_value(_AvgPrice.AveragePrice) * abap.decfloat34'0.7' then cast(1 as zmrg_cds_budget)
        when Price < _AvgPrice.AveragePrice then cast(2 as zmrg_cds_budget)
        when Price = _AvgPrice.AveragePrice then cast(3 as zmrg_cds_budget)
        when get_numeric_value(Price) < get_numeric_value(_AvgPrice.AveragePrice) * abap.decfloat34'1.5' then cast(4 as zmrg_cds_budget)
        else cast( 5 as zmrg_cds_budget)
       end as BudgedtCategory,
      _AvgPrice

}
