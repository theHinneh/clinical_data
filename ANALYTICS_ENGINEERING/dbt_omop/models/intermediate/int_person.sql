select
    hash(id) as person_id
    , coalesce(gender_concept.concept_id, 0) as gender_concept_id
    , date_part('year', birthdate) as year_of_birth
    , date_part('month', birthdate) as month_of_birth
    , date_part('day', birthdate) as day_of_birth
    , birthdate as birth_datetime
    , coalesce(race_concept.concept_id, 0) as race_concept_id
    , case
        when patient.ethnicity = 'nonhispanic'
            then 38003564
        when patient.ethnicity = 'hispanic'
            then 38003563
        else 0
    end as ethnicity_concept_id
    , hash(id) as location_id -- Actually, nothing prevents us from using this as the primary key for the patient's location.
    , null as provider_id -- I was expecting to find the PCP in the patient data, but it's not.
    , null as care_site_id -- Since there's no PCP, this will be left as a null.
    , id as person_source_value
    , gender as gender_source_value
    , 0 as gender_source_concept_id -- I did not map this in the source_to_concept_map, so there's no corresponding source_concept_id.
    , race as race_source_value
    , 0 as race_source_concept_id -- I did not map this in the source_to_concept_map, so there's no corresponding source_concept_id.
    , ethnicity as ethnicity_source_value
    , 0 as ethnicity_source_concept_id
from {{ref('stg_patients')}} as patient -- I did not map this in the source_to_concept_map, so there's no corresponding source_concept_id.

left join {{ref('concept')}} gender_concept
    on gender_concept.concept_code = patient.gender -- lucky for me, this was an easy join.
    and gender_concept.domain_id = 'Gender'
    and gender_concept.standard_concept = 'S'

-- Only 6 races in the data: other,hawaiian,asian,native,black,white. I'll deal with "other" later.
left join {{ref('concept')}} race_concept
    on lower(race_concept.concept_name) = lower(patient.race)
    and race_concept.domain_id = 'Race'
    and race_concept.standard_concept = 'S'

where deathdate is null