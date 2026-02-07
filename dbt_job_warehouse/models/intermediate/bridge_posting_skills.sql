with base as (
    select
        job_id,
        lower(coalesce(description, '') || ' ' || coalesce(skills_desc, '')) as text_blob
    from {{ ref('stg_job_postings') }}
),

skills as (
    select skill, category, pattern
    from {{ ref('skill_dictionary') }}
)

select
    b.job_id as posting_id,
    s.skill,
    s.category
from base b
join skills s
    on b.text_blob ~* s.pattern
