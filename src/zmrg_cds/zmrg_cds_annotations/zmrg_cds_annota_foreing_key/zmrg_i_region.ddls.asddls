@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Region entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.representativeKey: 'Region'
define view entity zmrg_i_region
  as select from zmrg_tab_region
  association of exact one to one ZMRG_I_COUNTRYTEXT as _CountryText on  $projection.Country  = _CountryText.Country
                                                                     and $projection.Language = _CountryText.Language
{
      @ObjectModel.foreignKey.association: '_CountryText'
  key land1  as Country,
      @ObjectModel.text.element: ['RegionText']
  key bland  as Region,
      @Semantics.language: true
  key langu  as Language,
      fprcd  as TaxCode,
      @Semantics.text: true
      regtxt as RegionText,
      _CountryText
}
