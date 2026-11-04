#show bibliography: none
#bibliography("../../references.bib")

#import "../../data_bindings.typ": (
  total-trips-fmt, total-cancellations-fmt, total-completions-fmt, cancellation-rate, avg-surge,
  avg-final-fare, avg-distance-km, avg-wait-time-min, total-users, total-drivers, total-zones,
  total-quadrants, total-weather-days, total-weather-observations-fmt, total-campaigns, dbt-total-tests, dbt-staging-models,
  dbt-mart-models, dbt-tests-unique, dbt-tests-not-null, dbt-tests-relationships,
  dbt-tests-accepted-values, inv-integrity, regression-n-total, regression-n-train, regression-n-test,
  m1-b0, m1-b1, m1-r2, m1-r2-train, m1-mae, m1-rmse, m1-ci-b1-low, m1-ci-b1-upp, m1-epochs,
  m2-b0, m2-b1, m2-r2, m2-r2-train, m2-mae, m2-rmse, m2-ci-b1-low, m2-ci-b1-upp, m2-epochs,
  sgd-eta0, dist-mean-km, dur-skew, fare-skew, surge-mean-completed, flag-drop-min, flag-drop-max,
  fmt-dec, predict, routing-nodes, routing-edges, routing-speed-dry, routing-speed-storm,
)
#import "../../diagrams/star_schema.typ": fig-star-schema
#import "../../tables/index.typ": (
  fig-data-inventory, fig-general-kpis, fig-regression-summary,
)
#import "../../graphs/index.typ": (
  fig-trip-origins-density, fig-numerical-duration, fig-numerical-fare, fig-urban-network-dijkstra,
)
#import "../../snippets.typ": fig-dbt-integrity, fig-duckdb-kpis

= Resultados y Discusión

La investigación partió de una pregunta concreta: de qué manera un repositorio analítico multidimensional y la optimización espacial de la red vial permiten cuantificar los estrangulamientos de MoviGo y mitigar sus demoras ante contingencias climáticas. Responderla exigió recorrer tres tramos que no son independientes. El primero convierte #total-trips-fmt solicitudes dispersas en un repositorio auditable. El segundo mide hasta dónde la distancia explica el tiempo y el precio de un viaje. El tercero busca en la geografía urbana los puntos donde el sistema pierde tiempo. Cada tramo prepara al siguiente: sin un dato confiable no hay modelo que signifique algo; sin un modelo de tiempo y costo no se sabe qué buscar en la red; sin el mapa de la red, el promedio urbano oculta dónde se concentra el problema. El capítulo sigue ese recorrido y discute, en el mismo movimiento, lo que cada resultado permite afirmar y lo que deja fuera.

== El repositorio: convertir registros dispersos en una base confiable (Objetivo 1)

El primer objetivo específico consistió en consolidar un repositorio analítico multidimensional a partir de los registros operativos del servicio. La tarea suele describirse como infraestructura, pero define el alcance de todo lo que sigue: un repositorio mal integrado produce promedios que parecen ciertos y coeficientes que no resisten la auditoría. Por eso el trabajo no terminó cuando los datos estuvieron cargados; terminó cuando cada cifra pudo rastrearse hasta su origen.

=== La arquitectura que hace posible la consulta

Las fuentes llegaron separadas. La API expone siete conjuntos que abarcan zonas, usuarios, conductores, campañas, clima, viajes y telemetría, describiendo el mismo servicio desde ángulos distintos. El flujo de extracción, carga y transformación los recuperó con paginación controlada, los serializó en archivos columnares Parquet y los cargó en un esquema relacional normalizado. Sobre esa base, la capa de transformación construyó el modelo dimensional. La elección no es estética: un esquema en estrella permite que una consulta analítica cruce el viaje con la zona, el clima o el usuario mediante una sola unión, en lugar de recorrer las tablas normalizadas de origen, siguiendo los principios del modelado dimensional de Kimball @kimball2013.

El resultado es una tabla de hechos con #total-trips-fmt registros (uno por cada intento de viaje de 2024, sin muestreo) y seis dimensiones que describen a #total-users pasajeros, #total-drivers conductores, #total-zones zonas urbanas, #total-quadrants cuadrantes, #total-weather-observations-fmt registros horarios de microclima por cuadrante (#total-weather-days días de observación) y #total-campaigns campañas de incentivos (@tbl-data-inventory). La tabla de hechos conserva el grano atómico; las dimensiones aportan el contexto que hace legible cada registro: quién viajó, desde dónde, hacia dónde, bajo qué microclima en su cuadrante y dentro de qué campaña.

