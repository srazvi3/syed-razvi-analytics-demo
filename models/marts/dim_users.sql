select
    user_id,
    first_name,
    last_name,
    country,
    traffic_source,
    age,
    case
        when age < 25 then '18-24'
        when age < 35 then '25-34'
        when age < 45 then '35-44'
        when age < 55 then '45-54'
        else '55+'
    end as age_band,
    user_created_at
from {{ ref('stg_users') }}