select
    hash(id) as visit_occurrence_id
    , int_person.person_id
    , visit_concept.target_concept_id as visit_concept_id
    , start::date as visit_start_date
    , start as visit_start_datetime
    , stop::date as visit_end_date
    , stop as visit_end_datetime
    , 32817 as visit_type_concept_id
    , provider.provider_id
    , care_site.care_site_id
    , stg_encounters.encounterclass as visit_source_value
    , visit_concept.source_code as visit_source_concept_id
    , 0 as admitting_source_concept_id
    , null as admitting_source_value
    , 0 as discharge_to_concept_id
    , null as discharge_to_source_value
    , 0 as preceding_visit_occurrence_id
from {{ ref('stg_encounters') }}

inner join {{ ref('int_person') }}
    on stg_encounters.patient = int_person.person_source_value

inner join {{ ref('source_to_concept_map') }} as visit_concept
    on stg_encounters.encounterclass = visit_concept.source_code_description
    and visit_concept.target_vocabulary_id = 'Visit'

left join {{ ref('int_provider') }} as provider
    on provider.provider_source_value = stg_encounters.provider

left join {{ ref('int_care_site') }} as care_site
    on care_site.care_site_source_value = stg_encounters.organization