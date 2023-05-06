{% macro dbt_housekeeping() -%}
    '{{ invocation_id }}'::string as invocation_id,
    '{{ run_started_at }}'::timestamp as invocation_timestamp
{%- endmacro %}