#import "template.typ": *
#import "components.typ": *

= Optimización de redes espaciales y ruteo adaptativo con Dijkstra

#slide-dual-chart(
  speaker: "C",
  accent-1: color-primary,
  icon-1: slide-icons.map,
  chart-fn-1: image("../graphs/urban_network_topology.png", height: 162pt),
  caption-1: [Figura: Topología de red vial urbana modelada en OpenStreetMap (69,695 nodos).],
  stat-1: [69,695 nodos y matriz CSR],
  body-1: [La infraestructura urbana de Managua se representó como un grafo dirigido de alta resolución en formato `scipy.sparse.csr_matrix`, asignando velocidades y jerarquías viales a cada segmento.],
  accent-2: color-accent,
  icon-2: slide-icons.shield,
  stat-2: [-21.4% tiempo en desvío],
  body-2: [Ante la activación de impedancia severa (caída al 25% de velocidad y factor de barrera 2.5) en el Cauce Oriental, Dijkstra reconfigura la ruta por vías perimetrales seguras evitando el colapso.],
  chart-fn-2: image("../graphs/urban_network_dijkstra.png", height: 162pt),
  caption-2: [Figura: Ruta óptima de Dijkstra recalculada evadiendo el segmento inundado.],
)
