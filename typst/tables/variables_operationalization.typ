// typst/tables/variables_operationalization.typ: Matriz de Operacionalización de Variables
// Especificación metodológica formal para el estudio econométrico y espacial

#let table-variables-operationalization(size: 6.8pt) = {
  set text(size: size)
  table(
    columns: (2.0fr, 1.2fr, 2.5fr, 2.5fr, 1.1fr, 1.1fr),
    stroke: 0.4pt + rgb("#cbd5e1"),
    inset: (x: 4pt, y: 5pt),
    align: (col, row) => if row == 0 { center + horizon } else if col == 1 or col == 4 or col == 5 { center + horizon } else { left + horizon },
    fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else if calc.even(row) { rgb("#f8fafc") } else { none },
    table.header(
      [*Variable*], [*Rol*], [*Definición Conceptual*], [*Definición Operacional*], [*Escala*], [*Modelo dbt*]
    ),
    [
      *Trip Cancellation* \
      #text(size: 5.6pt, fill: rgb("#334155"))[`is_cancelled`]
    ],
    [Dependiente \ ($Y$)],
    [Decisión de abandonar o no consumar el servicio de transporte solicitado.],
    [Indicador booleano de desenlace del servicio ($1 = "cancelado"$, $0 = "completado"$).],
    [Binaria \ ($0, 1$)],
    [`fct_trips`],

    [
      *Surge Multiplier* \
      #text(size: 5.6pt, fill: rgb("#334155"))[`surge_multiplier`]
    ],
    [Independiente \ ($X_1$)],
    [Factor de recargo sobre el base fare determinado por desbalance de oferta y demanda.],
    [Multiplicador continuo en escala $[1.00, 3.20]times$ fijado al momento de solicitar el viaje.],
    [Continua \ (Razón)],
    [`fct_trips`],

    [
      *Trip Distance* \
      #text(size: 5.6pt, fill: rgb("#334155"))[`distance_km`]
    ],
    [Independiente \ ($X_2$)],
    [Longitud métrica vial del desplazamiento planificado entre origen y destino.],
    [Distancia en kilómetros ($"km"$) estimada mediante ruteo con factor de tortuosidad.],
    [Continua \ (Razón)],
    [`fct_trips`],

    [
      *Congestion Index* \
      #text(size: 5.6pt, fill: rgb("#334155"))[`congestion_index`]
    ],
    [Independiente \ ($X_3$)],
    [Nivel de saturación vehicular exógeno en la trama arterial metropolitana.],
    [Razón de demora sobre flujo libre en escala continua de $1.00$ (fluido) a $3.50$ (crítico).],
    [Continua \ (Razón)],
    [`dim_weather`],

    [
      *Peak Hour* \
      #text(size: 5.6pt, fill: rgb("#334155"))[`is_peak_hour`]
    ],
    [Control \ ($X_4$)],
    [Ventana horaria de máxima demanda laboral y escolar matutina y vespertina.],
    [Indicador binario ($1$ en 07:00--08:59 y 17:00--18:59; $0$ en horarios valle).],
    [Binaria \ ($0, 1$)],
    [`fct_trips`],

    [
      *Rain Condition* \
      #text(size: 5.6pt, fill: rgb("#334155"))[`has_rain`]
    ],
    [Control \ ($X_5$)],
    [Ocurrencia de precipitaciones con potencial de anegamiento en la red vial.],
    [Indicador diario ($1$ si precipitación acumulada $> 0.1 "mm"$, $0$ si jornada seca).],
    [Binaria \ ($0, 1$)],
    [`dim_weather`],

    [
      *Socioeconomic Stratum* \
      #text(size: 5.6pt, fill: rgb("#334155"))[`stratum`]
    ],
    [Segmentación \ ($Z$)],
    [Nivel socioeconómico territorial del cuadrante urbano de partida del viaje.],
    [Clasificación ordinal en 4 estratos (1: Popular, 2: Medio, 3: Comercial, 4: Alto).],
    [Ordinal \ (1 a 4)],
    [`dim_zones`],
  )
}

#let fig-variables-operationalization = figure(
  table-variables-operationalization(),
  caption: [Matriz metodológica de operacionalización de variables de la investigación],
)
