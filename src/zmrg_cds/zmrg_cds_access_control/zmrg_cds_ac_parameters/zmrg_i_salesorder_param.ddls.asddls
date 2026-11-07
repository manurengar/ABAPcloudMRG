@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order CDS path expression'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMRG_I_SALESORDER_PARAM
  with parameters
    p_p1 : abap.char(1),
    p_p2 : abap.char(1),
    p_p3 : abap.char(1)
  as select from zmrg_salesorder
  composition [0..*] of ZMRG_I_SALESITEM_PARAM as _Item
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
