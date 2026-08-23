select
    care_site_id
    ,care_site_name
    ,place_of_service_concept_id
    ,location_id
    ,care_site_source_value
    ,place_of_service_source_value
from {{ ref('int_care_site') }}

{% if is_incremental() %}
where _loaded_date >= dateadd(day, -{{ var('lookback_days', 2) }}, current_date)
{% endif %}