@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Nationality value help'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_nationality_vh as select from zmrg_tab_natio
{
      @ObjectModel.text.element: ['NationalityDescr']
  key natkey   as Nationality,
  key spras    as Language,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      natdescr as NationalityDescr
} where spras = $session.system_language
