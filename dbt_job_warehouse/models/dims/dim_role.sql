with roles as (
    select distinct
        {{ job_role_from_title('title') }} as role
    from {{ ref('stg_job_postings') }}
)

select
    md5(role) as role_key,
    role
from roles
