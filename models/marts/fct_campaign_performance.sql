with spend as (
    select
        campaign_id,
        spend_date,
        sum(impressions) as impressions,
        sum(clicks)      as clicks,
        sum(spend_usd)   as spend_usd
    from {{ ref('stg_campaign_spend') }}
    group by 1, 2
),
campaigns as (
    select * from {{ ref('stg_campaigns') }}
),
-- naive attribution: orders on the same day in the same target_country as the campaign
orders_by_country_day as (
    select
        date(o.created_at) as order_date,
        u.country,
        count(distinct o.order_id) as orders,
        sum(o.gross_revenue)       as revenue
    from {{ ref('fct_orders') }} o
    join {{ ref('dim_users') }} u on o.user_id = u.user_id
    where o.status not in ('Cancelled')
    group by 1, 2
)
select
    s.campaign_id,
    c.campaign_name,
    c.channel,
    c.target_country,
    s.spend_date,
    s.impressions,
    s.clicks,
    s.spend_usd,
    coalesce(ob.orders, 0)   as attributed_orders,
    coalesce(ob.revenue, 0)  as attributed_revenue,
    safe_divide(s.clicks, s.impressions)            as ctr,
    safe_divide(s.spend_usd, nullif(s.clicks, 0))   as cpc,
    safe_divide(ob.revenue, nullif(s.spend_usd, 0)) as roas
from spend s
join campaigns c
    on s.campaign_id = c.campaign_id
left join orders_by_country_day ob
    on ob.order_date = s.spend_date
   and ob.country    = c.target_country