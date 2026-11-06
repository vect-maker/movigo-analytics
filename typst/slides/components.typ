#import "template.typ": *

// ============================================================
// MARCADORES DE EXPOSITOR (SPEAKER MARKERS)
// ============================================================

#let speaker-colors = (
  "A": color-primary,    // Teal Profundo (#144e45)
  "B": color-accent,     // Teal Vibrante (#2a9d8f)
  "C": color-slate-teal, // Pizarra Marina (#264653)
  "D": color-coral,      // Coral Cálido (#e76f51)
)

/// Insignia colocada en la esquina superior derecha indicando el expositor actual
#let speaker-marker(
  letter,
  color: auto,
  position: top + right,
  dx: auto,
  dy: auto,
  size: 26pt,
  radius: 5pt,
) = {
  let fill-color = if color == auto {
    speaker-colors.at(str(letter), default: color-title)
  } else {
    color
  }

  let (offset-x, offset-y) = if dx != auto and dy != auto {
    (dx, dy)
  } else if position == top + right {
    (if dx != auto { dx } else { 38pt }, if dy != auto { dy } else { -58pt })
  } else if position == bottom + right {
    (if dx != auto { dx } else { 38pt }, if dy != auto { dy } else { 8pt })
  } else {
    (0pt, 0pt)
  }

  place(
    position,
    dx: offset-x,
    dy: offset-y,
    box(
      fill: fill-color,
      width: size,
      height: size,
      radius: radius,
      align(center + horizon, text(
        fill: white,
        size: size * 0.52,
        weight: "bold",
        font: font-heading,
        letter,
      ))
    )
  )
}

// ============================================================
// COMPONENTES DE TARJETAS Y CONTENEDORES
// ============================================================

/// Tarjeta de métrica destacada
#let metric-card(stat: [], body: [], accent: color-title) = {
  block(
    fill: color-card-bg,
    stroke: 1.1pt + color-card-stroke,
    radius: 9pt,
    inset: (x: 16pt, y: 14pt),
    width: 100%,
    [
      #text(size: 22pt, weight: "bold", fill: accent, font: font-heading, stat)
      #v(0.4em)
      #text(size: 13.5pt, fill: color-body, font: font-body, body)
    ]
  )
}

/// Tarjeta numerada para objetivos o fases secuenciales
#let card-numbered(number: 1, title: none, text-content: [], size: 13.5pt, accent: color-title) = {
  block(
    fill: color-card-bg,
    stroke: 1.1pt + color-card-stroke,
    radius: 9pt,
    inset: (x: 16pt, y: 11pt),
    width: 100%,
    breakable: false,
    grid(
      columns: (30pt, 1fr),
      gutter: 12pt,
      align: (center + horizon, left + horizon),
      circle(
        radius: 14pt,
        fill: accent,
        text(fill: white, size: 13pt, weight: "bold", font: font-heading)[#number]
      ),
      stack(
        dir: ttb,
        spacing: 3pt,
        if title != none [
          #text(fill: accent, size: 13pt, weight: "bold", font: font-heading, title)
        ],
        par(leading: 0.44em)[#text(fill: color-body, size: size, font: font-body, text-content)]
      )
    )
  )
}

/// Tarjeta temática para metodología, arquitectura o conceptos clave
#let feature-card(
  icon: none,
  title: [],
  subtitle: none,
  body: [],
  height: auto,
  inset: (x: 13pt, y: 11pt),
  badge-fill: auto,
  badge-stroke: auto,
  badge-size: 26pt,
  title-size: 14pt,
  subtitle-size: 9.5pt,
  body-size: 10.8pt,
  leading: 0.46em,
  spacing: 0.6em,
  accent: color-title,
) = {
  let b-fill = if badge-fill != auto { badge-fill } else { accent }
  let b-stroke = if badge-stroke != auto { badge-stroke } else { accent }
  block(
    fill: color-card-bg,
    stroke: 1.1pt + color-card-stroke,
    radius: 9pt,
    inset: inset,
    width: 100%,
    height: height,
    stack(
      dir: ttb,
      spacing: 5pt,
      grid(
        columns: if icon != none { (badge-size, 1fr) } else { (1fr,) },
        gutter: 8pt,
        align: (horizon + center, horizon + left),
        if icon != none {
          box(
            fill: b-fill,
            stroke: 0.8pt + b-stroke,
            radius: 5pt,
            width: badge-size,
            height: badge-size,
            align(center + horizon, box(width: badge-size * 0.75, align(center + horizon, icon)))
          )
        },
        [
          #text(size: title-size, weight: "bold", fill: accent, font: font-heading, title)
          #if subtitle != none [
            #v(0.1em)
            #text(size: subtitle-size, fill: color-accent, font: font-body, subtitle)
          ]
        ]
      ),
      line(length: 100%, stroke: 0.5pt + color-card-stroke),
      [
        #set text(size: body-size, fill: color-body, font: font-body)
        #set par(leading: leading)
        #set list(spacing: spacing)
        #body
      ]
    )
  )
}

