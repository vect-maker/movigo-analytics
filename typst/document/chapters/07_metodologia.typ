#show bibliography: none
#bibliography("../../references.bib")
#import "../../tables/index.typ": fig-variables-operationalization
#import "../../diagrams/index.typ": fig-dbt-lineage, fig-star-schema
#import "../../data_bindings.typ": total-trips-fmt, total-zones, total-campaigns
#import "../../metadata.typ": repo-url

= Diseño Metodológico

El diseño metodológico establece la secuencia técnica, analítica y computacional estructurada para dar cumplimiento a los objetivos de la investigación, articulando la ingeniería de datos bajo modelado dimensional Kimball y la optimización prescriptiva de la red vial en redes espaciales.

== Enfoque, Tipo y Alcance

*Enfoque metodológico mixto:* De acuerdo con la tipología metodológica de @sampieri2014, la investigación adopta un enfoque mixto con claro predominio cuantitativo. En él converge el rigor formal del modelado analítico dimensional y la optimización algorítmica de redes espaciales sobre el censo cerrado de $N = #total-trips-fmt$ operaciones transaccionales, complementado con el análisis cualitativo y contextual de la estratificación socioespacial, la infraestructura urbana y la vulnerabilidad histórica ante anegamientos en el municipio de Managua.

*Diseño observacional y longitudinal:* El estudio se sustenta en un diseño no experimental y longitudinal, observando transacciones operativas y registros meteorológicos a lo largo del ciclo anual 2024 ($n = 366$ días) sin manipulación deliberada ni intervención exógena sobre las variables del sistema de transporte.

*Alcance investigativo multidimensional:* La investigación articula simultáneamente tres alcances: descriptivo, al caracterizar los patrones empíricos de asignación, espera y cancelación; explicativo, al cuantificar mediante modelos funcionales e inferencia estadística el impacto de la distancia sobre la duración y la tarifa; y prescriptivo, al formular estrategias óptimas de ruteo y resiliencia vial ante contingencias meteorológicas mediante algoritmos de caminos mínimos.

