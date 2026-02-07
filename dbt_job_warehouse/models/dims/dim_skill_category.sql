select distinct
    md5(category) as category_key,
    category
from {{ ref('dim_skill') }}
