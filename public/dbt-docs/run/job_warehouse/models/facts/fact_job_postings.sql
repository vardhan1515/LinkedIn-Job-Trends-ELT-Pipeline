
  
    

  create  table "job_warehouse"."analytics_analytics"."fact_job_postings__dbt_tmp"
  
  
    as
  
  (
    with base as (
    select *
    from "job_warehouse"."analytics_staging"."stg_job_postings"
),

role_map as (
    select
        job_id,
        
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
    from base
)

select
    b.job_id as posting_id,
    md5(coalesce(b.company_id, '') || '|' || coalesce(b.company_name, '')) as company_key,
    md5(coalesce(b.location, '') || '|' || coalesce(b.zip_code, '') || '|' || coalesce(b.fips, '')) as location_key,
    md5(r.role) as role_key,
    b.posting_date as date_day,
    b.company_id,
    b.company_name,
    b.title,
    b.location,
    b.workplace_type,
    b.listed_at,
    b.original_listed_at,
    b.expires_at,
    b.closed_at,
    b.min_salary,
    b.med_salary,
    b.max_salary,
    b.normalized_salary,
    b.currency,
    b.compensation_type,
    b.pay_period,
    b.formatted_experience_level,
    b.views,
    b.applies,
    b.posting_domain,
    b.sponsored
from base b
left join role_map r
    on b.job_id = r.job_id
  );
  