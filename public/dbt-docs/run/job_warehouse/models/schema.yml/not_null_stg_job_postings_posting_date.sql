
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select posting_date
from "job_warehouse"."analytics_staging"."stg_job_postings"
where posting_date is null



  
  
      
    ) dbt_internal_test