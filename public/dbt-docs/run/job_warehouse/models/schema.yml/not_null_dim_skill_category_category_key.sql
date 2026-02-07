
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select category_key
from "job_warehouse"."analytics_analytics"."dim_skill_category"
where category_key is null



  
  
      
    ) dbt_internal_test