*Unidad de análisis:* La unidad de observación corresponde al viaje individual o solicitud de servicio ($N = #total-trips-fmt$ registros), caracterizado por sus coordenadas geográficas de origen y destino, su marca temporal precisa, el multiplicador dinámico aplicado, el régimen meteorológico concurrente y el desenlace operativo de atención o abandono. A fin de formalizar las dimensiones analíticas, la @tbl-variables-operationalization detalla la matriz metodológica de operacionalización de variables del estudio.

#fig-variables-operationalization <tbl-variables-operationalization>

== Fases Metodológicas de la Investigación

=== Fase 1: Pipeline de Datos ELT, Procesamiento y Esquema en Estrella (Objetivo 1)

Los datos primarios de la investigación provienen de una API REST que expone un entorno de simulación sintética de alta fidelidad, diseñado específicamente para emular de manera fidedigna la dinámica transaccional, operativa y espacial de una plataforma de transporte selectivo metropolitana en Managua. Para asegurar la reproducibilidad científica estricta y la trazabilidad de los hallazgos, la extracción se delimitó al censo anual cerrado de 2024 ($N = #total-trips-fmt$ operaciones).

Para consolidar el repositorio analítico a partir de las fuentes desacopladas de la API, se ejecutó un pipeline integral bajo el paradigma ELT (Extract, Load, Transform) articulado a través de dbt Core y Azure PostgreSQL, cuyo linaje y transformaciones dimensionales se ilustran en la @fig-dbt-lineage.

#fig-dbt-lineage <fig-dbt-lineage>

*Extracción e inmutabilidad columnar:* El consumo sistemático de los endpoints de la API REST se realiza mediante un cliente en Python (`fetcher.py`) con control dinámico de paginación (`limit=200`, `offset`). Los conjuntos recuperados se serializan en siete archivos columnares Apache Parquet (`pipeline/data/raw/*.parquet`: zonas, usuarios, conductores, campañas, clima, viajes y telemetría), garantizando inmutabilidad, compresión volumétrica y desacoplamiento de la red.

*Ingestión en Raw Layer:* La carga inicial materializa el esquema relacional DDL estricto (`raw_schema.sql`, @lst-ddl) en el esquema `raw` de Azure Database for PostgreSQL. El cargador automatizado (`loader.py`, @lst-loader) aplica casteo de marcas temporales, establece conexión cifrada TLS/SSL y ejecuta inserciones por bloques de 2,000 registros respetando el orden topológico de restricciones relacionales.

*Transformación y estandarización en Staging Layer:* Sobre la capa transaccional se implementan modelos intermedios en dbt Core materializados como vistas lógicas 1:1 puras (`view`) bajo la capa `staging` (@fig-dbt-lineage). En esta etapa se descartan dependencias cruzadas, se estandariza la nomenclatura técnica canónica en inglés y se realiza tipificación formal estructurada en tres dominios operativos diferenciados:

*Dominio transaccional y tarifario en Staging:* En las vistas `stg_trips`, `stg_trip_payments` y `stg_trip_cancellations` se ejecuta la extracción y casteo de identificadores de entidades (`trip_id`, `user_id`, `driver_id`), componentes temporales y de calendario (`request_date`, `request_hour`, `is_peak_hour`, `is_weekend`), métricas operativas de distancia y duración, descomposición analítica de la tarifa (`base_fare`, `surge_multiplier`, `final_fare`), wait time en minutos hasta el abandono (`wait_time_minutes`) y binarización determinística del resultado del servicio (`is_cancelled`, `is_completed`).

*Dominio territorial y meteorológico en Staging:* A través de `stg_urban_zones` y `stg_quadrants` se normaliza la división administrativa de las 24 zonas de Managua y la discretización espacial en 298 cuadrantes con cota altimétrica y riesgo de inundación. De forma concurrente, `stg_weather_daily` consolida la serie meteorológica diaria, clasificando la intensidad pluvial e incorporando el índice exógeno de congestión vehicular (`congestion_index`).

*Dominio de actores e incentivos en Staging:* Los modelos `stg_users`, `stg_drivers`, `stg_vehicles` y `stg_campaigns` homogeneizan el perfil socioeconómico de los usuarios, el estado del parque vehicular con su historial de mantenimiento y los esquemas presupuestarios de bonos para conductores.

*Estructuración dimensional en Marts Layer y Star Schema:* La etapa analítica superior consolida los datos bajo la metodología dimensional de Ralph Kimball @kimball2013, materializando físicamente tablas (`table`) optimizadas para cargas de trabajo OLAP (@fig-dbt-lineage y @fig-star-schema). La Fact Table atómica (`fct_viajes`, @lst-fct-viajes) preserva el grain fundamental de una fila por solicitud ($N = #total-trips-fmt$). Integra métricas operacionales de tiempo, distancia y recargo dinámico, junto con la variable respuesta de cancelación y surrogate keys conformadas generadas mediante la función `md5(cast(id as text))` (`sk_trip`, `sk_zone_origin`, `sk_zone_destination`, `sk_driver`, `sk_user`, `sk_weather`). Dichas llaves foráneas se acoplan con las conformed dimensions (`dim_zones`, `dim_quadrants`, `dim_weather`, `dim_users`, `dim_drivers`, `dim_campaigns`), destacando `dim_zones` como role-playing dimension para fijar el estrato socioeconómico de origen y el radio territorial del destino (@tbl-star-schema).

*Barrera de calidad declarativa con Data Tests:* La integridad del repositorio dimensional se salvaguarda mediante pruebas automáticas en `sources.yml`, `_staging__models.yml` y `_marts__models.yml` evaluadas con `dbt test` (@lst-dbt-marts). El marco valida la unicidad (`unique`) y completitud (`not_null`) de todas las llaves surrogadas, la integridad referencial cruzada (`relationships`) entre la tabla de hechos y sus dimensiones conformadas, y la no nulidad obligatoria en la variable dependiente de cancelación (`is_cancelled`).

*Análisis de densidad espacial y distribución urbana:* La captura granular de coordenadas geográficas en origen y destino permite proyectar el universo transaccional sobre la malla urbana de Managua mediante un mapa base arterial de OpenStreetMap (@fig-trip-origins-density), revelando los patrones de concentración espacial en polos comerciales centrales frente a la dispersión de puntos de abandono en cuadrantes periféricos.

=== Fase 2: Modelado de Regresión Simple vía Descenso de Gradiente e Inferencia al 95% (Objetivo 2)

Para modelar analíticamente la dinámica operativa y comercial del servicio a partir del censo analítico depurado, se formula un esquema de regresión lineal simple bivariada resuelto mediante optimización numérica iterativa e inferencia estadística:

*Partición y aislamiento analítico (80% Train / 20% Test):* Sobre el universo de viajes completados con telemetría válida ($N = 49,049$), se realiza una partición analítica estricta con generador pseudoaleatorio determinista (`random_state=42`) sin reposición. El conjunto de entrenamiento ($N_"train" = 39,239$ viajes, 80%) se destina con exclusividad al ajuste de coeficientes paramétricos, mientras que el conjunto de prueba ($N_"test" = 9,810$ viajes, 20%) permanece estrictamente aislado para evaluar la generalización fuera de muestra mediante el Coeficiente de Determinación ($R^2$), el Error Absoluto Medio ($"MAE"$) y la Raíz del Error Cuadrático Medio ($"RMSE"$).

*Formulación funcional de los modelos:* Se definen dos formulaciones bivariadas complementarias: el Modelo Operativo de Tiempo de Viaje ($"duracion_minutos" = f("distance_km")$), orientado a estimar la duración prevista del recorrido (ETA) a partir de la distancia física; y el Modelo Económico de Tarificación ($"final_fare" = f("distance_km")$), orientado a modelar el cobro final facturado en Córdobas en función del trayecto.

*Optimización numérica mediante Descenso de Gradiente Estocástico (SGD):* El aprendizaje de parámetros minimiza iterativamente la función de pérdida del Error Cuadrático Medio ($"loss" = "squared_error"$). Para acondicionar la curvatura de la superficie de pérdida y acelerar la convergencia, la distancia se estandariza mediante tipificación $Z$ (`StandardScaler`). El optimizador opera con una tasa de aprendizaje con decaimiento inverso (`invscaling`, $eta_0 = 0.01$, $"power_t" = 0.25$) y umbral de parada $"tol" = 10^(-4)$, alcanzando convergencia en pocas épocas (13 épocas para Duración y 10 para Tarifa), tras lo cual los estimadores se des-escalan analíticamente a sus unidades físicas originales.

*Inferencia estadística e intervalos de confianza paramétricos al 95%:* La significancia y precisión de las pendientes e interceptos se determina calculando la matriz de varianza-covarianza asintótica $sigma^2 (X^T X)^(-1)$ sobre los datos de entrenamiento. A partir de los errores estándar de los estimadores se calculan intervalos de confianza al 95% ($z_(0.025) = 1.96$), confirmando la robustez y estabilidad de los efectos analizados.

=== Fase 3: Modelado de Redes Espaciales y Auditoría Algorítmica de Ruteo (Objetivo 3)

La evaluación prescriptiva del sistema y la auditoría de la caja negra de la plataforma ante contingencias meteorológicas se ejecuta sobre la infraestructura vial metropolitana:

*Topología jerárquica de la red espacial:* La trama física se modela como un grafo dirigido ponderado extraído de OpenStreetMap, comprendiendo 69,695 nodos viales y 80,287 aristas viales. Dicha red se conecta a la partición de 298 cuadrantes urbanos (`dim_quadrants`) y 24 zonas analíticas, integrando la hidrografía de los 485 cauces pluviales metropolitanos.

*Función de costo de impedancia dinámica:* La resistencia vial en cada arista se calcula mediante el tiempo de desplazamiento $tau_(i j) = frac(d_(i j), v_(i j)) dot 60$, determinado por las distancias euclidianas viales y las velocidades reglamentarias de la jerarquía vial. En escenarios lluviosos, se incorporan penalizaciones por anegamiento derivadas de `quadrant_weather` sobre los tramos viales interceptados por cauces desbordados.

*Auditoría algorítmica vectorizada vía Dijkstra:* Se implementa el algoritmo de caminos mínimos de Dijkstra mediante matrices dispersas CSR (`scipy.sparse.csgraph.dijkstra`), evaluando de manera sistemática los 552 pares origen-destino metropolitanos en condición basal seca y de tormenta. Las trayectorias prescriptivas óptimas se contrastan frente a los trayectos observados de MoviGo en `fct_viajes` para medir ahorros temporales ($Delta T$) y mitigación del detonante de cancelaciones.

*Centralidad de intermediación y detección de cuellos de botella:* Finalmente, se computa la centralidad de intermediación $C_B(v)$ sobre la red territorial para diagnosticar la criticidad estructural y la redistribución del tráfico ante inundaciones urbanas.

== Ecosistema Computacional y Flujo de Reproducibilidad (DuckDB, Python y Typst)

Para asegurar la validez metodológica y la reproducibilidad científica estricta de los resultados, la fase final de análisis empírico y generación de evidencia desacopla y articula tres tecnologías complementarias bajo el paradigma _Data-to-Document_:

*Análisis exploratorio y consultas analíticas en DuckDB CLI:* Para la exploración multidimensional y la síntesis de agregaciones sobre los #total-trips-fmt registros, se utiliza DuckDB CLI. Su motor columnar en proceso permite procesar analítica OLAP de alto rendimiento con latencias de milisegundos directamente sobre el repositorio de datos. Desde DuckDB se extraen las agregaciones espaciotemporales consolidadas (distribución de cancelaciones por estrato, franja horaria y condición meteorológica), las cuales se exportan de forma automatizada hacia artefactos estructurados en formato `.json`.

*Modelado y optimización numérica en Python:* El cálculo cuantitativo especializado se implementa a través de scripts modulares en Python apoyados en bibliotecas de cómputo científico (`scikit-learn`, `networkx`, `scipy`, `matplotlib`). Este entorno recibe las tablas depuradas para entrenar los modelos SGD con intervalos de confianza al 95% (Fase 2) y resolver las matrices de impedancia y optimización de caminos mínimos con Dijkstra (Fase 3).

*Renderizado programático y trazabilidad determinista en Typst:* La integración de Typst como motor tipográfico trasciende la edición tradicional al operar como un compilador dinámico enlazado a los datos. Typst consume directamente los archivos `.json` generados por DuckDB y los parámetros cuantitativos calculados por Python mediante funciones nativas de ingesta (`#json(...)`), sintetizando las tablas analíticas, indicadores cuantitativos y visualizaciones en tiempo de compilación (`just build-doc`). Esta arquitectura programática establece una fuente única de verdad (_single source of truth_), eliminando el riesgo de transcripción manual o desalineación de cifras (_human drift_), y asegurando que toda actualización en los modelos se refleje de manera inmediata, exacta y determinística en el documento final.

== Disponibilidad de Código, Datos y Reproducibilidad

En concordancia con los principios de reproducibilidad científica y ciencia abierta, la totalidad de los artefactos computacionales de la investigación (incluyendo los scripts de extracción y carga, las definiciones DDL y transformaciones en dbt Core, el almacén de datos columnar en DuckDB, los scripts de modelación y optimización en Python, así como los archivos fuentes de maquetación y generación de figuras en Typst) se encuentran versionados y disponibles públicamente en el repositorio oficial del proyecto @movigo2024repo (#link(repo-url)).
