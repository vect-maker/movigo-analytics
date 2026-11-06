#import "template.typ": *
#import "components.typ": *
#import "../data_bindings.typ": (
  m1-r2, m1-b0, m1-b1, m1-mae, fmt-dec,
)

= Estimación de duración de viaje mediante SGD

#slide-single-chart(
  speaker: "C",
  accent: color-accent,
  icon: slide-icons.clock,
  chart: image("../graphs/numerical_duration.png", height: 310pt, fit: "contain"),
  caption: [Figura: Ajuste de duración de viaje estimada (ETA) frente a distancia recorrida.],
  stat: [R² = #fmt-dec(m1-r2, digits: 3) en duración ETA],
  formula: [
    #grid(
      columns: (auto, 1fr),
      gutter: 8pt,
      align: (horizon, horizon),
      text(size: 8pt, weight: "bold", fill: color-title, font: font-heading)[FUNCIÓN MODELADA:],
      text(size: 11pt, weight: "bold", fill: color-primary)[
        $text("ETA") = #fmt-dec(m1-b0, digits: 2) + #fmt-dec(m1-b1, digits: 2) dot text("distancia")$
      ]
    )
  ],
  body: [
    La duración prevista exhibe una alta consistencia lineal (+#fmt-dec(m1-b1, digits: 2) min/km, error medio absoluto MAE #fmt-dec(m1-mae, digits: 2) min). Los viajes con demoras extremas corresponden a contingencias pluviales severas y cuellos de botella viales identificados en Managua.
  ],
  insights: (
    [#text(weight: "bold", fill: color-title)[Predecibilidad base:] Fuerte correlación lineal entre distancia euclidiana/vial y tiempo estándar de tránsito.],
    [#text(weight: "bold", fill: color-title)[Anomalías pluviales:] Desviaciones marcadas causadas por inundaciones de cauces y reducción drástica de velocidad vehicular.],
    [#text(weight: "bold", fill: color-title)[Fiabilidad operativa:] Proporciona al usuario un ETA robusto fuera de muestra con baja varianza basal.],
  ),
)
