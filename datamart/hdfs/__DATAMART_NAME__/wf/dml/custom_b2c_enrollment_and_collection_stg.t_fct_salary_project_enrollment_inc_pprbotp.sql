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
,'ППРБ.РПП'                                                                                     as source_system_code
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
            otp.rquid                                                          as sid
            , otp.upduid                                                       as document_sid
            , cast (NULL as string)                                            as registry_enrollment_sid
            , cast (payer_t.epkid as string)                                   as payer_epk_id
            , cast (recipient.epkid as string)                                 as receiver_epk_id
            , case
                when payer_t.type = 'Organization' then 'Organization'
                when payer_t.type = 'Client' then   'Individual'
            end                                                                as client_type_code
            , cast (NULL as int)                                               as registered_self_employed_flag
            , case
                when recipient.resident = True then 1
                when recipient.resident = False then 0
            end                                                                as phys_resident_flag
            , case
                when contract.isresident = True then 1
                when contract.isresident = False then 0
            end                                                                as legal_entity_resident_flag
            , payer_t.inn                                                      as payer_inn_num
            , cast (NULL as string)                                            as registry_num
            , contract.number                                                  as agreement_num
            , cast (NULL as timestamp)                                         as registry_receive_dttm
            , cast (otp.operday as timestamp)                                  as plan_enrollment_dt
            , cast (otp.operday as timestamp)                                  as fact_enrollment_dttm
            , cast (coalesce(haronevent.operationdate, '1900-01-01') as timestamp) as operation_day_dt
            , cast (NULL as decimal(38,16))                                    as registry_incoming_file_ccy_amt
            , cast (coalesce(haronevent.amount, otp.amount) as decimal(38,16)) as ccy_amt
            , cast (otp.sourceamount as decimal(38,16))                        as control_sum_ccy_amt
            , otp.status                                                       as status_code
            , cast (NULL as int)                                               as registry_receiver_cnt
            , cast (otp.passingtype as string)                                 as type_code
            , cast (NULL as string)                                            as registry_tb_code
            , product.agencyid                                                 as account_gosb_code
            , product.regionid                                                 as account_tb_department_code
            , cast (NULL as string)                                            as account_tb_department_name
            , cast (haronevent.branchid as string)                             as osb_code
            , cast (product.branchid as string)                                as vsp_code
            , cast (NULL as string)                                            as vsp_operator_code
            ----------------------------------
            , otp.objectid                                                     as operation_sid
            , recipient.inn                                                    as receiver_inn_num
            , cast (otp.paymentdate as timestamp)                              as cor_acc_valuing_dttm  
            , case
                when otp.currency = 'AED' then '784'
                when otp.currency = 'AFN' then '971'
                when otp.currency = 'ALL' then '008'
                when otp.currency = 'AMD' then '051'
                when otp.currency = 'ANG' then '532'
                when otp.currency = 'AOA' then '973'
                when otp.currency = 'ARS' then '032'
                when otp.currency = 'AUD' then '036'
                when otp.currency = 'AWG' then '533'
                when otp.currency = 'AZN' then '944'
                when otp.currency = 'BAM' then '977'
                when otp.currency = 'BBD' then '052'
                when otp.currency = 'BDT' then '050'
                when otp.currency = 'BGN' then '975'
                when otp.currency = 'BHD' then '048'
                when otp.currency = 'BIF' then '108'
                when otp.currency = 'BMD' then '060'
                when otp.currency = 'BND' then '096'
                when otp.currency = 'BOB' then '068'
                when otp.currency = 'BOV' then '984'
                when otp.currency = 'BRL' then '986'
                when otp.currency = 'BSD' then '044'
                when otp.currency = 'BTN' then '064'
                when otp.currency = 'BWP' then '072'
                when otp.currency = 'BYN' then '933'
                when otp.currency = 'BZD' then '084'
                when otp.currency = 'CAD' then '124'
                when otp.currency = 'CDF' then '976'
                when otp.currency = 'CHF' then '756'
                when otp.currency = 'CLP' then '152'
                when otp.currency = 'CNY' then '156'
                when otp.currency = 'COP' then '170'
                when otp.currency = 'COU' then '970'
                when otp.currency = 'CRC' then '188'
                when otp.currency = 'CUC' then '931'
                when otp.currency = 'CUP' then '192'
                when otp.currency = 'CVE' then '132'
                when otp.currency = 'CZK' then '203'
                when otp.currency = 'DJF' then '262'
                when otp.currency = 'DKK' then '208'
                when otp.currency = 'DOP' then '214'
                when otp.currency = 'DZD' then '012'
                when otp.currency = 'EGP' then '818'
                when otp.currency = 'ERN' then '232'
                when otp.currency = 'ETB' then '230'
                when otp.currency = 'EUR' then '978'
                when otp.currency = 'FJD' then '242'
                when otp.currency = 'FKP' then '238'
                when otp.currency = 'GBP' then '826'
                when otp.currency = 'GEL' then '981'
                when otp.currency = 'GHS' then '936'
                when otp.currency = 'GIP' then '292'
                when otp.currency = 'GMD' then '270'
                when otp.currency = 'GNF' then '324'
                when otp.currency = 'GTQ' then '320'
                when otp.currency = 'GYD' then '328'
                when otp.currency = 'HKD' then '344'
                when otp.currency = 'HNL' then '340'
                when otp.currency = 'HRK' then '191'
                when otp.currency = 'HTG' then '332'
                when otp.currency = 'HUF' then '348'
                when otp.currency = 'IDR' then '360'
                when otp.currency = 'ILS' then '376'
                when otp.currency = 'INR' then '356'
                when otp.currency = 'IQD' then '368'
                when otp.currency = 'IRR' then '364'
                when otp.currency = 'ISK' then '352'
                when otp.currency = 'JMD' then '388'
                when otp.currency = 'JOD' then '400'
                when otp.currency = 'JPY' then '392'
                when otp.currency = 'KES' then '404'
                when otp.currency = 'KGS' then '417'
                when otp.currency = 'KHR' then '116'
                when otp.currency = 'KMF' then '174'
                when otp.currency = 'KPW' then '408'
                when otp.currency = 'KRW' then '410'
                when otp.currency = 'KWD' then '414'
                when otp.currency = 'KYD' then '136'
                when otp.currency = 'KZT' then '398'
                when otp.currency = 'LAK' then '418'
                when otp.currency = 'LBP' then '422'
                when otp.currency = 'LKR' then '144'
                when otp.currency = 'LRD' then '430'
                when otp.currency = 'LSL' then '426'
                when otp.currency = 'LYD' then '434'
                when otp.currency = 'MAD' then '504'
                when otp.currency = 'MDL' then '498'
                when otp.currency = 'MGA' then '969'
                when otp.currency = 'MKD' then '807'
                when otp.currency = 'MMK' then '104'
                when otp.currency = 'MNT' then '496'
                when otp.currency = 'MOP' then '446'
                when otp.currency = 'MRU' then '929'
                when otp.currency = 'MUR' then '480'
                when otp.currency = 'MVR' then '462'
                when otp.currency = 'MWK' then '454'
                when otp.currency = 'MXN' then '484'
                when otp.currency = 'MYR' then '458'
                when otp.currency = 'MZN' then '943'
                when otp.currency = 'NAD' then '516'
                when otp.currency = 'NGN' then '566'
                when otp.currency = 'NIO' then '558'
                when otp.currency = 'NOK' then '578'
                when otp.currency = 'NPR' then '524'
                when otp.currency = 'NZD' then '554'
                when otp.currency = 'OMR' then '512'
                when otp.currency = 'PAB' then '590'
                when otp.currency = 'PEN' then '604'
                when otp.currency = 'PGK' then '598'
                when otp.currency = 'PHP' then '608'
                when otp.currency = 'PKR' then '586'
                when otp.currency = 'PLN' then '985'
                when otp.currency = 'PYG' then '600'
                when otp.currency = 'QAR' then '634'
                when otp.currency = 'RON' then '946'
                when otp.currency = 'RSD' then '941'
                when otp.currency = 'RUB' then '643'
                when otp.currency = 'RUR' then '810'
                when otp.currency = 'RWF' then '646'
                when otp.currency = 'SAR' then '682'
                when otp.currency = 'SBD' then '090'
                when otp.currency = 'SCR' then '690'
                when otp.currency = 'SDG' then '938'
                when otp.currency = 'SEK' then '752'
                when otp.currency = 'SGD' then '702'
                when otp.currency = 'SHP' then '654'
                when otp.currency = 'SLE' then '925'
                when otp.currency = 'SOS' then '706'
                when otp.currency = 'SRD' then '968'
                when otp.currency = 'SSP' then '728'
                when otp.currency = 'STN' then '930'
                when otp.currency = 'SVC' then '222'
                when otp.currency = 'SYP' then '760'
                when otp.currency = 'SZL' then '748'
                when otp.currency = 'THB' then '764'
                when otp.currency = 'TJS' then '972'
                when otp.currency = 'TMT' then '934'
                when otp.currency = 'TND' then '788'
                when otp.currency = 'TOP' then '776'
                when otp.currency = 'TRY' then '949'
                when otp.currency = 'TTD' then '780'
                when otp.currency = 'TWD' then '901'
                when otp.currency = 'TZS' then '834'
                when otp.currency = 'UAH' then '980'
                when otp.currency = 'UGX' then '800'
                when otp.currency = 'USD' then '840'
                when otp.currency = 'UYI' then '940'
                when otp.currency = 'UYU' then '858'
                when otp.currency = 'UZS' then '860'
                when otp.currency = 'VEF' then '937'
                when otp.currency = 'VND' then '704'
                when otp.currency = 'VUV' then '548'
                when otp.currency = 'WST' then '882'
                when otp.currency = 'XAF' then '950'
                when otp.currency = 'XCD' then '951'
                when otp.currency = 'XDR' then '960'
                when otp.currency = 'XOF' then '952'
                when otp.currency = 'XPF' then '953'
                when otp.currency = 'YER' then '886'
                when otp.currency = 'ZAR' then '710'
                when otp.currency = 'ZMW' then '967'
                when otp.currency = 'ZWG' then '924'
                else otp.currency
            end                                                                as cor_acc_currency_code
            , cast (otp.amount as decimal(38,16))                              as cor_acc_ccy_amt
            , product.accountcurrency                                          as receiver_acc_currency_code
            , payer_t.name                                                     as payer_name
            , payer_t.account                                                  as payer_account_num
            , payer_t.bankname                                                 as payer_bank_name
            , payer_t.bankaccount                                              as payer_bank_account_num
            , payer_t.bankbik                                                  as payer_bank_bic_code
            , cast (NULL as string)                                            as intermediary_bank_name
            , cast (NULL as string)                                            as intermediary_bank_account_num
            , cast (NULL as string)                                            as intermediary_bank_bic_code
            , recipient.bankname                                               as receiver_bank_name
            , recipient.bankaccount                                            as receiver_bank_account_num
            , recipient.bankbik                                                as receiver_bank_bic_code
            , recipient.name                                                   as receiver_full_name
            , recipient.account                                                as receiver_account_num
            , otp.purpose                                                      as purpose_txt
            , concat(recipient.lastname,' ',                                   
                    recipient.firstname,' ',                                   
                    recipient.middlename)                                      as receiver_acc_owner_full_name
            , payer_t.account                                                  as debit_account_num
            , recipient.account                                                as credit_account_num
            ----------------------------------
            , haronevent.serviceid                                             as service_sid
            , cast(otp.createdate as timestamp)                                as document_create_dttm
            , cast(NULL as string)                                             as document_processing_code
            , cast(NULL as string)                                             as registry_type_code
            , cast(otp.docnumber as string)                                    as document_num
            , haronevent.paymentdocumentnumber                                 as digital_doc_origin_num
            , cast(haronevent.paymentdocumentdate as timestamp)                as digital_doc_origin_dt
            , haronevent.paymentdocumentid                                     as digital_doc_originator_code
            , cast(otp.clientdate as timestamp)                                as digital_doc_client_dt
            , cast(NULL as string)                                             as pension_type_code

            from $app_src_schema_name_pprbotp.$app_src_table_name_ontmpmnt            otp
                left join $app_src_schema_name_pprbotp.$app_src_table_name_rcpnt      recipient
                    on otp.recipient_short_foreign_key = recipient.objectid
                left join $app_src_schema_name_pprbotp.$app_src_table_name_dmnpr      payer_t
                    on otp.payer_short_foreign_key = payer_t.objectid
                left join $app_src_schema_name_pprbotp.$app_src_table_name_dmncntrct  contract
                    on contract.payer_short_foreign_key = payer_t.objectid
                left join $app_src_schema_name_pprbotp.$app_src_table_name_dmnprdct   product
                    on product.owner_short_foreign_key = recipient.objectid
                left join $app_src_schema_name_pprbotp.$app_src_table_name_hrnvnt     haronevent
                    on haronevent.onetimepayment_short_foreign_key = otp.objectid
            where 1=1 
                and otp.status = 'CREDITED'
                and otp.ctl_validfrom $loadDt
            ) t1 
        ) t
    )
where rn = 1
;
