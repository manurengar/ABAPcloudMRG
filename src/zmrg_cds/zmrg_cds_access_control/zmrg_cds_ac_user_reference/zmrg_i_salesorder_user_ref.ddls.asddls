@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order CDS path expression'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMRG_I_SALESORDER_USER_REF
  as select from zmrg_salesorder

{
  key vbeln      as SalesOrder,
      erdat      as CreationDate,
      erzet      as CreationTime,
      ernam      as CreatedByUser,
      auart      as SalesOrderType,
      @Semantics.user.createdBy: true
      created_by as CreatedBy,
      vbtyp      as SDDocumentCategory,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      netwr      as TotalNetAmount,
      waerk      as TransactionCurrency,
      vkorg      as SalesOrganization,
      vtweg      as DistributionChannel,
      spart      as OrganizationDivision,
      vkbur      as SalesOffice,
      vkgrp      as SalesGroup,
      kunnr      as SoldToParty,
      bstnk      as PurchaseOrderByCustomer,
      bstdk      as CustomerPurchaseOrderDate,
      vdatu      as RequestedDeliveryDate

}
