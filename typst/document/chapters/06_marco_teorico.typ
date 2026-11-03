#show bibliography: none
#bibliography("../../references.bib")
#import "../../data_bindings.typ": total-trips-fmt, total-zones
#import "../../tables/index.typ": fig-strata-summary
#import "../../diagrams/index.typ": fig-pipeline-architecture

= Marco Teórico

== Arquitectura de Datos ELT, Modelado Dimensional Kimball y Validación de Calidad

Para analizar la movilidad urbana y la resiliencia operativa sobre volúmenes masivos de registros, la investigación adopta la ingeniería analítica contemporánea basada en el paradigma ELT (Extract, Load, Transform) @kimball2013. A diferencia del enfoque clásico ETL —donde los datos son transformados antes de su persistencia—, el flujo ELT desacopla la extracción y la carga de la fase de modelación analítica:

+ *Raw Layer en Azure PostgreSQL:* Las colecciones transaccionales se recuperan mediante cursor-based pagination y se serializan en archivos columnares Apache Parquet. Dichos datos se cargan en Azure Database for PostgreSQL bajo el esquema transaccional `raw` en Tercera Forma Normal (3NF), garantizando inmutabilidad y aislamiento frente a la fuente de origen.
+ *Transformación Declarativa con dbt Core:* La ingeniería analítica se orquesta mediante dbt en dos capas: staging layer (vistas lógicas puras) y marts layer (tablas físicas bajo un Star Schema optimizado para OLAP).

#fig-pipeline-architecture <fig-pipeline-architecture>

=== Principios del Modelado Dimensional Kimball

El diseño del almacén sigue rigurosamente los principios de Ralph Kimball @kimball2013, situando la transacción del viaje como el proceso de negocio atómico:

