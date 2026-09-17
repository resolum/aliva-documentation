# Capítulo 4: Strategic-Level Software Design

## 4.1. Strategic-Level Attribute-Driven Design (ADD)

### 4.1.1. Design Purpose

El propósito de este diseño es establecer una arquitectura que integre dos componentes complementarios. El primero, basado en IoT y Edge Computing, permite a la persona con discapacidad motora realizar de forma autónoma acciones cotidianas del hogar, tales como abrir puertas y ventanas o encender luces, mediante comandos de voz interpretados localmente por un modelo de aprendizaje automático, garantizando respuesta inmediata incluso sin conexión a Internet. El segundo componente sincroniza esta información en la nube y gestiona el cuidado de la persona asistida (horarios, medicamentos y tareas), habilitando que el cuidador reciba alertas, supervise remotamente el estado del hogar y coordine la atención. La arquitectura debe conectar ambos componentes mediante un flujo de eventos: las acciones y solicitudes generadas en el borde alimentan la capa de supervisión y comunicación en la nube, sin que la autonomía inmediata dependa de esa sincronización.

### 4.1.2. Attribute-Driven Design Inputs

Esta sección presenta las funcionalidades principales y los escenarios de calidad que orientan las decisiones arquitectónicas de Alivia.

#### 4.1.2.1. Primary Functionality (Primary User Stories)

Se seleccionaron las épicas e historias de usuario que representan las funcionalidades esenciales de Alivia y que generan mayor impacto en su arquitectura. Estas se relacionan principalmente con el control por voz, la operación sin Internet, la supervisión remota, la gestión de alertas, la coordinación del cuidado y el monitoreo de dispositivos, considerando los atributos prioritarios de usabilidad, performance, disponibilidad y observabilidad.

