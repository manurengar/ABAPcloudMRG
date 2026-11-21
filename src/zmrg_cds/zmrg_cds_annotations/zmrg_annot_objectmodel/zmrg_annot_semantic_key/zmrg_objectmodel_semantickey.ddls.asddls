@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Annotation Object Model Example 1'
@Metadata.ignorePropagatedAnnotations: true

/*
2. Keys & Entity Semantics (Header Level)

@ObjectModel.semanticKey: [ 'Field1', 'Field2' ]

    •  What it means: Defines the human-readable business key(s) of an entity (especially when the technical key is a RAW(16) UUID).
    •  When to use: On Consumption (C_) or Interface (I_) views exposed to Fiori Elements. Fiori displays the semantic key in bold in tables/headers and shows the draft/editing status underneath it.
*/

@ObjectModel.semanticKey: [ 'Username', 'FirstName', 'LastName' ]

define view entity ZMRG_OBJECTMODEL_SEMANTICKEY as select from zmrg_cds_01
{
    key abap.rawstring'019992312451' as UUID,
    username as Username,
    first_name as FirstName,
    last_name as LastName,
    abap.string'dummy_field' as DummyField
}
