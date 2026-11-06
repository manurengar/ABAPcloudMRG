@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales order item CDS path exp'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMRG_I_SALESITEM_INH as select from zmrg_sales_item
association to parent ZMRG_I_SALESORDER_INH as _SalesOrder
    on $projection.SalesOrder = _SalesOrder.SalesOrder
composition [0..*] of ZMRG_I_SALESLINE_INH as _ScheduleLine
{
    key vbeln as SalesOrder,
    key posnr as SalesOrderItem,
    matnr as Material,
    matkl as MaterialGroup,
    arktx as SalesOrderItemText,
    pstyv as SalesOrderItemCategory,
    @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
    kwmeng as OrderQuantity,
    vrkme as OrderQuantityUnit,
    meins as BaseUnit,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    netwr as NetAmount,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    netpr as NetPriceAmount,
    waerk as TransactionCurrency,
    werks as Plant,
    lgort as StorageLocation,
    vstel as ShippingPoint,
    erdat as CreationDate,
    ernam as CreatedByUser,
    erzet as CreationTime,
    _SalesOrder,
    _ScheduleLine
}
