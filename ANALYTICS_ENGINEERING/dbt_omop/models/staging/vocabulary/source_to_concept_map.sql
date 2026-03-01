with base as (
    {{ read_seed_csv('source_to_concept_map_seed.csv',delim=',') }}
)
select
    source_code
    , hash(concat(source_code, source_vocabulary_id, source_code_description)) as source_concept_id
    , source_vocabulary_id
    , source_code_description
    , target_concept_id
    , target_vocabulary_id
    , valid_start_date
    , valid_end_date
    , invalid_reason
from base