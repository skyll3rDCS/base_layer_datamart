insert overwrite table $app.stg.schema.name.$app.stg.snp.inc.table.name partition (part_1_day)
(
    sid
    , parent_type_sid
    , code
    , name
    , ctl_action
    , ctl_loading
    , ctl_validfrom
    , start_dt
    , end_dt
    , source_system_code
    , tech_distr_name
    , row_hash
    , part_1_day
)

select * from (
with tgt_tbl as (
select *
  from $app.target.schema.name.$app.target.table.name as tgt
  where tgt.part_1_day = '9999-12-31'
)  /*отбираем актувльные записи из таргета*/
,
inc_tbl as (
select * from  $app.stg.schema.name.$app.stg.table.name as dp
) /*забираем весь инкремент с шага 1*/
,
inc_tbl_without_9999 as (
select * from  $app.stg.schema.name.$app.stg.table.name
WHERE part_1_day != '9999-12-31'
) /*забираем из инкремента все кроме актульных*/
,
time_table as (
SELECT
    t.sid
    , t.parent_type_sid
    , t.code
    , t.name
    , t.ctl_action
    , t.ctl_loading
    , t.ctl_validfrom
    , t.start_dt
    , case
        when t.start_dt = lead(t.start_dt) over(partition by t.sid order by t.start_dt)
        then t.start_dt
        else lead(t.start_dt - interval '1' day, 1, cast('9999-12-31' as timestamp)) over(partition by t.sid order by t.start_dt)
      end as end_dt
    , t.source_system_code
    , t.tech_distr_name
    , t.row_hash
    , cast(to_date(case
        when t.start_dt = lead(t.start_dt) over(partition by t.sid order by t.start_dt)
        then t.start_dt
        else lead(t.start_dt - interval '1' day, 1, cast('9999-12-31' as timestamp)) over(partition by t.sid order by t.start_dt)
      end) as string) as part_1_day
from (
 select
        t2.sid
        , t2.parent_type_sid
        , t2.code
        , t2.name
        , t2.ctl_action
        , t2.ctl_loading
        , t2.ctl_validfrom
        , t2.start_dt
        , t2.end_dt
        , t2.source_system_code
        , t2.tech_distr_name
        , t2.row_hash
        , t2.part_1_day
 from(
     select t1.*,
            row_number() over (partition by t1.row_hash order by t1.start_dt) as rn
     from (
      select
        dp.sid
        , dp.parent_type_sid
        , dp.code
        , dp.name
        , dp.ctl_action
        , dp.ctl_loading
        , dp.ctl_validfrom
        , dp.start_dt
        , dp.end_dt
        , dp.source_system_code
        , dp.tech_distr_name
        , dp.row_hash
        , dp.part_1_day
      from  inc_tbl as dp
      left join tgt_tbl as tgt
      on dp.sid = tgt.sid
      where 1 = 1
        and dp.row_hash != tgt.row_hash
        /*объединяем инкремент с актуальными записями таргета, где hash отличается*/

      union all

      select
       tgt.sid
        , tgt.parent_type_sid
        , tgt.code
        , tgt.name
        , tgt.ctl_action
        , tgt.ctl_loading
        , tgt.ctl_validfrom
        , tgt.start_dt
        , tgt.end_dt
        , tgt.source_system_code
        , tgt.tech_distr_name
        , tgt.row_hash
        , tgt.part_1_day
      from inc_tbl as dp
      inner join tgt_tbl as tgt
      on dp.sid = tgt.sid
      where 1 = 1
        --and dp.row_hash != tgt.row_hash
        /*объединяем инкремент с актуальными записями из таргета*/
        /*забирает из таргета пересечение с инкрементом*/

  union all

  select
    tgt.sid
        , tgt.parent_type_sid
        , tgt.code
        , tgt.name
        , tgt.ctl_action
        , tgt.ctl_loading
        , tgt.ctl_validfrom
        , tgt.start_dt
        , tgt.end_dt
        , tgt.source_system_code
        , tgt.tech_distr_name
        , tgt.row_hash
        , tgt.part_1_day
      from inc_tbl_without_9999 dp
      inner join $app.target.schema.name.$app.target.table.name as tgt
        ON dp.part_1_day = tgt.part_1_day
        AND dp.sid = tgt.sid
        /*объединяем инкремент без актальных записей с таргетом по id и part_1_day*/
        ) t1
    ) t2
    where t2.rn = 1

  union  all

  select
    dp.sid
        , dp.parent_type_sid
        , dp.code
        , dp.name
        , dp.ctl_action
        , dp.ctl_loading
        , dp.ctl_validfrom
        , case
            when row_number() over (partition by dp.sid order by dp.start_dt) = 1
            then cast('1900-01-01' as timestamp)
            else dp.start_dt
         end as start_dt
        , dp.end_dt
        , dp.source_system_code
        , dp.tech_distr_name
        , dp.row_hash
        , dp.part_1_day
  from  inc_tbl as dp
  left join tgt_tbl as tgt
  on dp.sid = tgt.sid
  where 1 = 1
    and tgt.sid is null
    /*отбирает чисто новые записи из инкремента*/

   union all

   select
    tgt.sid
        , tgt.parent_type_sid
        , tgt.code
        , tgt.name
        , tgt.ctl_action
        , tgt.ctl_loading
        , tgt.ctl_validfrom
        , tgt.start_dt
        , tgt.end_dt
        , tgt.source_system_code
        , tgt.tech_distr_name
        , tgt.row_hash
        , tgt.part_1_day
  from tgt_tbl as tgt
  left join  inc_tbl as dp
  on dp.sid = tgt.sid
    where 1 = 1
      and dp.sid is null
)t )
,
dt_list as ( /*из временной таблицы забираем все строки кроме актульных*/
select distinct part_1_day
from time_table
where part_1_day != '9999-12-31')


select
      sid
        , parent_type_sid
        , code
        , name
        , ctl_action
        , ctl_loading
        , ctl_validfrom
        , start_dt
        , end_dt
        , source_system_code
        , tech_distr_name
        , row_hash
        , part_1_day
from (
    select
        *,
        row_number() over(partition by t1.row_hash order by t1.end_dt asc) rn
    from (
        select
            sid
                , parent_type_sid
                , code
                , name
                , ctl_action
                , ctl_loading
                , ctl_validfrom
                , start_dt
                , end_dt
                , source_system_code
                , tech_distr_name
                , row_hash
                , part_1_day
            from time_table
        union all
        select
              sid
                , parent_type_sid
                , code
                , name
                , ctl_action
                , ctl_loading
                , ctl_validfrom
                , start_dt
                , end_dt
                , source_system_code
                , tech_distr_name
                , row_hash
                , tgt.part_1_day
        from $app.target.schema.name.$app.target.table.name as tgt /*находим пересечения в инкременте и таргете*/
        inner join dt_list as dl on dl.part_1_day = tgt.part_1_day
        ) t1
) t2
where rn = 1
);

