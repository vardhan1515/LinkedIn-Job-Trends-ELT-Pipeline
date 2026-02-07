
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select posting_id
from "job_warehouse"."analytics_analytics"."fact_posting_skills"
where posting_id is null



  
  
      
    ) dbt_internal_test