#fig-data-inventory <tbl-data-inventory>

La estructura resultante es un esquema en estrella: la tabla de hechos al centro y cada dimensión unida por llaves sustitutas (@fig-star-schema). Con esa forma, el repositorio deja de ser un archivo de transacciones y se convierte en una base para comparar territorios. El diccionario completo de campos está en el Apéndice C (@tbl-star-schema).

#fig-star-schema <fig-star-schema>

=== La integridad se prueba, no se supone

La calidad se verificó en dos frentes. El proyecto dbt declara #dbt-total-tests pruebas automáticas sobre #(dbt-staging-models + dbt-mart-models) modelos (#dbt-staging-models de preparación y #dbt-mart-models dimensionales): #dbt-tests-unique de unicidad, #dbt-tests-not-null de completitud, #dbt-tests-relationships de integridad referencial y #dbt-tests-accepted-values de valores permitidos. El fragmento de la @fig-dbt-integrity muestra cómo se declaran esas pruebas sobre la tabla de hechos: la llave primaria subrogada debe ser única y no nula, y cada llave foránea debe existir en su dimensión correspondiente.

#fig-dbt-integrity <fig-dbt-integrity>

La segunda verificación fue una auditoría directa del repositorio final. El resultado fue consistente con las pruebas: #inv-integrity.duplicated_trip_keys viajes duplicados, #inv-integrity.total_orphans llaves huérfanas entre la tabla de hechos y sus dimensiones, #inv-integrity.total_null_keys llaves vacías y #inv-integrity.total_null_metrics valores vacíos en distancia, duración, tarifa final y multiplicador dinámico. Ninguna de las dos verificaciones sustituye a la otra: las pruebas previenen regresiones en la transformación, y la auditoría confirma que el estado actual del almacén es íntegro.

La consecuencia práctica es directa. Cada viaje apunta a una zona, un usuario, un conductor y un día que existen, y las variables que alimentan los modelos del Objetivo 2 están completas; no fue necesario imputar valores. La integridad no es un sello final, sino la condición que permite que las regresiones y la red se lean como resultados y no como artefactos de un cruce mal hecho.

=== El censo de 2024 y el mapa de la desigualdad territorial

Con el repositorio validado, la primera consulta fue un censo general del servicio (@tbl-general-kpis). De los #total-trips-fmt viajes registrados, #total-completions-fmt se completaron y #total-cancellations-fmt se cancelaron, lo que arroja una tasa de cancelación de #cancellation-rate%. El multiplicador dinámico promedio fue #avg-surge, la tarifa final promedio de C\$ #avg-final-fare, el recorrido medio de #avg-distance-km km y el tiempo de espera promedio de #avg-wait-time-min minutos. La consulta que produce estas cifras se conserva en el repositorio y se ejecuta en cada actualización (@fig-duckdb-kpis), de modo que el censo no depende de una transcripción manual.

#fig-general-kpis <tbl-general-kpis>

#fig-duckdb-kpis <fig-duckdb-kpis>

Una tasa de cancelación de #cancellation-rate% implica que poco más de un tercio de las solicitudes no termina en viaje. Ese nivel de fricción no se explica por una sola causa, pero sí justifica mirar el fenómeno en dos escalas: la del viaje individual, donde la distancia y el precio importan, y la del territorio, donde las condiciones de acceso cambian según la zona. El censo ofrece la primera escala; el mapa ofrece la segunda.

La ubicación de las solicitudes se proyectó sobre la trama urbana de Managua (@fig-trip-origins-density). Los orígenes se concentran en los polos comerciales y corporativos y se dispersan hacia las zonas populares y periféricas. Esa diferencia territorial no es un detalle descriptivo: anticipa que un mismo servicio opera con condiciones de acceso distintas y que la red vial puede amplificar o amortiguar esa desigualdad.

#fig-trip-origins-density <fig-trip-origins-density>

=== Lo que este repositorio no puede decir

