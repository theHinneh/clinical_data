select
    hash(provider.id) as provider_id
    , provider.name as provider_name
    , null as npi
    , null as dea
    , specialty_concept.concept_id as specialty_concept_id
    , hash(id) as care_site_id
    , 0 as year_of_birth
    , coalesce(gender_concept.concept_id, 0) as gender_concept_id
    , id as provider_source_value
    , provider.speciality as specialty_source_value
    , 0 as specialty_source_concept_id
    , provider.gender as gender_source_value
    , 0 as gender_source_concept_id
from {{ref('stg_providers')}} as provider

left join {{ref('concept')}} as specialty_concept
    on specialty_concept.domain_id = 'Provider'
    and specialty_concept.standard_concept = 'S'
    and lower(specialty_concept.concept_name) = lower(provider.speciality)

left join {{ref('concept')}} gender_concept
    on gender_concept.domain_id = 'Gender'
    and gender_concept.standard_concept = 'S'
    and gender_concept.concept_code = provider.gender