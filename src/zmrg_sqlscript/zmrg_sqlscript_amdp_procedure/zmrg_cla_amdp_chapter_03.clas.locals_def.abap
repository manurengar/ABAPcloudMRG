TYPES: BEGIN OF t_map_merge_sample,
         my_key    TYPE string,
         days_diff TYPE i,
       END OF t_map_merge_sample,
       tt_map_merge_sample TYPE TABLE OF t_map_merge_sample WITH EMPTY KEY.

TYPES: BEGIN OF t_source_tab,
         my_key     TYPE string,
         start_date TYPE datn,
         end_date   TYPE datn,
       END OF t_source_tab,
       tt_source_tab TYPE TABLE OF t_source_tab WITH EMPTY KEY.
