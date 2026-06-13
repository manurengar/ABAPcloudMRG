@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Extension for employee'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMRG_E_EMPLOYEE
  as select from zmrg_tab_employe
{
  key employee_id as EmployeeId
}
