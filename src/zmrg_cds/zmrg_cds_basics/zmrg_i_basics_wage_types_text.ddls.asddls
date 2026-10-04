@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Wage type text entity'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_basics_wage_types_text
  as select from zmrg_cds_01
{
  key abap.char'9E01'                                        as wage_type,
      @Semantics.language: true
  key abap.lang'E'                                           as language,

      cast( 'Remote Connectivity Stipend' as abap.char(50) ) as wage_type_text
}

union

select from zmrg_cds_01
{
  key abap.char'9E01'                              as wage_type,
  key abap.lang'S'                                 as language,
      abap.char'Estipendio de Conectividad Remota' as wage_type_text
}

union

select from zmrg_cds_01
{
  key abap.char'9E02'                    as wage_type,
  key abap.lang'E'                       as language,
      abap.char'Pet Insurance Allowance' as wage_type_text
}

union

select from zmrg_cds_01
{
  key abap.char'9E02'                             as wage_type,
  key abap.lang'S'                                as language,
      abap.char'Subsidio de Seguro para Mascotas' as wage_type_text
}

union

select from zmrg_cds_01
{
  key abap.char'9E03'                       as wage_type,
  key abap.lang'E'                          as language,
      abap.char'Innovation Milestone Bonus' as wage_type_text
}

union

select from zmrg_cds_01
{
  key abap.char'9E03'                        as wage_type,
  key abap.lang'S'                           as language,
      abap.char'Bono por Hito de Innovación' as wage_type_text
}
  
  
  
  
