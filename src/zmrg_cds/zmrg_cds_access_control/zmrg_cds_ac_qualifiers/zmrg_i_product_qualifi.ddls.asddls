@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Access control product qualifiers'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_product_qualifi
  as select from zmrg_cds_01
{
  key 'P1' as Product,
      'A1' as AuthorizationGroup
}
union all select distinct from zmrg_cds_01
{
  key 'P2' as Product,
      'A2' as AuthorizationGroup
}
