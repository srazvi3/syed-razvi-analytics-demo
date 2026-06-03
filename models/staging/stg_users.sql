select
    id          as user_id,
    first_name,
    last_name,
    email,
    age,
    gender,
    country,
    traffic_source,
    created_at  as user_created_at
from {{ source('thelook', 'users') }}