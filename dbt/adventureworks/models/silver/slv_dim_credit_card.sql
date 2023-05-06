{{ config(
    materialized='incremental',
    schema='silver',
    file_format='delta', 
    unique_key='credit_card_key',
    incremental_strategy='merge'
) }}
with brz_aw_sales_order_header as (
    select distinct credit_card_id
    from {{ ref('brz_aw_sales_order_header') }}
    where credit_card_id is not null
),

brz_aw_credit_card as (
    select *
    from {{ ref('brz_aw_credit_card') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['brz_aw_sales_order_header.credit_card_id']) }} as credit_card_key,
    brz_aw_sales_order_header.credit_card_id,
    brz_aw_credit_card.card_type,
    brz_aw_credit_card.modified_date as modified_date,
    {{ dbt_housekeeping() }}

from brz_aw_sales_order_header
left join brz_aw_credit_card on brz_aw_sales_order_header.credit_card_id = brz_aw_credit_card.credit_card_id
