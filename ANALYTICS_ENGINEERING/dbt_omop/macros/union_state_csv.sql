{% macro union_state_csv(file_name) %}
{% set states = var('states') %}
{% for state in states %}
select
  *,
  '{{ state }}' as state,
  '{{ state }}' as tenant_id
from read_csv_auto(
  '{{ var("data_root") }}/{{ state }}/{{ file_name }}',
  header=true
)
{% if not loop.last %}
union all
{% endif %}
{% endfor %}
{% endmacro %}
