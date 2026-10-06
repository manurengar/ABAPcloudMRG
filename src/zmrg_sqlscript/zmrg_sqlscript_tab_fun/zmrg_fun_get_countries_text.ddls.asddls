@EndUserText.label: 'CDS Table function countries'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
define table function zmrg_fun_get_countries_text
  with parameters
    @Environment.systemField: #SYSTEM_LANGUAGE
    language : abap.lang
returns
{
  client_element_name : abap.clnt;
  langu               : abap.lang;
  natkey              : land1;
  natdescr            : zmrg_employee_natio;
}
implemented by method
  zmrg_cla_cds_table_function=>get_countries_text;