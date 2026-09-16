# Capítulo 4: Strategic-Level Software Design

## 4.1. Strategic-Level Attribute-Driven Design (ADD)

### 4.1.1. Design Purpose

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

<table>
    <tr>
        <th> Concern ID </th>
        <th> Título </th>
        <th> Descripción </th>
    </tr>
    <tr>
        <td> EP001 </td>
        <td> Si Va a Salir </td>
        <td> Concern ID </td>
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
