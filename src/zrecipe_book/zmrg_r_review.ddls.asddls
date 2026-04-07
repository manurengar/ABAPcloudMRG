@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity Review'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_r_review
  as select from zmrg_review
  association to parent zmrg_r_recipe as _Recipe on $projection.RecipeId = _Recipe.RecipeId
{
  key review_id             as ReviewId,
      recipe_id             as RecipeId,
      username              as Username,
      review_text           as ReviewText,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.largeObject: {
          mimeType: 'Mimetype',
          fileName: 'Filename',
          contentDispositionPreference: #INLINE,
          acceptableMimeTypes: [ 'image/*' ]
      }
      @Semantics.imageUrl: true
      attachment            as Attachment,
      @Semantics.mimeType: true
      mimetype              as Mimetype,
      filename              as Filename,
      _Recipe
}
