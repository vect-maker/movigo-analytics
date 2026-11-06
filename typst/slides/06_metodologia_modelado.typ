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
  columns: (1.15fr, 1fr),
  gutter: 14pt,
  // Columna Izquierda: Código Python de Producción con tipografía ampliada
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
          #set text(size: 11pt, font: ("Liberation Mono", "DejaVu Sans Mono"))
          #set par(leading: 0.44em)
          ```python
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import SGDRegressor
from sklearn.pipeline import Pipeline

# 1. Aislamiento analitico 80/20 determinista
X_tr, X_te, y_tr, y_te = train_test_split(
    df[["distance_km"]], df["target"],
    test_size=0.20, random_state=42
)

# 2. Pipeline con estandarizacion y SGD
pipeline = Pipeline([
    ("scaler", StandardScaler()),
    ("sgd", SGDRegressor(penalty=None, random_state=42))
])

# 3. Ajuste iterativo y prediccion
pipeline.fit(X_tr, y_tr)
y_pred = pipeline.predict(X_te)
          ```
        ]
      )
    )
  ],
  // Columna Derecha: Lógica de Fórmulas en Pseudocódigo en Inglés
  [
    #stack(
      spacing: 10pt,
      // Tarjeta 1: Aislamiento y Blindaje del Flujo
      block(
        width: 100%,
        height: 112pt,
        fill: color-card-bg,
        stroke: 1.1pt + color-card-stroke,
        radius: 8pt,
        inset: (x: 12pt, y: 9pt),
        stack(
          dir: ttb,
          spacing: 5pt,
          grid(
            columns: (22pt, 1fr),
            gutter: 8pt,
            align: horizon,
            box(
              fill: color-title,
              radius: 4pt,
              width: 22pt,
              height: 22pt,
              align(center + horizon, box(width: 14pt, slide-icons.activity))
            ),
            [
              #text(size: 11.5pt, weight: "bold", fill: color-title, font: font-heading)[Aislamiento y Blindaje del Flujo] \
              #text(size: 8.5pt, fill: color-accent, font: font-body)[#regression-n-train viajes entrenamiento (80%) / #regression-n-test prueba (20%)]
            ]
          ),
          line(length: 100%, stroke: 0.5pt + color-card-stroke),
          [
            #set text(size: 9.3pt, fill: color-body, font: font-body)
            #set par(leading: 0.38em)
            El objeto `Pipeline` encapsula la estandarización y el optimizador SGD. Garantiza que la media y la desviación estándar se calculen exclusivamente sobre el conjunto de entrenamiento, eliminando cualquier riesgo de fuga de datos (*data leakage*) hacia la evaluación.
          ]
        )
      ),
      // Tarjeta 2: Fórmulas en Pseudocódigo (Palabras en inglés sin símbolos matemáticos)
      block(
        width: 100%,
        height: 233pt,
        fill: color-card-bg,
        stroke: (left: 3.5pt + color-accent, rest: 1pt + color-card-stroke),
        radius: 8pt,
        inset: (x: 12pt, y: 9pt),
        stack(
          dir: ttb,
          spacing: 5pt,
          grid(
            columns: (22pt, 1fr),
            gutter: 8pt,
            align: horizon,
            box(
              fill: color-accent,
              radius: 4pt,
              width: 22pt,
              height: 22pt,
              align(center + horizon, box(width: 14pt, slide-icons.code))
            ),
            [
              #text(size: 11.5pt, weight: "bold", fill: color-accent, font: font-heading)[Lógica de Fórmulas en Pseudocódigo] \
              #text(size: 8.5pt, fill: color-muted, font: font-body)[Equivalencias algorítmicas sin abstracción matemática]
            ]
          ),
          line(length: 100%, stroke: 0.5pt + color-card-stroke),
          v(2pt),
          // Bloque de Pseudocódigo con palabras en inglés
          block(
            width: 100%,
            fill: white,
            stroke: 0.8pt + color-card-stroke,
            radius: 5pt,
            inset: (x: 9pt, y: 7pt),
            [
              #set text(size: 9.3pt, font: ("Liberation Mono", "DejaVu Sans Mono"))
              #set par(leading: 0.36em)
              ```python
# 1. StandardScaler
scaled_value = (value - mean) / standard_deviation

# 2. invscaling (Adaptive Learning Rate)
learning_rate = initial_rate / (step ** 0.25)

# 3. SGD Parameter Update Rule
new_weight = old_weight - learning_rate * gradient
              ```
            ]
          ),
          v(2pt),
          [
            #set text(size: 8.8pt, fill: color-body, font: font-body)
            #set par(leading: 0.34em)
            #list(
              spacing: 0.45em,
              [#text(weight: "bold", fill: color-title)[`StandardScaler`:] Transforma la escala a media cero y varianza unitaria para acondicionar la superficie de error.],
              [#text(weight: "bold", fill: color-title)[`invscaling`:] Reduce el paso en cada iteración (`step`), garantizando convergencia suave sin oscilar.],
              [#text(weight: "bold", fill: color-title)[Convergencia SGD:] Criterio de parada temprana alcanzado en solo #m2-epochs épocas (tarifa) y #m1-epochs (duración) con defaults de Scikit-Learn.],
            )
          ]
        )
      )
    )
  ]
)
