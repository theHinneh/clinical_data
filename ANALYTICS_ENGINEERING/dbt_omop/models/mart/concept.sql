select * from {{ref('int_concept')}}

{% if is_incremental() %}
where _loaded_date >= dateadd(day, -{{ var('lookback_days', 2) }}, current_date)
{% endif %}