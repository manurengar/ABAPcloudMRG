@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS entity with parameter (like)'
@Metadata.ignorePropagatedAnnotations: false
define view entity ZMRG_BASICS_LIKE_PARAMETER
  with parameters
    p_text : abap.char(3)
  as select from zmrg_basics_grouping_source
{
  key RandomKey,
      KeyGroup,
      Amount,
      Currency,
      Text
}
where
  Text = $parameters.p_text
