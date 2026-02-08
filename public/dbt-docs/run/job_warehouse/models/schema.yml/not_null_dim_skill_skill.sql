
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select skill
from "job_warehouse"."analytics_analytics"."dim_skill"
where skill is null



  
  
      
    ) dbt_internal_test