select
    date_trunc('month', date_day)::date as month_start,
    r.role,
    avg(case when workplace_type = 'remote' then 1.0 else 0.0 end) as remote_share
from {{ ref('fact_job_postings') }} f
join {{ ref('dim_role') }} r
    on f.role_key = r.role_key
where date_day is not null
group by 1, 2
