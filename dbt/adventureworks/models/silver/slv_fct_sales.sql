{{ config(
    materialized='incremental',
    schema='silver',
    file_format='delta'
) }}
with brz_aw_sales_order_header as (
    select
        sales_order_id,
        customer_id,
        credit_card_id,
        ship_to_address_id,
        status as order_status,
        cast(order_date as date) as order_date,
        modified_date
    from {{ ref('brz_aw_sales_order_header') }}
),

brz_aw_sales_order_detail as (
    select
        sales_order_id,
        sales_order_detail_id,
        product_id,
        order_qty,
        unit_price,
        unit_price * order_qty as revenue,
        modified_date
    from {{ ref('brz_aw_sales_order_detail') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['brz_aw_sales_order_detail.sales_order_id', 'sales_order_detail_id']) }} as sales_key,
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
    {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as customer_key,
    {{ dbt_utils.generate_surrogate_key(['credit_card_id']) }} as credit_card_key,
    {{ dbt_utils.generate_surrogate_key(['ship_to_address_id']) }} as ship_address_key,
    {{ dbt_utils.generate_surrogate_key(['order_status']) }} as order_status_key,
    {{ dbt_utils.generate_surrogate_key(['order_date']) }} as order_date_key,
    brz_aw_sales_order_detail.sales_order_id,
    brz_aw_sales_order_detail.sales_order_detail_id,
    brz_aw_sales_order_detail.unit_price,
    brz_aw_sales_order_detail.order_qty,
    brz_aw_sales_order_detail.revenue,
    greatest(brz_aw_sales_order_detail.modified_date,brz_aw_sales_order_header.modified_date) as modified_date,
    {{ dbt_housekeeping() }}

from brz_aw_sales_order_detail
inner join brz_aw_sales_order_header on brz_aw_sales_order_detail.sales_order_id = brz_aw_sales_order_header.sales_order_id
