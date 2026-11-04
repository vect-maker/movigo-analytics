#import "template.typ": *
#import "components.typ": *

#slide(header: none)[
  #speaker-marker("A", dx: 38pt, dy: -26pt)

  // Franja decorativa en el margen izquierdo: vector continuo en gradiente
  #place(
    top + left,
    dx: -60pt,
    dy: -48pt,
    rect(
      width: 10pt,
      height: 540pt,
      fill: gradient.linear(color-primary, color-mint),
    )
  )

  // Decoración geométrica en esquina inferior derecha inspirada en la plantilla de referencia
  #place(
    bottom + right,
    dx: 60pt,
    dy: 36pt,
    polygon(
      fill: color-mint.lighten(80%),
      (0pt, 0pt),
      (-145pt, 0pt),
      (0pt, -145pt),
    )
  )

  // Título vertical rotado en el margen izquierdo: "PROBLEMÁTICA" (desplazado a la derecha para mayor separación de la barra)
  #place(
    top + left,
    dx: -4pt,
    dy: 360pt,
    rotate(-90deg, origin: bottom + left)[
      #text(size: 42pt, weight: "bold", font: font-heading)[
        #text(fill: color-primary)[PROBLEMÁ]#text(fill: color-mint)[TICA]
      ]
    ]
  )

  // Cuadrícula 2x2 de las 4 Dimensiones de la Problemática (ocupando el espacio máximo del slide)
  #place(
    top + left,
    dx: 86pt,
    dy: -24pt,
    block(
      width: 754pt,
      grid(
        columns: (1fr, 1fr),
        row-gutter: 14pt,
        column-gutter: 22pt,

        // 1. Dilema Tarifario (Top Left)
        stack(
          spacing: 6pt,
          text(size: 19pt, weight: "bold", fill: color-primary, font: font-heading)[Dilema Tarifario],
          box(
            width: 100%,
            height: 196pt,
            radius: 9pt,
            stroke: 1.8pt + color-accent,
            fill: white,
            inset: (x: 18pt, y: 16pt),
            [
              #set par(leading: 0.58em, justify: true)
              #text(size: 12.8pt, fill: color-body, font: font-body)[
                La tarificación dinámica (_surge pricing_) opera como un mecanismo financiero ciego ante las restricciones espaciales de la red vial. Los incrementos tarifarios agresivos saturan la elasticidad-precio del usuario sin descongestionar vías ni resolver atascos, detonando cancelaciones masivas por abandono del servicio.
              ]
              #v(1fr)
              #box(
                fill: color-card-bg,
                stroke: 0.7pt + color-card-stroke,
                radius: 4pt,
                inset: (x: 9pt, y: 4.5pt),
                text(size: 9.5pt, weight: "bold", fill: color-coral)[Fricción: Cancelación de usuarios por sobrecosto]
              )
            ]
          )
        ),

        // 2. Fricción Territorial (Top Right)
        stack(
          spacing: 6pt,
          text(size: 19pt, weight: "bold", fill: color-primary, font: font-heading)[Fricción Territorial],
          box(
            width: 100%,
            height: 196pt,
            radius: 9pt,
            stroke: 1.8pt + color-accent,
            fill: white,
            inset: (x: 18pt, y: 16pt),
            [
              #set par(leading: 0.58em, justify: true)
              #text(size: 12.8pt, fill: color-body, font: font-body)[
                Managua exhibe una estructura urbana fragmentada y marcadamente dispersa. Mientras los cuadrantes corporativos y residenciales altos absorben aumentos de tarifa, los sectores populares y comerciales dependen del efectivo, sufriendo exclusión territorial y rechazos de viaje por los conductores.
              ]
              #v(1fr)
              #box(
                fill: color-card-bg,
                stroke: 0.7pt + color-card-stroke,
                radius: 4pt,
                inset: (x: 9pt, y: 4.5pt),
                text(size: 9.5pt, weight: "bold", fill: color-primary)[Brecha: Exclusión territorial en cuadrantes populares]
              )
            ]
          )
        ),

        // 3. Choque Climático (Bottom Left)
        stack(
          spacing: 6pt,
          text(size: 19pt, weight: "bold", fill: color-primary, font: font-heading)[Choque Climático],
          box(
            width: 100%,
            height: 196pt,
            radius: 9pt,
            stroke: 1.8pt + color-accent,
            fill: white,
            inset: (x: 18pt, y: 16pt),
            [
              #set par(leading: 0.58em, justify: true)
              #text(size: 12.8pt, fill: color-body, font: font-body)[
                Los episodios de precipitaciones intensas y tormentas tropicales colapsan la vulnerable infraestructura de drenaje pluvial de la capital, inundando cauces y nudos arteriales neurálgicos. El anegamiento paraliza el tránsito, atrapa unidades vehiculares y desborda una demanda de refugio imposible de atender.
              ]
              #v(1fr)
              #box(
                fill: color-card-bg,
                stroke: 0.7pt + color-card-stroke,
                radius: 4pt,
                inset: (x: 9pt, y: 4.5pt),
                text(size: 9.5pt, weight: "bold", fill: color-coral)[Vulnerabilidad: Anegamiento pluvial y parálisis de nudos viales]
              )
            ]
          )
        ),

        // 4. Rigidez Vial y Ruteo (Bottom Right)
        stack(
          spacing: 6pt,
          text(size: 19pt, weight: "bold", fill: color-primary, font: font-heading)[Rigidez Vial y Ruteo],
          box(
            width: 100%,
            height: 196pt,
            radius: 9pt,
            stroke: 1.8pt + color-accent,
            fill: white,
            inset: (x: 18pt, y: 16pt),
            [
              #set par(leading: 0.58em, justify: true)
              #text(size: 12.8pt, fill: color-body, font: font-body)[
                El despacho tradicional de viajes no anticipa los cuellos de botella viales ni ofrece navegación inteligente en tiempo real. Los conductores quedan atrapados en corredores colapsados ante la ausencia de algoritmos prescriptivos de camino mínimo capaces de circunnavegar las zonas críticas.
              ]
              #v(1fr)
              #box(
                fill: color-card-bg,
                stroke: 0.7pt + color-card-stroke,
                radius: 4pt,
                inset: (x: 9pt, y: 4.5pt),
                text(size: 9.5pt, weight: "bold", fill: color-accent)[Solución: Ruteo prescriptivo de camino mínimo]
              )
            ]
          )
        ),
      )
    )
  )
]
