
  create view "job_warehouse"."analytics_staging"."stg_job_postings__dbt_tmp"
    
    
  as (
    with source as (
    select *
    from "job_warehouse"."raw"."raw_job_postings"
    where coalesce(job_id, '') <> 'job_id'
      and coalesce(listed_time, '') <> 'listed_time'
),

cleaned as (
    select
        nullif(trim(job_id), '') as job_id,
        nullif(trim(company_id), '') as company_id,
        nullif(trim(company_name), '') as company_name,
        nullif(trim(title), '') as title,
        nullif(trim(description), '') as description,
        nullif(trim(location), '') as location,
        nullif(trim(zip_code), '') as zip_code,
        nullif(trim(fips), '') as fips,
        nullif(trim(pay_period), '') as pay_period,
        nullif(trim(formatted_experience_level), '') as formatted_experience_level,
        nullif(trim(formatted_work_type), '') as formatted_work_type,
        nullif(trim(work_type), '') as work_type,
        nullif(trim(currency), '') as currency,
        nullif(trim(compensation_type), '') as compensation_type,
        nullif(trim(posting_domain), '') as posting_domain,
        nullif(trim(skills_desc), '') as skills_desc,
        nullif(trim(job_posting_url), '') as job_posting_url,
        nullif(trim(application_url), '') as application_url,
        nullif(trim(application_type), '') as application_type,
        nullif(trim(sponsored), '') as sponsored,
        nullif(trim(remote_allowed), '') as remote_allowed,
        nullif(trim(views), '')::int as views,
        nullif(trim(applies), '')::int as applies,
        nullif(trim(min_salary), '')::numeric as min_salary,
        nullif(trim(med_salary), '')::numeric as med_salary,
        nullif(trim(max_salary), '')::numeric as max_salary,
        nullif(trim(normalized_salary), '')::numeric as normalized_salary,
        case
            when trim(listed_time) ~ '^[0-9]+(\\.[0-9]+)?$' then trim(listed_time)::numeric::bigint
            else null
        end as listed_time_ms,
        case
            when trim(original_listed_time) ~ '^[0-9]+(\\.[0-9]+)?$' then trim(original_listed_time)::numeric::bigint
            else null
        end as original_listed_time_ms,
        case
            when trim(expiry) ~ '^[0-9]+(\\.[0-9]+)?$' then trim(expiry)::numeric::bigint
            else null
        end as expiry_ms,
        case
            when trim(closed_time) ~ '^[0-9]+(\\.[0-9]+)?$' then trim(closed_time)::numeric::bigint
            else null
        end as closed_time_ms,
        load_date,
        ingested_at
    from source
),

final as (
    select
        job_id,
        company_id,
        company_name,
        title,
        description,
        location,
        zip_code,
        fips,
        pay_period,
        formatted_experience_level,
        formatted_work_type,
        work_type,
        currency,
        compensation_type,
        posting_domain,
        skills_desc,
        job_posting_url,
        application_url,
        application_type,
        sponsored,
        remote_allowed,
        views,
        applies,
        min_salary,
        med_salary,
        max_salary,
        normalized_salary,
        coalesce(listed_time_ms, original_listed_time_ms) as posting_time_ms,
        to_timestamp(coalesce(listed_time_ms, original_listed_time_ms) / 1000.0) as listed_at,
        to_timestamp(original_listed_time_ms / 1000.0) as original_listed_at,
        to_timestamp(expiry_ms / 1000.0) as expires_at,
        to_timestamp(closed_time_ms / 1000.0) as closed_at,
        (to_timestamp(coalesce(listed_time_ms, original_listed_time_ms) / 1000.0))::date as posting_date,
        case
            when lower(coalesce(formatted_work_type, '')) in ('remote') then 'remote'
            when lower(coalesce(formatted_work_type, '')) in ('hybrid') then 'hybrid'
            when lower(coalesce(formatted_work_type, '')) in ('on-site', 'onsite', 'on site') then 'onsite'
            when lower(coalesce(remote_allowed, '')) in ('1', 'true', 't', 'yes', 'y') then 'remote'
            else 'unknown'
        end as workplace_type,
        load_date,
        ingested_at
    from cleaned
    where company_name is not null
      and title is not null
      and coalesce(listed_time_ms, original_listed_time_ms) is not null
),

ranked as (
    select
        *,
        row_number() over (partition by job_id order by listed_at desc nulls last, ingested_at desc) as rn
    from final
)

select *
from ranked
where rn = 1
  );