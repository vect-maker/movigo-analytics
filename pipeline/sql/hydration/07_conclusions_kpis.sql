-- 07_conclusions_kpis.sql: Metricas empiricas de resiliencia y friccion para conclusiones
SELECT 
    COUNT(*) AS total_viajes,
    ROUND(COUNT(CASE WHEN is_cancelled THEN 1 END) * 100.0 / COUNT(*), 2) AS tasa_cancelacion_global_pct,
    
    -- Metricas de Tormenta
    COUNT(CASE WHEN origin_sky_condition = 'tormenta' THEN 1 END) AS viajes_tormenta,
    COUNT(CASE WHEN origin_sky_condition = 'tormenta' AND is_cancelled THEN 1 END) AS cancelaciones_tormenta,
    ROUND(COUNT(CASE WHEN origin_sky_condition = 'tormenta' AND is_cancelled THEN 1 END) * 100.0 / 
          NULLIF(COUNT(CASE WHEN origin_sky_condition = 'tormenta' THEN 1 END), 0), 2) AS tasa_cancelacion_tormenta_pct,
    ROUND(COUNT(CASE WHEN origin_sky_condition = 'tormenta' AND is_cancelled_by_driver THEN 1 END) * 100.0 / 
          NULLIF(COUNT(CASE WHEN origin_sky_condition = 'tormenta' AND is_cancelled THEN 1 END), 0), 2) AS participacion_conductor_cancelaciones_tormenta_pct,
    ROUND(COUNT(CASE WHEN origin_sky_condition = 'tormenta' AND is_cancelled_by_driver THEN 1 END) * 100.0 / 
          NULLIF(COUNT(CASE WHEN origin_sky_condition = 'tormenta' THEN 1 END), 0), 2) AS cancelacion_conductor_sobre_total_tormenta_pct,
          
    -- Surge Critico (>= 1.85x)
    COUNT(CASE WHEN surge_multiplier >= 1.85 THEN 1 END) AS viajes_surge_critico,
    ROUND(COUNT(CASE WHEN surge_multiplier >= 1.85 AND is_cancelled THEN 1 END) * 100.0 / 
          NULLIF(COUNT(CASE WHEN surge_multiplier >= 1.85 THEN 1 END), 0), 2) AS tasa_cancelacion_surge_critico_pct,
          
    -- Inundacion Vial
    ROUND(COUNT(CASE WHEN origin_flooded_roads AND is_cancelled THEN 1 END) * 100.0 / 
          NULLIF(COUNT(CASE WHEN origin_flooded_roads THEN 1 END), 0), 2) AS tasa_cancelacion_inundacion_pct
FROM fct_trips
