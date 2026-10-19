@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Source association B'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMRG_ASSOCIATION_SOURCE_B
  as select from zmrg_cds_01
{
  key abap.cuky'EUR'                  as Currency,
  key abap.lang'E'                    as Language,
      cast( 'Euro' as abap.char(40) ) as CurrencyText
}
union all select from zmrg_cds_01
{
  key abap.cuky'USD'                       as Currency,
  key abap.lang'E'                         as Language,
      cast( 'US Dollar' as abap.char(40) ) as CurrencyText
}
union all select from zmrg_cds_01
{
  key abap.cuky'GBP'                           as Currency,
  key abap.lang'E'                             as Language,
      cast( 'British Pound' as abap.char(40) ) as CurrencyText
}
union all select from zmrg_cds_01
{
  key abap.cuky'JPY'                          as Currency,
  key abap.lang'E'                            as Language,
      cast( 'Japanese Yen' as abap.char(40) ) as CurrencyText
}
union all select from zmrg_cds_01
{
  key abap.cuky'CHF'                         as Currency,
  key abap.lang'E'                           as Language,
      cast( 'Swiss Franc' as abap.char(40) ) as CurrencyText
}
union all select from zmrg_cds_01
{
  key abap.cuky'CAD'                             as Currency,
  key abap.lang'E'                               as Language,
      cast( 'Canadian Dollar' as abap.char(40) ) as CurrencyText
}
union all select from zmrg_cds_01
{
  key abap.cuky'AUD'                               as Currency,
  key abap.lang'E'                                 as Language,
      cast( 'Australian Dollar' as abap.char(40) ) as CurrencyText
}
union all select from zmrg_cds_01
{
  key abap.cuky'BRL'                            as Currency,
  key abap.lang'E'                              as Language,
      cast( 'Brazilian Real' as abap.char(40) ) as CurrencyText
}
union all select from zmrg_cds_01
{
  key abap.cuky'MXN'                          as Currency,
  key abap.lang'E'                            as Language,
      cast( 'Mexican Peso' as abap.char(40) ) as CurrencyText
}
union all select from zmrg_cds_01
{
  key abap.cuky'INR'                          as Currency,
  key abap.lang'E'                            as Language,
      cast( 'Indian Rupee' as abap.char(40) ) as CurrencyText
}
