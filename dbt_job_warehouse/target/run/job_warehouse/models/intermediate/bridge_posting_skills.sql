
  create view "job_warehouse"."analytics_intermediate"."bridge_posting_skills__dbt_tmp"
    
    
  as (
    with base as (
    select
        job_id,
        lower(coalesce(description, '') || ' ' || coalesce(skills_desc, '')) as text_blob
    from "job_warehouse"."analytics_staging"."stg_job_postings"
),

skills as (
    select skill, category, pattern
    from "job_warehouse"."analytics_intermediate"."skill_dictionary"
)

select
    b.job_id as posting_id,
    s.skill,
    s.category
from base b
join skills s
    on b.text_blob ~* s.pattern
  );