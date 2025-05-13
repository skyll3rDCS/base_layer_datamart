drop table if exists custom_b2c_enrollment_and_collection_stg.t_dim_salary_project_agreement_inc purge;

create table if not exists custom_b2c_enrollment_and_collection_stg.t_dim_salary_project_agreement_inc (
   sid                          string
   , num                        string
   , currency_name              string
   , currency_code              string
   , type_code                  string
   , type_name                  string
   , classification_code        string
   , begin_dttmtz               string
   , end_dttmtz                 string
   , planned_end_dt             timestamp
   , status_name                string
   , external_status_code       string
   , external_status_name       string
   , active_flag                int
   , plan_employee_cnt          int
   , fot_ccy_amt                decimal(38, 16)
   , epk_id                     string
   , inn_kio_num                string
   , kpp_code                   string
   , kpp_kn_code                string
   , ogrn_num                   string
   , okpo_num                   string
   , rko_flag                   int
   , reservation_flag           int
   , source_code                string
   , source_name                string
   , source_system_jupiter_code string
   , source_system_name         string
   , tb_code                    string
   , gosb_code                  string
   , vsp_register_code          string
   , sign_option_sid            string
   , sign_option_jupiter_code   string
   , sign_option_code           string
   , sign_option_name           string
   , process_type_code          string
   , process_type_name          string
   , sales_channel_code         string
   , sales_channel_name         string
   , sales_method_code          string
   , sales_method_name          string
   , commission_account_sid     string
   , commission_account_num     string
   , contract_version_sid       string
   , source_ctl_action          string
   , ctl_action                 string
   , ctl_loading                bigint
   , ctl_validfrom              timestamp
   , start_dttm                 timestamp
   , end_dttm                   timestamp
   , tech_distr_name            string
   , row_hash					string
)
partitioned by (part_1_day string comment 'Партиционирование данных по суткам')
STORED AS PARQUET TBLPROPERTIES ('PARQUET.COMPRESS'='SNAPPY', 'transactional'='false');