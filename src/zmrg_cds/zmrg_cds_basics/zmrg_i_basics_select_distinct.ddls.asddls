@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Select distinct applicable'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_basics_select_distinct
  as select distinct from zmrg_cds_02
{
  col1 as Column1 // Initial table contained a distribution of 5 numbers, so We exect 5 rows

}
