@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Annotation Object Model Example 1'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: {
  serviceQuality: #A,
  sizeCategory:   #L,
  dataClass:      #CUSTOMIZING
}

define view entity ZMRG_OBJECTMODEL_USAGETYPE as select from zmrg_cds_01
{
    key username as Username,
    first_name as FirstName,
    last_name as LastName
}
