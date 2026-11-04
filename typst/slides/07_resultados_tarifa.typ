#import "template.typ": *
#import "components.typ": *
#import "../data_bindings.typ": (
  m1-r2, m1-b1, m1-mae, m2-r2, m2-b1, m2-mae, fmt-dec,
)

= Dinámica tarifaria y duración de viajes por descenso de gradiente

#slide-dual-chart(
  speaker: "C",
  accent-1: color-primary,
  icon-1: slide-icons.dollar-sign,
  chart-fn-1: image("../graphs/numerical_fare.png", height: 162pt),
  caption-1: [Figura: Regresión SGD de la tarifa final frente a la distancia de viaje.],
  stat-1: [R² = #fmt-dec(m2-r2, digits: 3) en tarifa final],
  body-1: [El modelo numérico por gradiente estocástico estima una pendiente marginal de C\$ #fmt-dec(m2-b1, digits: 2)/km con cargo base de arranque. La alta dispersión vertical evidencia la activación del recargo dinámico (surge) y factores exógenos.],
  accent-2: color-accent,
  icon-2: slide-icons.clock,
  stat-2: [R² = #fmt-dec(m1-r2, digits: 3) en duración],
  body-2: [La duración prevista (ETA) exhibe una fuerte consistencia lineal (+#fmt-dec(m1-b1, digits: 2) min/km, MAE #fmt-dec(m1-mae, digits: 2) min). Los viajes con demoras extremas corresponden a contingencias pluviales y cuellos de botella viales.],
  chart-fn-2: image("../graphs/numerical_duration.png", height: 162pt),
  caption-2: [Figura: Ajuste de duración de viaje estimada frente a distancia recorrida.],
)
