{{ config(
    materialized='incremental',
    schema='silver',
    file_format='delta', 
    unique_key='customer_key',
    incremental_strategy='merge'
) }}
with brz_aw_customer as (
    select
        customer_id,
        person_id,
        store_id
    from {{ ref('brz_aw_customer') }}
),

brz_aw_person as (
    select
        business_entity_id,
        concat(coalesce(first_name, ''), ' ', coalesce(middle_name, ''), ' ', coalesce(last_name, '')) as full_name,
        modified_date
    from {{ ref('brz_aw_person') }}
),

brz_aw_store as (
    select
        business_entity_id as store_business_entity_id,
        store_name,
        modified_date
    from {{ ref('brz_aw_store') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['brz_aw_customer.customer_id']) }} as customer_key,
    brz_aw_customer.customer_id,
    brz_aw_person.business_entity_id,
    brz_aw_person.full_name,
    brz_aw_store.store_business_entity_id,
    brz_aw_store.store_name,
    greatest(brz_aw_person.modified_date, brz_aw_store.modified_date) as modified_date,
    {{ dbt_housekeeping() }}
from brz_aw_customer
left join brz_aw_person on brz_aw_customer.person_id = brz_aw_person.business_entity_id
left join brz_aw_store on brz_aw_customer.store_id = brz_aw_store.store_business_entity_id
