#import "template.typ": *
#import "components.typ": *

= Recomendaciones operativas y estratégicas

#speaker-marker("D")

#stack(
  dir: ttb,
  spacing: 8pt,
  policy-row(
    number: "01",
    pillar-tag: [TARIFA JUSTA],
    target-agency: [OPERACIÓN MOVIGO • REGULACIÓN],
    icon: slide-icons.shield,
    title: [Tope Dinámico y Bonificación],
    action-1-title: [Techo al Multiplicador],
    action-1-body: [Establecer un tope máximo de 1.80x en contingencias climáticas para prevenir el abandono masivo de usuarios.],
    action-2-title: [Incentivo Directo de Seguridad],
    action-2-body: [Bonificar directamente al conductor por operar bajo lluvia sin transferir la totalidad del sobrecosto al pasajero.],
    impact-label: [REDUCCIÓN FRICCIÓN],
    impact-stat: [-12.5%],
    impact-target: [Descenso proyectado en la tasa de cancelación por tarifa percibida como excesiva.],
    accent: color-title,
  ),

  policy-row(
    number: "02",
    pillar-tag: [RUTEO RESILIENTE],
    target-agency: [ALGORITMOS • INGENIERÍA DE SOFTWARE],
    icon: slide-icons.navigation,
    title: [Navegación Dinámica con Barreras],
    action-1-title: [Alertas de Cauces Desbordados],
    action-1-body: [Integrar capas de microzonas inundables en el despacho de la app para impedir asignaciones a través de puntos ciegos.],
    action-2-title: [Dijkstra Ponderado en Producción],
    action-2-body: [Desplegar matrices de penalización vial en Python para recalcular trayectorias óptimas perimetrales en milisegundos.],
    impact-label: [AHORRO TEMPORAL],
    impact-stat: [-21.4%],
    impact-target: [Optimización de tiempo de viaje bordeando estrangulamientos viales y cauces.],
    accent: color-accent,
  ),

  policy-row(
    number: "03",
    pillar-tag: [DATOS Y POLÍTICA URBANA],
    target-agency: [ALMA • IRTRAMMA • ACADEMIA],
    icon: slide-icons.database,
    title: [Modern Data Stack Metropolitano],
    action-1-title: [Colaboración Público-Privada],
    action-1-body: [Compartir telemetría agregada para apoyar obras municipales de drenaje pluvial y sincronización de semáforos.],
    action-2-title: [Analítica Continua de Movilidad],
    action-2-body: [Evolucionar el almacén dbt hacia ingesta continua para auditoría permanente de la resiliencia del transporte.],
    impact-label: [COBERTURA URBANA],
    impact-stat: [298 Cuadr.],
    impact-target: [Monitoreo integral de equidad territorial y tiempos de espera en Managua.],
    accent: color-teal,
  ),
)
