{{ config(
    materialized='incremental',
    schema='silver',
    file_format='delta', 
    unique_key='address_key',
    incremental_strategy='merge'
) }}

with brz_aw_address as (
    select *
    from {{ ref('brz_aw_address') }}
),

brz_aw_state_province as (
    select *
    from {{ ref('brz_aw_state_province') }}
),

brz_aw_country_region as (
    select *
    from {{ ref('brz_aw_country_region') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['brz_aw_address.address_id']) }} as address_key,
    brz_aw_address.address_id,
    brz_aw_address.city as city_name,
    brz_aw_state_province.state_province_name as state_name,
    brz_aw_country_region.country_region_name as country_name,
    greatest(brz_aw_address.modified_date, cast(brz_aw_state_province.modified_date as timestamp), brz_aw_country_region.modified_date) as modified_date,
    {{ dbt_housekeeping() }}
from brz_aw_address
left join brz_aw_state_province on brz_aw_address.state_province_id = brz_aw_state_province.state_province_id
left join brz_aw_country_region on brz_aw_state_province.country_region_code = brz_aw_country_region.country_region_code
