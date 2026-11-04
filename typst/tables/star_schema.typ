// Especificación Arquitectónica del Esquema en Estrella (Star Schema)
// Componente de tabla reutilizable para el paper, presentaciones y anexos técnicos

#import "../data_bindings.typ": (
  total-trips-fmt,
  total-zones,
  total-weather-days,
  total-campaigns,
)

#let table-star-schema(size: 7.6pt, raw-size: 6.8pt) = {
  set text(size: size)
  show raw.where(block: false): it => box(
    fill: rgb("#f1f5f9"),
    radius: 1.5pt,
    inset: (x: 1.8pt, y: 0pt),
    baseline: 0%,
    text(font: ("Liberation Mono", "DejaVu Sans Mono"), size: raw-size, it.text)
  )
  table(
    columns: (1.35fr, 1.15fr, 1.15fr, 1.35fr, 2.5fr),
    stroke: 0.4pt + rgb("#cbd5e1"),
    inset: (x: 4pt, y: 3.5pt),
    align: (col, row) => if row == 0 { center + horizon } else { left + horizon },
    fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else if calc.even(row) { rgb("#f8fafc") } else { none },
    table.header(
      [*Modelo (dbt)*], [*Rol Dimensional*], [*Surrogate Key (PK)*], [*Relaciones (FK)*], [*Grain y Métricas / Atributos Clave*]
    ),
    [`fct_trips`],
    [Fact Table (Atómica)],
    [`sk_trip` \ #text(size: raw-size, fill: rgb("#64748b"))[(Hash MD5)]],
    [
      #stack(
        spacing: 1.5pt,
        [`sk_zone_origin`],
        [`sk_zone_destination`],
        [`sk_weather`, `sk_user`],
        [`sk_driver`]
      )
    ],
    [1 fila por solicitud ($N = #total-trips-fmt$). Surge multiplier, base fare, tarifa final, recargo surge, wait time, bandera booleana de cancelación (`is_cancelled`).],

    [`dim_zones`],
    [Conformed Dimension],
    [`sk_zone` \ #text(size: raw-size, fill: rgb("#64748b"))[(Hash MD5)]],
    [Origen y Destino \ #text(size: raw-size, fill: rgb("#64748b"))[(`fct_trips`)]],
    [#total-zones zonas urbanas de Managua. Estrato socioeconómico, nivel ordinal (1--4), distrito, coordenadas centroides, radio de cobertura, base fare zonal.],

    [`dim_quadrants`],
    [Territorial Dimension],
    [`sk_quadrant` \ #text(size: raw-size, fill: rgb("#64748b"))[(Hash MD5)]],
    [`sk_zone` \ #text(size: raw-size, fill: rgb("#64748b"))[(`dim_zones`)]],
    [298 cuadrantes geográficos. Cuadrícula espacial, límites lat/lon, cota altimétrica, clasificación de riesgo pluvial y cauces principales.],

    [`dim_weather`],
    [Conformed Dimension],
    [`sk_weather` \ #text(size: raw-size, fill: rgb("#64748b"))[(Hash MD5)]],
    [`sk_weather` \ #text(size: raw-size, fill: rgb("#64748b"))[(`fct_trips`)]],
    [#total-weather-days días del ciclo 2024. Precipitación (mm), temperatura (°C), índice y nivel de congestión vial, condición de cielo, indicador de lluvia, estacionalidad y riesgo de escorrentía.],

    [`dim_users`],
    [Conformed Dimension],
    [`sk_user` \ #text(size: raw-size, fill: rgb("#64748b"))[(Hash MD5)]],
    [`sk_user` \ #text(size: raw-size, fill: rgb("#64748b"))[(`fct_trips`)]],
    [Pasajeros registrados. Preferencia de pago (efectivo vs digital), calificación histórica promedio, segmento de reputación y antigüedad.],

    [`dim_drivers`],
    [Conformed Dimension],
    [`sk_driver` \ #text(size: raw-size, fill: rgb("#64748b"))[(Hash MD5)]],
    [`sk_driver` \ #text(size: raw-size, fill: rgb("#64748b"))[(`fct_trips`)]],
    [Socios de la flota. Modalidad vehicular, modelo, año, tasa de aceptación, servicios acumulados de mantenimiento, costo de taller y horas de inactividad.],

    [`dim_campaigns`],
    [Context Dimension],
    [`sk_campaign` \ #text(size: raw-size, fill: rgb("#64748b"))[(Hash MD5)]],
    [Análisis de Oferta \ #text(size: raw-size, fill: rgb("#64748b"))[Incentivos y Cobertura]],
    [#total-campaigns programas de bonos. Costo presupuestario en córdobas (NIO), incremento en horas de conexión proyectadas y zona urbana objetivo.]
  )
}

// Figura enumerada completa con título y formato formal
#let fig-star-schema-table = figure(
  table-star-schema(),
  caption: [Especificación arquitectónica del Star Schema dimensional implementado en dbt Core],
)
