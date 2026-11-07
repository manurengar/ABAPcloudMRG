@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMRG_C_SALESORDER_REDEF
  as select from ZMRG_I_SALESORDER_REDEF
{
  key SalesOrder,
      CreationDate,
      CreationTime,
      CreatedByUser,
      SalesOrderType,
      SDDocumentCategory,
      SalesOrganization,
      DistributionChannel,
      OrganizationDivision,
      SalesOffice,
      SalesGroup,
      SoldToParty,
      PurchaseOrderByCustomer,
      CustomerPurchaseOrderDate,
      RequestedDeliveryDate
}