| Epic / User Story ID | Título                                                  | Descripción                                                                                                                                                                                                                                                                                                            | Criterios de Aceptación                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | Relacionado con (Epic ID) |
|----------------------|---------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------|
| **EP03**             | **Evaluación, instalación y activación del servicio**   | Gestiona la evaluación presencial, asignación del técnico, adaptación del plan, confirmación del cobro, instalación, pruebas y conformidad del cliente.                                                                                                                                                                | —                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | —                         |
| US11                 | Instalar y comprobar el servicio                        | **Como** técnico o instalador,<br>**quiero** instalar, configurar y comprobar los dispositivos incluidos,<br>**para** entregar el servicio funcionando correctamente.                                                                                                                                                  | **Escenario #1: Instalación satisfactoria**<br>Dado que la vivienda fue aprobada y el pago está confirmado,<br>cuando instala y prueba los dispositivos,<br>entonces registra resultados satisfactorios para luz, puerta, ventana y cubo.<br><br>**Escenario #2: Falla durante la instalación**<br>Dado que un dispositivo no supera las pruebas,<br>cuando registra la falla,<br>entonces la instalación permanece pendiente y se coordina la corrección o reemplazo.<br><br>**Escenario #3: Activación con conformidad**<br>Dado que todas las pruebas fueron satisfactorias,<br>cuando el cliente confirma la recepción,<br>entonces se activa la suscripción y las funciones instaladas. | EP03                      |
| **EP06**             | **Control autónomo y accesible del entorno doméstico**  | Permite que la persona asistida controle luces, puertas y ventanas mediante comandos de voz, reciba confirmaciones comprensibles y mantenga las acciones esenciales ante una interrupción de conexión.                                                                                                                 | —                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | —                         |
| US18                 | Controlar la iluminación mediante voz                   | **Como** persona con discapacidad motora severa,<br>**quiero** encender y apagar la luz mediante mi voz,<br>**para** controlar la iluminación sin depender de otra persona.                                                                                                                                            | **Escenario #1: Encendido exitoso**<br>Dado que la luz está disponible,<br>cuando solicita encenderla,<br>entonces la luz se enciende y se confirma el resultado de forma audible.<br><br>**Escenario #2: Apagado exitoso**<br>Dado que la luz está encendida,<br>cuando solicita apagarla,<br>entonces la luz se apaga y se confirma el resultado.<br><br>**Escenario #3: Luz sin respuesta**<br>Dado que la luz no responde,<br>cuando intenta controlarla,<br>entonces se informa la falla, no se afectan otros dispositivos y se avisa al cuidador.                                                                                                                                      | EP06                      |
| US19                 | Controlar la puerta mediante voz                        | **Como** persona con discapacidad motora severa,<br>**quiero** abrir o cerrar la puerta mediante mi voz,<br>**para** ingresar, salir o recibir ayuda con mayor autonomía.                                                                                                                                              | **Escenario #1: Apertura exitosa**<br>Dado que la puerta está disponible,<br>cuando solicita abrirla,<br>entonces la puerta se acciona y se confirma el resultado.<br><br>**Escenario #2: Cierre exitoso**<br>Dado que la puerta puede cerrarse,<br>cuando solicita su cierre,<br>entonces la puerta se acciona y se confirma el resultado.<br><br>**Escenario #3: Puerta atascada**<br>Dado que la puerta presenta un bloqueo,<br>cuando intenta accionarla,<br>entonces se informa la falla, se mantiene la condición segura y se alerta al cuidador.                                                                                                                                      | EP06                      |
| US20                 | Controlar la ventana mediante voz                       | **Como** persona con discapacidad motora severa,<br>**quiero** abrir o cerrar la ventana mediante mi voz,<br>**para** ventilar o proteger la habitación sin asistencia directa.                                                                                                                                        | **Escenario #1: Apertura exitosa**<br>Dado que la ventana está disponible,<br>cuando solicita abrirla,<br>entonces la ventana se acciona y se confirma el resultado.<br><br>**Escenario #2: Cierre exitoso**<br>Dado que la ventana puede cerrarse,<br>cuando solicita su cierre,<br>entonces la ventana se acciona y se confirma el resultado.<br><br>**Escenario #3: Ventana bloqueada**<br>Dado que presenta resistencia o no informa su estado,<br>cuando intenta accionarla,<br>entonces se detiene la acción, se informa la falla y se alerta al cuidador.                                                                                                                             | EP06                      |
| US21                 | Mantener el control esencial sin Internet               | **Como** persona con discapacidad motora severa,<br>**quiero** continuar controlando los dispositivos esenciales cuando se pierda Internet,<br>**para** no quedar sin autonomía por un problema de conexión.                                                                                                           | **Escenario #1: Control local disponible**<br>Dado que no existe conexión externa,<br>cuando solicita controlar un dispositivo disponible,<br>entonces la acción se procesa localmente y se confirma el resultado.<br><br>**Escenario #2: Conservación de eventos**<br>Dado que se realizan acciones durante la interrupción,<br>cuando todavía no existe conexión,<br>entonces los eventos quedan pendientes sin impedir el control local.<br><br>**Escenario #3: Restablecimiento de conexión**<br>Dado que existen eventos pendientes,<br>cuando se recupera la conexión,<br>entonces se incorporan al historial sin duplicarlos.                                                         | EP06                      |
| **EP07**             | **Supervisión remota, alertas y solicitud de auxilio**  | Permite que el cuidador conozca estados relevantes, reciba alertas escritas y discretas, confirme su atención y sea informado ante solicitudes de auxilio o condiciones críticas.                                                                                                                                      | —                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | —                         |
| US22                 | Supervisar remotamente a la persona asistida            | **Como** familiar o cuidador,<br>**quiero** consultar el estado de los dispositivos y los eventos recientes,<br>**para** conocer situaciones relevantes cuando estoy fuera del hogar.                                                                                                                                  | **Escenario #1: Consulta de estado**<br>Dado que está autorizado,<br>cuando consulta a la persona asistida,<br>entonces conoce el último estado disponible de los dispositivos.<br><br>**Escenario #2: Consulta del historial**<br>Dado que existen acciones y alertas,<br>cuando consulta los eventos recientes,<br>entonces conoce qué ocurrió, cuándo y qué dispositivo estuvo involucrado.<br><br>**Escenario #3: Información desactualizada**<br>Dado que la vivienda perdió la conexión,<br>cuando consulta el estado,<br>entonces se informa la última actualización y que pueden existir eventos pendientes.                                                                         | EP07                      |
| US23                 | Recibir alertas escritas y discretas                    | **Como** familiar o cuidador,<br>**quiero** recibir alertas escritas que identifiquen la necesidad y su prioridad,<br>**para** comprender rápidamente lo ocurrido incluso cuando no puedo escuchar audio.                                                                                                              | **Escenario #1: Alerta completa**<br>Dado que se detecta una situación que requiere atención,<br>cuando se genera la alerta,<br>entonces recibe la persona relacionada, necesidad, prioridad y momento.<br><br>**Escenario #2: Alerta crítica**<br>Dado que la situación es crítica,<br>cuando se genera la alerta,<br>entonces se diferencia su prioridad y se solicita confirmación.<br><br>**Escenario #3: Entrega pendiente**<br>Dado que el cuidador no tiene conexión,<br>cuando se intenta entregar la alerta,<br>entonces permanece pendiente y se entrega cuando vuelve a estar disponible.                                                                                         | EP07                      |
| US24                 | Confirmar y atender alertas críticas                    | **Como** familiar o cuidador,<br>**quiero** confirmar que recibí una alerta crítica,<br>**para** detener las repeticiones y dejar constancia de su atención.                                                                                                                                                           | **Escenario #1: Confirmación oportuna**<br>Dado que recibió una alerta crítica,<br>cuando confirma su recepción,<br>entonces se detienen las repeticiones y se registra quién la confirmó.<br><br>**Escenario #2: Repetición sin confirmación**<br>Dado que la alerta continúa sin confirmación,<br>cuando transcurren dos minutos,<br>entonces se repite hasta alcanzar un máximo de tres avisos.<br><br>**Escenario #3: Pendiente crítica**<br>Dado que concluyeron tres avisos sin confirmación,<br>cuando transcurren seis minutos desde el primer aviso,<br>entonces queda pendiente crítica y se incorpora al historial.                                                               | EP07                      |
| US25                 | Solicitar auxilio mediante voz                          | **Como** persona con discapacidad motora severa,<br>**quiero** solicitar ayuda mediante una expresión de voz,<br>**para** avisar rápidamente al cuidador cuando necesite asistencia.                                                                                                                                   | **Escenario #1: Solicitud reconocida**<br>Dado que el cubo está disponible,<br>cuando pronuncia una expresión de auxilio reconocida,<br>entonces se genera una alerta crítica y se confirma el envío.<br><br>**Escenario #2: Cuidador confirma**<br>Dado que el cuidador recibió la alerta,<br>cuando confirma su recepción,<br>entonces la solicitud queda reconocida y la persona recibe una confirmación.<br><br>**Escenario #3: Solicitud sin confirmación**<br>Dado que ningún cuidador confirma la alerta,<br>cuando concluye el ciclo de avisos,<br>entonces permanece pendiente crítica sin garantizar ayuda presencial.                                                             | EP07                      |
| **EP08**             | **Coordinación y continuidad del cuidado**              | Permite organizar turnos, disponibilidad, transferencia de responsabilidad y rutinas relacionadas con alimentación, higiene y movilización. También permite coordinar la administración de medicamentos mediante horarios, recordatorios, asignación del cuidador responsable y confirmación de la atención realizada. | —                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | —                         |
| US26                 | Organizar turnos y disponibilidad                       | **Como** familiar o cuidador,<br>**quiero** registrar turnos y periodos de disponibilidad,<br>**para** saber quién tiene la responsabilidad principal en cada momento.                                                                                                                                                 | **Escenario #1: Turno registrado**<br>Dado que existe una red de cuidado,<br>cuando asigna un cuidador a un periodo,<br>entonces queda identificado como responsable del turno.<br><br>**Escenario #2: Consulta de disponibilidad**<br>Dado que existen turnos programados,<br>cuando consulta un periodo,<br>entonces conoce quién está disponible y quién está a cargo.<br><br>**Escenario #3: Superposición de turnos**<br>Dado que un cuidador ya tiene una responsabilidad coincidente,<br>cuando intenta asignar otro turno incompatible,<br>entonces se informa la coincidencia antes de confirmar.                                                                                   | EP08                      |
| US28                 | Coordinar rutinas de cuidado                            | **Como** familiar o cuidador,<br>**quiero** programar y registrar rutinas de alimentación, higiene y movilización,<br>**para** reducir omisiones y coordinar las actividades cotidianas.                                                                                                                               | **Escenario #1: Rutina programada**<br>Dado que existe una persona asistida,<br>cuando registra una actividad y horario,<br>entonces la rutina queda disponible para los responsables.<br><br>**Escenario #2: Rutina completada**<br>Dado que existe una actividad pendiente,<br>cuando registra su atención,<br>entonces quedan identificados la actividad, responsable y momento.<br><br>**Escenario #3: Rutina vencida**<br>Dado que la actividad no fue confirmada,<br>cuando vence su horario,<br>entonces permanece identificada como pendiente.                                                                                                                                       | EP08                      |
| US29                 | Coordinar la administración de medicamentos             | **Como** familiar o cuidador,<br>**quiero** registrar horarios y responsables de los medicamentos indicados,<br>**para** coordinar su administración sin modificar las indicaciones establecidas.                                                                                                                      | **Escenario #1: Medicamento programado**<br>Dado que cuenta con una indicación previamente establecida,<br>cuando registra medicamento, horario y responsable,<br>entonces se programa el recordatorio correspondiente.<br><br>**Escenario #2: Administración confirmada**<br>Dado que existe una administración programada,<br>cuando confirma que fue atendida,<br>entonces se registra quién la atendió y en qué momento.<br><br>**Escenario #3: Administración pendiente**<br>Dado que transcurre el horario sin confirmación,<br>cuando se cumple el periodo establecido,<br>entonces queda pendiente sin recomendar cambios de dosis ni tratamiento.                                   | EP08                      |
| **EP09**             | **Supervisión y mantenimiento de dispositivos**         | Permite conocer la conexión, batería y funcionamiento de los dispositivos, registrar fallas, solicitar soporte y gestionar mantenimiento, garantía o reemplazo.                                                                                                                                                        | —                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | —                         |
| US30                 | Consultar el estado de los dispositivos                 | **Como** familiar o cuidador,<br>**quiero** conocer la conexión, batería y funcionamiento de los dispositivos,<br>**para** anticipar fallas que puedan afectar a la persona asistida.                                                                                                                                  | **Escenario #1: Dispositivos operativos**<br>Dado que los equipos informan su estado,<br>cuando consulta la instalación,<br>entonces conoce cuáles están disponibles y funcionando.<br><br>**Escenario #2: Batería baja**<br>Dado que un dispositivo alcanza el nivel preventivo,<br>cuando se actualiza su estado,<br>entonces se genera una alerta que identifica el equipo.<br><br>**Escenario #3: Dispositivo desconectado**<br>Dado que un equipo deja de responder,<br>cuando se detecta la pérdida de conexión,<br>entonces se informa el último estado y se registra la anomalía.                                                                                                    | EP09                      |
| US32                 | Gestionar mantenimiento y reemplazo                     | **Como** personal de soporte,<br>**quiero** registrar el diagnóstico, mantenimiento o reemplazo de un dispositivo,<br>**para** recuperar el servicio y conservar su trazabilidad.                                                                                                                                      | **Escenario #1: Mantenimiento completado**<br>Dado que un dispositivo puede repararse,<br>cuando se completa y comprueba el mantenimiento,<br>entonces se registra el resultado y vuelve a estar disponible.<br><br>**Escenario #2: Reemplazo por garantía**<br>Dado que el equipo cumple las condiciones de garantía,<br>cuando se aprueba el reemplazo,<br>entonces se registra el retiro y se asigna el nuevo equipo.<br><br>**Escenario #3: Garantía no aplicable**<br>Dado que la falla no cumple las condiciones,<br>cuando se evalúa la solicitud,<br>entonces se registra la justificación y se informa la alternativa.                                                              | EP09                      |
| **EP10**             | **Administración de planes, suscripciones y operación** | Permite al personal autorizado gestionar clientes, planes, suscripciones, técnicos, dispositivos, evaluaciones, instalaciones y cambios en el servicio.                                                                                                                                                                | —                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | —                         |
| US35                 | Consultar la trazabilidad de la operación               | **Como** administrador del negocio,<br>**quiero** consultar las operaciones realizadas sobre clientes, suscripciones, instalaciones y dispositivos,<br>**para** supervisar la gestión del servicio.                                                                                                                    | **Escenario #1: Consulta por periodo**<br>Dado que existen operaciones registradas,<br>cuando consulta un periodo,<br>entonces conoce qué acciones se realizaron, quién las ejecutó y cuándo.<br><br>**Escenario #2: Consulta por elemento**<br>Dado que existe un cliente, orden, suscripción o dispositivo,<br>cuando consulta su historial,<br>entonces obtiene las operaciones relacionadas en orden cronológico.<br><br>**Escenario #3: Consulta sin resultados**<br>Dado que no existen operaciones para los criterios,<br>cuando realiza la consulta,<br>entonces se informa que no se encontraron registros sin alterar la información.                                              | EP10                      |

