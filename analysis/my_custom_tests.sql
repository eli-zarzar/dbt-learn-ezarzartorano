-- you need to find the thing you don't want
-- fail if amount is less than the average of the last 2

-- this code should be moved to the tests folders if we want it to run with dbt tests

/* you can also call this as a macro instead of having it as a test only:
{# {{ better_than_before (
    model = ref('orders'),
    date_or_ts_column = 'order_date',
    column_name = 'amount'
) }} #} */

with orders as (

    select * from {{ ref('orders') }}

),

order_days as (

    select

        order_date,
        sum(amount) as daily_total

    from orders
    group by 1

),

previous_three as (

    select *,

        avg(daily_total) over(
            order by order_date
            rows between 4 preceding and 1 preceding
        ) as previous_3_order_amount_avg

    from order_days

)

select * from previous_three
where daily_total < previous_3_order_amount_avg