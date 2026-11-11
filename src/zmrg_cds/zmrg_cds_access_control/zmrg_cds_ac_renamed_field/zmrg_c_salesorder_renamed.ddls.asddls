@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMRG_C_SALESORDER_RENAMED
  as select from ZMRG_I_SALESORDER_RENAMED
{
  key SalesOrder,
      CreationDate,
      CreationTime,
      CreatedByUser,
      SalesOrderType,
      SDDocumentCategory,
      SalesOrganization as SalesOrganizationRenamed,
      DistributionChannel as DistributionChannelRenamed,
      OrganizationDivision,
      SalesOffice,
      SalesGroup,
      SoldToParty,
      PurchaseOrderByCustomer,
      CustomerPurchaseOrderDate,
      RequestedDeliveryDate
}