#### 4.1.2.2. Quality Attribute Scenarios

Los escenarios de atributos de calidad son descripciones que se enfocan en el detalle y medición de cómo debería ser el comportamiento del sistema frente a los posibles estímulos que pueda recibir en un entorno dado. Para ello, se eligen los atributos de calidad primero y, luego, se asocian escenarios para verificar el comportamiento del sistema asociado al atributo elegido. De esta forma, se facilita la elección de tácticas para cumplir con estos escenarios. A continuación, se muestra la tabla con los escenarios descritos para Alivia:

<table>
    <tr>
        <th> Atributo </th>
        <th> Fuente </th>
        <th> Estímulo </th>
        <th> Artefacto </th>
        <th> Entorno </th>
        <th> Respuesta </th>
        <th> Medida </th>
    </tr>
    <tr>
        <td> Availability </td>
        <td> Dispositivo IoT </td>
        <td> Pérdida o degradación de la conexión Wi-Fi </td>
        <td> Módulo de control y comunicación </td>
        <td> Operación normal con red Wi-Fi inestable </td>
        <td> Detectar la falla y restablecer la comunicación con el dispositivo IoT </td>
        <td> Tiempo de failover ≤ 0.5s & 100% acciones ejecutadas sin conexión a red </td>
    </tr>
    <tr>
        <td> Availability </td>
        <td> Dispositivo móvil del usuario </td>
        <td> Pérdida temporal de conexión con el servicio en la nube </td>
        <td> Módulo de sincronización </td>
        <td> Operación normal </td>
        <td> Detectar la pérdida, restablecer la comunicación y sincronizar los cambios locales pendientes </td>
        <td> Reconexión y sincronización en ≤ 5 s; 0% de pérdida de datos </td>
    </tr>
    <tr>
        <td> Availability </td>
        <td> Servicio externo integrado </td>
        <td> Detección de indisponibilidad </td>
        <td> Interfaz de integraciones </td>
        <td> Operación normal </td>
        <td> Detectar la falla a tiempo sin afectar al sistema </td>
        <td> 100% de las acciones esenciales que no dependen del servicio afectado se siguen ejecutando </td>
    </tr>
    <tr>
        <td> Security </td>
        <td> Usuario visitante </td>
        <td> Crear una cuenta nueva </td>
        <td> IAM </td>
        <td> Operación normal </td>
        <td> Aplicar derivación de clave a la contraseña antes de almacenarla </td>
        <td> 100% de contraseñas almacenadas mediante el mecanismo establecido </td>
    </tr>
    <tr>
        <td> Security </td>
        <td> Cuidador de persona con discapacidad motora </td>
        <td> Iniciar sesión con sus credenciales correctas </td>
        <td> IAM </td>
        <td> Operación normal </td>
        <td> Autenticar y emitir un token de acceso asociado al rol </td>
        <td> Token con vigencia ≤ 30 minutos </td>
    </tr>
    <tr>
        <td> Security </td>
        <td> Cuidador de persona con discapacidad motora </td>
        <td> Realizar acción en la plataforma </td>
        <td> IAM </td>
        <td> Operación normal </td>
        <td> Validar token de acceso antes de autorizar la acción </td>
        <td> Rechazo del 100% de acciones no autorizadas </td>
    </tr>
    <tr>
        <td> Performance </td>
        <td> Dispositivo móvil del usuario </td>
        <td> Recuperación de la conectividad con el servicio </td>
        <td> Módulo de sincronización </td>
        <td> Operación normal </td>
        <td> Procesar y enviar los cambios locales pendientes </td>
        <td> Sincronización completada ≤ 1.0s </td>
    </tr>
    <tr>
        <td> Performance </td>
        <td> Persona con discapacidad motora </td>
        <td> Solicitar ejecución de acción física </td>
        <td> Módulo de control y comunicación </td>
        <td> Operación normal </td>
        <td> Procesar el comando y delegarlo al dispositivo correspondiente </td>
        <td> Latencia de ejecución ≤ 1.5s </td>
    </tr>
    <tr>
        <td> Performance </td>
        <td> Sistema </td>
        <td> Detección de escenario de evento crítico </td>
        <td> Módulo de alertas y notificaciones </td>
        <td> Operación normal </td>
        <td> Transmitir la información del evento al servicio externo de notificaciones </td>
        <td> Latencia punto a punto ≤ 1.0s </td>
    </tr>
    <tr>
        <td> Performance </td>
        <td> Dispositivo IoT </td>
        <td> Envío de telemetría </td>
        <td> Módulo de persistencia </td>
        <td> Operación normal </td>
        <td> Almacenar los registros asociados sin afectar las operaciones transaccionales y de sincronización </td>
        <td> Tiempo de persistencia ≤ 1.0s </td>
    </tr>
    <tr>
        <td> Interoperability </td>
        <td> Servicio externo integrado </td>
        <td> Falla o indisponibilidad en la comunicación </td>
        <td> Interfaz de integraciones </td>
        <td> Operación normal </td>
        <td> Detectar incompatibilidad y gestionar la interacción con el servicio afectado </td>
        <td> 100% de las interfaces de integración operativas se mantengan con formato y protocolos establecidos </td>
    </tr>
    <tr>
        <td> Usability </td>
        <td> Persona con discapacidad motora </td>
        <td> Solicitar la ejecución de una acción física </td>
        <td> Módulo de control y comunicación </td>
        <td> Operación normal </td>
        <td> Ejecutar el comando y proporcionar una confirmación por voz de la acción realizada </td>
        <td> Confirmación en el 100% de las ejecuciones de comandos </td>
    </tr>
    <tr>
        <td> Usability </td>
        <td> Persona con discapacidad motora </td>
        <td> Solicitar la ejecución de una acción física </td>
        <td> Módulo de control y comunicación </td>
        <td> Operación normal </td>
        <td> Activar la acción asociada a la frase clave </td>
        <td> 100% de las acciones ejecutadas se solicitan mediante comandos de voz </td>
    </tr>
    <tr>
        <td> Usability </td>
        <td> Persona con discapacidad motora </td>
        <td> Requerir asistencia de un cuidador </td>
        <td> Módulo de control y comunicación </td>
        <td> Operación normal </td>
        <td> Detectar la solicitud, priorizarla y activar el flujo de comunicación </td>
        <td> Procesar el flujo de comunicación el 100% de los escenarios de llamada de asistencia por necesidad </td>
    </tr>
    <tr>
        <td> Usability </td>
        <td> Cuidador de una persona con discapacidad motora </td>
        <td> Recibir solicitud de asistencia de la persona con discapacidad </td>
        <td> Aplicación cliente </td>
        <td> Operación normal </td>
        <td> Presentar la información de la solicitud de forma clara, legible y estructurada  </td>
        <td> Lograr identificar y responder a la solicitud el 100% de las ocasiones </td>
    </tr>
    <tr>
        <td> Reliability </td>
        <td> Persona con discapacidad motora </td>
        <td> Emitir un comando de voz para solicitar la ejecución de una acción física </td>
        <td> Módulo de control y comunicación (ML) </td>
        <td> Operación normal </td>
        <td> Interpretar el comando y delegar su ejecución </td>
        <td> Comandos interpretados correctamente ≥ 85% & 0% de comandos ejecutados cuando la confianza del resultado no supera el umbral establecido </td>
    </tr>
    <tr>
        <td> Observability </td>
        <td> Sistema </td>
        <td> Detección de evento interno </td>
        <td> Sección de estado del sistema </td>
        <td> Operación normal </td>
        <td> Mostrar la información respecto del cambio </td>
        <td> 100% de los eventos internos detectados se muestran con fecha, hora, dispositivo asociado, severidad y resultado </td>
    </tr>
    <tr>
        <td> Observability </td>
        <td> Sistema </td>
        <td> Cambio de estado de los dispositivos de control </td>
        <td> Sección de estado del sistema </td>
        <td> Operación normal </td>
        <td> Mostrar el estado actual de los dispositivos </td>
        <td> 100% de los eventos de cambio de estado deben ser notificados </td>
    </tr>
