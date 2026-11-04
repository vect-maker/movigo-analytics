// Diagrama de Linaje y Modelado Dimensional en dbt Core
// Compilado desde Mermaid (.mmd) a formato vectorial nativo (PDF) mediante Podman

#let diagram-dbt-lineage = align(center)[
  #image("dbt_lineage.pdf", width: 95%)
]

#let fig-dbt-lineage = figure(
  diagram-dbt-lineage,
  caption: [Linaje analítico y flujo de transformación dimensional en dbt Core, ilustrando la ingestión desde el esquema transaccional 3NF (Raw Layer), la normalización y tipado en vistas lógicas intermedias (Staging Layer) y la convergencia en el Esquema en Estrella (Marts Layer) compuesto por la tabla de hechos `fct_viajes` y sus dimensiones conformadas.],
)
