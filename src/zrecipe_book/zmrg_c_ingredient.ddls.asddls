@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection entity ingredient'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_c_ingredient 
as projection on zmrg_r_ingredient
{
    key RecipeId,
    key IngredientId,
    Name,
    Quantity,
    Unit,
    CreatedBy,
    CreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    LastChangedBy,
    _Recipe: redirected to parent zmrg_c_recipe
}