</table>

#### 4.1.2.3. Constraints

<table>
    <tr>
        <th> Technical Story ID </th>
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

#### 4.1.2.4. Architectural Concerns

Una preocupación arquitectónica es una petición o expectativa por parte de los stakeholders frente a la arquitectura de software del sistema que deben ser consideradas durante el diseño. Por ejemplo, una preocupación puede estar relacionada a la seguridad de la plataforma; al cumplimiento de normas de regulación de privacidad de los datos; gestión de errores. Además, no necesariamente se relacionan con alguna funcionalidad, pues su alcance es hasta transversal, es decir, atraviesa varias funciones del sistema. A continuación, se presenta la tabla con las preocupaciones identificadas para el diseño de la arquitectura de software:

<table>
    <tr>
        <th> Concern ID </th>
        <th> Título </th>
        <th> Descripción </th>
    </tr>
    <tr>
        <td> AC001 </td>
        <td> Autonomía de la persona discapacitada </td>
        <td> La solución debe facilitar que la persona pueda realizar actividades cotidianas dentro del hogar con la menor dependencia posible del cuidador, mediante mecanismos de interacción accesibles y control de dispositivos IoT. </td>
    </tr>
    <tr>
        <td> AC002 </td>
        <td> Seguridad y privacidad de los datos </td>
        <td> La arquitectura debe permitir que el sistema proteja la información personal, credenciales, solicitudes de asistencia, estados de los dispositivos y demás datos generados durante la interacción entre la persona, el cuidador y la plataforma. </td>
    </tr>
    <tr>
        <td> AC003 </td>
        <td> Seguridad ante fallos del modelo </td>
        <td> La arquitectura debe contemplar qué hacer cuando el modelo de aprendizaje no pueda interpretar un comando con suficiente confianza, evitando que una predicción incierta se convierta automáticamente en una acción física. </td>
    </tr>
    <tr>
        <td> AC004 </td>
        <td> Costo y disponibilidad de infraestructura </td>
        <td> Las decisiones arquitectónicas deben considerar los recursos económicos y tecnológicos disponibles para implementar y mantener sensores, dispositivos Edge, servicios de nube y aplicaciones cliente. </td>
    </tr>
    <tr>
        <td> AC005 </td>
        <td> Gestión de datos y telemetría </td>
        <td> La arquitectura debe permitir almacenar y gestionar adecuadamente los datos generados por sensores, dispositivos, comandos y eventos, considerando sus diferentes volúmenes, estructuras y frecuencias de generación. </td>
    </tr>
    <tr>
        <td> AC006 </td>
        <td> Mantenibilidad y evolución del modelo de aprendizaje </td>
        <td> La arquitectura debe permitir actualizar, evaluar y reemplazar el modelo de aprendizaje sin afectar innecesariamente el resto de los componentes de la solución. </td>
    </tr>
    <tr>
        <td> AC007 </td>
        <td> Privacidad en Edge Computing </td>
        <td> El procesamiento de comandos de voz y otros datos sensibles debería realizarse en el borde cuando sea viable, reduciendo la necesidad de transmitir información personal hacia servicios externos. </td>
    </tr>
    <tr>
        <td> AC008 </td>
        <td> Comunicación cuidador–persona </td>
        <td> La arquitectura debe facilitar el intercambio oportuno de solicitudes, confirmaciones, alertas y estados entre la persona con discapacidad y su cuidador. </td>
    </tr>
    <tr>
        <td> AC009 </td>
        <td> Seguridad de las acciones físicas </td>
        <td> Las acciones ejecutadas sobre dispositivos del hogar deben evitar comportamientos no deseados y contemplar mecanismos que impidan ejecutar comandos ambiguos o de baja confianza. </td>
    </tr>
    <tr>
        <td> AC010 </td>
        <td> Escalabilidad del entorno IoT </td>
        <td> La arquitectura debe permitir incorporar nuevos dispositivos, sensores, actuadores y funcionalidades sin requerir modificaciones extensas en los componentes existentes. </td>
    </tr>
