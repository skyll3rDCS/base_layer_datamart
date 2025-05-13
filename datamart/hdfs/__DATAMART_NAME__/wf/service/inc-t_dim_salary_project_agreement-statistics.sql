select '910' as statistic,  count(inc.sid) as stats_value
  from
       ${$app.stg.schema.name}.t_dim_salary_project_agreement_inc inc
       left join ${$app.target.schema.name}.t_dim_salary_project_agreement tgt
           on inc.sid = tgt.sid and tgt.part_1_day = '9999-12-31'
  where
       tgt.sid is null
union
select '911' as statistic,  count(inc.sid) as stats_value
  from
        ${$app.stg.schema.name}.t_dim_salary_project_agreement_inc inc
        join ${$app.target.schema.name}.t_dim_salary_project_agreement tgt
             on inc.sid = tgt.sid and tgt.part_1_day = '9999-12-31'
 where
      inc.row_hash != tgt.row_hash
union
select '912' as statistic,   0 as stats_value
;