*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
TYPES t_weekday TYPE c LENGTH 10.

TYPES: BEGIN OF t_day_info,
         d             TYPE d,
         weekDayEn     TYPE t_weekday,
         weekDayLocale TYPE t_weekday,
         weekNumber    TYPE i,
       END OF t_day_info,
       tt_day_info type table of t_day_info with empty key.
