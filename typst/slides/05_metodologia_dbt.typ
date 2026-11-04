#import "template.typ": *
#import "components.typ": *

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
            • *Esquema 3NF inmutable:* 100,000 registros transaccionales extraídos sin mutación previa.\
            • *Multi-dominio:* Desacoplamiento de viajes, pagos, telemetría y meteorología.
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
            • *Tipado estricto:* Normalización semántica en inglés y binarización de `is_cancelled`.\
            • *Espacial & Pluvial:* 24 zonas, 298 cuadrantes WGS84 y cota de riesgo por cauces.
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
          #text(size: 11pt, weight: "bold", fill: rgb("#064e3b"), font: font-heading)[III. Marts Dimensional (DuckDB)]
          #v(3pt)
          #text(size: 9.3pt, fill: color-body, font: font-body)[
            • *Kimball Star Schema:* Fact table `fct_trips` (77,487 viajes auditados) y conformed dims.\
            • *OLAP zero-copy:* Surrogate keys conformadas (MD5) para computación analítica.
          ]
        ]
      )
    )
  ]
)
