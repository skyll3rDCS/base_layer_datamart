insert into table $app.stg.schema.name.$app.stg.snp.inc.table.name partition (part_1_day)
(
sid
, document_sid
, registry_enrollment_sid
, payer_epk_id
, receiver_epk_id
, client_type_code
, registered_self_employed_flag
, phys_resident_flag
, legal_entity_resident_flag
, payer_inn_num
, registry_num
, agreement_num
, registry_receive_dttm
, plan_enrollment_dt
, fact_enrollment_dttm
, operation_day_dt
, registry_incoming_file_ccy_amt
, ccy_amt
, control_sum_ccy_amt
, status_code
, registry_receiver_cnt
, type_code
, registry_tb_code
, account_gosb_code
, account_tb_department_code
, account_tb_department_name
, osb_code
, vsp_code
, vsp_operator_code
--------------------------
, operation_sid
, receiver_inn_num
, cor_acc_valuing_dttm  
, cor_acc_currency_code
, cor_acc_ccy_amt
, receiver_acc_currency_code
, payer_name
, payer_account_num
, payer_bank_name
, payer_bank_account_num
, payer_bank_bic_code
, intermediary_bank_name
, intermediary_bank_account_num
, intermediary_bank_bic_code
, receiver_bank_name
, receiver_bank_account_num
, receiver_bank_bic_code
, receiver_full_name
, receiver_account_num
, purpose_txt    
, receiver_acc_owner_full_name
, debit_account_num
, credit_account_num    
--------------------------
, service_sid
, document_create_dttm
, document_processing_code
, registry_type_code
, document_num
, digital_doc_origin_num
, digital_doc_origin_dt
, digital_doc_originator_code
, digital_doc_client_dt
, pension_type_code
--------------------------
, ctl_action
, ctl_loading
, ctl_validfrom
, source_system_code
, tech_distr_name
, row_hash
, part_1_day
)

select
    t2.sid
  , t2.document_sid
  , t2.registry_enrollment_sid
  , t2.payer_epk_id
  , t2.receiver_epk_id
  , t2.client_type_code
  , t2.registered_self_employed_flag
  , t2.phys_resident_flag
  , t2.legal_entity_resident_flag
  , t2.payer_inn_num
  , t2.registry_num
  , t2.agreement_num
  , t2.registry_receive_dttm
  , t2.plan_enrollment_dt
  , t2.fact_enrollment_dttm
  , t2.operation_day_dt
  , t2.registry_incoming_file_ccy_amt
  , t2.ccy_amt
  , t2.control_sum_ccy_amt
  , t2.status_code
  , t2.registry_receiver_cnt
  , t2.type_code
  , t2.registry_tb_code
  , t2.account_gosb_code
  , t2.account_tb_department_code
  , t2.account_tb_department_name
  , t2.osb_code
  , t2.vsp_code
  , t2.vsp_operator_code
  --------------------------
  , t2.operation_sid
  , t2.receiver_inn_num
  , t2.cor_acc_valuing_dttm  
  , t2.cor_acc_currency_code
  , t2.cor_acc_ccy_amt
  , t2.receiver_acc_currency_code
  , t2.payer_name
  , t2.payer_account_num
  , t2.payer_bank_name
  , t2.payer_bank_account_num
  , t2.payer_bank_bic_code
  , t2.intermediary_bank_name
  , t2.intermediary_bank_account_num
  , t2.intermediary_bank_bic_code
  , t2.receiver_bank_name
  , t2.receiver_bank_account_num
  , t2.receiver_bank_bic_code
  , t2.receiver_full_name
  , t2.receiver_account_num
  , t2.purpose_txt    
  , t2.receiver_acc_owner_full_name
  , t2.debit_account_num
  , t2.credit_account_num   
  --------------------------
  , t2.service_sid
  , t2.document_create_dttm
  , t2.document_processing_code
  , t2.registry_type_code
  , t2.document_num
  , t2.digital_doc_origin_num
  , t2.digital_doc_origin_dt
  , t2.digital_doc_originator_code
  , t2.digital_doc_client_dt
  , t2.pension_type_code
  --------------------------
  , t2.ctl_action
  , t2.ctl_loading
  , t2.ctl_validfrom
  , t2.source_system_code
  , t2.tech_distr_name
  , t2.row_hash
  , t2.part_1_day
