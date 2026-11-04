#import "../../data_bindings.typ": (
  total-trips-fmt, dbt-total-tests, dbt-coverage-pct, m1-r2, m2-r2, fmt-dec, routing-nodes, routing-edges,
  routing-net-delay, od1-delay-pct, od2-delay-pct, od3-delay-pct, bn1-name, bn2-name,
  cancellation-rate, storm-cancellation-rate, storm-driver-cancel-rate, high-surge-cancellation-rate,
)

= Conclusiones

La investigación se propuso analizar la resiliencia operativa y la conectividad de la red de transporte selectivo MoviGo ante estrangulamientos viales y contingencias climáticas en Managua durante 2024. El recorrido de los resultados permite responder esa pregunta en tres planos articulados: el dato, el viaje y la red. Las conclusiones que siguen no repiten las cifras; las interpretan en conjunto.

== Un repositorio que hace auditable la operación (Objetivo 1)

Consolidar el repositorio analítico no fue un paso previo al análisis, sino su primera condición. Las siete fuentes del servicio quedaron integradas en una tabla de hechos de #total-trips-fmt registros y seis dimensiones, y la integridad se sostuvo en dos mecanismos complementarios: una cobertura del #fmt-dec(dbt-coverage-pct, digits: 0)% de los modelos respaldada por #dbt-total-tests pruebas automáticas de dbt Core y una auditoría directa que no encontró duplicados, llaves huérfanas ni valores vacíos en las variables críticas. El resultado es un repositorio que no solo almacena transacciones, sino que permite rastrear cada cifra hasta su origen.

Ese atributo tiene una consecuencia metodológica: los resultados de los dos objetivos siguientes son verificables. Sin integridad, la regresión de la distancia y la red vial serían ejercicios sobre datos de calidad desconocida. El repositorio, además, deja una lección de diseño: la calidad no se declara al final, se construye en la transformación y se comprueba en la auditoría. Los límites inherentes al entorno de simulación y a la copia local en DuckDB acotan el alcance, pero no la coherencia interna del resultado.

== La distancia explica el tiempo y explica en parte el precio (Objetivo 2)

Modelar la relación entre distancia, duración y tarifa permitió separar dos cosas que suelen confundirse. El tiempo de viaje está estructuralmente ligado a la distancia: la ecuación explica el #fmt-dec(m1-r2 * 100, digits: 1)% de su variación, con un efecto por kilómetro estrecho y estable. La tarifa, en cambio, solo se explica en un #fmt-dec(m2-r2 * 100, digits: 1)%. Esa diferencia no es una debilidad del método, sino el hallazgo: el precio está mediado por el multiplicador dinámico, la zona de origen y el tiempo real del trayecto, factores que una recta de distancia no puede representar.

La consecuencia operativa es una jerarquía de confianza y una advertencia sobre la fricción del servicio. La plataforma puede prometer una llegada con relativa seguridad y, en cambio, debe presentar el precio como una estimación sujeta al contexto. Además, el análisis revela que la fricción en eventos hidrometeorológicos es dual: mientras que la tasa global de cancelación se sitúa en #fmt-dec(cancellation-rate, digits: 1)%, bajo tormenta severa se dispara al #fmt-dec(storm-cancellation-rate, digits: 1)%, detonada principalmente por el rechazo preventivo de los conductores (#fmt-dec(storm-driver-cancel-rate, digits: 1)% de las solicitudes en tormenta) ante el riesgo de inundación en cauces, y agravada por el rechazo de los usuarios cuando el multiplicador de tarifa dinámica rebasa el umbral crítico de 1.85x (con una tasa de cancelación del #fmt-dec(high-surge-cancellation-rate, digits: 1)%). La conclusión no invalida el modelo; delimita su uso: una recta simple sirve para comunicar una tendencia de arranque, pero la gestión de la oferta y la demanda requiere incorporar el contexto territorial y climático.

== La resiliencia tiene geografía: cuellos de botella y lluvia (Objetivo 3)

Optimizar la red vial mostró que la resiliencia no es un atributo uniforme de la ciudad. En la red de #routing-nodes nodos y #routing-edges corredores, los tiempos de traslado se dilatan #routing-net-delay% en promedio bajo tormenta, pero ese promedio oculta tres respuestas distintas: un corredor que se desvía y asume una dilatación temporal relativa de #od1-delay-pct% respecto a su trayectoria seca pero ahorra 24.6 minutos (un 60.0% de reducción temporal) frente al tiempo empírico que sufren los vehículos atascados en el cauce pluvial, otro corredor que carece de vías perimetrales viables y pierde #od2-delay-pct%, y un tercero que resiste con una penalización de #od3-delay-pct%. La misma perturbación produce resultados diferentes según la geometría de cada trayecto y la disponibilidad de rutas alternativas de mayor cota.

El análisis de centralidad añade una lectura estructural. Los nodos con mayor intermediación, incluyendo a #bn1-name y #bn2-name, concentran el tránsito de rutas mínimas y, por eso, cualquier interrupción en ellos se propaga al resto de la red. La lluvia no crea esa vulnerabilidad: la revela y la redistribuye. La conclusión es que la resiliencia debe medirse en dos niveles: el tiempo promedio de la red y la posición de los nodos que sostienen la conectividad. Un sistema puede mejorar su promedio y seguir siendo frágil si los cuellos de botella permanecen intactos.

== Lo que el estudio habilita y lo que no

Tres recomendaciones se desprenden de los resultados. La primera es tratar la calidad del dato como infraestructura permanente, no como una verificación de cierre. La segunda es calibrar la estimación de precio con el multiplicador vigente, la zona y el clima, en lugar de confiar solo en la distancia. La tercera es planear la flota y los tiempos de llegada con criterio de red: priorizar los nodos de mayor centralidad y ajustar las promesas por escenario climático.

Los límites del estudio son igualmente claros. Los datos provienen de un simulador de alta fidelidad, no de la operación real; el grafo es estático y no incorpora tráfico en tiempo real; los modelos usan una sola variable de entrada y suponen una dispersión constante de los errores. Estas condiciones no invalidan las conclusiones, pero las sitúan: describen una estructura probable, no una predicción operativa definitiva. Las líneas futuras naturales son la telemetría en tiempo real, las matrices origen-destino dinámicas y modelos que incorporen explícitamente el multiplicador, la congestión y la lluvia.

== Respuesta al objetivo general

En términos del objetivo general, la investigación permite afirmar que la resiliencia operativa de MoviGo no depende de una sola palanca. Depende de un dato confiable que haga visibles las diferencias territoriales, de un modelo que distinga lo que la distancia explica de lo que deja fuera, y de una lectura de red que localice los puntos donde el sistema pierde tiempo. Las tres piezas se sostienen entre sí: sin dato no hay modelo; sin modelo no hay diagnóstico; sin red no hay prescripción.

La articulación de esas tres escalas es, quizá, el aporte central del estudio. El repositorio convierte la operación en evidencia; la regresión muestra los límites de una explicación simple; la red revela que la resiliencia tiene geografía. Con datos reales y telemetría en tiempo real, ese mismo esquema podría pasar de la descripción estructural a la gestión operativa cotidiana. La pregunta queda respondida en su dimensión analítica; su validación en la operación real es el siguiente paso.