</table>

### 4.1.3. Tactics

Las tácticas son decisiones de diseño de arquitectura de software que logran modificar la respuesta de la solución frente a estímulos para mejorar los atributos de calidad. A continuación, se define la lista de atributos de calidad identificados para la solución y las tácticas a emplear para satisfacer los escenarios de atributos de calidad que se definen para guiar la arquitectura de software.

<table>
    <tr>
        <th> Atributo de Calidad </th>
        <th> Táctica </th>
        <th> Descripción </th>
    </tr>
    <tr>
        <td rowspan="3"> Availability </td>
        <td> Failover </td>
        <td> Define la estrategia para cambiar el componente de comunicación a uno secundario en caso que el principal falle para que el sistema esté disponible para ejecutar acciones para la persona discapacitada. </td>
    </tr>
    <tr>
        <td> Store-and-forward </td>
        <td> Define que la información se guarde temporalmente en un componente intermedio entre la aplicación cliente y el servicio en la nube en escenarios con conexión limitada y transmita la información cuando el escenario de red sea el óptimo. </td>
    </tr>
    <tr>
        <td> Exception Handling </td>
        <td> Define que el sistema deba ser capaz de manejar errores internos y externos para prevalecer la continuidad operativa de la plataforma. </td>
    </tr>
    <tr>
        <td rowspan="3"> Security </td>
        <td> Encrypt Data </td>
        <td> Define el método de almacenamiento de las contraseñas para que el acceso de las cuentas sea seguro y evite incidencias de accesos no identificados. </td>
    </tr>
    <tr>
        <td> Authenticate Autors </td>
        <td> Define el método de identificación de los usuarios al acceder al sistema para evitar accesos de usuarios anónimos. </td>
    </tr>
    <tr>
        <td> Authorize Autors </td>
        <td> Define que el sistema deba verificar el alcance de funcionalidades de los usuarios según su rol y qué acciones pueden ejecutar en el sistema para evitar accesos no autorizados. </td>
    </tr>
    <tr>
        <td rowspan="3"> Performance </td>
        <td> Introduce Concurrency </td>
        <td> Define que el sistema debe procesar peticiones de forma paralela al procesamiento de otros recursos. </td>
    </tr>
    <tr>
        <td> Increase Resource Efficiency </td>
        <td> Define que se debe proporcionar una mayor capacidad de potencia computacional para el procesamiento de los comandos o hacer que una operación consuma una menor cantidad de recursos. </td>
    </tr>
    <tr>
        <td> Manage Resources </td>
        <td> Define que el sistema debe administrar eficientemente el uso de recursos como memoria, CPU y red. </td>
    </tr>
    <tr>
        <td rowspan="2"> Interoperability </td>
        <td> Use a Standard Protocol </td>
        <td> Define que el sistema debe utilizar un protocolo de comunicación estándar para transmitir información a los servicios externos. </td>
    </tr>
    <tr>
        <td> Use a Standard Data Model </td>
        <td> Define que se deben utilizar modelos internos estandarizados para la transferencia de datos entre el sistema y los servicios externos. </td>
    </tr>
    <tr>
        <td rowspan="4"> Usability </td>
        <td> Provide Feedback </td>
        <td> Define que el sistema debe informar al usuario sobre el estado de la ejecución de las acciones. </td>
    </tr>
    <tr>
        <td> Intuitive Interfaces </td>
        <td> Define que las interfaces de información deben presentar la información de forma clara, estructura y de fácil lectura para los usuarios. </td>
    </tr>
    <tr>
        <td> Maintain User Model </td>
        <td> Define el uso de frases clave para asociarlas a acciones que el usuario requiera ejecutar para cumplir una necesidad determinada. </td>
    </tr>
    <tr>
        <td> Support User Initiative </td>
        <td> Permite que el usuario pueda accionar los comandos cuando los necesite y que el sistema responda a esta iniciativa. </td>
    </tr>
    <tr>
        <td rowspan="2"> Reliability </td>
        <td> Confidence Threshold </td>
        <td> Define que el sistema debe calcular valores de confianza a sus respuestas antes de informar el resultado, lo que se traduce en la toma de decisiones si el sistema interpreta correctamente los comandos del usuario. </td>
    </tr>
    <tr>
        <td> Input Validation </td>
        <td> Define que el sistema debe presentar reglas para valida las entradas de información al sistema para mantenerlo seguro y confiable en sus respuestas. </td>
    </tr>
    <tr>
        <td rowspan="2"> Observability </td>
        <td> Maintain Audit Trail </td>
        <td> Define que el sistema debe dejar rastro de lo que ocurre en el sistema, ya sean eventos o acciones que el usuario realice en la plataforma. </td>
    </tr>
    <tr>
        <td> Heartbeat </td>
        <td> Adaptación de la táctica de disponibilidad, pero en este caso el sistema envía pulsos con información actual de los estados de los dispositivos IoT. </td>
    </tr>
