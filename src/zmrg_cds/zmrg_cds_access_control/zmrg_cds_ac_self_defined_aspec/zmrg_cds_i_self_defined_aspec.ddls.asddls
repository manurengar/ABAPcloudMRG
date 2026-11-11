@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Self defined aspect on CDS'
@Metadata.ignorePropagatedAnnotations: true
@AccessControl.auditing.type: #CUSTOM
@AccessControl.auditing.specification: 'Used as source for AC on CDS ZMRG_I_SALESORDER_SELF_ASPEC'
define view entity zmrg_cds_i_self_defined_aspec
  as select from zmrg_cds_01
{
  key cast( abap.char'MANUELR' as zmrg_auth_user_name ) as Username,
      cast( abap.char'FFG' as vkgrp )                   as SalesGroup
}
union select distinct from zmrg_cds_01
{
  key cast( abap.char'JAVILIN' as zmrg_auth_user_name ) as Username,
      cast( abap.char'FTG' as vkgrp )                   as SalesGroup
}
