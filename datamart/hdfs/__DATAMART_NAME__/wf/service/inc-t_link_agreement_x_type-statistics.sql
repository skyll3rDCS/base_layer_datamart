select '910' as statistic,  count(inc.agreement_sid) as stats_value
  from
       ${$app.stg.schema.name}.t_link_agreement_x_type_inc inc
       left join ${$app.target.schema.name}.t_link_agreement_x_type tgt
           on inc.agreement_sid = tgt.agreement_sid and tgt.part_1_day = '9999-12-31'
  where
        tgt.agreement_sid is null

union
select '911' as statistic, count(inc.agreement_sid) as stats_value
  from
       ${$app.stg.schema.name}.t_link_agreement_x_type_inc inc
       join   ${$app.target.schema.name}.t_link_agreement_x_type tgt
           on inc.agreement_sid = tgt.agreement_sid and tgt.part_1_day = '9999-12-31'
where
      inc.row_hash != tgt.row_hash

union
select '912' as statistic,   0 as stats_value
;