@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Source entity for grouping values'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_basics_grouping_source
  as select from zmrg_cds_01
{
  key abap.char'AS21OINAFO' as RandomKey,
      abap.int2'1'          as KeyGroup,
      @Semantics.amount.currencyCode: 'Currency'
      abap.curr'3200.21'    as Amount,
      abap.cuky'EUR'        as Currency,
      abap.char'NIG'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'AS21OINAFC' as RandomKey,
      abap.int2'1'          as KeyGroup,
      abap.curr'330.21'     as Amount,
      abap.cuky'SOL'        as Currency,
      abap.char'NIG'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'BT42XKJQWE' as RandomKey,
      abap.int2'1'          as KeyGroup,
      abap.curr'1500.00'    as Amount,
      abap.cuky'EUR'        as Currency,
      abap.char'XYZ'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'CU53YRKASD' as RandomKey,
      abap.int2'1'          as KeyGroup,
      abap.curr'2450.75'    as Amount,
      abap.cuky'USD'        as Currency,
      abap.char'ABC'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'DV64ZSLZXC' as RandomKey,
      abap.int2'2'          as KeyGroup,
      abap.curr'5100.00'    as Amount,
      abap.cuky'GBP'        as Currency,
      abap.char'DEF'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'EW75AMNXCV' as RandomKey,
      abap.int2'2'          as KeyGroup,
      abap.curr'890.25'     as Amount,
      abap.cuky'EUR'        as Currency,
      abap.char'GHI'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'FX86BNBQWE' as RandomKey,
      abap.int2'2'          as KeyGroup,
      abap.curr'3333.33'    as Amount,
      abap.cuky'USD'        as Currency,
      abap.char'JKL'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'GY97COPWER' as RandomKey,
      abap.int2'3'          as KeyGroup,
      abap.curr'4200.00'    as Amount,
      abap.cuky'JPY'        as Currency,
      abap.char'MNO'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'HZ08DPQASD' as RandomKey,
      abap.int2'3'          as KeyGroup,
      abap.curr'750.50'     as Amount,
      abap.cuky'EUR'        as Currency,
      abap.char'PQR'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'IA19EQRZXC' as RandomKey,
      abap.int2'4'          as KeyGroup,
      abap.curr'6200.80'    as Amount,
      abap.cuky'USD'        as Currency,
      abap.char'STU'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'JB20FSTWER' as RandomKey,
      abap.int2'4'          as KeyGroup,
      abap.curr'999.99'     as Amount,
      abap.cuky'GBP'        as Currency,
      abap.char'VWX'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'KC31GTYUIO' as RandomKey,
      abap.int2'1'          as KeyGroup,
      abap.curr'2750.50'    as Amount,
      abap.cuky'EUR'        as Currency,
      abap.char'YZA'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'LD42HUIOPA' as RandomKey,
      abap.int2'1'          as KeyGroup,
      abap.curr'1800.25'    as Amount,
      abap.cuky'USD'        as Currency,
      abap.char'BCD'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'ME53IJASDF' as RandomKey,
      abap.int2'2'          as KeyGroup,
      abap.curr'4600.75'    as Amount,
      abap.cuky'GBP'        as Currency,
      abap.char'EFG'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'NF64JKGHJK' as RandomKey,
      abap.int2'2'          as KeyGroup,
      abap.curr'1250.00'    as Amount,
      abap.cuky'EUR'        as Currency,
      abap.char'HIJ'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'OG75KLZXCV' as RandomKey,
      abap.int2'3'          as KeyGroup,
      abap.curr'5800.00'    as Amount,
      abap.cuky'JPY'        as Currency,
      abap.char'KLM'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'PH86LMQWER' as RandomKey,
      abap.int2'3'          as KeyGroup,
      abap.curr'1100.90'    as Amount,
      abap.cuky'EUR'        as Currency,
      abap.char'NOP'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'QI97MNRTYU' as RandomKey,
      abap.int2'4'          as KeyGroup,
      abap.curr'4500.40'    as Amount,
      abap.cuky'USD'        as Currency,
      abap.char'QRS'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'RJ08NOSDFG' as RandomKey,
      abap.int2'4'          as KeyGroup,
      abap.curr'1750.60'    as Amount,
      abap.cuky'GBP'        as Currency,
      abap.char'TUV'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'SK19OPFGHJ' as RandomKey,
      abap.int2'5'          as KeyGroup,
      abap.curr'3900.00'    as Amount,
      abap.cuky'EUR'        as Currency,
      abap.char'WXY'        as Text
}
union all select from zmrg_cds_01
{
  key abap.char'TL20PQVBNM' as RandomKey,
      abap.int2'5'          as KeyGroup,
      abap.curr'2100.50'    as Amount,
      abap.cuky'EUR'        as Currency,
      abap.char'ZAB'        as Text
}
