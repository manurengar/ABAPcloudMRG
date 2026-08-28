@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection entity certificate'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity zmrg_c_certificate
  provider contract transactional_query
  as projection on zmrg_i_certificate as Certificate
{
  key     CertUUID,
          @ObjectModel.text.element: [ 'ProductName' ]
          @UI.textArrangement: #TEXT_SEPARATE
          @Consumption.valueHelpDefinition: [{ entity: { name: 'zmrg_i_producttext', element: 'Material' } }]
          Product,
          @Semantics.text: true
          @Search.defaultSearchElement: true
          @Search.fuzzinessThreshold: 0.7
          _ProductText.MaterialName as ProductName,
          Version,
          @ObjectModel.text.element: [ 'StatusText' ]
          @UI.textArrangement: #TEXT_SEPARATE
          @Consumption.valueHelpDefinition: [{ entity: { name: 'zmrg_i_status_text', element: 'Status' } }]
          CertificationStatus,
          @Semantics.text: true
          @Search.defaultSearchElement: true
          @Search.fuzzinessThreshold: 0.7
          _StatusText.StatusText    as StatusText,
          CertificateCe,
          CertificateGs,
          CertificateTuev,
          AttachmentCE,
          MimetypeCE,
          FilenameCE,
          AttachmentGS,
          MimetypeGS,
          FilenameGS,
          AttachmentTuev,
          MimetypeTuev,
          FilenameTuev,
          CreatedBy,
          CreatedAt,
          LocalLastChangedBy,
          LocalLastChangedAt,
          LastChangedAt,
          LastChangedBy,
          Criticality,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZMRG_CLA_RAP_02_VIRTUAL_SAMPLE'
  virtual virtualSampleText : abap.char( 150 ),
          /* Associations */
          _CertificateState : redirected to composition child zmrg_c_certificatestate,
          _ProductText,
          _StatusText
}
