select '910' as statistic,  count(inc.sid) as stats_value
  from
       ${$app.stg.schema.name}.t_fct_salary_project_enrollment_inc inc

union
select '911' as statistic, 0 as stats_value

union  
select  '912' as statistic, 0 as stats_value ;

