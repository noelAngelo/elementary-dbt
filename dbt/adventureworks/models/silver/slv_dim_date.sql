with brz_aw_date as (
    select * from {{ ref('brz_aw_date') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['brz_aw_date.date_day']) }} as date_key,
    *,
    {{ dbt_housekeeping() }}
from brz_aw_date
