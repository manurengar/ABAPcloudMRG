@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel : { resultSet.sizeCategory: #XS }
@EndUserText.label: 'Country key cds'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.representativeKey: 'Country'
define view entity ZMRG_I_COUNTRY
  as select from zmrg_tab_natio
  association of one to many ZMRG_I_COUNTRYTEXT as _Text on $projection.Country = _Text.Country
{
      @ObjectModel.text.association: '_Text'
  key natkey as Country,
      'A'    as Dummy,
      _Text

}
