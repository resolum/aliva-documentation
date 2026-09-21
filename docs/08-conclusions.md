# Conclusiones

## Conclusiones y Recomendaciones

Alivia parte de un problema validado con datos duros y no solo con intuición: en el Perú más de 3.2 millones de personas presentan alguna discapacidad permanente (INEI, Censo 2017), la discapacidad motora es la de mayor prevalencia (932 mil personas, 59.2%) y el 41% de las personas con discapacidad requiere algún grado de dependencia de terceros para sus actividades cotidianas. Las entrevistas realizadas a ambos segmentos objetivo —la persona con discapacidad motora severa y su familiar o cuidador— confirmaron ese problema en el terreno: el 100% de los entrevistados con discapacidad reportó no poder controlar sin ayuda elementos tan básicos como la luz, la puerta o la ventana de su propia habitación, y el 100% de los cuidadores identificó la falta de un reemplazo durante sus turnos como su mayor fuente de desgaste. Esta doble validación —estadística y cualitativa— es la que sostiene la decisión de negocio y de producto detrás de Alivia.

A partir de ese hallazgo, el equipo tradujo el problema en una propuesta de valor concreta: un ecosistema de asistencia y automatización del hogar controlado por voz, con procesamiento local que no depende de una conexión constante a Internet. Esta decisión de diseño no es un detalle técnico menor, sino la respuesta directa a una necesidad expresada por los propios usuarios: la confianza en que el sistema va a responder "sin importar fallas externas o caídas de red" apareció de forma recurrente tanto en las entrevistas como en los supuestos de negocio, y terminó reflejada como requisito no funcional explícito (RNF06, RNF07) y como uno de los quality attribute scenarios priorizados en el diseño arquitectónico estratégico.

El trabajo de elicitación y análisis (Capítulo II) permitió pasar de una problemática general a un conjunto de 25 requisitos funcionales y 32 no funcionales (Capítulo III) que cubren desde la gestión comercial y de cuentas hasta el control por voz, la supervisión remota del cuidador y la operación sin conexión. El Impact Mapping y las User Stories mantienen la trazabilidad entre cada funcionalidad del backlog y un cambio de comportamiento esperado en los usuarios (Sebastián y Mariano), lo que evita el riesgo típico de construir funcionalidades que no resuelven una necesidad real. En paralelo, el Attribute-Driven Design (Capítulo IV) tradujo esos requisitos en drivers arquitectónicos, decisiones de diseño y refinamientos de escenarios de calidad, dejando definida la base estratégica sobre la que se apoyará el diseño táctico.

Dicho esto, es importante ser honestos sobre el estado real del informe a la fecha: el diseño estratégico de dominio (Domain-Driven Design, sección 4.2), el diseño táctico por bounded context (Capítulo V), el diseño UX de la solución (Capítulo VI) y la implementación, validación y despliegue del producto (Capítulo VII) todavía están en plantilla, sin desarrollar. Esto no es una falla del equipo sino el reflejo del punto del ciclo en el que se encuentra el curso — el foco hasta ahora estuvo en validar el problema y sentar las bases estratégicas antes de pasar a diseño detallado e implementación.

**Recomendaciones para las siguientes etapas:**

- Priorizar el cierre de la sección 4.2 (DDD) y el Capítulo V antes de avanzar con código, ya que el diseño táctico depende directamente de los bounded contexts que ahí se definan.
- Completar los requisitos aún marcados como placeholder (Epics y Product Backlog en el Capítulo III) para que el Sprint Planning del Capítulo VII tenga un backlog real del cual partir.
- Aprovechar los hallazgos de las entrevistas (preferencia por notificaciones de texto sobre mensajes de voz, necesidad de garantías de seguridad "absolutas") como criterios de aceptación explícitos al momento de diseñar la UX y las alertas del cuidador, para no perder ese matiz cualitativo en la traducción a pantallas.
- Validar tempranamente con hardware real la latencia end-to-end estimada en el diseño IoT (1.11 s), dado que la usabilidad de todo el sistema de comandos de voz depende de que esa cifra se sostenga en campo y no solo en el diseño.

## Video About-the-Team

<div style="page-break-after: always;"></div>
