@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status text entity'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_status_text
  as select from zmrg_status_t
{
      @ObjectModel.text.element: ['StatusText']
      @UI.textArrangement: #TEXT_SEPARATE
      @UI.lineItem: [{ position: 10, label: 'Status' }]
  key status    as Status,
      @UI.hidden: true
  key spras     as Language,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @UI.lineItem: [{ position: 20, label: 'Certification status' }]
      statustxt as StatusText
}
