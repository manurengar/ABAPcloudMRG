@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED

/*
@AccessControl.auditing annotations are used for security auditing and
compliance documentation at the CDS entity level. They have NO runtime effect
(they do not enforce, enable, or disable authorization checks in ABAP SQL).

They are typically combined with @AccessControl.authorizationCheck: #NOT_REQUIRED
or #NOT_ALLOWED to document for security auditors and static checks (e.g., ATC)
why a standard CDS DCL role is omitted or how access control is handled instead:

- @AccessControl.auditing.type:
  Classifies the auditing/access-control approach (e.g., #CUSTOM when
  authorization is verified outside of CDS DCL).

- @AccessControl.auditing.specification:
  Free-text justification or reference explaining why no DCL role is used
  or where the custom authorization check (e.g., AUTHORITY-CHECK in ABAP)
  takes place.
  
  IMPORTANT: Needed for CDS that will be used as the source for user defined
  aspects on Access Control on CDS.
*/
@AccessControl.auditing.type: #CUSTOM
@AccessControl.auditing.specification: 'Authorization is checked in the consuming ABAP application class'

@EndUserText.label: 'Auditing annotations'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_access_control_auditing
  as select from zmrg_cds_01
{
  key username   as Username,
      first_name as FirstName,
      last_name  as LastName
}
