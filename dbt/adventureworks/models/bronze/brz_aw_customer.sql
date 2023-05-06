with source as (

    select * from {{ source('aw', 'sales_customer') }}

),

renamed as (

    select
        customerid as customer_id,
        personid as person_id,
        storeid as store_id,
        territoryid as territory_id

    from source

)

select * from renamed