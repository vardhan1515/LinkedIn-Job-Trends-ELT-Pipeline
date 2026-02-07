
  
    

  create  table "job_warehouse"."analytics_analytics"."dim_location__dbt_tmp"
  
  
    as
  
  (
    select distinct
    md5(coalesce(location, '') || '|' || coalesce(zip_code, '') || '|' || coalesce(fips, '')) as location_key,
    location,
    zip_code,
    fips
from "job_warehouse"."analytics_staging"."stg_job_postings"
where location is not null
  );
  