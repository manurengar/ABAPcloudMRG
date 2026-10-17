@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Currency Texts demo'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_basics_currency_texts
  as select from zmrg_cds_01
{
  key abap.cuky'EUR'                  as Currency,
      cast( 'Euro' as abap.char(40) ) as CurrencyText,
      @Semantics.language: true
      abap.lang'E'                    as Language
}
union all select from zmrg_cds_01
{
  key abap.cuky'USD'                       as Currency,
      cast( 'US Dollar' as abap.char(40) ) as CurrencyText,
      abap.lang'E'                         as Language
}
union all select from zmrg_cds_01
{
  key abap.cuky'GBP'                           as Currency,
      cast( 'British Pound' as abap.char(40) ) as CurrencyText,
      abap.lang'E'                             as Language
}
union all select from zmrg_cds_01
{
  key abap.cuky'JPY'                          as Currency,
      cast( 'Japanese Yen' as abap.char(40) ) as CurrencyText,
      abap.lang'E'                            as Language
}
union all select from zmrg_cds_01
{
  key abap.cuky'CHF'                         as Currency,
      cast( 'Swiss Franc' as abap.char(40) ) as CurrencyText,
      abap.lang'E'                           as Language
}
union all select from zmrg_cds_01
{
  key abap.cuky'CAD'                             as Currency,
      cast( 'Canadian Dollar' as abap.char(40) ) as CurrencyText,
      abap.lang'E'                               as Language
}
union all select from zmrg_cds_01
{
  key abap.cuky'AUD'                               as Currency,
      cast( 'Australian Dollar' as abap.char(40) ) as CurrencyText,
      abap.lang'E'                                 as Language
}
union all select from zmrg_cds_01
{
  key abap.cuky'CNY'                          as Currency,
      cast( 'Chinese Yuan' as abap.char(40) ) as CurrencyText,
      abap.lang'E'                            as Language
}
union all select from zmrg_cds_01
{
  key abap.cuky'INR'                          as Currency,
      cast( 'Indian Rupee' as abap.char(40) ) as CurrencyText,
      abap.lang'E'                            as Language
}
union all select from zmrg_cds_01
{
  key abap.cuky'BRL'                            as Currency,
      cast( 'Brazilian Real' as abap.char(40) ) as CurrencyText,
      abap.lang'E'                              as Language
}
union all select from zmrg_cds_01
{
  key abap.cuky'MXN'                          as Currency,
      cast( 'Mexican Peso' as abap.char(40) ) as CurrencyText,
      abap.lang'E'                            as Language
}
union all select from zmrg_cds_01
{
  key abap.cuky'KRW'                              as Currency,
      cast( 'South Korean Won' as abap.char(40) ) as CurrencyText,
      abap.lang'E'                                as Language
}
union all select from zmrg_cds_01
{
  key abap.cuky'SGD'                              as Currency,
      cast( 'Singapore Dollar' as abap.char(40) ) as CurrencyText,
      abap.lang'E'                                as Language
}
union all select from zmrg_cds_01
{
  key abap.cuky'HKD'                              as Currency,
      cast( 'Hong Kong Dollar' as abap.char(40) ) as CurrencyText,
      abap.lang'E'                                as Language
}
union all select from zmrg_cds_01
{
  key abap.cuky'NZD'                                as Currency,
      cast( 'New Zealand Dollar' as abap.char(40) ) as CurrencyText,
      abap.lang'E'                                  as Language
}
