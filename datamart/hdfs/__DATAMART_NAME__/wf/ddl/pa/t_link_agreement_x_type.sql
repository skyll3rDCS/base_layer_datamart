drop table if exists custom_b2c_enrollment_and_collection.t_link_agreement_x_type purge;

create table if not exists custom_b2c_enrollment_and_collection.t_link_agreement_x_type (
   agreement_sid          string
   , type_sid             string
   , type_code            string
   , type_name            string
   , subtype_sid          string
   , subtype_code         string
   , subtype_name         string
   , contract_version_sid string
   , ctl_action           string
   , ctl_loading          bigint
   , ctl_validfrom        timestamp
   , start_dttm           timestamp
   , end_dttm             timestamp
   , source_system_code   string
   , tech_distr_name      string
   , row_hash			  string
)
partitioned by (part_1_day string comment 'Партиционирование данных по суткам')
STORED AS PARQUET TBLPROPERTIES ('PARQUET.COMPRESS'='SNAPPY', 'transactional'='false');