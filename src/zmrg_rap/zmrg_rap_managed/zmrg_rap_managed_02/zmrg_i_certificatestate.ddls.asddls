@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Certificate State interface entity'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_certificatestate
  as select from ZMRG_CERTI_STATE
  association to parent zmrg_i_certificate as _Certificate on $projection.CertUUID = _Certificate.CertUUID
{
  key state_uuid            as StateUuid,
      cert_uuid             as CertUUID,
      matnr                 as Product,
      version               as Version,
      status                as Status,
      status_old            as StatusOld,
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
      _Certificate
}
