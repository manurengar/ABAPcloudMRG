@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order CDS path expression'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zmrg_i_salesorder_path_exp as select from zmrg_salesorder
composition [0..*] of zmrg_i_salesitem_path_exp as _Item
{
    key vbeln as SalesOrder,
    erdat as CreationDate,
    erzet as CreationTime,
    ernam as CreatedByUser,
    auart as SalesOrderType,
    vbtyp as SDDocumentCategory,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    netwr as TotalNetAmount,
    waerk as TransactionCurrency,
    vkorg as SalesOrganization,
    vtweg as DistributionChannel,
    spart as OrganizationDivision,
    vkbur as SalesOffice,
    vkgrp as SalesGroup,
    kunnr as SoldToParty,
    bstnk as PurchaseOrderByCustomer,
    bstdk as CustomerPurchaseOrderDate,
    vdatu as RequestedDeliveryDate,
    _Item
}
