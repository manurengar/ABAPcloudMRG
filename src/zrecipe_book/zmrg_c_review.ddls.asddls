@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection entity review'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity zmrg_c_review 
as projection on zmrg_r_review
{
    key ReviewId,
    RecipeId,
    Username,
    ReviewText,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    LastChangedBy,
    CreatedBy,
    CreatedAt,
    Attachment,
    Mimetype,
    Filename,
    _Recipe: redirected to parent zmrg_c_recipe 
}
