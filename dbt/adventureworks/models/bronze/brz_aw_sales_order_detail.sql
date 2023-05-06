with source as (

    select * from {{ source('aw', 'salesorderdetail') }}

),

renamed as (

    select
        salesorderid as sales_order_id,
        orderqty as order_qty,
        salesorderdetailid as sales_order_detail_id,
        unitprice as unit_price,
        specialofferid as special_offer_id,
        modifieddate as modified_date,
        rowguid as row_guid,
        productid as product_id,
        unitpricediscount as unit_priced_is_count

    from source

)

select * from renamed