/// Nodo representativo para pipelines de datos (ELT, dbt Core, Python)
#let pipeline-node(
  logo: none,
  title: [],
  subtitle: none,
  tag: none,
  details: (),
  width: 100%,
  accent: color-title,
  fill: color-card-bg,
  title-size: 12pt,
  subtitle-size: 9.2pt,
  tag-size: 8pt,
  badge-size: 24pt,
  inset: (x: 10pt, y: 8pt),
) = {
  block(
    fill: fill,
    stroke: 1.1pt + color-card-stroke,
    radius: 8pt,
    inset: inset,
    width: width,
    stack(
      dir: ttb,
      spacing: 4pt,
      grid(
        columns: if logo != none { (badge-size, 1fr) } else { (1fr,) },
        gutter: 6pt,
        align: (horizon + center, horizon + left),
        if logo != none {
          box(
            fill: white,
            stroke: 0.8pt + color-card-stroke,
            radius: 4pt,
            width: badge-size,
            height: badge-size,
            align(center + horizon, box(width: badge-size * 0.75, align(center + horizon, logo)))
          )
        },
        [
          #text(size: title-size, weight: "bold", fill: accent, font: font-heading, title)
          #if subtitle != none [
            #v(0.06em)
            #text(size: subtitle-size, fill: color-accent, font: font-body, subtitle)
          ]
        ]
      ),
      if tag != none [
        #box(
          fill: accent.lighten(90%),
          radius: 3pt,
          inset: (x: 4.5pt, y: 1.8pt),
          text(size: tag-size, weight: "bold", fill: accent, font: font-heading, tag)
        )
      ],
      if details.len() > 0 [
        #line(length: 100%, stroke: 0.4pt + color-card-stroke)
        #set text(size: 8.5pt, fill: color-body, font: font-body)
        #set par(leading: 0.28em)
        #for d in details [
          #text(fill: accent, [•]) #d \
        ]
      ]
    )
  )
}

/// Flecha conectora entre nodos de flujo
#let flow-arrow = align(center + horizon, box(
  fill: color-card-bg,
  stroke: 0.8pt + color-card-stroke,
  radius: 11pt,
  width: 22pt,
  height: 22pt,
  align(center + horizon, text(size: 13pt, fill: color-accent, weight: "bold")[#sym.arrow.r])
))

// ============================================================
// COMPONENTES DE CONCLUSIÓN Y RECOMENDACIÓN ESTRATÉGICA
// ============================================================

