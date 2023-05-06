with source as (

    select * from {{ source('aw', 'sales_store') }}

),

renamed as (

    select
        businessentityid as business_entity_id,
        "Name" as store_name,
        salespersonid as sales_person_id,
        modifieddate as modified_date

    from source

)

select * from renamed