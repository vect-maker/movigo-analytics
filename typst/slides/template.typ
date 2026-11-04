#import "@preview/touying:0.8.0": *
#import "@preview/ficons:0.1.0": make-icons
#import "@preview/tiaoma:0.3.0": qrcode

// ============================================================
// PALETA CROMÁTICA INSTITUCIONAL Y CONSTANTES (MOVIGO)
// ============================================================
#let color-title = rgb("#0f2942")       // Azul marino profundo
#let color-body = rgb("#1e293b")        // Slate oscuro para texto legible
#let color-accent = rgb("#1a4d8f")      // Azul analítico institucional
#let color-red = rgb("#d9383a")         // Rojo de contraste MoviGo / UNAN
#let color-teal = rgb("#0b7285")        // Teal para componentes espaciales
#let color-card-bg = rgb("#fbfafc")     // Fondo neutro limpio de tarjetas
#let color-card-stroke = rgb("#e2e8f0") // Borde sutil neutro
#let color-badge-bg = color-title
#let color-badge-stroke = color-title

#let font-heading = ("Liberation Sans",)
#let font-body = ("Liberation Sans",)

/// Feather icons configurados con trazo blanco para contenedores de insignias
#let slide-icons = make-icons(stroke: white, stroke-width: 2.3)

// ============================================================
// FUNCIONES MAESTRAS DE DIAPOSITIVA (TOUYING 0.8.0)
// ============================================================

/// Diapositiva de contenido maestro con encabezado dinámico y pie institucional vectorial
#let slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  let header(self) = {
    // Barra de acento superior vectorial
    place(
      top + left,
      rect(
        width: 960pt,
        height: 3.5pt,
        fill: gradient.linear(color-title, color-accent, color-red),
      )
    )
    // Título de la diapositiva obtenido del heading de nivel 1
    place(
      top + left,
      dx: 60pt,
      dy: 18pt,
      block(
        width: 840pt,
        height: 52pt,
        align(top + left, text(
          fill: color-title,
          size: 24pt,
          weight: "bold",
          font: font-heading,
          utils.display-current-heading(level: 1)
        ))
      )
    )
  }

  let footer(self) = {
    place(
      bottom + left,
      dx: 60pt,
      dy: -14pt,
      block(
        width: 840pt,
        [
          #line(length: 100%, stroke: 0.5pt + rgb("#e2e8f0"))
          #v(3pt)
          #grid(
            columns: (1fr, auto),
            align: (left + horizon, right + horizon),
            text(size: 8.5pt, fill: rgb("#64748b"), font: font-body)[
              *MoviGo* #sym.bar.v Tarifa Dinámica y Cancelaciones #sym.bar.v UNAN-Managua (Integrador IV)
            ],
            text(size: 8.5pt, fill: rgb("#64748b"), font: font-body)[
              #context utils.slide-counter.display("1 / 1", both: true)
            ]
          )
        ]
      )
    )
  }

  let self = utils.merge-dicts(
    self,
    config-page(
      fill: rgb("#ffffff"),
      header: header,
      footer: footer,
      margin: (left: 60pt, right: 60pt, top: 78pt, bottom: 32pt),
    ),
  )

  touying-slide(
    self: self,
    config: config,
    repeat: repeat,
    setting: setting,
    composer: composer,
    ..bodies,
  )
})