Tres límites acotan lo que el repositorio permite afirmar. Los datos provienen de un entorno de simulación de alta fidelidad, no de registros reales de la empresa; los resultados describen el comportamiento del simulador y no necesariamente el de la operación histórica. El análisis trabaja sobre una copia local en DuckDB tomada en un momento dado, no sobre un flujo continuo. Y el repositorio está diseñado para responder preguntas sobre viajes y zonas, no sobre la experiencia del pasajero ni la calidad percibida del servicio. Reconocerlo no debilita el resultado: delimita su alcance.

Con todo, el repositorio deja una base firme. La distancia, la duración y la tarifa final de cada viaje completado quedan disponibles para el siguiente tramo; las zonas y el clima, para el análisis de red. La pregunta que sigue es si la distancia basta para explicar el tiempo y el precio.

== La distancia: dos ecuaciones para entender tiempo y precio (Objetivo 2)

El segundo objetivo específico buscó modelar cómo la distancia del viaje determina su duración y su costo. La pregunta no es trivial: si la distancia explicara el tiempo con precisión, la planeación operativa podría reducirse a medir kilómetros; si explicara también el precio, la tarifa dinámica sería un ajuste menor. Los datos mostraron una realidad más matizada.

Se usaron los #regression-n-total viajes completados del repositorio, ya que solo estos tienen duración y tarifa cobrada. Los modelos se ajustaron con #regression-n-train viajes (80%) y se evaluaron con los #regression-n-test restantes (20%), que el algoritmo nunca vio durante el ajuste. Se trató de dos regresiones lineales simples, una para la duración y otra para la tarifa, con la distancia como única variable de entrada. Los coeficientes se estimaron por descenso de gradiente estocástico y se acompañaron de intervalos de confianza al 95%; la separación entre entrenamiento y prueba permite evaluar generalización, no solo ajuste.

=== El tiempo de viaje sigue a la distancia

La recta ajustada para estimar la duración $hat(y)$, en minutos, a partir de la distancia $d$, en km, es:

$ hat(y)_"min" = #fmt-dec(m1-b0) + #fmt-dec(m1-b1) dot d $

La pendiente tiene una lectura inmediata: cada kilómetro adicional añade #fmt-dec(m1-b1) minutos al viaje, lo que equivale a una velocidad media de #fmt-dec(60 / m1-b1, digits: 1) km/h dentro de Managua. El intercepto (#fmt-dec(m1-b0) min) recoge el tiempo que el viaje paga antes de moverse: el arranque, la recogida y la incorporación al flujo. Esa separación importa porque distingue lo que crece con la distancia de lo que se cobra una sola vez. Para el viaje promedio de #fmt-dec(dist-mean-km) km, la ecuación predice alrededor de #fmt-dec(predict(m1-b0, m1-b1, dist-mean-km), digits: 1) minutos.

La incertidumbre del coeficiente es estrecha. Con un 95% de confianza, el efecto real de la distancia está entre #fmt-dec(m1-ci-b1-low) y #fmt-dec(m1-ci-b1-upp) minutos por kilómetro: el intervalo está lejos de cero y su amplitud es pequeña, de modo que el efecto es estadísticamente significativo y estable. En los viajes de prueba, el modelo explica el #fmt-dec(m1-r2 * 100, digits: 1)% de la variación de la duración ($R^2 = #fmt-dec(m1-r2, digits: 3)$), con un error típico de #fmt-dec(m1-mae) minutos (MAE). El RMSE (#fmt-dec(m1-rmse) min) es mayor porque penaliza con más fuerza los errores grandes: existen viajes con demoras muy superiores a lo esperado, en línea con la asimetría de la duración (coeficiente de #fmt-dec(dur-skew, digits: 1)).

La lectura operativa es directa: la ecuación permite estimar el tiempo de llegada antes de iniciar el viaje y ajustar la promesa al pasajero. Pero el ajuste no es perfecto. La dispersión vertical de la @fig-numerical-duration muestra viajes que se alargan más de lo previsto, y esos casos son precisamente los que la operación necesita anticipar. El modelo describe la tendencia; no reemplaza el seguimiento del viaje en curso.

#fig-numerical-duration <fig-numerical-duration>

=== La tarifa obedece a más que la distancia

La recta ajustada para estimar la tarifa final, en córdobas, es:

