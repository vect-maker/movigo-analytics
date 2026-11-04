#import "template.typ": *
#import "components.typ": *

= Objetivos de la investigación

#speaker-marker("A")

#v(2pt)

// Objetivo General en tarjeta destacada
#block(
  fill: color-card-bg,
  stroke: 1.2pt + color-title.lighten(50%),
  radius: 9pt,
  inset: (x: 18pt, y: 12pt),
  width: 100%,
  stack(
    dir: ttb,
    spacing: 4pt,
    text(size: 15pt, weight: "bold", fill: color-title, font: font-heading)[Objetivo General],
    par(leading: 0.46em)[#text(size: 13.5pt, fill: color-body, font: font-body)[
      *Analizar* la resiliencia operativa y la conectividad de la red de transporte selectivo MoviGo ante estrangulamientos viales y contingencias climáticas en el municipio de Managua durante el año 2024.
    ]]
  )
)

#v(10pt)

// Tres Objetivos Específicos usando card-numbered
#stack(
  spacing: 9pt,
  card-numbered(
    number: 1,
    accent: color-title,
    title: [Eje 1: Repositorio Multidimensional y Pipeline ELT],
    text-content: [
      *Consolidar* un repositorio analítico multidimensional a partir de los registros operativos del servicio mediante un flujo de extracción, carga y transformación para la integración y explotación de los datos transaccionales.
    ],
    size: 12.8pt,
  ),
  card-numbered(
    number: 2,
    accent: color-accent,
    title: [Eje 2: Modelación Paramétrica y Regresión de Tarifas],
    text-content: [
      *Modelar* las relaciones funcionales operativas y tarifarias del servicio mediante algoritmos de optimización por descenso de gradiente e inferencia paramétrica para cuantificar el impacto de la distancia en la duración y el costo del viaje.
    ],
    size: 12.8pt,
  ),
  card-numbered(
    number: 3,
    accent: color-teal,
    title: [Eje 3: Optimización de Trayectorias y Resiliencia Espacial],
    text-content: [
      *Optimizar* las trayectorias de desplazamiento y la resiliencia de la red vial metropolitana mediante modelos de redes espaciales y algoritmos de camino mínimo ante perturbaciones meteorológicas y cuellos de botella urbanos.
    ],
    size: 12.8pt,
  ),
)
