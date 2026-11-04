#import "template.typ": *
#import "components.typ": *
#import "../data_bindings.typ": (
  total-trips-fmt, dbt-total-tests, dbt-coverage-pct, fmt-dec,
)

= Linaje de transformación modular y esquema Kimball en dbt Core

#speaker-marker("B")

#v(2pt)

#grid(
  columns: (1.35fr, 1fr),
  gutter: 14pt,
  [
    // Hero Diagram Card - Maximizando altura, visibilidad y legibilidad
    #block(
      width: 100%,
      height: 355pt,
      fill: white,
      stroke: 1pt + color-card-stroke,
      radius: 8pt,
      inset: (x: 8pt, y: 6pt),
      align(center + horizon, image("../diagrams/dbt_lineage.pdf", width: 99%, height: 99%, fit: "contain"))
    )
  ],
  [
    // Columna explicativa estructurada en 3 capas dimensionales
    #grid(
      rows: (1fr, 1fr, 1fr),
      gutter: 10pt,
      // Capa I: Raw
      block(
        width: 100%,
        fill: color-card-bg,
        stroke: (left: 3.5pt + rgb("#2563eb"), rest: 0.8pt + color-card-stroke),
        radius: 6pt,
        inset: (x: 12pt, y: 9pt),
        [
          #text(size: 11pt, weight: "bold", fill: rgb("#1e3a8a"), font: font-heading)[I. Ingesta Raw (PostgreSQL)]
          #v(3pt)
          #text(size: 9.3pt, fill: color-body, font: font-body)[
            • *Esquema 3NF inmutable:* #total-trips-fmt solicitudes operacionales persistidas sin mutación destructiva.\
            • *Multi-dominio:* Separación estricta de viajes, tarifas, telemetría y meteorología.
          ]
        ]
      ),
      // Capa II: Staging
      block(
        width: 100%,
        fill: color-card-bg,
        stroke: (left: 3.5pt + rgb("#d97706"), rest: 0.8pt + color-card-stroke),
        radius: 6pt,
        inset: (x: 12pt, y: 9pt),
        [
          #text(size: 11pt, weight: "bold", fill: rgb("#78350f"), font: font-heading)[II. Staging dbt Core (Vistas 1:1)]
          #v(3pt)
          #text(size: 9.3pt, fill: color-body, font: font-body)[
            • *Tipado estricto:* Normalización semántica de nombres, fechas ISO y binarización de fallos (`is_cancelled`).\
            • *Malla espacial WGS84:* 24 zonas, 298 cuadrantes e intercepción de cauces pluviales.
          ]
        ]
      ),
      // Capa III: Marts
      block(
        width: 100%,
        fill: color-card-bg,
        stroke: (left: 3.5pt + rgb("#059669"), rest: 0.8pt + color-card-stroke),
        radius: 6pt,
        inset: (x: 12pt, y: 9pt),
        [
          #text(size: 11pt, weight: "bold", fill: rgb("#064e3b"), font: font-heading)[III. Marts Dimensional & Pruebas]
          #v(3pt)
          #text(size: 9.3pt, fill: color-body, font: font-body)[
            • *Kimball Star Schema:* Fact table `fct_trips` a grano atómico con surrogate keys MD5 y conformed dims.\
            • *Gobernanza dbt:* #fmt-dec(dbt-coverage-pct, digits: 0)% de cobertura con #str(dbt-total-tests) pruebas automáticas de unicidad y FKs.
          ]
        ]
      )
    )
  ]
)
