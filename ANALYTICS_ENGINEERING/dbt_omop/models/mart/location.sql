select
    location_id
    , address_1
    , address_2
    , city
    , state
    , zip
    , county
    , location_source_value
    , country_concept_id
    , country_source_value
    , latitude
    , longitude
from {{ref('int_location')}}

{% if is_incremental() %}
where _loaded_date >= dateadd(day, -{{ var('lookback_days', 2) }}, current_date)
{% endif %}