@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Qualifiers for Access control cds'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_salesorderitem_qualifi
  as select from zmrg_cds_01
  association of many to exact one zmrg_i_product_qualifi as _Product on _Product.Product = $projection.Product
{
  key 'S1' as SalesOrder,
  key 'I1' as SalesOrderItem,
      'P1' as Product,
      _Product
}
union all select distinct from zmrg_cds_01
association of many to exact one zmrg_i_product_qualifi as _Product on _Product.Product = $projection.Product
{
  key 'S1' as SalesOrder,
  key 'I2' as SalesOrderItem,
      'P1' as Product,
      _Product
}
union all select distinct from zmrg_cds_01
association of many to exact one zmrg_i_product_qualifi as _Product on _Product.Product = $projection.Product
{
  key 'S2' as SalesOrder,
  key 'I1' as SalesOrderItem,
      'P1' as Product,
      _Product
}
union all select distinct from zmrg_cds_01
association of many to exact one zmrg_i_product_qualifi as _Product on _Product.Product = $projection.Product
{
  key 'S2' as SalesOrder,
  key 'I2' as SalesOrderItem,
      'P2' as Product,
      _Product
}
union all select distinct from zmrg_cds_01
association of many to exact one zmrg_i_product_qualifi as _Product on _Product.Product = $projection.Product
{
  key 'S3' as SalesOrder,
  key 'I1' as SalesOrderItem,
      ''   as Product,
      _Product
}
