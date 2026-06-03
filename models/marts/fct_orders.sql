with items as (
    select
        order_id,
        count(*)             as item_count,
        sum(sale_price)      as gross_revenue
    from {{ ref('stg_order_items') }}
    group by 1
),
orders as (
    select * from {{ ref('stg_orders') }}
)
select
    o.order_id,
    o.user_id,
    o.status,
    date(o.created_at)               as order_date,
    o.created_at,
    o.shipped_at,
    o.delivered_at,
    o.returned_at,
    coalesce(i.item_count, 0)        as item_count,
    coalesce(i.gross_revenue, 0)     as gross_revenue,
    case when o.returned_at is not null then 1 else 0 end as is_returned
from orders o
left join items i on o.order_id = i.order_id