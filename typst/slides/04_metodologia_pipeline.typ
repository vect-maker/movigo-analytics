#import "template.typ": *
#import "components.typ": *

= Arquitectura integral del pipeline de datos y DataOps

#speaker-marker("B")

#v(2pt)

// 1. NIVEL SUPERIOR: Banda Horizontal Panorámica del Flujo de Integración
#block(
  width: 100%,
  height: 126pt,
  fill: white,
  stroke: 1pt + color-card-stroke,
  radius: 8pt,
  inset: (x: 10pt, y: 6pt),
  align(center + horizon, image("../diagrams/pipeline_architecture.pdf", width: 99%, height: 98%, fit: "contain"))
)

#v(10pt)

// 2. NIVEL INFERIOR: Tres Columnas Arquitectónicas de Profundidad Técnica
#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 12pt,
  // Columna 1: Ingesta y Persistencia Raw
  block(
    width: 100%,
    height: 215pt,
    fill: color-card-bg,
    stroke: (top: 3.5pt + rgb("#2563eb"), rest: 0.8pt + color-card-stroke),
    radius: 6pt,
    inset: (x: 14pt, y: 12pt),
    [
      #text(size: 11pt, weight: "bold", fill: rgb("#1e3a8a"), font: font-heading)[I. Ingesta y Datos Raw]
      #v(2pt)
      #text(size: 8.5pt, fill: color-muted, font: font-heading)[EXTRACCIÓN REST & AZURE POSTGRESQL]
      #v(6pt)
      #text(size: 9.2pt, fill: color-body, font: font-body)[
        • *Extracción por cursor:* Consumo sistemático de la API REST FastAPI con paginación dinámica (`limit=200`, `offset`).\
        • *Buffer Apache Parquet:* Serialización intermedia columnar garantizando inmutabilidad, compresión y desacoplamiento.\
        • *Azure PostgreSQL (OLTP):* Esquema `raw` (3NF) con 7 tablas normalizadas, casteo de tipos e inserción por bloques con TLS.
      ]
    ]
  ),
  // Columna 2: Transformación dbt Core Kimball
  block(
    width: 100%,
    height: 215pt,
    fill: color-card-bg,
    stroke: (top: 3.5pt + rgb("#d97706"), rest: 0.8pt + color-card-stroke),
    radius: 6pt,
    inset: (x: 14pt, y: 12pt),
    [
      #text(size: 11pt, weight: "bold", fill: rgb("#78350f"), font: font-heading)[II. Transformación dbt Core]
      #v(2pt)
      #text(size: 8.5pt, fill: color-muted, font: font-heading)[STAGING 1:1 & KIMBALL STAR SCHEMA]
      #v(6pt)
      #text(size: 9.2pt, fill: color-body, font: font-body)[
        • *Staging lógicas:* Vistas 1:1 puras con tipado estricto, binarización de fallos y descarte de dependencias cruzadas.\
        • *Esquema en estrella Kimball:* Fact table atómica `fct_trips` consolidando 77,487 viajes auditados con llaves subrogadas MD5.\
        • *Conformed Dimensions:* Dimensiones de zonificación WGS84, severidad pluvial diaria y segmentación socioeconómica.
      ]
    ]
  ),
  // Columna 3: Motor Analítico y DataOps
  block(
    width: 100%,
    height: 215pt,
    fill: color-card-bg,
    stroke: (top: 3.5pt + rgb("#059669"), rest: 0.8pt + color-card-stroke),
    radius: 6pt,
    inset: (x: 14pt, y: 12pt),
    [
      #text(size: 11pt, weight: "bold", fill: rgb("#064e3b"), font: font-heading)[III. Motor DuckDB & DataOps]
      #v(2pt)
      #text(size: 8.5pt, fill: color-muted, font: font-heading)[COMPUTACIÓN OLAP & REPRODUCIBILIDAD]
      #v(6pt)
      #text(size: 9.2pt, fill: color-body, font: font-body)[
        • *DuckDB In-Process:* Motor columnar analítico de ultra baja latencia con consultas OLAP vectorizadas sobre Parquet.\
        • *Validación continua DataOps:* Pruebas automáticas de unicidad, no-nulidad e integridad referencial (`dbt test` y `pytest`).\
        • *Compilación Zero-Drift:* Enlace directo de métricas y coeficientes a Typst sin transcripción manual ni deriva de datos.
      ]
    ]
  )
)
