#import "template.typ": *
#import "components.typ": *
#import "../data_bindings.typ": (
  m2-r2, m2-b0, m2-b1, m2-mae, fmt-dec,
)

= Dinámica tarifaria y recargo dinámico mediante SGD

#slide-single-chart(
  speaker: "C",
  accent: color-primary,
  icon: slide-icons.dollar-sign,
  chart: image("../graphs/numerical_fare.png", height: 310pt, fit: "contain"),
  caption: [Figura: Regresión lineal estocástica (SGD) de la tarifa final frente a la distancia de recorrido.],
  stat: [R² = #fmt-dec(m2-r2, digits: 3) en tarifa final],
  formula: [
    #grid(
      columns: (auto, 1fr),
      gutter: 8pt,
      align: (horizon, horizon),
      text(size: 8pt, weight: "bold", fill: rgb("#064e3b"), font: font-heading)[FUNCIÓN MODELADA:],
      text(size: 11pt, weight: "bold", fill: rgb("#064e3b"))[
        $text("Tarifa") = #fmt-dec(m2-b0, digits: 2) + #fmt-dec(m2-b1, digits: 2) dot text("distancia")$
      ]
    )
  ],
  body: [
    El modelo por descenso de gradiente estocástico ajusta una pendiente marginal de C\$ #fmt-dec(m2-b1, digits: 2) por kilómetro sobre los viajes completados. La dispersión observada por encima de la recta de ajuste refleja la activación de recargos dinámicos (*surge pricing*) y factores de congestión horaria.
  ],
  insights: (
    [#text(weight: "bold", fill: color-title)[Tarifa base y pendiente:] Costo operativo mínimo predecible con tasa marginal uniforme de arranque.],
    [#text(weight: "bold", fill: color-title)[Dispersión vertical:] Picos tarifarios originados por alta demanda relativa en zonas de lluvia o eventos de saturación.],
    [#text(weight: "bold", fill: color-title)[Inferencia en producción:] Modelo ligero de evaluación instantánea ($O(1)$) apto para cotización en tiempo real.],
  ),
)
