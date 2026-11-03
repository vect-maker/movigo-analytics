#show bibliography: none
#bibliography("../../references.bib")

= Contextualización de la Investigación

== Sistema de Movilidad Urbana y el Rol del Transporte Selectivo por Plataforma

La movilidad urbana constituye un sistema dinámico y multidimensional en el que convergen decisiones de los usuarios, disponibilidad de vehículos, configuración territorial, condiciones de circulación, tiempos de desplazamiento, costos operativos y variaciones del entorno. En el caso del transporte selectivo, estas relaciones adquieren especial relevancia porque la prestación eficaz del servicio depende de la capacidad de ubicar oportunamente las unidades en aquellos sectores donde se concentra o se desplaza la demanda, responder con tiempos razonables de atención y mantener un esquema tarifario que guarde correspondencia con las condiciones reales de operación. Por ello, la distribución espacial de la oferta y la definición de tarifas no pueden analizarse como procesos aislados, sino como componentes interdependientes de un mismo mercado bilateral @cachon2017.

En este ecosistema, las plataformas tecnológicas bajo demanda (_ride-hailing_) operan como intermediarios algorítmicos. La *tarificación dinámica* (_surge pricing_) se erige como el mecanismo económico rector para balancear oferta y demanda en tiempo real. Cuando la intensidad de solicitudes supera la disponibilidad inmediata de vehículos en un sector, o cuando el entorno vial se deteriora por congestión o fenómenos climáticos, la plataforma eleva temporalmente las tarifas a través de un multiplicador continuo. Teóricamente, este mecanismo cumple un doble propósito equilibrador:

+ *Racionar la demanda:* Desalentar los viajes prescindibles entre usuarios con menor disposición o capacidad de pago.
+ *Estimular la oferta:* Atraer conductores hacia los cuadrantes con déficit de vehículos mediante la expectativa de un mayor ingreso marginal.

Sin embargo, en mercados urbanos caracterizados por marcadas disparidades socioeconómicas y limitaciones de infraestructura, la aplicación descalibrada de la tarifa dinámica introduce fricciones severas: incrementos abruptos en el precio final pueden inducir tasas críticas de cancelación de viajes por parte de pasajeros sensibles al costo, generar exclusión territorial en sectores populares y propiciar que los conductores rechacen o cancelen servicios en zonas congestionadas.

La presente investigación se sitúa en el municipio de *Managua, Nicaragua*, y toma como unidad de análisis el servicio de transporte selectivo de la empresa *MoviGo*. La plataforma atiende la movilidad metropolitana articulando a pasajeros y conductores a través de tres modalidades vehiculares:

- `movigo_estandar`: Unidades sedán convencionales orientadas al traslado urbano cotidiano.
- `movigo_comfort`: Vehículos de gama superior con mayores prestaciones de espacio y comodidad.
- `movigo_moto`: Flota de dos ruedas para traslados individuales ágiles y de menor costo.

El eje central del estudio consiste en *evaluar la eficacia del esquema de tarificación dinámica de MoviGo*, analizando la sensibilidad y elasticidad de la demanda, las tasas de cancelación resultantes, la heterogeneidad territorial de la capital y la viabilidad de esquemas de incentivos económicos como alternativa sostenible al aumento punitivo de tarifas.

== Dimensión Tarifaria Paramétrica y Dinámica del Surge Pricing

El sistema tarifario de MoviGo opera bajo una regla de tarificación compuesta y paramétrica que calcula en primer lugar una tarifa base regular en función de la distancia, el tiempo y el cuadrante de origen, sobre la cual se aplica el multiplicador dinámico:

$ "TarifaBase" = "BajadaBandera"_z + (18.0 dot "distancia_km") + (4.5 dot "duracion_minutos") $

$ "TarifaFinal" = "TarifaBase" dot "multiplicador_dinamico" $

