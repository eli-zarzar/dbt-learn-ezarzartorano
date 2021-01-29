/* jinja documentation - templates gives you a table with all available loop values that can be used */

/* Using static payment methods: */
/* {% set payment_methods = ['credit_card','coupon','bank_transfer','gift_card'] %}*/

/* Updating payment method dynamically:  */
/*{% set get_payment_methods_sql %}

    select distinct payment_method from {{ ref('stg_payments') }}

{% endset %}

{% set results = run_query(get_payment_methods_sql) %}

{% if execute %}
    {% set payment_methods = results.columns['PAYMENT_METHOD'].values() %}
{% endif %}
/**/

/* Using macro */
/**/
{% set payment_methods = get_distinct_values('payment_method', ref('stg_payments')) %}
/**/

/* get_column_values already exists in dbt_utils!! dbt_utils.get_column_values */

with payments as (

    select * from {{ ref('stg_payments') }}

),

pivoted as (

    select 

        order_id,
    {%- for payment_method in payment_methods %}
        sum(case when payment_method = '{{ payment_method }}' then amount else 0 /*null*/ end) as {{ payment_method }}_amount
    {%- if not loop.last -%}, {%- endif -%}
        {% endfor %}

    from payments
    where status = 'success'
    group by 1

)

select * from pivoted