
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select role
from "job_warehouse"."analytics_analytics"."dim_role"
where role is null



  
  
      
    ) dbt_internal_test