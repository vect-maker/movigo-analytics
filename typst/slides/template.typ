#import "@preview/touying:0.8.0": *
#import "@preview/ficons:0.1.0": make-icons
#import "@preview/tiaoma:0.3.0": qrcode

// ============================================================
// PALETA CROMÁTICA INSTITUCIONAL MAESTRA (TEAL & ESMERALDA)
// ============================================================
#let color-primary = rgb("#144e45")     // Teal Profundo / Bosque (títulos y primario)
#let color-title = color-primary
#let color-accent = rgb("#2a9d8f")      // Teal Vibrante / Esmeralda (énfasis y cifras)
#let color-mint = rgb("#52b69a")        // Menta Suave para contrastes bicromáticos
#let color-slate-teal = rgb("#264653")  // Pizarra Marina para soporte técnico
#let color-coral = rgb("#e76f51")       // Coral Cálido para alertas y cancelaciones
#let color-red = color-coral
#let color-teal = color-accent
#let color-card-bg = rgb("#f8faf9")     // Fondo de tarjetas tenue y limpio
#let color-card-stroke = rgb("#e2ece9") // Trazo capilar neutro suave
#let color-badge-bg = color-primary
#let color-badge-stroke = color-primary
#let color-body = rgb("#1e293b")        // Pizarra oscuro para lectura continua
#let color-muted = rgb("#64748b")       // Texto secundario y leyendas

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
  header: auto,
  footer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  let default-header(self) = {
    // Barra de acento superior vectorial
    place(
      top + left,
      rect(
        width: 960pt,
        height: 3.5pt,
        fill: gradient.linear(color-primary, color-accent, color-coral),
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

  let default-footer(self) = {
    place(
      bottom + right,
      dx: -60pt,
      dy: -18pt,
      text(size: 9pt, fill: color-muted, font: font-body)[
        #context utils.slide-counter.display("1 / 1", both: true)
      ]
    )
  }

  let active-header = if header == auto { default-header } else { header }
  let active-footer = if footer == auto { default-footer } else { footer }

  let self = utils.merge-dicts(
    self,
    config-page(
      fill: rgb("#ffffff"),
      header: active-header,
      footer: active-footer,
      margin: if active-header == none { (left: 60pt, right: 60pt, top: 48pt, bottom: 28pt) } else { (left: 60pt, right: 60pt, top: 78pt, bottom: 32pt) },
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

/// Diapositiva de portada institucional ejecutiva de alta precisión (inspirada en diseño Stitch)
#let title-slide(
  title: [Título de la Investigación],
  subtitle: none,
  authors: (),
  tutor: none,
  career: "Ingeniería en Ciencias de Datos",
  university: "UNAN-Managua",
  logo: "../assets/unan-logo.jpg",
  date: "Segundo Semestre • 2026",
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

  let author-card(num, name) = {
    box(
      fill: color-card-bg,
      stroke: 0.6pt + color-card-stroke,
      radius: 4pt,
      inset: (x: 14pt, y: 10pt),
      width: 100%,
      grid(
        columns: (22pt, 1fr),
        gutter: 10pt,
        align: horizon,
        box(
          fill: color-primary,
          radius: 3pt,
          width: 22pt,
          height: 22pt,
          align(center + horizon, text(fill: white, size: 8.5pt, weight: "bold", font: font-heading, num))
        ),
        text(size: 11pt, weight: "bold", fill: color-primary, font: font-heading, name)
      )
    )
  }

  touying-slide(
    self: self,
    config: config,
    {
      // 1. Columna lateral decorativa de acento fino en margen izquierdo
      place(
        top + left,
        rect(
          width: 8pt,
          height: 540pt,
          fill: gradient.linear(color-primary, color-mint),
        )
      )

      // 2. Lienzo principal estructurado
      place(
        top + left,
        dx: 48pt,
        dy: 46pt,
        block(
          width: 864pt,
          stack(
            spacing: 0pt,

            // CABECERA INSTITUCIONAL: ÚNICAMENTE EL LOGOTIPO OFICIAL (SIN BORDES NI SOMBRAS)
            if logo != none [
              #image(logo, height: 56pt)
            ],

            v(34pt),

            // SECCIÓN CENTRAL: TÍTULO COMPLETO A ANCHO TOTAL
            text(
              size: 27pt,
              weight: "bold",
              fill: color-primary,
              font: font-heading,
              title,
            ),

            v(44pt),
            line(length: 100%, stroke: 0.6pt + color-card-stroke),
            v(26pt),

            // SECCIÓN INFERIOR: METADATOS ACADÉMICOS (AUTORES DE LA INVESTIGACIÓN)
            stack(
              spacing: 10pt,
              grid(
                columns: (1fr, auto),
                text(size: 8.8pt, weight: "bold", fill: color-primary, font: font-heading)[
                  AUTORES DE LA INVESTIGACIÓN
                ],
                text(size: 8.2pt, fill: color-muted, font: font-body)[Ingeniería en Ciencias de Datos]
              ),
              grid(
                columns: (1fr, 1fr),
                gutter: 10pt,
                ..author-items.slice(0, calc.min(4, author-items.len())).enumerate().map(((idx, item)) => {
                  let num = "0" + str(idx + 1)
                  author-card(num, item)
                })
              )
            )
          )
        )
      )
    }
  )
})

/// Diapositiva de cierre con tarjeta QR para el código fuente de la investigación
#let ending-slide(
  title: [¡Muchas gracias por su atención!],
  subtitle: [Espacio para Preguntas, Discusión y Recursos Abiertos de la Investigación],
  repo-url: "https://github.com/vect-maker/movigo-analytics.git",
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
      radius: 12pt,
      inset: (x: 20pt, y: 16pt),
      width: 500pt,
      grid(
        columns: (94pt, 1fr),
        gutter: 18pt,
        align: horizon,
        box(
          fill: white,
          radius: 9pt,
          stroke: 0.8pt + color-card-stroke,
          inset: 7pt,
          qrcode(url, width: 86pt)
        ),
        align(left)[
          #box(
            fill: tag-color.lighten(88%),
            radius: 3.5pt,
            inset: (x: 8pt, y: 3pt),
            text(size: 8.5pt, weight: "bold", fill: tag-color, font: font-heading, tag)
          )
          #v(5pt)
          #text(size: 14.5pt, weight: "bold", fill: color-primary, font: font-heading, card-title) \
          #v(3pt)
          #text(size: 9.8pt, fill: color-body, font: font-body, desc) \
          #v(4pt)
          #text(size: 8.8pt, fill: color-accent, font: font-body)[#link(url)[#url]]
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
          fill: gradient.linear(color-primary, rgb("#1b5e54"), angle: 20deg),
        )
      )
      #place(
        top + left,
        dy: 177pt,
        rect(
          width: 960pt,
          height: 3pt,
          fill: gradient.linear(color-accent, color-coral),
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
                #text(fill: rgb("#d1fae5"), size: 14pt, font: font-body, subtitle)
              ]
            )
          )
        )
      )

      #place(
        top + left,
        dx: 60pt,
        dy: 240pt,
        block(
          width: 840pt,
          align(center,
            qr-card(
              repo-url,
              [Código Fuente y Pipeline],
              [Pipeline ELT en dbt Core, scripts de optimización en Python y compilación del artículo científico Typst.],
              [CÓDIGO FUENTE],
              tag-color: color-accent,
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
      primary: color-primary,
      secondary: color-body,
    ),
    ..args,
  )

  body
}
