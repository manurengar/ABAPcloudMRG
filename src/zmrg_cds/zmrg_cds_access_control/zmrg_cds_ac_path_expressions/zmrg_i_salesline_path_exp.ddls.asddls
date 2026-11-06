@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Schedule line cds path expression'
@Metadata.ignorePropagatedAnnotations: true
define view entity zmrg_i_salesline_path_exp as select from zmrg_sales_line
association to parent zmrg_i_salesitem_path_exp as _SalesItem
    on  $projection.SalesOrder     = _SalesItem.SalesOrder
    and $projection.SalesOrderItem = _SalesItem.SalesOrderItem
association [1..1] to zmrg_i_salesorder_path_exp as _SalesOrder
    on  $projection.SalesOrder     = _SalesOrder.salesorder
{
    key vbeln as SalesOrder,
    key posnr as SalesOrderItem,
    key etenr as ScheduleLine,
    ettyp as ScheduleLineCategory,
    edatu as RequestedDeliveryDate,
    @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
    wmeng as ScheduleLineOrderQuantity,
    @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
    bmeng as ConfirmedOrderQuantity,
    vrkme as OrderQuantityUnit,
    meins as BaseUnit,
    wadat as GoodsIssueDate,
    lddat as LoadingDate,
    tddat as TransportationPlanningDate,
    mbdat as MaterialAvailabilityDate,
    _SalesItem,
    _SalesOrder
}
