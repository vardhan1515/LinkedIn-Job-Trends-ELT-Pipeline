
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select date_day
from "job_warehouse"."analytics_analytics"."dim_date"
where date_day is null



  
  
      
    ) dbt_internal_test