</table>

### 4.1.4. Architectural Drivers Backlog

<table>
    <tr>
        <th> Driver ID </th>
        <th> Título de Driver </th>
        <th> Descripción </th>
        <th> Importancia para Stakeholders (High, Medium, Low) </th>
        <th> Impacto en Architecture Technical Complexity (High, Medium, Low) </th>
    </tr>
    <tr>
        <td> EP001 </td>
        <td> Si Va a Salir </td>
        <td> Si Va a Salir </td>
        <td> Si Va a Salir </td>
        <td> Si Va a Salir </td>
    </tr>
</table>

### 4.1.5. Architectural Design Decisions

<table>
    <tr>
        <td colspan="2">  </td>
        <th colspan="2"> Pattern 1 </th>
        <th colspan="2"> Pattern 2 </th>
        <th colspan="2"> Pattern 3 </th>
    </tr>
    <tr>
        <th> Driver ID </th>
        <th> Título de Driver </th>
        <td> Pro </td>
        <td> Con </td>
        <td> Pro </td>
        <td> Con </td>
        <td> Pro </td>
        <td> Con </td>
    </tr>
    <tr>
        <td> DRV001 </td>
        <td> Si Va a Salir </td>
        <td>  </td>
        <td>  </td>
        <td>  </td>
        <td>  </td>
        <td>  </td>
        <td>  </td>
    </tr>
