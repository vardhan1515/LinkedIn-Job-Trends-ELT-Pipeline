
    
    

with all_values as (

    select
        workplace_type as value_field,
        count(*) as n_records

    from "job_warehouse"."analytics_staging"."stg_job_postings"
    group by workplace_type

)

select *
from all_values
where value_field not in (
    'remote','hybrid','onsite','unknown'
)


