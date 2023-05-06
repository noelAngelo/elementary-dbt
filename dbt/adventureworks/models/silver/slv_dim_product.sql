{{ config(
    materialized='incremental',
    schema='silver',
    file_format='delta', 
    unique_key='product_key',
    incremental_strategy='merge'
) }}
with brz_aw_product as (
    select *
    from {{ ref('brz_aw_product') }}
),

brz_aw_product_subcategory as (
    select *
    from {{ ref('brz_aw_product_subcategory') }}
),

brz_aw_product_category as (
    select *
    from {{ ref('brz_aw_product_category') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['brz_aw_product.product_id']) }} as product_key,
    brz_aw_product.product_id,
    brz_aw_product.product_name as product_name,
    brz_aw_product.product_number,
    brz_aw_product.color,
    brz_aw_product.class,
    brz_aw_product_subcategory.product_subcategory_name as product_subcategory_name,
    brz_aw_product_category.product_category_name as product_category_name,
    greatest(brz_aw_product.modified_date,brz_aw_product_subcategory.modified_date,brz_aw_product_category.modified_date) as modified_date,
    {{ dbt_housekeeping() }}
from brz_aw_product
left join brz_aw_product_subcategory on brz_aw_product.product_subcategory_id = brz_aw_product_subcategory.product_subcategory_id
left join brz_aw_product_category on brz_aw_product_subcategory.product_category_id = brz_aw_product_category.product_category_id
