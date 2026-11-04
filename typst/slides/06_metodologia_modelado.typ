#import "template.typ": *
#import "components.typ": *

= Modelación matemática, redes espaciales y reproducibilidad

#speaker-marker("B")

#v(2pt)

// Pipeline visual de modelación en 3 etapas
#grid(
  columns: (1fr, 24pt, 1fr, 24pt, 1fr),
  gutter: 8pt,
  align: horizon,
  pipeline-node(
    logo: slide-icons.activity,
    title: [Fase 2: Regresión SGD],
    subtitle: [Modelación de Tarifas y Tiempo],
    tag: [OPTIMIZACIÓN NUMÉRICA],
    accent: color-title,
    details: (
      [Descenso de Gradiente Estocástico (SGD)],
      [Loss: MSE $J(theta) = 1/(2m) sum (h_theta(x) - y)^2$],
      [Normalización Z-score de distancias],
    )
  ),
  flow-arrow,
  pipeline-node(
    logo: slide-icons.navigation,
    title: [Fase 3: Redes Espaciales],
    subtitle: [Grafo OSM e Impedancia Dinámica],
    tag: [DIJKSTRA VECTORIAL],
    accent: color-accent,
    details: (
      [69,695 nodos de intersección física],
      [Matriz dispersa CSR $69,695 times 69,695$],
      [Penalización por anegamiento de cauces],
    )
  ),
  flow-arrow,
  pipeline-node(
    logo: slide-icons.file-text,
    title: [Data-to-Document],
    subtitle: [Entorno Inmutable en Podman],
    tag: [REPRODUCIBILIDAD TOTAL],
    accent: color-slate-teal,
    details: (
      [Typst nativo para slides y paper],
      [Justfile automatizado de compilación],
      [Cero discrepancia código-documento],
    )
  ),
)

#v(12pt)

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 12pt,
  feature-card(
    icon: slide-icons.trending-up,
    title: [Inferencia Paramétrica],
    subtitle: [Tarificación de Base vs. Picos],
    accent: color-title,
    body: [
      #list(
        [*Gradiente determinista:* Convergencia analizada sobre el tiempo de viaje y la tarifa cobrada.],
        [*Elasticidad observable:* Cuantificación del costo marginal por kilómetro adicional.],
        [*Sensibilidad meteorológica:* Incremento sistemático de duración bajo precipitaciones.],
      )
    ]
  ),
  feature-card(
    icon: slide-icons.map-pin,
    title: [Ruteo Resiliente],
    subtitle: [Evasión de Cuellos de Botella],
    accent: color-accent,
    body: [
      #list(
        [*Impedancia pluvial:* Reducción de velocidad a 25% y factor de barrera 2.5 en cauces desbordados.],
        [*Resolución en milisegundos:* `scipy.sparse.csgraph.dijkstra` con vector de predecesores.],
        [*Ruta adaptativa:* Desvío automático alrededor de zonas críticas como el Cauce Oriental.],
      )
    ]
  ),
  feature-card(
    icon: slide-icons.check-circle,
    title: [Garantía Metodológica],
    subtitle: [Transparencia Algorítmica],
    accent: color-slate-teal,
    body: [
      #list(
        [*Desacoplamiento modular:* Separación entre almacenamiento, computación y visualización.],
        [*Contenedores Podman:* Ejecución sin conflictos de librerías en cualquier sistema.],
        [*Trazabilidad de linaje:* Gráficos y tablas generados directamente de la base de datos.],
      )
    ]
  )
)
