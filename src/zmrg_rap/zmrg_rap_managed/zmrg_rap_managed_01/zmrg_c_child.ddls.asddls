@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view Child'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity zmrg_c_child
  as projection on ZMRG_I_CHILD
{
      @Semantics.uuid: true
  key Uuid,
      @Search.defaultSearchElement: true
  key EmployeeId,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      FirstName,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      LastName,
      Age,
      Gender,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZMRG_I_NATIONALITY_VH', element: 'Nationality' } }]
      Nationality,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      NationalityText,
      IdentityNumber,
      Discapacity,
      DiscapacityPercentage,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      LastChangedBy,
      /* Associations */
      _Employee : redirected to parent zmrg_c_employee,
      _Nationality
}
