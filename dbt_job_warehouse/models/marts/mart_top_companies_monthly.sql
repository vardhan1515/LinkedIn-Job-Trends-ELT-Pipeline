select
    date_trunc('month', date_day)::date as month_start,
    company_name,
    count(distinct posting_id) as posting_count
from {{ ref('fact_job_postings') }}
where date_day is not null and company_name is not null
group by 1, 2
