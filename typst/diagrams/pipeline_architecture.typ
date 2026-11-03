// Diagrama Arquitectónico del Pipeline de Datos ELT y Flujo DataOps
// Compilado desde Mermaid (.mmd) a formato vectorial nativo (PDF) mediante Podman

#let diagram-pipeline-architecture = align(center)[
  #image("pipeline_architecture.pdf", width: 95%)
]

#let fig-pipeline-architecture = figure(
  diagram-pipeline-architecture,
  caption: [Arquitectura integral del flujo analítico de datos de MoviGo, ilustrando las etapas de ingesta transaccional desacoplada, modelado dimensional Kimball con dbt Core, almacenamiento analítico en DuckDB, optimización matemática e inferencia estadística, y reproducibilidad científica en Typst.],
)
