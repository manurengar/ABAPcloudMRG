@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Annotation Object Model Example 1'
@Metadata.ignorePropagatedAnnotations: true

/*
@ObjectModel.resultSet.sizeCategory: #XS

What it means: Tells the runtime that the view returns a very small result set (typically < 200 rows). When to use: On small Value Help or Status/Domain CDS views so Fiori Elements automatically renders the field as a Dropdown list instead of a dialog popup.
*/

@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZMRG_OBJECTMODEL_RESULTSET as select from zmrg_cds_01
{
    key username as Username,
    first_name as FirstName,
    last_name as LastName
}
