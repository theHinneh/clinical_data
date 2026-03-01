{% macro read_seed_csv(file_name, delim='\t') %}
select *
from read_csv_auto(
  '{{ var("seed_root") }}/{{ file_name }}',
  header=true,
  delim='{{ delim }}'
)
{% endmacro %}