/// Tarjeta de conclusión de alto impacto con hero stats y veredicto
#let conclusion-card(
  number: "01",
  tag: [],
  title: [],
  icon: none,
  stat-main: [],
  stat-label: [],
  stat-sub: none,
  stat-sub-label: none,
  verdict-headline: [],
  verdict-body: [],
  accent: color-title,
  height: 330pt,
) = {
  block(
    fill: color-card-bg,
    stroke: 1.1pt + color-card-stroke,
    radius: 9pt,
    inset: (x: 14pt, y: 14pt),
    width: 100%,
    height: height,
    breakable: false,
    stack(
      dir: ttb,
      spacing: 0pt,
      // 1. Tag & Número
      grid(
        columns: (auto, 1fr),
        gutter: 6pt,
        align: (horizon + left, horizon + right),
        box(
          fill: accent,
          radius: 3pt,
          inset: (x: 7pt, y: 3pt),
          text(size: 8.5pt, weight: "bold", fill: white, font: font-heading)[#number #sym.bar.v #tag]
        ),
        if icon != none [
          #box(
            fill: accent,
            radius: 4pt,
            width: 22pt,
            height: 22pt,
            align(center + horizon, box(width: 14pt, icon))
          )
        ] else [ ]
      ),
      v(10pt),
      // 2. Título
      text(size: 15.5pt, weight: "bold", fill: accent, font: font-heading, title),
      v(10pt),
      // 3. Contenedor de Hero Metric
      block(
        fill: accent.lighten(94%),
        stroke: 0.8pt + accent.lighten(70%),
        radius: 7pt,
        inset: (x: 8pt, y: 10pt),
        width: 100%,
        [
          #if stat-sub != none [
            #grid(
              columns: (1fr, 1fr),
              gutter: 6pt,
              align: (center, center),
              [
                #text(size: 26pt, weight: "bold", fill: accent, font: font-heading, stat-main) \
                #v(2pt)
                #text(size: 9pt, weight: "bold", fill: color-body, font: font-body, stat-label)
              ],
              [
                #text(size: 26pt, weight: "bold", fill: color-accent, font: font-heading, stat-sub) \
                #v(2pt)
                #text(size: 9pt, weight: "bold", fill: color-body, font: font-body, stat-sub-label)
              ]
            )
          ] else [
            #align(center, [
              #text(size: 28pt, weight: "bold", fill: accent, font: font-heading, stat-main) \
              #v(2pt)
              #text(size: 9.5pt, weight: "bold", fill: color-body, font: font-body, stat-label)
            ])
          ]
        ]
      ),
      v(13pt),
      // 4. Veredicto principal
      text(size: 13.5pt, weight: "bold", fill: color-body, font: font-heading, verdict-headline),
      v(6pt),
      par(leading: 0.48em)[#text(size: 11.2pt, fill: color-body, font: font-body, verdict-body)],
    )
  )
}

/// Fila estructurada de recomendación operativa / de políticas
#let policy-row(
  number: "01",
  pillar-tag: [],
  target-agency: [],
  icon: none,
  title: [],
  action-1-title: [],
  action-1-body: [],
  action-2-title: [],
  action-2-body: [],
  impact-label: none,
  impact-target: [],
  impact-stat: none,
  accent: color-title,
) = {
  block(
    fill: color-card-bg,
    stroke: 1.1pt + color-card-stroke,
    radius: 8pt,
    inset: (x: 13pt, y: 9pt),
    width: 100%,
    breakable: false,
    grid(
      columns: (160pt, 1fr, 140pt),
      gutter: 12pt,
      align: (horizon + left, horizon + left, horizon + center),
      // Columna 1: Pilar y Ente
      stack(
        dir: ttb,
        spacing: 4pt,
        grid(
          columns: (auto, 1fr),
          gutter: 5pt,
          align: (horizon + left, horizon + left),
          box(
            fill: accent,
            radius: 3pt,
            inset: (x: 5pt, y: 2.2pt),
            text(size: 7.8pt, weight: "bold", fill: white, font: font-heading)[#number #sym.bar.v #pillar-tag]
          ),
          if icon != none [
            #box(
              fill: accent,
              radius: 3.5pt,
              width: 18pt,
              height: 18pt,
              align(center + horizon, box(width: 11pt, icon))
            )
          ] else [ ]
        ),
        block(
          text(size: 13pt, weight: "bold", fill: accent, font: font-heading, title)
        ),
        block(
          text(size: 8pt, weight: "bold", fill: color-accent, font: font-body, target-agency)
        ),
      ),
      // Columna 2: Acciones Operativas
      grid(
        columns: (1fr, 1fr),
        gutter: 12pt,
        // Acción Inmediata
        stack(
          dir: ttb,
          spacing: 4pt,
          box(
            fill: accent.lighten(92%),
            radius: 2.5pt,
            inset: (x: 4.5pt, y: 1.8pt),
            text(size: 7pt, weight: "bold", fill: accent, font: font-heading)[ACCIÓN INMEDIATA]
          ),
          block(
            text(size: 9.8pt, weight: "bold", fill: color-title, font: font-heading, action-1-title)
          ),
          block[
            #set par(leading: 0.36em)
            #text(size: 8.8pt, fill: color-body, font: font-body, action-1-body)
          ],
        ),
        // Reforma Estructural
        stack(
          dir: ttb,
          spacing: 4pt,
          box(
            fill: accent.lighten(92%),
            radius: 2.5pt,
            inset: (x: 4.5pt, y: 1.8pt),
            text(size: 7pt, weight: "bold", fill: accent, font: font-heading)[ESTRATEGIA ALGORÍTMICA]
          ),
          block(
            text(size: 9.8pt, weight: "bold", fill: color-title, font: font-heading, action-2-title)
          ),
          block[
            #set par(leading: 0.36em)
            #text(size: 8.8pt, fill: color-body, font: font-body, action-2-body)
          ],
        ),
      ),
      // Columna 3: Métrica de Impacto
      block(
        fill: accent.lighten(94%),
        stroke: 0.8pt + accent.lighten(70%),
        radius: 7pt,
        inset: (x: 7pt, y: 7pt),
        width: 100%,
        align(center, stack(
          dir: ttb,
          spacing: 3pt,
          if impact-label != none and impact-label != [] [
            #box(
              fill: accent.lighten(88%),
              radius: 2.5pt,
              inset: (x: 5pt, y: 1.8pt),
              text(size: 7pt, weight: "bold", fill: accent, font: font-heading, impact-label)
            )
          ] else [ ],
          if impact-stat != none [
            #block(text(size: 18pt, weight: "bold", fill: accent, font: font-heading, impact-stat))
          ] else [ ],
          block[
            #set par(leading: 0.34em)
            #text(size: 8pt, fill: color-body, font: font-body, impact-target)
          ]
        ))
      )
    )
  )
}

