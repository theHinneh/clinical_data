select
    hash(id) as location_id -- A simple way to get a unique id for a patient's location, since there's no dedicated location table from the source data.
    , address as address_1
    , null as address_2
    , city
    , state
    , zip
    , null as county
    , concat_ws(', ', address, city, state, zip) as location_source_value
    , 4330442 as country_concept_id -- An easy one since all the data originated from the USA
    , 'USA' as country_source_value
    , lat as latitude
    , lon as longitude
from {{ref('stg_organizations')}}