@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value help for position type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel : { resultSet.sizeCategory: #XS }
@Search.searchable: true
define view entity zmrg_i_POSITION_VH
  as select from zmrg_tab_positio
{
      @ObjectModel.text.element: ['PosText']
      @UI.textArrangement: #TEXT_FIRST
  key type     as Type,
  key langu    as Langu,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      pos_text as PosText
}
