insert overwrite table $app.stg.schema.name.$app.stg.snp.inc.table.name partition (part_1_day)
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
    , ctl_action
    , ctl_loading
    , ctl_validfrom
    , start_dttm
    , end_dttm
    , tech_distr_name
    , row_hash
    , part_1_day
    )

select * from (
with tgt_tbl as ( /*отбираем актуальные записи из таргета(9999 партиция)*/
    select *
    from $app.target.schema.name.$app.target.table.name as tgt
        where tgt.part_1_day = '9999-12-31'
)  
,
inc_tbl as ( /*забираем весь инкремент с 1-го шага*/
    select * from  $app.stg.schema.name.$app.stg.table.name as dp
) 
,
inc_tbl_new_hash as ( /*забираем из инкремента измененные строки(новые версии договоров)*/
    select distinct inc_tbl.* from inc_tbl
    inner join tgt_tbl 
        on tgt_tbl.sid = inc_tbl.sid
        and inc_tbl.row_hash != tgt_tbl.row_hash
    where tgt_tbl.start_dttm < inc_tbl.start_dttm
)
,
inc_tbl_updated as ( /*забираем из инкремента update*/
    select distinct
        inc_tbl.sid
        , inc_tbl.num
        , inc_tbl.currency_name
        , inc_tbl.currency_code
        , inc_tbl.type_code
        , inc_tbl.type_name
        , inc_tbl.classification_code
        , inc_tbl.begin_dttmtz
        , inc_tbl.end_dttmtz
        , inc_tbl.planned_end_dt
        , inc_tbl.status_name
        , inc_tbl.external_status_code
        , inc_tbl.external_status_name
        , inc_tbl.active_flag
        , inc_tbl.plan_employee_cnt
        , inc_tbl.fot_ccy_amt
        , inc_tbl.epk_id
        , inc_tbl.inn_kio_num
        , inc_tbl.kpp_code
        , inc_tbl.kpp_kn_code
        , inc_tbl.ogrn_num
        , inc_tbl.okpo_num
        , inc_tbl.rko_flag
        , inc_tbl.reservation_flag
        , inc_tbl.source_code
        , inc_tbl.source_name
        , inc_tbl.source_system_jupiter_code
        , inc_tbl.source_system_name
        , inc_tbl.tb_code
        , inc_tbl.gosb_code
        , inc_tbl.vsp_register_code
        , inc_tbl.sign_option_sid
        , inc_tbl.sign_option_jupiter_code
        , inc_tbl.sign_option_code
        , inc_tbl.sign_option_name
        , inc_tbl.process_type_code
        , inc_tbl.process_type_name
        , inc_tbl.sales_channel_code
        , inc_tbl.sales_channel_name
        , inc_tbl.sales_method_code
        , inc_tbl.sales_method_name
        , inc_tbl.commission_account_sid
        , inc_tbl.commission_account_num
        , inc_tbl.contract_version_sid
        , 'U' as ctl_action
        , inc_tbl.ctl_loading
        , inc_tbl.ctl_validfrom
        , inc_tbl.start_dttm
        , case 
              when tgt.part_1_day = '9999-12-31' then inc_tbl.end_dttm 
              else tgt.end_dttm
          end as end_dttm
        , inc_tbl.tech_distr_name
        , inc_tbl.row_hash
        , case 
              when tgt.part_1_day = '9999-12-31' then inc_tbl.part_1_day
              else tgt.part_1_day
          end as part_1_day
    from inc_tbl
    inner join $app.target.schema.name.$app.target.table.name as tgt 
        on tgt.sid = inc_tbl.sid
        and tgt.start_dttm = inc_tbl.start_dttm
    where 1=1 
        and inc_tbl.source_ctl_action = 'U'
        and tgt.start_dttm <> tgt.end_dttm
)
,

time_table as ( /*перестраиваем бизнес-историю для новых версия договоров (новые записи + 9999 партиция из таргета)*/
SELECT
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
    , t.source_code
    , t.source_name
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
    , t.commission_account_sid
    , t.commission_account_num
    , t.contract_version_sid
    , t.ctl_action
    , t.ctl_loading
    , t.ctl_validfrom
    , t.start_dttm
    , case
        when t.start_dttm = lead(t.start_dttm) over(partition by t.sid order by t.start_dttm)
        then t.start_dttm
        else lead(t.start_dttm - interval '1' microsecond, 1, cast('9999-12-31' as timestamp)) over(partition by t.sid order by t.start_dttm)
    end    as end_dttm
    , t.tech_distr_name
    , t.row_hash
    , cast(to_date(case
        when t.start_dttm = lead(t.start_dttm) over(partition by t.sid order by t.start_dttm)
        then t.start_dttm
        else lead(t.start_dttm - interval '1' microsecond, 1, cast('9999-12-31' as timestamp)) over(partition by t.sid order by t.start_dttm)
    end) as string) as part_1_day
from (
select
        t2.sid
        , t2.num
        , t2.currency_name
        , t2.currency_code
        , t2.type_code
        , t2.type_name
        , t2.classification_code
        , t2.begin_dttmtz
        , t2.end_dttmtz
        , t2.planned_end_dt
        , t2.status_name
        , t2.external_status_code
        , t2.external_status_name
        , t2.active_flag
        , t2.plan_employee_cnt
        , t2.fot_ccy_amt
        , t2.epk_id
        , t2.inn_kio_num
        , t2.kpp_code
        , t2.kpp_kn_code
        , t2.ogrn_num
        , t2.okpo_num
        , t2.rko_flag
        , t2.reservation_flag
        , t2.source_code
        , t2.source_name
        , t2.source_system_jupiter_code
        , t2.source_system_name
        , t2.tb_code
        , t2.gosb_code
        , t2.vsp_register_code
        , t2.sign_option_sid
        , t2.sign_option_jupiter_code
        , t2.sign_option_code
        , t2.sign_option_name
        , t2.process_type_code
        , t2.process_type_name
        , t2.sales_channel_code
        , t2.sales_channel_name
        , t2.sales_method_code
        , t2.sales_method_name
        , t2.commission_account_sid
        , t2.commission_account_num
        , t2.contract_version_sid
        , t2.ctl_action
        , t2.ctl_loading
        , t2.ctl_validfrom
        , t2.start_dttm
        , t2.end_dttm
        , t2.tech_distr_name
        , t2.row_hash
        , t2.part_1_day
from(
    select t1.*,
            row_number() over (partition by t1.row_hash order by t1.start_dttm) as rn
    from (
    select /*+ BROADCAST(dp) */
        dp.sid
        , dp.num
        , dp.currency_name
        , dp.currency_code
        , dp.type_code
        , dp.type_name
        , dp.classification_code
        , dp.begin_dttmtz
        , dp.end_dttmtz
        , dp.planned_end_dt
        , dp.status_name
        , dp.external_status_code
        , dp.external_status_name
        , dp.active_flag
        , dp.plan_employee_cnt
        , dp.fot_ccy_amt
        , dp.epk_id
        , dp.inn_kio_num
        , dp.kpp_code
        , dp.kpp_kn_code
        , dp.ogrn_num
        , dp.okpo_num
        , dp.rko_flag
        , dp.reservation_flag
        , dp.source_code
        , dp.source_name
        , dp.source_system_jupiter_code
        , dp.source_system_name
        , dp.tb_code
        , dp.gosb_code
        , dp.vsp_register_code
        , dp.sign_option_sid
        , dp.sign_option_jupiter_code
        , dp.sign_option_code
        , dp.sign_option_name
        , dp.process_type_code
        , dp.process_type_name
        , dp.sales_channel_code
        , dp.sales_channel_name
        , dp.sales_method_code
        , dp.sales_method_name
        , dp.commission_account_sid
        , dp.commission_account_num
        , dp.contract_version_sid
        , dp.ctl_action
        , dp.ctl_loading
        , dp.ctl_validfrom
        , dp.start_dttm
        , dp.end_dttm
        , dp.tech_distr_name
        , dp.row_hash
        , dp.part_1_day
    from  inc_tbl_new_hash as dp
    left join tgt_tbl as tgt
    on dp.sid = tgt.sid
    where 1 = 1
        and dp.row_hash != tgt.row_hash
        /*объединяем инкремент с актуальными записями таргета, где hash отличается*/

    union all

    select /*+ BROADCAST(dp) */
        tgt.sid
        , tgt.num
        , tgt.currency_name
        , tgt.currency_code
        , tgt.type_code
        , tgt.type_name
        , tgt.classification_code
        , tgt.begin_dttmtz
        , tgt.end_dttmtz
        , tgt.planned_end_dt
        , tgt.status_name
        , tgt.external_status_code
        , tgt.external_status_name
        , tgt.active_flag
        , tgt.plan_employee_cnt
        , tgt.fot_ccy_amt
        , tgt.epk_id
        , tgt.inn_kio_num
        , tgt.kpp_code
        , tgt.kpp_kn_code
        , tgt.ogrn_num
        , tgt.okpo_num
        , tgt.rko_flag
        , tgt.reservation_flag
        , tgt.source_code
        , tgt.source_name
        , tgt.source_system_jupiter_code
        , tgt.source_system_name
        , tgt.tb_code
        , tgt.gosb_code
        , tgt.vsp_register_code
        , tgt.sign_option_sid
        , tgt.sign_option_jupiter_code
        , tgt.sign_option_code
        , tgt.sign_option_name
        , tgt.process_type_code
        , tgt.process_type_name
        , tgt.sales_channel_code
        , tgt.sales_channel_name
        , tgt.sales_method_code
        , tgt.sales_method_name
        , tgt.commission_account_sid
        , tgt.commission_account_num
        , tgt.contract_version_sid
        , tgt.ctl_action
        , tgt.ctl_loading
        , tgt.ctl_validfrom
        , tgt.start_dttm
        , tgt.end_dttm
        , tgt.tech_distr_name
        , tgt.row_hash
        , tgt.part_1_day
    from inc_tbl_new_hash as dp
    inner join tgt_tbl as tgt
    on dp.sid = tgt.sid
    where 1 = 1
        --and dp.row_hash != tgt.row_hash
        /*объединяем инкремент с актуальными записями из таргета*/
        /*забирает из таргета пересечение с инкрементом*/
        ) t1
    ) t2
    where t2.rn = 1

union all

select /*+ BROADCAST(dp) */
    dp.sid
    , dp.num
    , dp.currency_name
    , dp.currency_code
    , dp.type_code
    , dp.type_name
    , dp.classification_code
    , dp.begin_dttmtz
    , dp.end_dttmtz
    , dp.planned_end_dt
    , dp.status_name
    , dp.external_status_code
    , dp.external_status_name
    , dp.active_flag
    , dp.plan_employee_cnt
    , dp.fot_ccy_amt
    , dp.epk_id
    , dp.inn_kio_num
    , dp.kpp_code
    , dp.kpp_kn_code
    , dp.ogrn_num
    , dp.okpo_num
    , dp.rko_flag
    , dp.reservation_flag
    , dp.source_code
    , dp.source_name
    , dp.source_system_jupiter_code
    , dp.source_system_name
    , dp.tb_code
    , dp.gosb_code
    , dp.vsp_register_code
    , dp.sign_option_sid
    , dp.sign_option_jupiter_code
    , dp.sign_option_code
    , dp.sign_option_name
    , dp.process_type_code
    , dp.process_type_name
    , dp.sales_channel_code
    , dp.sales_channel_name
    , dp.sales_method_code
    , dp.sales_method_name
    , dp.commission_account_sid
    , dp.commission_account_num
    , dp.contract_version_sid
    , dp.ctl_action
    , dp.ctl_loading
    , dp.ctl_validfrom
    , case
        when row_number() over (partition by dp.sid order by dp.start_dttm) = 1
        then cast('1900-01-01' as timestamp)
        else dp.start_dttm
    end as start_dttm
    , dp.end_dttm
    , dp.tech_distr_name
    , dp.row_hash
    , dp.part_1_day
from  inc_tbl as dp
left join tgt_tbl as tgt
on dp.sid = tgt.sid
where 1 = 1
    and tgt.sid is null
    /*отбираем из инкремента договора, по которым ранее не было записей в таргете*/

union all

    select /*+ BROADCAST(dp) */
    tgt.sid
    , tgt.num
    , tgt.currency_name
    , tgt.currency_code
    , tgt.type_code
    , tgt.type_name
    , tgt.classification_code
    , tgt.begin_dttmtz
    , tgt.end_dttmtz
    , tgt.planned_end_dt
    , tgt.status_name
    , tgt.external_status_code
    , tgt.external_status_name
    , tgt.active_flag
    , tgt.plan_employee_cnt
    , tgt.fot_ccy_amt
    , tgt.epk_id
    , tgt.inn_kio_num
    , tgt.kpp_code
    , tgt.kpp_kn_code
    , tgt.ogrn_num
    , tgt.okpo_num
    , tgt.rko_flag
    , tgt.reservation_flag
    , tgt.source_code
    , tgt.source_name
    , tgt.source_system_jupiter_code
    , tgt.source_system_name
    , tgt.tb_code
    , tgt.gosb_code
    , tgt.vsp_register_code
    , tgt.sign_option_sid
    , tgt.sign_option_jupiter_code
    , tgt.sign_option_code
    , tgt.sign_option_name
    , tgt.process_type_code
    , tgt.process_type_name
    , tgt.sales_channel_code
    , tgt.sales_channel_name
    , tgt.sales_method_code
    , tgt.sales_method_name
    , tgt.commission_account_sid
    , tgt.commission_account_num
    , tgt.contract_version_sid
    , tgt.ctl_action
    , tgt.ctl_loading
    , tgt.ctl_validfrom
    , tgt.start_dttm
    , tgt.end_dttm
    , tgt.tech_distr_name
    , tgt.row_hash
    , tgt.part_1_day
from tgt_tbl as tgt
left join inc_tbl_new_hash as dp
on dp.sid = tgt.sid
    where 1 = 1
    and dp.sid is null
    /*отбираем из таргета договора, по которым не пришло изменений*/
)t )
,
time_table_union as ( /*объединяем таблицы update и новые версии договоров, для учета случая когда по одному договору пришло и то и то*/
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
        , ctl_action
        , ctl_loading
        , ctl_validfrom
        , start_dttm
        , end_dttm
        , tech_distr_name
        , row_hash
        , part_1_day
    from (
        select 
        *,
        row_number() over(partition by t.sid, t.start_dttm order by t.ctl_validfrom desc) rn
        from ( 
            select * from inc_tbl_updated
            union all
            select * from time_table 
    ) t ) 
    where rn = 1
)
,
dt_list as ( /*из временной таблицы всех изменений по договорам забираем партиции, по которым пришли изменения*/
select distinct part_1_day
from time_table_union
where part_1_day != '9999-12-31'
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
    , ctl_action
    , ctl_loading
    , ctl_validfrom
    , start_dttm
    , end_dttm
    , tech_distr_name
    , row_hash
    , part_1_day
from (
    select
        *
        , row_number() over(partition by t1.row_hash order by t1.end_dttm desc) rn
        , case 
            when t1.start_dttm = t1.end_dttm then 1
            else row_number() over(partition by t1.sid, t1.start_dttm order by t1.ctl_validfrom desc, t1.end_dttm desc) 
          end as rn2
    from (
        select /*забираем сторки, по которым пришли какие-либо изменения в инкременте*/
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
                , ctl_action
                , ctl_loading
                , ctl_validfrom
                , start_dttm
                , end_dttm
                , tech_distr_name
                , row_hash
                , part_1_day
            from time_table_union
        union all
        select /*+ BROADCAST(dl) */
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
                , ctl_action
                , ctl_loading
                , ctl_validfrom
                , start_dttm
                , end_dttm
                , tech_distr_name
                , row_hash
                , tgt.part_1_day
        from $app.target.schema.name.$app.target.table.name as tgt /*забираем данные из партиция таргета, в которых пришли изменения в инкременте*/
        inner join dt_list as dl on dl.part_1_day = tgt.part_1_day
        ) t1
) t2
where rn = 1 and rn2 = 1);
