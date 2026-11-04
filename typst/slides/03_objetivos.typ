#import "template.typ": *
#import "components.typ": *

#slide(header: none)[
  #speaker-marker("A", dx: 38pt, dy: -26pt)

  // Decoración suave en el margen izquierdo inspirado en el diseño de referencia
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

  #v(18pt)

  // Fila superior: Título prominente a la izquierda y Objetivo General a la derecha
  #grid(
    columns: (1fr, 430pt),
    gutter: 20pt,
    align: (left + horizon, right + horizon),
    [
      #text(size: 48pt, weight: "bold", font: font-heading)[
        #text(fill: color-primary)[Objet]#text(fill: color-mint)[ivos]
      ]
    ],
    [
      #align(right)[
        #block(width: 420pt)[
          #set par(leading: 0.44em, justify: false)
          #text(size: 13.5pt, weight: "bold", fill: color-accent, font: font-heading)[
            Diseñar e implementar un pipeline de datos, modelos numéricos y algoritmos de ruteo para la optimización operativa de la red MoviGo en el municipio de Managua durante el año 2024.
          ]
        ]
      ]
    ]
  )

  #v(48pt)

  // Fila inferior: Tres columnas con números grandes y objetivos específicos
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 34pt,
    align: top + left,
    // Columna 1
    [
      #text(size: 42pt, weight: "bold", fill: color-accent, font: font-heading)[1.]
      #v(8pt)
      #par(leading: 0.46em)[
        #text(size: 11.5pt, fill: color-body, font: font-body)[
          *Consolidar* un repositorio analítico multidimensional a partir de los registros operativos del servicio mediante un flujo de extracción, carga y transformación para la integración y explotación de los datos transaccionales.
        ]
      ]
    ],
    // Columna 2
    [
      #text(size: 42pt, weight: "bold", fill: color-accent, font: font-heading)[2.]
      #v(8pt)
      #par(leading: 0.46em)[
        #text(size: 11.5pt, fill: color-body, font: font-body)[
          *Modelar* las relaciones funcionales operativas y tarifarias del servicio mediante algoritmos de optimización por descenso de gradiente e inferencia paramétrica para cuantificar el impacto de la distancia en la duración y el costo del viaje.
        ]
      ]
    ],
    // Columna 3
    [
      #text(size: 42pt, weight: "bold", fill: color-accent, font: font-heading)[3.]
      #v(8pt)
      #par(leading: 0.46em)[
        #text(size: 11.5pt, fill: color-body, font: font-body)[
          *Optimizar* las trayectorias de desplazamiento y la resiliencia de la red vial metropolitana mediante modelos de redes espaciales y algoritmos de camino mínimo ante perturbaciones meteorológicas y cuellos de botella urbanos.
        ]
      ]
    ]
  )
]
