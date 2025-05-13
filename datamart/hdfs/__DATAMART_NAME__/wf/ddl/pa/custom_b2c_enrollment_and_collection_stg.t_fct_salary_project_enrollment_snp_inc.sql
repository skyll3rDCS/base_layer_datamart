drop table if exists custom_b2c_enrollment_and_collection_stg.t_dim_salary_project_enrollment_snp_inc purge;

drop table if exists custom_b2c_enrollment_and_collection_stg.t_fct_salary_project_enrollment_snp_inc;

create table if not exists custom_b2c_enrollment_and_collection_stg.t_fct_salary_project_enrollment_snp_inc (
   sid                                string
   , document_sid                     string
   , registry_enrollment_sid          string
   , payer_epk_id                     string
   , receiver_epk_id                  string
   , client_type_code                 string
   , registered_self_employed_flag    int
   , phys_resident_flag               int
   , legal_entity_resident_flag       int
   , payer_inn_num                    string
   , registry_num                     string
   , agreement_num                    string
   , registry_receive_dttm            timestamp
   , plan_enrollment_dt               timestamp
   , fact_enrollment_dttm             timestamp
   , operation_day_dt                 timestamp
   , registry_incoming_file_ccy_amt   decimal(38,16)
   , ccy_amt                          decimal(38,16)
   , control_sum_ccy_amt              decimal(38,16)
   , status_code                      string
   , registry_receiver_cnt            int
   , type_code                        string
   , registry_tb_code                 string
   , account_gosb_code                string
   , account_tb_department_code       string
   , account_tb_department_name       string
   , osb_code                         string
   , vsp_code                         string
   , vsp_operator_code                string
   ---
   , operation_sid                    string
   , receiver_inn_num                 string
   , cor_acc_valuing_dttm             timestamp
   , cor_acc_currency_code            string
   , cor_acc_ccy_amt                  decimal(38,16)
   , receiver_acc_currency_code       string
   , payer_name                       string
   , payer_account_num                string
   , payer_bank_name                  string
   , payer_bank_account_num           string
   , payer_bank_bic_code              string
   , intermediary_bank_name           string
   , intermediary_bank_account_num    string
   , intermediary_bank_bic_code       string
   , receiver_bank_name               string
   , receiver_bank_account_num        string
   , receiver_bank_bic_code           string
   , receiver_full_name               string
   , receiver_account_num             string
   , purpose_txt                      string
   , receiver_acc_owner_full_name     string
   , debit_account_num                string
   , credit_account_num               string
   ---
   , service_sid                      string 
   , document_create_dttm             timestamp
   , document_processing_code         string    
   , registry_type_code               string       
   , document_num                     string
   , digital_doc_origin_num           string        
   , digital_doc_origin_dt            timestamp  
   , digital_doc_originator_code      string     
   , digital_doc_client_dt            timestamp
   , pension_type_code                string
   ---
   , ctl_action                       string
   , ctl_loading                      bigint
   , ctl_validfrom                    timestamp
   , source_system_code               string
   , tech_distr_name                  string
   , row_hash                         string
)
partitioned by (part_1_day string comment 'Партиционирование данных по суткам')
STORED AS PARQUET TBLPROPERTIES ('PARQUET.COMPRESS'='SNAPPY', 'transactional'='false');
