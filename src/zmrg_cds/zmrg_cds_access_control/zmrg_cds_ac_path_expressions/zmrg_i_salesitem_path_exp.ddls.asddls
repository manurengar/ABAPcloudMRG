@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales order item CDS path exp'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_salesitem_path_exp as select from zmrg_sales_item
association to parent zmrg_i_salesorder_path_exp as _SalesOrder
    on $projection.SalesOrder = _SalesOrder.SalesOrder
composition [0..*] of zmrg_i_salesline_path_exp as _ScheduleLine
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
