{% test valid_concept_in_domain(model, column_name, domain_id, _condition=None) %}

-- Is the concept_id valid, and does it have the correct domain?

with concepts as (
    select distinct concept_id
    from {{ ref('concept') }}
    where domain_id = '{{ domain_id }}'
),

concept_ids as (
    select
        {{ column_name }} as concept_id
    from {{ model }}
    where 1=1
    {% if _condition %}
        and {{ _condition }}
    {% else %}
        and {{ column_name }} is not null
        and {{ column_name }} != 0
    {% endif %}
)

select
    concept_id
from concept_ids
where concept_id not in (select concept_id from concepts)

{% endtest %}