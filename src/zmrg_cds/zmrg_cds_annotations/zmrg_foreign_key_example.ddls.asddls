@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Foreign key association example'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMRG_FOREIGN_KEY_EXAMPLE
  as select from zmrg_tab_child
  association of one to one  zmrg_i_employee as _Employee // cardinality is either 0..1 or 1..1
    on $projection.EmployeeId = _Employee.EmployeeId
{
  key uuid        as Uuid,

      @ObjectModel.foreignKey.association: '_Employee'
      employee_id as EmployeeId,

      _Employee
}
