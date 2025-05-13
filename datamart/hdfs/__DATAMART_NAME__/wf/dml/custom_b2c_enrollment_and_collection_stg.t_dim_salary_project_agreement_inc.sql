insert overwrite $app.stg.schema.name.$app.stg.table.name
(
  sid
, num
, currency_name
, currency_code
, type_code
, type_name
, classification_code
, begin_dttmtz
, end_dttmtz
, planned_end_dt
, status_name
, external_status_code
, external_status_name
, active_flag
, plan_employee_cnt
, fot_ccy_amt
, epk_id
, inn_kio_num
, kpp_code
, kpp_kn_code
, ogrn_num
, okpo_num
, rko_flag
, reservation_flag
, source_code
, source_name
, source_system_jupiter_code
, source_system_name
, tb_code
, gosb_code
, vsp_register_code
, sign_option_sid
, sign_option_jupiter_code
, sign_option_code
, sign_option_name
, process_type_code
, process_type_name
, sales_channel_code
, sales_channel_name
, sales_method_code
, sales_method_name
, commission_account_sid
, commission_account_num
, contract_version_sid
, source_ctl_action
, ctl_action
, ctl_loading
, ctl_validfrom
, start_dttm
, end_dttm
, tech_distr_name
, row_hash
, part_1_day
)
select
  sid