/// Diapositiva de portada institucional moderna en diseño vectorial puro
#let title-slide(
  title: [Título de la Investigación],
  subtitle: none,
  authors: (),
  tutor: none,
  career: none,
  university: none,
  date: none,
  config: (:),
) = touying-slide-wrapper(self => {
  let self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(
      fill: rgb("#ffffff"),
      margin: 0pt,
      header: none,
      footer: none,
    ),
  )

  let author-items = if type(authors) == array {
    authors.map(a => {
      if type(a) == dictionary {
        if "formal-name" in a {
          a.formal-name
        } else if "name" in a {
          a.name
        } else {
          ""
        }
      } else {
        str(a)
      }
    })
  } else if authors != none and authors != [] {
    (str(authors),)
  } else {
    ()
  }

  let tutor-name = if type(tutor) == dictionary {
    if "formal-name" in tutor {
      tutor.formal-name
    } else if "name" in tutor {
      tutor.name
    } else {
      none
    }
  } else {
    tutor
  }

  touying-slide(
    self: self,
    config: config,
    {
      // Panel lateral decorativo con gradiente vectorial
      place(
        top + left,
        rect(
          width: 220pt,
          height: 540pt,
          fill: gradient.linear(color-title, rgb("#132a45"), angle: 45deg),
        )
      )

      // Acento geométrico en panel lateral
      place(
        top + left,
        dx: 216pt,
        rect(
          width: 4pt,
          height: 540pt,
          fill: gradient.linear(color-red, color-accent),
        )
      )

      // Identificador institucional en panel lateral
      place(
        top + left,
        dx: 28pt,
        dy: 42pt,
        block(
          width: 165pt,
          stack(
            spacing: 12pt,
            box(
              fill: color-red,
              radius: 4pt,
              inset: (x: 8pt, y: 4pt),
              text(fill: white, size: 8.5pt, weight: "bold", font: font-heading)[PROYECTO INTEGRADOR IV]
            ),
            text(fill: white, size: 15pt, weight: "bold", font: font-heading)[MoviGo Analytics],
            line(length: 100%, stroke: 0.8pt + rgb("#2d486b")),
            if career != none [
              #text(fill: rgb("#cbd5e1"), size: 9pt, font: font-body, career) \
            ],
            if university != none [
              #v(4pt)
              #text(fill: rgb("#94a3b8"), size: 8.5pt, font: font-body, university)
            ],
            if date != none [
              #v(16pt)
              #text(fill: rgb("#cbd5e1"), size: 8.5pt, weight: "semibold", font: font-body, date)
            ]
          )
        )
      )

      // Contenido principal de la portada (lado derecho)
      place(
        top + left,
        dx: 260pt,
        dy: 52pt,
        block(
          width: 640pt,
          stack(
            spacing: 0pt,
            box(
              fill: rgb("#eff6ff"),
              stroke: 0.8pt + rgb("#bfdbfe"),
              radius: 4pt,
              inset: (x: 8pt, y: 3.5pt),
              text(fill: color-accent, size: 8.5pt, weight: "bold", font: font-heading)[ARTÍCULO CIENTÍFICO Y MODELACIÓN]
            ),
            v(10pt),
            text(
              fill: color-title,
              size: 22.5pt,
              weight: "bold",
              font: font-heading,
              title,
            ),
            if subtitle != none and subtitle != [] [
              #v(8pt)
              #text(
                fill: color-accent,
                size: 13.5pt,
                weight: "medium",
                font: font-body,
                subtitle,
              )
            ],
            v(18pt),
            line(length: 100%, stroke: 0.6pt + rgb("#e2e8f0")),
            v(16pt),
            grid(
              columns: (1fr, 1fr),
              gutter: 20pt,
              // Autores
              stack(
                spacing: 6pt,
                text(fill: color-title, size: 11pt, weight: "bold", font: font-heading)[Autores de la Investigación:],
                grid(
                  columns: 1,
                  row-gutter: 4.5pt,
                  ..author-items.map(a => text(fill: color-body, size: 10pt, font: font-body, a))
                )
              ),
              // Tutor y detalles académicos
              stack(
                spacing: 6pt,
                if tutor-name != none [
                  #text(fill: color-title, size: 11pt, weight: "bold", font: font-heading)[Tutor Académico:]
                  #v(2pt)
                  #text(fill: color-body, size: 10.5pt, font: font-body, tutor-name)
                ],
                v(8pt),
                text(fill: rgb("#64748b"), size: 8.8pt, font: font-body)[
                  Segundo Semestre • 2026 \
                  Managua, Nicaragua
                ]
              )
            )
          )
        )
      )
    }
  )
})

