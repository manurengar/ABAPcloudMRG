@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product text entity view'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_producttext
  as select from zmrg_matnr_t
{
      @ObjectModel.text.element: ['MaterialName']
      @UI.textArrangement: #TEXT_SEPARATE
      @UI.lineItem: [{ position: 10, label: 'Material' }]
  key matnr as Material,
      @UI.hidden: true
  key mtart as MaterialType,
      @UI.hidden: true
  key spras as Language,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @UI.lineItem: [{ position: 20, label: 'Material Description' }]
      maktx as MaterialName
}
