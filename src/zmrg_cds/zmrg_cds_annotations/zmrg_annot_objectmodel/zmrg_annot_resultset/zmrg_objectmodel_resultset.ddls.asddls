@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Annotation Object Model Example 1'
@Metadata.ignorePropagatedAnnotations: true


@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZMRG_OBJECTMODEL_RESULTSET as select from zmrg_cds_01
{
    key username as Username,
    first_name as FirstName,
    last_name as LastName
}
