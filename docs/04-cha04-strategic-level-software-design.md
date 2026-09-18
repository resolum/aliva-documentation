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
| US23                 | Recibir alertas escritas de rápida lectura              | **Como** familiar o cuidador,<br>**quiero** recibir alertas escritas que identifiquen la necesidad y su prioridad,<br>**para** comprender rápidamente lo ocurrido incluso cuando no puedo escuchar audio.                                                                                                              | **Escenario #1: Alerta completa**<br>Dado que se detecta una situación que requiere atención,<br>cuando se genera la alerta,<br>entonces recibe la persona relacionada, necesidad, prioridad y momento.<br><br>**Escenario #2: Alerta crítica**<br>Dado que la situación es crítica,<br>cuando se genera la alerta,<br>entonces se diferencia su prioridad y se solicita confirmación.<br><br>**Escenario #3: Entrega pendiente**<br>Dado que el cuidador no tiene conexión,<br>cuando se intenta entregar la alerta,<br>entonces permanece pendiente y se entrega cuando vuelve a estar disponible.                                                                                         | EP07                      |
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

En esta sección se explica detalladamente las restricciones tecnológicas que limitan el desarrollo del proyecto y, a su vez, el diseño de la arquitectura de software. Para ello, cada restricción está redactada en formato de historia de usuario y cuentan con criterios de aceptación para garantizar que cada una esté estandarizada y el equipo pueda conocer los requisitos tecnológicos asociados.

