@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel : { resultSet.sizeCategory: #XS }
@EndUserText.label: 'Nationality value help'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.representativeKey: 'Country'
@ObjectModel.dataCategory: #TEXT
define view entity ZMRG_I_COUNTRYTEXT
  as select from zmrg_tab_natio
  association of exact one to many zmrg_i_region as _Region on  $projection.Country  = _Region.Country
                                                            and $projection.Language = _Region.Language
{
      @ObjectModel.text.element: ['CountryText']
  key natkey   as Country,
      @UI.hidden: true
      @Semantics.language: true
  key spras    as Language,
      @Semantics.text: true
      natdescr as CountryText,
      _Region
}
