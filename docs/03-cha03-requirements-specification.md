# Capítulo 3: Requirements Specification

## 3.1. To-Be Scenario Mapping

El To-Be Scenario Map representa cómo cambiaría el día a día del usuario una vez que cuenta con Aliva. Se construye a partir del As-Is Scenario Map y sirve para identificar, fase por fase, qué cambia realmente con la solución propuesta.

Para armarlo, el equipo siguió un proceso en Miro. Primero se revisó el As-Is de cada segmento para tener frescos los puntos de dolor y las fases ya definidas. Luego cada integrante propuso, por su cuenta, posibles mejoras frente a cada pain point identificado. Después se hizo una revisión en grupo para descartar ideas que no aportaban y quedarnos con las más relevantes. Con eso ya definido, se armaron las columnas replicando la estructura del As-Is, pero adaptando el contenido de cada etapa al nuevo flujo con el sistema ya integrado. Las fases también se renombraron, dejando de describir el problema para reflejar la nueva experiencia del usuario. Por último, se comparó el resultado con el As-Is para dejar en claro qué cambia en cada fase, tanto en lo que la persona hace (Doing) como en lo que piensa (Thinking) y siente (Feeling).

**User Persona 1: Persona con discapacidad motora severa**

![To-Be Scenario Mapping - Persona con discapacidad motora severa](https://imgur.com/nrxVkf1.png)

Comparando ambos mapas se nota una mejora clara en la capacidad de la persona para controlar su entorno sin depender de que alguien más esté disponible. Cosas que antes implicaban esperar, alzar la voz o interrumpir al cuidador por algo tan simple como encender una luz o abrir la puerta, ahora se resuelven solo con un comando de voz. Esto no solo reduce las interrupciones hacia el cuidador, también cambia cómo se siente la persona: la culpa, la vergüenza y la impotencia del As-Is dan paso a una sensación mucho más fuerte de control, seguridad y autonomía sobre su propio espacio.

**User Persona 2: Familiar o cuidador de persona con discapacidad**

![To-Be Scenario Mapping - Familiar o cuidador](https://imgur.com/yQ1yJ56.png)

Comparando ambos mapas se nota una reducción importante en la carga mental y física del cuidador durante el día. Las interrupciones constantes por pedidos simples, que antes generaban agotamiento y frustración, bajan considerablemente al delegarlas al sistema. La ansiedad y la hipervigilancia que sentía al salir de casa también se reducen, gracias a poder monitorear en tiempo real cómo está su familiar, lo que le permite ocuparse de sus propias responsabilidades sin dejar de estar pendiente de su bienestar.

## 3.2. User Stories

Las historias de usuario describen las necesidades funcionales de los actores involucrados en Alivia desde una perspectiva orientada al valor. Cada historia se relaciona con una épica y establece criterios de aceptación que permiten verificar el comportamiento esperado del sistema. Esta sección también consolida los requisitos funcionales y no funcionales que delimitan las capacidades y condiciones de calidad de la solución.

### 3.2.1. Requisitos Funcionales

Los requisitos funcionales especifican las capacidades, procesos y respuestas que Alivia debe proporcionar para apoyar la contratación del servicio, la instalación de dispositivos, la asistencia domiciliaria, la supervisión remota y la administración de la solución.

| **ID** | **Capacidad / Módulo** | **Descripción** |
|--------| --- | --- |
| RF01   | Información comercial | Cuando un visitante consulte Alivia, el sistema debe presentar su propósito, beneficios, equipo, testimonios, planes y condiciones, generando información suficiente para evaluar el servicio. |
| RF02   | Gestión de cuentas y acceso | Cuando una persona proporcione información válida, acepte las condiciones y verifique su identidad digital, el sistema debe registrar su cuenta y aplicar los permisos correspondientes, generando acceso autorizado. |
| RF03   | Personas asistidas y red de cuidado | Cuando el responsable registre a una persona asistida, el sistema debe permitir asociar al cuidador principal y a otros contactos autorizados, generando una red de cuidado con responsabilidades diferenciadas. |
| RF04   | Validación técnica y selección del plan | Cuando el cliente complete la evaluación técnica detallada y seleccione un plan, el sistema debe comprobar los requisitos mínimos y calcular el importe correspondiente, generando una contratación pendiente de validación presencial. |
| RF05   | Preautorización bancaria | Cuando el cliente confirme la contratación, el sistema debe solicitar la retención temporal del importe correspondiente, generando una preautorización sin activar la suscripción ni efectuar el cobro definitivo. |
| RF06   | Órdenes y asignación técnica | Cuando exista una preautorización vigente, el sistema debe generar una orden de evaluación y asignarla a un técnico disponible dentro del plazo establecido, generando trazabilidad de la atención. |
| RF07   | Evaluación técnica presencial | Cuando el técnico inspeccione la vivienda, el sistema debe registrar la compatibilidad de las instalaciones y dispositivos requeridos, generando un dictamen sustentado. |
| RF08   | Resolución de factibilidad y cobro | Cuando se emita el dictamen técnico, el sistema debe adaptar el plan, pausar la orden, capturar el importe autorizado o cancelar la preautorización según el resultado, generando una resolución comunicable al cliente. |
| RF09   | Instalación y activación | Cuando el pago esté confirmado, el sistema debe coordinar la instalación, registrar la configuración, ejecutar pruebas y activar la suscripción después del acta de conformidad, generando el servicio operativo. |
| RF10   | Inventario y asignación de dispositivos | Cuando una instalación requiera dispositivos, el sistema debe reservar y asignar equipos disponibles a la vivienda, habitación y persona asistida, generando trazabilidad de su ubicación y estado. |
| RF11   | Control del entorno mediante voz | Cuando la persona asistida emita un comando reconocido y autorizado, el sistema debe controlar la luz, puerta o ventana solicitada, generando una confirmación audible y el estado resultante. |
| RF12   | Operación sin conexión | Cuando se pierda la conexión externa, el sistema debe mantener localmente el reconocimiento de voz y las acciones esenciales, generando registros temporales para su posterior sincronización. |
| RF13   | Monitoreo y diagnóstico | Cuando un dispositivo cambie de estado o presente una anomalía, el sistema debe registrar su conectividad, batería, respuesta y componente afectado, generando información para supervisión y diagnóstico. |
| RF14   | Alertas textuales al cuidador | Cuando se genere una alerta, el sistema debe proporcionar al cuidador principal información escrita, inmediata y discreta que identifique la necesidad, su prioridad y la persona asistida relacionada. |
| RF15   | Generación de alertas técnicas | Cuando se detecte batería baja, desconexión del cubo, fallo del micrófono, parlante, indicadores, luz, puerta, ventana o varios comandos fallidos, el sistema debe clasificar la severidad y generar una alerta para el cuidador principal. |
| RF16   | Confirmación e insistencia de alertas | Cuando una alerta crítica no sea confirmada, el sistema debe repetirla cada dos minutos hasta tres veces y, al concluir seis minutos sin respuesta, registrarla como pendiente crítica. |
| RF17   | Supervisión remota e historial | Cuando el cuidador autorizado consulte a la persona asistida, el sistema debe proporcionar los estados disponibles de dispositivos, solicitudes, alertas y eventos recientes, generando un historial trazable. |
| RF18   | Turnos y disponibilidad de cuidado | Cuando el cuidador principal organice la atención, el sistema debe registrar responsables y horarios de cuidado, generando la identificación de quién está disponible en cada periodo. |
| RF19   | Transferencia de responsabilidad | Cuando finalice un turno de cuidado, el sistema debe permitir transferir la responsabilidad al siguiente cuidador, generando un resumen de actividades, solicitudes y alertas pendientes. |
| RF20   | Solicitud de auxilio por voz | Cuando la persona asistida pronuncie una expresión de auxilio reconocida, el sistema debe generar inmediatamente una alerta crítica para el cuidador principal, entregando la identidad de la persona y el momento de la solicitud. |
| RF21   | Comunicación asistida | Cuando la persona asistida solicite comunicarse con un contacto autorizado, el sistema debe generar una solicitud de comunicación dirigida al contacto correspondiente, entregando una confirmación audible del resultado. |
| RF22   | Rutinas de cuidado | Cuando un cuidador registre actividades recurrentes de alimentación, higiene, medicación o movilización, el sistema debe programar recordatorios y permitir registrar su atención, generando seguimiento de la rutina. |
| RF23   | Registro de actividades | Cuando un cuidador complete una actividad, el sistema debe registrar qué se realizó, quién la atendió y en qué momento, generando información disponible para los demás responsables autorizados. |
| RF24   | Soporte y mantenimiento | Cuando un usuario reporte un problema o un dispositivo presente una falla persistente, el sistema debe generar una solicitud vinculada al equipo y la vivienda, produciendo seguimiento hasta su resolución. |
| RF25   | Garantías y reemplazos | Cuando un dispositivo defectuoso esté dentro de las condiciones de garantía, el sistema debe registrar su retiro, reemplazo y nueva asignación, generando continuidad del historial del servicio. |
| RF26   | Gestión del ciclo de suscripción | Cuando un cliente solicite cambiar, suspender, renovar o cancelar su plan, el sistema debe aplicar las reglas comerciales correspondientes, generando el nuevo estado y las condiciones económicas resultantes. |
| RF27   | Administración del negocio | Cuando un administrador autorizado gestione planes, clientes, cuidadores, técnicos, dispositivos, órdenes o suscripciones, el sistema debe aplicar la operación según sus permisos, generando un registro auditable. |

### 3.2.2. Requisitos No Funcionales

Los requisitos no funcionales establecen las condiciones de calidad y las restricciones técnicas que debe cumplir Alivia. Se priorizan la observabilidad, disponibilidad, eficiencia de desempeño y usabilidad debido a su impacto en la autonomía y seguridad de la persona asistida.

| **ID** | **Categoría (ISO 25010 / Tipo de Restricción)** | **Descripción** |
| :---: | :--- | :--- |
| RNF01 | Observabilidad | El sistema debe registrar el estado de conexión, batería, comandos, acciones, fallos y sincronizaciones de los componentes y dispositivos asociados. |
| RNF02 | Observabilidad | El sistema debe detectar y comunicar la pérdida de conexión o ausencia de respuesta del cubo, componente Edge, controladores ESP32 y actuadores supervisados. |
| RNF03 | Observabilidad | El sistema debe informar el nivel de batería y generar una alerta preventiva antes de que un componente crítico deje de funcionar. |
| RNF04 | Observabilidad | El sistema debe clasificar los eventos técnicos según su severidad para facilitar su diagnóstico y atención. |
| RNF05 | Observabilidad | El sistema debe conservar información suficiente para reconstruir cronológicamente una incidencia operativa o técnica. |
| RNF06 | Observabilidad | El sistema debe permitir comprobar el funcionamiento de luces, puertas, ventanas, micrófono, miniparlante e indicadores LED durante la instalación y el mantenimiento. |
| RNF07 | Disponibilidad | El sistema debe mantener disponible la plataforma central durante cada periodo mensual de operación. |
| RNF08 | Disponibilidad | El sistema debe mantener localmente el reconocimiento de voz y el control esencial de luces, puertas y ventanas cuando no exista conexión a Internet. |
| RNF09 | Disponibilidad | El sistema debe conservar localmente los eventos generados durante una interrupción y sincronizarlos cuando se restablezca la conexión. |
| RNF10 | Disponibilidad | El sistema debe proporcionar autonomía eléctrica al cubo, componente Edge y micrófono mediante una batería de respaldo. |
| RNF11 | Disponibilidad | El sistema debe mantener operativas las cerraduras que utilicen batería independiente durante el periodo mínimo establecido. |
| RNF12 | Disponibilidad | El sistema debe mantener aislado el funcionamiento de los dispositivos para evitar que el fallo de un actuador interrumpa los demás componentes. |
| RNF13 | Disponibilidad | El sistema debe mantener el mecanismo de la puerta en condición segura cuando se detecte un atasco o pérdida de comunicación. |
| RNF14 | Eficiencia de Desempeño | El sistema debe iniciar la acción física solicitada después de finalizar un comando de voz reconocido. |
| RNF15 | Eficiencia de Desempeño | El sistema debe responder a las operaciones transaccionales y consultas estándar de los servicios REST dentro del umbral establecido bajo carga nominal. |
| RNF16 | Eficiencia de Desempeño | El sistema debe completar las operaciones complejas de sincronización dentro del tiempo máximo establecido. |
| RNF17 | Eficiencia de Desempeño | El sistema debe entregar las alertas críticas al servicio de notificaciones y al dispositivo disponible del cuidador bajo condiciones nominales de conectividad. |
| RNF18 | Usabilidad | El sistema debe reconocer correctamente los comandos de voz admitidos en condiciones acústicas nominales de una habitación. |
| RNF19 | Usabilidad | El sistema debe mantener el reconocimiento de comandos de voz ante ruido ambiental moderado. |
| RNF20 | Usabilidad | El sistema debe permitir controlar luces, puertas y ventanas mediante comandos de voz sin requerir interacción manual de la persona asistida. |
| RNF21 | Usabilidad | El sistema debe proporcionar confirmación sonora o verbal sobre el resultado de cada comando de voz procesado. |
| RNF22 | Usabilidad | El sistema debe proporcionar al cuidador alertas escritas que identifiquen la persona asistida, la necesidad detectada y su prioridad. |
| RNF23 | Seguridad | El sistema debe autenticar las solicitudes dirigidas a recursos protegidos mediante tokens JWT válidos. |
| RNF24 | Seguridad | El sistema debe restringir la información de personas asistidas, dispositivos, alertas e instalaciones según las responsabilidades autorizadas. |
| RNF25 | Restricción de Cumplimiento (Legal) | El sistema debe tratar los datos personales conforme con la Ley peruana N.º 29733 y su reglamento vigente. |
| RNF26 | Restricción de Implementación (Landing Page) | El sistema debe implementar la Landing Page informativa y de prefactibilidad utilizando Astro. |
| RNF27 | Restricción de Implementación (Aplicación Web) | El sistema debe implementar la aplicación web de contratación, administración, supervisión e instalación utilizando React. |
| RNF28 | Restricción de Implementación (Aplicación Móvil) | El sistema debe implementar la aplicación móvil para familiares o cuidadores utilizando Flutter. |
| RNF29 | Restricción de Implementación (Backend) | El sistema debe implementar el backend central utilizando Java 21 LTS, Spring Boot 3.3.x o superior y servicios REST. |
| RNF30 | Restricción de Implementación (Datos) | El sistema debe utilizar PostgreSQL para la persistencia central de la información del servicio. |
| RNF31 | Restricción de Implementación (Edge) | El sistema debe utilizar Python y Flask en el componente Edge para el reconocimiento local de comandos, la coordinación de acciones, la comunicación con los dispositivos y la persistencia temporal de eventos. |
| RNF32 | Restricción de Hardware / Memoria | El sistema debe ejecutar el componente Edge en una Raspberry Pi 4 Model B o equipo equivalente o superior. |
| RNF33 | Restricción de Hardware / Almacenamiento | El sistema debe utilizar almacenamiento apto para conservar modelos, eventos y registros locales. |
| RNF34 | Restricción de Hardware / Dispositivos | El sistema debe integrar en el cubo un componente Edge, micrófono ambiental, miniparlante, indicadores LED y batería de respaldo. |
| RNF35 | Compatibilidad | El sistema debe integrar los servicios externos de pagos, notificaciones, correos y validación de direcciones sin comprometer el control local esencial. |

### Epics y User Stories



<table>
    <tr>
        <th> Epic / User Story ID </th>
        <th> Título </th>
        <th> Descripción </th>
        <th> Criterios de Aceptación </th>
        <th> Relacionado con </th>
    </tr>
    <tr>
        <td> EP001 </td>
        <td> Si Va a Salir </td>
        <td> Si Va a Salir </td>
        <td> Si Va a Salir </td>
        <td> Si Va a Salir </td>
    </tr>
</table>

## 3.3. Impact Mapping

## 3.4. Product Backlog

<table>
    <tr>
        <th> # Orden </th>
        <th> User Story ID </th>
        <th> Título </th>
        <th> Descripción </th>
        <th> Story Points </th>
    </tr>
    <tr>
        <td> 1 </td>
        <td> Si Va a Salir </td>
        <td> Si Va a Salir </td>
        <td> Si Va a Salir </td>
        <td> Si Va a Salir </td>
    </tr>
</table>

<div style="page-break-after: always;"></div>
