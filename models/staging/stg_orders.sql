with source as (
    select * from {{ source('thelook', 'orders') }}
)
select
    order_id,
    user_id,
    status,
    gender,
    created_at,
    shipped_at,
    delivered_at,
    returned_at,
    num_of_item
from source