@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Example using parameters'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_basics_parameters
  with parameters
    @Environment.systemField: #SYSTEM_DATE
    p_start_date : zmrg_cds_start_date,
    @Environment.systemField: #SYSTEM_DATE
    p_end_date   : ZMRG_CDS_END_DATE,
    @Environment.systemField: #SYSTEM_LANGUAGE
    p_language   : ZMRG_CDS_WAGE_TYPE_LANGUAGE
  as select from zmrg_i_basics_group_source1
  association of one to many zmrg_i_basics_wage_types_text as _WageTypeText on _WageTypeText.wage_type = $projection.WageType
{
  key personnel_number                                                  as PersonnelNumber,
  key start_date                                                        as StartDate,
  key end_date                                                          as EndDate,
  key wage_type                                                         as WageType,
      _WageTypeText[1:language = $parameters.p_language].wage_type_text as WageTypeText,
      currency                                                          as Currency,
      @Semantics.amount.currencyCode: 'Currency'
      amount                                                            as Amount,
      quantity                                                          as Quantity
}
where
      start_date <= $parameters.p_end_date
  and end_date   >= $parameters.p_start_date
