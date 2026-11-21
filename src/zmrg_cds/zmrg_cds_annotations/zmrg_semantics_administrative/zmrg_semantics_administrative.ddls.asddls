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


`@Semantics.systemDate` and `@Semantics.systemTime` only support createdAt and lastChangedAt 
 (localInstanceLastChangedAt exists only under @Semantics.systemDateTime).
 
In a real Managed RAP Business Object where RAP populates these automatically, t
hose fields would be persisted columns on the database table (using types such as abp_creation_date / abp_lastchange_date and abp_creation_time / abp_lastchange_time), 
though @Semantics.systemDateTime timestamps are preferred in modern RAP for ETag and timezone accuracy.
*/

define view entity ZMRG_SEMANTICS_ADMINISTRATIVE
  as select from zmrg_tab_child
{
  key uuid                              as Uuid,
  key employee_id                       as EmployeeId,

      // User annotations
      @Semantics.user.createdBy: true
      created_by                        as CreatedBy,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by             as LocalLastChangedBy,
      @Semantics.user.lastChangedBy: true
      last_changed_by                   as LastChangedBy,

      // System DateTime (Timestamp: DEC(15,0), DEC(21,7), or UTCLONG)
      @Semantics.systemDateTime.createdAt: true
      created_at                        as CreatedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at             as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                   as LastChangedAt,

      // System Date (Date: abap.dats or abap.datn) -- These are not released
      //@Semantics.systemDate.createdAt: true
      cast( '20260101' as abap.dats )   as CreatedOnDate,
      //@Semantics.systemDate.lastChangedAt: true
      cast( '20260101' as abap.dats )   as LastChangedOnDate,

      // System Time (Time: abap.tims or abap.timn)
      //@Semantics.systemTime.createdAt: true
      cast( '120000' as abap.tims )     as CreatedAtTime,
      //@Semantics.systemTime.lastChangedAt: true
      cast( '120000' as abap.tims )     as LastChangedAtTime
}
