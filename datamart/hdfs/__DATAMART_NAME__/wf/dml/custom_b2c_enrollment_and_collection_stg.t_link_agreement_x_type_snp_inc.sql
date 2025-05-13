insert overwrite table $app.stg.schema.name.$app.stg.snp.inc.table.name partition (part_1_day)
(
    agreement_sid
    , type_sid
    , type_code
    , type_name
    , subtype_sid
    , subtype_code
    , subtype_name
    , contract_version_sid
    , ctl_action
    , ctl_loading
    , ctl_validfrom
    , start_dttm
    , end_dttm
    , source_system_code
    , tech_distr_name
    , row_hash
    , part_1_day
    ) 
    
select * from (
with tgt_tbl as ( /*отбираем актуальные записи из таргета(9999 партиция)*/
    select 
    agreement_sid
        , type_sid
        , type_code
        , type_name
        , subtype_sid
        , subtype_code
        , subtype_name
        , contract_version_sid
        , ctl_action
        , ctl_loading
        , ctl_validfrom
        , start_dttm
        , end_dttm
        , source_system_code
        , tech_distr_name
        , row_hash
        , part_1_day
    from $app.target.schema.name.$app.target.table.name as tgt
        where tgt.part_1_day = '9999-12-31'
)  
,
inc_tbl as ( /*забираем весь инкремент с 1-го шага*/
    select * from  $app.stg.schema.name.$app.stg.table.name as dp
) 
,
inc_tbl_new_hash as ( /*забираем из инкремента измененные строки(новые версии договоров)*/
    select distinct 
    inc_tbl.agreement_sid
        , inc_tbl.type_sid
        , inc_tbl.type_code
        , inc_tbl.type_name
        , inc_tbl.subtype_sid
        , inc_tbl.subtype_code
        , inc_tbl.subtype_name
        , inc_tbl.contract_version_sid
        , inc_tbl.ctl_action
        , inc_tbl.ctl_loading
        , inc_tbl.ctl_validfrom
        , inc_tbl.start_dttm
        , inc_tbl.end_dttm
        , inc_tbl.source_system_code
        , inc_tbl.tech_distr_name
        , inc_tbl.row_hash
        , inc_tbl.part_1_day
    from inc_tbl
    inner join tgt_tbl 
        on tgt_tbl.agreement_sid = inc_tbl.agreement_sid
        and inc_tbl.row_hash != tgt_tbl.row_hash
    where tgt_tbl.start_dttm < inc_tbl.start_dttm
)
,
inc_tbl_updated as ( /*забираем из инкремента update*/
    select distinct 
        inc_tbl.agreement_sid /*1*/
        , inc_tbl.type_sid/*2*/
        , inc_tbl.type_code/*3*/
        , inc_tbl.type_name/*4*/
        , inc_tbl.subtype_sid/*5*/
        , inc_tbl.subtype_code/*6*/
        , inc_tbl.subtype_name/*7*/
        , inc_tbl.contract_version_sid/*8*/
        , 'U' as ctl_action/*9*/
        , inc_tbl.ctl_loading/*10*/
        , inc_tbl.ctl_validfrom/*11*/
        , inc_tbl.start_dttm/*12*/
        , case 
              when tgt.part_1_day = '9999-12-31' then inc_tbl.end_dttm 
              else tgt.end_dttm/*13*/
          end as end_dttm
        , inc_tbl.source_system_code/*14*/
        , inc_tbl.tech_distr_name/*15*/
        , inc_tbl.row_hash/*16*/
        , case 
              when tgt.part_1_day = '9999-12-31' then inc_tbl.part_1_day
              else tgt.part_1_day
          end as part_1_day/*17*/
    from inc_tbl
    inner join $app.target.schema.name.$app.target.table.name as tgt 
        on tgt.agreement_sid = inc_tbl.agreement_sid
        and tgt.start_dttm = inc_tbl.start_dttm
    where 1=1 
        and inc_tbl.source_ctl_action = 'U'
)
,
unique_tgt_tbl as (
    select distinct
    tgt.agreement_sid 
    , tgt.part_1_day
    , tgt.row_hash
    , tgt.start_dttm
    , tgt.end_dttm
    from tgt_tbl as tgt
    where tgt.part_1_day in (select distinct part_1_day from inc_tbl)
)
,
unique_inc_tbl as (
    select distinct
    agreement_sid 
    , part_1_day
    , row_hash
    , start_dttm
    , end_dttm
    from inc_tbl_new_hash
)
,
time_table as ( /*перестраиваем бизнес-историю для новых версия договоров (новые записи + 9999 партиция из таргета)*/
    select
        t.agreement_sid
        , t.start_dttm
        , case
            when t.start_dttm = lead(t.start_dttm) over(partition by t.agreement_sid order by t.start_dttm)
            then t.start_dttm
            else lead(t.start_dttm - interval '1' microsecond, 1, cast('9999-12-31' as timestamp)) over(partition by t.agreement_sid order by t.start_dttm)
        end    as end_dttm
        , t.row_hash
        , cast(to_date(case
            when t.start_dttm = lead(t.start_dttm) over(partition by t.agreement_sid order by t.start_dttm)
            then t.start_dttm
            else lead(t.start_dttm - interval '1' microsecond, 1, cast('9999-12-31' as timestamp)) over(partition by t.agreement_sid order by t.start_dttm)
        end) as string) as part_1_day
        from (
            select
                t2.agreement_sid
                , t2.start_dttm
                , t2.end_dttm
                , t2.row_hash
                , t2.part_1_day
            from(
                select t1.*,
                        row_number() over (partition by t1.row_hash order by t1.start_dttm) as rn
                from (
                    select 
                        dp.agreement_sid
                        , dp.start_dttm
                        , dp.end_dttm
                        , dp.row_hash
                        , dp.part_1_day
                    from  unique_inc_tbl as dp
                    left join unique_tgt_tbl as tgt
                    on dp.agreement_sid = tgt.agreement_sid
                    where 1 = 1
                        and dp.row_hash != tgt.row_hash
                        /*объединяем инкремент с актуальными записями таргета, где hash отличается*/

                    union all

                    select 
                        tgt.agreement_sid
                        , tgt.start_dttm
                        , tgt.end_dttm
                        , tgt.row_hash
                        , tgt.part_1_day
                    from unique_inc_tbl as dp
                    inner join unique_tgt_tbl as tgt
                    on dp.agreement_sid = tgt.agreement_sid
                    where 1 = 1
                        /*объединяем инкремент с актуальными записями из таргета*/
                        /*забирает из таргета пересечение с инкрементом*/
                    ) t1
                ) t2
                where t2.rn = 1

        union all

        select 
            dp.agreement_sid
            , case
                when row_number() over (partition by dp.agreement_sid order by dp.start_dttm) = 1
                then cast('1900-01-01' as timestamp)
                else dp.start_dttm
            end as start_dttm
            , dp.end_dttm
            , dp.row_hash
            , dp.part_1_day
        from unique_inc_tbl as dp
        left join unique_tgt_tbl as tgt
        on dp.agreement_sid = tgt.agreement_sid
        where 1 = 1
            and tgt.agreement_sid is null
    )t 
)
,
union_inc_tgt as (
    select * 
    from inc_tbl_new_hash
    union all
    select * 
    from tgt_tbl
)
,
time_table2 as (
select
    uni.agreement_sid
    , uni.type_sid
    , uni.type_code
    , uni.type_name
    , uni.subtype_sid
    , uni.subtype_code
    , uni.subtype_name
    , uni.contract_version_sid
    , uni.ctl_action
    , uni.ctl_loading
    , uni.ctl_validfrom
    , uni.start_dttm
    , coalesce(tt.end_dttm, uni.end_dttm) as end_dttm
    , uni.source_system_code
    , uni.tech_distr_name
    , uni.row_hash
    , coalesce(tt.part_1_day, uni.part_1_day) as part_1_day
from union_inc_tgt uni
left join time_table tt
    on uni.agreement_sid = tt.agreement_sid
    and uni.start_dttm = tt.start_dttm
    and uni.row_hash = tt.row_hash
)
,
time_table_union as ( /*объединяем таблицы update и новые версии договоров, для учета случая когда по одному договору пришло и то и то*/
    select 
        agreement_sid
        , type_sid
        , type_code
        , type_name
        , subtype_sid
        , subtype_code
        , subtype_name
        , contract_version_sid
        , ctl_action
        , ctl_loading
        , ctl_validfrom
        , start_dttm
        , end_dttm
        , source_system_code
        , tech_distr_name
        , row_hash
        , part_1_day
    from (
        select 
        *,
        row_number() over(partition by t.agreement_sid, t.subtype_sid, t.start_dttm order by t.ctl_validfrom desc) rn
        from ( 
            select * from inc_tbl_updated
            union all
            select * from time_table2
    ) t ) 
    where rn = 1
)
,
dt_list as ( /*из временной таблицы всех изменений по договорам забираем партиции, по которым пришли изменения*/
select distinct part_1_day
from time_table_union
--where part_1_day != '9999-12-31'
)

select
    agreement_sid
    , type_sid
    , type_code
    , type_name
    , subtype_sid
    , subtype_code
    , subtype_name
    , contract_version_sid
    , ctl_action
    , ctl_loading
    , ctl_validfrom
    , start_dttm
    , end_dttm
    , source_system_code
    , tech_distr_name
    , row_hash
    , part_1_day
from (
    select 
    t2.*
    , row_number() over(partition by t2.row_hash, t2.subtype_sid order by t2.end_dttm asc) as rn
    , case 
        when t2.start_dttm = t2.end_dttm then 1
        else row_number() over(partition by t2.agreement_sid, t2.subtype_sid, t2.start_dttm order by t2.ctl_validfrom desc) 
    end as rn2
   from(
        select /*забираем сторки, по которым пришли какие-либо изменения в инкременте*/
            agreement_sid
            , type_sid
            , type_code
            , type_name
            , subtype_sid
            , subtype_code
            , subtype_name
            , contract_version_sid
            , ctl_action
            , ctl_loading
            , ctl_validfrom
            , start_dttm
            , end_dttm
            , source_system_code
            , tech_distr_name
            , row_hash
            , part_1_day
            from time_table_union
        union all
        select
            agreement_sid
            , type_sid
            , type_code
            , type_name
            , subtype_sid
            , subtype_code
            , subtype_name
            , contract_version_sid
            , ctl_action
            , ctl_loading
            , ctl_validfrom
            , start_dttm
            , end_dttm
            , source_system_code
            , tech_distr_name
            , row_hash
            , tgt.part_1_day
        from  dt_list as dl   /*забираем данные из партиция таргета, в которых пришли изменения в инкременте*/
        inner join $app.target.schema.name.$app.target.table.name as tgt on dl.part_1_day = tgt.part_1_day
) t2 ) t3
where rn = 1 and rn2 = 1);
