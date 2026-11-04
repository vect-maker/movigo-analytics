with trips as (
    select * from {{ ref('stg_trips') }}
),
quadrants as (
    select * from {{ ref('stg_quadrants') }}
),
payments as (
    select * from {{ ref('stg_trip_payments') }}
),
cancellations as (
    select * from {{ ref('stg_trip_cancellations') }}
),
ratings as (
    select * from {{ ref('stg_trip_ratings') }}
),
weather_quadrant as (
    select * from {{ ref('stg_quadrant_weather') }}
),
vehicles as (
    select * from {{ ref('stg_vehicles') }}
)

select
    -- Surrogate primary key
    md5(cast(t.trip_id as text)) as sk_trip,
    t.trip_id,

    -- Conformed surrogate foreign keys
    md5(cast(qo.zone_id as text)) as sk_zone_origin,
    md5(cast(qd.zone_id as text)) as sk_zone_destination,
    case 
        when t.driver_id is not null then md5(cast(t.driver_id as text)) 
        else null 
    end as sk_driver,
    md5(cast(t.user_id as text)) as sk_user,
    md5(cast(t.request_date as text)) as sk_weather,

    -- Spatial quadrants, districts, and GPS coordinates
    t.origin_quadrant_id,
    qo.district as origin_district,
    t.destination_quadrant_id,
    qd.district as destination_district,
    t.origin_latitude,
    t.origin_longitude,
    t.destination_latitude,
    t.destination_longitude,

    -- Temporal components
    t.request_date,
    t.request_hour,
    t.iso_day_of_week,
    t.is_weekend,
    t.is_peak_hour,
    t.requested_at,
    t.started_at,
    t.completed_at,

    -- Financial and dynamic pricing metrics
    p.base_fare,
    p.surge_multiplier,
    p.has_surge,
    p.final_fare,
    p.surge_cost_nio,
    p.tip_amount,
    p.payment_method,
    p.payment_status,

    -- Service outcome and cancellation metrics
    t.trip_status,
    t.is_cancelled,
    t.is_cancelled_by_user,
    t.is_cancelled_by_driver,
    t.is_completed,
    c.cancellation_reason,
    c.cancelled_by,
    c.origin_active_requests,
    c.origin_available_drivers,

    -- Basic operational metrics
    t.distance_km,
    t.duration_minutes,
    coalesce(
        c.wait_time_minutes,
        case 
            when t.started_at is not null 
            then round(extract(epoch from (t.started_at - t.requested_at)) / 60.0, 2) 
            else null 
        end
    ) as wait_time_minutes,

    -- Service quality ratings
    r.user_rating,
    r.driver_rating,

    -- Origin microclimate and localized congestion (quadrant and hour)
    wq.congestion_index as origin_congestion_index,
    wq.precipitation_mm as origin_precipitation_mm,
    wq.channel_runoff_mm as origin_channel_runoff_mm,
    wq.flooded_roads as origin_flooded_roads,
    wq.sky_condition as origin_sky_condition,
    wq.temperature_c as origin_temperature_c,

    -- Derived operational and physical metrics
    case 
        when t.duration_minutes > 0 
        then round((t.distance_km / (t.duration_minutes / 60.0))::numeric, 2)
        else null 
    end as effective_speed_kmh,
    case 
        when v.fuel_efficiency_km_l is not null and v.fuel_efficiency_km_l > 0 
        then round((t.distance_km / v.fuel_efficiency_km_l)::numeric, 2)
        else null 
    end as estimated_fuel_liters
from trips t
left join quadrants qo on t.origin_quadrant_id = qo.quadrant_id
left join quadrants qd on t.destination_quadrant_id = qd.quadrant_id
left join payments p on t.trip_id = p.trip_id
left join cancellations c on t.trip_id = c.trip_id
left join ratings r on t.trip_id = r.trip_id
left join weather_quadrant wq on t.origin_quadrant_id = wq.quadrant_id 
                             and t.request_date = wq.weather_date 
                             and t.request_hour = wq.weather_hour
left join vehicles v on t.driver_id = v.driver_id
