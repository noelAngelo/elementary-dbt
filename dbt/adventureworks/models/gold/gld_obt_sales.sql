with slv_fct_sales as (
    select * from {{ ref('slv_fct_sales') }}
),

slv_dim_customer as (
    select * from {{ ref('slv_dim_customer') }}
),

slv_dim_credit_card as (
    select * from {{ ref('slv_dim_credit_card') }}
),

slv_dim_address as (
    select * from {{ ref('slv_dim_address') }}
),

slv_dim_order_status as (
    select * from {{ ref('slv_dim_order_status') }}
),

slv_dim_product as (
    select * from {{ ref('slv_dim_product') }}
),

slv_dim_date as (
    select * from {{ ref('slv_dim_date') }}
)

select
    {{ dbt_utils.star(from=ref('slv_fct_sales'), relation_alias='slv_fct_sales', except=[
        "product_key", "customer_key", "creditcard_key", "ship_address_key", "order_status_key", "order_date_key","modified_date","invocation_id","invocation_timestamp"
    ]) }},
    {{ dbt_utils.star(from=ref('slv_dim_product'), relation_alias='slv_dim_product', except=["product_key","modified_date","invocation_id","invocation_timestamp"]) }},
    {{ dbt_utils.star(from=ref('slv_dim_customer'), relation_alias='slv_dim_customer', except=["customer_key","modified_date","invocation_id","invocation_timestamp"]) }},
    {{ dbt_utils.star(from=ref('slv_dim_credit_card'), relation_alias='slv_dim_credit_card', except=["credit_card_key","modified_date","invocation_id","invocation_timestamp"]) }},
    {{ dbt_utils.star(from=ref('slv_dim_address'), relation_alias='slv_dim_address', except=["address_key","modified_date","invocation_id","invocation_timestamp"]) }},
    {{ dbt_utils.star(from=ref('slv_dim_order_status'), relation_alias='slv_dim_order_status', except=["order_status_key","modified_date","invocation_id","invocation_timestamp"]) }},
    {{ dbt_utils.star(from=ref('slv_dim_date'), relation_alias='slv_dim_date', except=["date_key","modified_date","invocation_id","invocation_timestamp"]) }},
    greatest(slv_fct_sales.modified_date,
        slv_dim_product.modified_date,
        slv_dim_customer.modified_date,
        slv_dim_credit_card.modified_date,
        slv_dim_address.modified_date) as modified_date,
    {{ dbt_housekeeping() }}
from slv_fct_sales
left join slv_dim_product on slv_fct_sales.product_key = slv_dim_product.product_key
left join slv_dim_customer on slv_fct_sales.customer_key = slv_dim_customer.customer_key
left join slv_dim_credit_card on slv_fct_sales.credit_card_key = slv_dim_credit_card.credit_card_key
left join slv_dim_address on slv_fct_sales.ship_address_key = slv_dim_address.address_key
left join slv_dim_order_status on slv_fct_sales.order_status_key = slv_dim_order_status.order_status_key
left join slv_dim_date on slv_fct_sales.order_date_key = slv_dim_date.date_key