$ hat(y)_"C$" = #fmt-dec(m2-b0) + #fmt-dec(m2-b1) dot d $

Cada kilómetro adicional encarece el viaje en promedio C\$ #fmt-dec(m2-b1), con un intervalo de confianza al 95% entre C\$ #fmt-dec(m2-ci-b1-low) y C\$ #fmt-dec(m2-ci-b1-upp). El intercepto (C\$ #fmt-dec(m2-b0)) funciona como un cargo base del servicio. Es algo mayor que el base fare de las zonas (entre C\$ #fmt-dec(flag-drop-min) y C\$ #fmt-dec(flag-drop-max)), porque además del arranque absorbe el cobro por el tiempo fijo del viaje y, en promedio, parte del recargo dinámico. Para el viaje promedio, la ecuación sitúa la tarifa en torno a C\$ #fmt-dec(predict(m2-b0, m2-b1, dist-mean-km)).

El ajuste, sin embargo, es claramente menor que el del modelo de duración. La tarifa explica el #fmt-dec(m2-r2 * 100, digits: 1)% de la variación ($R^2 = #fmt-dec(m2-r2, digits: 3)$), con un error típico de C\$ #fmt-dec(m2-mae) (MAE) y un RMSE de C\$ #fmt-dec(m2-rmse). La diferencia no es un defecto del modelo, sino una pista: la tarifa no depende solo de la distancia. También depende del surge multiplier (en promedio #fmt-dec(surge-mean-completed) en los viajes completados), del base fare de cada zona y del tiempo real del trayecto. La literatura sobre surge pricing coincide en que el multiplicador responde a tráfico, clima y entorno urbano @battifarano2019; por eso una recta de distancia no puede capturarlo todo @cachon2017.

#fig-numerical-fare <fig-numerical-fare>

La dispersión vertical de la @fig-numerical-fare confirma esa lectura: viajes de igual distancia pueden tener precios muy distintos. En términos operativos, la ecuación sirve como referencia de precio base, no como cotización exacta. Para el pasajero, la promesa de precio es menos confiable que la promesa de llegada; para la plataforma, la estimación debe combinarse con el multiplicador vigente y el estado de la red.

=== Lo que ambas ecuaciones permiten y lo que ocultan

La @tbl-regression-summary reúne ambos modelos. El descenso de gradiente llegó a la solución en #m1-epochs épocas para la duración y en #m2-epochs para la tarifa, partiendo de una tasa de aprendizaje inicial de #sgd-eta0. La convergencia rápida se explica por la estandarización previa de la distancia, que acondiciona la superficie de error y facilita el descenso.

#fig-regression-summary <tbl-regression-summary>

