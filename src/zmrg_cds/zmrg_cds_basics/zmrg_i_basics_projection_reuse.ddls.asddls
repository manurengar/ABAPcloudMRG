@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Example of how to use $projection on intermediate results'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_basics_projection_reuse
  as select from zmrg_i_basics_group_functions
{
  key personnel_number,
  key wage_type,
      NumberOfEntriesPerGroup,
      case
      when $projection.numberofentriespergroup = 1 then concat(abap.char'One row: ', cast( $projection.numberofentriespergroup as abap.sstring(11) ) )
      else concat(abap.char'Number of rows: ', cast ( $projection.numberofentriespergroup as abap.char(11) ) )
      end as NumberOfEntriesText
}
