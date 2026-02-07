select
    b.posting_id,
    d.skill_key,
    d.skill,
    d.category,
    md5(d.category) as category_key
from "job_warehouse"."analytics_intermediate"."bridge_posting_skills" b
join "job_warehouse"."analytics_analytics"."dim_skill" d
    on b.skill = d.skill