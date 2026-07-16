@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view Employee'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity zmrg_c_employee
provider contract transactional_query
as projection on zmrg_i_employee
{   
    @Search.defaultSearchElement: true
    key EmployeeId,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.7
    FirstName,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.7
    LastName,
    Age,
    Gender,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZMRG_I_NATIONALITY_VH', element: 'Nationality' } }]
    Nationality,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.7
    NationalityText,
    CivilStatus,
    Children,
    IdentityNumber,
    ProfilePicture,
    MimeType,
    Filename,
    CreatedBy,
    CreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    LastChangedBy,
    /* Associations */
    _Child: redirected to composition child ZMRG_C_CHILD,
    _Salary: redirected to composition child ZMRG_C_SALARY,
    _Nationality
}
