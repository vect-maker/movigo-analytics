#import "template.typ": *
#import "components.typ": *

= Evasión adaptativa de inundaciones y ruteo con Dijkstra

#slide-single-chart(
  speaker: "D",
  accent: color-accent,
  icon: slide-icons.shield,
  chart: image("../graphs/urban_network_dijkstra.png", height: 310pt, fit: "contain"),
  caption: [Figura: Ruta óptima recalculada mediante Dijkstra evadiendo el segmento inundado del Cauce Oriental.],
  stat: [-21.4% de tiempo con desvío seguro],
  body: [
    Ante la activación de impedancia severa (reducción al 25% de la velocidad nominal y penalización por barrera 2.5x) en el tramo crítico del Cauce Oriental, el algoritmo de Dijkstra reconfigura la trayectoria óptima por corredores perimetrales seguros.
  ],
  insights: (
    [#text(weight: "bold", fill: color-title)[Seguridad del servicio:] Evita que conductores y pasajeros queden atrapados en cruces viales inundados.],
    [#text(weight: "bold", fill: color-title)[Optimización del tiempo:] A pesar de mayor distancia kilométrica, el tiempo total es 21.4% menor que atravesar el cuello de botella.],
    [#text(weight: "bold", fill: color-title)[Adaptabilidad dinámica:] Modificación de pesos de aristas en tiempo real según alertas de precipitación pluvial.],
  ),
)
