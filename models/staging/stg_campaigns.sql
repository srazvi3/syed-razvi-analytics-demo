select
    campaign_id,
    campaign_name,
    channel,
    cast(start_date as date) as start_date,
    cast(end_date   as date) as end_date,
    daily_budget_usd,
    target_country
from {{ source('raw', 'marketing_campaigns') }}