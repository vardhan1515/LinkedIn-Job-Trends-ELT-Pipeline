
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select job_id
from "job_warehouse"."analytics_staging"."stg_job_postings"
where job_id is null



  
  
      
    ) dbt_internal_test