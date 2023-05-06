with source as (

    select * from {{ source('aw', 'salesorderheader') }}

),

renamed as (

    select
        salesorderid as sales_order_id,
        shipmethodid as ship_method_id,
        billtoaddressid as bill_to_address_id,
        modifieddate as modified_date,
        rowguid as row_guid,
        taxamt as tax_amt,
        shiptoaddressid as ship_to_address_id,
        onlineorderflag as online_order_flag,
        territoryid as territory_id,
        status,
        orderdate as order_date,
        creditcardapprovalcode as credit_card_approval_code,
        subtotal as sub_total,
        creditcardid as credit_card_id,
        currencyrateid as currency_rate_id,
        revisionnumber as revision_number,
        freight as freight,
        duedate as due_date,
        totaldue as total_due,
        customerid as customer_id,
        salespersonid as sales_person_id,
        shipdate as ship_date,
        accountnumber as account_number

    from source

)

select * from renamed