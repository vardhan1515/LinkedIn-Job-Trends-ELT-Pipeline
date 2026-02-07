
    
    

select
    role_key as unique_field,
    count(*) as n_records

from "job_warehouse"."analytics_analytics"."dim_role"
where role_key is not null
group by role_key
having count(*) > 1


