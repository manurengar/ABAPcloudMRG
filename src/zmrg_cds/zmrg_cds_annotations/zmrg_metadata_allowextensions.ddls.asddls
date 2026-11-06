@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Allow extensions for metadata extensions'
@Metadata.ignorePropagatedAnnotations: true

/*
  --   @Metadata.allowExtensions: true
  
  Used to specify that this CDS can have a Metadata extension. However is not mandatory
  as default value is true. However it is advisable to have.  
*/

@Metadata.allowExtensions: true
define view entity ZMRG_METADATA_ALLOWEXTENSIONS
  as select from zmrg_cds_01
{
  key username   as Username,
      first_name as FirstName,
      last_name  as LastName
}
