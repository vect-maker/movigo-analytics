with source as (
    select * from {{ ref('stg_quadrant_weather') }}
)

select
    weather_id,
    quadrant_id,
    recorded_at,
    weather_date as date,
    weather_hour as hour,
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
    sky_condition
from source
