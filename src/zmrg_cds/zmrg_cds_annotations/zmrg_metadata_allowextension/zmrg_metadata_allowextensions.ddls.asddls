@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Allow extensions for metadata extensions'
@Metadata.ignorePropagatedAnnotations: true

@Metadata.allowExtensions: true
define view entity ZMRG_METADATA_ALLOWEXTENSIONS
  as select from zmrg_cds_01
{
  key username   as Username,
      first_name as FirstName,
      last_name  as LastName
}
