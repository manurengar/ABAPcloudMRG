@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Granting access control to Draft table'
@Metadata.ignorePropagatedAnnotations: true

// Draft table from behavior definition: zmrg_i_employee
define view entity zmrg_draft_table_acces_control
  as select from zmrg_dra_employe
{
  key employeeid                    as Employeeid,
      firstname                     as Firstname,
      lastname                      as Lastname,
      age                           as Age,
      gender                        as Gender,
      nationality                   as Nationality,
      nationalitytext               as Nationalitytext,
      civilstatus                   as Civilstatus,
      children                      as Children,
      identitynumber                as Identitynumber,
      profilepicture                as Profilepicture,
      mimetype                      as Mimetype,
      filename                      as Filename,
      createdby                     as Createdby,
      createdat                     as Createdat,
      locallastchangedby            as Locallastchangedby,
      locallastchangedat            as Locallastchangedat,
      lastchangedat                 as Lastchangedat,
      lastchangedby                 as Lastchangedby,
      draftentitycreationdatetime   as Draftentitycreationdatetime,
      draftentitylastchangedatetime as Draftentitylastchangedatetime,
      draftadministrativedatauuid   as Draftadministrativedatauuid,
      draftentityoperationcode      as Draftentityoperationcode,
      hasactiveentity               as Hasactiveentity,
      draftfieldchanges             as Draftfieldchanges
}
