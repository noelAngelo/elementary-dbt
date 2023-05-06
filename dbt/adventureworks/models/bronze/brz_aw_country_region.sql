with source as (

    select * from {{ source('aw', 'countryregion') }}

),

renamed as (

    select
        countryregioncode as country_region_code,
        modifieddate as modified_date,
        name as country_region_name

    from source

)

select * from renamed