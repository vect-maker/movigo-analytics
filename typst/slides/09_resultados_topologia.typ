#import "template.typ": *
#import "components.typ": *

= Topología de la red vial urbana modelada en Managua

#slide-single-chart(
  speaker: "D",
  accent: color-primary,
  icon: slide-icons.map,
  chart: image("../graphs/urban_network_topology.png", height: 310pt, fit: "contain"),
  caption: [Figura: Topología de la red vial urbana de Managua extraída de OpenStreetMap (69,695 nodos).],
  stat: [69,695 nodos y matriz CSR],
  body: [
    La infraestructura vial de Managua fue modelada como un grafo dirigido de alta resolución espacial. Se optimizó computacionalmente mediante matrices dispersas en formato `scipy.sparse.csr_matrix`, asignando jerarquías y velocidades regulatorias a cada segmento vial.
  ],
  insights: (
    [#text(weight: "bold", fill: color-title)[Cobertura exhaustiva:] Integración integral de avenidas primarias, vías secundarias, residenciales y pasos a desnivel.],
    [#text(weight: "bold", fill: color-title)[Eficiencia computacional:] Reducción de la huella en memoria mediante representación matricial comprimida CSR.],
    [#text(weight: "bold", fill: color-title)[Fundamento para ruteo:] Base geométrica y topológica sobre la cual se inyectan penalizaciones climáticas dinámicas.],
  ),
)