// ============================================================
// COMPONENTES PARA DIAPOSITIVAS ANALÍTICAS CON GRÁFICOS
// ============================================================

/// Tarjeta analítica lateral para emparejar con gráficos
#let analytical-card(
  icon: none,
  stat: [],
  body: [],
  formula: none,
  accent: color-title,
) = {
  block(
    fill: color-card-bg,
    stroke: 1pt + color-card-stroke,
    radius: 8pt,
    inset: (x: 12pt, y: 10pt),
    width: 100%,
    [
      #grid(
        columns: if icon != none { (24pt, 1fr) } else { (1fr,) },
        gutter: 8pt,
        align: (horizon + center, horizon + left),
        if icon != none {
          box(
            fill: accent,
            radius: 5pt,
            width: 24pt,
            height: 24pt,
            align(center + horizon, box(width: 14pt, height: 14pt, icon))
          )
        },
        [
          #text(size: 14pt, weight: "bold", fill: accent, font: font-heading, stat)
        ]
      )
      #v(4pt)
      #line(length: 100%, stroke: 0.5pt + color-card-stroke)
      #if formula != none [
        #v(3pt)
        #block(
          width: 100%,
          fill: white,
          stroke: 1pt + accent.lighten(40%),
          radius: 6pt,
          inset: (x: 8pt, y: 5.5pt),
          align(center + horizon)[#formula]
        )
      ]
      #v(4pt)
      #par(leading: 0.46em)[#text(size: 10.2pt, fill: color-body, font: font-body, body)]
    ]
  )
}

