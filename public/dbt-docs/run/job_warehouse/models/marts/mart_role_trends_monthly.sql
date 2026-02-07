
  
    

  create  table "job_warehouse"."analytics_marts"."mart_role_trends_monthly__dbt_tmp"
  
  
    as
  
  (
    select
    date_trunc('month', date_day)::date as month_start,
    r.role,
    count(distinct posting_id) as posting_count
from "job_warehouse"."analytics_analytics"."fact_job_postings" f
join "job_warehouse"."analytics_analytics"."dim_role" r
    on f.role_key = r.role_key
where date_day is not null
group by 1, 2
  );
  