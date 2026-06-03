with source as (
    select * from {{ source('thelook', 'order_items') }}
)
select
    id          as order_item_id,
    order_id,
    user_id,
    product_id,
    sale_price,
    created_at  as item_created_at,
    status      as item_status
from source