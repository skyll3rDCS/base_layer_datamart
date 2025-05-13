insert overwrite $app.stg.schema.name.$app.stg.table.name
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
, cast(cast(end_dt as date) as string) as part_1_day
from(
    select
        sid
        , parent_type_sid
        , code
        , name
        , ctl_action
        , ctl_loading
        , ctl_validfrom
        , start_dt
        , case
            when start_dt = lead(start_dt) over(partition by sid order by start_dt)
            then start_dt
            else lead(start_dt - interval '1' day, 1, cast('9999-12-31' as timestamp)) over(partition by sid order by start_dt)
          end as end_dt
        , source_system_code
        , tech_distr_name
        , row_hash
    from(
        select
            sid
            , parent_type_sid
            , code
            , name
            , 'I'                                                                                           as ctl_action
            , null                                                                                          as ctl_loading
            , current_timestamp()                                                                           as ctl_validfrom
            , source_ctl_validfrom                                                                          as start_dt
            ,'ППРБ.ЗД'                                                                                      as source_system_code
            ,'$app.version'                                                                                 as tech_distr_name
            , row_hash
        from(
            select
            t.sid
            , t.parent_type_sid
            , t.code
            , t.name
            , t.source_ctl_validfrom
            , t.row_hash
            , row_number() over (partition by t.row_hash order by t.source_ctl_validfrom desc) as rn
            from(
                select
                t1.sid
                , t1.parent_type_sid
                , t1.code
                , t1.name
                , t1.source_ctl_validfrom
                , sha2(concat(nvl(t1.sid, '0'), nvl(t1.parent_type_sid, '0'), nvl(t1.code, '0'),
                            nvl(t1.name, '0')), 256) as row_hash
                from(
                    select
                    id                    as sid
                    , split(type, ':')[1] as parent_type_sid
                    , code                as code
                    , name                as name
                    , cast(ctl_validfrom as timestamp)       as source_ctl_validfrom
                    from $app_src_schema_name_pprbzdfd.$app_src_table_name_enrlmntsbtp

                    union

                    select
                    id                     as sid
                    , cast(NULL as string) as parent_type_sid
                    , code                 as code
                    , name                 as name
                    , cast(ctl_validfrom as timestamp)       as source_ctl_validfrom
                    from $app_src_schema_name_pprbzdfd.$app_src_table_name_enrlmnttp
                    where 1=1 
                        and ctl_validfrom $loadDt
                ) t1 
            ) t
        )
    where rn = 1));
