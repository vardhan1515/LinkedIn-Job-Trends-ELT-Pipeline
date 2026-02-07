select distinct
    md5(skill) as skill_key,
    skill,
    category
from {{ ref('bridge_posting_skills') }}
