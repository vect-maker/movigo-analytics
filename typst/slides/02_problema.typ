#import "template.typ": *
#import "components.typ": *

= Problema y contexto de la investigación

#speaker-marker("A")

// --- SECCIÓN SUPERIOR: UNIVERSO DE MOVILIDAD Y VACÍO EMPÍRICO ---
#grid(
  columns: (380pt, 1fr),
  gutter: 14pt,
  // 1. Métricas del Universo de Operación
  grid(
    columns: (1fr, 1fr),
    gutter: 10pt,
    // Métrica 1: Viajes Totales
    block(
      fill: rgb("#f8fafc"),
      stroke: 1.1pt + color-title.lighten(65%),
      radius: 9pt,
      inset: (x: 12pt, y: 10pt),
      height: 104pt,
      stack(
        dir: ttb,
        spacing: 4pt,
        box(
          fill: color-title.lighten(88%),
          radius: 3pt,
          inset: (x: 5pt, y: 2pt),
          text(size: 7.5pt, weight: "bold", fill: color-title, font: font-heading)[UNIVERSO MOVIGO]
        ),
        v(1pt),
        block(text(size: 22pt, weight: "bold", fill: color-title, font: font-heading)[100,000]),
        block(text(size: 10pt, weight: "bold", fill: color-accent, font: font-body)[Viajes registrados]),
        block(text(size: 8.5pt, fill: rgb("#64748b"), font: font-body)[298 cuadrantes urbanos])
      )
    ),
    // Métrica 2: Tasa de Cancelación Global
    block(
      fill: rgb("#fff5f5"),
      stroke: 1.1pt + color-red.lighten(65%),
      radius: 9pt,
      inset: (x: 12pt, y: 10pt),
      height: 104pt,
      stack(
        dir: ttb,
        spacing: 4pt,
        box(
          fill: color-red.lighten(88%),
          radius: 3pt,
          inset: (x: 5pt, y: 2pt),
          text(size: 7.5pt, weight: "bold", fill: color-red, font: font-heading)[FRICCIÓN CRÍTICA]
        ),
        v(1pt),
        block(text(size: 22pt, weight: "bold", fill: color-red, font: font-heading)[17.8%]),
        block(text(size: 10pt, weight: "bold", fill: color-red, font: font-body)[Cancelación global]),
        block(text(size: 8.5pt, fill: rgb("#64748b"), font: font-body)[Pico 38.4% bajo lluvia torrencial])
      )
    )
  ),
  // 2. Tarjeta de Vacío en la Literatura / Contexto Managua
  block(
    fill: color-card-bg,
    stroke: 1.1pt + color-card-stroke,
    radius: 9pt,
    inset: (x: 14pt, y: 10pt),
    height: 104pt,
    stack(
      dir: ttb,
      spacing: 5pt,
      grid(
        columns: (22pt, 1fr),
        gutter: 7pt,
        align: (center + horizon, left + horizon),
        box(
          fill: color-red,
          radius: 4pt,
          width: 22pt,
          height: 22pt,
          align(center + horizon, box(width: 14pt, slide-icons.alert-circle))
        ),
        [
          #text(size: 12.8pt, weight: "bold", fill: color-title, font: font-heading)[Desafío Urbano en Managua] \
          #text(size: 8.5pt, fill: color-accent, font: font-body)[Tarificación dinámica bajo infraestructura vulnerable]
        ]
      ),
      line(length: 100%, stroke: 0.5pt + rgb("#e2e8f0")),
      block[
        #set text(size: 9.8pt, fill: color-body, font: font-body)
        #set par(leading: 0.38em)
        Los algoritmos convencionales de tarificación asumen redes fluidas y homogéneas; en Managua, la escorrentía pluvial y los cauces abiertos colapsan la conectividad y disparan cancelaciones.
      ],
      v(2pt),
      grid(
        columns: (auto, auto, auto),
        gutter: 6pt,
        box(
          fill: rgb("#eff6ff"),
          radius: 3pt,
          inset: (x: 5pt, y: 2pt),
          text(size: 7.8pt, weight: "bold", fill: color-accent, font: font-heading)[Red Vial 69k Nodos]
        ),
        box(
          fill: rgb("#fef2f2"),
          radius: 3pt,
          inset: (x: 5pt, y: 2pt),
          text(size: 7.8pt, weight: "bold", fill: color-red, font: font-heading)[Microclima Extremo]
        ),
        box(
          fill: rgb("#f0fdfa"),
          radius: 3pt,
          inset: (x: 5pt, y: 2pt),
          text(size: 7.8pt, weight: "bold", fill: color-teal, font: font-heading)[Cauces Críticos]
        )
      )
    )
  )
)

#v(10pt)

// --- SECCIÓN INFERIOR: TRES PARADOJAS CIENTÍFICAS A CONTRASTAR ---
#grid(
  columns: (22pt, 1fr),
  gutter: 7pt,
  align: (center + horizon, left + horizon),
  box(
    fill: color-accent,
    radius: 4pt,
    width: 22pt,
    height: 22pt,
    align(center + horizon, box(width: 14pt, slide-icons.help-circle))
  ),
  [
    #text(size: 13.5pt, weight: "bold", fill: color-title, font: font-heading)[Tres Paradojas Operativas y Científicas a Contrastar]
  ]
)

