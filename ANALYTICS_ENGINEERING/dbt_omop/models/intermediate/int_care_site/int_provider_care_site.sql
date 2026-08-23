select
    hash(id) as care_site_id
    , name as care_site_name
    , 0 as place_of_service_concept_id
    , hash(id) as location_id
    , id as care_site_source_value
    , null as place_of_service_source_value
    , _loaded_date
from {{ref('stg_providers')}}