@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Scalar ref function example'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_basics_scalar_ref_functio
  with parameters
    p_operator : zmrg_typ_operator
  as select from zmrg_i_basics_reference_source
{
  Unit,
  Currency,
  concat( Currency, concat( '/', Unit ) ) as UnitOfMeasure,
  @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
  zmrg_scal_ternary_operator( q1 => curr_to_decfloat_amount(TotalAmount), 
                              q2 => Quantity, 
                              operator => $parameters.p_operator  ) as ReferenceFunctionResult
  
}
