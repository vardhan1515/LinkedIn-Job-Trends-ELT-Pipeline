
  
    

  create  table "job_warehouse"."analytics_analytics"."dim_role__dbt_tmp"
  
  
    as
  
  (
    with roles as (
    select distinct
        
case
    when title is null then 'other'
    when title ~* 'analytics engineer' then 'analytics_engineer'
    when title ~* 'data engineer|data engineering|etl developer|elt developer|data pipeline|data platform' then 'data_engineer'
    when title ~* 'data scientist|applied scientist|research scientist' then 'data_scientist'
    when title ~* 'machine learning|ml engineer|mlops' then 'ml_engineer'
    when title ~* 'business intelligence|bi developer|bi engineer|bi analyst|reporting analyst' then 'bi_analyst'
    when title ~* 'data analyst|analytics analyst|insights analyst' then 'data_analyst'
    when title ~* 'business analyst|product analyst|operations analyst' then 'business_analyst'
    when title ~* 'data architect' then 'data_architect'
    when title ~* 'data quality|dq engineer' then 'data_quality'
    when title ~* 'data governance' then 'data_governance'
    when title ~* 'database administrator|\\mdba\\M' then 'dba'
    else 'other'
end
 as role
    from "job_warehouse"."analytics_staging"."stg_job_postings"
)

select
    md5(role) as role_key,
    role
from roles
  );
  