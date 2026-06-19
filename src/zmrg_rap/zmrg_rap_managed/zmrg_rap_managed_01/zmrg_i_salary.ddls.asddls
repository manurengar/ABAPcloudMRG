@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Salary entity view'
@Metadata.ignorePropagatedAnnotations: false
define view entity zmrg_i_salary
  as select from zmrg_tab_salary
  association to parent zmrg_i_employee as _Employee on $projection.EmployeeId = _Employee.EmployeeId
{
  key position_id           as PositionId,
  key start_date            as StartDate,
  key end_date              as EndDate,
      position_type         as PositionType,
      employee_id           as EmployeeId,
      @Semantics.amount.currencyCode: 'Currency'
      gross_annual_salary   as GrossAnnualSalary,
      @Semantics.amount.currencyCode: 'Currency'
      net_annual_salary     as NetAnnualSalary,
      currency              as Currency,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      _Employee
}
