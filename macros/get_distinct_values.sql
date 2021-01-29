{% macro get_distinct_values(column_name, relation) %} /*relation = table_name*/ 

{% set get_payment_methods_sql %}

    select distinct {{ column_name }} from {{ relation }}

{% endset %}

{% set results = run_query(get_payment_methods_sql) %}

{% if execute %}
    {% set payment_methods = results.columns[0].values() %}
    {{ return(payment_methods) }}
{% endif %}

{% endmacro %}