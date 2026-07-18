@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view Salary'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZMRG_C_SALARY
  as projection on zmrg_i_salary
{
      @Search.defaultSearchElement: true
  key PositionId,
      @Search.defaultSearchElement: true
  key StartDate,
      EndDate,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZMRG_I_POSITION_VH', element: 'PosText' } }]
      PositionType,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      PositionText,
      EmployeeId,
      GrossAnnualSalary,
      NetAnnualSalary,
      Currency,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      LastChangedBy,
      /* Associations */
      _Employee : redirected to parent zmrg_c_employee,
      _PositionType
}
