with source as (

    select * from {{ source('aw', 'sales_creditcard') }}

),

renamed as (

    select
        creditcardid as credit_card_id,
        cardtype as card_type,
        expyear as expiry_year,
        modifieddate as modified_date,
        expmonth as expiry_month,
        cardnumber as card_number

    from source

)

select * from renamed