, num
, currency_name
, currency_code
, type_code
, type_name
, classification_code
, begin_dttmtz
, end_dttmtz
, planned_end_dt
, status_name
, external_status_code
, external_status_name
, active_flag
, plan_employee_cnt
, fot_ccy_amt
, epk_id
, inn_kio_num
, kpp_code
, kpp_kn_code
, ogrn_num
, okpo_num
, rko_flag
, reservation_flag
, source_code
, source_name
, source_system_jupiter_code
, source_system_name
, tb_code
, gosb_code
, vsp_register_code
, sign_option_sid
, sign_option_jupiter_code
, sign_option_code
, sign_option_name
, process_type_code
, process_type_name
, sales_channel_code
, sales_channel_name
, sales_method_code
, sales_method_name
, commission_account_sid
, commission_account_num
, contract_version_sid
, source_ctl_action
, ctl_action
, ctl_loading
, ctl_validfrom
, start_dttm
, end_dttm
, tech_distr_name
, row_hash
, cast(cast(end_dttm as date) as string) as part_1_day
from(
    select
        sid
        , num
        , currency_name
        , currency_code
        , type_code
        , type_name
        , classification_code
        , begin_dttmtz
        , end_dttmtz
        , planned_end_dt
        , status_name
        , external_status_code
        , external_status_name
        , active_flag
        , plan_employee_cnt
        , fot_ccy_amt
        , epk_id
        , inn_kio_num
        , kpp_code
        , kpp_kn_code
        , ogrn_num
        , okpo_num
        , rko_flag
        , reservation_flag
        , source_code
        , source_name
        , source_system_jupiter_code
        , source_system_name
        , tb_code
        , gosb_code
        , vsp_register_code
        , sign_option_sid
        , sign_option_jupiter_code
        , sign_option_code
        , sign_option_name
        , process_type_code
        , process_type_name
        , sales_channel_code
        , sales_channel_name
        , sales_method_code
        , sales_method_name
        , commission_account_sid
        , commission_account_num
        , contract_version_sid
        , source_ctl_action
        , ctl_action
        , ctl_loading
        , ctl_validfrom
        , start_dttm
        , case
            when start_dttm = lead(start_dttm) over(partition by sid order by start_dttm)
            then start_dttm
            else lead(start_dttm - interval '1' microsecond, 1, cast('9999-12-31' as timestamp)) over(partition by sid order by start_dttm)
          end as end_dttm
        , tech_distr_name
        , row_hash
    from(
        select
        sid
        , num
        , currency_name
        , currency_code
        , type_code
        , type_name
        , classification_code
        , begin_dttmtz
        , end_dttmtz
        , planned_end_dt
        , status_name
        , external_status_code
        , external_status_name
        , active_flag
        , plan_employee_cnt
        , fot_ccy_amt
        , epk_id
        , inn_kio_num
        , kpp_code
        , kpp_kn_code
        , ogrn_num
        , okpo_num
        , rko_flag
        , reservation_flag
        , source_code
        , source_name
        , source_system_jupiter_code
        , source_system_name
        , tb_code
        , gosb_code
        , vsp_register_code
        , sign_option_sid
        , sign_option_jupiter_code
        , sign_option_code
        , sign_option_name
        , process_type_code
        , process_type_name
        , sales_channel_code
        , sales_channel_name
        , sales_method_code
        , sales_method_name
        , commission_account_sid
        , commission_account_num
        , contract_version_sid
        , source_ctl_action
        , 'I'                                                                                           as ctl_action
        , cast('$app.ctl.loading' as bigint)                                                            as ctl_loading
        , current_timestamp()                                                                           as ctl_validfrom
        , source_ctl_validfrom_dttm                                                                     as start_dttm
        ,'$app.version'                                                                                 as tech_distr_name
        , row_hash
        from(
            select
            t.sid
            , t.num
            , t.currency_name
            , t.currency_code
            , t.type_code
            , t.type_name
            , t.classification_code
            , t.begin_dttmtz
            , t.end_dttmtz
            , t.planned_end_dt
            , t.status_name
            , t.external_status_code
            , t.external_status_name
            , t.active_flag
            , t.plan_employee_cnt
            , t.fot_ccy_amt
            , t.epk_id
            , t.inn_kio_num
            , t.kpp_code
            , t.kpp_kn_code
            , t.ogrn_num
            , t.okpo_num
            , t.rko_flag
            , t.reservation_flag
            , t.source_name
            , t.source_code
            , t.source_system_jupiter_code
            , t.source_system_name
            , t.tb_code
            , t.gosb_code
            , t.vsp_register_code
            , t.sign_option_sid
            , t.sign_option_jupiter_code
            , t.sign_option_code
            , t.sign_option_name
            , t.process_type_code
            , t.process_type_name
            , t.sales_channel_code
            , t.sales_channel_name
            , t.sales_method_code
            , t.sales_method_name
            , t.source_ctl_validfrom_dttm
            , t.commission_account_sid
            , t.commission_account_num
            , t.contract_version_sid
            , t.source_ctl_action
            , t.row_hash
            , row_number() over (partition by t.row_hash order by t.source_ctl_validfrom_dttm desc) as rn
            from(
                select
                t1.sid
                , t1.num
                , t1.currency_name
                , t1.currency_code
                , t1.type_code
                , t1.type_name
                , t1.classification_code
                , t1.begin_dttmtz
                , t1.end_dttmtz
                , t1.planned_end_dt
                , t1.status_name
                , t1.external_status_code
                , t1.external_status_name
                , t1.active_flag
                , t1.plan_employee_cnt
                , t1.fot_ccy_amt
                , t1.epk_id
                , t1.inn_kio_num
                , t1.kpp_code
                , t1.kpp_kn_code
                , t1.ogrn_num
                , t1.okpo_num
                , t1.rko_flag
                , t1.reservation_flag
                , t1.source_name
                , t1.source_code
                , t1.source_system_jupiter_code
                , t1.source_system_name
                , t1.tb_code
                , t1.gosb_code
                , t1.vsp_register_code
                , t1.sign_option_sid
                , t1.sign_option_jupiter_code
                , t1.sign_option_code
                , t1.sign_option_name
                , t1.process_type_code
                , t1.process_type_name
                , t1.sales_channel_code
                , t1.sales_channel_name
                , t1.sales_method_code
                , t1.sales_method_name
                , t1.source_ctl_validfrom_dttm
                , t1.commission_account_sid
                , t1.commission_account_num
                , t1.contract_version_sid
                , t1.source_ctl_action
                , sha2(
                        concat(
                            nvl(t1.sid, '0'), nvl(t1.num, '0'), nvl(t1.currency_name, '0'),
                            nvl(t1.currency_code, '0'), nvl(t1.type_code, '0'), nvl(t1.type_name, '0'), nvl(t1.classification_code, '0'), nvl(t1.begin_dttmtz, '0'),
                            nvl(t1.end_dttmtz, '0'), nvl(t1.planned_end_dt, '0'), nvl(t1.status_name, '0'), nvl(t1.external_status_code, '0'), nvl(t1.external_status_name, '0'),
                            nvl(t1.active_flag, '0'), nvl(t1.plan_employee_cnt, '0'), nvl(t1.fot_ccy_amt, '0'), nvl(t1.epk_id, '0'), nvl(t1.inn_kio_num, '0'),
                            nvl(t1.kpp_code, '0'), nvl(t1.kpp_kn_code, '0'), nvl(t1.ogrn_num, '0'), nvl(t1.okpo_num, '0'), nvl(t1.rko_flag, '0'),
                            nvl(t1.reservation_flag, '0'), nvl(t1.source_name, '0'), nvl(t1.source_code, '0'), nvl(t1.source_system_jupiter_code, '0'), nvl(t1.source_system_name, '0'),
                            nvl(t1.tb_code, '0'), nvl(t1.gosb_code, '0'), nvl(t1.vsp_register_code, '0'), nvl(t1.sign_option_sid, '0'), nvl(t1.sign_option_jupiter_code, '0'),
                            nvl(t1.sign_option_code, '0'), nvl(t1.sign_option_name, '0'), nvl(t1.process_type_code, '0'), nvl(t1.process_type_name, '0'), nvl(t1.sales_channel_code, '0'), nvl(t1.sales_channel_name, '0'),
                            nvl(t1.sales_method_code, '0'), nvl(t1.sales_method_name, '0'), nvl(t1.commission_account_sid, '0'), nvl(t1.commission_account_num, '0')
                            ), 256)                     as row_hash
                from(
                    select
                    split(sacard.contract, '[:]')[1]                   as sid
                    , sacard.contractnumber                            as num
                    , sacard.currency                                  as currency_name
                    , case
                        --when currency='RUB' then '643'
                        when currency='RUR' then '810'
                        when currency='USD' then '840'
                        when currency='EUR' then '978'
                        end                                              as currency_code
                    , sacard.agreementtype                             as type_code
                    , d_agr.name                                       as type_name
                    , sacard.contractclassification                    as classification_code
                    , sacard.contractbegindate                         as begin_dttmtz
                    , sacard.contractenddate                           as end_dttmtz
                    , cast(sacard.plannedcontractenddate as timestamp) as planned_end_dt
                    , sacard.numberstatus                              as status_name
                    , sacard.externalstatus                            as external_status_code
                    , es.name                                          as external_status_name
                    , CASE WHEN externalstatus in ('SA_RESOLVED', 'SA_TR_IN_PROGRESS', 'SA_CLIENT_SIGNING', 'SA_CLIENT_VERIFYING',
                                                    'SA_BANK_SIGNED', 'SA_CLIENT_SIGNED', 'SA_REGISTER_WAITING', 'SA_BANK_APPROVING',
                                                    'SA_CLIENT_VERIFIED', 'SA_IN_PROGRESS', 'SA_BANK_SIGNING', 'SA_DRAFT')
                                THEN 1 -- договор активный
                            WHEN externalstatus in ('SA_TERMINATED', 'SA_CLIENT_REJECTED', 'SA_ROUTED',
                                                    'SA_BANK_REJECTED', 'SA_BANK_CANCELED', 'SA_ARCHIVED')
                                                    or externalstatus is null
                                THEN 0 -- договор неактивный, вместе с NULL
                            ELSE NULL -- неизвестный статус
                        END                                              as active_flag
                    , cast(sacard.planingemployeecount as int)         as plan_employee_cnt
                    , cast(sacard.fot as decimal(38,16))               as fot_ccy_amt
                    , cast(sacard.clientid as string)                  as epk_id
                    , replace(sacard.innkio, '\n', '')                 as inn_kio_num
                    , sacard.kpp                                       as kpp_code
                    , sacard.kppkn                                     as kpp_kn_code
                    , sacard.ogrn                                      as ogrn_num
                    , sacard.okpo                                      as okpo_num
                    , case
                        when sacard.rko='true' then 1
                        when sacard.rko='false' then 0
                        end                                              as rko_flag
                    , cast(sacard.paymentscheme as int)                as reservation_flag
                    , sacard.sourcecode                                as source_name
                    , sacard.sourcesystemcode                          as source_code
                    , ss.jupitercode                                   as source_system_jupiter_code
                    , ss.name                                          as source_system_name
                    , sacard.tb                                        as tb_code
                    , sacard.gosb                                      as gosb_code
                    , sacard.vspregister                               as vsp_register_code
                    , split(sacard.signoption, '[:]')[1]               as sign_option_sid
                    , signa.jupitercode                                as sign_option_jupiter_code
                    , signa.code                                       as sign_option_code
                    , signa.description                                as sign_option_name
                    , sacard.processtype                               as process_type_code
                    , pt.name                                          as process_type_name
                    , sacard.saleschannel                              as sales_channel_code
                    , sch.name                                         as sales_channel_name
                    , sacard.salesmethodcode                           as sales_method_code
                    , sm.name                                          as sales_method_name
                    , CASE
                        WHEN sacard.versionbegindate like '%UTC%'
                        THEN cast(replace(split(sacard.versionbegindate, 'Z')[0], 'T', ' ') as timestamp) + interval 3 hour
                        ELSE cast(replace(split(sacard.versionbegindate, '[+]')[0], 'T', ' ') as timestamp)
                      END                                              as source_ctl_validfrom_dttm
                    , req.id                                           as commission_account_sid
                    , req.checkingaccount                              as commission_account_num
                    , sacard.id                                        as contract_version_sid
                    , sacard.ctl_action                                as source_ctl_action

                    from $app_src_schema_name_pprbzdfd.$app_src_table_name_slragrmnt sacard
                    left join $app_src_schema_name_pprbzdfd.$app_src_table_name_extrnlsts es
                    on sacard.externalstatus = es.code
                    left join $app_src_schema_name_pprbzdfd.$app_src_table_name_agrmnttp d_agr
                    on sacard.agreementtype = d_agr.code
                    left join $app_src_schema_name_pprbzdfd.$app_src_table_name_prcsstp pt
                    on sacard.processtype = pt.code
                    left join $app_src_schema_name_pprbzdfd.$app_src_table_name_srcsstm ss
                    on sacard.sourcesystemcode = ss.code
                    left join $app_src_schema_name_pprbzdfd.$app_src_table_name_slschnl sch
                    on sacard.saleschannel = sch.code
                    left join $app_src_schema_name_pprbzdfd.$app_src_table_name_slsmthd sm
                    on sacard.salesmethodcode = sm.code
                    left join $app_src_schema_name_pprbzdfd.$app_src_table_name_rqsts req
                    on sacard.id = split(req.cardcommission, '[:]')[1]
                    left join $app_src_schema_name_pprbzdfd.$app_src_table_name_sgnptn signa
                    on split(sacard.signoption, '[:]')[1] = signa.id
                    where 1=1
                        and sacard.versionbegindate is not NULL
                        and sacard.versionbegindate <> coalesce(sacard.versionenddate, 'actual null')
                        and sacard.ctl_validfrom $loadDt
                ) t1 
            ) t
        )
    where rn = 1));


