
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select company_name
from "job_warehouse"."analytics_staging"."stg_job_postings"
where company_name is null



  
  
      
    ) dbt_internal_test