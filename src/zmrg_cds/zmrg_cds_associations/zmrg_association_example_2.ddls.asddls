@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Example association 1'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMRG_ASSOCIATION_EXAMPLE_2
  as select from zmrg_association_source_a
  association of one to many ZMRG_ASSOCIATION_SOURCE_C as _SourceC on $projection.ColNumber = _SourceC.Col1
{
  key KeyColumn,
      Currency,
      ColNumber,
      _SourceC
}
