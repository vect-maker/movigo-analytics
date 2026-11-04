with source as (
    select * from {{ source('raw', 'quadrant_weather') }}
)

select
    weather_id,
    quadrant_id,
    recorded_at,
    date as weather_date,
    hour as weather_hour,
    precipitation_mm,
    channel_runoff_mm,
    case
        when channel_runoff_mm < 5.0 then 'bajo'
        when channel_runoff_mm < 15.0 then 'medio'
        else 'critico'
    end as channel_runoff_risk,
    case
        when precipitation_mm = 0 then 'sin lluvia'
        when precipitation_mm < 10 then 'ligera'
        when precipitation_mm < 30 then 'moderada'
        else 'fuerte'
    end as rain_intensity,
    case
        when precipitation_mm = 0 then 'sin lluvia'
        when precipitation_mm < 10 then 'ligera'
        when precipitation_mm < 30 then 'moderada'
        else 'fuerte'
    end as precipitation_category,
    case when precipitation_mm > 0 then true else false end as has_rain,
    temperature_c,
    congestion_index,
    case
        when congestion_index < 1.30 then 'baja'
        when congestion_index < 1.70 then 'moderada'
        when congestion_index < 2.20 then 'alta'
        else 'critica'
    end as congestion_level,
    flooded_roads,
    has_flooded_roads,
    sky_condition
from (
    select
        *,
        flooded_roads as has_flooded_roads
    from source
)
