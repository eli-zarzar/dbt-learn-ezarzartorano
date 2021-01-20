with stg_orders as (

    select * from {{ ref('stg_orders') }}

),

payments as (

    select * from {{ ref('stg_payments') }}
    /* where status = 'success' */

),

final as (

    select
        stg_orders.order_id,
        stg_orders.customer_id,
        payments.amount,
        payments.status

    from stg_orders
    left join payments on stg_orders.order_id = payments.order_id
    /* where payments.status = 'success' */

)

select * from final