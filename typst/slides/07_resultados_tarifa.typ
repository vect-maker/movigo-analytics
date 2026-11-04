#import "template.typ": *
#import "components.typ": *

= Dinámica tarifaria y duración de viajes por descenso de gradiente

#slide-dual-chart(
  speaker: "C",
  accent-1: color-primary,
  icon-1: slide-icons.dollar-sign,
  chart-fn-1: image("../graphs/numerical_fare.png", height: 162pt),
  caption-1: [Figura: Regresión SGD de la tarifa final frente a la distancia de viaje.],
  stat-1: [R² = 0.892 en tarifa final],
  body-1: [El modelo numérico por gradiente estocástico estima una pendiente marginal de C\$ 18.20/km con tarifa base. La dispersión superior refleja la activación del multiplicador dinámico ante picos de demanda.],
  accent-2: color-coral,
  icon-2: slide-icons.clock,
  stat-2: [+14.8 min en contingencia],
  body-2: [La duración del viaje se dilata de manera no lineal en eventos meteorológicos extremos. La velocidad media desciende drásticamente en corredores principales, forzando aumentos en el costo temporal.],
  chart-fn-2: image("../graphs/numerical_duration.png", height: 162pt),
  caption-2: [Figura: Ajuste de duración de viaje estimada frente a distancia recorrida.],
)
