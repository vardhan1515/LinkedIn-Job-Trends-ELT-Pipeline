
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select category
from "job_warehouse"."analytics_analytics"."dim_skill"
where category is null



  
  
      
    ) dbt_internal_test