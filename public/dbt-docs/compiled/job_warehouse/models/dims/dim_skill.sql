select distinct
    md5(skill) as skill_key,
    skill,
    category
from "job_warehouse"."analytics_intermediate"."bridge_posting_skills"