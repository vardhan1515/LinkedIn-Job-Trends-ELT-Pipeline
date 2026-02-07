select
    b.posting_id,
    d.skill_key,
    d.skill,
    d.category,
    md5(d.category) as category_key
from {{ ref('bridge_posting_skills') }} b
join {{ ref('dim_skill') }} d
    on b.skill = d.skill
