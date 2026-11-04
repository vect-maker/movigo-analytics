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

// 2. NIVEL INFERIOR: Tres Columnas de Infraestructura y Almacenamiento Físico
#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 12pt,
  // Columna 1: Extracción API REST y Buffer Apache Parquet
  block(
    width: 100%,
    height: 215pt,
    fill: color-card-bg,
    stroke: (top: 3.5pt + rgb("#2563eb"), rest: 0.8pt + color-card-stroke),
    radius: 6pt,
    inset: (x: 14pt, y: 12pt),
    [
      #text(size: 11pt, weight: "bold", fill: rgb("#1e3a8a"), font: font-heading)[I. Ingesta Asíncrona & Buffer]
      #v(2pt)
      #text(size: 8.5pt, fill: color-muted, font: font-heading)[EXTRACCIÓN REST & APACHE PARQUET]
      #v(6pt)
      #text(size: 9.2pt, fill: color-body, font: font-body)[
        • *Extracción por cursor:* Consumo sistemático de los 7 endpoints en FastAPI con paginación optimizada (`limit=200`, `offset`).\
        • *Buffer Apache Parquet:* Serialización intermedia columnar en disco que garantiza inmutabilidad, compresión Snappy y desacoplamiento.\
        • *Tolerancia a fallos:* Aislamiento de la API ante interrupciones de red sin reintentos destructivos ni pérdida de estado.
      ]
    ]
  ),
  // Columna 2: Persistencia Relacional OLTP en Azure PostgreSQL
  block(
    width: 100%,
    height: 215pt,
    fill: color-card-bg,
    stroke: (top: 3.5pt + rgb("#144e45"), rest: 0.8pt + color-card-stroke),
    radius: 6pt,
    inset: (x: 14pt, y: 12pt),
    [
      #text(size: 11pt, weight: "bold", fill: rgb("#144e45"), font: font-heading)[II. Persistencia Relacional OLTP]
      #v(2pt)
      #text(size: 8.5pt, fill: color-muted, font: font-heading)[ESQUEMA RAW 3NF EN AZURE POSTGRESQL]
      #v(6pt)
      #text(size: 9.2pt, fill: color-body, font: font-body)[
        • *Esquema 3NF normalizado:* 7 tablas relacionales tipadas que albergan transacciones, actores, flotas y telemetría.\
        • *Carga masiva por bloques:* Inserción vectorizada por lotes mediante conexiones seguras cifradas con TLS/SSL.\
        • *Integridad de entrada:* Llaves primarias seriales y restricciones de tipo que impiden anomalías previas a la analítica.
      ]
    ]
  ),
  // Columna 3: Motor Analítico Vectorizado DuckDB & DataOps
  block(
    width: 100%,
    height: 215pt,
    fill: color-card-bg,
    stroke: (top: 3.5pt + rgb("#059669"), rest: 0.8pt + color-card-stroke),
    radius: 6pt,
    inset: (x: 14pt, y: 12pt),
    [
      #text(size: 11pt, weight: "bold", fill: rgb("#064e3b"), font: font-heading)[III. Motor OLAP & DataOps]
      #v(2pt)
      #text(size: 8.5pt, fill: color-muted, font: font-heading)[DUCKDB IN-PROCESS & COMPILACIÓN ZERO-DRIFT]
      #v(6pt)
      #text(size: 9.2pt, fill: color-body, font: font-body)[
        • *DuckDB columnar:* Motor OLAP embebido de ultra baja latencia para consultas analíticas vectorizadas sobre Parquet.\
        • *Aislamiento en contenedores:* Ejecución determinista orquestada con Podman para garantizar paridad entre entornos.\
        • *Compilación Zero-Drift:* Enlace directo de métricas y coeficientes a Typst sin transcripción manual ni deriva de datos.
      ]
    ]
  )
)
