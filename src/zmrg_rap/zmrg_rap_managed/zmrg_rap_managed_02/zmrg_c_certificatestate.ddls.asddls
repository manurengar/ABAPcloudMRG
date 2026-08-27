@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection entity certificate state'
@Metadata.ignorePropagatedAnnotations: false
define view entity zmrg_c_certificatestate
  as projection on zmrg_i_certificatestate as CertificateState
{
  key StateUuid,
      CertUUID,
      Product,
      Version,
      Status,
      StatusOld,

      LocalLastChangedAt,
      LastChangedAt,
      LastChangedBy,

      /* Associations */
      _Certificate : redirected to parent zmrg_c_certificate
}
