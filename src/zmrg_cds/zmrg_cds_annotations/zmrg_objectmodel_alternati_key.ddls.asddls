@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child entity view'
@Metadata.ignorePropagatedAnnotations: true

/*
@ObjectModel.alternativeKey is not available on
zmrg_objectmodel_alternati_key.asddls because this CDS view entity
uses the ABAP for Cloud Development language version
(abapLanguageVersion="cloudDevelopment"),
and @ObjectModel.alternativeKey is not released
for Cloud Development (C1 contract).

The alternative would be to use

@ObjectModel.semanticKey: [ 'EmployeeId' ]
*/
@ObjectModel.semanticKey: [ 'EmployeeId' ]

define view entity ZMRG_OBJECTMODEL_ALTERNATI_KEY
  as select from zmrg_tab_child
{
  key uuid                   as Uuid,
  key employee_id            as EmployeeId,
      first_name             as FirstName,
      last_name              as LastName,
      age                    as Age,
      gender                 as Gender,
      nationality            as Nationality,
      identity_number        as IdentityNumber,
      discapacity            as Discapacity,
      discapacity_percentage as DiscapacityPercentage,
      @Semantics.user.createdBy: true
      created_by             as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at             as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by  as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at  as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at        as LastChangedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by        as LastChangedBy
}
