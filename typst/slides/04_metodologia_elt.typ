#import "template.typ": *
#import "components.typ": *

= Pipeline de ingeniería de datos y modelo dimensional

#speaker-marker("B")

#align(center, block(
  fill: white,
  stroke: 1pt + color-card-stroke,
  radius: 8pt,
  inset: (x: 10pt, y: 6pt),
  image("../diagrams/dbt_lineage.pdf", width: 88%, height: 105pt)
))

#v(8pt)

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 12pt,
  feature-card(
    icon: slide-icons.database,
    title: [Extracción y Carga ELT],
    subtitle: [PostgreSQL a Parquet Crudo],
    accent: color-title,
    body: [
      #list(
        [*Ingesta desacoplada:* Extracción de 100,000 registros transaccionales desde Azure PostgreSQL.],
        [*Almacenamiento columnar:* Exportación en formato Parquet particionado de alta compresión.],
        [*Cero mutación previa:* Preservación íntegra de tipos y telemetría de conductores.],
      )
    ]
  ),
  feature-card(
    icon: slide-icons.layers,
    title: [Transformación dbt Core],
    subtitle: [Linaje y Pruebas Unitarias],
    accent: color-accent,
    body: [
      #list(
        [*Staging modular:* Tipado estricto, casteo de coordenadas WGS84 y normalización semántica.],
        [*Pruebas automatizadas:* Validación de unicidad de claves primarias y rangos de tarifas.],
        [*Idempotencia total:* Reconstrucción reproducible del warehouse mediante un único comando.],
      )
    ]
  ),
  feature-card(
    icon: slide-icons.grid,
    title: [Modelo Kimball],
    subtitle: [Esquema Estrella y DuckDB],
    accent: color-teal,
    body: [
      #list(
        [*Tabla de hechos:* `fct_trips` consolidando métricas de distancia, duración y multiplicador.],
        [*Dimensiones analíticas:* `dim_quadrants` con elevación y riesgo de inundación por cauces.],
        [*Consultas OLAP zero-copy:* DuckDB sobre Parquet para computación de matrices y ML.],
      )
    ]
  )
)
