insert overwrite $app.stg.schema.name.$app.stg.table.name
(
  agreement_sid
, type_sid
, type_code
, type_name
, subtype_sid
, subtype_code
, subtype_name
, contract_version_sid
, source_ctl_action
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
select
  agreement_sid
, type_sid
, type_code
, type_name
, subtype_sid
, subtype_code
, subtype_name
, contract_version_sid
, cast(null as string) as source_ctl_action
, ctl_action
, ctl_loading
, ctl_validfrom
, start_dttm
, end_dttm
, source_system_code
, tech_distr_name
, row_hash
, cast(cast(end_dttm as date)as string)                                                             as part_1_day
from(
    select 
    lvl_1.contractid                                                                                as agreement_sid
    , split(est.type, ':')[1]                                                                       as type_sid
    , et.code                                                                                       as type_code
    , et.name                                                                                       as type_name
    , lvl_1.enrollmentsubtypeid                                                                     as subtype_sid
    , est.code                                                                                      as subtype_code
    , est.name                                                                                      as subtype_name
    , lvl_1.contract_version_sid                                                                    as contract_version_sid
    , 'I'                                                                                           as ctl_action
    , cast('$app.ctl.loading' as bigint)                                                            as ctl_loading
    , current_timestamp()                                                                           as ctl_validfrom
    , lvl_1.start_dttm                                                                              as start_dttm
    , lvl_1.end_dttm                                                                                as end_dttm
    ,'ППРБ.ЗД'                                                                                      as source_system_code
    ,'$app.version'                                                                                 as tech_distr_name
    , lvl_1.row_hash                                                                                as row_hash
    from(
        select
            split(time_tbl.contract, '[:]')[1] as contractid,
            split(subtype, ':')[0]    as enrollmentsubtypeid,
            split(regexp_replace(time_tbl.enrollmentsubtypes,':([^;]+);',';'),':')[0] as enrollmentsubtypes,
            time_tbl.contract_version_sid,
            time_tbl.start_dttm,
            time_tbl.end_dttm,
            time_tbl.row_hash
            from(
                select
                    contract
                    , enrollmentsubtypes
                    , contract_version_sid
                    , start_dttm
                    , case
                        when start_dttm = lead(start_dttm) over(partition by contract order by start_dttm)
                        then start_dttm
                        else lead(start_dttm - interval '1' microsecond, 1, cast('9999-12-31' as timestamp)) over(partition by contract order by start_dttm)
                    end as end_dttm
                    , row_hash
                from(
                    select
                        contract
                        , enrollmentsubtypes
                        , contract_version_sid
                        , cast(case
                                when row_number() over (partition by contract order by source_versionbegindate) = 1
                                then cast('1900-01-01' as timestamp)
                                else source_versionbegindate
                            end as timestamp) as start_dttm
                        , row_hash
                    from(
                        select
                        t2.contract,
                        t2.enrollmentsubtypes,
                        t2.source_versionbegindate,
                        t2.contract_version_sid,
                        t2.row_hash,
                        row_number() over (partition by t2.row_hash order by t2.source_versionbegindate desc) as rn
                        from(
                            select
                            t1.contract
                            , t1.enrollmentsubtypes
                            , t1.source_versionbegindate
                            , t1.contract_version_sid
                            , sha2(concat(nvl(t1.contract, '0'), nvl(t1.enrollmentsubtypes, '0'), nvl(t1.source_versionbegin_dttmtz, '0')), 256) as row_hash
                            from(
                                select
                                sa.contract
                                , sa.enrollmentsubtypes
                                , sa.id                   as contract_version_sid
                                , sa.versionbegindate     as source_versionbegin_dttmtz
                                , CASE
                                    WHEN sa.versionbegindate like '%UTC%'
                                    THEN cast(replace(split(sa.versionbegindate, 'Z')[0], 'T', ' ') as timestamp) + interval 3 hour
                                    ELSE cast(replace(split(sa.versionbegindate, '[+]')[0], 'T', ' ') as timestamp)
                                  END as source_versionbegindate
                                from $app_src_schema_name_pprbzdfd.$app_src_table_name_slragrmnt sa
                                where 1=1 
                                    and sa.versionbegindate is not NULL
                                    and sa.versionbegindate <> coalesce(sa.versionenddate, 'actual null')
                                ) t1
                            ) t2
                        )
                where rn = 1)) time_tbl
    lateral view outer explode(split(time_tbl.enrollmentsubtypes, ';')) subtype_ids as subtype) lvl_1
    left join $app_src_schema_name_pprbzdfd.$app_src_table_name_enrlmntsbtp est
        on lvl_1.enrollmentsubtypeid = est.id
    left join $app_src_schema_name_pprbzdfd.$app_src_table_name_enrlmnttp et
        on split(est.type, ':')[1] = et.id
    );
