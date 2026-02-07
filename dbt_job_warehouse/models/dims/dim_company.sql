select distinct
    md5(coalesce(company_id, '') || '|' || coalesce(company_name, '')) as company_key,
    company_id,
    company_name
from {{ ref('stg_job_postings') }}
where company_name is not null
