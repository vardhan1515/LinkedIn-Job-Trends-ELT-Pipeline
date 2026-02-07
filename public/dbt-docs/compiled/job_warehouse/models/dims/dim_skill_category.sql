select distinct
    md5(category) as category_key,
    category
from "job_warehouse"."analytics_analytics"."dim_skill"