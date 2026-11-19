@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Profit center dummy for foreing key relationship'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_profit_center
  as select from zmrg_tab_center
  association of one to one ZMRG_I_COUNTRYTEXT as _CountryText on  $projection.Country  = _CountryText.Country
                                                               and $projection.Language = _CountryText.Language
  association of one to one zmrg_i_region      as _Region      on  $projection.Country  = _Region.Country
                                                               and $projection.Language = _Region.Language
                                                               and $projection.Region   = _Region.Region
{
  key land1 as Country,
  key bland as Region,
  key langu as Language,
      dummy as Dummy,
      @ObjectModel.foreignKey.association: '_CountryText'
      _CountryText,
      @ObjectModel.foreignKey.association: '_Region'
      _Region
}