/// Diapositiva de cierre con tarjetas QR vectoriales para código y portal interactivo
#let ending-slide(
  title: [¡Muchas gracias por su atención!],
  subtitle: [Espacio para Preguntas, Discusión y Recursos Abiertos de la Investigación],
  repo-url: "https://github.com/vect-maker/movigo-analytics",
  doc-url: "https://github.com/vect-maker/movigo-analytics",
  config: (:),
) = touying-slide-wrapper(self => {
  let self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(
      fill: rgb("#ffffff"),
      margin: 0pt,
      header: none,
      footer: none,
    ),
  )

  let qr-card(url, card-title, desc, tag, tag-color: color-accent) = {
    box(
      fill: color-card-bg,
      stroke: 1.1pt + color-card-stroke,
      radius: 10pt,
      inset: (x: 14pt, y: 12pt),
      width: 380pt,
      grid(
        columns: (80pt, 1fr),
        gutter: 14pt,
        align: horizon,
        box(
          fill: white,
          radius: 8pt,
          stroke: 0.8pt + rgb("#cbd5e1"),
          inset: 6pt,
          qrcode(url, width: 72pt)
        ),
        align(left)[
          #box(
            fill: tag-color.lighten(88%),
            radius: 3pt,
            inset: (x: 6pt, y: 2.5pt),
            text(size: 7.8pt, weight: "bold", fill: tag-color, font: font-heading, tag)
          )
          #v(4pt)
          #text(size: 13pt, weight: "bold", fill: color-title, font: font-heading, card-title) \
          #v(3pt)
          #text(size: 9.5pt, fill: rgb("#475569"), font: font-body, desc)
        ]
      )
    )
  }

  touying-slide(
    self: self,
    config: config,
    [
      // Encabezado superior con gradiente
      #place(
        top + left,
        rect(
          width: 960pt,
          height: 180pt,
          fill: gradient.linear(color-title, rgb("#16324f"), angle: 20deg),
        )
      )
      #place(
        top + left,
        dy: 177pt,
        rect(
          width: 960pt,
          height: 3pt,
          fill: gradient.linear(color-accent, color-red),
        )
      )

      #place(
        top + left,
        dx: 60pt,
        dy: 46pt,
        block(
          width: 840pt,
          align(center,
            stack(
              spacing: 8pt,
              text(fill: white, size: 28pt, weight: "bold", font: font-heading, title),
              if subtitle != none [
                #text(fill: rgb("#cbd5e1"), size: 14pt, font: font-body, subtitle)
              ]
            )
          )
        )
      )

      #place(
        top + left,
        dx: 60pt,
        dy: 245pt,
        block(
          width: 840pt,
          align(center,
            stack(
              dir: ltr,
              spacing: 28pt,
              qr-card(
                repo-url,
                [Repositorio de Código],
                [Pipeline ELT en dbt Core, scripts de optimización en Python y compilación del paper Typst.],
                [CÓDIGO ABIERTO],
                tag-color: color-accent,
              ),
              qr-card(
                doc-url,
                [Documentación y Datos],
                [Catálogo de variables, tablas maestras del modelo Kimball y artefactos reproducibles.],
                [RECURSOS Y DATOS],
                tag-color: color-teal,
              ),
            )
          )
        )
      )
    ]
  )
})

/// Inicializador de tema maestro para MoviGo
#let movigo-theme(
  aspect-ratio: "16-9",
  ..args,
  body,
) = {
  set text(
    font: font-body,
    fill: color-body,
    size: 20pt,
    lang: "es",
  )

  set list(
    marker: ([•], [–], [·]),
    spacing: 1.0em,
  )

  show: touying-slides.with(
    config-page(
      width: 960pt,
      height: 540pt,
      margin: 0pt,
    ),
    config-common(slide-fn: slide),
    config-colors(
      primary: color-title,
      secondary: color-body,
    ),
    ..args,
  )

  body
}
