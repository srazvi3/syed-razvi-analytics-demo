select
    campaign_id,
    cast(spend_date as date) as spend_date,
    impressions,
    clicks,
    spend_usd
from {{ source('raw', 'campaign_daily_spend') }}