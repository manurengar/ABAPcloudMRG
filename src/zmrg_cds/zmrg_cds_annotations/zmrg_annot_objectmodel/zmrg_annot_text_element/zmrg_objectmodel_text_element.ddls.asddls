@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value help for position type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel : { resultSet.sizeCategory: #XS }
@Search.searchable: true


define view entity ZMRG_OBJECTMODEL_TEXT_ELEMENT
  as select from zmrg_tab_positio
{
      @ObjectModel.text.element: ['PositionTypeText']
      @UI.textArrangement: #TEXT_FIRST
  key type     as Type,
  key langu    as Langu,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      pos_text as PositionTypeText
}
