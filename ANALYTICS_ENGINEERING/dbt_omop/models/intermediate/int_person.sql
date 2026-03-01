select
    hash(id) as person_id
    , coalesce(gender_concept.concept_id, 0) as gender_concept_id
    , date_part('year', birthdate) as year_of_birth
    , date_part('month', birthdate) as month_of_birth
    , date_part('day', birthdate) as day_of_birth
    , birthdate as birth_datetime
    , coalesce(race_concept.concept_id, 0) as race_concept_id
    , ethnicity_concept.concept_id as ethnicity_concept_id
    , 0 as location_id --Todo
    , 0 as provider_id --Todo
    , 0 as care_site_id --Todo
    , id as person_source_value
    , gender as gender_source_value
    , 0 as gender_source_concept_id
    , race as race_source_value
    , 0 as race_source_concept_id
    , ethnicity as ethnicity_source_value
    , 0 as ethnicity_source_concept_id
from {{ref('stg_patients')}} as patient

left join {{ref('concept')}} gender_concept
    on gender_concept.concept_code = patient.gender -- lucky for me, this was an easy join.
    and gender_concept.domain_id = 'Gender'
    and gender_concept.standard_concept = 'S'

-- Only 6 races in the data: other,hawaiian,asian,native,black,white. I'll deal with "other" later.
left join {{ref('concept')}} race_concept
    on lower(race_concept.concept_name) = lower(patient.race)
    and race_concept.domain_id = 'Race'
    and race_concept.standard_concept = 'S'

left join {{ref('concept')}} ethnicity_concept
    on lower(ethnicity_concept.concept_name) = lower(patient.race)
    and ethnicity_concept.domain_id = 'Ethnicity'
    and ethnicity_concept.standard_concept = 'S'

where deathdate is null