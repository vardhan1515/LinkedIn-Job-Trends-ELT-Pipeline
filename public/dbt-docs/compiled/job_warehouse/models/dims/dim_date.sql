select distinct
    posting_date as date_day,
    extract(year from posting_date)::int as year,
    extract(month from posting_date)::int as month,
    date_trunc('month', posting_date)::date as month_start,
    to_char(posting_date, 'Mon') as month_name,
    extract(quarter from posting_date)::int as quarter
from "job_warehouse"."analytics_staging"."stg_job_postings"
where posting_date is not null