+ *Fact Table Atómica (`fct_viajes`):* Modela cada intento o solicitud de traslado registrado ($N = #total-trips-fmt$), fijando el grain al nivel más atómico del proceso operativo. Agrupa tanto métricas numéricas aditivas y continuas (distancia en km, duración en minutos, wait time, base fare, tarifa cobrada y surge multiplier) como indicadores lógicos de desenlace del servicio (`is_cancelled`, `is_cancelled_by_user`, `is_cancelled_by_driver`, `is_completed`).
+ *Conformed Dimensions y Jerarquía Territorial:* Aportan el contexto analítico y los atributos de filtrado:
  - `dim_zones`: Caracteriza las #total-zones zonas urbanas de Managua mediante su estratificación socioeconómica, coordenadas de centroide y base fare (@tbl-strata-summary; catálogo detallado en Apéndice B, @tbl-zones-catalog). Opera como role-playing dimension, enlazándose de forma simultánea con el cuadrante de origen (`sk_zone_origin`) y el cuadrante de destino (`sk_zone_destination`).
  - `dim_quadrants`: Contiene la discretización espacial celular en 298 cuadrantes territoriales, incorporando elevación topográfica y riesgo de exposición hidrológica ante cauces.
  - `dim_weather`: Registra las observaciones meteorológicas diarias (precipitación en milímetros, temperatura, estacionalidad climática y congestion index).
  - `dim_users` y `dim_drivers`: Agrupan atributos de comportamiento, modalidades vehiculares (`movigo_estandar`, `movigo_comfort`, `movigo_moto`) y tasas de retención.
  - `dim_campaigns`: Registra el catálogo de programas de incentivos y bonos para conductores.
+ *Surrogate Keys Determinísticas (MD5):* Para garantizar idempotencia e independencia frente a cambios en los identificadores del sistema origen, los enlaces dimensionales se resuelven mediante surrogate keys generadas como `md5(cast(id as text))`.

#fig-strata-summary <tbl-strata-summary>

=== Data Tests y Validación Automatizada de Calidad

La validez de los resultados analíticos depende de que la integridad del repositorio no sea supuesta, sino empíricamente demostrada. En el marco de dbt Core, la calidad de los datos se formaliza a través de cuatro data tests declarativos:
1. *Unicidad (`unique`):* Garantiza que las surrogate keys no presenten duplicación de registros en la fact table ni en las conformed dimensions.
2. *Completitud (`not_null`):* Verifica la ausencia de valores nulos en variables determinantes para los modelos (distancia, duración, tarifa final, surge multiplier y claves foráneas).
3. *Integridad Referencial (`relationships`):* Asegura que toda clave foránea en la fact table apunte de manera estricta a un registro existente en su conformed dimension padre, previniendo registros huérfanos.
4. *Restricción de Dominio (`accepted_values`):* Valida que los atributos categóricos contengan valores permitidos por el modelo de negocio (ej. estados de viaje válidos, surge multipliers no inferiores a $1.00times$).

=== Motor Analítico Columnar DuckDB

Para posibilitar un análisis exploratorio y econométrico de ultra baja latencia sin sobrecargar la infraestructura transaccional en la nube, el almacén dimensional validado es exportado como un snapshot inmutable a DuckDB. DuckDB opera como un motor columnar in-process que procesa consultas vectorizadas de forma local, permitiendo auditar la integridad y calcular agregaciones analíticas con tiempos de respuesta submilisegundo.

== Modelado Funcional de Movilidad, Optimización Numérica por Descenso de Gradiente (SGD) e Inferencia Estadística

Para cuantificar cómo las características físicas del traslado determinan la dinámica operativa y tarifaria de la plataforma, se postulan dos modelos funcionales de regresión lineal simple bivariada:
1. *Modelo de Duración:* Estima el tiempo de recorrido en minutos ($hat(y)_"min"$) a partir de la distancia física recorrida en kilómetros ($x$).
2. *Modelo de Tarifa:* Estima el precio cobrado en Córdobas ($hat(y)_"C$"$) a partir de la distancia física recorrida en kilómetros ($x$).

Formalmente, para un conjunto de observaciones $(x_i, y_i)_(i=1)^n$:

$ y_i = beta_0 + beta_1 x_i + epsilon_i, quad epsilon_i tilde.op cal(N)(0, sigma^2) $ <eq-regresion-simple>

donde $beta_0$ representa el costo fijo o tiempo inicial de arranque (intercepto) y $beta_1$ la tasa marginal de incremento por kilómetro adicional (pendiente).

=== Formulación del Problema de Optimización y Descenso de Gradiente Estocástico

La estimación de los parámetros óptimos $bold(beta) = [beta_0, beta_1]^T$ se formula como un problema de optimización convexa que minimiza la función de pérdida del Error Cuadrático Medio ($"MSE"$):

$ L(bold(beta)) = frac(1, 2n) sum_(i=1)^n (y_i - (beta_0 + beta_1 x_i))^2 $ <eq-loss-mse>

Frente al enfoque tradicional de inversión matricial de ecuaciones normales ($(X^T X)^(-1) X^T y$), el estudio implementa el algoritmo iterativo de *Descenso de Gradiente Estocástico (SGD)*. La regla de actualización paramétrica en la época $k+1$ se define como:

$ bold(beta)^((k+1)) = bold(beta)^((k)) - eta_k nabla L_i (bold(beta)^((k))) $ <eq-sgd-rule>

donde $eta_k$ es la tasa de aprendizaje sujeta a un esquema de decaimiento inverso (_inverse scaling_) para garantizar convergencia asintótica hacia el mínimo global sin oscilaciones:

$ eta_k = frac(eta_0, (1 + gamma dot k)^p) $ <eq-learning-rate>

Para acondicionar la superficie de pérdida y acelerar la convergencia, la variable predictora $x$ se somete a estandarización normal estándar ($z = (x - mu_x) \/ sigma_x$). Una vez alcanzada la convergencia bajo la tolerancia $\|bold(beta)^((k+1)) - bold(beta)^((k))\|_2 < "tol"$, los coeficientes obtenidos en escala estandarizada ($w_"scaled", b_"scaled"$) se des-escalan analíticamente a sus unidades físicas reales:

$ beta_1 = frac(w_"scaled", sigma_x), quad beta_0 = b_"scaled" - beta_1 mu_x $ <eq-unscaling>

=== Partición Metodológica y Evaluación de Generalización

Para prevenir el sobreajuste y contrastar objetivamente la capacidad predictiva del modelo, el censo de viajes completados se particiona en dos conjuntos disjuntos mediante muestreo aleatorio reproducible:
- *Conjunto de Entrenamiento (80%):* Empleado exclusivamente para el ajuste iterativo de los parámetros por SGD.
- *Conjunto de Prueba (20%):* Datos que el algoritmo nunca vio durante el ajuste, empleados para medir la generalización mediante métricas formales:
  - *Coeficiente de Determinación ($R^2$):* Cuantifica la proporción de varianza de la variable respuesta explicada por la distancia:
    $ R^2 = 1 - frac(sum_(i=1)^n (y_i - hat(y)_i)^2, sum_(i=1)^n (y_i - macron(y))^2) $
  - *Error Absoluto Medio (MAE):* Expresa el error promedio en unidades físicas directas (minutos o córdobas):
    $ "MAE" = frac(1, n) sum_(i=1)^n |y_i - hat(y)_i| $
  - *Raíz del Error Cuadrático Medio (RMSE):* Penaliza con mayor severidad las desviaciones atípicas de magnitud extrema:
    $ "RMSE" = sqrt(frac(1, n) sum_(i=1)^n (y_i - hat(y)_i)^2) $

=== Inferencia Estadística y Bandas de Confianza al 95%

Para cuantificar la incertidumbre muestral de los estimadores, la teoría estadística asume que bajo el Teorema del Límite Central y grandes volúmenes muestrales ($N_"train" > 39,000$), los estimadores de mínimos cuadrados convergen asintóticamente hacia una distribución normal. La matriz de varianza-covarianza paramétrica se calcula como:

$ "Var"(hat(bold(beta))) = sigma^2 (X^T X)^(-1) $ <eq-var-covar>

donde la varianza residual insesgada del modelo se define a través de los grados de libertad residuales ($n - p$, con $p = 2$):

$ hat(sigma)^2 = frac(sum_(i=1)^n (y_i - hat(y)_i)^2, n - p) $ <eq-sigma2>

El error estándar del coeficiente corresponde a $"SE"(hat(beta)_j) = sqrt(hat(sigma)^2 [(X^T X)^(-1)]_(j j))$. En consecuencia, el intervalo de confianza al 95% para cada parámetro estructural se deduce formalmente como:

$ "IC"_(95%) (beta_j) = [hat(beta)_j - 1.96 dot "SE"(hat(beta)_j), quad hat(beta)_j + 1.96 dot "SE"(hat(beta)_j)] $ <eq-ci-95>

== Teoría de Grafos Espaciales, Topología Vial y Ruteo Prescriptivo de Caminos Mínimos

La estimación bivariada de duración y costo asume implícitamente una ciudad homogénea; sin embargo, en la práctica el tiempo de traslado depende de la configuración topológica de la red vial urbana y de su vulnerabilidad ante perturbaciones exógenas.

=== Modelado Topológico Jerárquico de la Red Vial

La infraestructura territorial y la movilidad de Managua se formalizan como una red espacial jerárquica de dos niveles:
1. *Red Física Densa de Vías Urbanas ($G_"street" = (V_s, E_s)$):* Extraída del repositorio geográfico OpenStreetMap, integrada por $|V_s| = 69,695$ nodos de intersección y $|E_s| = 80,287$ tramos viales calibrados según su jerarquía funcional (autopistas, arterias principales, colectores y vías residenciales).
2. *Red Celular Territorial ($G_"cell" = (V_c, E_c)$):* Malla de 298 cuadrantes (`dim_quadrants`) y 1,072 conexiones contiguas en 24 zonas analíticas, articulada con el Star Schema dimensional para el análisis agregado de flujos origen-destino y centralidad.

=== Función de Impedancia Temporal y Modelo de Anegamiento Pluvial

Cada tramo vial $(i, j) in E_s$ posee una función de impedancia temporal generalizada $tau_(i j)$ que cuantifica el costo de cruce en minutos a partir de su longitud física real $d_(i j)$:

$ tau_(i j) = frac(d_(i j), v_(i j) (c)) dot 60 $

donde $v_(i j)(c)$ representa la velocidad efectiva de circulación condicionada por la jerarquía de la vía y el régimen meteorológico $c in {"seco", "tormenta"}$.

Para incorporar el riesgo hidrológico, se define una zona de influencia geométrica (buffer de 50 metros) alrededor de los 485 cauces pluviales de Managua. Cuando un tramo vial es interceptado por un cauce desbordado durante una tormenta, su velocidad experimenta un colapso inducido:

$ v_(i j) (c) = v_(0, "vía") dot (1 - 0.75 dot bb(I)_"anegamiento") $

=== Diagnóstico de Vulnerabilidad mediante Betweenness Centrality

Para identificar los puntos críticos de estrangulamiento donde el sistema de transporte es susceptible de colapsar, se calcula la métrica de Betweenness Centrality sobre los pares origen-destino de la red:

$ C_B (v) = sum_(s eq.not v eq.not t) frac(sigma_(s t)(v), sigma_(s t)) $ <eq-betweenness>

donde $sigma_(s t)$ representa el número total de caminos mínimos entre el origen $s$ y el destino $t$, y $sigma_(s t)(v)$ es la cantidad de dichos caminos que atraviesan forzosamente el vértice $v$. Nodos con alto $C_B$ constituyen cuellos de botella sistémicos donde cualquier perturbación climática propaga retrasos masivos a toda la capital.

=== Auditoría de Ruteo Black-Box y Algoritmo de Dijkstra

Dado que el algoritmo comercial de despacho y ruteo de MoviGo es propietario y cerrado (black-box), su comportamiento se audita contrastando las trayectorias reales observadas en el censo analítico frente a un óptimo prescriptivo calculado mediante el Algoritmo de Dijkstra sobre la red vial ponderada.

El algoritmo resuelve el problema del camino más corto aplicando iterativamente la regla de relajación de aristas:

$ "dist"[j] = min("dist"[j], "dist"[i] + tau_(i j)) $

Dijkstra determina la ruta de mínima impedancia capaz de circunnavegar activamente los tramos anegados por cauces desbordados. La ineficiencia del ruteo observado de MoviGo frente al óptimo prescriptivo se cuantifica mediante el *Índice de Sub-optimización* ($rho$) y el ahorro temporal neto ($Delta T$):

$ rho = frac(t_"real", t_"óptimo"), quad Delta T = t_"real" - t_"óptimo" $

=== Métricas Macroscópicas de Red: Diámetro y Tortuosidad

Para evaluar la degradación estructural de la red metropolitana bajo choques pluviales, se monitorean dos indicadores globales:
- *Diámetro de la Red ($D$):* Longitud temporal del camino mínimo más largo entre todos los pares origen-destino conectados ($D = max_(s, t) d(s, t)$), cuantificando la máxima separación de tiempo en la ciudad.
- *Tortuosidad de Ruta ($T$):* Razón entre la longitud física real de la trayectoria recorrida y la distancia geodésica euclidiana directa ($T = d_"recorrida" \/ d_"euclidiana"$), reflejando el grado de desvío forzado que impone la infraestructura o la inundación de cauces.

== Arquitectura DataOps y Reproducibilidad Computacional

El marco analítico y científico del proyecto se sustenta en los principios de automatización, trazabilidad e inmutabilidad propios de la cultura DataOps en entornos Linux:
- *Orquestación Declarativa vía `justfile`:* Automatiza la ejecución determinística del flujo completo (`just fetch-data`, `just dbt-run`, `just run-regression`, `just run-optimization`, `just build-doc`).
- *Shell Scripting Profesional en Bash:* Implementación de scripts de ingesta y snapshot bajo directivas estrictas de ejecución (`set -euo pipefail`), asegurando interrupción inmediata ante inconsistencias.
- *Paradigma Data-to-Document en Typst:* El artículo científico no contiene valores numéricos estáticos transcritos manualmente. Todas las métricas del censo, parámetros de regresión, intervalos de confianza y tiempos de ruteo se cargan en tiempo de compilación desde contratos de datos en archivos JSON (`typst/data/`), garantizando consistencia absoluta y cero deriva humana (*zero human drift*).