from(
    select
        t1.sid
      , t1.document_sid
      , t1.registry_enrollment_sid
      , t1.payer_epk_id
      , t1.receiver_epk_id
      , t1.client_type_code
      , t1.registered_self_employed_flag
      , t1.phys_resident_flag
      , t1.legal_entity_resident_flag
      , t1.payer_inn_num
      , t1.registry_num
      , t1.agreement_num
      , t1.registry_receive_dttm
      , t1.plan_enrollment_dt
      , t1.fact_enrollment_dttm
      , t1.operation_day_dt
      , t1.registry_incoming_file_ccy_amt
      , t1.ccy_amt
      , t1.control_sum_ccy_amt
      , t1.status_code
      , t1.registry_receiver_cnt
      , t1.type_code
      , t1.registry_tb_code
      , t1.account_gosb_code
      , t1.account_tb_department_code
      , t1.account_tb_department_name
      , t1.osb_code
      , t1.vsp_code
      , t1.vsp_operator_code
      --------------------------
      , t1.operation_sid
      , t1.receiver_inn_num
      , t1.cor_acc_valuing_dttm  
      , t1.cor_acc_currency_code
      , t1.cor_acc_ccy_amt
      , t1.receiver_acc_currency_code
      , t1.payer_name
      , t1.payer_account_num
      , t1.payer_bank_name
      , t1.payer_bank_account_num
      , t1.payer_bank_bic_code
      , t1.intermediary_bank_name
      , t1.intermediary_bank_account_num
      , t1.intermediary_bank_bic_code
      , t1.receiver_bank_name
      , t1.receiver_bank_account_num
      , t1.receiver_bank_bic_code
      , t1.receiver_full_name
      , t1.receiver_account_num
      , t1.purpose_txt    
      , t1.receiver_acc_owner_full_name
      , t1.debit_account_num
      , t1.credit_account_num   
      --------------------------
      , t1.service_sid
      , t1.document_create_dttm
      , t1.document_processing_code
      , t1.registry_type_code
      , t1.document_num
      , t1.digital_doc_origin_num
      , t1.digital_doc_origin_dt
      , t1.digital_doc_originator_code
      , t1.digital_doc_client_dt
      , t1.pension_type_code
      --------------------------
      , t1.ctl_action
      , t1.ctl_loading
      , t1.ctl_validfrom
      , t1.source_system_code
      , t1.tech_distr_name
      , t1.row_hash
      , t1.part_1_day
      , row_number() over (partition by t1.row_hash order by t1.operation_day_dt) as rn
    from(
        select
            dp.sid
          , dp.document_sid
          , dp.registry_enrollment_sid
          , dp.payer_epk_id
          , dp.receiver_epk_id
          , dp.client_type_code
          , dp.registered_self_employed_flag
          , dp.phys_resident_flag
          , dp.legal_entity_resident_flag
          , dp.payer_inn_num
          , dp.registry_num
          , dp.agreement_num
          , dp.registry_receive_dttm
          , dp.plan_enrollment_dt
          , dp.fact_enrollment_dttm
          , dp.operation_day_dt
          , dp.registry_incoming_file_ccy_amt
          , dp.ccy_amt
          , dp.control_sum_ccy_amt
          , dp.status_code
          , dp.registry_receiver_cnt
          , dp.type_code
          , dp.registry_tb_code
          , dp.account_gosb_code
          , dp.account_tb_department_code
          , dp.account_tb_department_name
          , dp.osb_code
          , dp.vsp_code
          , dp.vsp_operator_code
          --------------------------
          , dp.operation_sid
          , dp.receiver_inn_num
          , dp.cor_acc_valuing_dttm  
          , dp.cor_acc_currency_code
          , dp.cor_acc_ccy_amt
          , dp.receiver_acc_currency_code
          , dp.payer_name
          , dp.payer_account_num
          , dp.payer_bank_name
          , dp.payer_bank_account_num
          , dp.payer_bank_bic_code
          , dp.intermediary_bank_name
          , dp.intermediary_bank_account_num
          , dp.intermediary_bank_bic_code
          , dp.receiver_bank_name
          , dp.receiver_bank_account_num
          , dp.receiver_bank_bic_code
          , dp.receiver_full_name
          , dp.receiver_account_num
          , dp.purpose_txt    
          , dp.receiver_acc_owner_full_name
          , dp.debit_account_num
          , dp.credit_account_num   
          --------------------------
          , dp.service_sid
          , dp.document_create_dttm
          , dp.document_processing_code
          , dp.registry_type_code
          , dp.document_num
          , dp.digital_doc_origin_num
          , dp.digital_doc_origin_dt
          , dp.digital_doc_originator_code
          , dp.digital_doc_client_dt
          , dp.pension_type_code
          --------------------------
          , dp.ctl_action
          , dp.ctl_loading
          , dp.ctl_validfrom
          , dp.source_system_code
          , dp.tech_distr_name
          , dp.row_hash
          , dp.part_1_day
          from $app.stg.schema.name.$app.stg.table.name as dp
        union all
          select
            tgt.sid
          , tgt.document_sid
          , tgt.registry_enrollment_sid
          , tgt.payer_epk_id
          , tgt.receiver_epk_id
          , tgt.client_type_code
          , tgt.registered_self_employed_flag
          , tgt.phys_resident_flag
          , tgt.legal_entity_resident_flag
          , tgt.payer_inn_num
          , tgt.registry_num
          , tgt.agreement_num
          , tgt.registry_receive_dttm
          , tgt.plan_enrollment_dt
          , tgt.fact_enrollment_dttm
          , tgt.operation_day_dt
          , tgt.registry_incoming_file_ccy_amt
          , tgt.ccy_amt
          , tgt.control_sum_ccy_amt
          , tgt.status_code
          , tgt.registry_receiver_cnt
          , tgt.type_code
          , tgt.registry_tb_code
          , tgt.account_gosb_code
          , tgt.account_tb_department_code
          , tgt.account_tb_department_name
          , tgt.osb_code
          , tgt.vsp_code
          , tgt.vsp_operator_code
          --------------------------
          , tgt.operation_sid
          , tgt.receiver_inn_num
          , tgt.cor_acc_valuing_dttm  
          , tgt.cor_acc_currency_code
          , tgt.cor_acc_ccy_amt
          , tgt.receiver_acc_currency_code
          , tgt.payer_name
          , tgt.payer_account_num
          , tgt.payer_bank_name
          , tgt.payer_bank_account_num
          , tgt.payer_bank_bic_code
          , tgt.intermediary_bank_name
          , tgt.intermediary_bank_account_num
          , tgt.intermediary_bank_bic_code
          , tgt.receiver_bank_name
          , tgt.receiver_bank_account_num
          , tgt.receiver_bank_bic_code
          , tgt.receiver_full_name
          , tgt.receiver_account_num
          , tgt.purpose_txt    
          , tgt.receiver_acc_owner_full_name
          , tgt.debit_account_num
          , tgt.credit_account_num  
          --------------------------
          , tgt.service_sid
          , tgt.document_create_dttm
          , tgt.document_processing_code
          , tgt.registry_type_code
          , tgt.document_num
          , tgt.digital_doc_origin_num
          , tgt.digital_doc_origin_dt
          , tgt.digital_doc_originator_code
          , tgt.digital_doc_client_dt
          , tgt.pension_type_code
          --------------------------
          , tgt.ctl_action
          , tgt.ctl_loading
          , tgt.ctl_validfrom
          , tgt.source_system_code
          , tgt.tech_distr_name
          , tgt.row_hash
          , tgt.part_1_day
          from 
               (select distinct part_1_day from $app.stg.schema.name.$app.stg.table.name) dp
               join $app.target.schema.name.$app.target.table.name as tgt 
               on dp.part_1_day = tgt.part_1_day
          -- where
          --    tgt.part_1_day in (select distinct part_1_day from $app.stg.schema.name.$app.stg.table.name)
        ) t1
) t2 
where rn = 1
;
