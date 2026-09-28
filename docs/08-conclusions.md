# Conclusiones

## Conclusiones y Recomendaciones

Alivia parte de una problemática respaldada tanto por información estadística como por evidencia cualitativa. En el Perú, más de 3,2 millones de personas presentan alguna discapacidad permanente y una proporción importante requiere apoyo para realizar actividades cotidianas. Las entrevistas efectuadas confirmaron que las personas con discapacidad motora severa enfrentan dificultades para controlar elementos básicos de su hogar, como luces, puertas y ventanas, mientras que sus familiares o cuidadores experimentan una carga física y emocional constante. Esta doble validación demuestra que la propuesta responde a una necesidad real y relevante.

A partir de estos hallazgos, el equipo definió una propuesta de valor centrada en la autonomía: un ecosistema de asistencia y automatización del hogar que permite ejecutar acciones mediante comandos de voz y que conserva sus funciones esenciales aun cuando no existe conexión a Internet. El procesamiento local, la confirmación audible de las acciones y el almacenamiento temporal de eventos responden directamente a las necesidades de accesibilidad, seguridad y confianza identificadas durante la investigación con los usuarios.

El proceso de Requirements Elicitation & Analysis permitió transformar la problemática en requisitos funcionales y no funcionales concretos. Los requisitos abarcan el control del entorno, la solicitud de auxilio, las alertas para cuidadores, la supervisión remota, la operación sin conexión, la contratación, la instalación y el mantenimiento del servicio. Asimismo, las historias de usuario, los escenarios de aceptación y el Product Backlog mantienen la trazabilidad entre las necesidades de las personas, los objetivos del negocio y las capacidades que debe implementar el sistema.

La aplicación de Attribute-Driven Design permitió identificar como atributos de calidad prioritarios la disponibilidad, el rendimiento, la usabilidad, la confiabilidad, la seguridad y la observabilidad. Estos atributos se tradujeron en decisiones como el procesamiento Edge, el almacenamiento local, la comunicación mediante MQTT, los mecanismos de failover, el control de acceso basado en roles, la trazabilidad de eventos y el uso de umbrales de confianza para evitar la ejecución de comandos ambiguos. De este modo, la arquitectura propuesta se encuentra alineada con la necesidad de ofrecer una respuesta rápida y segura dentro del hogar.

El Strategic Domain-Driven Design y el Design-Level Event Storming permitieron organizar el dominio en responsabilidades diferenciadas, identificar actores, comandos, eventos, políticas, agregados y sistemas externos, así como reconocer situaciones críticas que deben resolverse antes de la implementación. Los contextos de gestión de identidad, pagos y suscripciones, perfiles, actividades, comunicaciones, gestión de bienes, telemetría y operaciones técnicas establecen una base adecuada para reducir el acoplamiento y facilitar la evolución independiente de las distintas capacidades de Alivia.

Finalmente, la arquitectura de software propuesta integra aplicaciones web y móviles, servicios centrales en la nube y una capa local formada por componentes Edge, un broker de mensajería y dispositivos IoT. Esta distribución permite combinar la administración y supervisión remota con la continuidad local de las funciones esenciales. Sin embargo, su viabilidad definitiva dependerá de validar el comportamiento del sistema con hardware real y con usuarios pertenecientes a los segmentos objetivo, especialmente en condiciones de ruido, pérdida de conectividad, fallos de dispositivos y situaciones de emergencia.

#### Recomendaciones para las siguientes etapas:

- Completar el Domain Message Flow Modeling y los Bounded Context Canvases antes de iniciar el diseño táctico, de manera que queden claramente definidos los contratos, responsabilidades y dependencias entre los bounded contexts.

- Unificar las decisiones tecnológicas que actualmente presentan diferencias dentro del documento. Debe establecerse una única alternativa para la aplicación móvil —Flutter o desarrollo nativo con Kotlin y Swift—, así como una infraestructura definitiva entre Azure y Oracle Cloud y una estrategia coherente entre monolito modular y microservicios.

- Revisar y depurar los requisitos y el Product Backlog para corregir requisitos duplicados, identificadores repetidos y posibles contradicciones. También se recomienda mantener una matriz de trazabilidad entre objetivos de negocio, requisitos, historias de usuario, escenarios de calidad y componentes arquitectónicos.

- Desarrollar inicialmente un producto mínimo viable que priorice el reconocimiento local de voz, el control de luces, puertas y ventanas, la confirmación audible y las solicitudes de auxilio. Las funciones comerciales, analíticas y administrativas pueden ampliarse después de validar el núcleo de autonomía.

- Validar el modelo de reconocimiento de voz con personas reales del segmento objetivo, considerando variaciones de pronunciación, intensidad de voz, ruido ambiental y condiciones acústicas de diferentes viviendas. Deben medirse la precisión, los falsos positivos, los comandos rechazados y la latencia completa desde la pronunciación hasta la acción física.

- Realizar pruebas de resiliencia sobre escenarios de pérdida de Internet, desconexión de Wi-Fi, indisponibilidad del broker, agotamiento de batería, falla de sensores, bloqueo de actuadores y reinicio del componente Edge. La sincronización posterior debe ser idempotente para impedir la duplicación de comandos, alertas o eventos.

- Evaluar la experiencia de uso con personas con discapacidad y cuidadores, verificando la claridad de las confirmaciones auditivas, la facilidad de configuración y la presentación de alertas escritas. Las notificaciones deben mostrar prioritariamente a la persona asistida, el tipo de necesidad, la severidad, la hora y la acción esperada.

- Definir un protocolo específico para las solicitudes de auxilio. Este debe contemplar reconocimiento prioritario, confirmación local, reintentos, escalamiento hacia cuidadores alternativos y un comportamiento seguro cuando no exista conectividad externa o el cuidador principal no responda.

- Aplicar desde el inicio medidas de seguridad y privacidad acordes con la Ley peruana N.º 29733, incluyendo cifrado de datos, almacenamiento seguro de contraseñas, gestión de secretos, control de acceso por roles, auditoría de operaciones y una política de conservación y eliminación de grabaciones y eventos.

- Ejecutar un piloto controlado en viviendas reales antes de ampliar el alcance comercial. Este piloto debe medir la reducción de intervenciones del cuidador, el porcentaje de actividades realizadas autónomamente, el tiempo de respuesta, la disponibilidad sin conexión y la percepción de seguridad y autonomía de ambos segmentos.

- Establecer procedimientos de instalación, mantenimiento preventivo, diagnóstico y reemplazo de equipos. Al tratarse de una solución que interactúa con puertas, iluminación y solicitudes de emergencia, la continuidad del servicio y el estado seguro de los actuadores deben considerarse requisitos operativos fundamentales.

- Mantener la participación de usuarios y cuidadores durante todo el ciclo de desarrollo. La validación continua permitirá comprobar que las decisiones técnicas se traduzcan efectivamente en mayor autonomía, menor carga de cuidado y una experiencia confiable en el contexto cotidiano del hogar.

## Video About-the-Team

<div style="page-break-after: always;"></div>