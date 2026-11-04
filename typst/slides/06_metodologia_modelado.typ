#import "template.typ": *
#import "components.typ": *
#import "../data_bindings.typ": (
  total-completions-fmt, regression-n-train, regression-n-test,
  m1-epochs, m2-epochs,
)

= Modelación numérica e integración con Scikit-Learn

#speaker-marker("B")

#v(2pt)

#grid(
  columns: (1.18fr, 1fr),
  gutter: 14pt,
  // Columna Izquierda: Bloque de Código de Producción con fuente ampliada
  [
    #block(
      width: 100%,
      height: 355pt,
      fill: rgb("#f8fafc"),
      stroke: 1.1pt + color-card-stroke,
      radius: 8pt,
      inset: (x: 12pt, y: 10pt),
      stack(
        dir: ttb,
        spacing: 6pt,
        grid(
          columns: (auto, 1fr, auto),
          gutter: 8pt,
          align: horizon,
          box(
            fill: color-title,
            radius: 3.5pt,
            inset: (x: 6pt, y: 3pt),
            text(size: 8pt, weight: "bold", fill: white, font: font-heading)[Scikit-Learn]
          ),
          text(size: 9.2pt, weight: "bold", fill: color-title, font: font-heading)[pipeline/analysis/01_regression.py],
          box(
            fill: color-accent.lighten(90%),
            radius: 3.5pt,
            inset: (x: 6pt, y: 2.5pt),
            text(size: 8pt, weight: "bold", fill: color-accent)[Python 3.12]
          )
        ),
        line(length: 100%, stroke: 0.6pt + color-card-stroke),
        v(2pt),
        [
          #set text(size: 9.1pt, font: ("Liberation Mono", "DejaVu Sans Mono"))
          #set par(leading: 0.38em)
          ```python
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import SGDRegressor
from sklearn.pipeline import Pipeline

# 1. Aislamiento analitico 80/20 determinista
X_tr, X_te, y_tr, y_te = train_test_split(
    df[["distance_km"]], df["target"], # duration o fare
    test_size=0.20,
    random_state=42
)

# 2. Pipeline con estandarizacion y SGDRegressor
pipeline = Pipeline([
    ("scaler", StandardScaler()),
    ("sgd", SGDRegressor(
        loss="squared_error",
        penalty=None,
        max_iter=2000,
        tol=1e-4,
        eta0=0.01,
        learning_rate="invscaling",
        random_state=42
    ))
])

# 3. Ajuste iterativo y prediccion fuera de muestra
pipeline.fit(X_tr, y_tr)
y_pred = pipeline.predict(X_te)
          ```
        ]
      )
    )
  ],
  // Columna Derecha: Explicación del Flujo y Desglose Detallado con tipografía ampliada
  [
    #stack(
      spacing: 11pt,
      // Tarjeta 1: Párrafo Explicativo del Flujo
      block(
        width: 100%,
        fill: color-card-bg,
        stroke: 1.1pt + color-card-stroke,
        radius: 8pt,
        inset: (x: 13pt, y: 11pt),
        stack(
          dir: ttb,
          spacing: 6pt,
          grid(
            columns: (24pt, 1fr),
            gutter: 9pt,
            align: horizon,
            box(
              fill: color-title,
              radius: 4pt,
              width: 24pt,
              height: 24pt,
              align(center + horizon, box(width: 16pt, slide-icons.activity))
            ),
            [
              #text(size: 12.2pt, weight: "bold", fill: color-title, font: font-heading)[Flujo y Propósito del Pipeline] \
              #text(size: 9.3pt, fill: color-accent, font: font-body)[Integración atómica sobre N = #total-completions-fmt viajes completados]
            ]
          ),
          line(length: 100%, stroke: 0.5pt + color-card-stroke),
          [
            #set text(size: 10.1pt, fill: color-body, font: font-body)
            #set par(leading: 0.42em)
            El fragmento implementa el flujo de aprendizaje automático enlazado a DuckDB. Encapsula en un objeto `Pipeline` la normalización $Z$-score y el descenso de gradiente estocástico, asegurando que los parámetros de escala ($mu, sigma$) se calculen estrictamente sobre el 80% de entrenamiento, blindando el modelo contra cualquier fuga de información (*data leakage*) hacia el conjunto de evaluación.
          ]
        )
      ),
      // Tarjeta 2: Desglose Detallado de Parámetros Utilizados
      block(
        width: 100%,
        fill: color-card-bg,
        stroke: 1.1pt + color-card-stroke,
        radius: 8pt,
        inset: (x: 13pt, y: 11pt),
        stack(
          dir: ttb,
          spacing: 6pt,
          grid(
            columns: (24pt, 1fr),
            gutter: 9pt,
            align: horizon,
            box(
              fill: color-accent,
              radius: 4pt,
              width: 24pt,
              height: 24pt,
              align(center + horizon, box(width: 16pt, slide-icons.sliders))
            ),
            [
              #text(size: 12.2pt, weight: "bold", fill: color-accent, font: font-heading)[Desglose de Hiperparámetros] \
              #text(size: 9.3pt, fill: color-slate-teal, font: font-body)[Parametrización técnica del optimizador y partición]
            ]
          ),
          line(length: 100%, stroke: 0.5pt + color-card-stroke),
          [
            #set text(size: 9.4pt, fill: color-body, font: font-body)
            #set par(leading: 0.38em)
            #list(
              spacing: 0.5em,
              [#text(weight: "bold", fill: color-title)[`test_size=0.20, random_state=42`:] Reserva fija de #regression-n-test viajes para contrastar generalización ciega.],
              [#text(weight: "bold", fill: color-title)[`StandardScaler()`:] Tipificación $Z$-score ($z = frac(x - mu, sigma)$) que regulariza la curvatura del gradiente.],
              [#text(weight: "bold", fill: color-title)[`loss="squared_error", penalty=None`:] Minimización pura de MSE sin regularización para estimadores insesgados.],
              [#text(weight: "bold", fill: color-title)[`learning_rate="invscaling", eta0=0.01`:] Tasa adaptativa con decaimiento inverso ($eta = eta_0 \/ t^(0.25)$) que previene oscilaciones.],
              [#text(weight: "bold", fill: color-title)[`tol=1e-4, max_iter=2000`:] Criterio de parada temprana alcanzado en solo #m2-epochs épocas (tarifa) y #m1-epochs (duración).],
            )
          ]
        )
      )
    )
  ]
)
