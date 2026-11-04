#show bibliography: none
#bibliography("../../references.bib")

= Justificación

== Justificación Práctica: Sostenibilidad Económica y Retención de Clientes para MoviGo

La presente investigación se fundamenta en la necesidad operativa de sustituir la calibración empírica y reactiva de tarifas en la plataforma *MoviGo* por un modelo de tarificación y gestión de oferta sustentado en evidencia matemática y econométrica. En el modelo de negocio de las aplicaciones de transporte selectivo, el esquema tarifario dinámico representa tanto la principal fuente de ingresos como el factor determinante de la experiencia del usuario y del conductor @cachon2017.

A partir del análisis de los *77,487 registros históricos de viajes* y las series meteorológicas del entorno de simulación, este proyecto aporta beneficios concretos a la gestión empresarial y operativa de MoviGo:
- *Estimación Paramétrica Confiable de Costos y Tiempos:* Provee modelos bivariados ajustados por Descenso de Gradiente Estocástico (SGD) con intervalos de confianza al 95%, permitiendo estimar con precisión matemática la duración esperada ($R^2 = 0.721$) y la tarifa de referencia ($R^2 = 0.463$) a partir de la distancia de recorrido.
- *Diagnóstico Topológico de Cuellos de Botella:* Identifica cuantitativamente los nudos espaciales con mayor índice de intermediación (Rotonda Centroamérica, Jean Paul Genie, Metrocentro) que concentran el riesgo de colapso vial en la capital.
- *Optimización Prescriptiva de Trayectorias y Ruteo de Viajes:* Demuestra mediante el algoritmo de Dijkstra cómo circunnavegar cauces desbordados genera ahorros de hasta 82.2 minutos por traslado frente a la operación observada de la plataforma, mitigando las demoras excesivas de viaje que constituyen el principal detonante de abandono y cancelación.

== Relevancia Científica y Metodológica: Optimización Espacial y Modelado en Grafos

Desde el punto de vista científico y metodológico, la investigación trasciende la analítica descriptiva tradicional para articular herramientas formales de *teoría de grafos, análisis de redes espaciales e investigación de operaciones*:

+ *Modelado Topológico y Cuellos de Botella Sistémicos:* Modela el territorio metropolitano como una red celular ponderada $G = (V, E)$ de 298 cuadrantes y 1,072 conexiones contiguas en las 24 zonas urbanas de Managua, aplicando métricas de *Centralidad de Intermediación (_Betweenness Centrality_)* para diagnosticar objetivamente los nudos espaciales con mayor vulnerabilidad estructural.
+ *Optimización de Trayectorias y Auditoría de Ruteo de Caja Negra:* Aplica el *Algoritmo de Dijkstra* para calcular caminos mínimos prescriptivos y contrastarlos con las trayectorias reales observadas de MoviGo, demostrando cómo circunnavegar activamente los cauces desbordados ahorra hasta 82 minutos de retraso e impide el colapso operativo por cancelaciones masivas.

== Relevancia Tecnológica y Arquitectura de Ingeniería de Datos (ELT con dbt)

En el ámbito tecnológico, el proyecto resuelve un desafío propio de los entornos de datos contemporáneos: *la inexistencia de acceso directo a la base de datos transaccional y la obligatoriedad de consumir los datos exclusivamente mediante una API REST paginada*.

El pipeline tecnológico implementado demuestra un diseño DataOps escalable y profesional:
+ *Extracción Modular y Paginación Robusta:* Pipeline automatizado en Python (`fetcher.py`) diseñado para consumir colecciones paginadas (`limit=200`, `offset` dinámico), serializando datos brutos en formato columnar Parquet y aislando la ingesta de la infraestructura de alojamiento mediante variables de entorno.
+ *Raw Layer en Azure PostgreSQL:* Ingesta, normalización relacional y persistencia de los 7 endpoints de la plataforma MoviGo en el esquema `raw` alojado en Azure Database for PostgreSQL.
+ *Modelado Dimensional y Transformación con dbt Core:* Construcción de un Data Warehouse bajo metodología Kimball mediante dbt, desacoplando la capa staging y los marts analíticos, con surrogate keys hash (MD5) y una batería exhaustiva de dbt tests que validan reglas de negocio (`surge_multiplier >= 1.00`, tarifas positivas y unicidad referencial) @kimball2013.

== Relevancia Social y Equidad Territorial en el Municipio de Managua

En términos de impacto social, la investigación incide directamente en la equidad urbana y la justicia algorítmica. De acuerdo con el Plan Maestro de Movilidad Urbana de Managua @jica2017, más de una cuarta parte (26%) de los viajes diarios en la capital se realizan en transporte selectivo, constituyendo un modo de transporte vital para la clase trabajadora, estudiantes y comerciantes que conectan periferias con centros neurálgicos como el Mercado Oriental o Metrocentro.

Un sistema de movilidad que responde a las crisis viales elevando tarifas sin optimizar trayectorias actúa como un mecanismo excluyente, perjudicando a usuarios en sectores vulnerables que dependen del transporte selectivo para traslados esenciales. Proponer un ruteo prescriptivo que circunnavegue inundaciones y evite cancelaciones masivas promueve una movilidad metropolitana más resiliente, accesible y justa para la ciudadanía de Managua.

== Articulación Interdisciplinaria en Ciencia de Datos

La presente investigación demuestra la sinergia práctica de la ciencia de datos aplicada a la movilidad metropolitana, articulando armónicamente diferentes frentes técnicos y analíticos en torno a un hilo conductor común:

- *Ingeniería y Almacenamiento Analítico:* Arquitectura ELT, diseño dimensional Star Schema bajo metodología Kimball (fact table atómica `fct_trips` y conformed dimensions), transformaciones con dbt Core y motor OLAP columnar in-process con DuckDB.
- *Automatización y Reproducibilidad Computacional:* Automatización de ingesta desde API REST paginada, scripts Bash estructurados (`set -euo pipefail`), orquestación mediante `justfile`, entorno reproducible con `uv` y verificación estática con `basedpyright`.
- *Investigación de Operaciones y Redes:* Teoría de grafos, modelado de red vial urbana y algoritmo de Dijkstra para cuantificar retrasos y desvíos forzados ante contingencias pluviales.
- *Persistencia Transaccional Relacional:* Diseño relacional normalizado (3NF) y almacenamiento estructurado en la nube sobre Azure Database for PostgreSQL.