Los valores de $R^2$ en entrenamiento y en prueba son casi iguales en el modelo de duración (#fmt-dec(m1-r2-train, digits: 3) frente a #fmt-dec(m1-r2, digits: 3)), lo que indica una buena generalización. En la tarifa la diferencia es mayor (#fmt-dec(m2-r2-train, digits: 3) frente a #fmt-dec(m2-r2, digits: 3)). Con solo dos parámetros, esa brecha no indica sobreajuste: se explica por las tarifas extremas. La tarifa es muy asimétrica (coeficiente de #fmt-dec(fare-skew, digits: 1)), y unos pocos viajes muy caros en el conjunto de prueba bastan para reducir el $R^2$.

Las dos ecuaciones comparten una limitación de diseño: una sola variable de entrada. Dejan fuera la tarifa dinámica, la congestión y la lluvia; en la duración el sesgo es menor porque la distancia es el determinante principal, pero en la tarifa el efecto es grande. Los intervalos de confianza suponen, además, que la dispersión de los errores es la misma para viajes cortos y largos; la asimetría observada sugiere que esa dispersión crece con la distancia, de modo que los intervalos podrían ser algo más estrechos de lo real. Y los datos, otra vez, provienen de un simulador.

El resultado conjunto permite una conclusión operativa: la distancia ofrece una estimación razonable del tiempo y una estimación parcial del costo. Para el pasajero, eso se traduce en una promesa de llegada más confiable que una promesa de precio. Para la plataforma, en la necesidad de combinar la ecuación con el multiplicador vigente y el estado de la red. Esa última condición conduce al tercer tramo: el promedio de #fmt-dec(60 / m1-b1, digits: 1) km/h describe la ciudad en conjunto, pero no dice cómo navegar la red ante perturbaciones espaciales.

== Optimización Prescriptiva de Trayectorias y Ruteo Espacial (Objetivo 3)

El tercer objetivo de la investigación se orienta a la formulación, diseño e implementación computacional de un motor de búsqueda de trayectorias óptimas (_pathfinding_) adaptativo ante perturbaciones pluviales. Mientras que los modelos paramétricos previos aportan una estimación global de duración y tarifa basada en distancia, la dinámica operativa real de una plataforma de transporte se decide en la topología de la red vial. En lugar de centrar la atención en la inferencia empírica sobre registros simulados, este componente prioriza la arquitectura técnica del algoritmo de ruteo, la formalización matemática de los grafos y la parametrización de variables espaciales que guían la toma de decisiones de navegación.

=== Formalización de Nodos y Variables de la Red Espacial

La representación computacional de la red vial metropolitana se estructura en dos niveles jerárquicos complementarios en Python:

*Nivel micro: Grafo vial denso de intersecciones físicas:* La trama circulatoria se modela a partir de la topología real de OpenStreetMap, conformando un grafo dirigido y ponderado de #routing-nodes nodos y #routing-edges aristas viales transitables. En este nivel, cada nodo representa una intersección física o vértice vial georreferenciado en coordenadas WGS84 ($phi_i, lambda_i$), delimitado por su pertenencia a un cuadrante territorial (`quadrant_id`) y una zona urbana (`zone_id`). Las aristas representan tramos de calle continuos definidos por su longitud métrica geodésica ($d_(i j)$ en kilómetros), su velocidad reglamentaria basal ($v_(0, "vía")$ calibrada según jerarquía de vía: vías principales a #routing-speed-dry km/h, secundarias y residenciales) y una bandera booleana de intercepción con la red de drenaje pluvial metropolitana (485 cauces vectoriales).

*Nivel macro: Malla celular de cuadrantes territoriales:* De manera complementaria, el espacio se discretiza en una rejilla regular de 298 cuadrantes (`dim_quadrants`), donde cada nodo celular encapsula atributos agregados de cota altimétrica media (`mean_altitude_masl`), nivel de riesgo de anegamiento (`flood_risk`), historial de susceptibilidad pluvial y cercanía a cauces críticos. Este nivel provee la conexión topológica con el Star Schema y permite mapear las demandas de viaje (puntos OD) hacia sus nodos viales representativos (`quad_hubs`) dentro del grafo denso.

=== Implementación Computacional del Algoritmo en Python

El algoritmo de ruteo prescriptivo se implementa modularmente utilizando bibliotecas científicas de alto rendimiento (`scipy.sparse`, `numpy` y `networkx`). Para garantizar escalabilidad y baja latencia computacional sobre los #routing-nodes nodos de la capital, la estructura de conectividad y costos se almacena mediante matrices dispersas en formato Compressed Sparse Row (`scipy.sparse.csr_matrix`):

*Construcción de la matriz de adyacencia e impedancia dinámica:* El costo temporal de cruce en cada arista $(i, j)$ se modela como una función de impedancia generalizada en minutos:
$ tau_(i j) = frac(d_(i j), max(v_("efectiva"), 5.0)) dot 60 dot k_("barrera") $

La velocidad efectiva $v_("efectiva")$ y el factor de fricción $k_("barrera")$ se determinan determinísticamente en función de la información del nodo y de la arista:
1. *Escenario basal seco:* La velocidad efectiva coincide con la velocidad basal regulada ($v_("efectiva") = v_(0, "vía")$) y $k_("barrera") = 1.0$, reflejando condiciones de circulación libre.
2. *Escenario de tormenta con anegamiento:* Las aristas que intersectan cauces pluviales sufren un desplome drástico de velocidad a un 25% de la capacidad basal ($v_("efectiva") = v_(0, "vía") dot 0.25$, convergiendo a #routing-speed-storm km/h), agravado por una penalización de barrera hidráulica ($k_("barrera") = 2.5$). En contraste, las aristas no anegadas experimentan únicamente la fricción estándar por lluvia ($v_("efectiva") = v_(0, "vía") dot 0.82$, $k_("barrera") = 1.0$).

*Decisión de trayectoria y resolución de caminos mínimos vía Dijkstra:* A partir de las matrices dispersas resultantes (`mat_dry` y `mat_storm`), el cálculo del camino óptimo entre cualquier par origen-destino se ejecuta mediante el algoritmo vectorizado de Dijkstra (`scipy.sparse.csgraph.dijkstra`). Dado un nodo de origen $s = "hub_orig"$, el optimizador resuelve simultáneamente el vector de distancias mínimas y la matriz de predecesores $P$ (`return_predecessors=True`):
$ d(v) = min_(u in "Vecinos"(v)) { d(u) + tau_(u v) } $

*Reconstrucción determinista de la ruta óptima:* Con la matriz de predecesores $P$, la función algorítmica `reconstruct_path(predecessors, source, target)` rastrea en sentido inverso los punteros topológicos desde el nodo destino hasta el origen, recuperando la secuencia exacta e ininterrumpida de intersecciones viales:
$ "Ruta" = (v_0, v_1, v_2, dots, v_m), quad "con" v_0 = s quad "y" quad v_m = t $

#fig-urban-network-dijkstra <fig-urban-network-dijkstra>

=== Del Modelo Algorítmico a la Resiliencia de la Plataforma

La @fig-urban-network-dijkstra evidencia el comportamiento adaptativo del algoritmo en el corredor estratégico Bello Horizonte hacia Metrocentro. En condiciones secas, el camino mínimo atraviesa el eje directo a través de la cuenca baja; sin embargo, al activarse la condición de tormenta, el drástico incremento en la impedancia temporal de los tramos interceptados por el Cauce Oriental induce a la función objetivo a penalizar dicho corredor. El algoritmo selecciona automáticamente un desvío hacia vías de mayor cota y capacidad de drenaje, garantizando que el vehículo mantenga viabilidad operativa y esquive los puntos críticos de anegamiento.

Esta formulación desacopla la navegación de la plataforma de heurísticas rígidas o de estimaciones de caja negra. Al incorporar la topología física, la cota de los cuadrantes y la geometría de los cauces pluviales directamente en las matrices de impedancia, la infraestructura computacional desarrollada en Python permite que una plataforma de transporte preserve fluidez de servicio, justifique técnicamente sus decisiones de ruteo y evite los colapsos viales que desencadenan cancelaciones durante la temporada de lluvias.

== Síntesis: tres miradas sobre un mismo servicio

Leídos en conjunto, los resultados describen una misma operación desde tres escalas analíticas. En la escala del dato, #total-trips-fmt solicitudes se convierten en un repositorio estructurado que permite comparar zonas, días y condiciones climáticas sin perder trazabilidad. En la escala del viaje, la distancia explica el #fmt-dec(m1-r2 * 100, digits: 1)% de la variación de la duración y el #fmt-dec(m2-r2 * 100, digits: 1)% de la variación de la tarifa: el tiempo es predecible, el precio solo en parte. En la escala de la infraestructura espacial, el motor de ruteo en grafos demuestra que la resiliencia operativa depende de la capacidad computacional para modelar la red calle por calle, integrando la hidrología urbana en la toma de decisiones de navegación.

La consecuencia para MoviGo es una agenda de tres frentes. El primero es la calidad del dato: sin integridad, cualquier modelo posterior es una conjetura bien presentada. El segundo es la calibración tarifaria: la distancia no basta para explicar el precio, de modo que la plataforma necesita incorporar el multiplicador, la zona y el clima en su estimación. El tercero es la inteligencia algorítmica de navegación: la resiliencia ante contingencias climáticas no se logra aumentando pasivamente las tarifas, sino guiando activamente a la flota a través de trayectorias óptimas que esquiven la vulnerabilidad hidráulica. Los tres frentes se sostienen entre sí, y esa interdependencia técnica es el hallazgo central del capítulo.

El recorrido deja, además, una lección metodológica. Cada componente de este capítulo nace del repositorio analítico y del modelado computacional determinista; las tablas, las figuras y los coeficientes no se transcriben a mano. Esa disciplina no es un adorno de ingeniería: es lo que permite que la investigación sea reproducible y que cualquier corrección en los modelos o en la infraestructura se propague de manera exacta y verificable en el documento final.
