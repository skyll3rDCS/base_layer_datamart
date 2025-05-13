insert into $app.stg.schema.name.$app.stg.table.name (
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
, 'I'                                                                                           as ctl_action
, cast('$app.ctl.loading' as bigint)                                                            as ctl_loading
, current_timestamp()                                                                           as ctl_validfrom
,'ППРБ.РСР'                                                                                     as source_system_code
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
    --------------------------
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
        --------------------------
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
            rei.object_id                                          as sid                                  
            , pay_ord.upd_uid                                      as document_sid                         
            , ri.object_id                                         as registry_enrollment_sid              
            , ri.organization_id                                   as payer_epk_id                             
            , rei.epk_id                                           as receiver_epk_id                                                                                                   
            , cast (NULL as string)                                as client_type_code                                                                                                   
            , case 
                when rei.is_registered_self_employed = 'true' then 1 
                when rei.is_registered_self_employed = 'false' then 0 
            end                                                    as registered_self_employed_flag        
            , case 
                when rei.row_context_is_resident = 'true' then 1 
                when rei.row_context_is_resident = 'false' then 0 
            end                                                    as phys_resident_flag                   
            , case 
                when ri.roster_is_resident = 'true' then 1 
                when ri.roster_is_resident = 'false' then 0 
            end                                                    as legal_entity_resident_flag    
            , ri.organization_inn                                  as payer_inn_num            
            , ri.blank_number                                      as registry_num               
            , ri.incoming_organization_contract_number             as agreement_num                        
            , ri.receiving_date                                    as registry_receive_dttm                
            , cast (NULL as timestamp)                             as plan_enrollment_dt              
            , rlist.payment_date_time                              as fact_enrollment_dttm          
            , cast (coalesce(ri.context_organization_account_operday, '1900-01-01') as timestamp) as operation_day_dt                  
            , cast (ri.incoming_file_sum as decimal(38,16))        as registry_incoming_file_ccy_amt       
            , cast (rei.row_operation_sum as decimal(38,16))       as ccy_amt                              
            , cast (rei.row_operation_sum as decimal(38,16))       as control_sum_ccy_amt            
            , rei.status                                           as status_code                          
            , cast (ri.elements_count as int)                      as registry_receiver_cnt                
            , ri.incoming_passing_kind                             as type_code                             
            , ri.tb_id                                             as registry_tb_code                     
            , ri.organization_gosb                                 as account_gosb_code                   
            , rei.row_context_department                           as account_tb_department_code           
            , cast (NULL as string)                                as account_tb_department_name          
            , cast (rei.row_context_branch_id as string)           as osb_code                             
            , rei.row_fosb                                         as vsp_code
            , cast (NULL as string)                                as vsp_operator_code  
            ----------------------------------
            , rei.object_id                                        as operation_sid
            , cast (NULL as string)                                as receiver_inn_num
            , rlist.payment_date_time                              as cor_acc_valuing_dttm  
            , ri.incoming_file_currency                            as cor_acc_currency_code
            , cast (rei.row_operation_sum as decimal(38,16))       as cor_acc_ccy_amt
            , ri.incoming_file_currency                            as receiver_acc_currency_code
            , ri.context_organization_name                         as payer_name
            , ri.account_number                                    as payer_account_num
            , ri.account_bank_name                                 as payer_bank_name
            , ri.corresponded_account                              as payer_bank_account_num
            , ri.account_bic                                       as payer_bank_bic_code
            , cast (NULL as string)                                as intermediary_bank_name
            , cast (NULL as string)                                as intermediary_bank_account_num
            , cast (NULL as string)                                as intermediary_bank_bic_code
            , pay_ord.recipient_bank_name                          as receiver_bank_name
            , pay_ord.recipient_corr_account_bank                  as receiver_bank_account_num
            , pay_ord.recipient_bic_bank                           as receiver_bank_bic_code
            , concat(rei.row_surname,' ',                          
                    rei.row_name,' ',                              
                    rei.row_patronymic)                            as receiver_full_name
            , rei.row_account_number                               as receiver_account_num
            , pay_ord.purpose                                      as purpose_txt
            , concat(rei.row_surname,' ',                          
                    rei.row_name,' ',                              
                    rei.row_patronymic)                            as receiver_acc_owner_full_name
            , ri.account_number                                    as debit_account_num
            , rei.row_account_number                               as credit_account_num
            ----------------------------------
            , rei.object_id                                        as service_sid
            , pay_ord.create_date_time                             as document_create_dttm
            , cast(NULL as string)                                 as document_processing_code
            , cast(NULL as string)                                 as registry_type_code
            , pay_ord.doc_num                                      as document_num
            , cast(NULL as string)                                 as digital_doc_origin_num
            , cast(NULL as timestamp)                              as digital_doc_origin_dt
            , cast(NULL as string)                                 as digital_doc_originator_code
            , cast(NULL as timestamp)                              as digital_doc_client_dt
            , cast(NULL as string)                                 as pension_type_code
            ----------------------------------
            
            from ${$app_src_schema_rsr_streamgate}.t_roster_element_instance rei
                left join ${$app_src_schema_rsr_streamgate}.t_roster_instance    ri  on rei.roster_instance_id = ri.object_id
                left join ${$app_src_schema_rsr_streamgate}.t_payment_order pay_ord on rei.roster_instance_id = pay_ord.roster_id
                left join ${$app_src_schema_rsr_streamgate}.t_roster_list rlist on rei.roster_instance_id = rlist.roster_id
            where 1=1
                and rei.status in ('104', '107')
                and rei.ctl_validfrom $loadDt
            ) t1 
        ) t
    )
where rn = 1
;
