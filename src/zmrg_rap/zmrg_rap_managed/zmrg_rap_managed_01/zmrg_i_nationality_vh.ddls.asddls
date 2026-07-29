@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel : { resultSet.sizeCategory: #XS }
@EndUserText.label: 'Nationality value help'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define view entity zmrg_i_nationality_vh
  as select from zmrg_tab_natio
{
      @ObjectModel.text.element: ['NationalityDescr']
      @UI.textArrangement: #TEXT_SEPARATE
      @UI.lineItem: [{ position: 10, label: 'Country Key' }]
  key natkey   as Nationality,

      @UI.hidden: true
  key spras    as Language,

      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @UI.lineItem: [{ position: 20, label: 'Nationality Name' }]
      natdescr as NationalityDescr
}
where
  spras = $session.system_language