Donde:
- *$"BajadaBandera"_z$:* Costo fijo inicial de arranque del servicio, diferenciado según el cuadrante urbano de partida $z$ (con valores que oscilan entre *C\$ 35.0 y C\$ 80.0 NIO*).
- *Costo por Distancia:* Cargo paramétrico fijo de *C\$ 18.0 NIO* por cada kilómetro recorrido.
- *Costo por Tiempo:* Cargo paramétrico fijo de *C\$ 4.5 NIO* por cada minuto transcurrido de trayecto.
- *Multiplicador Dinámico ($m$):* Factor escalar continuo que oscila regularmente entre *$1.00 times$ (tarifa regular) y $2.80 times$ (alta demanda)*, alcanzando techos extraordinarios de hasta *$3.20 times$* ante perturbaciones meteorológicas severas y colapso vial.

Esta arquitectura tarifaria exige examinar si las reglas de cobro utilizadas mantienen coherencia con las características de los desplazamientos y si el multiplicador converge efectivamente hacia un equilibrio de mercado o si, por el contrario, opera en rangos de sobredimensión que desbordan la disposición de pago del usuario, induciendo cancelaciones masivas de viajes.

== Dimensión Territorial y Heterogeneidad Urbana de Managua

La dimensión territorial agrega un nivel de complejidad determinante. Managua presenta una estructura urbana extensa, dispersa, policéntrica y marcadamente estratificada, con sectores residenciales, comerciales, institucionales, educativos y de servicios que generan patrones de movilidad asimétricos y diferenciados @jica2017.

En este contexto, la demanda de transporte no se distribuye de manera uniforme en el espacio ni permanece constante durante la jornada: la localización de los puntos de atracción laboral y comercial, la conectividad de la red vial, las distancias entre sectores y los niveles diferenciados de accesibilidad condicionan tanto la disponibilidad física de vehículos como las decisiones de los pasajeros:

+ *Asimetría en la Elasticidad-Precio:* Los usuarios de cuadrantes populares presentan una sensibilidad al precio sustancialmente más elástica frente a alzas tarifarias que aquellos en cuadrantes corporativos o de estrato socioeconómico alto.
+ *Sensibilidad a Medios de Pago y Liquidez:* La heterogeneidad territorial se traduce en una desigual bancarización. El predominio de pagos en efectivo en sectores populares frente al uso de tarjeta o billetera digital en cuadrantes comerciales provoca que aumentos imprevistos en el multiplicador superen el circulante disponible del pasajero, motivando la cancelación inmediata de la solicitud.

== Dimensión Climática y Choques Exógenos en la Red Vial

Las condiciones climáticas se incorporan como una dimensión complementaria y no como el único eje explicativo del estudio. En el municipio de Managua, la variabilidad de la precipitación y la temperatura forma parte intrínseca del contexto operativo del transporte. De acuerdo con las normas climatológicas históricas de la estación del Aeropuerto Internacional Augusto C. Sandino, reportadas por el Instituto Nicaragüense de Estudios Territoriales @ineter2021, Managua registra una precipitación media anual aproximada de *1,119.8 mm*, caracterizada por una marcada estacionalidad con mayores acumulados durante la época lluviosa, y una temperatura media anual de *26.9 °C*.

La topografía de la capital, sumada a la vulnerabilidad y déficit histórico del drenaje pluvial urbano, ocasiona que eventos de precipitación torrencial y tormentas convectivas deriven en anegamientos temporales de cauces viales y nudos circulatorios neurálgicos (*Rotonda Centroamérica, Metrocentro, Rotonda Rubén Darío, Pista Juan Pablo II*).

Estas condiciones meteorológicas modifican severamente la dinámica del servicio:
- Se reduce la velocidad media de circulación y se prolongan los tiempos de viaje.
- La demanda de viajes se dispara abruptamente al buscar los peatones refugio en vehículos selectivos.
- La disponibilidad efectiva de unidades se contrae o experimenta demoras críticas para alcanzar los puntos de recogida.

Frente a este desbalance simultáneo de oferta y demanda, el algoritmo de la plataforma responde activando multiplicadores extremos ($2.50 times - 3.20 times$). Evaluar si esta respuesta tarifaria equilibra el sistema o exacerba la insatisfacción y la tasa de cancelación constituye un eje investigativo prioritario.

