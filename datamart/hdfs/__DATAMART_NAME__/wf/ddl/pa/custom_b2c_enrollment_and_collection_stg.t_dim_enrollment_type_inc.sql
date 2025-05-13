drop table if exists custom_b2c_enrollment_and_collection_stg.t_dim_enrollment_type_inc purge;
create table if not exists custom_b2c_enrollment_and_collection_stg.t_dim_enrollment_type_inc (
   sid                    string
   , parent_type_sid      string
   , code                 string
   , name                 string
   , ctl_action           string
   , ctl_loading          bigint
   , ctl_validfrom        timestamp
   , start_dt             timestamp
   , end_dt               timestamp
   , source_system_code   string
   , tech_distr_name      string
   , row_hash             string
)
partitioned by (part_1_day string comment 'Партиционирование данных по суткам')
STORED AS PARQUET TBLPROPERTIES ('PARQUET.COMPRESS'='SNAPPY', 'transactional'='false');
