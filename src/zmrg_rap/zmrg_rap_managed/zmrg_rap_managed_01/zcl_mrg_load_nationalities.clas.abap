CLASS zcl_mrg_load_nationalities DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_nationality,
             spras    TYPE spras,
             natkey   TYPE land1,
             natdescr TYPE zmrg_employee_natio,
           END OF ty_nationality,
           tt_nationality TYPE STANDARD TABLE OF ty_nationality WITH EMPTY KEY.

    METHODS get_nationalities
      RETURNING VALUE(rt_data) TYPE tt_nationality.

ENDCLASS.


CLASS zcl_mrg_load_nationalities IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA range_tab TYPE TABLE OF zmrg_ranges WITH DEFAULT KEY.

    APPEND INITIAL LINE TO range_tab ASSIGNING FIELD-SYMBOL(<range>).
    <range>-range_key = '01'.
    <range>-range_value = '10000000'.

    APPEND INITIAL LINE TO range_tab ASSIGNING <range>.
    <range>-range_key = '02'.
    <range>-range_value = '2000000'.

    MODIFY zmrg_ranges FROM TABLE @range_tab.
    COMMIT WORK.
  ENDMETHOD.


  METHOD get_nationalities.

    rt_data = VALUE #(
      " A
      ( spras = 'E'  natkey = 'AF'  natdescr = 'Afghan'              )
      ( spras = 'E'  natkey = 'AL'  natdescr = 'Albanian'            )
      ( spras = 'E'  natkey = 'DZ'  natdescr = 'Algerian'            )
      ( spras = 'E'  natkey = 'AD'  natdescr = 'Andorran'            )
      ( spras = 'E'  natkey = 'AO'  natdescr = 'Angolan'             )
      ( spras = 'E'  natkey = 'AR'  natdescr = 'Argentine'           )
      ( spras = 'E'  natkey = 'AM'  natdescr = 'Armenian'            )
      ( spras = 'E'  natkey = 'AU'  natdescr = 'Australian'          )
      ( spras = 'E'  natkey = 'AT'  natdescr = 'Austrian'            )
      ( spras = 'E'  natkey = 'AZ'  natdescr = 'Azerbaijani'         )
      " B
      ( spras = 'E'  natkey = 'BS'  natdescr = 'Bahamian'            )
      ( spras = 'E'  natkey = 'BH'  natdescr = 'Bahraini'            )
      ( spras = 'E'  natkey = 'BD'  natdescr = 'Bangladeshi'         )
      ( spras = 'E'  natkey = 'BY'  natdescr = 'Belarusian'          )
      ( spras = 'E'  natkey = 'BE'  natdescr = 'Belgian'             )
      ( spras = 'E'  natkey = 'BZ'  natdescr = 'Belizean'            )
      ( spras = 'E'  natkey = 'BJ'  natdescr = 'Beninese'            )
      ( spras = 'E'  natkey = 'BT'  natdescr = 'Bhutanese'           )
      ( spras = 'E'  natkey = 'BO'  natdescr = 'Bolivian'            )
      ( spras = 'E'  natkey = 'BA'  natdescr = 'Bosnian'             )
      ( spras = 'E'  natkey = 'BR'  natdescr = 'Brazilian'           )
      ( spras = 'E'  natkey = 'BN'  natdescr = 'Bruneian'            )
      ( spras = 'E'  natkey = 'BG'  natdescr = 'Bulgarian'           )
      ( spras = 'E'  natkey = 'BF'  natdescr = 'Burkinabe'           )
      ( spras = 'E'  natkey = 'BI'  natdescr = 'Burundian'           )
      " C
      ( spras = 'E'  natkey = 'CV'  natdescr = 'Cape Verdean'        )
      ( spras = 'E'  natkey = 'KH'  natdescr = 'Cambodian'           )
      ( spras = 'E'  natkey = 'CM'  natdescr = 'Cameroonian'         )
      ( spras = 'E'  natkey = 'CA'  natdescr = 'Canadian'            )
      ( spras = 'E'  natkey = 'CF'  natdescr = 'Central African'     )
      ( spras = 'E'  natkey = 'TD'  natdescr = 'Chadian'             )
      ( spras = 'E'  natkey = 'CL'  natdescr = 'Chilean'             )
      ( spras = 'E'  natkey = 'CN'  natdescr = 'Chinese'             )
      ( spras = 'E'  natkey = 'CO'  natdescr = 'Colombian'           )
      ( spras = 'E'  natkey = 'KM'  natdescr = 'Comorian'            )
      ( spras = 'E'  natkey = 'CG'  natdescr = 'Congolese'           )
      ( spras = 'E'  natkey = 'CR'  natdescr = 'Costa Rican'         )
      ( spras = 'E'  natkey = 'HR'  natdescr = 'Croatian'            )
      ( spras = 'E'  natkey = 'CU'  natdescr = 'Cuban'               )
      ( spras = 'E'  natkey = 'CY'  natdescr = 'Cypriot'             )
      ( spras = 'E'  natkey = 'CZ'  natdescr = 'Czech'               )
      " D-F
      ( spras = 'E'  natkey = 'DK'  natdescr = 'Danish'              )
      ( spras = 'E'  natkey = 'DJ'  natdescr = 'Djiboutian'          )
      ( spras = 'E'  natkey = 'DO'  natdescr = 'Dominican'           )
      ( spras = 'E'  natkey = 'EC'  natdescr = 'Ecuadorian'          )
      ( spras = 'E'  natkey = 'EG'  natdescr = 'Egyptian'            )
      ( spras = 'E'  natkey = 'SV'  natdescr = 'Salvadoran'          )
      ( spras = 'E'  natkey = 'GQ'  natdescr = 'Equatorial Guinean'  )
      ( spras = 'E'  natkey = 'ER'  natdescr = 'Eritrean'            )
      ( spras = 'E'  natkey = 'EE'  natdescr = 'Estonian'            )
      ( spras = 'E'  natkey = 'SZ'  natdescr = 'Swazi'               )
      ( spras = 'E'  natkey = 'ET'  natdescr = 'Ethiopian'           )
      ( spras = 'E'  natkey = 'FJ'  natdescr = 'Fijian'              )
      ( spras = 'E'  natkey = 'FI'  natdescr = 'Finnish'             )
      ( spras = 'E'  natkey = 'FR'  natdescr = 'French'              )
      " G
      ( spras = 'E'  natkey = 'GA'  natdescr = 'Gabonese'            )
      ( spras = 'E'  natkey = 'GM'  natdescr = 'Gambian'             )
      ( spras = 'E'  natkey = 'GE'  natdescr = 'Georgian'            )
      ( spras = 'E'  natkey = 'DE'  natdescr = 'German'              )
      ( spras = 'E'  natkey = 'GH'  natdescr = 'Ghanaian'            )
      ( spras = 'E'  natkey = 'GR'  natdescr = 'Greek'               )
      ( spras = 'E'  natkey = 'GT'  natdescr = 'Guatemalan'          )
      ( spras = 'E'  natkey = 'GN'  natdescr = 'Guinean'             )
      ( spras = 'E'  natkey = 'GW'  natdescr = 'Bissau-Guinean'      )
      ( spras = 'E'  natkey = 'GY'  natdescr = 'Guyanese'            )
      " H-I
      ( spras = 'E'  natkey = 'HT'  natdescr = 'Haitian'             )
      ( spras = 'E'  natkey = 'HN'  natdescr = 'Honduran'            )
      ( spras = 'E'  natkey = 'HU'  natdescr = 'Hungarian'           )
      ( spras = 'E'  natkey = 'IS'  natdescr = 'Icelandic'           )
      ( spras = 'E'  natkey = 'IN'  natdescr = 'Indian'              )
      ( spras = 'E'  natkey = 'ID'  natdescr = 'Indonesian'          )
      ( spras = 'E'  natkey = 'IR'  natdescr = 'Iranian'             )
      ( spras = 'E'  natkey = 'IQ'  natdescr = 'Iraqi'               )
      ( spras = 'E'  natkey = 'IE'  natdescr = 'Irish'               )
      ( spras = 'E'  natkey = 'IL'  natdescr = 'Israeli'             )
      ( spras = 'E'  natkey = 'IT'  natdescr = 'Italian'             )
      " J-K
      ( spras = 'E'  natkey = 'JM'  natdescr = 'Jamaican'            )
      ( spras = 'E'  natkey = 'JP'  natdescr = 'Japanese'            )
      ( spras = 'E'  natkey = 'JO'  natdescr = 'Jordanian'           )
      ( spras = 'E'  natkey = 'KZ'  natdescr = 'Kazakhstani'         )
      ( spras = 'E'  natkey = 'KE'  natdescr = 'Kenyan'              )
      ( spras = 'E'  natkey = 'KI'  natdescr = 'I-Kiribati'          )
      ( spras = 'E'  natkey = 'KW'  natdescr = 'Kuwaiti'             )
      ( spras = 'E'  natkey = 'KG'  natdescr = 'Kyrgyz'              )
      " L
      ( spras = 'E'  natkey = 'LA'  natdescr = 'Laotian'             )
      ( spras = 'E'  natkey = 'LV'  natdescr = 'Latvian'             )
      ( spras = 'E'  natkey = 'LB'  natdescr = 'Lebanese'            )
      ( spras = 'E'  natkey = 'LS'  natdescr = 'Basotho'             )
      ( spras = 'E'  natkey = 'LR'  natdescr = 'Liberian'            )
      ( spras = 'E'  natkey = 'LY'  natdescr = 'Libyan'              )
      ( spras = 'E'  natkey = 'LI'  natdescr = 'Liechtensteiner'     )
      ( spras = 'E'  natkey = 'LT'  natdescr = 'Lithuanian'          )
      ( spras = 'E'  natkey = 'LU'  natdescr = 'Luxembourgish'       )
      " M
      ( spras = 'E'  natkey = 'MG'  natdescr = 'Malagasy'            )
      ( spras = 'E'  natkey = 'MW'  natdescr = 'Malawian'            )
      ( spras = 'E'  natkey = 'MY'  natdescr = 'Malaysian'           )
      ( spras = 'E'  natkey = 'MV'  natdescr = 'Maldivian'           )
      ( spras = 'E'  natkey = 'ML'  natdescr = 'Malian'              )
      ( spras = 'E'  natkey = 'MT'  natdescr = 'Maltese'             )
      ( spras = 'E'  natkey = 'MH'  natdescr = 'Marshallese'         )
      ( spras = 'E'  natkey = 'MR'  natdescr = 'Mauritanian'         )
      ( spras = 'E'  natkey = 'MU'  natdescr = 'Mauritian'           )
      ( spras = 'E'  natkey = 'MX'  natdescr = 'Mexican'             )
      ( spras = 'E'  natkey = 'FM'  natdescr = 'Micronesian'         )
      ( spras = 'E'  natkey = 'MD'  natdescr = 'Moldovan'            )
      ( spras = 'E'  natkey = 'MC'  natdescr = 'Monegasque'          )
      ( spras = 'E'  natkey = 'MN'  natdescr = 'Mongolian'           )
      ( spras = 'E'  natkey = 'ME'  natdescr = 'Montenegrin'         )
      ( spras = 'E'  natkey = 'MA'  natdescr = 'Moroccan'            )
      ( spras = 'E'  natkey = 'MZ'  natdescr = 'Mozambican'          )
      ( spras = 'E'  natkey = 'MM'  natdescr = 'Burmese'             )
      " N
      ( spras = 'E'  natkey = 'NA'  natdescr = 'Namibian'            )
      ( spras = 'E'  natkey = 'NR'  natdescr = 'Nauruan'             )
      ( spras = 'E'  natkey = 'NP'  natdescr = 'Nepali'              )
      ( spras = 'E'  natkey = 'NL'  natdescr = 'Dutch'               )
      ( spras = 'E'  natkey = 'NZ'  natdescr = 'New Zealander'       )
      ( spras = 'E'  natkey = 'NI'  natdescr = 'Nicaraguan'          )
      ( spras = 'E'  natkey = 'NE'  natdescr = 'Nigerien'            )
      ( spras = 'E'  natkey = 'NG'  natdescr = 'Nigerian'            )
      ( spras = 'E'  natkey = 'NO'  natdescr = 'Norwegian'           )
      " O-P
      ( spras = 'E'  natkey = 'OM'  natdescr = 'Omani'               )
      ( spras = 'E'  natkey = 'PK'  natdescr = 'Pakistani'           )
      ( spras = 'E'  natkey = 'PW'  natdescr = 'Palauan'             )
      ( spras = 'E'  natkey = 'PA'  natdescr = 'Panamanian'          )
      ( spras = 'E'  natkey = 'PG'  natdescr = 'Papua New Guinean'   )
      ( spras = 'E'  natkey = 'PY'  natdescr = 'Paraguayan'          )
      ( spras = 'E'  natkey = 'PE'  natdescr = 'Peruvian'            )
      ( spras = 'E'  natkey = 'PH'  natdescr = 'Filipino'            )
      ( spras = 'E'  natkey = 'PL'  natdescr = 'Polish'              )
      ( spras = 'E'  natkey = 'PT'  natdescr = 'Portuguese'          )
      " Q-R
      ( spras = 'E'  natkey = 'QA'  natdescr = 'Qatari'              )
      ( spras = 'E'  natkey = 'RO'  natdescr = 'Romanian'            )
      ( spras = 'E'  natkey = 'RU'  natdescr = 'Russian'             )
      ( spras = 'E'  natkey = 'RW'  natdescr = 'Rwandan'             )
      " S
      ( spras = 'E'  natkey = 'KN'  natdescr = 'Kittitian'           )
      ( spras = 'E'  natkey = 'LC'  natdescr = 'Saint Lucian'        )
      ( spras = 'E'  natkey = 'VC'  natdescr = 'Vincentian'          )
      ( spras = 'E'  natkey = 'WS'  natdescr = 'Samoan'              )
      ( spras = 'E'  natkey = 'SM'  natdescr = 'Sammarinese'         )
      ( spras = 'E'  natkey = 'ST'  natdescr = 'Sao Tomean'          )
      ( spras = 'E'  natkey = 'SA'  natdescr = 'Saudi Arabian'       )
      ( spras = 'E'  natkey = 'SN'  natdescr = 'Senegalese'          )
      ( spras = 'E'  natkey = 'RS'  natdescr = 'Serbian'             )
      ( spras = 'E'  natkey = 'SC'  natdescr = 'Seychellois'         )
      ( spras = 'E'  natkey = 'SL'  natdescr = 'Sierra Leonean'      )
      ( spras = 'E'  natkey = 'SG'  natdescr = 'Singaporean'         )
      ( spras = 'E'  natkey = 'SK'  natdescr = 'Slovak'              )
      ( spras = 'E'  natkey = 'SI'  natdescr = 'Slovenian'           )
      ( spras = 'E'  natkey = 'SB'  natdescr = 'Solomon Islander'    )
      ( spras = 'E'  natkey = 'SO'  natdescr = 'Somali'              )
      ( spras = 'E'  natkey = 'ZA'  natdescr = 'South African'       )
      ( spras = 'E'  natkey = 'SS'  natdescr = 'South Sudanese'      )
      ( spras = 'E'  natkey = 'ES'  natdescr = 'Spanish'             )
      ( spras = 'E'  natkey = 'LK'  natdescr = 'Sri Lankan'          )
      ( spras = 'E'  natkey = 'SD'  natdescr = 'Sudanese'            )
      ( spras = 'E'  natkey = 'SR'  natdescr = 'Surinamese'          )
      ( spras = 'E'  natkey = 'SE'  natdescr = 'Swedish'             )
      ( spras = 'E'  natkey = 'CH'  natdescr = 'Swiss'               )
      ( spras = 'E'  natkey = 'SY'  natdescr = 'Syrian'              )
      " T
      ( spras = 'E'  natkey = 'TW'  natdescr = 'Taiwanese'           )
      ( spras = 'E'  natkey = 'TJ'  natdescr = 'Tajik'               )
      ( spras = 'E'  natkey = 'TZ'  natdescr = 'Tanzanian'           )
      ( spras = 'E'  natkey = 'TH'  natdescr = 'Thai'                )
      ( spras = 'E'  natkey = 'TL'  natdescr = 'Timorese'            )
      ( spras = 'E'  natkey = 'TG'  natdescr = 'Togolese'            )
      ( spras = 'E'  natkey = 'TO'  natdescr = 'Tongan'              )
      ( spras = 'E'  natkey = 'TT'  natdescr = 'Trinidadian'         )
      ( spras = 'E'  natkey = 'TN'  natdescr = 'Tunisian'            )
      ( spras = 'E'  natkey = 'TR'  natdescr = 'Turkish'             )
      ( spras = 'E'  natkey = 'TM'  natdescr = 'Turkmen'             )
      ( spras = 'E'  natkey = 'TV'  natdescr = 'Tuvaluan'            )
      " U-Z
      ( spras = 'E'  natkey = 'UG'  natdescr = 'Ugandan'             )
      ( spras = 'E'  natkey = 'UA'  natdescr = 'Ukrainian'           )
      ( spras = 'E'  natkey = 'AE'  natdescr = 'Emirati'             )
      ( spras = 'E'  natkey = 'GB'  natdescr = 'British'             )
      ( spras = 'E'  natkey = 'US'  natdescr = 'American'            )
      ( spras = 'E'  natkey = 'UY'  natdescr = 'Uruguayan'           )
      ( spras = 'E'  natkey = 'UZ'  natdescr = 'Uzbek'               )
      ( spras = 'E'  natkey = 'VU'  natdescr = 'Vanuatuan'           )
      ( spras = 'E'  natkey = 'VE'  natdescr = 'Venezuelan'          )
      ( spras = 'E'  natkey = 'VN'  natdescr = 'Vietnamese'          )
      ( spras = 'E'  natkey = 'YE'  natdescr = 'Yemeni'              )
      ( spras = 'E'  natkey = 'ZM'  natdescr = 'Zambian'             )
      ( spras = 'E'  natkey = 'ZW'  natdescr = 'Zimbabwean'          )
    ).

  ENDMETHOD.

ENDCLASS.
