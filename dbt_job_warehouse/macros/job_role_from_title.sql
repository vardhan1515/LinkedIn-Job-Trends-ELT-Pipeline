{% macro job_role_from_title(title_expr) %}
case
    when {{ title_expr }} is null then 'other'
    when {{ title_expr }} ~* 'analytics engineer' then 'analytics_engineer'
    when {{ title_expr }} ~* 'data engineer|data engineering|etl developer|elt developer|data pipeline|data platform' then 'data_engineer'
    when {{ title_expr }} ~* 'data scientist|applied scientist|research scientist' then 'data_scientist'
    when {{ title_expr }} ~* 'machine learning|ml engineer|mlops' then 'ml_engineer'
    when {{ title_expr }} ~* 'business intelligence|bi developer|bi engineer|bi analyst|reporting analyst' then 'bi_analyst'
    when {{ title_expr }} ~* 'data analyst|analytics analyst|insights analyst' then 'data_analyst'
    when {{ title_expr }} ~* 'business analyst|product analyst|operations analyst' then 'business_analyst'
    when {{ title_expr }} ~* 'data architect' then 'data_architect'
    when {{ title_expr }} ~* 'data quality|dq engineer' then 'data_quality'
    when {{ title_expr }} ~* 'data governance' then 'data_governance'
    when {{ title_expr }} ~* 'database administrator|\\mdba\\M' then 'dba'
    else 'other'
end
{% endmacro %}
