select
    concept_id
    ,concept_name
    ,domain_id
    ,vocabulary_id
    ,concept_class_id
    ,standard_concept
    ,concept_code
    ,strptime(valid_start_date::varchar, '%Y%m%d')::date as valid_start_date
    ,strptime(valid_end_date::varchar, '%Y%m%d')::date as valid_end_date
    ,invalid_reason
from {{ref('stg_concept')}}
union all

select
    concept_id
    ,concept_name
    ,domain_id
    ,vocabulary_id
    ,concept_class_id
    ,standard_concept
    ,concept_code
    ,strptime(valid_start_date::varchar, '%Y%m%d')::date as valid_start_date
    ,strptime(valid_end_date::varchar, '%Y%m%d')::date as valid_end_date
    ,invalid_reason
from {{ref('concept_cpt4')}}
union all

select
    source_concept_id as concept_id
    ,source_code_description as concept_name
    ,'None' as domain_id
    ,source_vocabulary_id as vocabulary_id
    ,'None' as concept_class_id
    ,null as standard_concept
    ,source_code as concept_code
    ,valid_start_date
    ,valid_end_date
    ,invalid_reason
from {{ref('source_to_concept_map')}}