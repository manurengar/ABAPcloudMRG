@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Example association 1'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_association_example_1
  as select from zmrg_association_source_a
  association of exact one to one ZMRG_ASSOCIATION_SOURCE_B as _SourceB on  $projection.Currency = _SourceB.Currency
                                                                        and _SourceB.Language    = abap.lang'E'
{
  key KeyColumn,
      Currency,
      ColNumber,
      _SourceB
}
