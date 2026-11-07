@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Qualifiers for Access control cds'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMRG_I_SALESORDER_QUALIFI
  as select from zmrg_cds_01
  association of exact one to many zmrg_i_salesorderitem_qualifi as _Item on _Item.SalesOrder = $projection.SalesOrder
{
  key 'S1' as SalesOrder,
      _Item
}
union all select distinct from zmrg_cds_01
association of exact one to many zmrg_i_salesorderitem_qualifi as _Item on _Item.SalesOrder = $projection.SalesOrder
{
  key 'S2' as SalesOrder,
      _Item
}
union all select distinct from zmrg_cds_01
association of exact one to many zmrg_i_salesorderitem_qualifi as _Item on _Item.SalesOrder = $projection.SalesOrder
{
  key 'S3' as SalesOrder,
      _Item
}
