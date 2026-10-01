@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Simple types showdown'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_basics_simple_types
  as select from zmrg_cds_01
{
  username                                                    as MyTableField,
  '20010121'                                                  as PrimitiveCharacter,
  cast( '20010121' as abap.dats )                             as DateField,
  cast( cast( 'E' as abap.lang ) as sylangu preserving type ) as LanguageField,
  1.2                                                         as FloatingNumber,
  abap.fltp'1.2'                                              as TypedFloatingPoint,
  fltp_to_dec(1.2 as abap.dec( 2, 1 ))                        as DecimalNumber,
  abap.dec'1234.56'                                           as Typed1Decimal,
  abap.dec'001234.56'                                         as Typed2Decimal,
  '  CHAR10  '                                                as PrimitiveChar10,
  cast( '  CHAR10  ' as abap.char(10) )                       as CastChar10,
  abap.char'  CHAR10   '                                      as TypeChar10
}
