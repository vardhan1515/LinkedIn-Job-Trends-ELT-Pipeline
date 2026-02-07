select distinct
    md5(coalesce(location, '') || '|' || coalesce(zip_code, '') || '|' || coalesce(fips, '')) as location_key,
    location,
    zip_code,
    fips
from {{ ref('stg_job_postings') }}
where location is not null
