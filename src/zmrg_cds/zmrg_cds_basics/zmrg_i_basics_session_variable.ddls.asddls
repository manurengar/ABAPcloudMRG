@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Session variables for CDS'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_basics_session_variable
  as select from Zmrg_i_basics_avg_flight_price
{
  $session.client          as SystemClient,
  $session.system_date     as SystemDate,
  $session.system_language as SystemLanguage,
  $session.user            as CurrentUser,
  $session.user_date       as UserDate,
  $session.user_timezone   as UserTimeZone
}