</table>

### 4.1.6. Quality Attribute Scenario Refinements

<table>
    <tr>
        <th colspan="3" align="left"> Scenario Refinement for Scenario N </th>
    </tr>
    <tr>
        <th colspan="2" align="left"> Scenario(s) </th>
        <td> </td>
    </tr>
    <tr>
        <th colspan="2" align="left"> Business Goals </th>
        <td> </td>
    </tr>
    <tr>
        <th colspan="2" align="left"> Relevant Quality Attributes </th>
        <td> </td>
    </tr>
    <tr>
        <th rowspan="6" align="left"> Scenario Components </th>
        <th align="left"> Stimulus </th>
        <td> </td>
    </tr>
    <tr>
        <th align="left"> Stimulus Source </th>
        <td> </td>
    </tr>
    <tr>
        <th align="left"> Environment </th>
        <td> </td>
    </tr>
    <tr>
        <th align="left"> Artifact (If known) </th>
        <td> </td>
    </tr>
    <tr>
        <th align="left"> Response </th>
        <td> </td>
    </tr>
    <tr>
        <th align="left"> Response Measure </th>
        <td> </td>
    </tr>
    <tr>
        <th colspan="2" align="left"> Questions </th>
        <td> </td>
    </tr>
    <tr>
        <th colspan="2" align="left"> Issues </th>
        <td> </td>
    </tr>
</table>

## 4.2. Strategic-Level Domain-Driven Design (DDD)

### 4.2.1. Design-Level Eventstorming

### 4.2.2. Candidate Context Discovery

### 4.2.3. Domain Message Flow Modeling

### 4.2.4. Bounded Context Canvases

### 4.2.5. Context Mapping

## 4.3. Software Architecture

### 4.3.1. Software Architecture System Landscape Diagram

### 4.3.2. Software Architecture Context Level Diagram

### 4.3.3. Software Architecture Container Level Diagram

### 4.3.4. Software Architecture Deployment Diagram

<div style="page-break-after: always;"></div>
