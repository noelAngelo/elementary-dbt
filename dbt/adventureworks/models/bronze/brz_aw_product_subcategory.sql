with source as (

    select * from {{ source('aw', 'productsubcategory') }}

),

renamed as (

    select
        productsubcategoryid as product_subcategory_id,
        productcategoryid as product_category_id,
        name as product_subcategory_name,
        modifieddate as modified_date

    from source

)

select * from renamed