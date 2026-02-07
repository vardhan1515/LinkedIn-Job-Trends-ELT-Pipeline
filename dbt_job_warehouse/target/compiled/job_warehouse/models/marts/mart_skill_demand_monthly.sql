with base as (
    select
        date_trunc('month', f.date_day)::date as month_start,
        s.skill,
        s.category,
        f.posting_id
    from "job_warehouse"."analytics_analytics"."fact_posting_skills" s
    join "job_warehouse"."analytics_analytics"."fact_job_postings" f
        on s.posting_id = f.posting_id
    where f.date_day is not null
)

select
    month_start,
    skill,
    category,
    count(distinct posting_id) as posting_count
from base
group by 1, 2, 3