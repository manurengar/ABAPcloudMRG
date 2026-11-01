@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Annotation for RONT NONT objects'
@Metadata.ignorePropagatedAnnotations: true

/*
Populate annotation sapObjectNodeTypeReference on simple type
zmrg_typ_unit_of_measure for RONT type objects.

In the SAP One Domain Model / ABAP Cloud:

    1. `@ObjectModel.sapObjectNodeType.name` 
       (on a CDS Entity, e.g. @ObjectModel.sapObjectNodeType.name:
       'Address' in i_address_2.asddls) declares which SAP Object
        Node Type a CDS view represents.
    2. `@ObjectModel.sapObjectNodeTypeReference` (on a CDS Simple 
       Type or Element, like your 
       zmrg_typ_unit_of_measure.asdrtysty) declares that values of
       this type hold an identifier/key referencing that SAP 
       Object Node Type.

This allows SAP frameworks, OData services, Enterprise Search, 
and UI clients to understand the semantic business object
relationship of a field or simple type (for example, 
for intent-based navigation, extensibility, or metadata discovery).
*/

 @ObjectModel.sapObjectNodeType.name: 'ZMRG_UnitOfMeasure' 
define view entity ZMRG_OBJECTMODEL_NODE_TYPE 
     as select from zmrg_cds_02
   {
     key cast( 'KwH' as zmrg_typ_unit_of_measure) as UnitOfMeasure
   }
