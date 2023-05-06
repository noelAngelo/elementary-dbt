{{ config(
    materialized='incremental',
    schema='silver',
    file_format='delta', 
    unique_key='order_status_key',
    incremental_strategy='merge'
) }}
with brz_aw_sales_order_header as (
    select distinct status as order_status
    from
        {{ ref('brz_aw_sales_order_header') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['brz_aw_sales_order_header.order_status']) }} as order_status_key,
    order_status,
    case
        when order_status = 1 then 'in_process'
        when order_status = 2 then 'approved'
        when order_status = 3 then 'backordered'
        when order_status = 4 then 'rejected'
        when order_status = 5 then 'shipped'
        when order_status = 6 then 'cancelled'
        else 'no_status'
    end as order_status_name ,
    {{ dbt_housekeeping() }}
from brz_aw_sales_order_header
