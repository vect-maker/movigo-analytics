#import "template.typ": *
#import "components.typ": *
#import "../data_bindings.typ": (
  total-trips-fmt, dbt-coverage-pct, routing-nodes, fmt-dec,
  storm-cancellation-rate, storm-driver-cancel-rate, high-surge-cancellation-rate,
)

= Conclusiones de la investigación

#speaker-marker("A")

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 12pt,
  conclusion-card(
    number: "01",
    tag: [PIPELINE ELT],
    title: [Gobernanza y Datos],
    icon: slide-icons.database,
    stat-main: [#total-trips-fmt],
    stat-label: [Viajes procesados en 2024],
    stat-sub: [#fmt-dec(dbt-coverage-pct, digits: 0)%],
    stat-sub-label: [Cobertura pruebas dbt],
    verdict-headline: [Arquitectura auditable y sin fugas],
    verdict-body: [La modernización con dbt Core y DuckDB garantiza integridad referencial absoluta (cero llaves huérfanas) y formalización Kimball reproducible.],
    accent: color-primary,
  ),
  conclusion-card(
    number: "02",
    tag: [DINÁMICA OPERATIVA],
    title: [Fricción y Sensibilidad],
    icon: slide-icons.dollar-sign,
    stat-main: [#fmt-dec(storm-cancellation-rate, digits: 1)%],
    stat-label: [Cancelación en tormenta],
    stat-sub: [>1.85x],
    stat-sub-label: [Umbral crítico de surge],
    verdict-headline: [Fricción dual oferta-demanda],
    verdict-body: [En tormenta, el #fmt-dec(storm-driver-cancel-rate, digits: 1)% de cancelaciones provienen de conductores que evitan cauces, mientras que multiplicadores sobre 1.85x disparan el rechazo de usuarios (#fmt-dec(high-surge-cancellation-rate, digits: 1)%).],
    accent: color-coral,
  ),
  conclusion-card(
    number: "03",
    tag: [REDES ESPACIALES],
    title: [Resiliencia Algorítmica],
    icon: slide-icons.navigation,
    stat-main: [#routing-nodes],
    stat-label: [Nodos viales modelados],
    stat-sub: [-60.0%],
    stat-sub-label: [Tiempo vs. cruce anegado],
    verdict-headline: [Evasión de cuellos de botella],
    verdict-body: [Inyectar penalizaciones climáticas en matrices dispersas permite a Dijkstra desviar activamente la flota, ahorrando hasta 24.6 min en ejes críticos.],
    accent: color-accent,
  ),
)