== Alternativa Operativa: Búsqueda de Rutas Óptimas y Ruteo Prescriptivo de Viajes

Frente a la limitación de responder a los colapsos viales y al déficit de oferta únicamente mediante el aumento punitivo de tarifas, la optimización operativa del servicio demanda intervenir sobre la navegación espacial de los viajes. En situaciones de congestión crítica o anegamiento pluvial, los conductores enfrentan prolongaciones severas en los tiempos de recorrido que deterioran la calidad del servicio y disparan las tasas de cancelación.

En este marco, la propuesta investigativa plantea un enfoque de búsqueda de trayectorias óptimas (_pathfinding_) sobre la red urbana de Managua. En lugar de tolerar que los vehículos queden atrapados en corredores colapsados o nudos viales inundados, la modelación prescriptiva permite identificar rutas alternativas de mínima impedancia que circunnaveguen activamente los puntos críticos de fricción. Esta optimización de trayectorias constituye la contraparte operativa al análisis tarifario: resolver las ineficiencias del servicio mediante una navegación inteligente y resiliente que mitigue demoras y neutralice el detonante espacial de cancelaciones.

== Dimensión Tecnológica y Entorno de Datos de la Plataforma

Para sustentar el análisis operativo y tarifario, la investigación se fundamenta en la captura y estructuración de la huella digital generada por la plataforma. La naturaleza del sistema transaccional analizado y la arquitectura adoptada para el tratamiento de los datos responden a tres premisas de diseño:

+ *Simulación Transaccional de Alta Fidelidad:* Los datos operacionales proceden de un entorno de simulación sintética desarrollado específicamente para la investigación. Dicho motor reproduce con fidelidad estocástica las dinámicas de una aplicación de transporte selectivo en el área metropolitana de Managua: emisión de solicitudes de viaje, asignación y fricción en la aceptación de conductores, interacción entre oferta y demanda sujeta a elasticidades de precio, perturbaciones por anegamiento pluvial y registros continuos de telemetría.

+ *Desacoplamiento vía API REST y Reproducibilidad Abierta:* El acceso a los eventos operativos se realiza mediante una interfaz desacoplada de API REST que expone colecciones paginadas para viajes, cuadrantes, conductores, vehículos, pagos, telemetría y meteorología. El flujo de ingesta (`fetcher.py`) es agnóstico a la infraestructura de despliegue, resolviendo la ubicación del servicio mediante una variable de entorno (`API_URL`). La API no constituye un servicio público permanentemente alojado en la web; en su lugar, tanto el código fuente del servidor transaccional como los conjuntos íntegros de datos son de naturaleza abierta y se liberan públicamente junto con la publicación de este trabajo, garantizando la auditoría independiente y la replicabilidad experimental.

+ *Fuente Centralizada de Verdad y Snapshot Analítico Columnar:* Para aislar el análisis de posibles alteraciones de estado y asegurar reproducibilidad estricta, la investigación delimita como universo censal cerrado el año completo 2024 ($N = 77,487$ viajes transaccionales y 366 días de observaciones meteorológicas). El procesamiento de este universo se articula en dos niveles de almacenamiento:
  - *Repositorio Centralizado (PostgreSQL):* Los registros brutos extraídos por la ingesta se persisten en una base de datos relacional (*Azure Database for PostgreSQL*), que actúa como fuente centralizada de verdad (_single source of truth_), donde se ejecutan pruebas de consistencia y transformaciones dimensionales mediante *dbt Core* bajo modelado en estrella.
  - *Snapshot Analítico Local (DuckDB):* Para el desarrollo de los flujos de modelado econométrico, mapas exploratorios y análisis estadísticos, se genera una instantánea inmutable (_snapshot_) exportada a un motor columnar integrado (*DuckDB*). Este mecanismo confiere lecturas de ultra baja latencia, ejecución desacoplada de la red y garantiza que cualquier investigador pueda reproducir exactamente los mismos cómputos sin depender de conexiones activas a servicios en la nube.
