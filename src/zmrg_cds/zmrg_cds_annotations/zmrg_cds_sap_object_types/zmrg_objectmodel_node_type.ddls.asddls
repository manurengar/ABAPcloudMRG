@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Annotation for RONT NONT objects'
@Metadata.ignorePropagatedAnnotations: true

 @ObjectModel.sapObjectNodeType.name: 'ZMRG_UnitOfMeasure' 
define view entity ZMRG_OBJECTMODEL_NODE_TYPE 
     as select from zmrg_cds_02
   {
     key 'KwH'  as UnitOfMeasure
   }
