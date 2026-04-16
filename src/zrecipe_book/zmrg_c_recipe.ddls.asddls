@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection entity recipe'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
define root view entity zmrg_c_recipe
  provider contract transactional_query
  as projection on zmrg_r_recipe
{
  key RecipeId,
      RecipeName,
      RecipeText,
      Published,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      LastChangedBy,
      _Ingredient: redirected to composition child zmrg_c_ingredient,
      _Review: redirected to composition child zmrg_c_review
}
