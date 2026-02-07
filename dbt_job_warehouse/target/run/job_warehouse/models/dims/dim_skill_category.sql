
  
    

  create  table "job_warehouse"."analytics_analytics"."dim_skill_category__dbt_tmp"
  
  
    as
  
  (
    select distinct
    md5(category) as category_key,
    category
from "job_warehouse"."analytics_analytics"."dim_skill"
  );
  