| Technical Story ID | Título                                                                               | Descripción                                                                                                                                                                                                                                                                       | Criterios de Aceptación                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | Relacionado con (Epic ID) |
|--------------------|--------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------|
| TS06               | **Preautorización de pago y contratación**                                           | **Como** Web Developer,<br>**quiero** disponer de servicios para iniciar y consultar la preautorización de una contratación,<br>**para** gestionar la retención temporal del importe desde la aplicación web.                                                                     | **Escenario #1: Preautorización iniciada.** Dado que se envía `POST /api/v1/subscriptions/preauthorizations` con Bearer Token, `planId`, `assessmentId` y referencia de pago, cuando el backend valida la contratación y solicita la retención, entonces responde `201 CREATED` con `subscriptionId`, `paymentId` y estado `PREAUTHORIZED`.<br><br>**Escenario #2: Preautorización rechazada.** Dado que el proveedor de pagos rechaza la retención, cuando el backend procesa la respuesta, entonces responde `422 UNPROCESSABLE ENTITY` con estado `PAYMENT_REJECTED`.<br><br>**Escenario #3: Plan no disponible.** Dado que el `planId` no existe o está inactivo, cuando el backend valida la solicitud, entonces responde `404 NOT FOUND` o `409 CONFLICT` sin solicitar el pago.<br><br>**Escenario #4: Contratación duplicada.** Dado que existe una contratación vigente para la misma evaluación, cuando se intenta crear otra preautorización, entonces responde `409 CONFLICT`.                                                                                                                                                       | EP02                      |
| TS07               | **Captura o liberación del importe**                                                 | **Como** Web Developer,<br>**quiero** disponer de servicios para consultar el resultado económico posterior a la evaluación técnica,<br>**para** informar desde la aplicación web si el importe fue capturado, ajustado o liberado.                                               | **Escenario #1: Vivienda compatible.** Dado que se registra un dictamen compatible mediante `POST /api/v1/installations/{installationId}/technical-verdict`, cuando el backend solicita la captura del importe, entonces responde `200 OK` con estados `PAYMENT_CAPTURED` e `INSTALLATION_PENDING`.<br><br>**Escenario #2: Incompatibilidad definitiva.** Dado que el dictamen indica incompatibilidad definitiva, cuando el backend cancela la autorización, entonces responde `200 OK` con estado `PREAUTHORIZATION_RELEASED`.<br><br>**Escenario #3: Adaptación parcial.** Dado que el dictamen excluye dispositivos inviables, cuando el backend ajusta el plan y el importe, entonces responde `200 OK` con las nuevas condiciones.<br><br>**Escenario #4: Servicio de pagos no disponible.** Dado que el proveedor no responde, cuando el backend no puede confirmar la operación, entonces responde `503 SERVICE UNAVAILABLE` y mantiene el pago como `PAYMENT_PROCESSING`.                                                                                                                                                               | EP03                      |
| TS13               | **Confirmación y escalamiento de alertas**                                           | **Como** Frontend Developer,<br>**quiero** disponer de servicios para confirmar alertas y consultar su estado,<br>**para** gestionar su atención desde las aplicaciones web y móvil.                                                                                              | **Escenario #1: Alerta confirmada.** Dado que se envía `POST /api/v1/alerts/{alertId}/acknowledgements` con Bearer Token, cuando el backend valida al cuidador y la alerta pendiente, entonces responde `200 OK` con estado `ACKNOWLEDGED` y detiene las repeticiones.<br><br>**Escenario #2: Repetición de alerta.** Dado que una alerta crítica no fue confirmada, cuando transcurren dos minutos desde el último intento, entonces el backend genera otra entrega hasta un máximo de tres repeticiones.<br><br>**Escenario #3: Alerta pendiente crítica.** Dado que concluyen los tres intentos sin confirmación, cuando finaliza el ciclo de insistencia, entonces el backend actualiza la alerta a `PENDING_CRITICAL`.<br><br>**Escenario #4: Confirmación duplicada.** Dado que la alerta ya fue atendida, cuando se intenta confirmarla nuevamente, entonces responde `409 CONFLICT`.                                                                                                                                                                                                                                                     | EP07                      |
| TS19               | **Integración web con Stripe para captura de datos de pago**                         | **Como** Web Developer,<br>**quiero** integrar los componentes cliente de Stripe utilizando la clave pública y el secreto temporal generado por el backend,<br>**para** registrar el medio de pago sin que Alivia manipule ni almacene los datos de la tarjeta.                   | **Escenario #1: Preparación exitosa del pago.** Dado que el usuario solicita `POST /api/v1/payments/setup`, cuando el backend devuelve el secreto temporal de Stripe, entonces la aplicación inicializa el componente de pago de forma segura.<br><br>**Escenario #2: Medio de pago inválido.** Dado que Stripe identifica datos incompletos o inválidos, cuando el componente cliente procesa el medio de pago, entonces la aplicación informa el error sin enviar datos sensibles al backend.<br><br>**Escenario #3: Backend no disponible.** Dado que `POST /api/v1/payments/setup` responde `503` o excede el tiempo, cuando la aplicación prepara la operación, entonces no inicia el cobro y permite reintentar.<br><br>**Escenario #4: Credenciales protegidas.** Dado que se inspeccionan el código compilado y las solicitudes, cuando se revisa la configuración de Stripe, entonces solo se encuentra la clave pública y ningún secreto privado.                                                                                                                                                                                      | EP02                      |
| TS20               | **Orquestación backend de pagos con Stripe**                                         | **Como** Backend Developer,<br>**quiero** integrar Stripe para crear preautorizaciones, capturar o liberar importes y administrar los pagos,<br>**para** aplicar el flujo de contratación diferida según la evaluación técnica.                                                   | **Escenario #1: Preautorización creada.** Dado que se envía `POST /api/v1/subscriptions/preauthorizations` con los datos válidos, cuando Stripe autoriza la retención, entonces responde `201 CREATED` con `paymentId` y estado `PREAUTHORIZED` sin almacenar la tarjeta.<br><br>**Escenario #2: Captura posterior.** Dado que la vivienda fue declarada compatible, cuando el backend solicita la captura, entonces actualiza el pago a `CAPTURED` y responde `200 OK`.<br><br>**Escenario #3: Liberación por incompatibilidad.** Dado que la vivienda resulta incompatible, cuando el backend cancela la preautorización, entonces actualiza el pago a `RELEASED` y responde `200 OK`.<br><br>**Escenario #4: Error o timeout.** Dado que Stripe responde `4xx`, `5xx` o excede el tiempo, cuando el backend no confirma el resultado, entonces responde `422` o `503`, conserva estado pendiente y evita duplicados mediante idempotencia.<br><br>**Escenario #5: Clave privada protegida.** Dado que se inspeccionan respuestas y registros, cuando se ejecuta una operación, entonces la clave secreta y los datos sensibles no se exponen. | EP02                      |
| TS21               | **Procesamiento de webhooks de Stripe**                                              | **Como** Backend Developer,<br>**quiero** disponer de un endpoint seguro para recibir y procesar eventos de Stripe,<br>**para** mantener sincronizados los estados de pagos, preautorizaciones y suscripciones.                                                                   | **Escenario #1: Evento válido.** Dado que Stripe envía `POST /api/v1/webhooks/stripe` con un evento firmado, cuando el backend verifica la firma, entonces responde `200 OK` y actualiza el estado.<br><br>**Escenario #2: Firma inválida.** Dado que la solicitud no contiene una firma válida, cuando el backend verifica su autenticidad, entonces responde `400 BAD REQUEST` sin modificar información.<br><br>**Escenario #3: Evento duplicado.** Dado que Stripe reenvía un evento procesado, cuando el backend detecta el identificador externo, entonces responde `200 OK` sin duplicar la operación.<br><br>**Escenario #4: Error interno.** Dado que ocurre un fallo temporal, cuando el backend no completa el evento, entonces responde `500 INTERNAL SERVER ERROR` y permite el reintento.<br><br>**Escenario #5: Secreto protegido.** Dado que se inspeccionan los clientes, cuando se revisan sus configuraciones, entonces el secreto de webhooks no está incluido.                                                                                                                                                              | EP02                      |
| TS24               | **Integración con SendGrid**                                                         | **Como** Backend Developer,<br>**quiero** integrar SendGrid para enviar códigos de verificación y correos transaccionales,<br>**para** entregar comunicaciones con trazabilidad sin exponer credenciales.                                                                         | **Escenario #1: Código enviado.** Dado que se registra una cuenta, cuando el backend genera un código y SendGrid acepta el mensaje, entonces responde `201 CREATED` y no incluye el código en la respuesta.<br><br>**Escenario #2: Confirmación enviada.** Dado que un pago o instalación cambia de estado, cuando el backend solicita el correo, entonces SendGrid recibe la plantilla con datos permitidos.<br><br>**Escenario #3: Correo rechazado.** Dado que SendGrid rechaza el destinatario, cuando el backend procesa la respuesta, entonces registra el envío como `REJECTED`.<br><br>**Escenario #4: Error o timeout.** Dado que SendGrid responde `5xx` o timeout, cuando el backend no confirma el envío, entonces registra `PENDING_RETRY` y evita varios códigos vigentes.<br><br>**Escenario #5: API Key protegida.** Dado que se inspeccionan clientes, respuestas y logs, cuando se ejecuta el envío, entonces la API Key permanece solo en backend.                                                                                                                                                                            | EP05                      |
| TS01               | **Registro de cuenta y verificación por correo**                                     | **Como** Web Developer,<br>**quiero** disponer de servicios para registrar una cuenta y verificarla mediante un código enviado al correo electrónico,<br>**para** habilitar el acceso desde la aplicación web únicamente después de completar el segundo factor.                  | **Escenario #1: Registro iniciado correctamente.** Dado que se envía `POST /api/v1/auth/register` con nombre, correo, teléfono, contraseña y aceptación de términos, cuando el backend valida que el correo no está registrado y genera el código, entonces responde `201 CREATED` con `accountId`, correo parcialmente oculto y estado `PENDING_VERIFICATION`.<br><br>**Escenario #2: Cuenta verificada correctamente.** Dado que se envía `POST /api/v1/auth/verify-email` con `accountId` y un código vigente, cuando el backend verifica que el código es correcto y no fue utilizado, entonces responde `200 OK` con estado `ACTIVE`.<br><br>**Escenario #3: Correo previamente registrado.** Dado que se envía un correo asociado a otra cuenta, cuando el backend verifica la duplicidad, entonces responde `409 CONFLICT` con un error asociado al campo `email`.<br><br>**Escenario #4: Código inválido o vencido.** Dado que se proporciona un código incorrecto, vencido o reutilizado, cuando el backend ejecuta la validación, entonces responde `400 BAD REQUEST` y mantiene la cuenta sin activar.                                | EP05                      |
| TS03               | **Autenticación y emisión de tokens**                                                | **Como** Frontend Developer,<br>**quiero** disponer de servicios para autenticar usuarios y renovar sesiones,<br>**para** permitir el acceso seguro desde las aplicaciones web y móvil.                                                                                           | **Escenario #1: Autenticación exitosa.** Dado que se envía `POST /api/v1/auth/login` con correo y contraseña válidos, cuando el backend verifica las credenciales y el estado de la cuenta, entonces responde `200 OK` con `accessToken`, `refreshToken`, vigencia, usuario y permisos.<br><br>**Escenario #2: Credenciales incorrectas.** Dado que se envían credenciales inválidas, cuando el backend no puede autenticar la cuenta, entonces responde `401 UNAUTHORIZED` sin revelar cuál credencial fue incorrecta.<br><br>**Escenario #3: Cuenta sin verificar.** Dado que las credenciales corresponden a una cuenta `PENDING_VERIFICATION`, cuando el backend valida su estado, entonces responde `403 FORBIDDEN` indicando que debe verificarse el correo.<br><br>**Escenario #4: Renovación de sesión.** Dado que se envía `POST /api/v1/auth/refresh` con un token de renovación válido, cuando el backend verifica su vigencia, entonces responde `200 OK` con nuevos tokens.                                                                                                                                                         | EP05                      |
| TS09               | **Registro y finalización de instalación**                                           | **Como** Web Developer,<br>**quiero** disponer de servicios para registrar dispositivos, pruebas y conformidad de una instalación,<br>**para** permitir que el técnico active el servicio desde la aplicación web.                                                                | **Escenario #1: Instalación completada.** Dado que se envía `POST /api/v1/installations/{installationId}/completion` con dispositivos, ubicaciones, pruebas y conformidad, cuando todos los componentes obligatorios superan las pruebas, entonces responde `200 OK` con instalación `COMPLETED` y suscripción `ACTIVE`.<br><br>**Escenario #2: Pruebas incompletas.** Dado que falta el resultado de un dispositivo obligatorio, cuando el backend valida la finalización, entonces responde `400 BAD REQUEST` y mantiene la instalación `IN_PROGRESS`.<br><br>**Escenario #3: Prueba fallida.** Dado que un componente no supera la prueba, cuando se intenta completar la instalación, entonces responde `409 CONFLICT`, registra la incidencia y evita la activación.                                                                                                                                                                                                                                                                                                                                                                        | EP03                      |
| TS12               | **Entrega móvil de alertas**                                                         | **Como** Mobile Developer,<br>**quiero** disponer de servicios para recibir alertas sobre solicitudes de auxilio y fallos críticos,<br>**para** informar inmediatamente al cuidador principal desde la aplicación móvil.                                                          | **Escenario #1: Alerta creada.** Dado que se envía `POST /api/v1/alerts` con persona asistida, evento, prioridad y origen, cuando el backend valida y clasifica la alerta, entonces responde `201 CREATED` con `alertId` y estado `PENDING`.<br><br>**Escenario #2: Notificación entregada.** Dado que existe una alerta válida y un cuidador principal, cuando el backend solicita la notificación móvil, entonces registra la entrega con persona, necesidad, prioridad y fecha.<br><br>**Escenario #3: Cuidador no configurado.** Dado que no existe un cuidador principal vinculado, cuando el backend determina el destinatario, entonces conserva la alerta pendiente y registra la incidencia operativa.<br><br>**Escenario #4: Servicio de notificaciones no disponible.** Dado que la dependencia externa no responde, cuando el backend intenta entregar la alerta, entonces conserva el estado `DELIVERY_PENDING` y programa otro intento.                                                                                                                                                                                            | EP07                      |
| TS23               | **Validación backend de direcciones con Google Maps**                                | **Como** Backend Developer,<br>**quiero** integrar Google Maps para validar y normalizar direcciones,<br>**para** conservar una ubicación consistente para la evaluación e instalación.                                                                                           | **Escenario #1: Dirección validada.** Dado que se envía `POST /api/v1/installation-addresses` con dirección y coordenadas, cuando Google Maps confirma la ubicación en Perú, entonces responde `201 CREATED` con estado `VERIFIED`.<br><br>**Escenario #2: Dirección ambigua.** Dado que Google Maps devuelve varias coincidencias, cuando el backend procesa la respuesta, entonces responde `422 UNPROCESSABLE ENTITY`.<br><br>**Escenario #3: Fuera de cobertura.** Dado que las coordenadas no están en la zona atendida, cuando el backend valida la cobertura, entonces responde `422` con `ADDRESS_OUT_OF_COVERAGE`.<br><br>**Escenario #4: Proveedor no disponible.** Dado que Google Maps responde `4xx`, `5xx` o timeout, cuando el backend no completa la verificación, entonces responde `503 SERVICE UNAVAILABLE`.<br><br>**Escenario #5: Clave protegida.** Dado que se inspeccionan respuestas y registros, cuando se procesa una dirección, entonces la clave privada no aparece.                                                                                                                                                | EP03                      |
| TS25               | **Integración backend con Firebase**                                                 | **Como** Backend Developer,<br>**quiero** integrar Firebase para despachar alertas y recordatorios hacia dispositivos móviles,<br>**para** informar oportunamente al cuidador principal.                                                                                          | **Escenario #1: Notificación enviada.** Dado que se genera una alerta válida, cuando Firebase acepta el mensaje, entonces se registra el identificador y estado `SENT`.<br><br>**Escenario #2: Token inválido.** Dado que Firebase informa que el token expiró, cuando el backend procesa la respuesta, entonces invalida el token y conserva la alerta.<br><br>**Escenario #3: Error temporal.** Dado que Firebase responde `5xx` o timeout, cuando el backend no confirma la entrega, entonces establece `DELIVERY_PENDING` y programa reintento.<br><br>**Escenario #4: Contenido discreto.** Dado que se prepara una notificación, cuando el backend construye el payload, entonces incluye solo información necesaria.<br><br>**Escenario #5: Credenciales protegidas.** Dado que se inspeccionan los clientes, cuando se revisa Firebase, entonces ninguna credencial administrativa está incluida.                                                                                                                                                                                                                                        | EP07                      |
| TS26               | **Registro móvil y recepción con Firebase**                                          | **Como** Mobile Developer,<br>**quiero** integrar Firebase y registrar de forma segura el token móvil,<br>**para** recibir y presentar las alertas destinadas al cuidador.                                                                                                        | **Escenario #1: Token registrado.** Dado que el cuidador inicia sesión y concede permisos, cuando la app envía `POST /api/v1/mobile-devices`, entonces el backend responde `201` o `200` y vincula el dispositivo.<br><br>**Escenario #2: Alerta recibida.** Dado que Firebase entrega una notificación válida, cuando la aplicación procesa el payload, entonces presenta persona, necesidad y prioridad.<br><br>**Escenario #3: Permiso denegado.** Dado que el cuidador rechaza las notificaciones, cuando la app intenta registrar el dispositivo, entonces informa la limitación y mantiene alertas internas.<br><br>**Escenario #4: Renovación de token.** Dado que Firebase genera un token nuevo, cuando la aplicación detecta el cambio, entonces actualiza mediante `PUT /api/v1/mobile-devices/{deviceId}/token`.<br><br>**Escenario #5: Credenciales protegidas.** Dado que se inspecciona el paquete móvil, cuando se revisa Firebase, entonces no contiene credenciales administrativas.                                                                                                                                           | EP07                      |
| TS28               | **Integración cliente con Cloudinary**                                               | **Como** Frontend Developer,<br>**quiero** integrar la carga de fotografías mediante parámetros firmados,<br>**para** adjuntar evidencias desde las aplicaciones web y móvil.                                                                                                     | **Escenario #1: Evidencia cargada.** Dado que se solicita `POST /api/v1/media/upload-authorizations`, cuando el backend devuelve parámetros firmados y Cloudinary acepta la imagen, entonces el cliente registra la referencia y recibe `201 CREATED`.<br><br>**Escenario #2: Archivo inválido.** Dado que el archivo supera el tamaño o formato permitido, cuando el cliente o Cloudinary valida la carga, entonces no registra la evidencia e informa el motivo.<br><br>**Escenario #3: Firma vencida.** Dado que los parámetros ya no están vigentes, cuando Cloudinary rechaza la operación, entonces el cliente solicita una nueva autorización.<br><br>**Escenario #4: Error o timeout.** Dado que Cloudinary responde `4xx`, `5xx` o timeout, cuando el cliente carga la evidencia, entonces conserva el formulario y permite reintentar.<br><br>**Escenario #5: Secreto protegido.** Dado que se inspeccionan clientes y red, cuando se realiza una carga, entonces el secreto privado no está disponible.                                                                                                                               | EP09                      |
| TS29               | **Administración backend de recursos en Cloudinary**                                 | **Como** Backend Developer,<br>**quiero** disponer de servicios para autorizar, registrar y eliminar recursos almacenados en Cloudinary,<br>**para** mantener la trazabilidad y evitar operaciones no autorizadas.                                                                | **Escenario #1: Autorización generada.** Dado que se envía `POST /api/v1/media/upload-authorizations`, cuando el backend valida permisos y restricciones, entonces responde `200 OK` con firma temporal y parámetros mínimos.<br><br>**Escenario #2: Referencia registrada.** Dado que se envía `POST /api/v1/media-assets` con el resultado de carga, cuando el backend valida la referencia, entonces responde `201 CREATED` asociando el recurso.<br><br>**Escenario #3: Eliminación autorizada.** Dado que se envía `DELETE /api/v1/media-assets/{assetId}`, cuando Cloudinary confirma la eliminación, entonces responde `204 NO CONTENT` y registra la operación.<br><br>**Escenario #4: Error del proveedor.** Dado que Cloudinary falla durante la eliminación, cuando el backend no confirma el resultado, entonces responde `503` y mantiene la referencia.<br><br>**Escenario #5: Credenciales protegidas.** Dado que se inspeccionan respuestas, logs y clientes, cuando se administran recursos, entonces el secreto permanece en backend.                                                                                          | EP09                      |
| TS27               | **Limitación de desarrollo orientado a Android**                                     | **Como** Product Owner,<br>**quiero** restringir el desarrollo y empaquetado de la aplicación móvil exclusivamente al ecosistema Android,<br>**para** optimizar los costos de licenciamiento e infraestructura de despliegue inicial (Apple Developer Program y hardware macOS).  | **Escenario #1: Configuración de compilación exclusiva para Android.** Dado el repositorio del proyecto móvil, cuando se compila el artefacto de distribución, entonces se generan únicamente paquetes Android (APK/AAB) compatibles con las versiones de SDK definidas.<br><br>**Escenario #2: Exclusión de dependencias de iOS.** Dado el archivo de configuración y dependencias del proyecto, cuando se auditan las librerías del cliente móvil, entonces no existen servicios, perfiles de aprovisionamiento ni dependencias exclusivas de Apple/iOS.<br><br>**Escenario #3: Verificación de acceso multiplataforma.** Dado un usuario que intenta ejecutar el aplicativo desde un entorno no soportado, cuando se valida la compatibilidad de plataforma, entonces el sistema restringe el acceso indicando soporte exclusivo para dispositivos Android certificados.                                                                                                                                                                                                                                                                      | EP07                      |
| TS30               | **Adopción de Spring Boot como framework backend sin costo de licenciamiento**       | **Como** Solution Architect,<br>**quiero** fundamentar los servicios backend en el framework de código abierto Spring Boot,<br>**para** construir APIs REST robustas y escalables eliminando costos recurrentes por licencias de software comercial.                              | **Escenario #1: Construcción de microservicios con dependencias open source.** Dado el código base del backend desarrollado en Java, cuando se compila y empaqueta la solución, entonces se utilizan exclusivamente módulos de Spring Boot y bibliotecas bajo licencias libres (Apache 2.0/MIT) sin requerir licencias de servidor de aplicaciones comercial.<br><br>**Escenario #2: Despliegue de APIs REST en contenedor autónomo.** Dado el artefacto JAR ejecutable generado por Spring Boot, cuando se inicia el servicio en el entorno de ejecución, entonces el servidor embebido inicializa los endpoints REST de manera autónoma sin costos de middleware propietario.                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | EP07                      |
| TS31               | **Despliegue de servicios y cargas de trabajo en Microsoft Azure**                   | **Como** DevOps Engineer,<br>**quiero** estandarizar la infraestructura y el despliegue de microservicios en Microsoft Azure,<br>**para** aprovechar créditos educativos/emprendedores y servicios gestionados garantizando alta disponibilidad.                                  | **Escenario #1: Aprovisionamiento de servicios en Azure.** Dado el manifiesto de infraestructura y configuración en la nube, cuando se despliegan los servicios de backend y APIs, entonces se aprovisionan en Azure App Service/Azure Container Instances bajo suscripción controlada con monitoreo de consumo.<br><br>**Escenario #2: Configuración de variables de entorno y secretos.** Dado el entorno de despliegue en Azure, cuando los microservicios se conectan a recursos gestionados, entonces las cadenas de conexión y secretos se recuperan de Azure Key Vault o App Configuration de forma segura.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | EP07                      |
| TS32               | **Ajuste arquitectural y cuotas de consumo ante recursos económicos limitados**      | **Como** Technical Lead,<br>**quiero** restringir el dimensionamiento de recursos en la nube a planes gratuitos o niveles de bajo consumo,<br>**para** asegurar la viabilidad técnica y operativa del proyecto dentro del presupuesto financiero limitado del equipo.             | **Escenario #1: Ejecución dentro de tiers básicos o gratuitos (Free/B1).** Dado el plan de infraestructura cloud del proyecto, cuando se configuran las instancias de cómputo y bases de datos, entonces se seleccionan niveles Free o Basic (B1) con topes estrictos de consumo mensual para evitar cobros imprevistos.<br><br>**Escenario #2: Alerta temprana de presupuesto.** Dado el servicio de Azure Cost Management, cuando el consumo proyectado alcanza el 80% del presupuesto asignado, entonces se emite una notificación al equipo para optimizar cargas antes de agotar los fondos disponibles.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | EP07                      |
| TS33               | **Operación offline y cobertura de conectividad Bluetooth para actuadores**          | **Como** Embedded Developer,<br>**quiero** establecer una comunicación directa por Bluetooth Low Energy (BLE) entre el nodo Edge y los actuadores cuando no haya red externa,<br>**para** garantizar el control dentro de un rango doméstico acotado sin dependencia de Internet. | **Escenario #1: Conexión BLE dentro del rango de cobertura.** Dado que el nodo Edge y los módulos ESP32 operan dentro de una distancia máxima de 8 a 10 metros en línea de vista, cuando el nodo Edge envía una instrucción por BLE, entonces el actuador recibe el paquete de control y confirma su recepción satisfactoriamente.<br><br>**Escenario #2: Pérdida de alcance o señal atenuada.** Dado que un actuador supera la distancia de cobertura o sufre atenuación por muros estructurales, cuando el nodo Edge no recibe confirmación en la ventana de tiempo definida, entonces registra el estado de desconexión BLE y activa una rutina de reintento controlada.                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | EP06                      |
| TS34               | **Alcance de hardware acotado a prototipo funcional de dispositivo IoT**             | **Como** Product Owner,<br>**quiero** delimitar el entregable de hardware a un prototipo funcional en placa de desarrollo (ESP32/Raspberry Pi),<br>**para** validar la interacción domótica sin asumir los costos ni tiempos de diseño de PCB comercial y matricería industrial.  | **Escenario #1: Validación funcional con hardware de prototipado.** Dado el dispositivo IoT ensamblado sobre módulo de desarrollo ESP32 con sensores y actuadores cableados, cuando se ejecuta la batería de pruebas de encendido, lectura y conmutación, entonces el sistema valida la viabilidad del circuito y la lógica de control como prototipo funcional aceptado.<br><br>**Escenario #2: Criterio de aceptación técnica como prototipo.** Dado el proceso de evaluación del proyecto, cuando se audita el entregable físico, entonces se valida la interacción asistiva y estabilidad eléctrica sin exigir certificación industrial de carcasa final.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | EP06                      |
| TS35               | **Reconocimiento de voz calibrado para espacio acústicamente controlado**            | **Como** Embedded Developer,<br>**quiero** calibrar los algoritmos de captura y umbral de voz en una estancia con ruido ambiental moderado y controlado,<br>**para** asegurar una tasa aceptable de acierto en los comandos asistivos sin requerir hardware de audio industrial.  | **Escenario #1: Reconocimiento exitoso en ambiente con bajo ruido.** Dado que el usuario pronuncia un comando a una distancia de hasta 2 metros con un nivel de ruido inferior a 50 dB, cuando el micrófono del nodo Edge captura el audio, entonces el procesador identifica la palabra clave y la intención con una confianza superior al 75%.<br><br>**Escenario #2: Descarte en entorno con ruido excesivo.** Dado que el nivel de ruido ambiental de la habitación supera los 65 dB o hay solapamiento de conversaciones, cuando el módulo procesa la señal sonora, entonces descarta la captura ruidosa, evita falsos positivos y solicita verbalmente repetir la instrucción si es necesario.                                                                                                                                                                                                                                                                                                                                                                                                                                             | EP08                      |
| TS36               | **Persistencia transaccional y relacional de datos en PostgreSQL**                   | **Como** Backend Developer,<br>**quiero** implementar PostgreSQL como motor principal de base de datos relacional,<br>**para** garantizar integridad transaccional ACID, consistencia en cuentas, suscripciones y contratos sin costos de licencias propietarias.                 | **Escenario #1: Operación transaccional ACID.** Dado que se registran simultáneamente cambios en cuentas, pagos o asignación de dispositivos, cuando el backend ejecuta la transacción relacional en PostgreSQL, entonces se confirman los cambios de forma atómica o se realiza rollback ante cualquier fallo de integridad.<br><br>**Escenario #2: Gestión de esquemas y migraciones.** Dado el ciclo de despliegue continuo de la aplicación, cuando se aplican cambios estructurales de base de datos mediante scripts de migración, entonces PostgreSQL aplica las restricciones de claves foráneas e índices asegurando la consistencia del esquema.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | EP07                      |
| TS37               | **Persistencia de telemetría y datos no estructurados en MongoDB**                   | **Como** Backend Developer,<br>**quiero** integrar una base de datos NoSQL MongoDB,<br>**para** registrar documentos flexibles de telemetría de sensores, bitácoras de eventos IoT y cargas variables sin esquemas rígidos.                                                       | **Escenario #1: Almacenamiento de telemetría y eventos IoT.** Dado que los dispositivos Edge y actuadores envían lecturas de estado con esquemas variables en formato JSON, cuando el backend recibe los paquetes de telemetría, entonces los almacena de forma asíncrona en colecciones de MongoDB indexadas por `timestamp` y `deviceId`.<br><br>**Escenario #2: Consulta eficiente de series temporales de diagnóstico.** Dado que se requiere consultar el historial de diagnósticos o fallas de un nodo, cuando se ejecuta una búsqueda por rango temporal en MongoDB, entonces la base de datos devuelve los documentos en menos de 200 ms sin sobrecargar la base relacional principal.                                                                                                                                                                                                                                                                                                                                                                                                                                                   | EP07                      |
| TS38               | **Reconocimiento local de comandos de voz mediante microservicio en Python y Flask** | **Como** Embedded Developer,<br>**quiero** desplegar un servicio ligero en Python y Flask dentro del nodo Edge,<br>**para** ejecutar modelos de procesamiento de voz e inferencia local que no dependan de conectividad a la nube.                                                | **Escenario #1: Inferencia de comando por HTTP local.** Dado que el proceso de captura de audio envía un buffer PCM mediante `POST /edge/v1/voice-recognize` al servicio Flask, cuando el motor de inferencia en Python procesa el audio localmente, entonces responde `200 OK` con la intención detectada en menos de 1,5 segundos sin conexión a Internet.<br><br>**Escenario #2: Manejo de errores e indisponibilidad del modelo.** Dado que el modelo local de Python no cuenta con suficiente memoria disponible o la muestra de audio está corrupta, cuando Flask gestiona la excepción, entonces responde `422` o `500` con detalle estructurado y reinicia el worker de inferencia sin congelar el sistema Edge.                                                                                                                                                                                                                                                                                                                                                                                                                         | EP08                      |

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
A continuación se presenta el diagrama de la vista general del sistema, que muestra la relacion entre el sistema y los usuarios,visitantes y trabajadores de la plataforma, asi como los dispositivos Iot y servicios externos que interactuan con el sistema.

![System Landscape Diagram](../images/diagrams/img/alivia-landscape.svg)
### 4.3.2. Software Architecture Context Level Diagram

### 4.3.3. Software Architecture Container Level Diagram

### 4.3.4. Software Architecture Deployment Diagram

<div style="page-break-after: always;"></div>
