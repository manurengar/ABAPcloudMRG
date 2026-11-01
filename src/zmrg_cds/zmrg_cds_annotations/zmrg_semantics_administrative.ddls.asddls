@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child entity view'
@Metadata.ignorePropagatedAnnotations: true

/*
In ABAP RAP, these @Semantics annotations mark administrative 
audit fields. When used in a Managed (or Draft-enabled) 
RAP Business Object, the RAP runtime automatically populates 
and updates these fields without requiring custom ABAP code, 
and uses the timestamps for optimistic concurrency control (ETags) 
and draft handling.
*/

define view entity ZMRG_SEMANTICS_ADMINISTRATIVE
  as select from zmrg_tab_child
{
  key uuid                   as Uuid,
  key employee_id            as EmployeeId,

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