/// Generador de diapositiva con 1 gráfico grande y panel explicativo enriquecido
#let slide-single-chart(
  chart: none,
  caption: [],
  stat: [],
  body: [],
  formula: none,
  insights: (),
  icon: none,
  speaker: none,
  accent: color-title,
) = {
  slide[
    #if speaker != none {
      speaker-marker(speaker)
    }
    #v(4pt)
    #grid(
      columns: (480pt, 1fr),
      gutter: 18pt,
      align: horizon,
      [
        #block(
          width: 100%,
          fill: color-card-bg,
          stroke: 1.1pt + color-card-stroke,
          radius: 8pt,
          inset: (x: 10pt, y: 10pt),
          align(center)[
            #chart
            #if caption != [] [
              #v(6pt)
              #text(size: 9pt, fill: color-muted, font: font-body, caption)
            ]
          ]
        )
      ],
      [
        #stack(
          spacing: 12pt,
          analytical-card(icon: icon, stat: stat, body: body, formula: formula, accent: accent),
          if insights.len() > 0 [
            #block(
              fill: color-card-bg,
              stroke: 1pt + color-card-stroke,
              radius: 8pt,
              inset: (x: 12pt, y: 10pt),
              width: 100%,
              [
                #text(size: 11pt, weight: "bold", fill: color-title, font: font-heading)[Implicaciones Operativas]
                #v(4pt)
                #line(length: 100%, stroke: 0.5pt + color-card-stroke)
                #v(4pt)
                #set text(size: 9.3pt, fill: color-body, font: font-body)
                #list(
                  spacing: 0.55em,
                  ..insights
                )
              ]
            )
          ]
        )
      ]
    )
  ]
}

/// Generador de diapositiva con 2 gráficos alternantes (zig-zag layout)
#let slide-dual-chart(
  // Fila 1 (arriba): Gráfico Izquierda, Análisis Derecha
  chart-fn-1: none,
  caption-1: [],
  stat-1: [],
  body-1: [],
  icon-1: none,
  // Fila 2 (abajo): Análisis Izquierda, Gráfico Derecha
  chart-fn-2: none,
  caption-2: [],
  stat-2: [],
  body-2: [],
  icon-2: none,
  speaker: none,
  accent-1: color-title,
  accent-2: color-accent,
) = {
  slide[
    #if speaker != none {
      speaker-marker(speaker)
    }
    #set text(size: 10pt, font: font-body)
    #grid(
      rows: (1fr, 1fr),
      row-gutter: 6pt,
      // Fila 1: Gráfico a la izquierda, información a la derecha
      grid(
        columns: (480pt, 1fr),
        gutter: 16pt,
        align: (center + horizon, horizon + left),
        [
          #block(width: 100%, align(center)[
            #chart-fn-1
            #if caption-1 != [] [
              #v(0.2em)
              #text(size: 8.8pt, fill: color-muted, font: font-body, caption-1)
            ]
          ])
        ],
        [
          #analytical-card(icon: icon-1, stat: stat-1, body: body-1, accent: accent-1)
        ]
      ),
      // Fila 2: Información a la izquierda, gráfico a la derecha
      grid(
        columns: (1fr, 480pt),
        gutter: 16pt,
        align: (horizon + left, center + horizon),
        [
          #analytical-card(icon: icon-2, stat: stat-2, body: body-2, accent: accent-2)
        ],
        [
          #block(width: 100%, align(center)[
            #chart-fn-2
            #if caption-2 != [] [
              #v(0.2em)
              #text(size: 8.8pt, fill: color-muted, font: font-body, caption-2)
            ]
          ])
        ]
      )
    )
  ]
}

/// Layout de figura o diagrama superior grande con tarjeta explicativa inferior
#let diagram-card-layout(
  image-content,
  title: [],
  body: [],
  icon: none,
  diagram-height: 295pt,
  accent: color-accent,
) = {
  align(center, block(
    width: 100%,
    height: diagram-height,
    fill: white,
    stroke: 1pt + color-card-stroke,
    radius: 8pt,
    inset: (x: 10pt, y: 8pt),
    align(center + horizon, image-content)
  ))

  v(10pt)

  block(
    width: 100%,
    fill: color-card-bg,
    stroke: (left: 3.5pt + accent, rest: 0.8pt + color-card-stroke),
    radius: 6pt,
    inset: (x: 16pt, y: 11pt),
    [
      #grid(
        columns: if icon != none { (28pt, 1fr) } else { (1fr,) },
        gutter: 14pt,
        align: horizon,
        if icon != none [
          #box(
            fill: color-primary,
            radius: 4pt,
            width: 28pt,
            height: 28pt,
            align(center + horizon, box(width: 16pt, icon))
          )
        ],
        stack(
          spacing: 3pt,
          if title != [] [
            #text(size: 11.5pt, weight: "bold", fill: color-primary, font: font-heading, title)
          ],
          text(size: 10.5pt, fill: color-body, font: font-body, body)
        )
      )
    ]
  )
}
