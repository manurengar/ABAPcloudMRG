@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status text entity'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true

/*
@ObjectModel.representativeKey: 'FieldName'

The representative key of a cds is the part of the k ey that that represents the row for this view. The representative key is 
often similar to the CDS name.


Not all CDS need a representative key. Views with representative key represent discrete entities that can be connected by
foreing keys to enrich other CDS.

    •  What it means: Specifies the single key element that represents the entity itself (excluding compound keys like Language or validity dates).
    •  When to use: On Dimension (I_) and Text (#TEXT) views. Target associations (@ObjectModel.foreignKey.association or @ObjectModel.text.association) match against this representative key.
*/

@ObjectModel: 
{ 
    dataCategory: #TEXT,
    representativeKey: 'Status' 
}

define view entity ZMRG_OBJECTMODEL_REPRESENT_KEY
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
