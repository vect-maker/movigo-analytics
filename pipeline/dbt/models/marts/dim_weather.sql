with source as (
    select * from {{ ref('stg_weather') }}
)

select
    -- Surrogate primary key
    md5(cast(weather_id as text)) as sk_weather,
    weather_id,

    -- Dimensional spatial foreign key
    md5(cast(quadrant_id as text)) as sk_quadrant,
    quadrant_id,

    -- Temporal attributes
    recorded_at,
    date,
    hour,

    -- Weather metrics and classifications
    precipitation_mm,
    channel_runoff_mm,
    channel_runoff_risk,
    rain_intensity,
    precipitation_category,
    has_rain,
    temperature_c,
    congestion_index,
    congestion_level,
    flooded_roads,
    has_flooded_roads,
    sky_condition,

    -- Seasonal and calendar temporal features
    case 
        when extract(month from date) between 5 and 10 then 'rainy'
        else 'dry'
    end as season,
    extract(month from date)::int as month,
    extract(quarter from date)::int as quarter,
    extract(isodow from date)::int as iso_day_of_week,
    case when extract(isodow from date) in (6, 7) then true else false end as is_weekend
from source
order by weather_id
