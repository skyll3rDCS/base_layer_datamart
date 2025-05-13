insert into $app.stg.schema.name.$app.stg.table.name
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
---
, ctl_action
, ctl_loading
, ctl_validfrom
, source_system_code
, tech_distr_name
, row_hash
, part_1_day
)
select
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
---
, 'I'                                                                                           as ctl_action
, cast('$app.ctl.loading' as bigint)                                                            as ctl_loading
, current_timestamp()                                                                           as ctl_validfrom
,'ППРБ.РБР'                                                                                     as source_system_code
,'$app.version'                                                                                 as tech_distr_name
, row_hash
, cast(cast(operation_day_dt as date) as string)                                                as part_1_day
from(
    select
    t.sid
    , t.document_sid
    , t.registry_enrollment_sid
    , t.payer_epk_id
    , t.receiver_epk_id
    , t.client_type_code
    , t.registered_self_employed_flag
    , t.phys_resident_flag
    , t.legal_entity_resident_flag
    , t.payer_inn_num
    , t.registry_num
    , t.agreement_num
    , t.registry_receive_dttm
    , t.plan_enrollment_dt
    , t.fact_enrollment_dttm
    , t.operation_day_dt
    , t.registry_incoming_file_ccy_amt
    , t.ccy_amt
    , t.control_sum_ccy_amt
    , t.status_code
    , t.registry_receiver_cnt
    , t.type_code
    , t.registry_tb_code
    , t.account_gosb_code
    , t.account_tb_department_code
    , t.account_tb_department_name
    , t.osb_code
    , t.vsp_code
    , t.vsp_operator_code
    --------------------------
    , t.operation_sid
    , t.receiver_inn_num
    , t.cor_acc_valuing_dttm  
    , t.cor_acc_currency_code
    , t.cor_acc_ccy_amt
    , t.receiver_acc_currency_code
    , t.payer_name
    , t.payer_account_num
    , t.payer_bank_name
    , t.payer_bank_account_num
    , t.payer_bank_bic_code
    , t.intermediary_bank_name
    , t.intermediary_bank_account_num
    , t.intermediary_bank_bic_code
    , t.receiver_bank_name
    , t.receiver_bank_account_num
    , t.receiver_bank_bic_code
    , t.receiver_full_name
    , t.receiver_account_num
    , t.purpose_txt    
    , t.receiver_acc_owner_full_name
    , t.debit_account_num
    , t.credit_account_num  
    --------------------------
    , t.service_sid
    , t.document_create_dttm
    , t.document_processing_code
    , t.registry_type_code
    , t.document_num
    , t.digital_doc_origin_num
    , t.digital_doc_origin_dt
    , t.digital_doc_originator_code
    , t.digital_doc_client_dt
    , t.pension_type_code
    ---
    , t.row_hash
    , row_number() over (partition by t.row_hash order by t.operation_day_dt desc) as rn
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
        ---
        , sha2(
            concat(
                nvl(t1.sid, '0'), nvl(t1.registry_enrollment_sid, '0'),
                nvl(t1.payer_epk_id, '0'), nvl(t1.receiver_epk_id, '0'), nvl(t1.client_type_code, '0'), nvl(t1.registered_self_employed_flag, '0'), nvl(t1.phys_resident_flag, '0'),
                nvl(t1.legal_entity_resident_flag, '0'), nvl(t1.payer_inn_num, '0'), nvl(t1.registry_num, '0'), nvl(t1.agreement_num, '0'), nvl(t1.registry_receive_dttm, '0'),
                nvl(t1.plan_enrollment_dt, '0'), nvl(t1.operation_day_dt, '0'), nvl(t1.registry_incoming_file_ccy_amt, '0'), nvl(t1.ccy_amt, '0'),
                nvl(t1.control_sum_ccy_amt, '0'), nvl(t1.status_code, '0'), nvl(t1.registry_receiver_cnt, '0'), nvl(t1.type_code, '0'), nvl(t1.registry_tb_code, '0'),
                nvl(t1.account_gosb_code, '0'), nvl(t1.account_tb_department_code, '0'), nvl(t1.account_tb_department_name, '0'), nvl(t1.osb_code, '0'), nvl(t1.vsp_code, '0'),
                nvl(t1.vsp_operator_code, '0'), nvl(t1.operation_sid, '0'), nvl(t1.receiver_inn_num, '0'), nvl(t1.cor_acc_currency_code, '0'), 
                nvl(t1.cor_acc_ccy_amt, '0'), nvl(t1.receiver_acc_currency_code, '0'), nvl(t1.payer_name, '0'), nvl(t1.payer_account_num, '0'), nvl(t1.payer_bank_name, '0'),
                nvl(t1.payer_bank_account_num, '0'), nvl(t1.payer_bank_bic_code, '0'), nvl(t1.intermediary_bank_name, '0'), nvl(t1.intermediary_bank_account_num, '0'), 
                nvl(t1.intermediary_bank_bic_code, '0'), nvl(t1.receiver_bank_name, '0'), nvl(t1.receiver_bank_account_num, '0'), nvl(t1.receiver_bank_bic_code, '0'),
                nvl(t1.receiver_full_name, '0'), nvl(t1.receiver_account_num, '0'), nvl(t1.purpose_txt, '0'), nvl(t1.receiver_acc_owner_full_name, '0'),
                nvl(t1.debit_account_num, '0'), nvl(t1.credit_account_num, '0'), nvl(t1.service_sid, '0'), nvl(t1.document_processing_code, '0'), 
                nvl(t1.registry_type_code, '0'), nvl(t1.digital_doc_origin_num, '0'), nvl(t1.digital_doc_origin_dt, '0'), nvl(t1.digital_doc_originator_code, '0'), 
                nvl(t1.digital_doc_client_dt, '0'), nvl(t1.pension_type_code, '0')
                ), 256)                     as row_hash
        from(
            select 
            t2.sid --
            , t2.document_sid
            , t2.registry_enrollment_sid
            , t2.payer_epk_id
            , t2.receiver_epk_id --
            , t2.client_type_code
            , t2.registered_self_employed_flag
            , t2.phys_resident_flag
            , t2.legal_entity_resident_flag
            , t2.payer_inn_num
            , t2.registry_num
            , t2.agreement_num
            , t2.registry_receive_dttm
            , t2.plan_enrollment_dt
            , t2.fact_enrollment_dttm --
            , t2.operation_day_dt
            , t2.registry_incoming_file_ccy_amt
            , t2.ccy_amt
            , t2.control_sum_ccy_amt
            , t2.status_code --
            , t2.registry_receiver_cnt
            , t2.type_code
            , t2.registry_tb_code
            , t2.account_gosb_code
            , t2.account_tb_department_code --
            , t2.account_tb_department_name
            , t2.osb_code --
            , t2.vsp_code --
            , t2.vsp_operator_code
            ---
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
            ---
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
            ---
            from(
            select 
                ini_t.*
                , row_number() over(partition by ini_t.sid order by ini_t.cor_acc_ccy_amt desc) as rn
                from(
                select
                    regrow.rowguid                                                                  as sid --
                    , pay.id                                                                        as document_sid
                    , reg.guid                                                                      as registry_enrollment_sid
                    , coalesce(pay.epk_id, reg.epk_id)                                              as payer_epk_id
                    , regrow.epkid                                                                  as receiver_epk_id --
                    , cast (NULL as string)                                                         as client_type_code
                    , cast (NULL as int)                                                            as registered_self_employed_flag
                    , reg.resident_type                                                             as phys_resident_flag
                    , cast (NULL as int)                                                            as legal_entity_resident_flag
                    , pay.pr_inn                                                                    as payer_inn_num
                    , reg.doc_num                                                                   as registry_num
                    , pay.agreement_number                                                          as agreement_num
                    , reg.receive_time                                                              as registry_receive_dttm
                    , task.targetday                                                                as plan_enrollment_dt
                    , regrow.statetime                                                              as fact_enrollment_dttm --
                    , cast(coalesce(pay.valuedate, '1900-01-01') as timestamp)                      as operation_day_dt
                    , cast(reg.summa as decimal(38,16))                                             as registry_incoming_file_ccy_amt
                    , cast(regrow.summa as decimal(38,16))                                          as ccy_amt
                    , cast(split(replace(reg.check_sum, '|','<sep>'),'<sep>')[2] as decimal(38,16)) as control_sum_ccy_amt
                    , cast(regrow.fort_status as string)                                            as status_code --
                    , reg.row_count                                                                 as registry_receiver_cnt
                    , reg.payment_type                                                              as type_code
                    , cast (reg.id_mega as string)                                                  as registry_tb_code
                    , cast (NULL as string)                                                         as account_gosb_code
                    , cast (regrow.id_mega as string)                                               as account_tb_department_code --
                    , cast (NULL as string)                                                         as account_tb_department_name
                    , cast (regrow.osb_num_dpc as string)                                           as osb_code --
                    , cast (regrow.vsp_num_dpc as string)                                           as vsp_code --
                    , cast (reg.code as string)                                                     as vsp_operator_code
                    ----------------------------------
                    , regrow.objectid                                                               as operation_sid
                    , cast (NULL as string)                                                         as receiver_inn_num
                    , pay.valuedate                                                                 as cor_acc_valuing_dttm  
                    , pay.currency                                                                  as cor_acc_currency_code
                    , cast (pay.total_sum as decimal(38,16))                                        as cor_acc_ccy_amt
                    , pay.currency                                                                  as receiver_acc_currency_code
                    , pay.pr_name                                                                   as payer_name
                    , pay.pr_account                                                                as payer_account_num
                    , pay.pr_bank_name                                                              as payer_bank_name
                    , pay.pr_bank_account                                                           as payer_bank_account_num
                    , pay.pr_bank_bic                                                               as payer_bank_bic_code
                    , cast (NULL as string)                                                         as intermediary_bank_name
                    , cast (NULL as string)                                                         as intermediary_bank_account_num
                    , cast (NULL as string)                                                         as intermediary_bank_bic_code
                    , pay.rc_bank_name                                                              as receiver_bank_name
                    , pay.rc_bank_account                                                           as receiver_bank_account_num
                    , pay.rc_bank_bic                                                               as receiver_bank_bic_code
                    , concat(regrow.last_name_dpc,' ',                                                        
                            regrow.first_name_dpc,' ',                                                            
                            regrow.second_name_dpc)                                                 as receiver_full_name
                    , regrow.account_num                                                            as receiver_account_num
                    , pay.purpose                                                                   as purpose_txt    
                    , concat(regrow.last_name_dpc,' ',                                                        
                            regrow.first_name_dpc,' ',                                                            
                            regrow.second_name_dpc)                                                 as receiver_acc_owner_full_name
                    , pay.pr_account                                                                as debit_account_num
                    , regrow.account_num                                                            as credit_account_num
                    ----------------------------------
                    , ae.service_id                                                                 as service_sid
                    , cast(NULL as timestamp)                                                       as document_create_dttm
                    , cast(NULL as string)                                                          as document_processing_code
                    , cast(reg.type_reg as string)                                                  as registry_type_code
                    , reg.contract_num                                                              as document_num
                    , pay.origin_number                                                             as digital_doc_origin_num
                    , pay.origin_date                                                               as digital_doc_origin_dt
                    , pay.originator                                                                as digital_doc_originator_code
                    , pay.client_date                                                               as digital_doc_client_dt
                    , regrow.joinnumber                                                             as pension_type_code
                    ----------------------------------

                    from ${$app_src_schema_rbr_streamgate}.task 
                        left join ${$app_src_schema_rbr_streamgate}.register      reg  
                            on task.id = reg.task_id 
                            and task.id_mega = reg.id_mega
                        left join ${$app_src_schema_rbr_streamgate}.register_row      regrow
                            on regrow.register_id = reg.id 
                            and regrow.id_mega = reg.id_mega
                        left join ${$app_src_schema_rbr_streamgate}.payment      pay
                            on task.id = pay.task_id 
                            and task.id_mega = pay.id_mega 
                        left join ${$app_src_schema_rbr_streamgate}.ae_service ae 
                            on ae.register_id = regrow.register_id  
                    where 1=1 
                        and task.statecode = 100
                        and regrow.error_code is NULL
                        and regrow.veto != true
                        and regrow.fort_status IN (2, 3)
                        and task.ctl_validfrom $loadDt
                    ) ini_t 
                ) t2
            where t2.rn = 1
            ) t1 
        ) t
    )
where rn = 1
;
