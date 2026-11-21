@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Annotation Object Model Example 1'
@Metadata.ignorePropagatedAnnotations: true

/*
@ObjectModel.usageType

Defines the expected performance, data volume, and data lifecycle of the CDS view. It is mandatory in SAP Virtual Data Model (VDM) guidelines and checked by ATC (ABAP Test Cockpit).

    •  `serviceQuality`: Expected performance KPI:
    •  #A / #B: High-volume / transactional or background processing (maximum 3 table joins).
    •  #C: UI / single object retrieval in transactions (up to 15 tables).
    •  #D: Analytical queries / reporting.
    •  #X: Default / special cases (e.g., data migration).
    •  `sizeCategory`: Expected number of rows in the largest underlying table (#S < 1k, #M < 100k, #L < 10M, #XL < 100M, #XXL >= 100M).
    •  `dataClass`: Lifecycle of the underlying data (#TRANSACTIONAL, #MASTER, #ORGANIZATIONAL, #CUSTOMIZING, #META, #MIXED).
*/

@ObjectModel.usageType: {
  serviceQuality: #A,
  sizeCategory:   #L,
  dataClass:      #CUSTOMIZING
}

define view entity ZMRG_OBJECTMODEL_USAGETYPE as select from zmrg_cds_01
{
    key username as Username,
    first_name as FirstName,
    last_name as LastName
}