#v(6pt)

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 12pt,
  // Paradoja 1: Tarifa
  block(
    fill: color-card-bg,
    stroke: 1.1pt + color-title.lighten(65%),
    radius: 9pt,
    inset: (x: 12pt, y: 10pt),
    height: 148pt,
    stack(
      dir: ttb,
      spacing: 5pt,
      grid(
        columns: (auto, 1fr),
        align: (horizon + left, horizon + right),
        box(
          fill: color-title,
          radius: 3pt,
          inset: (x: 5.5pt, y: 2pt),
          text(size: 7.8pt, weight: "bold", fill: white, font: font-heading)[01 #sym.bar.v TARIFA]
        ),
        box(
          fill: color-title.lighten(90%),
          radius: 3pt,
          inset: (x: 4.5pt, y: 1.8pt),
          text(size: 7.2pt, weight: "bold", fill: color-title, font: font-heading)[Elasticidad Demanda]
        )
      ),
      block(text(size: 14pt, weight: "bold", fill: color-title, font: font-heading)[¿Incentivo o Rechazo?]),
      line(length: 100%, stroke: 0.5pt + color-title.lighten(70%)),
      block[
        #set par(leading: 0.40em)
        #text(size: 10.8pt, fill: color-body, font: font-body)[
          ¿Atrae el multiplicador mayor oferta de conductores o ahuyenta al usuario superando su disposición a pagar?
        ]
      ],
      v(2pt),
      block(
        fill: rgb("#f8fafc"),
        stroke: 0.6pt + rgb("#cbd5e1"),
        radius: 4pt,
        inset: (x: 7pt, y: 5pt),
        width: 100%,
        [
          #set par(leading: 0.36em)
          #text(size: 9.2pt, fill: color-title, font: font-body)[
            *Hipótesis:* Existe un umbral no lineal donde el multiplicador cataliza cancelaciones por abandono.
          ]
        ]
      )
    )
  ),
  // Paradoja 2: Espacio
  block(
    fill: color-card-bg,
    stroke: 1.1pt + color-accent.lighten(65%),
    radius: 9pt,
    inset: (x: 12pt, y: 10pt),
    height: 148pt,
    stack(
      dir: ttb,
      spacing: 5pt,
      grid(
        columns: (auto, 1fr),
        align: (horizon + left, horizon + right),
        box(
          fill: color-accent,
          radius: 3pt,
          inset: (x: 5.5pt, y: 2pt),
          text(size: 7.8pt, weight: "bold", fill: white, font: font-heading)[02 #sym.bar.v ESPACIO]
        ),
        box(
          fill: color-accent.lighten(90%),
          radius: 3pt,
          inset: (x: 4.5pt, y: 1.8pt),
          text(size: 7.2pt, weight: "bold", fill: color-accent, font: font-heading)[Disparidad Territorial]
        )
      ),
      block(text(size: 14pt, weight: "bold", fill: color-accent, font: font-heading)[¿Cobertura o Abandono?]),
      line(length: 100%, stroke: 0.5pt + color-accent.lighten(70%)),
      block[
        #set par(leading: 0.40em)
        #text(size: 10.8pt, fill: color-body, font: font-body)[
          ¿Se distribuye la flota equitativamente o se concentra en distritos comerciales dejando periferias desabastecidas?
        ]
      ],
      v(2pt),
      block(
        fill: rgb("#eff6ff"),
        stroke: 0.6pt + rgb("#bfdbfe"),
        radius: 4pt,
        inset: (x: 7pt, y: 5pt),
        width: 100%,
        [
          #set par(leading: 0.36em)
          #text(size: 9.2pt, fill: color-accent, font: font-body)[
            *Hipótesis:* La periferia sur y oriental acumula cancelaciones crónicas por tiempos de espera inviables.
          ]
        ]
      )
    )
  ),
  // Paradoja 3: Ruteo
  block(
    fill: color-card-bg,
    stroke: 1.1pt + color-teal.lighten(65%),
    radius: 9pt,
    inset: (x: 12pt, y: 10pt),
    height: 148pt,
    stack(
      dir: ttb,
      spacing: 5pt,
      grid(
        columns: (auto, 1fr),
        align: (horizon + left, horizon + right),
        box(
          fill: color-teal,
          radius: 3pt,
          inset: (x: 5.5pt, y: 2pt),
          text(size: 7.8pt, weight: "bold", fill: white, font: font-heading)[03 #sym.bar.v RUTEO]
        ),
        box(
          fill: color-teal.lighten(90%),
          radius: 3pt,
          inset: (x: 4.5pt, y: 1.8pt),
          text(size: 7.2pt, weight: "bold", fill: color-teal, font: font-heading)[Red Dinámica]
        )
      ),
      block(text(size: 14pt, weight: "bold", fill: color-teal, font: font-heading)[¿Distancia o Resiliencia?]),
      line(length: 100%, stroke: 0.5pt + color-teal.lighten(70%)),
      block[
        #set par(leading: 0.40em)
        #text(size: 10.8pt, fill: color-body, font: font-body)[
          ¿Optimiza la ruta euclidiana tradicional o colapsa el viaje al enviar al conductor a través de un cauce anegado?
        ]
      ],
      v(2pt),
      block(
        fill: rgb("#f0fdfa"),
        stroke: 0.6pt + rgb("#99f6e4"),
        radius: 4pt,
        inset: (x: 7pt, y: 5pt),
        width: 100%,
        [
          #set par(leading: 0.36em)
          #text(size: 9.2pt, fill: color-teal, font: font-body)[
            *Hipótesis:* Un grafo de impedancia dinámica con Dijkstra reduce el tiempo efectivo bordeando zonas de riesgo.
          ]
        ]
      )
    )
  )
)
