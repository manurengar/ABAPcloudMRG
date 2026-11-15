@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMRG_C_SALESORDER_CONTRACT
provider contract transactional_query
  as projection on ZMRG_I_SALESORDER_CONTRACT
{
  key SalesOrder,
      CreationDate,
      CreationTime,
      CreatedByUser,
      SalesOrderType,
      SDDocumentCategory,
      SalesOrganization ,
      DistributionChannel,
      OrganizationDivision,
      SalesOffice,
      SalesGroup,
      SoldToParty,
      PurchaseOrderByCustomer,
      CustomerPurchaseOrderDate,
      RequestedDeliveryDate
}
