#import "template.typ": *
#import "components.typ": *

= Arquitectura integral del pipeline de datos y DataOps

#speaker-marker("B")

#v(2pt)

// 1. NIVEL SUPERIOR: Banda Panorámica Destacada del Flujo de Integración (Mayor protagonismo)
#block(
  width: 100%,
  height: 220pt,
  fill: white,
  stroke: 1pt + color-card-stroke,
  radius: 8pt,
  inset: (x: 10pt, y: 8pt),
  align(center + horizon, image("../diagrams/pipeline_architecture.pdf", width: 100%, height: 98%, fit: "contain"))
)

#v(10pt)

// 2. NIVEL INFERIOR: Tres Columnas Sintéticas de Infraestructura (Contenido condensado)
#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 12pt,
  // Columna 1: Extracción API REST y Buffer Apache Parquet
  block(
    width: 100%,
    height: 110pt,
    fill: color-card-bg,
    stroke: (top: 3.5pt + rgb("#2563eb"), rest: 0.8pt + color-card-stroke),
    radius: 6pt,
    inset: (x: 12pt, y: 9pt),
    [
      #text(size: 11pt, weight: "bold", fill: rgb("#1e3a8a"), font: font-heading)[I. Ingesta Asíncrona & Buffer]
      #v(2pt)
      #text(size: 8pt, fill: color-muted, font: font-heading)[EXTRACCIÓN REST & APACHE PARQUET]
      #v(5pt)
      #text(size: 9.3pt, fill: color-body, font: font-body)[
        • *Extracción por cursor:* Consumo sistemático de los 7 endpoints en FastAPI (`limit=200`).\
        • *Buffer Parquet:* Almacén columnar inmutable en disco con compresión Snappy y tolerancia a fallos.
      ]
    ]
  ),
  // Columna 2: Persistencia Relacional OLTP en Azure PostgreSQL
  block(
    width: 100%,
    height: 110pt,
    fill: color-card-bg,
    stroke: (top: 3.5pt + rgb("#144e45"), rest: 0.8pt + color-card-stroke),
    radius: 6pt,
    inset: (x: 12pt, y: 9pt),
    [
      #text(size: 11pt, weight: "bold", fill: rgb("#144e45"), font: font-heading)[II. Persistencia Relacional OLTP]
      #v(2pt)
      #text(size: 8pt, fill: color-muted, font: font-heading)[ESQUEMA RAW 3NF EN AZURE POSTGRESQL]
      #v(5pt)
      #text(size: 9.3pt, fill: color-body, font: font-body)[
        • *Esquema 3NF estricto:* 7 tablas relacionales tipadas para transacciones, actores y telemetría.\
        • *Carga masiva por bloques:* Inserción vectorizada por lotes con cifrado seguro TLS/SSL.
      ]
    ]
  ),
  // Columna 3: Motor Analítico Vectorizado DuckDB & DataOps
  block(
    width: 100%,
    height: 110pt,
    fill: color-card-bg,
    stroke: (top: 3.5pt + rgb("#059669"), rest: 0.8pt + color-card-stroke),
    radius: 6pt,
    inset: (x: 12pt, y: 9pt),
    [
      #text(size: 11pt, weight: "bold", fill: rgb("#064e3b"), font: font-heading)[III. Motor OLAP & DataOps]
      #v(2pt)
      #text(size: 8pt, fill: color-muted, font: font-heading)[DUCKDB IN-PROCESS & COMPILACIÓN ZERO-DRIFT]
      #v(5pt)
      #text(size: 9.3pt, fill: color-body, font: font-body)[
        • *DuckDB in-process:* Consultas analíticas vectorizadas de ultra baja latencia sobre Parquet.\
        • *Flujo Zero-Drift:* Enlace directo y reproducible a Typst orquestado mediante Podman.
      ]
    ]
  )
)
