@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Certificate interface entity'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zmrg_i_certificate
  as select from zmrg_certificate
  composition [0..*] of zmrg_i_certificatestate as _CertificateState
  association [0..1] to zmrg_i_producttext      as _ProductText on  $projection.Product   = _ProductText.Material
                                                                and _ProductText.MaterialType = 'HAWA'
                                                                and _ProductText.Language = $session.system_language
{
  key cert_uuid             as CertUUID,
      @EndUserText.label: 'Product Number'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zmrg_i_producttext', element: 'Material' } }]
      @ObjectModel.text.association: '_ProductText'
      matnr                 as Product,
      version               as Version,
      cert_status           as CertificationStatus,
      cert_ce               as CertificateCe,
      cert_gs               as CertificateGs,
      cert_tuev             as CertificateTuev,
      @Semantics.largeObject: {
      acceptableMimeTypes: [ 'image/*', 'application/*' ],
      cacheControl.maxAge: #LONG,
      contentDispositionPreference: #ATTACHMENT ,
      fileName: 'FilenameCE',
      mimeType: 'MimetypeCE'
      }
      attachment_ce         as AttachmentCE,
      mimetype_ce           as MimetypeCE,
      filename_ce           as FilenameCE,
      @Semantics.largeObject: {
      acceptableMimeTypes: [ 'image/*', 'application/*' ],
      cacheControl.maxAge: #LONG,
      contentDispositionPreference: #ATTACHMENT ,
      fileName: 'FilenameGS',
      mimeType: 'MimetypeGS'
      }
      attachment_gs         as AttachmentGS,
      mimetype_gs           as MimetypeGS,
      filename_gs           as FilenameGS,
      @Semantics.largeObject: {
      acceptableMimeTypes: [ 'image/*', 'application/*' ],
      cacheControl.maxAge: #LONG,
      contentDispositionPreference: #ATTACHMENT ,
      fileName: 'FilenameTuev',
      mimeType: 'MimetypeTuev'
      }
      attachment_tuev       as AttachmentTuev,
      mimetype_tuev         as MimetypeTuev,
      filename_tuev         as FilenameTuev,
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

      case
        when ( cert_status = '01' or cert_status = '04' ) then 2
        when ( cert_status = '03' or cert_status is initial ) then 1
        else 3
      end                   as Criticality,

      _CertificateState,
      _ProductText
}
