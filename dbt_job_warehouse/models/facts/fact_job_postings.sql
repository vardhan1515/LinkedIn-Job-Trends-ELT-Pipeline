with base as (
    select *
    from {{ ref('stg_job_postings') }}
),

role_map as (
    select
        job_id,
        {{ job_role_from_title('title') }} as role
    from base
)

select
    b.job_id as posting_id,
    md5(coalesce(b.company_id, '') || '|' || coalesce(b.company_name, '')) as company_key,
    md5(coalesce(b.location, '') || '|' || coalesce(b.zip_code, '') || '|' || coalesce(b.fips, '')) as location_key,
    md5(r.role) as role_key,
    b.posting_date as date_day,
    b.company_id,
    b.company_name,
    b.title,
    b.location,
    b.workplace_type,
    b.listed_at,
    b.original_listed_at,
    b.expires_at,
    b.closed_at,
    b.min_salary,
    b.med_salary,
    b.max_salary,
    b.normalized_salary,
    b.currency,
    b.compensation_type,
    b.pay_period,
    b.formatted_experience_level,
    b.views,
    b.applies,
    b.posting_domain,
    b.sponsored
from base b
left join role_map r
    on b.job_id = r.job_id
