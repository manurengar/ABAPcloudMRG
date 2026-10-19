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

TYPES: BEGIN OF t_grouped_days,
         days_diff TYPE i,
       END OF t_grouped_days,
       tt_grouped_days TYPE TABLE OF t_grouped_days WITH EMPTY KEY.



TYPES: BEGIN OF t_mapper_source_tab,
         id       TYPE i,
         sentence TYPE string,
       END OF t_mapper_source_tab,
       tt_mapper_source_tab TYPE TABLE OF t_mapper_source_tab WITH EMPTY KEY.

TYPES: BEGIN OF t_mapper_returned_tab,
         id   TYPE i,
         c    TYPE c LENGTH 1,
         freq TYPE i,
       END OF t_mapper_returned_tab,
       tt_mapper_output_tab TYPE TABLE OF t_mapper_returned_tab WITH EMPTY KEY.

TYPES: BEGIN OF t_reducer_input_tab,
         id   TYPE i,
         freq TYPE i,
       END OF t_reducer_input_tab,
       tt_reducer_input_tab TYPE TABLE OF t_reducer_input_tab WITH EMPTY KEY.

types c01 type c length 1.

TYPES: BEGIN OF t_reducer_output_tab,
         c           TYPE c LENGTH 1,
         occu_per_id TYPE i,
         total_freq  TYPE i,
       END OF t_reducer_output_tab,
       tt_reducer_output_tab TYPE TABLE OF t_reducer_output_tab WITH EMPTY KEY.
