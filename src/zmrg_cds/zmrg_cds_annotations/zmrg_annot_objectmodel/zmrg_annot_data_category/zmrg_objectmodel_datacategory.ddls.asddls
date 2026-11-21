@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status text entity'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true

/*
@ObjectModel.dataCategory

    •  What it means: Classifies the special role of a CDS entity:
    •  #TEXT: The view provides language-dependent descriptions (must have a @Semantics.language: true key field and @Semantics.text: true description field).
    •  #VALUE_HELP: The view acts primarily as a search help provider.
    •  #HIERARCHY: The view represents hierarchy data.
    •  When to use: Always add @ObjectModel.dataCategory: #TEXT on text views (such as zmrg_i_status_text.asddls).
*/

@ObjectModel.dataCategory: #TEXT

define view entity ZMRG_OBJECTMODEL_DATACATEGORY
  as select from zmrg_status_t
{
      @ObjectModel.text.element: ['StatusText']
      @UI.textArrangement: #TEXT_SEPARATE
      @UI.lineItem: [{ position: 10, label: 'Status' }]
  key status    as Status,
      @UI.hidden: true
  key spras     as Language,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @UI.lineItem: [{ position: 20, label: 'Certification status' }]
      statustxt as StatusText
}
