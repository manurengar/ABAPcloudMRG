@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Annotation Object Model Example 1'
@Metadata.ignorePropagatedAnnotations: true

/*
@Environment.systemField: #ENUM

Assigns an ABAP system field to an input parameter of a CDS object for implicit parameter passing in ABAP SQL.

Enums
#CLIENT

sy-mandt
#SYSTEM_LANGUAGE

sy-langu
#USER

sy-uname
#SYSTEM_DATE

sy-datum
#SYSTEM_TIME

sy-uzeit
#USER_DATE

sy-datlo
#USER_TIMEZONE

sy-zonlo
*/

define view entity ZMRG_OBJECTMODEL_ENVIROMENT
  with parameters
    @Environment.systemField: #USER
    p_user : zmrg_auth_user_name
  as select from zmrg_cds_01
{
  key username   as Username,
      first_name as FirstName,
      last_name  as LastName
}
where
  username = $parameters.p_user
