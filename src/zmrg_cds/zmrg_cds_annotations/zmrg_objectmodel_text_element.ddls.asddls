@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value help for position type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel : { resultSet.sizeCategory: #XS }
@Search.searchable: true

/*
@ObjectModel.text.element represent a list of elements. It is used together with Semantics.text

If the list contains one text field, the first found is used as standard text. This variant does not support laguage dependent
texts.
*/
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
