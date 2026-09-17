# Capítulo 4: Strategic-Level Software Design

## 4.1. Strategic-Level Attribute-Driven Design (ADD)

### 4.1.1. Design Purpose

El propósito de este diseño es establecer una arquitectura que integre dos componentes complementarios. El primero, basado en IoT y Edge Computing, permite a la persona con discapacidad motora realizar de forma autónoma acciones cotidianas del hogar, tales como abrir puertas y ventanas o encender luces, mediante comandos de voz interpretados localmente por un modelo de aprendizaje automático, garantizando respuesta inmediata incluso sin conexión a Internet. El segundo componente sincroniza esta información en la nube y gestiona el cuidado de la persona asistida (horarios, medicamentos y tareas), habilitando que el cuidador reciba alertas, supervise remotamente el estado del hogar y coordine la atención. La arquitectura debe conectar ambos componentes mediante un flujo de eventos: las acciones y solicitudes generadas en el borde alimentan la capa de supervisión y comunicación en la nube, sin que la autonomía inmediata dependa de esa sincronización.

### 4.1.2. Attribute-Driven Design Inputs

#### 4.1.2.1. Primary Functionality (Primary User Stories)

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

El Backlog de drivers de arquitectura fue conformado y priorizado tomando como base para juicio el Problem Statement de la solución descrito en el proceso Lean UX; los arquetipos formados a partir de información clave de los segmentos objetivos; los mapas de empatía y los mapas de impacto. A partir de estos recursos, se desarrolló el Quality Attribute Workshop para determinar cuáles son los drivers que deben ser tomados en cuenta para el diseño de la arquitectura de la solución. Para ello, se toman en cuenta los Functional Drivers que son capaces de modificar la arquitectura para su implementación; los Quality Attribute Drivers, los Constraints que limitan las decisiones de diseño y los Concerns que contemplan expectativas de los stakeholders.

Por otro lado, para la priorización del backlog, se tomaron en cuenta dos criterios: la importancia para los stakeholders y el impacto que el driver puede generar en la complejidad de la arquitectura. Para dar mayor sentido a la priorización, se colocaron en la parte superior de la tabla los drivers con mayor valor entregado a los stakeholders y los que mayor impacto generen en la toma de decisiones de diseño asociadas al entorno de Internet de las Cosas, procesamiento de comandos, sincronización en la nube y funciones de gestión del cuidado de la persona discapacitada. A continuación, se muestra la tabla priorizada de los drivers arquitectónicos.

<table>
    <tr>
        <th> Driver ID </th>
        <th> Título de Driver </th>
        <th> Descripción </th>
        <th> Importancia para Stakeholders (High, Medium, Low) </th>
        <th> Impacto en Architecture Technical Complexity (High, Medium, Low) </th>
    </tr>
    <tr>
        <td> AD001 </td>
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
