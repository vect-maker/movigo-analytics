#import "template.typ": *
#import "components.typ": *

= Conclusiones de la investigación

#speaker-marker("D")

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 12pt,
  conclusion-card(
    number: "01",
    tag: [PIPELINE ELT],
    title: [Gobernanza y Datos],
    icon: slide-icons.database,
    stat-main: [100k],
    stat-label: [Viajes procesados],
    stat-sub: [100%],
    stat-sub-label: [Linaje dbt Core],
    verdict-headline: [Arquitectura escalable y robusta],
    verdict-body: [La modernización del stack ELT con dbt Core y DuckDB garantiza la integridad semántica y matemática del modelo Kimball, asegurando reproducibilidad total de los análisis.],
    accent: color-primary,
  ),
  conclusion-card(
    number: "02",
    tag: [TARIFA DINÁMICA],
    title: [Sensibilidad y Fricción],
    icon: slide-icons.dollar-sign,
    stat-main: [38.4%],
    stat-label: [Cancelación en tormenta],
    stat-sub: [1.85x],
    stat-sub-label: [Multiplicador crítico],
    verdict-headline: [Límite de disposición a pagar],
    verdict-body: [El multiplicador elevado no resuelve la escasez bajo tormenta: los conductores temen daños por inundación y los usuarios cancelan al percibir tarifas desmedidas.],
    accent: color-coral,
  ),
  conclusion-card(
    number: "03",
    tag: [REDES ESPACIALES],
    title: [Resiliencia Algorítmica],
    icon: slide-icons.navigation,
    stat-main: [69,695],
    stat-label: [Nodos viales analizados],
    stat-sub: [2.5x],
    stat-sub-label: [Factor barrera pluvial],
    verdict-headline: [Evasión de puntos críticos],
    verdict-body: [La incorporación de impedancia meteorológica en matrices dispersas permite a Dijkstra esquivar cauces desbordados, reduciendo cancelaciones operativas y tiempos muertos.],
    accent: color-accent,
  ),
)
