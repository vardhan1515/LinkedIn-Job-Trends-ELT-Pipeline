
  
    

  create  table "job_warehouse"."analytics_analytics"."dim_company__dbt_tmp"
  
  
    as
  
  (
    select distinct
    md5(coalesce(company_id, '') || '|' || coalesce(company_name, '')) as company_key,
    company_id,
    company_name
from "job_warehouse"."analytics_staging"."stg_job_postings"
where company_name is not null
  );
  