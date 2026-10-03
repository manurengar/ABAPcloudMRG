@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inner Join example'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_basics_inner_join
  as select from            zmrg_i_basics_union_testing  as T1
    inner many to many join ZMRG_I_BASICS_UNION_TESTING2 as T2 on T1.Field1 = T2.Field1
{
  T1.Field1 as AField1,
  T1.Field2 as AField2,
  T2.Field1 as BField1,
  T2.Field2 as BField2,
  T2.Field3 as BField3
}
