@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity Ingredient'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_r_ingredient as select from zmrg_ingredient
association to parent zmrg_r_recipe as _Recipe
    on $projection.RecipeId = _Recipe.RecipeId
{
    key recipe_id as RecipeId,
    key ingredient_id as IngredientId,
    name as Name,
    @Semantics.quantity.unitOfMeasure: 'Unit'
    quantity as Quantity,
    unit as Unit,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.localInstanceLastChangedBy: true
    local_last_changed_by as LocalLastChangedBy,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed_at as LocalLastChangedAt,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    _Recipe
}
