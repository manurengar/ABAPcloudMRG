@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Foreign key association example'
@Metadata.ignorePropagatedAnnotations: true
/*

The associations of foreing key relationships often are of type 0..1 1..1 and 0..* 1..* in the other direction.

The Foreing Key association relationship support the usage of multiple foreing key, so  this annotation can be used
with different associations within a same CDS. 

In theory it will restrict the number of entries of main CDS based on foreing key check table.

*/
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
