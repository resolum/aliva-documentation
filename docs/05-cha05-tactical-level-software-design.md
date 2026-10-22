# Capítulo 5: Tactical-Level Software Design

En este capítulo se presenta el diseño táctico de la solución de software de Alivia. Se incluye una sección por cada bounded context, con el diccionario de clases de su Domain Layer, su diagrama de clases y su diagrama de base de datos.

**Organización del Domain Layer.** En todos los bounded contexts, la capa de dominio se organiza en tres paquetes:

| Paquete | Contenido |
|---|---|
| `domain.model` | Modelo del dominio, dividido en `aggregates`, `entities`, `valueobjects`, `commands`, `queries` y `events`. |
| `domain.services` | Interfaces de los services de dominio: un `CommandService` (escritura) y un `QueryService` (lectura) por aggregate. |
| `domain.exceptions` | Excepciones que representan reglas de negocio incumplidas. |

**Convenciones usadas en el diccionario.**

| Convención | Significado |
|---|---|
| Visibilidad `private` | Atributo interno de una clase; solo cambia mediante los métodos de la clase. |
| Visibilidad `public` | Método o constructor que forma parte del comportamiento expuesto. |
| Visibilidad `protected` | Miembro de una base abstracta, disponible solo para sus subclases. |
| Componente de record | Los value objects, commands, queries y algunos eventos son `record` de Java: cada componente es `private final` y se lee con un accessor `public` del mismo nombre. En los diagramas se muestran con `+` por ese accessor. |
| Referencia a otro contexto | Un bounded context nunca guarda objetos de otro: solo su identidad mediante un value object de Shared (`UserId`, `PersonProfileId`, `StaffProfileId`, `BusinessProfileId`, `BusinessId`, `InstallationId`, `EdgeId`, `DeviceId`, `EmployeeId`, `AssistedPersonId`). |
| Instante actual | El dominio no consulta el reloj: recibe `now` (`LocalDateTime`) o `today` (`LocalDate`) como parámetro. La zona horaria (America/Lima) se configura una sola vez en Shared. |
| Repositories | Siguiendo la organización del proyecto, las interfaces de repositorio y su implementación se documentan en Infrastructure Layer. |


**Nombres de los bounded contexts en el código.** En el informe se usan los nombres del lenguaje ubicuo; en el código, cada bounded context es un paquete con nombre en inglés. En las descripciones se usa el nombre del paquete al referirse a otro contexto.

| Bounded context | Paquete | Sección |
|---|---|---|
| IAM | `iam` | 5.1 |
| Gestión del Negocio | `company` | 5.2 |
| Perfiles | `profiles` | 5.3 |
| Capital Humano | `hcm` | 5.4 |
| Asistencia Médica | `assistance` | 5.5 |
| Pagos y Suscripciones | `subscriptions` | 5.6 |
| Soporte Técnico | `support` | 5.7 |
| Comunicaciones | `communication` | 5.8 |
| Analíticas | `analytics` | 5.9 |
| Telemetría | `tracking` | 5.10 |
| Bienes | `assets` | 5.11 |
| Elementos compartidos | `shared` | Antes de 5.1 |

**Formato del diccionario de clases.** Cada clase se presenta en un recuadro con su nombre, categoría, propósito, atributos (nombre, tipo de dato, visibilidad y descripción), métodos (firma, tipo de retorno, visibilidad y descripción), reglas o invariantes y relaciones con otras clases (tipo, clase relacionada, multiplicidad y descripción). Las clases se agrupan por categoría: Aggregates, Entities, Value Objects, Enumerations, Domain Events, Commands, Queries, Domain Services y Exceptions. Los eventos indican qué aggregate los registra y qué activan; los commands, qué service los atiende y sus reglas. Al final de cada Domain Layer se incluyen las reglas generales que el diagrama documenta en sus notas.



## Elementos compartidos (Shared)

Shared reúne los elementos que usan todos los bounded contexts de Alivia: las bases auditables de aggregates y entidades, los value objects comunes y las reglas técnicas que siguen todos los contextos (la política de eventos y los procesos programados). No tiene commands, queries ni services propios: no representa un proceso de negocio, sino el vocabulario común con el que los demás contextos se referencian entre sí.

### Domain Layer

#### Aggregates (bases abstractas)

<table>
<tr><th colspan="4" align="left"><code>AuditableAbstractAggregateRoot</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Clase abstracta base de aggregates</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Base de los aggregates guardados en PostgreSQL. Aporta el id, las fechas de auditoría y el registro de eventos de dominio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>id</code></td><td><code>Long</code></td><td>private</td><td>Identificador generado por la base de datos.</td></tr>
<tr><td><code>createdAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Fecha y hora de creación.</td></tr>
<tr><td><code>updatedAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Fecha y hora de la última modificación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>addDomainEvent(Object event)</code></td><td><code>void</code></td><td>public</td><td>Registra un evento de dominio (<code>registerEvent</code> de Spring Data). Spring lo publica al guardar el aggregate (<code>save</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AuditableMongoAggregateRoot</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Clase abstracta base de aggregates</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">La misma base para los aggregates guardados en MongoDB (Telemetría). Su id es de texto.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>id</code></td><td><code>String</code></td><td>private</td><td>Identificador del documento en MongoDB.</td></tr>
<tr><td><code>createdAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Fecha y hora de creación.</td></tr>
<tr><td><code>updatedAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Fecha y hora de la última modificación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>addDomainEvent(Object event)</code></td><td><code>void</code></td><td>public</td><td>Registra un evento de dominio; se publica al guardar el aggregate.</td></tr>
</table>

#### Entities (base abstracta)

<table>
<tr><th colspan="4" align="left"><code>AuditableModel</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Clase abstracta base de entidades</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Base de las entidades internas de un aggregate (por ejemplo, <code>ActivityAssignment</code>, <code>Contract</code> y <code>Vacation</code>). Aporta el id y las fechas de auditoría.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>id</code></td><td><code>Long</code></td><td>private</td><td>Identificador generado por la base de datos.</td></tr>
<tr><td><code>createdAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Fecha y hora de creación.</td></tr>
<tr><td><code>updatedAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Fecha y hora de la última modificación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

#### Value Objects

Los value objects de identidad (`PersonProfileId`, `StaffProfileId`, `BusinessProfileId`, `UserId`, `BusinessId`, `InstallationId`, `EdgeId`, `DeviceId`, `EmployeeId` y `AssistedPersonId`) representan la identidad de un aggregate de otro contexto. Son la única forma en que un bounded context referencia a otro: no nulos y mayores que 0.

<table>
<tr><th colspan="4" align="left"><code>EmailAddress</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Correo electrónico válido y normalizado, para que la validación de correo ya registrado trate <code>Ana@x.com</code> y <code>ana@x.com</code> como el mismo correo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo con formato válido, sin espacios y en minúsculas.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmailAddress(String emailAddress)</code></td><td>(constructor)</td><td>public</td><td>Valida el formato y normaliza el correo (sin espacios y en minúsculas).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Photo</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Referencia a una imagen ya subida a un almacenamiento externo. El archivo (<code>byte[]</code>) que llega en los commands se sube fuera del dominio; el aggregate solo guarda la referencia.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>photoUrl</code></td><td><code>String</code></td><td>private final</td><td>URL pública de la imagen. No vacía.</td></tr>
<tr><td><code>photoPublicId</code></td><td><code>String</code></td><td>private final</td><td>Identificador de la imagen en el servicio de almacenamiento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Photo(String photoUrl, String photoPublicId)</code></td><td>(constructor)</td><td>public</td><td>Crea la referencia; <code>photoUrl</code> no puede estar vacío.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PersonProfileId</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Identidad de un <code>PersonProfile</code> de Profiles (cliente: familiar o persona asistida) en otro bounded context.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>personProfileId</code></td><td><code>Long</code></td><td>private final</td><td>Id del <code>PersonProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PersonProfileId(Long personProfileId)</code></td><td>(constructor)</td><td>public</td><td>Crea la identidad; no nula y mayor que 0.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>StaffProfileId</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Identidad de un <code>StaffProfile</code> de Profiles (personal de Alivia: administrador o empleado) en otro bounded context.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>staffProfileId</code></td><td><code>Long</code></td><td>private final</td><td>Id del <code>StaffProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>StaffProfileId(Long staffProfileId)</code></td><td>(constructor)</td><td>public</td><td>Crea la identidad; no nula y mayor que 0.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessProfileId</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Identidad de un <code>BusinessProfile</code> de Profiles (datos públicos del negocio) en otro bounded context.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessProfileId</code></td><td><code>Long</code></td><td>private final</td><td>Id del <code>BusinessProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessProfileId(Long businessProfileId)</code></td><td>(constructor)</td><td>public</td><td>Crea la identidad; no nula y mayor que 0.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UserId</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Identidad de una cuenta (<code>User</code>) de IAM en otro bounded context.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Id del <code>User</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UserId(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Crea la identidad; no nula y mayor que 0.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessId</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Identidad de un <code>Business</code> de Company en otro bounded context.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del <code>Business</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessId(Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Crea la identidad; no nula y mayor que 0.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationId</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Identidad de una <code>Installation</code> de Soporte Técnico en otro bounded context. La usan Assets, Tracking y Analytics.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la <code>Installation</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallationId(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la identidad; no nula y mayor que 0.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EdgeId</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Identidad de un <code>Edge</code> de Assets en otro bounded context. La usan IAM, Support y Tracking.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del <code>Edge</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EdgeId(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Crea la identidad; no nula y mayor que 0.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceId</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Identidad de un <code>Device</code> (micrófono o actuador) de Assets en otro bounded context. La usan Support y Tracking.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>deviceId</code></td><td><code>Long</code></td><td>private final</td><td>Id del <code>Device</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceId(Long deviceId)</code></td><td>(constructor)</td><td>public</td><td>Crea la identidad; no nula y mayor que 0.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeId</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Identidad de un <code>Employee</code> de HCM en otro bounded context. La usa Support para el técnico de cada visita.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del <code>Employee</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeId(Long employeeId)</code></td><td>(constructor)</td><td>public</td><td>Crea la identidad; no nula y mayor que 0.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssistedPersonId</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Identidad de una <code>AssistedPerson</code> de Assistance en otro bounded context. La usan Subscriptions y Support.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la <code>AssistedPerson</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssistedPersonId(Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Crea la identidad; no nula y mayor que 0.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>TimeRange</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Intervalo de horas semiabierto <code>[start, end)</code>. Lo usan <code>BusinessHours</code> (Profiles, mediante <code>WeeklyPeriod</code>), los turnos de HCM, el horario de cuidado de Assistance y las citas y visitas de Support. Si <code>end</code> es anterior a <code>start</code>, el rango cruza medianoche (22:00-06:00 empieza un día y termina al día siguiente); cada contexto decide si acepta rangos así.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>start</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de inicio (incluida).</td></tr>
<tr><td><code>end</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de fin (excluida). Distinta de <code>start</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>TimeRange(LocalTime start, LocalTime end)</code></td><td>(constructor)</td><td>public</td><td>Rechaza horas nulas o iguales.</td></tr>
<tr><td><code>contains(LocalTime time)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si una hora está dentro del rango (<code>start</code> incluido, <code>end</code> excluido). En 22:00-06:00, las 23:00 y las 03:00 están dentro.</td></tr>
<tr><td><code>contains(TimeRange other)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si otro rango está completamente dentro de este.</td></tr>
<tr><td><code>overlaps(TimeRange other)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si ambos rangos comparten algún tramo, empezando los dos el mismo día. 09:00-10:00 y 10:00-11:00 no se cruzan.</td></tr>
<tr><td><code>duration()</code></td><td><code>Duration</code></td><td>public</td><td>Tiempo total entre <code>start</code> y <code>end</code> (22:00-06:00 dura 8 horas).</td></tr>
<tr><td><code>crossesMidnight()</code></td><td><code>boolean</code></td><td>public</td><td>Verdadero si <code>end</code> es anterior a <code>start</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PhoneNumber</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Número telefónico internacional de cualquier país.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Código de país seguido del número nacional, sin "+" (ej. <code>51987654321</code>). Solo dígitos, máximo 15 (E.164).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PhoneNumber(String phoneNumber)</code></td><td>(constructor)</td><td>public</td><td>Rechaza letras, espacios y símbolos, y los números que no son válidos según el plan de numeración del país de su código (ej. Perú: 51 + móvil de 9 dígitos que empieza en 9).</td></tr>
<tr><td><code>countryCallingCode()</code></td><td><code>String</code></td><td>public</td><td>Devuelve el código de país del número.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Address</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Dirección geolocalizada obtenida de Google Maps.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>formattedAddress</code></td><td><code>String</code></td><td>private final</td><td>Dirección legible. No vacía.</td></tr>
<tr><td><code>latitude</code></td><td><code>Double</code></td><td>private final</td><td>Latitud, entre -90 y 90.</td></tr>
<tr><td><code>longitude</code></td><td><code>Double</code></td><td>private final</td><td>Longitud, entre -180 y 180.</td></tr>
<tr><td><code>placeId</code></td><td><code>String</code></td><td>private final</td><td>Identificador del lugar en Google Maps.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Address(String formattedAddress, Double latitude, Double longitude, String placeId)</code></td><td>(constructor)</td><td>public</td><td>Valida que <code>formattedAddress</code> no esté vacío y el rango de las coordenadas.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>WeeklyPeriod</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Bloque semanal: unos días de la semana con un mismo rango de horas (ej. lunes a viernes de 09:00 a 18:00).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>days</code></td><td><code>Set&lt;DayOfWeek&gt;</code></td><td>private final</td><td>Días de la semana. No vacío.</td></tr>
<tr><td><code>range</code></td><td><code>TimeRange</code></td><td>private final</td><td>Rango de horas de esos días.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>WeeklyPeriod(Set&lt;DayOfWeek&gt; days, TimeRange range)</code></td><td>(constructor)</td><td>public</td><td>Valida que <code>days</code> no esté vacío y que <code>range</code> sea válido.</td></tr>
<tr><td><code>occursOn(LocalDate date)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el periodo empieza en el día de la semana de esa fecha.</td></tr>
<tr><td><code>overlapsWith(WeeklyPeriod other)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si alguna ocurrencia de uno se cruza con alguna del otro. Si un rango cruza medianoche, también compara con el día siguiente (lunes 22:00-06:00 se cruza con martes 05:00-07:00).</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>range</code>)</td><td><code>TimeRange</code></td><td>1 a 1</td><td>Rango de horas de esos días.</td></tr>
</table>

#### Reglas generales

Las dos notas siguientes del diagrama de Shared rigen a todos los bounded contexts.

**Política de eventos (la capa de aplicación de cada contexto).** Cada aggregate registra sus eventos con `addDomainEvent` (`registerEvent` de Spring Data) y Spring los publica al guardarlo (`save`), como en learning-center-platform.

**Síncrono, en la misma transacción** (`@EventListener`): las cadenas dentro de un contexto (Support, Assistance, Assets, Subscriptions), Support hacia Assets, Subscriptions hacia Support (fin del servicio), HCM hacia IAM, Assets hacia IAM y Tracking, e IAM hacia Assistance. Si un handler falla, se revierte también el command que inició la cadena y el usuario recibe el error.

**Después del commit** (`@TransactionalEventListener` `AFTER_COMMIT`, como restock): todo lo que consumen Communication y Analytics; dentro de Communication, el envío por FCM (`AlertCreatedEvent` y `NotificationCreatedEvent`), para que la alerta o el aviso quede guardado aunque FCM falle; y Subscriptions cuando devuelve un pago (llama a Stripe). Un fallo ahí no revierte la operación de negocio, que ya es válida. Los eventos de Tracking (MongoDB) usan además `fallbackExecution` = true: ese guardado no abre una transacción de PostgreSQL.

**Orquestaciones entre contextos** (crear familiar, administrador o empleado: IAM, Profiles y el contexto dueño): una sola transacción; si un paso falla, no queda nada a medias.

**Eventos registrados en un constructor**: guardan el aggregate y leen su id al publicarse, porque antes de guardar no existe.

**Procesos programados (`@Scheduled` en la capa de aplicación).** Cada minuto: `DetectDisconnectedEdgesCommand` (Tracking; edges sin contacto por 5 minutos). Cada minuto: `RetryUndeliveredAlertsCommand` y `RetryUndeliveredPushNotificationsCommand` (Communication; hasta 5 intentos por alarma o aviso). Cada día a las 00:05: `ExpireOverdueAppointmentsCommand` y `CancelInstallationsWithoutAppointmentCommand` (Support; citas vencidas y plazo de 7 días hábiles) y `MarkMissedActivitiesCommand` (Assistance; con la fecha de ayer como `closingDate`). Son idempotentes: si se ejecutan dos veces, la segunda no cambia nada.

### Code Level Diagrams

#### Domain Layer Class Diagram

El diagrama muestra las bases abstractas (`AuditableAbstractAggregateRoot`, `AuditableMongoAggregateRoot` y `AuditableModel`) y los value objects compartidos, con sus atributos, métodos y visibilidad. La única relación propia de Shared es la composición entre `WeeklyPeriod` y `TimeRange` (1 a 1). Las notas documentan las invariantes de cada value object, la semántica de `TimeRange`, la política de eventos que siguen todos los contextos y los procesos programados.

![Diagrama de clases de la capa de dominio - Elementos compartidos (Shared)](../images/diagrams/img/chapter-5/shared-backend-diagram.svg)

#### Database Design Diagram

Shared no tiene tablas propias. Sus bases se reflejan en las tablas de cada contexto: toda tabla de aggregate o entidad en PostgreSQL tiene `id` (`BIGINT`, identity), `created_at` y `updated_at` (`TIMESTAMP`), y todo documento de MongoDB (Telemetría) tiene `_id` (`ObjectId`), `created_at` y `updated_at`. Sus value objects se guardan como columnas de la tabla que los usa (por ejemplo, `Address` se guarda como `formatted_address`, `latitude`, `longitude` y `place_id` en `installations`), y los value objects de identidad, como columnas `BIGINT` sin llave foránea, porque apuntan a otro bounded context.

<div style="page-break-after: always;"></div>

## 5.1. Bounded Context: IAM

En el código, este bounded context es el paquete `iam`. IAM gestiona las cuentas con las que las personas y los edges acceden a Alivia: el registro con verificación de correo, el inicio de sesión, las contraseñas, los roles y las credenciales de los edges. Una cuenta se identifica con su correo, que es el mismo del perfil de la persona, y cada correo es una sola cuenta. Las cuentas son personales (familiar o cuidador, con un solo rol) o corporativas (administrador y empleados). Los demás contextos guardan solo el `UserId` de la cuenta y le piden a IAM, mediante su ACL, que la cree; IAM no guarda ids de otros contextos de personas. Se basa en el contexto IAM del repositorio de referencia (`User`, `Role`, `SignUp`, `SignIn` y la carga inicial de roles), con el hash de contraseñas y los tokens JWT en la capa de aplicación.

### 5.1.1. Domain Layer

#### Aggregates

<table>
<tr><th colspan="4" align="left"><code>User</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Una cuenta de Alivia: correo, contraseña, tipo de cuenta, estado y roles. Las fábricas ponen el tipo de cuenta según el rol.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>EmailAddress</code></td><td>private</td><td>Correo de la cuenta, normalizado en minúsculas. Es el usuario para iniciar sesión y no se repite (<code>EmailAddressAlreadyExists</code>).</td></tr>
<tr><td><code>password</code></td><td><code>HashedPassword</code></td><td>private</td><td>Contraseña hasheada. Vacía mientras un cuidador invitado no define la suya.</td></tr>
<tr><td><code>temporaryPassword</code></td><td><code>boolean</code></td><td>private</td><td>Verdadero mientras el empleado no cambia su contraseña temporal.</td></tr>
<tr><td><code>accountType</code></td><td><code>AccountType</code></td><td>private</td><td><code>PERSONAL</code> o <code>CORPORATE</code>.</td></tr>
<tr><td><code>status</code></td><td><code>AccountStatus</code></td><td>private</td><td><code>PENDING</code>, <code>ACTIVE</code>, <code>BLOCKED</code> o <code>DEACTIVATED</code>.</td></tr>
<tr><td><code>roles</code></td><td><code>Set&lt;Role&gt;</code></td><td>private</td><td>Conjunto de roles de la cuenta. Una cuenta <code>PERSONAL</code> tiene un solo rol: <code>ROLE_RELATIVE</code> o <code>ROLE_CAREGIVER</code>.</td></tr>
<tr><td><code>passwordToken</code></td><td><code>PasswordToken</code></td><td>private</td><td>Enlace vigente para definir o recuperar la contraseña, si lo hay.</td></tr>
<tr><td><code>emailVerified</code></td><td><code>boolean</code></td><td>private</td><td>Verdadero cuando el correo está verificado.</td></tr>
<tr><td><code>verificationCode</code></td><td><code>VerificationCode</code></td><td>private</td><td>Código de verificación vigente, si lo hay.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>signUp(EmailAddress emailAddress, HashedPassword password, Role role, VerificationCode code, String rawCode)</code></td><td><code>User</code></td><td>public static</td><td>Cuenta <code>PENDING</code> con la contraseña del usuario (administrador o familiar) y un código de verificación. El tipo de cuenta sale del rol. Registra <code>EmailVerificationRequestedEvent</code>.</td></tr>
<tr><td><code>invited(EmailAddress emailAddress, Role caregiverRole, PasswordToken token)</code></td><td><code>User</code></td><td>public static</td><td>Cuenta <code>PERSONAL</code> <code>PENDING</code> de un cuidador invitado, sin contraseña, con <code>ROLE_CAREGIVER</code> y un token <code>SETUP</code>. Nace con <code>emailVerified</code> verdadero: el enlace llega a su correo y eso prueba que es suyo.</td></tr>
<tr><td><code>corporate(EmailAddress emailAddress, HashedPassword temporaryPassword, Role role)</code></td><td><code>User</code></td><td>public static</td><td>Cuenta <code>CORPORATE</code> <code>PENDING</code> de un empleado, con contraseña temporal (<code>temporaryPassword</code> verdadero) y su rol. Nace con <code>emailVerified</code> verdadero, así <code>SignInCommand</code> con la contraseña temporal responde <code>PasswordChangeRequired</code> y no <code>EmailNotVerified</code>. Registra <code>CorporateAccountCreatedEvent</code>.</td></tr>
<tr><td><code>replaceCorporateRole(Role role)</code></td><td><code>void</code></td><td>public</td><td>Solo cuentas <code>CORPORATE</code> con rol de empleado; reemplaza el anterior.</td></tr>
<tr><td><code>hasRole(Roles role)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la cuenta tiene el rol.</td></tr>
<tr><td><code>verifyEmail(String codeHash, LocalDateTime now)</code></td><td><code>void</code></td><td>public</td><td>El código coincide (<code>InvalidVerificationCode</code>) y no venció (<code>VerificationCodeExpired</code>); el correo no estaba verificado (<code>EmailAlreadyVerified</code>). Deja la cuenta <code>ACTIVE</code> y borra el código.</td></tr>
<tr><td><code>renewVerificationCode(VerificationCode code, String rawCode)</code></td><td><code>void</code></td><td>public</td><td>Solo si el correo no está verificado (<code>EmailAlreadyVerified</code>); el código anterior deja de valer. Registra <code>EmailVerificationRequestedEvent</code>.</td></tr>
<tr><td><code>issuePasswordToken(PasswordToken token)</code></td><td><code>void</code></td><td>public</td><td><code>SETUP</code> solo en una cuenta <code>PENDING</code> sin contraseña (regenera el enlace; el anterior deja de valer); <code>RESET</code> solo en una cuenta <code>ACTIVE</code> (<code>AccountNotActive</code>). Registra <code>PasswordResetRequestedEvent</code> si es <code>RESET</code>.</td></tr>
<tr><td><code>definePassword(String tokenHash, HashedPassword password, LocalDateTime now)</code></td><td><code>void</code></td><td>public</td><td>El token coincide y es del propósito esperado (<code>InvalidPasswordToken</code>), no venció (<code>PasswordTokenExpired</code>); deja la cuenta <code>ACTIVE</code>, borra el token y, si estaba <code>PENDING</code>, registra <code>PasswordDefinedEvent</code>.</td></tr>
<tr><td><code>changeTemporaryPassword(HashedPassword password)</code></td><td><code>void</code></td><td>public</td><td>La contraseña es temporal (<code>PasswordNotTemporary</code>); deja la cuenta <code>ACTIVE</code> y registra <code>PasswordDefinedEvent</code>.</td></tr>
<tr><td><code>renewTemporaryPassword(HashedPassword temporaryPassword, String rawPassword)</code></td><td><code>void</code></td><td>public</td><td>Solo una cuenta <code>CORPORATE</code> <code>PENDING</code> con contraseña temporal (<code>PasswordNotTemporary</code>; <code>AccountNotPending</code>); reemplaza la anterior, que deja de valer, y registra <code>TemporaryPasswordRenewedEvent</code>. Sirve cuando el correo con la primera no llegó.</td></tr>
<tr><td><code>changePassword(HashedPassword password)</code></td><td><code>void</code></td><td>public</td><td>Cambia la contraseña de una cuenta <code>ACTIVE</code> (<code>AccountNotActive</code>).</td></tr>
<tr><td><code>block()</code></td><td><code>void</code></td><td>public</td><td>De <code>PENDING</code> o <code>ACTIVE</code> a <code>BLOCKED</code> (empleado suspendido).</td></tr>
<tr><td><code>unblock()</code></td><td><code>void</code></td><td>public</td><td>De <code>BLOCKED</code> a <code>ACTIVE</code>, o a <code>PENDING</code> si aún no completó su activación.</td></tr>
<tr><td><code>deactivate()</code></td><td><code>void</code></td><td>public</td><td>De cualquier estado a <code>DEACTIVATED</code>, estado final (empleado cesado).</td></tr>
<tr><td><code>canSignIn()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la cuenta está <code>ACTIVE</code>. Una cuenta <code>ACTIVE</code> siempre tiene el correo verificado y una contraseña definitiva.</td></tr>
<tr><td><code>hasDefinedPassword()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si ya tiene una contraseña.</td></tr>
<tr><td><code>isEmailVerified()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el correo está verificado.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Cada rol se asigna solo a su tipo de cuenta (<code>RoleNotAllowedForAccountType</code>). Una transición de estado no permitida lanza <code>InvalidAccountStatusTransition</code>.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>roles</code>)</td><td><code>Role</code></td><td>0..* a 1..*</td><td>Conjunto de roles de la cuenta.</td></tr>
<tr><td>Composición (<code>password</code>)</td><td><code>HashedPassword</code></td><td>1 a 0..1</td><td>Contraseña hasheada.</td></tr>
<tr><td>Composición (<code>passwordToken</code>)</td><td><code>PasswordToken</code></td><td>1 a 0..1</td><td>Enlace vigente para definir o recuperar la contraseña, si lo hay.</td></tr>
<tr><td>Composición (<code>verificationCode</code>)</td><td><code>VerificationCode</code></td><td>1 a 0..1</td><td>Código de verificación vigente, si lo hay.</td></tr>
<tr><td>Asociación dirigida (<code>accountType</code>)</td><td><code>AccountType</code></td><td>0..* a 1</td><td><code>PERSONAL</code> o <code>CORPORATE</code>.</td></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>AccountStatus</code></td><td>0..* a 1</td><td><code>PENDING</code>, <code>ACTIVE</code>, <code>BLOCKED</code> o <code>DEACTIVATED</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceCredential</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Credencial con la que un edge se autentica ante la API. Assets decide qué puede enviar el edge; IAM solo lo autentica.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>EdgeId</code></td><td>private</td><td>Id del <code>Edge</code> de Assets dueño de la credencial.</td></tr>
<tr><td><code>secret</code></td><td><code>HashedPassword</code></td><td>private</td><td>Secreto del edge, hasheado.</td></tr>
<tr><td><code>status</code></td><td><code>CredentialStatus</code></td><td>private</td><td><code>ACTIVE</code> o <code>REVOKED</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceCredential(EdgeId edgeId, HashedPassword secret)</code></td><td>(constructor)</td><td>public</td><td>Crea la credencial <code>ACTIVE</code>.</td></tr>
<tr><td><code>revoke()</code></td><td><code>void</code></td><td>public</td><td>De <code>ACTIVE</code> a <code>REVOKED</code> (<code>DeviceCredentialRevoked</code> si ya lo está).</td></tr>
<tr><td><code>isActive()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la credencial está <code>ACTIVE</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Un edge tiene una sola credencial <code>ACTIVE</code> (<code>DeviceCredentialAlreadyExists</code>). Nace cuando el administrador registra el edge en Assets (<code>RegisterEdgeCommand</code>). El secreto se genera en la capa de aplicación, se muestra una sola vez para configurar el edge y se guarda hasheado. Se revoca cuando el edge sale de una red o la red se desactiva; para volver a usar el edge, Assets la renueva (<code>RenewEdgeCredentialCommand</code>).</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>secret</code>)</td><td><code>HashedPassword</code></td><td>1 a 1</td><td>Secreto del edge, hasheado.</td></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>CredentialStatus</code></td><td>0..* a 1</td><td><code>ACTIVE</code> o <code>REVOKED</code>.</td></tr>
</table>

#### Entities

<table>
<tr><th colspan="4" align="left"><code>Role</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Entity de catálogo</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Un rol de Alivia, como en el repositorio de referencia: una fila por cada valor de <code>Roles</code>, creada al iniciar la aplicación con <code>SeedRolesCommand</code>. No cambia.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>name</code></td><td><code>Roles</code></td><td>private</td><td>Nombre del rol.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Role(Roles name)</code></td><td>(constructor)</td><td>public</td><td>Crea el rol.</td></tr>
<tr><td><code>getStringName()</code></td><td><code>String</code></td><td>public</td><td>Nombre del rol como texto.</td></tr>
<tr><td><code>allowedFor(AccountType type)</code></td><td><code>boolean</code></td><td>public</td><td><code>ROLE_ADMIN</code>, <code>ROLE_TECH</code>, <code>ROLE_SUBSCRIPTION_MANAGER</code> y <code>ROLE_CLEANING</code> son corporativos; <code>ROLE_RELATIVE</code> y <code>ROLE_CAREGIVER</code>, personales.</td></tr>
<tr><td><code>isEmployeeRole()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si es <code>ROLE_TECH</code>, <code>ROLE_SUBSCRIPTION_MANAGER</code> o <code>ROLE_CLEANING</code>.</td></tr>
<tr><td><code>toRoleFromName(String name)</code></td><td><code>Role</code></td><td>public static</td><td>Crea el rol desde su nombre.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>name</code>)</td><td><code>Roles</code></td><td>0..* a 1</td><td>Nombre del rol.</td></tr>
</table>

#### Value Objects

**Value objects de Shared que usa este contexto.** **`EmailAddress`**: correo de la cuenta, normalizado en minúsculas. Es el mismo correo del `PersonProfile` o del `StaffProfile` de la persona. **`UserId`**: los demás contextos guardan el id de `User` con este value object; IAM no guarda ids de otros contextos de personas. **`EdgeId`**: el edge de Assets dueño de una `DeviceCredential`.

<table>
<tr><th colspan="4" align="left"><code>HashedPassword</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Contraseña o secreto ya hasheado por <code>HashingService</code> en la capa de aplicación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>value</code></td><td><code>String</code></td><td>private final</td><td>Hash de la contraseña o del secreto.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>HashedPassword(String value)</code></td><td>(constructor)</td><td>public</td><td>Crea el valor; no puede estar vacío.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PasswordToken</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Enlace de un solo uso para definir la contraseña de una cuenta invitada (<code>SETUP</code>) o recuperarla (<code>RESET</code>). El token real va en la url; aquí solo su hash.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>tokenHash</code></td><td><code>String</code></td><td>private final</td><td>Hash del token.</td></tr>
<tr><td><code>purpose</code></td><td><code>TokenPurpose</code></td><td>private final</td><td><code>SETUP</code> o <code>RESET</code>.</td></tr>
<tr><td><code>expiresAt</code></td><td><code>LocalDateTime</code></td><td>private final</td><td>Vencimiento. <code>SETUP</code> vence junto con la invitación (<code>expiresAt</code> de Assistance); <code>RESET</code>, según la configuración de la capa de aplicación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PasswordToken(String tokenHash, TokenPurpose purpose, LocalDateTime expiresAt)</code></td><td>(constructor)</td><td>public</td><td>Crea el enlace con el hash del token, su propósito y su vencimiento.</td></tr>
<tr><td><code>matches(String tokenHash, TokenPurpose purpose)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el token y el propósito coinciden.</td></tr>
<tr><td><code>isExpired(LocalDateTime now)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si venció.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>purpose</code>)</td><td><code>TokenPurpose</code></td><td>0..* a 1</td><td><code>SETUP</code> o <code>RESET</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VerificationCode</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Código numérico que llega al correo al registrarse. Se guarda solo su hash; la vigencia la fija la capa de aplicación desde configuración.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>codeHash</code></td><td><code>String</code></td><td>private final</td><td>Hash del código.</td></tr>
<tr><td><code>expiresAt</code></td><td><code>LocalDateTime</code></td><td>private final</td><td>Vencimiento del código.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>VerificationCode(String codeHash, LocalDateTime expiresAt)</code></td><td>(constructor)</td><td>public</td><td>Crea el código.</td></tr>
<tr><td><code>matches(String codeHash)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el código coincide.</td></tr>
<tr><td><code>isExpired(LocalDateTime now)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si venció.</td></tr>
</table>

#### Enumerations

<table>
<tr><th colspan="4" align="left"><code>Roles</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3"><code>Roles</code> de Alivia. Los de empleado son los <code>EmployeeRole</code> de HCM.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>ROLE_ADMIN</code>, <code>ROLE_TECH</code>, <code>ROLE_SUBSCRIPTION_MANAGER</code>, <code>ROLE_CLEANING</code>, <code>ROLE_RELATIVE</code>, <code>ROLE_CAREGIVER</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AccountType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cuenta de cliente (familiar o cuidador) o del personal (administrador o empleado).</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>PERSONAL</code>, <code>CORPORATE</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AccountStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de la cuenta. <code>PENDING</code>: aún no verifica su correo, no define su contraseña o tiene una contraseña temporal.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>PENDING</code>, <code>ACTIVE</code>, <code>BLOCKED</code>, <code>DEACTIVATED</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>TokenPurpose</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Propósito de un enlace de contraseña.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>SETUP</code>, <code>RESET</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CredentialStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de la credencial de un edge.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>ACTIVE</code>, <code>REVOKED</code></td></tr>
</table>

#### Domain Events

`PasswordDefinedEvent`: el usuario definió su primera contraseña. Assistance acepta sus invitaciones `PENDING` (`GetPendingInvitationsByCaregiverUserIdQuery`). `CorporateAccountCreatedEvent`: Communication envía la bienvenida con la contraseña temporal al correo corporativo. Lee el id al publicarse. La contraseña temporal solo viaja en el evento; se guarda hasheada. `TemporaryPasswordRenewedEvent`: Communication vuelve a enviar `CORPORATE_ACCOUNT` con la contraseña nueva. `PasswordResetRequestedEvent`: Communication envía el enlace de recuperación. `EmailVerificationRequestedEvent`: Communication envía el código de verificación. Lee el id al publicarse.

<table>
<tr><th colspan="4" align="left"><code>PasswordDefinedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que una cuenta definió su primera contraseña y quedó activa.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la cuenta.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PasswordDefinedEvent(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>User.definePassword</code>, <code>User.changeTemporaryPassword</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Assistance acepta las invitaciones <code>PENDING</code> del cuidador (<code>GetPendingInvitationsByCaregiverUserIdQuery</code>). Síncrono, en la misma transacción.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CorporateAccountCreatedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que se creó la cuenta corporativa de un empleado con una contraseña temporal.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>user</code></td><td><code>User</code></td><td>private</td><td>Cuenta corporativa creada; su id se lee al publicarse.</td></tr>
<tr><td><code>temporaryPassword</code></td><td><code>String</code></td><td>private</td><td>Contraseña temporal del empleado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CorporateAccountCreatedEvent(User user, String temporaryPassword)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><code>getUserId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>userId</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getEmailAddress()</code></td><td><code>String</code></td><td>public</td><td>Devuelve <code>emailAddress</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getTemporaryPassword()</code></td><td><code>String</code></td><td>public</td><td>Devuelve <code>temporaryPassword</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>User.corporate</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Communication envía la bienvenida con la contraseña temporal al correo corporativo (plantilla <code>CORPORATE_ACCOUNT</code>). Después del commit. La contraseña temporal solo viaja en el evento; se guarda hasheada.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailVerificationRequestedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que una cuenta necesita verificar su correo con un código.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>user</code></td><td><code>User</code></td><td>private</td><td>Cuenta que originó el evento; su id se lee al publicarse.</td></tr>
<tr><td><code>code</code></td><td><code>String</code></td><td>private</td><td>Código de verificación recibido en el correo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmailVerificationRequestedEvent(User user, String code)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><code>getUserId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>userId</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getEmailAddress()</code></td><td><code>String</code></td><td>public</td><td>Devuelve <code>emailAddress</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getCode()</code></td><td><code>String</code></td><td>public</td><td>Devuelve <code>code</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>User.signUp</code>, <code>User.renewVerificationCode</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Communication envía el código de verificación al correo. Después del commit.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>TemporaryPasswordRenewedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que el administrador renovó la contraseña temporal de un empleado que no recibió el primer correo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>user</code></td><td><code>User</code></td><td>private</td><td>Cuenta corporativa; su id se lee al publicarse.</td></tr>
<tr><td><code>temporaryPassword</code></td><td><code>String</code></td><td>private</td><td>Contraseña temporal nueva. Solo viaja en el evento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>TemporaryPasswordRenewedEvent(User user, String temporaryPassword)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con el aggregate que lo registra.</td></tr>
<tr><td><code>getUserId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>userId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getEmailAddress()</code></td><td><code>String</code></td><td>public</td><td>Devuelve <code>emailAddress</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getTemporaryPassword()</code></td><td><code>String</code></td><td>public</td><td>Devuelve <code>temporaryPassword</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>User.renewTemporaryPassword</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Communication vuelve a enviar <code>CORPORATE_ACCOUNT</code> con la contraseña nueva. Después del commit.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PasswordResetRequestedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que una cuenta pidió recuperar su contraseña.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la cuenta.</td></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><td><code>resetUrl</code></td><td><code>String</code></td><td>private final</td><td>Url del enlace de recuperación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PasswordResetRequestedEvent(Long userId, String emailAddress, String resetUrl)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>User.issuePasswordToken</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Communication envía el enlace de recuperación. Después del commit.</td></tr>
</table>

#### Commands

<table>
<tr><th colspan="4" align="left"><code>SeedRolesCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea los roles que falten al iniciar la aplicación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SeedRolesCommand()</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>RoleCommandService</code>, que devuelve <code>void</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SignUpCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Registro con contraseña propia del administrador (Company) o del familiar (Assistance).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><td><code>password</code></td><td><code>String</code></td><td>private final</td><td>Contraseña de su cuenta. Se oculta en <code>toString()</code>.</td></tr>
<tr><td><code>role</code></td><td><code>Roles</code></td><td>private final</td><td><code>ROLE_ADMIN</code> o <code>ROLE_RELATIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SignUpCommand(String emailAddress, String password, Roles role)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>UserCommandService</code>, que devuelve <code>Optional&lt;User&gt;</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">(Company: administrador; Assistance: familiar). El rol existe (<code>RoleNotFound</code>) y es <code>ROLE_ADMIN</code> o <code>ROLE_RELATIVE</code>. El correo no tiene cuenta (<code>EmailAddressAlreadyExists</code>): un cuidador que se registra como familiar usa otro correo. Crea <code>User.signUp</code> (<code>PENDING</code> hasta verificar el correo); la capa de aplicación genera el código. Devuelve el <code>User</code> (su id es el <code>UserId</code> que guardan los demás contextos).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VerifyEmailCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Verifica el correo con el código recibido.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><td><code>code</code></td><td><code>String</code></td><td>private final</td><td>Código de verificación recibido en el correo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>VerifyEmailCommand(String emailAddress, String code)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>UserCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El correo existe (<code>InvalidCredentials</code>) y llama a <code>verifyEmail</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ResendVerificationCodeCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Pide un código de verificación nuevo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ResendVerificationCodeCommand(String emailAddress)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>UserCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Genera un código nuevo (<code>renewVerificationCode</code>); si el correo no existe no lanza error.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SignInCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Inicia sesión con correo y contraseña.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><td><code>password</code></td><td><code>String</code></td><td>private final</td><td>Contraseña de su cuenta. Se oculta en <code>toString()</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SignInCommand(String emailAddress, String password)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>UserCommandService</code>, que devuelve <code>Optional&lt;ImmutablePair&lt;User, String&gt;&gt;</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El correo existe y la contraseña coincide (<code>InvalidCredentials</code>, el mismo error para ambos casos); el correo está verificado (<code>EmailNotVerified</code>); con contraseña temporal pide cambiarla (<code>PasswordChangeRequired</code>); la cuenta está <code>ACTIVE</code> (<code>AccountNotActive</code>). Devuelve el <code>User</code> y el token JWT.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RegisterInvitedCaregiverCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea o reutiliza la cuenta de un cuidador invitado (Assistance).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><td><code>expiresAt</code></td><td><code>LocalDateTime</code></td><td>private final</td><td>Vencimiento de la invitación; el token <code>SETUP</code> vence a la misma hora.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RegisterInvitedCaregiverCommand(String emailAddress, LocalDateTime expiresAt)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>UserCommandService</code>, que devuelve <code>Optional&lt;ImmutablePair&lt;User, String&gt;&gt;</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">(Assistance). Correo sin cuenta: crea <code>User.invited</code> y devuelve el token <code>SETUP</code> para la url. Cuenta <code>PENDING</code> sin contraseña (invitación anterior sin aceptar): regenera el token. Cuenta de cuidador con contraseña (ya cuida a otra persona): la reutiliza y no devuelve token (la invitación llega como notificación). Cuenta de familiar o <code>CORPORATE</code>: <code>EmailAddressAlreadyExists</code> (para cuidar a otra persona se usa otro correo).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateCorporateAccountCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea la cuenta corporativa de un empleado (HCM) con su rol.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><td><code>role</code></td><td><code>Roles</code></td><td>private final</td><td>Rol de empleado: <code>ROLE_TECH</code>, <code>ROLE_SUBSCRIPTION_MANAGER</code> o <code>ROLE_CLEANING</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateCorporateAccountCommand(String emailAddress, Roles role)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>UserCommandService</code>, que devuelve <code>Optional&lt;User&gt;</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">(HCM). El correo no tiene cuenta (<code>EmailAddressAlreadyExists</code>); el rol es de empleado. la capa de aplicación genera la contraseña temporal.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DefinePasswordCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define la contraseña con un enlace de invitación o de recuperación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>token</code></td><td><code>String</code></td><td>private final</td><td>Token recibido en el enlace.</td></tr>
<tr><td><code>purpose</code></td><td><code>TokenPurpose</code></td><td>private final</td><td><code>SETUP</code> (invitación) o <code>RESET</code> (recuperación).</td></tr>
<tr><td><code>newPassword</code></td><td><code>String</code></td><td>private final</td><td>Contraseña nueva.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DefinePasswordCommand(String token, TokenPurpose purpose, String newPassword)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>UserCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Busca la cuenta por el hash del token (<code>InvalidPasswordToken</code>) y llama a <code>definePassword</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ChangeTemporaryPasswordCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El empleado reemplaza su contraseña temporal por una definitiva.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><td><code>temporaryPassword</code></td><td><code>String</code></td><td>private final</td><td>Contraseña temporal que recibió por correo.</td></tr>
<tr><td><code>newPassword</code></td><td><code>String</code></td><td>private final</td><td>Contraseña nueva.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ChangeTemporaryPasswordCommand(String emailAddress, String temporaryPassword, String newPassword)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>UserCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La contraseña temporal coincide (<code>InvalidCredentials</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RenewTemporaryPasswordCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El administrador genera una contraseña temporal nueva para un empleado que no recibió el correo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta corporativa del empleado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RenewTemporaryPasswordCommand(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>UserCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lo envía el administrador (<code>ROLE_ADMIN</code>) con el <code>userId</code> del empleado, que ve en HCM, cuando el empleado no recibió el correo (lo ve en Communication, <code>GetAllEmailsByStatusQuery</code> con <code>FAILED</code>). El usuario existe (<code>UserNotFound</code>) y la capa de aplicación confirma en HCM que es un empleado del negocio del administrador (<code>GetEmployeeByUserIdQuery</code> y <code>belongsTo</code>); genera la contraseña nueva y llama a <code>renewTemporaryPassword</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ChangePasswordCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cambia la contraseña con la sesión iniciada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta que cambia su contraseña (sale de la sesión).</td></tr>
<tr><td><code>currentPassword</code></td><td><code>String</code></td><td>private final</td><td>Contraseña actual.</td></tr>
<tr><td><code>newPassword</code></td><td><code>String</code></td><td>private final</td><td>Contraseña nueva.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ChangePasswordCommand(Long userId, String currentPassword, String newPassword)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>UserCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La contraseña actual coincide (<code>InvalidCredentials</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RequestPasswordResetCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Pide un enlace para recuperar la contraseña.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RequestPasswordResetCommand(String emailAddress)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>UserCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Si el correo no tiene cuenta no lanza error (no revela qué correos existen). <code>ChangePasswordCommand</code> y <code>RequestPasswordResetCommand</code> valen para cualquier cuenta <code>ACTIVE</code>, sin importar el rol: familiar, cuidador, administrador o empleado. Cada uno define su primera contraseña a su manera (familiar y administrador al registrarse, cuidador con el enlace de la invitación, empleado cambiando la temporal); después todos la cambian igual.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ChangeUserRoleCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cambia el rol de la cuenta de un empleado. Lo activa <code>EmployeeRoleChangedEvent</code> de HCM.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta corporativa del empleado.</td></tr>
<tr><td><code>role</code></td><td><code>Roles</code></td><td>private final</td><td>Rol nuevo de empleado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ChangeUserRoleCommand(Long userId, Roles role)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>UserCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El usuario existe (<code>UserNotFound</code>). Los activan los eventos de HCM.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BlockUserCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Bloquea la cuenta de un empleado suspendido. Lo activa <code>EmployeeSuspendedEvent</code> de HCM.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta corporativa del empleado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BlockUserCommand(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>UserCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El usuario existe (<code>UserNotFound</code>). Los activan los eventos de HCM.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UnblockUserCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Desbloquea la cuenta de un empleado reincorporado. Lo activa <code>EmployeeReinstatedEvent</code> de HCM.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta corporativa del empleado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UnblockUserCommand(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>UserCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El usuario existe (<code>UserNotFound</code>). Los activan los eventos de HCM.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeactivateUserCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Desactiva la cuenta de un empleado cesado. Lo activa <code>EmployeeTerminatedEvent</code> de HCM; la cuenta personal de la misma persona, si la tiene, no cambia.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta corporativa del empleado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeactivateUserCommand(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>UserCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El usuario existe (<code>UserNotFound</code>). Los activan los eventos de HCM.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>IssueDeviceCredentialCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea la credencial de un edge cuando el administrador lo registra en Assets (por ACL) o la renueva.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>IssueDeviceCredentialCommand(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>DeviceCredentialCommandService</code>, que devuelve <code>Optional&lt;ImmutablePair&lt;DeviceCredential, String&gt;&gt;</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El edge no tiene otra credencial <code>ACTIVE</code> (<code>DeviceCredentialAlreadyExists</code>). la capa de aplicación genera el secreto y lo devuelve una sola vez.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RevokeDeviceCredentialCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Revoca la credencial de un edge que salió de su red o cuya red se desactivó.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RevokeDeviceCredentialCommand(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>DeviceCredentialCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Revoca la credencial <code>ACTIVE</code> del edge. Si no tiene una, no hace nada: llega por eventos que pueden repetirse (el edge sale de la red después de que la red se desactivó).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AuthenticateDeviceCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Autentica al edge con su secreto y devuelve su token.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><td><code>secret</code></td><td><code>String</code></td><td>private final</td><td>Secreto del edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AuthenticateDeviceCommand(Long edgeId, String secret)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>DeviceCredentialCommandService</code>, que devuelve <code>Optional&lt;String&gt;</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Existe (<code>DeviceCredentialNotFound</code>), está <code>ACTIVE</code> (<code>DeviceCredentialRevoked</code>) y el secreto coincide (<code>InvalidCredentials</code>). Devuelve el token del edge.</td></tr>
</table>

#### Queries

<table>
<tr><th colspan="4" align="left"><code>GetUserByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cuenta por id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la cuenta.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetUserByIdQuery(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;User&gt;</code> (<code>UserQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetUserByEmailAddressQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cuenta por correo; la usa el inicio de sesión y la invitación de cuidadores.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetUserByEmailAddressQuery(String emailAddress)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;User&gt;</code> (<code>UserQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ExistsUserByEmailAddressQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica si el correo ya tiene cuenta.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ExistsUserByEmailAddressQuery(String emailAddress)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>boolean</code> (<code>UserQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllRolesQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Todos los roles del catálogo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllRolesQuery()</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Role&gt;</code> (<code>RoleQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetRoleByNameQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Rol por nombre.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>name</code></td><td><code>Roles</code></td><td>private final</td><td>Nombre del rol.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetRoleByNameQuery(Roles name)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Role&gt;</code> (<code>RoleQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetDeviceCredentialByEdgeIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Credencial <code>ACTIVE</code> de un edge.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetDeviceCredentialByEdgeIdQuery(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;DeviceCredential&gt;</code> (<code>DeviceCredentialQueryService</code>)</td></tr>
</table>

#### Domain Services

<table>
<tr><th colspan="4" align="left"><code>UserCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>User</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(SignUpCommand command)</code></td><td><code>Optional&lt;User&gt;</code></td><td>public</td><td>Ejecuta <code>SignUpCommand</code>.</td></tr>
<tr><td><code>handle(VerifyEmailCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>VerifyEmailCommand</code>.</td></tr>
<tr><td><code>handle(ResendVerificationCodeCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>ResendVerificationCodeCommand</code>.</td></tr>
<tr><td><code>handle(SignInCommand command)</code></td><td><code>Optional&lt;ImmutablePair&lt;User, String&gt;&gt;</code></td><td>public</td><td>Ejecuta <code>SignInCommand</code>.</td></tr>
<tr><td><code>handle(RegisterInvitedCaregiverCommand command)</code></td><td><code>Optional&lt;ImmutablePair&lt;User, String&gt;&gt;</code></td><td>public</td><td>Ejecuta <code>RegisterInvitedCaregiverCommand</code>.</td></tr>
<tr><td><code>handle(CreateCorporateAccountCommand command)</code></td><td><code>Optional&lt;User&gt;</code></td><td>public</td><td>Ejecuta <code>CreateCorporateAccountCommand</code>.</td></tr>
<tr><td><code>handle(DefinePasswordCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>DefinePasswordCommand</code>.</td></tr>
<tr><td><code>handle(ChangeTemporaryPasswordCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>ChangeTemporaryPasswordCommand</code>.</td></tr>
<tr><td><code>handle(RenewTemporaryPasswordCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>RenewTemporaryPasswordCommand</code>.</td></tr>
<tr><td><code>handle(ChangePasswordCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>ChangePasswordCommand</code>.</td></tr>
<tr><td><code>handle(RequestPasswordResetCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>RequestPasswordResetCommand</code>.</td></tr>
<tr><td><code>handle(ChangeUserRoleCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>ChangeUserRoleCommand</code>.</td></tr>
<tr><td><code>handle(BlockUserCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>BlockUserCommand</code>.</td></tr>
<tr><td><code>handle(UnblockUserCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>UnblockUserCommand</code>.</td></tr>
<tr><td><code>handle(DeactivateUserCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>DeactivateUserCommand</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UserQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>User</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetUserByIdQuery query)</code></td><td><code>Optional&lt;User&gt;</code></td><td>public</td><td>Resuelve <code>GetUserByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetUserByEmailAddressQuery query)</code></td><td><code>Optional&lt;User&gt;</code></td><td>public</td><td>Resuelve <code>GetUserByEmailAddressQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(ExistsUserByEmailAddressQuery query)</code></td><td><code>boolean</code></td><td>public</td><td>Resuelve <code>ExistsUserByEmailAddressQuery</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RoleCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Role</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(SeedRolesCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>SeedRolesCommand</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RoleQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Role</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetAllRolesQuery query)</code></td><td><code>List&lt;Role&gt;</code></td><td>public</td><td>Resuelve <code>GetAllRolesQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetRoleByNameQuery query)</code></td><td><code>Optional&lt;Role&gt;</code></td><td>public</td><td>Resuelve <code>GetRoleByNameQuery</code>; devuelve vacío si no existe.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceCredentialCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>DeviceCredential</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(IssueDeviceCredentialCommand command)</code></td><td><code>Optional&lt;ImmutablePair&lt;DeviceCredential, String&gt;&gt;</code></td><td>public</td><td>Ejecuta <code>IssueDeviceCredentialCommand</code>.</td></tr>
<tr><td><code>handle(RevokeDeviceCredentialCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>RevokeDeviceCredentialCommand</code>.</td></tr>
<tr><td><code>handle(AuthenticateDeviceCommand command)</code></td><td><code>Optional&lt;String&gt;</code></td><td>public</td><td>Ejecuta <code>AuthenticateDeviceCommand</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceCredentialQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>DeviceCredential</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetDeviceCredentialByEdgeIdQuery query)</code></td><td><code>Optional&lt;DeviceCredential&gt;</code></td><td>public</td><td>Resuelve <code>GetDeviceCredentialByEdgeIdQuery</code>; devuelve vacío si no existe.</td></tr>
</table>

#### Exceptions

<table>
<tr><th colspan="4" align="left"><code>UserNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe la cuenta indicada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UserNotFound(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailAddressAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el correo ya tiene una cuenta (o, en una invitación, es de un familiar o de una cuenta corporativa).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmailAddressAlreadyExists(String emailAddress)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidCredentials</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el correo, la contraseña, el código de la cuenta o el secreto del edge no coinciden.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidCredentials()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AccountNotActive</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la operación pide una cuenta <code>ACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AccountNotActive(AccountStatus status)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AccountNotPending</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la operación pide una cuenta <code>PENDING</code> (renovar la contraseña temporal de un empleado que ya la cambió).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AccountNotPending(AccountStatus status)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PasswordChangeRequired</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el empleado inicia sesión con su contraseña temporal.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PasswordChangeRequired()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailNotVerified</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se inicia sesión sin verificar el correo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmailNotVerified()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailAlreadyVerified</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se verifica o se pide un código para un correo ya verificado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmailAlreadyVerified()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidVerificationCode</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el código de verificación no coincide.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidVerificationCode()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VerificationCodeExpired</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el código de verificación venció.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>VerificationCodeExpired()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PasswordNotTemporary</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se cambia o se renueva como temporal una contraseña que no lo es.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PasswordNotTemporary()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidPasswordToken</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el enlace no existe, ya se usó o no es del propósito esperado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidPasswordToken()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PasswordTokenExpired</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el enlace venció.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PasswordTokenExpired()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RoleNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el rol no existe en el catálogo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RoleNotFound(Roles name)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RoleNotAllowedForAccountType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el rol no corresponde al tipo de cuenta.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RoleNotAllowedForAccountType(Roles role, AccountType type)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidAccountStatusTransition</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el cambio de estado de la cuenta no está permitido.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidAccountStatusTransition(AccountStatus from, AccountStatus to)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceCredentialNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el edge no tiene credencial.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceCredentialNotFound(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceCredentialAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el edge ya tiene una credencial <code>ACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceCredentialAlreadyExists(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceCredentialRevoked</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la credencial del edge está revocada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceCredentialRevoked(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

#### Reglas generales del bounded context

**Contextos que usan IAM.**

**Company** (ACL): `SignUpCommand` con `ROLE_ADMIN`; guarda el `userId` en `Administrator`.

**Assistance** (ACL): `SignUpCommand` con `ROLE_RELATIVE` (el familiar paga la suscripción); `RegisterInvitedCaregiverCommand` al invitar a un cuidador. Escucha `PasswordDefinedEvent` para aceptar sus invitaciones.

**HCM** (ACL y eventos): `CreateCorporateAccountCommand` con el rol del empleado. `EmployeeSuspendedEvent`: Block; `EmployeeReinstatedEvent`: Unblock; `EmployeeTerminatedEvent`: Deactivate; `EmployeeRoleChangedEvent`: ChangeUserRole. La cuenta personal de familiar, si la tiene, no cambia.

**Assets** (ACL y eventos): al registrar un edge pide `IssueDeviceCredentialCommand`; el secreto vuelve al administrador, que lo copia en la configuración del edge. `RenewEdgeCredentialCommand`: Revoke e Issue. `AssetRemovedFromNetworkEvent` de un edge y `DeviceNetworkDeactivatedEvent` (por cada edge): `RevokeDeviceCredentialCommand`.

**Tracking**: el edge envía sus reportes con el token de `AuthenticateDeviceCommand`; Tracking toma el `edgeId` del token.

**Communication** (eventos): envía el código de verificación, la contraseña temporal (también cuando se renueva) y el enlace de recuperación.

**Autorización**: cada request lleva el token; el rol decide qué endpoints puede usar. Qué familiar o cuidador ve qué persona asistida lo valida Assistance.

### 5.1.2. Interface Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.1.1.

### 5.1.3. Application Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.1.1.

### 5.1.4. Infrastructure Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.1.1.

### 5.1.6. Bounded Context Software Architecture Component Level Diagrams

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.1.1.

### 5.1.7. Bounded Context Software Architecture Code Level Diagrams

#### 5.1.7.1. Bounded Context Domain Layer Class Diagrams

El diagrama muestra los aggregates `User` y `DeviceCredential` y la entidad de catálogo `Role`, con la asociación dirigida `roles` (0..* a 1..*). `User` se compone de sus value objects `HashedPassword`, `PasswordToken` y `VerificationCode` (0..1 cada uno) y registra los cinco eventos que consumen Assistance y Communication. `DeviceCredential` se compone de su secreto (`HashedPassword`) y guarda el `EdgeId` de Assets. Los services reciben sus commands y queries, y las notas detallan las reglas de cada service y los contextos que usan IAM: Company, Assistance, HCM, Assets, Tracking y Communication.

![Diagrama de clases de la capa de dominio - IAM](../images/diagrams/img/chapter-5/iam-backend-diagram.svg)

#### 5.1.7.2. Bounded Context Database Design Diagram

La base de datos es PostgreSQL.

| Tabla o colección | Aggregate, entidad o value object | Llaves y restricciones |
|---|---|---|
| `users` | `User` (con `PasswordToken` y `VerificationCode` embebidos) | PK `id`. UK `email_address`, `password_token_hash`. |
| `roles` | `Role` | PK `id`. UK `name`. |
| `user_roles` | Relación `roles` de `User` | PK `user_id`, `role_id`. FK `user_id`, `role_id`. |
| `device_credentials` | `DeviceCredential` | PK `id`. Referencia a Assets sin FK: `edge_id`. UK parcial (`edge_id`) WHERE status = '`ACTIVE`'. |

Relaciones entre tablas: `users` a `user_roles` (roles (1..*)); `roles` a `user_roles` ((0..*)).

**users** (aggregate `User`) `email_address`: correo normalizado en minúsculas; es el usuario para iniciar sesión. password: hash (BCrypt). Nulo mientras una cuenta invitada no define su contraseña. `temporary_password`: verdadero mientras el empleado no cambia la contraseña temporal. `account_type`: `PERSONAL` o `CORPORATE`. status: `PENDING`, `ACTIVE`, `BLOCKED` o `DEACTIVATED`. No se borra: una cuenta desactivada queda como historial. password_token_*: value object `PasswordToken` embebido (`@Embedded`). Solo el hash del token (SHA-256); nulos cuando no hay enlace vigente. UK para buscar la cuenta por el token. `email_verified` y verification_code_*: value object `VerificationCode` embebido; el código se guarda como hash y se borra al verificar el correo.



**roles** (entidad `Role`). Catálogo: una fila por cada valor de `Roles`, creada al iniciar la aplicación (`SeedRolesCommand`).



**`user_roles`**. Relación `@ManyToMany` de `User` con `Role`, igual que en la referencia. PK compuesta (`user_id`, `role_id`).



**`device_credentials`** (aggregate `DeviceCredential`) `edge_id`: `Edge` de Assets. Sin FK: otro contexto. secret: hash del secreto del edge. status: `ACTIVE` o `REVOKED`. Un edge tiene una sola credencial `ACTIVE`; las revocadas quedan como historial.




![Diagrama de base de datos - IAM](../images/diagrams/img/chapter-5/iam-database-diagram.svg)

<div style="page-break-after: always;"></div>

## 5.2. Bounded Context: Gestión del Negocio

En el código, este bounded context es el paquete `company`. Company representa el negocio que opera la plataforma (hoy, Alivia) y a la persona que lo gestiona. Su id es el `BusinessId` que usan los demás contextos; guardarlo permite abrir más negocios en el futuro. Los datos públicos y legales del negocio viven en `BusinessProfile` (Profiles) y los datos personales del administrador en su `StaffProfile` (Profiles): Company solo guarda la identidad de cada uno y quién gestiona el negocio. Por ahora el administrador se registra desde Swagger (`CreateAdministratorCommand`), sin aprobación; activa su cuenta con el código que le llega al correo y después crea el negocio.

### 5.2.1. Domain Layer

Este bounded context no declara Entities, Value Objects, Enumerations ni Domain Events propios.

#### Aggregates

<table>
<tr><th colspan="4" align="left"><code>Business</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El negocio que opera la plataforma (hoy, Alivia; <code>BusinessId</code> permite abrir más negocios). Sus datos públicos y legales viven en <code>BusinessProfile</code> (Profiles); aquí solo se guarda su identidad y quién lo gestiona.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessProfileId</code></td><td><code>BusinessProfileId</code></td><td>private</td><td>Identidad de sus datos en Profiles.</td></tr>
<tr><td><code>administrator</code></td><td><code>Administrator</code></td><td>private</td><td>Administrador que gestiona el negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Business(BusinessProfileId businessProfileId, Administrator administrator)</code></td><td>(constructor)</td><td>public</td><td>Crea el negocio con su perfil y su administrador.</td></tr>
<tr><td><code>isManagedBy(Administrator administrator)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el administrador recibido es quien gestiona el negocio. Se usa antes de modificar sus datos.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Su id es el <code>BusinessId</code> que guardan los demás contextos (por ejemplo, <code>Relative</code> en Assistance). Un administrador gestiona a lo sumo un negocio (<code>BusinessAlreadyExistsForAdministrator</code>).</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>gestionado por</code>)</td><td><code>Administrator</code></td><td>0..1 a 1</td><td></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Administrator</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">La persona que gestiona el <code>Business</code> en la plataforma. Es personal de Alivia: enlaza su cuenta corporativa de IAM (<code>UserId</code>) y su <code>StaffProfile</code> (<code>StaffProfileId</code>); aquí solo guarda su correo personal de respaldo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>UserId</code></td><td>private</td><td>Su cuenta corporativa en IAM (<code>ROLE_ADMIN</code>).</td></tr>
<tr><td><code>staffProfileId</code></td><td><code>StaffProfileId</code></td><td>private</td><td>Su perfil de personal en Profiles.</td></tr>
<tr><td><code>backupPersonalEmail</code></td><td><code>EmailAddress</code></td><td>private</td><td>Correo personal de respaldo. Opcional y único entre administradores.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Administrator(UserId userId, StaffProfileId staffProfileId, EmailAddress backupPersonalEmail)</code></td><td>(constructor)</td><td>public</td><td>Crea el administrador con su cuenta y su perfil.</td></tr>
<tr><td><code>updateBackupPersonalEmail(EmailAddress backupPersonalEmail)</code></td><td><code>void</code></td><td>public</td><td>Cambia el correo de respaldo. Es el único dato que el aggregate modifica; los datos personales se actualizan en su <code>StaffProfile</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Los demás datos personales van a su <code>StaffProfile</code> (Profiles) y la contraseña a IAM. <code>GetAdministratorByUserIdQuery</code> resuelve el administrador desde el usuario que inició sesión.</td></tr>
</table>

#### Commands

<table>
<tr><th colspan="4" align="left"><code>CreateBusinessCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El administrador crea su negocio con sus datos públicos y legales.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo del logo o foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo.</td></tr>
<tr><td><code>businessName</code></td><td><code>String</code></td><td>private final</td><td>Nombre comercial.</td></tr>
<tr><td><code>legalName</code></td><td><code>String</code></td><td>private final</td><td>Razón social.</td></tr>
<tr><td><code>ruc</code></td><td><code>Long</code></td><td>private final</td><td>RUC.</td></tr>
<tr><td><code>mainActivity</code></td><td><code>String</code></td><td>private final</td><td>Actividad principal.</td></tr>
<tr><td><code>description</code></td><td><code>String</code></td><td>private final</td><td>Descripción.</td></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo del negocio.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>formattedAddress</code></td><td><code>String</code></td><td>private final</td><td>Dirección.</td></tr>
<tr><td><code>latitude</code></td><td><code>Double</code></td><td>private final</td><td>Latitud.</td></tr>
<tr><td><code>longitude</code></td><td><code>Double</code></td><td>private final</td><td>Longitud.</td></tr>
<tr><td><code>placeId</code></td><td><code>String</code></td><td>private final</td><td>Id del lugar en Google Maps.</td></tr>
<tr><td><code>businessHours</code></td><td><code>String</code></td><td>private final</td><td>Horario de atención en texto o JSON de periodos; Profiles lo convierte en <code>BusinessHours</code>.</td></tr>
<tr><td><code>supportEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo de soporte.</td></tr>
<tr><td><code>emergencyPhone</code></td><td><code>String</code></td><td>private final</td><td>Teléfono de emergencia.</td></tr>
<tr><td><code>whatsappNum</code></td><td><code>String</code></td><td>private final</td><td>WhatsApp.</td></tr>
<tr><td><code>slogan</code></td><td><code>String</code></td><td>private final</td><td>Eslogan.</td></tr>
<tr><td><code>administratorId</code></td><td><code>Long</code></td><td>private final</td><td>Administrador que crea el negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateBusinessCommand(byte[] photoData, String photoFileName, String businessName, String legalName, Long ruc, String mainActivity, String description, String emailAddress, String phoneNumber, String formattedAddress, Double latitude, Double longitude, String placeId, String businessHours, String supportEmail, String emergencyPhone, String whatsappNum, String slogan, Long administratorId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>BusinessCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El <code>Administrator</code> existe (<code>AdministratorNotFound</code>). El <code>Administrator</code> no gestiona otro <code>Business</code> (<code>BusinessAlreadyExistsForAdministrator</code>). Los datos del negocio los crea Profiles (ACL) y devuelven el <code>BusinessProfileId</code> que guarda <code>Business</code>. Profiles rechaza <code>emailAddress</code>, ruc, <code>businessName</code> o <code>legalName</code> ya registrados; el ACL lo traduce a <code>EmailAddressAlreadyExists</code>, <code>RucAlreadyExists</code>, <code>BusinessNameAlreadyExists</code> o <code>LegalNameAlreadyExists</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateBusinessCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El administrador actualiza los datos de su negocio. No incluye <code>ruc</code>, <code>emailAddress</code> ni la ubicación, que no se modifican.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>administratorId</code></td><td><code>Long</code></td><td>private final</td><td>Administrador que solicita el cambio (sale de la sesión).</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo del logo o foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo.</td></tr>
<tr><td><code>businessName</code></td><td><code>String</code></td><td>private final</td><td>Nombre comercial.</td></tr>
<tr><td><code>legalName</code></td><td><code>String</code></td><td>private final</td><td>Razón social.</td></tr>
<tr><td><code>mainActivity</code></td><td><code>String</code></td><td>private final</td><td>Actividad principal.</td></tr>
<tr><td><code>description</code></td><td><code>String</code></td><td>private final</td><td>Descripción.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>businessHours</code></td><td><code>String</code></td><td>private final</td><td>Horario de atención en texto o JSON de periodos; Profiles lo convierte en <code>BusinessHours</code>.</td></tr>
<tr><td><code>supportEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo de soporte.</td></tr>
<tr><td><code>emergencyPhone</code></td><td><code>String</code></td><td>private final</td><td>Teléfono de emergencia.</td></tr>
<tr><td><code>whatsappNum</code></td><td><code>String</code></td><td>private final</td><td>WhatsApp.</td></tr>
<tr><td><code>slogan</code></td><td><code>String</code></td><td>private final</td><td>Eslogan.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateBusinessCommand(Long businessId, Long administratorId, byte[] photoData, String photoFileName, String businessName, String legalName, String mainActivity, String description, String phoneNumber, String businessHours, String supportEmail, String emergencyPhone, String whatsappNum, String slogan)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>BusinessCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El <code>Business</code> existe (<code>BusinessNotFound</code>). No incluye ruc, <code>emailAddress</code> ni la ubicación corporativa: ruc nunca se modifica. <code>businessName</code> y <code>legalName</code> siguen siendo únicos (<code>BusinessNameAlreadyExists</code>, <code>LegalNameAlreadyExists</code>). Solo el <code>Administrator</code> del <code>Business</code> puede modificarlo, incluido <code>legalName</code>: business.isManagedBy(administrator). <code>Business</code> no cambia: los datos se actualizan en <code>BusinessProfile</code> (Profiles) mediante el ACL.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateAdministratorCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Registra al administrador: su cuenta corporativa en IAM, su <code>StaffProfile</code> en Profiles y su <code>Administrator</code>. Por ahora se envía desde Swagger.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>corporateEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo corporativo: es la cuenta de IAM y el correo del <code>StaffProfile</code>.</td></tr>
<tr><td><code>password</code></td><td><code>String</code></td><td>private final</td><td>Contraseña de su cuenta. Se oculta en <code>toString()</code>.</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo de la foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo de la foto.</td></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><td><code>dni</code></td><td><code>String</code></td><td>private final</td><td>Documento de identidad (8 dígitos). No se modifica después.</td></tr>
<tr><td><code>birthDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de nacimiento.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>backupPersonalEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo personal de respaldo. Opcional.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateAdministratorCommand(String corporateEmail, String password, byte[] photoData, String photoFileName, String firstName, String lastName, String dni, LocalDate birthDate, String phoneNumber, String backupPersonalEmail)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AdministratorCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El administrador es personal de Alivia: su perfil es un <code>StaffProfile</code> nuevo. El dni no está entre el personal (<code>ExistsStaffProfileByDniQuery</code>; <code>DniAlreadyExists</code>) y el correo corporativo no está registrado (<code>ExistsStaffProfileByEmailAddressQuery</code>; <code>EmailAddressAlreadyExists</code>). Profiles crea el <code>StaffProfile</code>. Un administrador no puede ser también empleado: ambos usan el mismo registro de personal (<code>StaffProfile</code>). IAM crea su cuenta corporativa con <code>corporateEmail</code> + password (<code>SignUpCommand</code> con <code>ROLE_ADMIN</code>): el administrador registra su propia cuenta y la activa con el código que le llega al correo. IAM también rechaza un correo que ya es una cuenta, aunque no tenga perfil (por ejemplo, la de un cuidador): <code>EmailAddressAlreadyExists</code>. Después todo se enlaza por id, nunca por dni ni email. <code>backupPersonalEmail</code> no está registrado en otro <code>Administrator</code> (<code>BackupPersonalEmailAlreadyExists</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateAdministratorCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El administrador actualiza sus datos personales, menos el dni y el correo corporativo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>administratorId</code></td><td><code>Long</code></td><td>private final</td><td>Administrador que se actualiza (sale de la sesión).</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo de la foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo de la foto.</td></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><td><code>birthDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de nacimiento.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>backupPersonalEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo personal de respaldo. Opcional.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateAdministratorCommand(Long administratorId, byte[] photoData, String photoFileName, String firstName, String lastName, LocalDate birthDate, String phoneNumber, String backupPersonalEmail)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AdministratorCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El <code>Administrator</code> existe (<code>AdministratorNotFound</code>). El correo corporativo y el dni no se modifican. <code>Administrator</code> solo cambia <code>backupPersonalEmail</code>; los demás datos se actualizan en su <code>StaffProfile</code> (Profiles) mediante el ACL.</td></tr>
</table>

#### Queries

<table>
<tr><th colspan="4" align="left"><code>GetBusinessByAdministratorIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Obtiene el negocio que gestiona un administrador.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>administratorId</code></td><td><code>Long</code></td><td>private final</td><td>Id del administrador.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetBusinessByAdministratorIdQuery(Long administratorId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Business&gt;</code> (<code>BusinessQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetBusinessByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Obtiene un negocio por su id. Analytics toma de ahí el día en que se creó el negocio (<code>createdAt</code>): sus métricas empiezan ese día.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetBusinessByIdQuery(Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Business&gt;</code> (<code>BusinessQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAdministratorByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Obtiene un administrador por su id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>administratorId</code></td><td><code>Long</code></td><td>private final</td><td>Id del administrador.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAdministratorByIdQuery(Long administratorId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Administrator&gt;</code> (<code>AdministratorQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAdministratorByUserIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Obtiene el administrador del usuario que inició sesión.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta del usuario que consulta o ejecuta (sale de la sesión).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAdministratorByUserIdQuery(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Administrator&gt;</code> (<code>AdministratorQueryService</code>)</td></tr>
</table>

#### Domain Services

<table>
<tr><th colspan="4" align="left"><code>BusinessCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Business</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateBusinessCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Crea el negocio y devuelve su id.</td></tr>
<tr><td><code>handle(UpdateBusinessCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Actualiza el negocio y devuelve su id.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Business</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetBusinessByAdministratorIdQuery query)</code></td><td><code>Optional&lt;Business&gt;</code></td><td>public</td><td>Negocio por administrador.</td></tr>
<tr><td><code>handle(GetBusinessByIdQuery query)</code></td><td><code>Optional&lt;Business&gt;</code></td><td>public</td><td>Negocio por id.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AdministratorCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Administrator</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateAdministratorCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Registra al administrador y devuelve su id.</td></tr>
<tr><td><code>handle(UpdateAdministratorCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Actualiza sus datos y devuelve su id.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AdministratorQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Administrator</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetAdministratorByIdQuery query)</code></td><td><code>Optional&lt;Administrator&gt;</code></td><td>public</td><td>Administrador por id.</td></tr>
<tr><td><code>handle(GetAdministratorByUserIdQuery query)</code></td><td><code>Optional&lt;Administrator&gt;</code></td><td>public</td><td>Administrador por usuario.</td></tr>
</table>

#### Exceptions

<table>
<tr><th colspan="4" align="left"><code>BusinessNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe un negocio con el id indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AdministratorNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe un administrador con el id indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AdministratorNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessAlreadyExistsForAdministrator</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el administrador ya gestiona un negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessAlreadyExistsForAdministrator()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DniAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el dni ya está registrado entre el personal (traduce el rechazo de Profiles).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DniAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailAddressAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el correo corporativo ya es un <code>StaffProfile</code> o una cuenta de IAM (traduce el rechazo de Profiles o de IAM).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmailAddressAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessNameAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el nombre comercial ya pertenece a otro negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessNameAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>LegalNameAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la razón social ya pertenece a otro negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>LegalNameAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RucAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el RUC ya pertenece a otro negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RucAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BackupPersonalEmailAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el correo de respaldo ya pertenece a otro administrador.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BackupPersonalEmailAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

### 5.2.2. Interface Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.2.1.

### 5.2.3. Application Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.2.1.

### 5.2.4. Infrastructure Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.2.1.

### 5.2.6. Bounded Context Software Architecture Component Level Diagrams

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.2.1.

### 5.2.7. Bounded Context Software Architecture Code Level Diagrams

#### 5.2.7.1. Bounded Context Domain Layer Class Diagrams

El diagrama muestra los aggregates `Business` y `Administrator`, relacionados por la asociación dirigida "gestionado por" (0..1 a 1). Los colores distinguen el flujo de escritura (el command service recibe el command y crea o actualiza el aggregate) y el de lectura (el query service recibe la query y devuelve el aggregate). Los atributos de cada command se muestran en una nota enlazada a su clase, junto con sus validaciones.

![Diagrama de clases de la capa de dominio - Gestión del Negocio](../images/diagrams/img/chapter-5/Business.svg)

#### 5.2.7.2. Bounded Context Database Design Diagram

La base de datos es PostgreSQL.

| Tabla o colección | Aggregate, entidad o value object | Llaves y restricciones |
|---|---|---|
| `administrators` | `Administrator` | PK `id`. UK `user_id`, `staff_profile_id`, `backup_personal_email`. Referencia a IAM sin FK: `user_id`. Referencia a Profiles sin FK: `staff_profile_id`. |
| `businesses` | `Business` | PK `id`. UK `business_profile_id`, `administrator_id`. FK `administrator_id`. Referencia a Profiles sin FK: `business_profile_id`. |

Relaciones entre tablas: `administrators` a `businesses` (gestiona (1 : 0..1)).

**administrators** (aggregate `Administrator`). La persona que gestiona un `Business` en Alivia.

`user_id`: su cuenta corporativa de IAM (`UserId`). Sin FK. `staff_profile_id`: su `StaffProfile` (`StaffProfileId`). Sin FK. Ambos únicos: cada administrador tiene un usuario y un perfil propios, creados al registrarlo. `backup_personal_email`: opcional y único (`BackupPersonalEmailAlreadyExists`).

**businesses** (aggregate `Business`). El negocio que opera la plataforma (hoy, Alivia). Su id es el `BusinessId` que guardan otros contextos (relatives.business_id en Assistance).

`business_profile_id`: sus datos públicos y legales en Profiles (`BusinessProfileId`). Sin FK. `administrator_id`: FK dentro del contexto. Único: un administrador gestiona un solo `Business` (`BusinessAlreadyExistsForAdministrator`). El administrador se registra primero y luego crea el negocio: por eso un administrador puede existir aún sin `Business` (0..1).


![Diagrama de base de datos - Gestión del Negocio](../images/diagrams/img/chapter-5/Business-database.svg)

<div style="page-break-after: always;"></div>

## 5.3. Bounded Context: Perfiles

En el código, este bounded context es el paquete `profiles`. Profiles guarda los datos personales y de contacto de las personas y los datos públicos y legales del negocio. Distingue dos tipos de perfil de persona según su relación con Alivia: `PersonProfile` para los clientes (familiares y personas asistidas) y `StaffProfile` para el personal (administrador y empleados). Si una misma persona es cliente y personal, tiene los dos perfiles con sus datos por separado, porque son dos relaciones distintas con Alivia. Los demás contextos referencian los perfiles solo por su id; ningún perfil se busca ni se recupera por dni ni por email. Todos los datos personales se pueden corregir (nombres, fecha de nacimiento, teléfono y foto), menos el dni y el email.

### 5.3.1. Domain Layer

Este bounded context no declara Entities, Enumerations ni Domain Events propios.

#### Aggregates

<table>
<tr><th colspan="4" align="left"><code>Profile</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Clase abstracta base de aggregates (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Base común de los tres perfiles: email, foto y teléfono. No tiene repositorio ni services propios.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>EmailAddress</code></td><td>private</td><td>Correo del perfil. Obligatorio en <code>StaffProfile</code> y <code>BusinessProfile</code>; opcional en <code>PersonProfile</code> (persona asistida). No se modifica.</td></tr>
<tr><td><code>photo</code></td><td><code>Photo</code></td><td>private</td><td>Foto de perfil.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>PhoneNumber</code></td><td>private</td><td>Teléfono de contacto. Puede repetirse entre perfiles.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Profile(EmailAddress emailAddress, Photo photo, PhoneNumber phoneNumber)</code></td><td>(constructor)</td><td>protected</td><td>Inicializa los datos de contacto desde las subclases.</td></tr>
<tr><td><code>updateContactInformation(PhoneNumber phoneNumber, Photo photo)</code></td><td><code>void</code></td><td>protected</td><td>Actualiza teléfono y foto; la usan las subclases.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El id de <code>PersonProfile</code> es el que otros contextos guardan como <code>PersonProfileId</code>; el de <code>StaffProfile</code>, como <code>StaffProfileId</code>; y el de <code>BusinessProfile</code>, como <code>BusinessProfileId</code>. El email es único entre <code>PersonProfile</code> y <code>StaffProfile</code>, porque cada email es una cuenta de IAM.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PersonProfile</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>Profile</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Los datos personales de un cliente de Alivia: familiar o persona asistida. Assistance lo referencia por <code>PersonProfileId</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>personName</code></td><td><code>PersonName</code></td><td>private</td><td>Nombres y apellidos.</td></tr>
<tr><td><code>dni</code></td><td><code>Dni</code></td><td>private</td><td>Documento de identidad. Único entre los clientes; no se modifica.</td></tr>
<tr><td><code>birthDate</code></td><td><code>BirthDate</code></td><td>private</td><td>Fecha de nacimiento. Se puede corregir.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PersonProfile(EmailAddress emailAddress, Photo photo, PhoneNumber phoneNumber, PersonName personName, Dni dni, BirthDate birthDate)</code></td><td>(constructor)</td><td>public</td><td>Crea el perfil de un cliente.</td></tr>
<tr><td><code>updatePersonalInformation(PersonName personName, BirthDate birthDate, PhoneNumber phoneNumber, Photo photo)</code></td><td><code>void</code></td><td>public</td><td>Corrige nombres, fecha de nacimiento, teléfono y foto. El dni y el email no cambian. Lo pide Assistance: el familiar, para sí mismo y para su persona asistida.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>personName</code>)</td><td><code>PersonName</code></td><td>1 a 1</td><td>Nombres y apellidos.</td></tr>
<tr><td>Composición (<code>dni</code>)</td><td><code>Dni</code></td><td>1 a 1</td><td>Documento de identidad.</td></tr>
<tr><td>Composición (<code>birthDate</code>)</td><td><code>BirthDate</code></td><td>1 a 1</td><td>Fecha de nacimiento.</td></tr>
<tr><td>Herencia</td><td><code>Profile</code></td><td>No aplica</td><td>Extiende la base abstracta <code>Profile</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>StaffProfile</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>Profile</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Los datos personales del personal de Alivia: administrador o empleado, con su correo corporativo. Company y HCM lo referencian por <code>StaffProfileId</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>personName</code></td><td><code>PersonName</code></td><td>private</td><td>Nombres y apellidos.</td></tr>
<tr><td><code>dni</code></td><td><code>Dni</code></td><td>private</td><td>Documento de identidad. Único entre el personal: nadie es empleado dos veces y un administrador no puede ser empleado. No se modifica.</td></tr>
<tr><td><code>birthDate</code></td><td><code>BirthDate</code></td><td>private</td><td>Fecha de nacimiento. Se puede corregir.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>StaffProfile(EmailAddress corporateEmail, Photo photo, PhoneNumber phoneNumber, PersonName personName, Dni dni, BirthDate birthDate)</code></td><td>(constructor)</td><td>public</td><td>Crea el perfil de un miembro del personal.</td></tr>
<tr><td><code>updatePersonalInformation(PersonName personName, BirthDate birthDate, PhoneNumber phoneNumber, Photo photo)</code></td><td><code>void</code></td><td>public</td><td>Corrige nombres, fecha de nacimiento, teléfono y foto. El dni y el correo corporativo no cambian. Lo piden HCM (el administrador, por su personal) y Company (el administrador, por sí mismo).</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>personName</code>)</td><td><code>PersonName</code></td><td>1 a 1</td><td>Nombres y apellidos.</td></tr>
<tr><td>Composición (<code>dni</code>)</td><td><code>Dni</code></td><td>1 a 1</td><td>Documento de identidad.</td></tr>
<tr><td>Composición (<code>birthDate</code>)</td><td><code>BirthDate</code></td><td>1 a 1</td><td>Fecha de nacimiento.</td></tr>
<tr><td>Herencia</td><td><code>Profile</code></td><td>No aplica</td><td>Extiende la base abstracta <code>Profile</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessProfile</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>Profile</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Los datos públicos y legales del negocio (ruc, razón social, nombre comercial, horario, ubicación y contacto). Company lo referencia por <code>BusinessProfileId</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ruc</code></td><td><code>Ruc</code></td><td>private</td><td>RUC del negocio. Único y no se modifica.</td></tr>
<tr><td><code>businessName</code></td><td><code>BusinessName</code></td><td>private</td><td>Nombre comercial. Único.</td></tr>
<tr><td><code>legalName</code></td><td><code>LegalName</code></td><td>private</td><td>Razón social. Única; solo la modifica el administrador del negocio.</td></tr>
<tr><td><code>description</code></td><td><code>String</code></td><td>private</td><td>Descripción del negocio.</td></tr>
<tr><td><code>mainActivity</code></td><td><code>String</code></td><td>private</td><td>Actividad principal.</td></tr>
<tr><td><code>whatsappNum</code></td><td><code>PhoneNumber</code></td><td>private</td><td>Número de WhatsApp.</td></tr>
<tr><td><code>emergencyPhone</code></td><td><code>PhoneNumber</code></td><td>private</td><td>Teléfono de emergencia.</td></tr>
<tr><td><code>businessHours</code></td><td><code>BusinessHours</code></td><td>private</td><td>Horario de atención.</td></tr>
<tr><td><code>slogan</code></td><td><code>String</code></td><td>private</td><td>Eslogan.</td></tr>
<tr><td><code>supportEmail</code></td><td><code>EmailAddress</code></td><td>private</td><td>Correo de soporte.</td></tr>
<tr><td><code>address</code></td><td><code>Address</code></td><td>private</td><td>Ubicación del negocio. No se modifica.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessProfile(EmailAddress emailAddress, Photo photo, PhoneNumber phoneNumber, Ruc ruc, BusinessName businessName, LegalName legalName, String description, String mainActivity, PhoneNumber whatsappNum, PhoneNumber emergencyPhone, BusinessHours businessHours, String slogan, EmailAddress supportEmail, Address address)</code></td><td>(constructor)</td><td>public</td><td>Crea el perfil del negocio.</td></tr>
<tr><td><code>updateInformation(Photo photo, PhoneNumber phoneNumber, BusinessName businessName, LegalName legalName, String description, String mainActivity, PhoneNumber whatsappNum, PhoneNumber emergencyPhone, BusinessHours businessHours, String slogan, EmailAddress supportEmail)</code></td><td><code>void</code></td><td>public</td><td>Actualiza los datos modificables del negocio. El RUC, el email y la dirección no cambian.</td></tr>
<tr><td><code>isOpenAt(DayOfWeek day, LocalTime time)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el negocio atiende ese día a esa hora.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>businessName</code>)</td><td><code>BusinessName</code></td><td>1 a 1</td><td>Nombre comercial.</td></tr>
<tr><td>Composición (<code>legalName</code>)</td><td><code>LegalName</code></td><td>1 a 1</td><td>Razón social.</td></tr>
<tr><td>Composición (<code>ruc</code>)</td><td><code>Ruc</code></td><td>1 a 1</td><td>RUC del negocio.</td></tr>
<tr><td>Composición (<code>businessHours</code>)</td><td><code>BusinessHours</code></td><td>1 a 1</td><td>Horario de atención.</td></tr>
<tr><td>Herencia</td><td><code>Profile</code></td><td>No aplica</td><td>Extiende la base abstracta <code>Profile</code>.</td></tr>
</table>

#### Value Objects

<table>
<tr><th colspan="4" align="left"><code>Ruc</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Registro Único de Contribuyentes: 11 dígitos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ruc</code></td><td><code>Long</code></td><td>private final</td><td>RUC del negocio. Único y no se modifica.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Ruc(Long ruc)</code></td><td>(constructor)</td><td>public</td><td>Valida que tenga 11 dígitos.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>LegalName</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Razón social del negocio. Única.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>legalName</code></td><td><code>String</code></td><td>private final</td><td>Razón social. Única; solo la modifica el administrador del negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>LegalName(String legalName)</code></td><td>(constructor)</td><td>public</td><td>Valida que no esté vacía.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessName</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Nombre comercial del negocio. Único.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessName</code></td><td><code>String</code></td><td>private final</td><td>Nombre comercial. Único.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessName(String businessName)</code></td><td>(constructor)</td><td>public</td><td>Valida que no esté vacío.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessHours</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Horario de atención del negocio, dentro del día. Agrupa una lista de <code>WeeklyPeriod</code> (Shared), uno por cada bloque de días con el mismo horario (ej. lunes a viernes 09:00-18:00 y sábado 09:00-13:00 son dos periodos).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>periods</code></td><td><code>List&lt;WeeklyPeriod&gt;</code></td><td>private final</td><td>Periodos del horario. Al menos uno.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessHours(List&lt;WeeklyPeriod&gt; periods)</code></td><td>(constructor)</td><td>public</td><td>Valida que haya al menos un periodo, que ningún rango cruce medianoche y que ningún par de periodos se cruce el mismo día (<code>InvalidBusinessHours</code>).</td></tr>
<tr><td><code>isOpenAt(DayOfWeek day, LocalTime time)</code></td><td><code>boolean</code></td><td>public</td><td>Revisa todos los periodos para saber si el negocio está abierto.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Los commands ya lo reciben como value object: la conversión desde texto o JSON se hace en el borde del contexto (Interfaces o fachada del ACL).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PersonName</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Nombres y apellidos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PersonName(String firstName, String lastName)</code></td><td>(constructor)</td><td>public</td><td>Valida que <code>firstName</code> y <code>lastName</code> no estén vacíos.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Dni</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Documento Nacional de Identidad: 8 dígitos. Es <code>String</code> para admitir ceros a la izquierda. Es un dato de identificación personal: no identifica al aggregate ni enlaza perfiles.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>dni</code></td><td><code>String</code></td><td>private final</td><td>Documento de identidad. Único entre los clientes; no se modifica.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Dni(String dni)</code></td><td>(constructor)</td><td>public</td><td>Valida que tenga 8 dígitos.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Único dentro de cada tipo de perfil.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BirthDate</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Fecha de nacimiento de una persona.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>birthDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de nacimiento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BirthDate(LocalDate birthDate)</code></td><td>(constructor)</td><td>public</td><td>Valida que no sea posterior a hoy.</td></tr>
</table>

#### Commands

<table>
<tr><th colspan="4" align="left"><code>CreatePersonProfileCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea el perfil de un cliente: familiar o persona asistida. Lo envía Assistance.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo. Opcional: la persona asistida puede no tener correo; el familiar lo exige en Assistance.</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo de la foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo de la foto.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><td><code>dni</code></td><td><code>String</code></td><td>private final</td><td>DNI.</td></tr>
<tr><td><code>birthDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de nacimiento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreatePersonProfileCommand(String emailAddress, byte[] photoData, String photoFileName, String phoneNumber, String firstName, String lastName, String dni, LocalDate birthDate)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>PersonProfileCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Perfil de cliente: familiar o persona asistida. <code>emailAddress</code> es opcional (la persona asistida puede no tener correo). Si viene, no pertenece a otro <code>PersonProfile</code> ni a un <code>StaffProfile</code> (<code>EmailAddressAlreadyExists</code>). dni no pertenece a otro <code>PersonProfile</code> (<code>DniAlreadyExists</code>). Puede existir un <code>StaffProfile</code> con el mismo dni: la misma persona puede ser cliente y personal de Alivia. Los contextos lo validan antes con <code>ExistsPersonProfileByDniQuery</code>, que solo responde si existe: ningún perfil se recupera por dni.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateBusinessProfileCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea los datos públicos y legales del negocio. Lo envía Company.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo del negocio.</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo del logo o foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>ruc</code></td><td><code>Long</code></td><td>private final</td><td>RUC.</td></tr>
<tr><td><code>businessName</code></td><td><code>String</code></td><td>private final</td><td>Nombre comercial.</td></tr>
<tr><td><code>legalName</code></td><td><code>String</code></td><td>private final</td><td>Razón social.</td></tr>
<tr><td><code>description</code></td><td><code>String</code></td><td>private final</td><td>Descripción.</td></tr>
<tr><td><code>mainActivity</code></td><td><code>String</code></td><td>private final</td><td>Actividad principal.</td></tr>
<tr><td><code>whatsappNum</code></td><td><code>String</code></td><td>private final</td><td>WhatsApp.</td></tr>
<tr><td><code>emergencyPhone</code></td><td><code>String</code></td><td>private final</td><td>Teléfono de emergencia.</td></tr>
<tr><td><code>businessHours</code></td><td><code>BusinessHours</code></td><td>private final</td><td>Horario de atención.</td></tr>
<tr><td><code>slogan</code></td><td><code>String</code></td><td>private final</td><td>Eslogan.</td></tr>
<tr><td><code>supportEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo de soporte.</td></tr>
<tr><td><code>formattedAddress</code></td><td><code>String</code></td><td>private final</td><td>Dirección.</td></tr>
<tr><td><code>latitude</code></td><td><code>Double</code></td><td>private final</td><td>Latitud.</td></tr>
<tr><td><code>longitude</code></td><td><code>Double</code></td><td>private final</td><td>Longitud.</td></tr>
<tr><td><code>placeId</code></td><td><code>String</code></td><td>private final</td><td>Id del lugar en Google Maps.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateBusinessProfileCommand(String emailAddress, byte[] photoData, String photoFileName, String phoneNumber, Long ruc, String businessName, String legalName, String description, String mainActivity, String whatsappNum, String emergencyPhone, BusinessHours businessHours, String slogan, String supportEmail, String formattedAddress, Double latitude, Double longitude, String placeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>BusinessProfileCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3"><b>Valida</b> <code>emailAddress</code> no pertenece a otro <code>BusinessProfile</code> (<code>EmailAddressAlreadyExists</code>). ruc, <code>businessName</code> y <code>legalName</code> no pertenecen a otro <code>BusinessProfile</code> (<code>RucAlreadyExists</code>, <code>BusinessNameAlreadyExists</code>, <code>LegalNameAlreadyExists</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateBusinessProfileCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Actualiza los datos del negocio. Lo envía Company.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>id</code></td><td><code>Long</code></td><td>private final</td><td>Id del <code>BusinessProfile</code>.</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo del logo o foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>businessName</code></td><td><code>String</code></td><td>private final</td><td>Nombre comercial.</td></tr>
<tr><td><code>legalName</code></td><td><code>String</code></td><td>private final</td><td>Razón social.</td></tr>
<tr><td><code>description</code></td><td><code>String</code></td><td>private final</td><td>Descripción.</td></tr>
<tr><td><code>mainActivity</code></td><td><code>String</code></td><td>private final</td><td>Actividad principal.</td></tr>
<tr><td><code>whatsappNum</code></td><td><code>String</code></td><td>private final</td><td>WhatsApp.</td></tr>
<tr><td><code>emergencyPhone</code></td><td><code>String</code></td><td>private final</td><td>Teléfono de emergencia.</td></tr>
<tr><td><code>businessHours</code></td><td><code>BusinessHours</code></td><td>private final</td><td>Horario de atención.</td></tr>
<tr><td><code>slogan</code></td><td><code>String</code></td><td>private final</td><td>Eslogan.</td></tr>
<tr><td><code>supportEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo de soporte.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateBusinessProfileCommand(Long id, byte[] photoData, String photoFileName, String phoneNumber, String businessName, String legalName, String description, String mainActivity, String whatsappNum, String emergencyPhone, BusinessHours businessHours, String slogan, String supportEmail)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>BusinessProfileCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El perfil existe (<code>BusinessProfileNotFound</code>). ruc (nunca), address y <code>emailAddress</code> no se modifican. Solo llega desde Company, donde se valida que quien actualiza (incluido <code>legalName</code>) es el <code>Administrator</code> del <code>Business</code>. Profiles no valida roles. Si <code>businessName</code> o <code>legalName</code> cambian, no pertenecen a otro <code>BusinessProfile</code> (<code>BusinessNameAlreadyExists</code>, <code>LegalNameAlreadyExists</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdatePersonProfileCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Corrige los datos personales de un cliente. Lo envía Assistance.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>id</code></td><td><code>Long</code></td><td>private final</td><td>Id del <code>PersonProfile</code>.</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo de la foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo de la foto.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><td><code>birthDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de nacimiento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdatePersonProfileCommand(Long id, byte[] photoData, String photoFileName, String phoneNumber, String firstName, String lastName, LocalDate birthDate)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>PersonProfileCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El perfil existe (<code>PersonProfileNotFound</code>). dni y <code>emailAddress</code> no se modifican nunca. Lo envía Assistance: el familiar actualiza sus datos y los de su persona asistida.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateStaffProfileCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea el perfil de un miembro del personal: administrador (Company) o empleado (HCM).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>corporateEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo corporativo. Obligatorio.</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo de la foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo de la foto.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><td><code>dni</code></td><td><code>String</code></td><td>private final</td><td>DNI.</td></tr>
<tr><td><code>birthDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de nacimiento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateStaffProfileCommand(String corporateEmail, byte[] photoData, String photoFileName, String phoneNumber, String firstName, String lastName, String dni, LocalDate birthDate)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>StaffProfileCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Perfil del personal de Alivia: administrador o empleado. <code>corporateEmail</code> es obligatorio (correo corporativo) y no pertenece a otro <code>StaffProfile</code> ni a un <code>PersonProfile</code> (<code>EmailAddressAlreadyExists</code>). dni no pertenece a otro <code>StaffProfile</code> (<code>DniAlreadyExists</code>): nadie se registra dos veces como personal. Puede existir un <code>PersonProfile</code> con el mismo dni (la persona también es cliente); sus datos se guardan por separado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateStaffProfileCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Corrige los datos personales de un miembro del personal. Lo envían HCM y Company.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>id</code></td><td><code>Long</code></td><td>private final</td><td>Id del <code>StaffProfile</code>.</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo de la foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo de la foto.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><td><code>birthDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de nacimiento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateStaffProfileCommand(Long id, byte[] photoData, String photoFileName, String phoneNumber, String firstName, String lastName, LocalDate birthDate)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>StaffProfileCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El perfil existe (<code>StaffProfileNotFound</code>). dni y <code>corporateEmail</code> no se modifican nunca. Lo envían HCM (el administrador actualiza a su personal) y Company (el administrador, sus datos). No cambia el <code>PersonProfile</code> de la misma persona, si lo tiene: son relaciones distintas.</td></tr>
</table>

#### Queries

<table>
<tr><th colspan="4" align="left"><code>GetPersonProfileByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Obtiene un perfil de cliente por su id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>id</code></td><td><code>Long</code></td><td>private final</td><td>Id del <code>PersonProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetPersonProfileByIdQuery(Long id)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;PersonProfile&gt;</code> (<code>PersonProfileQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ExistsPersonProfileByEmailAddressQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica si el email ya está registrado en un perfil de cliente.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>EmailAddress</code></td><td>private final</td><td>Correo a buscar.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ExistsPersonProfileByEmailAddressQuery(EmailAddress emailAddress)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>boolean</code> (<code>PersonProfileQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ExistsPersonProfileByDniQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica si el DNI ya está registrado entre los clientes. No devuelve el perfil.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>dni</code></td><td><code>Dni</code></td><td>private final</td><td>Documento de identidad a buscar.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ExistsPersonProfileByDniQuery(Dni dni)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>boolean</code> (<code>PersonProfileQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetStaffProfileByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Obtiene un perfil de personal por su id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>id</code></td><td><code>Long</code></td><td>private final</td><td>Id del <code>StaffProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetStaffProfileByIdQuery(Long id)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;StaffProfile&gt;</code> (<code>StaffProfileQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ExistsStaffProfileByEmailAddressQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica si el correo corporativo ya está registrado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>EmailAddress</code></td><td>private final</td><td>Correo corporativo a buscar.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ExistsStaffProfileByEmailAddressQuery(EmailAddress emailAddress)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>boolean</code> (<code>StaffProfileQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ExistsStaffProfileByDniQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica si el DNI ya está registrado entre el personal.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>dni</code></td><td><code>Dni</code></td><td>private final</td><td>Documento de identidad a buscar.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ExistsStaffProfileByDniQuery(Dni dni)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>boolean</code> (<code>StaffProfileQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ExistsBusinessProfileByEmailAddressQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica si el email ya está registrado en un negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>EmailAddress</code></td><td>private final</td><td>Correo a buscar.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ExistsBusinessProfileByEmailAddressQuery(EmailAddress emailAddress)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>boolean</code> (<code>BusinessProfileQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetBusinessProfileByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Obtiene el perfil de un negocio por su id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>id</code></td><td><code>Long</code></td><td>private final</td><td>Id del <code>BusinessProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetBusinessProfileByIdQuery(Long id)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;BusinessProfile&gt;</code> (<code>BusinessProfileQueryService</code>)</td></tr>
</table>

#### Domain Services

<table>
<tr><th colspan="4" align="left"><code>PersonProfileCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>PersonProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreatePersonProfileCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Crea el perfil y devuelve su id.</td></tr>
<tr><td><code>handle(UpdatePersonProfileCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Actualiza el perfil y devuelve su id.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PersonProfileQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>PersonProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetPersonProfileByIdQuery query)</code></td><td><code>Optional&lt;PersonProfile&gt;</code></td><td>public</td><td>Perfil por id.</td></tr>
<tr><td><code>handle(ExistsPersonProfileByEmailAddressQuery query)</code></td><td><code>boolean</code></td><td>public</td><td><code>Email</code> registrado o no.</td></tr>
<tr><td><code>handle(ExistsPersonProfileByDniQuery query)</code></td><td><code>boolean</code></td><td>public</td><td>DNI registrado o no.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>StaffProfileCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>StaffProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateStaffProfileCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Crea el perfil y devuelve su id.</td></tr>
<tr><td><code>handle(UpdateStaffProfileCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Actualiza el perfil y devuelve su id.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>StaffProfileQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>StaffProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetStaffProfileByIdQuery query)</code></td><td><code>Optional&lt;StaffProfile&gt;</code></td><td>public</td><td>Perfil por id.</td></tr>
<tr><td><code>handle(ExistsStaffProfileByEmailAddressQuery query)</code></td><td><code>boolean</code></td><td>public</td><td>Correo corporativo registrado o no.</td></tr>
<tr><td><code>handle(ExistsStaffProfileByDniQuery query)</code></td><td><code>boolean</code></td><td>public</td><td>DNI registrado o no.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessProfileQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>BusinessProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetBusinessProfileByIdQuery query)</code></td><td><code>Optional&lt;BusinessProfile&gt;</code></td><td>public</td><td>Perfil por id.</td></tr>
<tr><td><code>handle(ExistsBusinessProfileByEmailAddressQuery query)</code></td><td><code>boolean</code></td><td>public</td><td><code>Email</code> registrado o no.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessProfileCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>BusinessProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateBusinessProfileCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Crea el perfil y devuelve su id.</td></tr>
<tr><td><code>handle(UpdateBusinessProfileCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Actualiza el perfil y devuelve su id.</td></tr>
</table>

#### Exceptions

<table>
<tr><th colspan="4" align="left"><code>BusinessNameAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el nombre comercial ya pertenece a otro negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessNameAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RucAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el RUC ya pertenece a otro negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RucAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DniAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el DNI ya está registrado en otro perfil del mismo tipo (cliente o personal).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DniAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailAddressAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el email ya está registrado: entre <code>PersonProfile</code> y <code>StaffProfile</code>, o entre negocios.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmailAddressAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PersonProfileNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe un <code>PersonProfile</code> con el id indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PersonProfileNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>StaffProfileNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe un <code>StaffProfile</code> con el id indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>StaffProfileNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessProfileNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe un <code>BusinessProfile</code> con el id indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessProfileNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidBusinessHours</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el horario está vacío, tiene un rango que cruza medianoche o periodos que se cruzan el mismo día.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidBusinessHours()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>LegalNameAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la razón social ya pertenece a otro negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>LegalNameAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

#### Reglas generales del bounded context

**`Email`**: obligatorio en `BusinessProfile` y en `StaffProfile` (correo corporativo); opcional en `PersonProfile` (persona asistida; el familiar lo exige en su contexto). Único entre `PersonProfile` y `StaffProfile`: cada email es una cuenta de IAM. No se modifica.

**Teléfono**: puede repetirse entre perfiles.

### 5.3.2. Interface Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.3.1.

### 5.3.3. Application Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.3.1.

### 5.3.4. Infrastructure Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.3.1.

### 5.3.6. Bounded Context Software Architecture Component Level Diagrams

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.3.1.

### 5.3.7. Bounded Context Software Architecture Code Level Diagrams

#### 5.3.7.1. Bounded Context Domain Layer Class Diagrams

El diagrama muestra la base abstracta `Profile` y sus tres aggregates (`PersonProfile`, `StaffProfile` y `BusinessProfile`), relacionados por generalización. Cada aggregate se compone de sus value objects propios con multiplicidad 1 a 1. Los services reciben sus commands y queries mediante dependencias nombradas ("recibe"). Los atributos de cada command se muestran en una nota enlazada a su clase, con sus validaciones; otras notas detallan las invariantes de los value objects y el horario `BusinessHours`.

![Diagrama de clases de la capa de dominio - Perfiles](../images/diagrams/img/chapter-5/profile-backend-diagram.svg)

#### 5.3.7.2. Bounded Context Database Design Diagram

La base de datos es PostgreSQL. `Profile` es una base abstracta sin tabla propia: sus columnas (email, foto y teléfono) se repiten en las tres tablas de perfiles.

| Tabla o colección | Aggregate, entidad o value object | Llaves y restricciones |
|---|---|---|
| `person_profiles` | `PersonProfile` | PK `id`. UK `email_address`, `dni`. |
| `staff_profiles` | `StaffProfile` | PK `id`. UK `corporate_email`, `dni`. |
| `business_profiles` | `BusinessProfile` (con `Address` embebido) | PK `id`. UK `email_address`, `ruc`, `business_name`, `legal_name`. |
| `business_profile_opening_periods` | `BusinessHours` (colección de `WeeklyPeriod`) | FK `business_profile_id`. |

Relaciones entre tablas: `business_profiles` a `business_profile_opening_periods` (business_hours (1..*)).

**`staff_profiles`** (aggregate `StaffProfile`). Personal de Alivia: administrador y empleados. Company y HCM guardan su id como `staff_profile_id`.

`corporate_email`: correo corporativo, obligatorio y único; es la cuenta corporativa en IAM. dni: índice único entre el personal (nadie es empleado dos veces; un administrador no es empleado). No se modifican: `corporate_email` ni dni. Sus datos no se comparten con `person_profiles` aunque sea la misma persona: son relaciones distintas. El email tampoco puede repetirse entre `corporate_email` y `person_profiles.email_address`: lo valida el dominio (cada email es una cuenta de IAM).

**`person_profiles`** (aggregate `PersonProfile`). Clientes de Alivia: familiares y personas asistidas. Assistance guarda su id como `person_profile_id`. `Profile` es una base abstracta sin tabla propia: sus columnas (email, foto, teléfono) se repiten aquí, en `staff_profiles` y en `business_profiles`.

`email_address`: único pero opcional (la persona asistida puede no tener correo). En PostgreSQL un índice único admite varios NULL. No se modifican: `email_address` ni dni. dni: índice único entre los clientes; respalda `DniAlreadyExists` y `ExistsPersonProfileByDniQuery`. El mismo dni puede estar en `staff_profiles` (la persona también es personal de Alivia). `phone_number`: solo dígitos, código de país incluido (máx. 15, E.164 sin "+"); puede repetirse.

**`business_profiles`** (aggregate `BusinessProfile`). Datos públicos y legales del negocio. Company guarda su id como `business_profile_id`.

Únicos: `email_address`, ruc, `business_name`, `legal_name`. No se modifican: ruc, `email_address` y la dirección. address_*: value object `Address` (Google Maps). ruc: BIGINT porque el value object `Ruc` recibe `Long` (11 dígitos, nunca empieza en 0).

**`business_profile_opening_periods`**. Value object `BusinessHours` (`@ElementCollection`): una fila por cada `WeeklyPeriod` del horario. No tiene id propio: es parte del valor de `BusinessProfile`. `week_days`: días separados por coma (MONDAY,TUESDAY,...) con un AttributeConverter. `start_time` anterior a `end_time`: el negocio no atiende cruzando medianoche. Al cambiar el horario, las filas se reemplazan.




![Diagrama de base de datos - Perfiles](../images/diagrams/img/chapter-5/profile-database-diagram.svg)

<div style="page-break-after: always;"></div>

## 5.4. Bounded Context: Capital Humano

En el código, este bounded context es el paquete `hcm`. HCM (Human Capital Management) gestiona al personal de cada negocio (hoy, Alivia): datos laborales, rol, estado, horario de trabajo, contratos y vacaciones. Todo gira en torno al `BusinessId`: cada operación valida que el empleado pertenezca al negocio. El administrador contrata a cada empleado: HCM le pide a Profiles su `StaffProfile` y a IAM su cuenta corporativa con una contraseña temporal. Los datos personales del empleado viven en su `StaffProfile` y su cuenta en IAM; el administrador puede corregir sus datos personales, menos el dni y el correo corporativo. Una persona que es familiar puede trabajar en Alivia y conserva aparte su perfil y su cuenta de cliente.

### 5.4.1. Domain Layer

#### Aggregates

<table>
<tr><th colspan="4" align="left"><code>Employee</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Una persona que trabaja para un <code>Business</code> (hoy, Alivia). Guarda su rol, su estado laboral, su horario, sus contratos y sus vacaciones. Sus datos personales viven en su <code>StaffProfile</code> (Profiles) y su cuenta corporativa en IAM.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>BusinessId</code></td><td>private</td><td>Negocio al que pertenece.</td></tr>
<tr><td><code>userId</code></td><td><code>UserId</code></td><td>private</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><td><code>staffProfileId</code></td><td><code>StaffProfileId</code></td><td>private</td><td>Su perfil de personal en Profiles.</td></tr>
<tr><td><code>role</code></td><td><code>EmployeeRole</code></td><td>private</td><td>Rol en el negocio: <code>TECH</code>, <code>SUBSCRIPTION_MANAGER</code> o <code>CLEANING</code>.</td></tr>
<tr><td><code>status</code></td><td><code>EmployeeStatus</code></td><td>private</td><td><code>ACTIVE</code>, <code>SUSPENDED</code> o <code>TERMINATED</code>.</td></tr>
<tr><td><code>workSchedule</code></td><td><code>WorkSchedule</code></td><td>private</td><td>Turnos semanales.</td></tr>
<tr><td><code>contractHistory</code></td><td><code>ContractHistory</code></td><td>private</td><td>Todos sus contratos.</td></tr>
<tr><td><code>vacationHistory</code></td><td><code>VacationHistory</code></td><td>private</td><td>Todas sus vacaciones.</td></tr>
<tr><td><code>terminationReason</code></td><td><code>TerminationReason</code></td><td>private</td><td>Motivo del cese (<code>DISMISSED</code> o <code>RESIGNED</code>). Solo en un empleado <code>TERMINATED</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Employee(BusinessId businessId, UserId userId, StaffProfileId staffProfileId, EmployeeRole role, WorkSchedule workSchedule, OperatingHours operatingHours, ContractPeriod firstContractPeriod, TypeOfContract firstContractType, LocalDate today)</code></td><td>(constructor)</td><td>public</td><td>Crea al empleado <code>ACTIVE</code> con su primer <code>Contract</code>; el horario cumple <code>OperatingHours</code>. Registra <code>EmployeeHiredEvent</code>.</td></tr>
<tr><td><code>belongsTo(BusinessId businessId)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si es del negocio indicado.</td></tr>
<tr><td><code>changeRole(EmployeeRole role)</code></td><td><code>void</code></td><td>public</td><td>Registra <code>EmployeeRoleChangedEvent</code> si el rol cambia.</td></tr>
<tr><td><code>updateWorkSchedule(WorkSchedule workSchedule, OperatingHours operatingHours)</code></td><td><code>void</code></td><td>public</td><td>Cada turno cabe en <code>OperatingHours</code> (<code>WorkScheduleOutsideOperatingHours</code>).</td></tr>
<tr><td><code>addContract(ContractPeriod period, TypeOfContract type, LocalDate today)</code></td><td><code>void</code></td><td>public</td><td>No empieza antes de today (<code>InvalidContractPeriod</code>) y no se cruza con otro contrato <code>ACTIVE</code> (<code>ContractOverlap</code>).</td></tr>
<tr><td><code>terminateContract(Long contractId)</code></td><td><code>void</code></td><td>public</td><td>El contrato existe (<code>ContractNotFound</code>) y está <code>ACTIVE</code> (<code>ContractNotActive</code>).</td></tr>
<tr><td><code>scheduleVacation(VacationPeriod period, LocalDate today)</code></td><td><code>void</code></td><td>public</td><td>No empieza antes de today (<code>InvalidVacationPeriod</code>), cae dentro de un contrato <code>ACTIVE</code> (<code>VacationOutsideContract</code>) y no se cruza con otra vacación <code>SCHEDULED</code> (<code>VacationOverlap</code>).</td></tr>
<tr><td><code>cancelVacation(Long vacationId, LocalDate today)</code></td><td><code>void</code></td><td>public</td><td>La vacación existe (<code>VacationNotFound</code>), está <code>SCHEDULED</code> y aún no empezó (<code>VacationNotCancelable</code>).</td></tr>
<tr><td><code>suspend()</code></td><td><code>void</code></td><td>public</td><td>De <code>ACTIVE</code> a <code>SUSPENDED</code>. Registra <code>EmployeeSuspendedEvent</code>.</td></tr>
<tr><td><code>reinstate()</code></td><td><code>void</code></td><td>public</td><td>De <code>SUSPENDED</code> a <code>ACTIVE</code>. Registra <code>EmployeeReinstatedEvent</code>.</td></tr>
<tr><td><code>terminate(TerminationReason reason, LocalDate today)</code></td><td><code>void</code></td><td>public</td><td>De <code>ACTIVE</code> o <code>SUSPENDED</code> a <code>TERMINATED</code> (estado final). Guarda el motivo, termina el contrato vigente, cancela las vacaciones futuras y registra <code>EmployeeTerminatedEvent</code>.</td></tr>
<tr><td><code>currentContract(LocalDate today)</code></td><td><code>Optional&lt;Contract&gt;</code></td><td>public</td><td>Contrato vigente a la fecha, si lo hay.</td></tr>
<tr><td><code>isOnVacation(LocalDate today)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la fecha cae en una vacación <code>SCHEDULED</code>. Sirve para cualquier fecha, también la de una visita futura de Support. "De vacaciones" se calcula; no es un estado guardado.</td></tr>
<tr><td><code>isTerminated()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si fue cesado.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Ningún método modifica a un empleado <code>TERMINATED</code> (<code>EmployeeTerminated</code>). Las transiciones de estado no permitidas lanzan <code>InvalidEmployeeStatusTransition</code>. Sin contrato vigente (vencido por fecha o terminado con <code>terminateContract</code>), el empleado sigue <code>ACTIVE</code> hasta que el administrador lo renueve (<code>addContract</code>) o lo cese (<code>terminate</code>); no hay proceso automático. En ese caso <code>currentContract</code> devuelve vacío y no se pueden programar vacaciones (<code>VacationOutsideContract</code>).</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>workSchedule</code>)</td><td><code>WorkSchedule</code></td><td>1 a 1</td><td>Turnos semanales.</td></tr>
<tr><td>Composición (<code>contractHistory</code>)</td><td><code>ContractHistory</code></td><td>1 a 1</td><td>Todos sus contratos.</td></tr>
<tr><td>Composición (<code>vacationHistory</code>)</td><td><code>VacationHistory</code></td><td>1 a 1</td><td>Todas sus vacaciones.</td></tr>
<tr><td>Dependencia "valida con"</td><td><code>OperatingHours</code></td><td>No aplica</td><td></td></tr>
<tr><td>Asociación dirigida (<code>role</code>)</td><td><code>EmployeeRole</code></td><td>0..* a 1</td><td>Rol en el negocio: <code>TECH</code>, <code>SUBSCRIPTION_MANAGER</code> o <code>CLEANING</code>.</td></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>EmployeeStatus</code></td><td>0..* a 1</td><td><code>ACTIVE</code>, <code>SUSPENDED</code> o <code>TERMINATED</code>.</td></tr>
<tr><td>Asociación dirigida (<code>terminationReason</code>)</td><td><code>TerminationReason</code></td><td>0..* a 0..1</td><td>Motivo del cese (<code>DISMISSED</code> o <code>RESIGNED</code>).</td></tr>
</table>

#### Entities

<table>
<tr><th colspan="4" align="left"><code>Contract</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Entity (extiende <code>AuditableModel</code>), dentro de <code>Employee</code></td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Un contrato laboral, con periodo (siempre con fecha de fin) y tipo (tiempo completo o parcial).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employee</code></td><td><code>Employee</code></td><td>private</td><td>Referencia a su aggregate root.</td></tr>
<tr><td><code>period</code></td><td><code>ContractPeriod</code></td><td>private</td><td>Fechas de inicio y fin.</td></tr>
<tr><td><code>type</code></td><td><code>TypeOfContract</code></td><td>private</td><td>Tiempo completo o parcial.</td></tr>
<tr><td><code>status</code></td><td><code>ContractStatus</code></td><td>private</td><td><code>ACTIVE</code> o <code>TERMINATED</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Contract(Employee employee, ContractPeriod period, TypeOfContract type)</code></td><td>(constructor)</td><td>public</td><td>Crea el contrato en <code>ACTIVE</code>.</td></tr>
<tr><td><code>terminate()</code></td><td><code>void</code></td><td>public</td><td>De <code>ACTIVE</code> a <code>TERMINATED</code>: termina antes de su fecha de fin.</td></tr>
<tr><td><code>isActive()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si está <code>ACTIVE</code>.</td></tr>
<tr><td><code>isExpired(LocalDate today)</code></td><td><code>boolean</code></td><td>public</td><td><code>ACTIVE</code> con fecha de fin anterior a <code>today</code>. Se calcula; no se guarda.</td></tr>
<tr><td><code>isCurrentOn(LocalDate date)</code></td><td><code>boolean</code></td><td>public</td><td><code>ACTIVE</code> y la fecha está dentro de su periodo.</td></tr>
<tr><td><code>overlapsWith(ContractPeriod period)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si su periodo se cruza con otro.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Vive dentro de <code>Employee</code>: solo se modifica por su root. Terminar o dejar vencer un contrato no cambia el estado del empleado.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>period</code>)</td><td><code>ContractPeriod</code></td><td>1 a 1</td><td>Fechas de inicio y fin.</td></tr>
<tr><td>Asociación dirigida (<code>type</code>)</td><td><code>TypeOfContract</code></td><td>0..* a 1</td><td>Tiempo completo o parcial.</td></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>ContractStatus</code></td><td>0..* a 1</td><td><code>ACTIVE</code> o <code>TERMINATED</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Vacation</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Entity (extiende <code>AuditableModel</code>), dentro de <code>Employee</code></td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Un periodo de vacaciones programado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employee</code></td><td><code>Employee</code></td><td>private</td><td>Referencia a su aggregate root.</td></tr>
<tr><td><code>period</code></td><td><code>VacationPeriod</code></td><td>private</td><td>Fechas de inicio y fin.</td></tr>
<tr><td><code>status</code></td><td><code>VacationStatus</code></td><td>private</td><td><code>SCHEDULED</code> o <code>CANCELLED</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Vacation(Employee employee, VacationPeriod period)</code></td><td>(constructor)</td><td>public</td><td>Crea la vacación en <code>SCHEDULED</code>.</td></tr>
<tr><td><code>cancel(LocalDate today)</code></td><td><code>void</code></td><td>public</td><td>De <code>SCHEDULED</code> a <code>CANCELLED</code>, solo si aún no empezó (<code>VacationNotCancelable</code>).</td></tr>
<tr><td><code>isOn(LocalDate date)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la fecha está dentro de la vacación.</td></tr>
<tr><td><code>overlapsWith(VacationPeriod period)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si se cruza con otro periodo.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Vive dentro de <code>Employee</code>: solo se modifica por su root. Una vacación que ya terminó sigue <code>SCHEDULED</code>: es el historial de lo que tomó.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>period</code>)</td><td><code>VacationPeriod</code></td><td>1 a 1</td><td>Fechas de inicio y fin.</td></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>VacationStatus</code></td><td>0..* a 1</td><td><code>SCHEDULED</code> o <code>CANCELLED</code>.</td></tr>
</table>

#### Value Objects

**Value objects de Shared que usa este contexto.** `Employee` extiende `AuditableAbstractAggregateRoot` (id, `createdAt`, `updatedAt`, `addDomainEvent()`). `Contract` y `Vacation` extienden `AuditableModel` (id, `createdAt`, `updatedAt`). Value objects: `BusinessId`, `UserId`, `StaffProfileId`, `WeeklyPeriod` (days, range; `occursOn`, `overlapsWith`), `TimeRange` (`crossesMidnight`). El dominio no consulta el reloj: recibe today como parámetro.

<table>
<tr><th colspan="4" align="left"><code>ContractHistory</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Componente embebido (<code>@Embeddable</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Componente embebido en <code>Employee</code> que agrupa todos sus contratos, vigentes y pasados.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>contracts</code></td><td><code>List&lt;Contract&gt;</code></td><td>private</td><td>Contratos del empleado, vigentes y pasados. Lista mutable; al contratar tiene uno.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ContractHistory()</code></td><td>(constructor)</td><td>public</td><td>Inicia la lista vacía y mutable.</td></tr>
<tr><td><code>addContract(Employee employee, ContractPeriod period, TypeOfContract type)</code></td><td><code>Contract</code></td><td>public</td><td>Crea y agrega un contrato.</td></tr>
<tr><td><code>getContractWithId(Long contractId)</code></td><td><code>Contract</code></td><td>public</td><td>Devuelve el contrato o lanza <code>ContractNotFound</code>.</td></tr>
<tr><td><code>currentContract(LocalDate today)</code></td><td><code>Optional&lt;Contract&gt;</code></td><td>public</td><td>Contrato vigente a la fecha.</td></tr>
<tr><td><code>hasActiveContractOverlapping(ContractPeriod period)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si un contrato <code>ACTIVE</code> se cruza con el periodo.</td></tr>
<tr><td><code>hasActiveContractCovering(VacationPeriod period)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si un contrato <code>ACTIVE</code> cubre las vacaciones.</td></tr>
<tr><td><code>terminateActiveContracts()</code></td><td><code>void</code></td><td>public</td><td>Termina los contratos <code>ACTIVE</code> (al cesar al empleado).</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">No es un value object en sentido estricto: es mutable y contiene entidades con identidad. Se ubica en <code>valueobjects</code> porque se embebe en el aggregate.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>contracts</code>)</td><td><code>Contract</code></td><td>1 a 1..*</td><td>Contratos del empleado, vigentes y pasados.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VacationHistory</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Componente embebido (<code>@Embeddable</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Componente embebido en <code>Employee</code> que agrupa sus vacaciones, como <code>ContractHistory</code> con los contratos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>vacations</code></td><td><code>List&lt;Vacation&gt;</code></td><td>private</td><td>Vacaciones del empleado, incluidas las canceladas. Lista mutable; inicia vacía.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>VacationHistory()</code></td><td>(constructor)</td><td>public</td><td>Inicia la lista vacía.</td></tr>
<tr><td><code>addVacation(Employee employee, VacationPeriod period)</code></td><td><code>Vacation</code></td><td>public</td><td>Crea y agrega una vacación.</td></tr>
<tr><td><code>getVacationWithId(Long vacationId)</code></td><td><code>Vacation</code></td><td>public</td><td>Devuelve la vacación o lanza <code>VacationNotFound</code>.</td></tr>
<tr><td><code>hasScheduledVacationOverlapping(VacationPeriod period)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si una vacación <code>SCHEDULED</code> se cruza con el periodo.</td></tr>
<tr><td><code>isOnVacation(LocalDate today)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la fecha cae en una vacación <code>SCHEDULED</code>.</td></tr>
<tr><td><code>cancelFutureVacations(LocalDate today)</code></td><td><code>void</code></td><td>public</td><td>Cancela las vacaciones que aún no empiezan (al cesar al empleado).</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>vacations</code>)</td><td><code>Vacation</code></td><td>1 a 0..*</td><td>Vacaciones del empleado, incluidas las canceladas.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ContractPeriod</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Periodo de un contrato. Ambas fechas obligatorias y <code>endDate</code> no anterior a <code>startDate</code> (<code>InvalidContractPeriod</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>startDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de inicio.</td></tr>
<tr><td><code>endDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de fin.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ContractPeriod(LocalDate startDate, LocalDate endDate)</code></td><td>(constructor)</td><td>public</td><td>Valida las fechas.</td></tr>
<tr><td><code>contains(LocalDate date)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la fecha está dentro del periodo.</td></tr>
<tr><td><code>overlapsWith(ContractPeriod other)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si se cruza con otro periodo del mismo tipo.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Los contratos siempre tienen fecha de fin.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VacationPeriod</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Periodo de vacaciones. Mismas invariantes (<code>InvalidVacationPeriod</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>startDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de inicio.</td></tr>
<tr><td><code>endDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de fin.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>VacationPeriod(LocalDate startDate, LocalDate endDate)</code></td><td>(constructor)</td><td>public</td><td>Valida las fechas.</td></tr>
<tr><td><code>contains(LocalDate date)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la fecha está dentro del periodo.</td></tr>
<tr><td><code>overlapsWith(VacationPeriod other)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si se cruza con otro periodo del mismo tipo.</td></tr>
<tr><td><code>days()</code></td><td><code>int</code></td><td>public</td><td>Cantidad de días del periodo.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>WorkSchedule</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Horario de trabajo semanal del empleado, fuera del contrato: un <code>WeeklyPeriod</code> (Shared) por cada bloque de días con el mismo turno (ej. lunes a viernes 08:00-16:00 y sábado 08:00-12:00).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>shifts</code></td><td><code>List&lt;WeeklyPeriod&gt;</code></td><td>private final</td><td>Turnos semanales. Al menos uno; ninguno cruza medianoche ni se cruza con otro (<code>InvalidWorkSchedule</code>).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>WorkSchedule(List&lt;WeeklyPeriod&gt; shifts)</code></td><td>(constructor)</td><td>public</td><td>Valida los turnos (<code>InvalidWorkSchedule</code>).</td></tr>
<tr><td><code>covers(DayOfWeek day, TimeRange range)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si un turno de ese día contiene todo el rango. Lo usa Support al asignar una visita al técnico.</td></tr>
<tr><td><code>fitsWithin(OperatingHours operatingHours)</code></td><td><code>boolean</code></td><td>public</td><td>Cada turno está dentro del horario de atención de su negocio (<code>OperatingHours</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>OperatingHours</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Horario de atención del <code>Business</code> del empleado (hoy, Alivia), que limita los turnos. Es la traducción que hace el ACL del <code>BusinessHours</code> de su <code>BusinessProfile</code> (Profiles), que no cruza medianoche.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>periods</code></td><td><code>List&lt;WeeklyPeriod&gt;</code></td><td>private final</td><td>Periodos del horario de atención.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>OperatingHours(List&lt;WeeklyPeriod&gt; periods)</code></td><td>(constructor)</td><td>public</td><td>Crea el horario con los periodos que entrega el ACL.</td></tr>
<tr><td><code>covers(WeeklyPeriod shift)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si un turno queda dentro del horario de atención.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Horario de atención del <code>Business</code> del empleado (hoy, Alivia; por ejemplo, hasta las 22:00). Es la traducción que hace el ACL del <code>BusinessHours</code> de su <code>BusinessProfile</code> (Profiles), que ya no cruza medianoche.</td></tr>
</table>

#### Enumerations

<table>
<tr><th colspan="4" align="left"><code>EmployeeStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado laboral del empleado. <code>TERMINATED</code> es final. Estar de vacaciones se calcula con las fechas.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>ACTIVE</code>, <code>SUSPENDED</code>, <code>TERMINATED</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>TerminationReason</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Motivo del cese: <code>DISMISSED</code> (despedido) o <code>RESIGNED</code> (renunció). Solo en un empleado <code>TERMINATED</code>.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>DISMISSED</code>, <code>RESIGNED</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeRole</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Rol del empleado.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>TECH</code>, <code>SUBSCRIPTION_MANAGER</code>, <code>CLEANING</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ContractStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de un contrato. "Vencido" se calcula con la fecha de fin.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>ACTIVE</code>, <code>TERMINATED</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>TypeOfContract</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tiempo completo o parcial.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>FULL_TIME</code>, <code>PART_TIME</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VacationStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de unas vacaciones.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>SCHEDULED</code>, <code>CANCELLED</code></td></tr>
</table>

#### Domain Events

<table>
<tr><th colspan="4" align="left"><code>EmployeeHiredEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que se contrató a un empleado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employee</code></td><td><code>Employee</code></td><td>private</td><td>Empleado que originó el evento; su id se lee al publicarse.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeHiredEvent(Employee employee)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><code>getEmployeeId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>employeeId</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getBusinessId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>businessId</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getUserId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>userId</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getRole()</code></td><td><code>EmployeeRole</code></td><td>public</td><td>Devuelve <code>role</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Employee.constructor</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Analytics cuenta una contratación del negocio ese día. Después del commit. Communication no envía otro correo: la bienvenida es la contraseña temporal (<code>CorporateAccountCreatedEvent</code> de IAM).</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Se registra en el constructor de <code>Employee</code>, cuando aún no hay id: <code>getEmployeeId()</code> lo lee del aggregate al publicarse.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeSuspendedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que se suspendió a un empleado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta corporativa del empleado en IAM.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeSuspendedEvent(Long employeeId, Long businessId, Long userId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Employee.constructor</code>, <code>Employee.suspend</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">IAM bloquea la cuenta corporativa (<code>BlockUserCommand</code>, síncrono). Después del commit, Communication avisa al empleado por correo y Analytics cuenta la suspensión.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeReinstatedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que un empleado suspendido volvió a estar activo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta corporativa del empleado en IAM.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeReinstatedEvent(Long employeeId, Long businessId, Long userId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Employee.reinstate</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">IAM vuelve a habilitar la cuenta (<code>UnblockUserCommand</code>, síncrono). Después del commit, Communication avisa al empleado por correo.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeTerminatedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que se cesó a un empleado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta corporativa del empleado en IAM.</td></tr>
<tr><td><code>reason</code></td><td><code>TerminationReason</code></td><td>private final</td><td>Motivo del cese: <code>DISMISSED</code> o <code>RESIGNED</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeTerminatedEvent(Long employeeId, Long businessId, Long userId, TerminationReason reason)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Employee.terminate</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">IAM desactiva la cuenta corporativa (<code>DeactivateUserCommand</code>, síncrono); la cuenta personal de familiar, si la tiene, no cambia. Después del commit, Communication avisa al empleado por correo y Analytics cuenta el cese según su motivo.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeRoleChangedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que cambió el rol de un empleado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta corporativa del empleado en IAM.</td></tr>
<tr><td><code>role</code></td><td><code>EmployeeRole</code></td><td>private final</td><td>Rol nuevo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeRoleChangedEvent(Long employeeId, Long businessId, Long userId, EmployeeRole role)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Employee.changeRole</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">IAM cambia el rol de la cuenta corporativa (<code>ChangeUserRoleCommand</code>, síncrono).</td></tr>
</table>

#### Commands

<table>
<tr><th colspan="4" align="left"><code>CreateEmployeeCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El administrador contrata a un empleado: su <code>StaffProfile</code>, su cuenta corporativa y su primer contrato.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Negocio que contrata (sale del administrador que inició sesión).</td></tr>
<tr><td><code>corporateEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo corporativo: cuenta de IAM y correo del <code>StaffProfile</code>. Obligatorio.</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo de la foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><td><code>dni</code></td><td><code>String</code></td><td>private final</td><td>DNI.</td></tr>
<tr><td><code>birthDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de nacimiento.</td></tr>
<tr><td><code>role</code></td><td><code>EmployeeRole</code></td><td>private final</td><td>Rol.</td></tr>
<tr><td><code>workSchedule</code></td><td><code>WorkSchedule</code></td><td>private final</td><td>Horario de trabajo.</td></tr>
<tr><td><code>contractStartDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Inicio del primer contrato.</td></tr>
<tr><td><code>contractEndDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fin del primer contrato.</td></tr>
<tr><td><code>contractType</code></td><td><code>TypeOfContract</code></td><td>private final</td><td>Tipo del primer contrato.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateEmployeeCommand(Long businessId, String corporateEmail, byte[] photoData, String photoFileName, String phoneNumber, String firstName, String lastName, String dni, LocalDate birthDate, EmployeeRole role, WorkSchedule workSchedule, LocalDate contractStartDate, LocalDate contractEndDate, TypeOfContract contractType)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EmployeeCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El negocio existe en Company (<code>BusinessNotFound</code>). El empleado es personal de Alivia: su perfil es un <code>StaffProfile</code> nuevo. El dni no está entre el personal (<code>ExistsStaffProfileByDniQuery</code>; <code>DniAlreadyExists</code>) y el correo corporativo no está registrado (<code>ExistsStaffProfileByEmailAddressQuery</code>; <code>EmailAddressAlreadyExists</code>). Profiles crea el <code>StaffProfile</code>. Nadie se registra dos veces como empleado, y un administrador no puede ser empleado: lo garantiza el dni único entre el personal. Si la persona también es familiar, conserva aparte su <code>PersonProfile</code> y su cuenta personal. Si es una persona asistida no se valida: lo decide el administrador. IAM crea su cuenta corporativa con su rol y una contraseña temporal (<code>CreateCorporateAccountCommand</code>); Communication se la envía al correo corporativo (<code>CorporateAccountCreatedEvent</code>). No tiene acceso hasta que la cambia. IAM también rechaza un correo que ya es una cuenta, aunque no tenga perfil (por ejemplo, la de un cuidador): <code>EmailAddressAlreadyExists</code>. Después todo se enlaza por id, nunca por dni ni email. la capa de aplicación entrega today y el <code>OperatingHours</code> del negocio.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateEmployeeCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El administrador corrige los datos personales de un empleado, menos el dni y el correo corporativo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Negocio.</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo de la foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><td><code>birthDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de nacimiento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateEmployeeCommand(Long employeeId, Long businessId, byte[] photoData, String photoFileName, String phoneNumber, String firstName, String lastName, LocalDate birthDate)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EmployeeCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">(datos personales del empleado) El empleado existe (<code>EmployeeNotFound</code>), es del negocio (<code>EmployeeNotInBusiness</code>) y no está <code>TERMINATED</code> (<code>EmployeeTerminated</code>). <code>Employee</code> no cambia: los datos se actualizan en su <code>StaffProfile</code> (Profiles) mediante el ACL. Lo envía el administrador del negocio. El correo corporativo y el dni no se modifican nunca.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ChangeEmployeeRoleCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cambia el rol (<code>Employee.changeRole</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>role</code></td><td><code>EmployeeRole</code></td><td>private final</td><td>Rol nuevo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ChangeEmployeeRoleCommand(Long employeeId, Long businessId, EmployeeRole role)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EmployeeCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateEmployeeWorkScheduleCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cambia el horario dentro del horario del negocio (<code>Employee.updateWorkSchedule</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>workSchedule</code></td><td><code>WorkSchedule</code></td><td>private final</td><td>Turnos semanales.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateEmployeeWorkScheduleCommand(Long employeeId, Long businessId, WorkSchedule workSchedule)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EmployeeCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SuspendEmployeeCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Suspende al empleado (<code>Employee.suspend</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SuspendEmployeeCommand(Long employeeId, Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EmployeeCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ReinstateEmployeeCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Lo reincorpora (<code>Employee.reinstate</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ReinstateEmployeeCommand(Long employeeId, Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EmployeeCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>TerminateEmployeeCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Lo cesa: termina su contrato, cancela vacaciones futuras y desactiva su cuenta corporativa (<code>Employee.terminate</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>reason</code></td><td><code>TerminationReason</code></td><td>private final</td><td>Motivo del cese: <code>DISMISSED</code> o <code>RESIGNED</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>TerminateEmployeeCommand(Long employeeId, Long businessId, TerminationReason reason)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EmployeeCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateContractCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Renueva al empleado con un contrato nuevo (<code>Employee.addContract</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>startDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de inicio.</td></tr>
<tr><td><code>endDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de fin.</td></tr>
<tr><td><code>type</code></td><td><code>TypeOfContract</code></td><td>private final</td><td>Tipo de contrato: <code>FULL_TIME</code> o <code>PART_TIME</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateContractCommand(Long employeeId, Long businessId, LocalDate startDate, LocalDate endDate, TypeOfContract type)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EmployeeCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Retorno: el id del <code>Contract</code> creado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>TerminateContractCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Termina un contrato antes de su fin (<code>Employee.terminateContract</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>contractId</code></td><td><code>Long</code></td><td>private final</td><td>Id del contrato.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>TerminateContractCommand(Long employeeId, Long contractId, Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EmployeeCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Retorno: el id del <code>Contract</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ScheduleVacationCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Programa vacaciones (<code>Employee.scheduleVacation</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>startDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de inicio.</td></tr>
<tr><td><code>endDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de fin.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ScheduleVacationCommand(Long employeeId, Long businessId, LocalDate startDate, LocalDate endDate)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EmployeeCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Retorno: el id de la <code>Vacation</code> creada.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CancelVacationCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cancela vacaciones que aún no empiezan (<code>Employee.cancelVacation</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>vacationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la vacación.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CancelVacationCommand(Long employeeId, Long vacationId, Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EmployeeCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Retorno: el id de la <code>Vacation</code>.</td></tr>
</table>

#### Queries

<table>
<tr><th colspan="4" align="left"><code>GetAllEmployeesByBusinessIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Personal de un negocio. La usan el administrador y Analytics (personal actual por estado).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>status</code></td><td><code>EmployeeStatus</code></td><td>private final</td><td>Filtro opcional por estado (nulo: sin filtro).</td></tr>
<tr><td><code>role</code></td><td><code>EmployeeRole</code></td><td>private final</td><td>Filtro opcional por rol (nulo: sin filtro).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllEmployeesByBusinessIdQuery(Long businessId, EmployeeStatus status, EmployeeRole role)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Employee&gt;</code> (<code>EmployeeQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetEmployeeByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Empleado por id. La usan Support (al asignar una visita: <code>TECH</code>, <code>ACTIVE</code>, turno y vacaciones) y Communication (cuenta del técnico).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetEmployeeByIdQuery(Long employeeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Employee&gt;</code> (<code>EmployeeQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetEmployeeByUserIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Empleado del usuario que inició sesión (<code>UserId</code> de IAM). La usan Support (el técnico que atiende una visita) e IAM (al renovar una contraseña temporal).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta corporativa del empleado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetEmployeeByUserIdQuery(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Employee&gt;</code> (<code>EmployeeQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllContractsByEmployeeIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Contratos de un empleado que se cruzan con el rango [<code>from</code>, <code>to</code>].</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>from</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha inicial del rango. Filtro opcional.</td></tr>
<tr><td><code>to</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha final del rango. Filtro opcional.</td></tr>
<tr><td><code>status</code></td><td><code>ContractStatus</code></td><td>private final</td><td>Filtro opcional por estado (nulo: sin filtro).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllContractsByEmployeeIdQuery(Long employeeId, LocalDate from, LocalDate to, ContractStatus status)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Contract&gt;</code> (<code>EmployeeQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetContractByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Un contrato, buscado dentro de su <code>Employee</code> (<code>employeeId</code> y <code>contractId</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>contractId</code></td><td><code>Long</code></td><td>private final</td><td>Id del contrato.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetContractByIdQuery(Long employeeId, Long contractId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Contract&gt;</code> (<code>EmployeeQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllVacationsByEmployeeIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Vacaciones de un empleado que se cruzan con el rango [<code>from</code>, <code>to</code>].</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>from</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha inicial del rango. Filtro opcional.</td></tr>
<tr><td><code>to</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha final del rango. Filtro opcional.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllVacationsByEmployeeIdQuery(Long employeeId, LocalDate from, LocalDate to)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Vacation&gt;</code> (<code>EmployeeQueryService</code>)</td></tr>
</table>

#### Domain Services

<table>
<tr><th colspan="4" align="left"><code>EmployeeCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Employee</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateEmployeeCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateEmployeeCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(UpdateEmployeeCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>UpdateEmployeeCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(ChangeEmployeeRoleCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ChangeEmployeeRoleCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(UpdateEmployeeWorkScheduleCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>UpdateEmployeeWorkScheduleCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(SuspendEmployeeCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>SuspendEmployeeCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(ReinstateEmployeeCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ReinstateEmployeeCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(TerminateEmployeeCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>TerminateEmployeeCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(CreateContractCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateContractCommand</code> y devuelve el id del <code>Contract</code>.</td></tr>
<tr><td><code>handle(TerminateContractCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>TerminateContractCommand</code> y devuelve el id del <code>Contract</code>.</td></tr>
<tr><td><code>handle(ScheduleVacationCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ScheduleVacationCommand</code> y devuelve el id de la <code>Vacation</code>.</td></tr>
<tr><td><code>handle(CancelVacationCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CancelVacationCommand</code> y devuelve el id de la <code>Vacation</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Todo command lleva <code>businessId</code>: el empleado existe (<code>EmployeeNotFound</code>) y employee.belongsTo(<code>businessId</code>) (<code>EmployeeNotInBusiness</code>). El <code>businessId</code> lo resuelve la capa de aplicación desde el usuario logueado; quién puede ejecutarlos lo decide IAM por rol, fuera del dominio. Cambio de rol, horario, estado, contratos y vacaciones: los valida <code>Employee</code> con sus métodos (ver su nota).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Employee</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetAllEmployeesByBusinessIdQuery query)</code></td><td><code>List&lt;Employee&gt;</code></td><td>public</td><td>Resuelve <code>GetAllEmployeesByBusinessIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetEmployeeByIdQuery query)</code></td><td><code>Optional&lt;Employee&gt;</code></td><td>public</td><td>Resuelve <code>GetEmployeeByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetEmployeeByUserIdQuery query)</code></td><td><code>Optional&lt;Employee&gt;</code></td><td>public</td><td>Resuelve <code>GetEmployeeByUserIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetAllContractsByEmployeeIdQuery query)</code></td><td><code>List&lt;Contract&gt;</code></td><td>public</td><td>Resuelve <code>GetAllContractsByEmployeeIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetContractByIdQuery query)</code></td><td><code>Optional&lt;Contract&gt;</code></td><td>public</td><td>Resuelve <code>GetContractByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetAllVacationsByEmployeeIdQuery query)</code></td><td><code>List&lt;Vacation&gt;</code></td><td>public</td><td>Resuelve <code>GetAllVacationsByEmployeeIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Un id inexistente devuelve <code>Optional</code> vacío o una lista vacía.</td></tr>
</table>

#### Exceptions

<table>
<tr><th colspan="4" align="left"><code>EmployeeNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe el empleado indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeNotInBusiness</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el empleado no pertenece al negocio indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeNotInBusiness()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el negocio no existe en Company.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeTerminated</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta modificar a un empleado cesado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeTerminated()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidEmployeeStatusTransition</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la transición de estado no está permitida (ej. suspender a un suspendido).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidEmployeeStatusTransition()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ContractNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el contrato no existe dentro del empleado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ContractNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ContractNotActive</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta terminar un contrato que no está <code>ACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ContractNotActive()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ContractOverlap</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el nuevo contrato se cruza con otro <code>ACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ContractOverlap()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidContractPeriod</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando las fechas del contrato son inválidas o empieza antes de hoy.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidContractPeriod()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidWorkSchedule</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el horario está vacío o tiene turnos que cruzan medianoche o que se cruzan entre sí.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidWorkSchedule()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>WorkScheduleOutsideOperatingHours</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando un turno queda fuera del horario de atención del negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>WorkScheduleOutsideOperatingHours()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VacationNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando las vacaciones no existen dentro del empleado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>VacationNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidVacationPeriod</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando las fechas de las vacaciones son inválidas o empiezan antes de hoy.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidVacationPeriod()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VacationOverlap</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando las vacaciones se cruzan con otras programadas.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>VacationOverlap()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VacationOutsideContract</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando las vacaciones no caen dentro de un contrato <code>ACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>VacationOutsideContract()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VacationNotCancelable</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando las vacaciones ya empezaron o ya fueron canceladas.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>VacationNotCancelable()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DniAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el DNI ya está registrado entre el personal.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DniAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailAddressAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el correo corporativo ya está registrado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmailAddressAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

#### Reglas generales del bounded context

**Contextos externos (fuera de este diagrama).**

**Company** (ACL): dueño del `Business` (hoy, Alivia). Valida que el negocio exista y entrega su `businessProfileId`.

**Profiles** (ACL): dueño del `StaffProfile` del empleado. Valida que el dni y el correo corporativo no estén registrados entre el personal, crea el perfil y actualiza sus datos personales. También entrega el `BusinessHours` del negocio, que el ACL traduce a `OperatingHours`.

**IAM** (ACL y eventos): dueño del usuario. Al contratar crea la cuenta corporativa con el rol del empleado y una contraseña temporal (`CreateCorporateAccountCommand`; el acceso se habilita cuando la cambia). Reacciona a: `EmployeeRoleChangedEvent`: cambia el rol de la cuenta. `EmployeeSuspendedEvent`: bloquea la cuenta corporativa. `EmployeeReinstatedEvent`: la vuelve a habilitar. `EmployeeTerminatedEvent`: desactiva la cuenta corporativa. La cuenta personal de familiar, si la tiene, no cambia.

**Communication** (eventos): avisa al empleado por correo corporativo: la contraseña temporal le llega por el evento `CorporateAccountCreatedEvent` de IAM; la suspensión, reincorporación y cese, por los eventos de este contexto. Al contratar no hay otro correo: la contraseña temporal es la bienvenida. También busca el `userId` del técnico (`GetEmployeeByIdQuery`) para avisarle de una visita asignada en Support.

**Support** (ACL, solo lectura): al asignar una visita, `GetEmployeeByIdQuery` (`TECH`, `ACTIVE`, `WorkSchedule.covers` e `isOnVacation` con la fecha de la visita); al atenderla, `GetEmployeeByUserIdQuery` (el técnico logueado).

**Analytics** (eventos y ACL): cuenta contrataciones, suspensiones y ceses, y el personal actual por estado (`GetAllEmployeesByBusinessIdQuery`).

`BusinessId` identifica el `Business` de Company. `UserId` identifica al usuario de IAM. `StaffProfileId` identifica el `StaffProfile` de Profiles.

### 5.4.2. Interface Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.4.1.

### 5.4.3. Application Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.4.1.

### 5.4.4. Infrastructure Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.4.1.

### 5.4.6. Bounded Context Software Architecture Component Level Diagrams

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.4.1.

### 5.4.7. Bounded Context Software Architecture Code Level Diagrams

#### 5.4.7.1. Bounded Context Domain Layer Class Diagrams

El diagrama muestra el aggregate `Employee` con sus componentes embebidos (`WorkSchedule`, `ContractHistory` y `VacationHistory`) y las entidades `Contract` (1..*) y `Vacation` (0..*), todo por composición con nombre y multiplicidad. Los enums se enlazan con la clase que los usa. `Employee` registra los cinco eventos y depende de `OperatingHours` para validar los turnos. Los services reciben sus commands y queries, y las notas detallan las reglas de los commands y los contextos externos: Company, Profiles, IAM, Communication, Support y Analytics.

![Diagrama de clases de la capa de dominio - Capital Humano](../images/diagrams/img/chapter-5/hcm-backend-diagram.svg)

#### 5.4.7.2. Bounded Context Database Design Diagram

La base de datos es PostgreSQL.

| Tabla o colección | Aggregate, entidad o value object | Llaves y restricciones |
|---|---|---|
| `employees` | `Employee` | PK `id`. UK `user_id`, `staff_profile_id`. Referencia a Company sin FK: `business_id`. Referencia a IAM sin FK: `user_id`. Referencia a Profiles sin FK: `staff_profile_id`. |
| `employee_work_shifts` | `WorkSchedule` (colección de `WeeklyPeriod`) | FK `employee_id`. |
| `contracts` | `Contract` | PK `id`. FK `employee_id`. CHECK (`end_date` >= `start_date`). |
| `vacations` | `Vacation` | PK `id`. FK `employee_id`. CHECK (`end_date` >= `start_date`). |

Relaciones entre tablas: `employees` a `employee_work_shifts` (work_schedule (1..*)); `employees` a `contracts` (contract_history (1..*)); `employees` a `vacations` (vacation_history (0..*)).

**employees** (aggregate `Employee`). Personal de un `Business` (hoy, Alivia).

`business_id`: el `Business` de Company (`BusinessId`). Sin FK; índice para `GetAllEmployeesByBusinessIdQuery`. `user_id`: su cuenta corporativa de IAM (`UserId`). Sin FK. Índice único para `GetEmployeeByUserIdQuery`. `staff_profile_id`: su `StaffProfile` (`StaffProfileId`). Sin FK. Único: como el dni es único entre el personal, una persona no es empleado dos veces. role: `TECH`, `SUBSCRIPTION_MANAGER` o `CLEANING`. status: `ACTIVE`, `SUSPENDED` o `TERMINATED` (final). No se borra: un empleado cesado queda como historial. `termination_reason`: solo cuando está `TERMINATED` (`DISMISSED` o `RESIGNED`). "De vacaciones" no es un estado: se calcula con vacations. Puede estar `ACTIVE` sin contrato vigente hasta que el administrador lo renueve o lo cese.

**`employee_work_shifts`**. Value object `WorkSchedule` (`@ElementCollection`): una fila por cada `WeeklyPeriod` (turno semanal). No tiene id propio: es parte del valor de `Employee`. `week_days`: días separados por coma (MONDAY,TUESDAY,...) con un AttributeConverter, igual que en `business_profile_opening_periods`. `start_time` anterior a `end_time`: los turnos no cruzan medianoche y caben en el horario del negocio (lo valida el dominio). Al cambiar el horario, las filas se reemplazan.



**contracts** (entidad `Contract`). Vive dentro de `Employee`; no se borra. `end_date` obligatorio: no hay contratos de plazo indeterminado. type: `FULL_TIME` o `PART_TIME`. status: `ACTIVE` o `TERMINATED`. "Vencido" se calcula con `end_date`; no se guarda. Índice (`employee_id`, status). Opcional: una restricción de exclusión de PostgreSQL (EXCLUDE USING gist con daterange y `btree_gist`) impide dos contratos `ACTIVE` que se cruzan; respalda `ContractOverlap`.



**vacations** (entidad `Vacation`). Vive dentro de `Employee`; no se borra (historial). status: `SCHEDULED` o `CANCELLED`. Índice (`employee_id`, `start_date`) para `GetAllVacationsByEmployeeIdQuery` e `isOnVacation`. Opcional: la misma restricción de exclusión impide dos vacaciones `SCHEDULED` que se cruzan; respalda `VacationOverlap`.




![Diagrama de base de datos - Capital Humano](../images/diagrams/img/chapter-5/hcm-database-diagram.svg)

<div style="page-break-after: always;"></div>

## 5.5. Bounded Context: Asistencia Médica

En el código, este bounded context es el paquete `assistance`. Assistance gestiona el cuidado de las personas asistidas. El familiar (`Relative`) se registra por su cuenta, paga la suscripción y gestiona a sus personas asistidas: invita cuidadores por correo, crea actividades de cuidado (medicación, baño, comida, etc.) y las asigna a un cuidador o a sí mismo con un horario. También puede corregir sus datos personales y los de su persona asistida, menos el dni y el email. Cada responsable marca como realizadas solo sus propias asignaciones y solo dentro de su horario. Las ocurrencias de una actividad no se guardan: se calculan con el horario, y solo se guarda lo que pasó con cada una (`ActivityLog`). Dentro del contexto los aggregates se referencian directamente; con otros contextos, solo por `UserId`, `PersonProfileId` y `BusinessId`.

### 5.5.1. Domain Layer

#### Aggregates

<table>
<tr><th colspan="4" align="left"><code>Invitation</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Invitación de un familiar a un cuidador para que cuide a una persona asistida. Hay dos caminos según IAM: con una cuenta nueva (correo con la url para definir la contraseña) o con una cuenta de cuidador que ya existe (notificación en la app).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPerson</code></td><td><code>AssistedPerson</code></td><td>private</td><td>Persona a cuidar.</td></tr>
<tr><td><code>inviter</code></td><td><code>Relative</code></td><td>private</td><td>Familiar que invita.</td></tr>
<tr><td><code>inviteeEmail</code></td><td><code>EmailAddress</code></td><td>private</td><td>Correo del cuidador invitado.</td></tr>
<tr><td><code>caregiverUserId</code></td><td><code>UserId</code></td><td>private</td><td>Cuenta de IAM asignada al cuidador. Nula hasta que IAM la asigna.</td></tr>
<tr><td><code>status</code></td><td><code>InvitationStatus</code></td><td>private</td><td><code>PENDING</code>, <code>ACCEPTED</code> o <code>REVOKED</code>.</td></tr>
<tr><td><code>expiresAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Fecha y hora de vencimiento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Invitation(AssistedPerson assistedPerson, Relative inviter, EmailAddress inviteeEmail, LocalDateTime expiresAt)</code></td><td>(constructor)</td><td>public</td><td><code>assistedPerson.isManagedBy</code>(inviter) (<code>AssistedPersonNotManagedByRelative</code>); estado <code>PENDING</code>; registra <code>InvitationCreatedEvent</code>.</td></tr>
<tr><td><code>assignCaregiverAccount(UserId userId, String passwordSetupUrl)</code></td><td><code>void</code></td><td>public</td><td><code>PENDING</code> (<code>InvitationNotPending</code>); si ya tenía cuenta, debe ser el mismo <code>userId</code> (reenvío). Registra <code>InvitationAccountCreatedEvent</code>.</td></tr>
<tr><td><code>assignExistingCaregiverAccount(UserId userId)</code></td><td><code>void</code></td><td>public</td><td>Asigna la cuenta de un cuidador que ya existe. Mismas reglas que <code>assignCaregiverAccount</code>. Registra <code>InvitationNotificationRequestedEvent</code>.</td></tr>
<tr><td><code>accept(UserId caregiverUserId, LocalDateTime now)</code></td><td><code>void</code></td><td>public</td><td><code>PENDING</code> (<code>InvitationNotPending</code>), no vencida (<code>InvitationExpired</code>), con cuenta asignada (<code>CaregiverAccountNotAssigned</code>) y <code>caregiverUserId</code> igual al asignado (<code>InvitationNotForUser</code>). Registra <code>InvitationAcceptedEvent</code>.</td></tr>
<tr><td><code>renew(LocalDateTime newExpiresAt)</code></td><td><code>void</code></td><td>public</td><td><code>PENDING</code> (<code>InvitationNotPending</code>). Registra <code>InvitationResentEvent</code>.</td></tr>
<tr><td><code>revoke()</code></td><td><code>void</code></td><td>public</td><td><code>PENDING</code> (<code>InvitationNotPending</code>).</td></tr>
<tr><td><code>isExpired(LocalDateTime now)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si está <code>PENDING</code> con <code>expiresAt</code> anterior a <code>now</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Una invitación vencida se calcula con <code>isExpired(now)</code>, no se guarda: por eso <code>InvitationStatus</code> no tiene <code>EXPIRED</code>. Una vencida no se acepta (<code>InvitationExpired</code>), pero se puede reenviar: <code>renew</code> le da una nueva vigencia y vuelve a correr el mismo ciclo (cuenta, aviso y aceptación) sobre la misma invitación y la misma cuenta del cuidador. Si fue <code>REVOKED</code> se crea una invitación nueva; si fue <code>ACCEPTED</code>, el <code>Caregiver</code> ya existe.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>invita a cuidar a</code>)</td><td><code>AssistedPerson</code></td><td>0..* a 1</td><td></td></tr>
<tr><td>Asociación dirigida (<code>enviada por (inviter)</code>)</td><td><code>Relative</code></td><td>0..* a 1</td><td></td></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>InvitationStatus</code></td><td>0..* a 1</td><td><code>PENDING</code>, <code>ACCEPTED</code> o <code>REVOKED</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Relative</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar responsable. Se registra solo en un <code>Business</code> y paga la suscripción. Gestiona a sus personas asistidas, crea sus actividades de cuidado e invita cuidadores.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>UserId</code></td><td>private</td><td>Su cuenta personal en IAM.</td></tr>
<tr><td><code>personProfileId</code></td><td><code>PersonProfileId</code></td><td>private</td><td>Su perfil de cliente en Profiles.</td></tr>
<tr><td><code>businessId</code></td><td><code>BusinessId</code></td><td>private</td><td>Negocio (Company) en el que se registró.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Relative(UserId userId, PersonProfileId personProfileId, BusinessId businessId)</code></td><td>(constructor)</td><td>public</td><td>Crea al familiar con su cuenta, su perfil y su negocio.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssistedPerson</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">La persona con discapacidad que recibe el cuidado. Pertenece a un solo <code>Relative</code> y no se da de baja.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>personProfileId</code></td><td><code>PersonProfileId</code></td><td>private</td><td>Su perfil de cliente en Profiles (puede no tener email).</td></tr>
<tr><td><code>relative</code></td><td><code>Relative</code></td><td>private</td><td>Familiar que la gestiona.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssistedPerson(PersonProfileId personProfileId, Relative relative)</code></td><td>(constructor)</td><td>public</td><td>Crea la persona asistida bajo su familiar.</td></tr>
<tr><td><code>isManagedBy(Relative relative)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la gestiona ese familiar. Se usa para validar pertenencia.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">No se da de baja: no tiene estado ni método para eliminarla. Lo que se revoca es el acceso de un cuidador (<code>Caregiver.revoke</code>).</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>gestionada por</code>)</td><td><code>Relative</code></td><td>0..* a 1</td><td></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Caregiver</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El acceso de un usuario de IAM como cuidador de una persona asistida. Un mismo usuario puede cuidar a varias personas: tiene un <code>Caregiver</code> por cada una.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>UserId</code></td><td>private</td><td>Cuenta del cuidador en IAM.</td></tr>
<tr><td><code>assistedPerson</code></td><td><code>AssistedPerson</code></td><td>private</td><td>Persona que cuida.</td></tr>
<tr><td><code>status</code></td><td><code>CaregiverStatus</code></td><td>private</td><td><code>ACTIVE</code> o <code>REVOKED</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Caregiver(UserId userId, AssistedPerson assistedPerson)</code></td><td>(constructor)</td><td>public</td><td>Crea el acceso <code>ACTIVE</code>.</td></tr>
<tr><td><code>revoke()</code></td><td><code>void</code></td><td>public</td><td>De <code>ACTIVE</code> a <code>REVOKED</code> (<code>CaregiverAlreadyRevoked</code>). Registra <code>CaregiverAccessRevokedEvent</code>.</td></tr>
<tr><td><code>isActive()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el acceso sigue vigente.</td></tr>
<tr><td><code>isCaregiverOf(AssistedPerson assistedPerson)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si cuida a esa persona.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>cuida a</code>)</td><td><code>AssistedPerson</code></td><td>0..* a 1</td><td></td></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>CaregiverStatus</code></td><td>0..* a 1</td><td><code>ACTIVE</code> o <code>REVOKED</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CareActivity</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Una actividad de cuidado de una persona asistida (medicación, baño, comida, etc.) con sus asignaciones: quién la hace y cuándo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPerson</code></td><td><code>AssistedPerson</code></td><td>private</td><td>Persona que recibe la actividad.</td></tr>
<tr><td><code>type</code></td><td><code>CareActivityType</code></td><td>private</td><td>Tipo de actividad.</td></tr>
<tr><td><code>title</code></td><td><code>String</code></td><td>private</td><td>Título.</td></tr>
<tr><td><code>description</code></td><td><code>String</code></td><td>private</td><td>Descripción.</td></tr>
<tr><td><code>status</code></td><td><code>ActivityStatus</code></td><td>private</td><td><code>ACTIVE</code> o <code>INACTIVE</code>.</td></tr>
<tr><td><code>activityAssignments</code></td><td><code>ActivityAssignments</code></td><td>private</td><td>Componente con sus asignaciones.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CareActivity(AssistedPerson assistedPerson, CareActivityType type, String title, String description)</code></td><td>(constructor)</td><td>public</td><td>Crea la actividad.</td></tr>
<tr><td><code>update(CareActivityType type, String title, String description)</code></td><td><code>void</code></td><td>public</td><td>Cambia tipo, título y descripción.</td></tr>
<tr><td><code>activate()</code></td><td><code>void</code></td><td>public</td><td>Pasa a <code>ACTIVE</code>.</td></tr>
<tr><td><code>deactivate()</code></td><td><code>void</code></td><td>public</td><td>Pasa a <code>INACTIVE</code>; los logs pasados no cambian.</td></tr>
<tr><td><code>assign(Caregiver caregiver, Schedule schedule, LocalDate today)</code></td><td><code>void</code></td><td>public</td><td>Agrega una asignación. Actividad <code>ACTIVE</code> (<code>CareActivityNotActive</code>); si hay cuidador, <code>ACTIVE</code> (<code>CaregiverNotActive</code>) y de esa persona (<code>CaregiverNotFound</code>); un <code>ONE_TIME</code> no puede tener fecha anterior a <code>today</code> (<code>InvalidSchedule</code>).</td></tr>
<tr><td><code>updateAssignment(Long assignmentId, Caregiver caregiver, Schedule schedule, LocalDate today)</code></td><td><code>void</code></td><td>public</td><td>Cambia responsable y horario con las mismas reglas que <code>assign</code>; la asignación existe (<code>ActivityAssignmentNotFound</code>).</td></tr>
<tr><td><code>activateAssignment(Long assignmentId)</code></td><td><code>void</code></td><td>public</td><td>Activa una asignación; existe (<code>ActivityAssignmentNotFound</code>).</td></tr>
<tr><td><code>deactivateAssignment(Long assignmentId)</code></td><td><code>void</code></td><td>public</td><td>Desactiva una asignación; existe (<code>ActivityAssignmentNotFound</code>).</td></tr>
<tr><td><code>reassignToRelative(Caregiver revokedCaregiver)</code></td><td><code>void</code></td><td>public</td><td>Pasa al familiar las asignaciones de un cuidador revocado.</td></tr>
<tr><td><code>occurrencesOn(LocalDate date)</code></td><td><code>List&lt;ActivityAssignment&gt;</code></td><td>public</td><td>Asignaciones que ocurren en esa fecha.</td></tr>
<tr><td><code>isActive()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la actividad está <code>ACTIVE</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lo que cruza aggregates queda en el service: <code>ScheduleConflict</code> (asignaciones del mismo cuidador en otras actividades) y <code>ScheduleNotEditable</code> (requiere consultar los <code>ActivityLog</code>).</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>cuidado de</code>)</td><td><code>AssistedPerson</code></td><td>0..* a 1</td><td></td></tr>
<tr><td>Asociación dirigida (<code>type</code>)</td><td><code>CareActivityType</code></td><td>0..* a 1</td><td>Tipo de actividad.</td></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>ActivityStatus</code></td><td>0..* a 1</td><td><code>ACTIVE</code> o <code>INACTIVE</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActivityLog</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Historial de lo que pasó con cada ocurrencia: completada, cancelada o perdida. Es lo que consultan el familiar (lo suyo y lo de todos sus cuidadores) y cada cuidador (solo lo suyo).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPerson</code></td><td><code>AssistedPerson</code></td><td>private</td><td>Persona asistida (tomada de la actividad).</td></tr>
<tr><td><code>careActivity</code></td><td><code>CareActivity</code></td><td>private</td><td>Actividad registrada.</td></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private</td><td>Id de la asignación. <code>ActivityAssignment</code> es una entidad interna de <code>CareActivity</code>, por eso el log la guarda por id.</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private</td><td>Fecha en que empieza la ocurrencia.</td></tr>
<tr><td><code>title</code></td><td><code>String</code></td><td>private</td><td>Copia del título vigente ese día.</td></tr>
<tr><td><code>timeRange</code></td><td><code>TimeRange</code></td><td>private</td><td>Copia del horario vigente ese día.</td></tr>
<tr><td><code>assignedCaregiver</code></td><td><code>Caregiver</code></td><td>private</td><td>Copia del responsable vigente ese día. Nulo: el familiar.</td></tr>
<tr><td><code>status</code></td><td><code>ActivityLogStatus</code></td><td>private</td><td><code>COMPLETED</code>, <code>CANCELLED</code> o <code>MISSED</code>.</td></tr>
<tr><td><code>completedBy</code></td><td><code>Caregiver</code></td><td>private</td><td>Quien la completó (solo <code>COMPLETED</code>). Nulo: el familiar.</td></tr>
<tr><td><code>completedAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Momento en que se completó (solo <code>COMPLETED</code>).</td></tr>
<tr><td><code>notes</code></td><td><code>String</code></td><td>private</td><td>Observaciones.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>completed(CareActivity activity, ActivityAssignment assignment, LocalDate date, Caregiver completedBy, LocalDateTime at, String notes)</code></td><td><code>ActivityLog</code></td><td>public static</td><td>Log <code>COMPLETED</code>. Actividad y asignación <code>ACTIVE</code> (<code>CareActivityNotActive</code>, <code>ActivityAssignmentNotActive</code>); <code>completedBy</code> es el responsable de la asignación (<code>NotResponsibleForActivity</code>) y, si es cuidador, está <code>ACTIVE</code> (<code>CaregiverNotActive</code>); <code>at</code> cae entre <code>occurrenceStart(date)</code> y <code>occurrenceEnd(date)</code> (<code>OccurrenceNotStarted</code> antes, <code>OccurrenceEnded</code> después).</td></tr>
<tr><td><code>cancelled(CareActivity activity, ActivityAssignment assignment, LocalDate date, LocalDateTime at)</code></td><td><code>ActivityLog</code></td><td>public static</td><td>Log <code>CANCELLED</code>. La ocurrencia aún no terminó: <code>at</code> anterior a <code>occurrenceEnd(date)</code> (<code>OccurrenceEnded</code>); actividad y asignación <code>ACTIVE</code>. Puede ser cualquier fecha futura. <code>at</code> solo se usa para validar: el momento de la cancelación queda en <code>createdAt</code>.</td></tr>
<tr><td><code>missed(CareActivity activity, ActivityAssignment assignment, LocalDate date, LocalDate today)</code></td><td><code>ActivityLog</code></td><td>public static</td><td>Log <code>MISSED</code>, sin <code>completedBy</code>. La fecha de cierre es anterior a <code>today</code> (<code>DayNotClosedYet</code>).</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Un solo log por asignación y día (<code>assignmentId</code>, <code>date</code>), con restricción única en base de datos; esa unicidad cruza aggregates y la valida el service (<code>OccurrenceClosed</code>). En las tres fábricas, la asignación pertenece a la actividad (<code>ActivityAssignmentNotFound</code>) y ocurre en esa fecha (<code>OccurrenceNotScheduled</code>). <code>assistedPerson</code> y <code>title</code> se toman de la actividad y <code>timeRange</code> de <code>assignment.schedule.effectiveTimeRange()</code>: son una copia de lo vigente ese día, así el historial no cambia si la asignación se edita después.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>historial de</code>)</td><td><code>AssistedPerson</code></td><td>0..* a 1</td><td></td></tr>
<tr><td>Asociación dirigida (<code>registra ocurrencia de</code>)</td><td><code>CareActivity</code></td><td>0..* a 1</td><td></td></tr>
<tr><td>Asociación dirigida (<code>assignedCaregiver / completedBy</code>)</td><td><code>Caregiver</code></td><td>0..* a 0..1</td><td></td></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>ActivityLogStatus</code></td><td>0..* a 1</td><td><code>COMPLETED</code>, <code>CANCELLED</code> o <code>MISSED</code>.</td></tr>
</table>

#### Entities

<table>
<tr><th colspan="4" align="left"><code>ActivityAssignment</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Entity (extiende <code>AuditableModel</code>), dentro de <code>CareActivity</code></td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Quién realiza la actividad (un cuidador o el familiar) y cuándo (<code>Schedule</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivity</code></td><td><code>CareActivity</code></td><td>private</td><td>Referencia a su aggregate root.</td></tr>
<tr><td><code>caregiver</code></td><td><code>Caregiver</code></td><td>private</td><td>Cuidador responsable. Nulo: la hace el familiar.</td></tr>
<tr><td><code>schedule</code></td><td><code>Schedule</code></td><td>private</td><td>Horario de la asignación.</td></tr>
<tr><td><code>status</code></td><td><code>ActivityStatus</code></td><td>private</td><td><code>ACTIVE</code> o <code>INACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>update(Caregiver caregiver, Schedule schedule)</code></td><td><code>void</code></td><td>public</td><td>Cambia responsable y horario.</td></tr>
<tr><td><code>activate()</code></td><td><code>void</code></td><td>public</td><td>Pasa a <code>ACTIVE</code>.</td></tr>
<tr><td><code>deactivate()</code></td><td><code>void</code></td><td>public</td><td>Pasa a <code>INACTIVE</code>.</td></tr>
<tr><td><code>occursOn(LocalDate date)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si tiene una ocurrencia que empieza ese día.</td></tr>
<tr><td><code>isAssignedTo(Caregiver caregiver)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el responsable es ese cuidador.</td></tr>
<tr><td><code>isAssignedToRelative()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la realiza el familiar.</td></tr>
<tr><td><code>isActive()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si está <code>ACTIVE</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Vive dentro de <code>CareActivity</code>: solo se accede por su root, y <code>careActivity</code> es la referencia de vuelta (lado dueño de la relación). Se agrupa en el componente <code>ActivityAssignments</code>. <code>isAssignedTo</code> e <code>isAssignedToRelative</code> los usa <code>ActivityLog.completed</code> (<code>NotResponsibleForActivity</code>); <code>isAssignedTo</code>, también <code>reassignToRelative</code>.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>realizada por (null = familiar)</code>)</td><td><code>Caregiver</code></td><td>0..* a 0..1</td><td></td></tr>
<tr><td>Composición (<code>schedule</code>)</td><td><code>Schedule</code></td><td>1 a 1</td><td>Horario de la asignación.</td></tr>
<tr><td>Asociación dirigida (<code>agrupada en</code>)</td><td><code>ActivityAssignments</code></td><td>0..* a 1</td><td></td></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>ActivityStatus</code></td><td>0..* a 1</td><td><code>ACTIVE</code> o <code>INACTIVE</code>.</td></tr>
</table>

#### Value Objects

<table>
<tr><th colspan="4" align="left"><code>ActivityAssignments</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Componente embebido (<code>@Embeddable</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Componente embebido en <code>CareActivity</code> que agrupa sus <code>ActivityAssignment</code>. <code>CareActivity</code> delega en él: <code>assign</code> agrega con <code>addAssignment</code>; actualizar, activar y desactivar buscan la asignación por su id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>activityAssignments</code></td><td><code>List&lt;ActivityAssignment&gt;</code></td><td>private</td><td>Asignaciones de la actividad. Lista mutable; inicia vacía.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActivityAssignments()</code></td><td>(constructor)</td><td>public</td><td>Inicia la lista vacía y mutable: con una lista inmutable, <code>assign</code> fallaría en una actividad recién creada.</td></tr>
<tr><td><code>getAssignmentWithId(Long assignmentId)</code></td><td><code>ActivityAssignment</code></td><td>public</td><td>Devuelve la asignación o lanza <code>ActivityAssignmentNotFound</code>; nunca devuelve null.</td></tr>
<tr><td><code>getFirstAssignmentWhere(Predicate&lt;ActivityAssignment&gt; predicate)</code></td><td><code>ActivityAssignment</code></td><td>private</td><td>Devuelve la primera asignación que cumple la condición o lanza <code>ActivityAssignmentNotFound</code>. La usa <code>getAssignmentWithId</code>.</td></tr>
<tr><td><code>addAssignment(CareActivity careActivity, Caregiver caregiver, Schedule schedule)</code></td><td><code>ActivityAssignment</code></td><td>public</td><td>Crea y agrega una asignación.</td></tr>
<tr><td><code>updateAssignment(Long assignmentId, Caregiver caregiver, Schedule schedule)</code></td><td><code>void</code></td><td>public</td><td>Actualiza una asignación.</td></tr>
<tr><td><code>activateAssignment(Long assignmentId)</code></td><td><code>void</code></td><td>public</td><td>Activa una asignación.</td></tr>
<tr><td><code>deactivateAssignment(Long assignmentId)</code></td><td><code>void</code></td><td>public</td><td>Desactiva una asignación.</td></tr>
<tr><td><code>reassignToRelative(Caregiver revokedCaregiver)</code></td><td><code>void</code></td><td>public</td><td>Pasa al familiar las asignaciones del cuidador revocado.</td></tr>
<tr><td><code>occurrencesOn(LocalDate date)</code></td><td><code>List&lt;ActivityAssignment&gt;</code></td><td>public</td><td>Asignaciones <code>ACTIVE</code> que ocurren esa fecha. Lo usan la agenda (<code>AgendaItem</code>) y <code>MarkMissedActivitiesCommand</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">No es un value object en sentido estricto: es mutable y contiene entidades con identidad. Se ubica en <code>valueobjects</code> porque se embebe en el aggregate.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>embebido en</code>)</td><td><code>CareActivity</code></td><td>1 a 1</td><td></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Schedule</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Horario de una asignación: una fecha puntual (<code>ONE_TIME</code>) o unos días de la semana (<code>WEEKLY</code>). "Lunes a domingo" es <code>WEEKLY</code> con 7 días; "una vez por semana", <code>WEEKLY</code> con 1 día.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>type</code></td><td><code>ScheduleType</code></td><td>private final</td><td><code>ONE_TIME</code> o <code>WEEKLY</code>.</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha (solo <code>ONE_TIME</code>).</td></tr>
<tr><td><code>timeRange</code></td><td><code>TimeRange</code></td><td>private final</td><td>Rango (solo <code>ONE_TIME</code>).</td></tr>
<tr><td><code>weeklyPeriod</code></td><td><code>WeeklyPeriod</code></td><td>private final</td><td>Días y rango (solo <code>WEEKLY</code>).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>oneTime(LocalDate date, TimeRange timeRange)</code></td><td><code>Schedule</code></td><td>public static</td><td>Fábrica de un horario puntual: <code>date</code> y <code>timeRange</code> obligatorios.</td></tr>
<tr><td><code>weekly(WeeklyPeriod weeklyPeriod)</code></td><td><code>Schedule</code></td><td>public static</td><td>Fábrica de un horario semanal: <code>weeklyPeriod</code> obligatorio, con al menos un día.</td></tr>
<tr><td><code>occursOn(LocalDate date)</code></td><td><code>boolean</code></td><td>public</td><td><code>ONE_TIME</code> compara la fecha; <code>WEEKLY</code> delega en <code>weeklyPeriod</code>.</td></tr>
<tr><td><code>effectiveTimeRange()</code></td><td><code>TimeRange</code></td><td>public</td><td>El rango de cualquiera de las dos formas; es el que se copia al <code>ActivityLog</code>.</td></tr>
<tr><td><code>occurrenceStart(LocalDate date)</code></td><td><code>LocalDateTime</code></td><td>public</td><td>Fecha y hora real de inicio de la ocurrencia.</td></tr>
<tr><td><code>occurrenceEnd(LocalDate date)</code></td><td><code>LocalDateTime</code></td><td>public</td><td>Fecha y hora real de fin (lunes 22:00-06:00 termina el martes 06:00).</td></tr>
<tr><td><code>closingDate(LocalDate date)</code></td><td><code>LocalDate</code></td><td>public</td><td>Fecha de <code>occurrenceEnd(date)</code>: el día en que <code>MarkMissedActivitiesCommand</code> cierra la ocurrencia.</td></tr>
<tr><td><code>overlapsWith(Schedule other)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si alguna ocurrencia de uno se cruza en el tiempo con alguna del otro, comparando fecha y hora reales (lunes 22:00-06:00 se cruza con martes 05:00-07:00; <code>ONE_TIME</code> contra <code>WEEKLY</code> usa el día de la semana de la fecha).</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Un rango que cruza medianoche pertenece a la fecha en que empieza: lunes 22:00-06:00 es la ocurrencia del lunes y termina el martes a las 06:00. El constructor solo valida la forma (<code>InvalidSchedule</code>). Que una fecha no esté en el pasado no se valida aquí, porque al reconstruir una asignación antigua fallaría: lo valida <code>CareActivity.assign</code> o <code>updateAssignment</code> con <code>today</code>.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>type</code>)</td><td><code>ScheduleType</code></td><td>0..* a 1</td><td><code>ONE_TIME</code> o <code>WEEKLY</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AgendaItem</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Modelo de lectura calculado (no se persiste): una ocurrencia de la agenda con su estado. Cruza las asignaciones <code>ACTIVE</code> que ocurren ese día con los <code>ActivityLog</code> y la hora actual.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad.</td></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Asignación.</td></tr>
<tr><td><code>title</code></td><td><code>String</code></td><td>private final</td><td>Título de la actividad.</td></tr>
<tr><td><code>type</code></td><td><code>CareActivityType</code></td><td>private final</td><td>Tipo de actividad.</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de la ocurrencia.</td></tr>
<tr><td><code>timeRange</code></td><td><code>TimeRange</code></td><td>private final</td><td>Horario.</td></tr>
<tr><td><code>caregiverId</code></td><td><code>Long</code></td><td>private final</td><td>Cuidador responsable (nulo: el familiar).</td></tr>
<tr><td><code>recurring</code></td><td><code>boolean</code></td><td>private final</td><td>Verdadero si es <code>WEEKLY</code>.</td></tr>
<tr><td><code>status</code></td><td><code>OccurrenceStatus</code></td><td>private final</td><td>Estado calculado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AgendaItem(Long careActivityId, Long assignmentId, String title, CareActivityType type, LocalDate date, TimeRange timeRange, Long caregiverId, boolean recurring, OccurrenceStatus status)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record.</td></tr>
<tr><td><code>of(CareActivity activity, ActivityAssignment assignment, LocalDate date, ActivityLog log, LocalDateTime now)</code></td><td><code>AgendaItem</code></td><td>public static</td><td>Calcula el estado. Con log, su resultado (<code>COMPLETED</code>, <code>CANCELLED</code> o <code>MISSED</code>); sin log, <code>SCHEDULED</code> antes del inicio, <code>IN_PROGRESS</code> dentro del horario y <code>MISSED</code> después del fin (ya no se puede completar; <code>MarkMissedActivitiesCommand</code> registra el log después). El log puede ser nulo.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">No tiene services propios: no es un aggregate. Sus queries las resuelve <code>CareActivityQueryService</code>. La agenda de una fecha muestra las ocurrencias que empiezan ese día.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>OccurrenceStatus</code></td><td>0..* a 1</td><td>Estado calculado.</td></tr>
</table>

#### Enumerations

<table>
<tr><th colspan="4" align="left"><code>ScheduleType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Fecha puntual o días de la semana.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>ONE_TIME</code>, <code>WEEKLY</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CareActivityType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tipo de actividad de cuidado.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>MEDICATION</code>, <code>BATH</code>, <code>MEAL</code>, <code>EXERCISE</code>, <code>THERAPY</code>, <code>APPOINTMENT</code>, <code>OTHER</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActivityStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de una actividad o de una asignación.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>ACTIVE</code>, <code>INACTIVE</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActivityLogStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Resultado registrado de una ocurrencia.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>COMPLETED</code>, <code>CANCELLED</code>, <code>MISSED</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>OccurrenceStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado calculado de una ocurrencia en la agenda.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>SCHEDULED</code>, <code>IN_PROGRESS</code>, <code>COMPLETED</code>, <code>CANCELLED</code>, <code>MISSED</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Ciclo de una invitación.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>PENDING</code>, <code>ACCEPTED</code>, <code>REVOKED</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CaregiverStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado del acceso de un cuidador.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>ACTIVE</code>, <code>REVOKED</code></td></tr>
</table>

#### Domain Events

<table>
<tr><th colspan="4" align="left"><code>InvitationCreatedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que un familiar creó una invitación para un cuidador.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitation</code></td><td><code>Invitation</code></td><td>private</td><td>Invitación que originó el evento; su id se lee al publicarse.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationCreatedEvent(Invitation invitation)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><code>getInvitationId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve el id de la invitación al publicarse el evento.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Invitation.constructor</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>RegisterCaregiverAccountCommand</code> (síncrono).</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Se registra en el constructor de <code>Invitation</code>, cuando aún no hay id: <code>getInvitationId()</code> lo lee del aggregate al publicarse.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationResentEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que se reenvió una invitación pendiente con una nueva vigencia.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationResentEvent(Long invitationId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Invitation.renew</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>RegisterCaregiverAccountCommand</code> (síncrono), que vuelve a correr el registro de cuenta y el aviso.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationAccountCreatedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que IAM creó (o regeneró) la cuenta del cuidador invitado y que debe enviársele el correo para definir su contraseña.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><td><code>inviteeEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo del cuidador invitado.</td></tr>
<tr><td><code>passwordSetupUrl</code></td><td><code>String</code></td><td>private final</td><td>Url para que el cuidador defina su contraseña.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationAccountCreatedEvent(Long invitationId, String inviteeEmail, String passwordSetupUrl)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Invitation.assignCaregiverAccount</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Communication envía el correo con la url (<code>SendEmailCommand</code>, plantilla <code>CAREGIVER_INVITATION</code>). Después del commit.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationNotificationRequestedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que el cuidador invitado ya tenía cuenta y debe recibir la invitación como notificación en la app.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><td><code>caregiverUserId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta de IAM del cuidador, que ya existía.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationNotificationRequestedEvent(Long invitationId, Long caregiverUserId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Invitation.assignExistingCaregiverAccount</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Communication crea el aviso en la app y lo envía al teléfono (<code>CreateNotificationCommand</code>, tipo <code>CAREGIVER_INVITATION</code>). Después del commit.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationAcceptedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que el cuidador aceptó la invitación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida que cuidará.</td></tr>
<tr><td><code>caregiverUserId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta de IAM del cuidador que aceptó.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationAcceptedEvent(Long invitationId, Long assistedPersonId, Long caregiverUserId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Invitation.accept</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>CreateCaregiverCommand</code> (síncrono).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CaregiverAccessRevokedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que el familiar revocó el acceso de un cuidador a una persona asistida.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>caregiverId</code></td><td><code>Long</code></td><td>private final</td><td>Cuidador revocado.</td></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CaregiverAccessRevokedEvent(Long caregiverId, Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Caregiver.revoke</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>ReassignCaregiverActivitiesCommand</code> (síncrono): sus asignaciones pasan al familiar.</td></tr>
</table>

#### Commands

<table>
<tr><th colspan="4" align="left"><code>CreateRelativeCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Registro del familiar: su cuenta personal en IAM, su <code>PersonProfile</code> y su <code>Relative</code>. Lo ejecuta el propio familiar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Negocio (Company) en el que se registra.</td></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo. Obligatorio: es su cuenta en IAM y el email de su <code>PersonProfile</code>.</td></tr>
<tr><td><code>password</code></td><td><code>String</code></td><td>private final</td><td>Contraseña de su cuenta. Obligatoria; se oculta en <code>toString()</code> para que no llegue a los logs.</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo de la foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><td><code>dni</code></td><td><code>String</code></td><td>private final</td><td>DNI.</td></tr>
<tr><td><code>birthDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de nacimiento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateRelativeCommand(Long businessId, String emailAddress, String password, byte[] photoData, String photoFileName, String phoneNumber, String firstName, String lastName, String dni, LocalDate birthDate)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>RelativeCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3"><code>emailAddress</code> y <code>password</code> son obligatorios: el constructor del command los rechaza si vienen vacíos. El negocio existe en Company (<code>BusinessNotFound</code>). El dni no está entre los clientes (<code>ExistsPersonProfileByDniQuery</code>; <code>DniAlreadyExists</code>) y el email no está registrado (<code>ExistsPersonProfileByEmailAddressQuery</code>; <code>EmailAddressAlreadyExists</code>); Profiles crea el <code>PersonProfile</code>. Nadie se registra dos veces como familiar: lo garantiza el dni único entre los clientes. IAM crea su cuenta personal con <code>SignUpCommand</code> (<code>ROLE_RELATIVE</code>) y le envía un código para verificar el correo. El correo no puede tener otra cuenta: un cuidador que se registra como familiar usa otro correo (<code>EmailAddressAlreadyExists</code>, lo valida IAM). Si también es empleado de Alivia, tiene además un <code>StaffProfile</code> y una cuenta corporativa aparte. Después todo se enlaza por id, nunca por dni ni email.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateAssistedPersonCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar registra a una persona asistida: su <code>PersonProfile</code> y su <code>AssistedPerson</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que la registra (sale de la sesión).</td></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo. Opcional.</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo de la foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><td><code>dni</code></td><td><code>String</code></td><td>private final</td><td>DNI.</td></tr>
<tr><td><code>birthDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de nacimiento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateAssistedPersonCommand(Long relativeId, String emailAddress, byte[] photoData, String photoFileName, String phoneNumber, String firstName, String lastName, String dni, LocalDate birthDate)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AssistedPersonCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El <code>Relative</code> existe (<code>RelativeNotFound</code>). El dni no está entre los clientes (<code>DniAlreadyExists</code>) y el email, si viene, tampoco (<code>EmailAddressAlreadyExists</code>); Profiles crea el <code>PersonProfile</code>. No tiene cuenta en IAM. Queda gestionada por ese familiar.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateRelativeCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar corrige sus datos personales, menos el dni y el email.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que se actualiza (sale de la sesión).</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo de la foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo de la foto.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono con código de país, solo dígitos.</td></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><td><code>birthDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de nacimiento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateRelativeCommand(Long relativeId, byte[] photoData, String photoFileName, String phoneNumber, String firstName, String lastName, LocalDate birthDate)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>RelativeCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El <code>Relative</code> existe (<code>RelativeNotFound</code>). <code>Relative</code> no cambia: el ACL envía <code>UpdatePersonProfileCommand</code> a Profiles con su <code>personProfileId</code>.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>valida; datos en Profiles</code>)</td><td><code>Relative</code></td><td>No aplica</td><td></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateAssistedPersonCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar corrige los datos personales de su persona asistida, menos el dni y el email.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la persona asistida (Assistance).</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que la gestiona (sale de la sesión).</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo de la foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo de la foto.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono con código de país, solo dígitos.</td></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><td><code>birthDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de nacimiento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateAssistedPersonCommand(Long assistedPersonId, Long relativeId, byte[] photoData, String photoFileName, String phoneNumber, String firstName, String lastName, LocalDate birthDate)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AssistedPersonCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El <code>Relative</code> existe (<code>RelativeNotFound</code>); la persona asistida existe (<code>AssistedPersonNotFound</code>) y la gestiona ese familiar (<code>AssistedPersonNotManagedByRelative</code>). <code>AssistedPerson</code> no cambia: el ACL envía <code>UpdatePersonProfileCommand</code> a Profiles con su <code>personProfileId</code>.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>valida; datos en Profiles</code>)</td><td><code>AssistedPerson</code></td><td>No aplica</td><td></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateInvitationCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar invita a un cuidador, por su correo, a cuidar a una persona asistida.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que invita (sale de la sesión).</td></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><td><code>inviteeEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo del cuidador invitado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateInvitationCommand(Long relativeId, Long assistedPersonId, String inviteeEmail)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>InvitationCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La <code>AssistedPerson</code> pertenece a <code>relativeId</code>; no hay otra invitación <code>PENDING</code> al mismo email para esa persona, vigente o vencida (<code>InvitationAlreadyExists</code>). Si la anterior venció, se usa <code>ResendInvitationCommand</code>. La vigencia (<code>expiresAt</code>) la fija la capa de aplicación, desde configuración.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RegisterCaregiverAccountCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Pide a IAM la cuenta del cuidador invitado y la asigna a la invitación. Lo activan <code>InvitationCreatedEvent</code> e <code>InvitationResentEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RegisterCaregiverAccountCommand(Long invitationId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>InvitationCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La invitación está <code>PENDING</code>; el ACL con IAM consulta <code>inviteeEmail</code>. Si ya tiene cuenta con contraseña definida: no existe un <code>Caregiver</code> <code>ACTIVE</code> de ese <code>userId</code> para esa <code>AssistedPerson</code> (<code>CaregiverAlreadyExists</code>) y llama a invitation.assignExistingCaregiverAccount(<code>userId</code>). Si no: IAM crea la cuenta y llama a invitation.assignCaregiverAccount(<code>userId</code>, <code>passwordSetupUrl</code>). Si el correo es de un familiar o de una cuenta corporativa, IAM lo rechaza (<code>EmailAddressAlreadyExists</code>): para cuidar a otra persona se usa otro correo. Solo se reutiliza la cuenta de alguien que ya es cuidador. Si la cuenta se creó en un envío anterior y su contraseña nunca se cambió, IAM regenera la url (la anterior deja de valer) y devuelve el mismo <code>userId</code>. La url vence en <code>expiresAt</code>, junto con la invitación.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AcceptInvitationCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El cuidador acepta la invitación. Con cuenta nueva lo activa <code>PasswordDefinedEvent</code> de IAM; con cuenta existente lo envía el cuidador desde la app.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><td><code>caregiverUserId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta de IAM del cuidador que acepta.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AcceptInvitationCommand(Long invitationId, Long caregiverUserId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>InvitationCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3"><code>Invitation.accept</code>(<code>userId</code>, now) valida <code>PENDING</code>, no vencida, cuenta asignada y que <code>caregiverUserId</code> sea el de la invitación (<code>InvitationNotPending</code>, <code>InvitationExpired</code>, <code>CaregiverAccountNotAssigned</code>, <code>InvitationNotForUser</code>). Cuenta nueva: IAM avisa el cambio de contraseña con el <code>userId</code>; <code>GetPendingInvitationsByCaregiverUserIdQuery</code> da sus invitaciones <code>PENDING</code> y se acepta cada una. Cuenta existente: el cuidador ve sus invitaciones con la misma query desde la app y acepta la que elija (<code>AcceptInvitationCommand</code> con su <code>userId</code> de sesión).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RevokeInvitationCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar revoca una invitación pendiente.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que la envió (sale de la sesión).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RevokeInvitationCommand(Long invitationId, Long relativeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>InvitationCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La invitación pertenece a <code>relativeId</code> (inviterId) y está <code>PENDING</code>. El <code>Caregiver</code> se crea recién al aceptar: hasta entonces no existe y no puede operar.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ResendInvitationCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar reenvía una invitación pendiente, vigente o vencida, con una nueva vigencia.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que la envió (sale de la sesión).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ResendInvitationCommand(Long invitationId, Long relativeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>InvitationCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La invitación pertenece a <code>relativeId</code> (inviterId) y está <code>PENDING</code>, vigente o vencida (<code>InvitationNotPending</code> si fue <code>ACCEPTED</code> o <code>REVOKED</code>). Llama a invitation.renew(nuevo <code>expiresAt</code>) y activa de nuevo el registro de cuenta y el aviso (correo o notificación).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateCaregiverCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea el acceso del cuidador a la persona asistida. Lo activa <code>InvitationAcceptedEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><td><code>caregiverUserId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta de IAM del cuidador.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateCaregiverCommand(Long assistedPersonId, Long caregiverUserId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>CaregiverCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">No existe un <code>Caregiver</code> <code>ACTIVE</code> de ese usuario para esa <code>AssistedPerson</code> (<code>CaregiverAlreadyExists</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RevokeCaregiverAccessCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar revoca el acceso de un cuidador a su persona asistida.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>caregiverId</code></td><td><code>Long</code></td><td>private final</td><td>Cuidador a revocar.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que revoca (sale de la sesión).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RevokeCaregiverAccessCommand(Long caregiverId, Long relativeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>CaregiverCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La <code>AssistedPerson</code> del caregiver pertenece a <code>relativeId</code>; el caregiver está <code>ACTIVE</code> (<code>CaregiverAlreadyRevoked</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateCareActivityCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar crea una actividad de cuidado para su persona asistida.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que la crea (sale de la sesión).</td></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><td><code>type</code></td><td><code>CareActivityType</code></td><td>private final</td><td>Tipo de actividad.</td></tr>
<tr><td><code>title</code></td><td><code>String</code></td><td>private final</td><td>Título.</td></tr>
<tr><td><code>description</code></td><td><code>String</code></td><td>private final</td><td>Descripción.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateCareActivityCommand(Long relativeId, Long assistedPersonId, CareActivityType type, String title, String description)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>CareActivityCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La persona asistida pertenece a <code>relativeId</code> (<code>AssistedPersonNotManagedByRelative</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateCareActivityCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar cambia el tipo, el título o la descripción de una actividad.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad a modificar.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que opera.</td></tr>
<tr><td><code>type</code></td><td><code>CareActivityType</code></td><td>private final</td><td>Tipo de actividad.</td></tr>
<tr><td><code>title</code></td><td><code>String</code></td><td>private final</td><td>Título.</td></tr>
<tr><td><code>description</code></td><td><code>String</code></td><td>private final</td><td>Descripción.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateCareActivityCommand(Long careActivityId, Long relativeId, CareActivityType type, String title, String description)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>CareActivityCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La actividad existe (<code>CareActivityNotFound</code>) y su persona asistida pertenece a <code>relativeId</code> (<code>AssistedPersonNotManagedByRelative</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActivateCareActivityCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Activa una actividad.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que opera (sale de la sesión).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActivateCareActivityCommand(Long careActivityId, Long relativeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>CareActivityCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeactivateCareActivityCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Desactiva una actividad.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que opera (sale de la sesión).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeactivateCareActivityCommand(Long careActivityId, Long relativeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>CareActivityCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssignCareActivityCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar asigna una actividad a un cuidador o a sí mismo, con un horario.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que asigna.</td></tr>
<tr><td><code>caregiverId</code></td><td><code>Long</code></td><td>private final</td><td>Cuidador responsable. Opcional: nulo si la hace el familiar.</td></tr>
<tr><td><code>scheduleType</code></td><td><code>ScheduleType</code></td><td>private final</td><td><code>ONE_TIME</code> o <code>WEEKLY</code>.</td></tr>
<tr><td><code>days</code></td><td><code>Set&lt;DayOfWeek&gt;</code></td><td>private final</td><td>Días de la semana (solo <code>WEEKLY</code>).</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha (solo <code>ONE_TIME</code>).</td></tr>
<tr><td><code>startTime</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de inicio.</td></tr>
<tr><td><code>endTime</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de fin; si es anterior al inicio, cruza medianoche.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssignCareActivityCommand(Long careActivityId, Long relativeId, Long caregiverId, ScheduleType scheduleType, Set&lt;DayOfWeek&gt; days, LocalDate date, LocalTime startTime, LocalTime endTime)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>CareActivityCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La actividad está <code>ACTIVE</code> (<code>CareActivityNotActive</code>) y su <code>AssistedPerson</code> pertenece a <code>relativeId</code>. Si hay <code>caregiverId</code>: es <code>Caregiver</code> <code>ACTIVE</code> de esa persona (<code>CaregiverNotActive</code>). <code>Schedule</code> válido: <code>ONE_TIME</code> con date, <code>WEEKLY</code> con days, <code>startTime</code> distinto de <code>endTime</code> (<code>InvalidSchedule</code>). Si <code>endTime</code> es anterior a <code>startTime</code>, cruza medianoche y termina al día siguiente (22:00-06:00). <code>ONE_TIME</code>: la fecha no está en el pasado. No choca con otra asignación <code>ACTIVE</code> del mismo cuidador (<code>ScheduleConflict</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateActivityAssignmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar cambia el responsable o el horario de una asignación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad.</td></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la asignación dentro de la actividad.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que asigna (sale de la sesión).</td></tr>
<tr><td><code>caregiverId</code></td><td><code>Long</code></td><td>private final</td><td>Cuidador responsable. Opcional: nulo si la hace el familiar.</td></tr>
<tr><td><code>scheduleType</code></td><td><code>ScheduleType</code></td><td>private final</td><td><code>ONE_TIME</code> o <code>WEEKLY</code>.</td></tr>
<tr><td><code>days</code></td><td><code>Set&lt;DayOfWeek&gt;</code></td><td>private final</td><td>Días de la semana (solo <code>WEEKLY</code>).</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha (solo <code>ONE_TIME</code>).</td></tr>
<tr><td><code>startTime</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de inicio.</td></tr>
<tr><td><code>endTime</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de fin; si es anterior al inicio, cruza medianoche.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateActivityAssignmentCommand(Long careActivityId, Long assignmentId, Long relativeId, Long caregiverId, ScheduleType scheduleType, Set&lt;DayOfWeek&gt; days, LocalDate date, LocalTime startTime, LocalTime endTime)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>CareActivityCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Las mismas reglas que <code>AssignCareActivityCommand</code>. <code>ONE_TIME</code> que ya tiene log: se rechaza (<code>ScheduleNotEditable</code>). Los logs ya registrados no cambian: guardan su copia del día.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActivateActivityAssignmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Activa una asignación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad.</td></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la asignación dentro de la actividad.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que opera (sale de la sesión).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActivateActivityAssignmentCommand(Long careActivityId, Long assignmentId, Long relativeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>CareActivityCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeactivateActivityAssignmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Desactiva una asignación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad.</td></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la asignación dentro de la actividad.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que opera (sale de la sesión).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeactivateActivityAssignmentCommand(Long careActivityId, Long assignmentId, Long relativeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>CareActivityCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ReassignCaregiverActivitiesCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Pasa al familiar las asignaciones de un cuidador revocado. Lo activa <code>CaregiverAccessRevokedEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>caregiverId</code></td><td><code>Long</code></td><td>private final</td><td>Cuidador revocado.</td></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ReassignCaregiverActivitiesCommand(Long caregiverId, Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>CareActivityCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Las asignaciones del cuidador revocado pasan al familiar (<code>caregiverId</code> nulo).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CompleteActivityCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar o el cuidador responsable marca una ocurrencia como realizada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad.</td></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la asignación dentro de la actividad.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que completa. Viene informado exactamente uno de <code>relativeId</code> o <code>caregiverId</code>.</td></tr>
<tr><td><code>caregiverId</code></td><td><code>Long</code></td><td>private final</td><td>Cuidador que completa. Viene informado exactamente uno de <code>relativeId</code> o <code>caregiverId</code>.</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha en que empieza la ocurrencia.</td></tr>
<tr><td><code>notes</code></td><td><code>String</code></td><td>private final</td><td>Observaciones.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CompleteActivityCommand(Long careActivityId, Long assignmentId, Long relativeId, Long caregiverId, LocalDate date, String notes)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>ActivityLogCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La actividad existe (<code>CareActivityNotFound</code>) y la asignación está en ella (<code>ActivityAssignmentNotFound</code>). La actividad y la asignación están <code>ACTIVE</code> (<code>CareActivityNotActive</code>, <code>ActivityAssignmentNotActive</code>). La asignación ocurre en esa fecha (<code>OccurrenceNotScheduled</code>). Se completa solo dentro del horario de la ocurrencia (<code>OccurrenceNotStarted</code> antes del inicio, <code>OccurrenceEnded</code> después del fin). Quien completa es el responsable de la asignación (<code>NotResponsibleForActivity</code>); si es cuidador, sigue <code>ACTIVE</code> (<code>CaregiverNotActive</code>). No existe log para (<code>assignmentId</code>, date). Si ya hay uno (<code>COMPLETED</code>, <code>CANCELLED</code> o <code>MISSED</code>): <code>OccurrenceClosed</code>. Lunes 22:00-06:00: se completa entre el lunes 22:00 y el martes 06:00. Todo excepto la unicidad del log lo valida <code>ActivityLog.completed</code>(...).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CancelActivityOccurrenceCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar cancela una ocurrencia que aún no terminó ("hoy no hay caminata").</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad.</td></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la asignación dentro de la actividad.</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha en que empieza la ocurrencia.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar dueño (sale de la sesión).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CancelActivityOccurrenceCommand(Long careActivityId, Long assignmentId, LocalDate date, Long relativeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>ActivityLogCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">("hoy no hay caminata"). La asignación se busca dentro de su <code>CareActivity</code> (<code>careActivityId</code> + <code>assignmentId</code>); solo el familiar dueño. Puede cancelar cualquier fecha que aún no terminó, incluso futuras; las pasadas no (<code>OccurrenceEnded</code>). Crea un log <code>CANCELLED</code> solo para esa ocurrencia; no debe existir log para (<code>assignmentId</code>, date).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>MarkMissedActivitiesCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cierra un día: crea un log <code>MISSED</code> por cada ocurrencia sin registro. Lo ejecuta el proceso programado cada día a las 00:05 con la fecha de ayer.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>closingDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Día que se cierra: sus ocurrencias sin log pasan a <code>MISSED</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>MarkMissedActivitiesCommand(LocalDate closingDate)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>ActivityLogCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3"><code>closingDate</code> es anterior a hoy (<code>DayNotClosedYet</code>). Crea un log <code>MISSED</code> por cada ocurrencia <code>ACTIVE</code> sin log cuya fecha de cierre es <code>closingDate</code>: las de ese día que no cruzan medianoche y las del día anterior que sí. Es idempotente por (<code>assignmentId</code>, <code>date</code>). Un log <code>MISSED</code> queda cerrado: ya no se puede completar.</td></tr>
</table>

#### Queries

<table>
<tr><th colspan="4" align="left"><code>GetInvitationByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Invitación por id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetInvitationByIdQuery(Long invitationId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Invitation&gt;</code> (<code>InvitationQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetPendingInvitationsByCaregiverUserIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Invitaciones <code>PENDING</code> de un cuidador, para aceptarlas.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>caregiverUserId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta de IAM asignada al cuidador. Nula hasta que IAM la asigna.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetPendingInvitationsByCaregiverUserIdQuery(Long caregiverUserId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Invitation&gt;</code> (<code>InvitationQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetInvitationsByAssistedPersonIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Invitaciones de una persona.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetInvitationsByAssistedPersonIdQuery(Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Invitation&gt;</code> (<code>InvitationQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAssistedPersonsByRelativeIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Personas asistidas de un familiar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que la registra.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAssistedPersonsByRelativeIdQuery(Long relativeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;AssistedPerson&gt;</code> (<code>AssistedPersonQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAssistedPersonByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Persona asistida por id. La usan Subscriptions y Support (validan que exista y la gestione el familiar) y Communication (obtiene al familiar). Nombre y datos personales viven en Profiles.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAssistedPersonByIdQuery(Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;AssistedPerson&gt;</code> (<code>AssistedPersonQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetRelativeByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Familiar por id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que la registra.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetRelativeByIdQuery(Long relativeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Relative&gt;</code> (<code>RelativeQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetRelativeByUserIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Familiar del usuario que inició sesión.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta personal del familiar.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetRelativeByUserIdQuery(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Relative&gt;</code> (<code>RelativeQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetRelativesByBusinessIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Familiares de un negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetRelativesByBusinessIdQuery(Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Relative&gt;</code> (<code>RelativeQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetCaregiversByAssistedPersonIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cuidadores de una persona asistida. Communication la usa para obtener el <code>userId</code> de los cuidadores de turno y confirmar que siguen <code>ACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetCaregiversByAssistedPersonIdQuery(Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Caregiver&gt;</code> (<code>CaregiverQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetCaregiversByUserIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Accesos de cuidador <code>ACTIVE</code> del usuario que inició sesión.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta del cuidador.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetCaregiversByUserIdQuery(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Caregiver&gt;</code> (<code>CaregiverQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetCareActivityByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Actividad por id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetCareActivityByIdQuery(Long careActivityId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;CareActivity&gt;</code> (<code>CareActivityQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetCareActivitiesByAssistedPersonIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Actividades de una persona.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetCareActivitiesByAssistedPersonIdQuery(Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;CareActivity&gt;</code> (<code>CareActivityQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAgendaByAssistedPersonIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Agenda completa de la persona asistida (familiar y cuidadores). Communication la usa para hallar a los cuidadores de turno en un momento dado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><td><code>from</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha inicial del rango consultado.</td></tr>
<tr><td><code>to</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha final del rango consultado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAgendaByAssistedPersonIdQuery(Long assistedPersonId, LocalDate from, LocalDate to)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;AgendaItem&gt;</code> (<code>CareActivityQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAgendaByCaregiverIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Agenda propia de un cuidador.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>caregiverId</code></td><td><code>Long</code></td><td>private final</td><td>Cuidador responsable (nulo: el familiar).</td></tr>
<tr><td><code>from</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha inicial del rango consultado.</td></tr>
<tr><td><code>to</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha final del rango consultado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAgendaByCaregiverIdQuery(Long caregiverId, LocalDate from, LocalDate to)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;AgendaItem&gt;</code> (<code>CareActivityQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetActivityLogsByAssistedPersonIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Historial de toda la persona asistida en el rango (lo del familiar y lo de cada cuidador). Es la vista con la que el familiar sigue las actividades.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><td><code>from</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha inicial del rango consultado.</td></tr>
<tr><td><code>to</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha final del rango consultado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetActivityLogsByAssistedPersonIdQuery(Long assistedPersonId, LocalDate from, LocalDate to)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;ActivityLog&gt;</code> (<code>ActivityLogQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetActivityLogsByCaregiverIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Historial propio de un cuidador: los logs cuyo <code>assignedCaregiver</code> es él, incluidos los <code>CANCELLED</code> y <code>MISSED</code>, que no tienen <code>completedBy</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>caregiverId</code></td><td><code>Long</code></td><td>private final</td><td>Cuidador responsable (nulo: el familiar).</td></tr>
<tr><td><code>from</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha inicial del rango consultado.</td></tr>
<tr><td><code>to</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha final del rango consultado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetActivityLogsByCaregiverIdQuery(Long caregiverId, LocalDate from, LocalDate to)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;ActivityLog&gt;</code> (<code>ActivityLogQueryService</code>)</td></tr>
</table>

#### Domain Services

**Reglas comunes de `RelativeQueryService`, `InvitationQueryService`, `CaregiverQueryService`, `CareActivityQueryService`, `ActivityLogQueryService`.** Cada query lleva solo el id por el que se busca (GetXById: el id de X; GetXByYId: el id de Y) y, en agenda e historial, el rango from / to. Las queries no validan pertenencia: no llevan `relativeId`. Quién puede ver qué se resuelve antes, desde el usuario logueado: `GetRelativeByUserIdQuery` y `GetCaregiversByUserIdQuery` entregan el `relativeId` / `caregiverId`, y `AssistedPerson.isManagedBy`(relative) confirma que la persona es suya (`AssistedPersonNotManagedByRelative`). Los commands sí llevan `relativeId` y validan la pertenencia. Las del cuidador usan su `caregiverId` (`GetAgendaByCaregiverIdQuery` y `GetActivityLogsByCaregiverIdQuery`).

<table>
<tr><th colspan="4" align="left"><code>RelativeCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Relative</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateRelativeCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateRelativeCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(UpdateRelativeCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>UpdateRelativeCommand</code> y devuelve el id del <code>Relative</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssistedPersonCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>AssistedPerson</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateAssistedPersonCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateAssistedPersonCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(UpdateAssistedPersonCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>UpdateAssistedPersonCommand</code> y devuelve el id de la <code>AssistedPerson</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Invitation</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateInvitationCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateInvitationCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(RegisterCaregiverAccountCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>RegisterCaregiverAccountCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(AcceptInvitationCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>AcceptInvitationCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(RevokeInvitationCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>RevokeInvitationCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(ResendInvitationCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ResendInvitationCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CaregiverCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Caregiver</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateCaregiverCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateCaregiverCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(RevokeCaregiverAccessCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>RevokeCaregiverAccessCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CareActivityCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>CareActivity</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateCareActivityCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateCareActivityCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(UpdateCareActivityCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>UpdateCareActivityCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(ActivateCareActivityCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ActivateCareActivityCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(DeactivateCareActivityCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>DeactivateCareActivityCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(AssignCareActivityCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>AssignCareActivityCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(UpdateActivityAssignmentCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>UpdateActivityAssignmentCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(ActivateActivityAssignmentCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ActivateActivityAssignmentCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(DeactivateActivityAssignmentCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>DeactivateActivityAssignmentCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(ReassignCaregiverActivitiesCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>ReassignCaregiverActivitiesCommand</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Todo command con <code>relativeId</code> valida que la <code>AssistedPerson</code> de la actividad pertenezca a ese <code>relativeId</code> (<code>AssistedPersonNotManagedByRelative</code>). Activate / Deactivate (actividad y asignación): solo cambian el estado; los logs pasados quedan intactos.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActivityLogCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>ActivityLog</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CompleteActivityCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CompleteActivityCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(CancelActivityOccurrenceCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CancelActivityOccurrenceCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(MarkMissedActivitiesCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>MarkMissedActivitiesCommand</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Invitation</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetInvitationByIdQuery query)</code></td><td><code>Optional&lt;Invitation&gt;</code></td><td>public</td><td>Resuelve <code>GetInvitationByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetInvitationsByAssistedPersonIdQuery query)</code></td><td><code>List&lt;Invitation&gt;</code></td><td>public</td><td>Resuelve <code>GetInvitationsByAssistedPersonIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetPendingInvitationsByCaregiverUserIdQuery query)</code></td><td><code>List&lt;Invitation&gt;</code></td><td>public</td><td>Resuelve <code>GetPendingInvitationsByCaregiverUserIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RelativeQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Relative</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetRelativeByIdQuery query)</code></td><td><code>Optional&lt;Relative&gt;</code></td><td>public</td><td>Resuelve <code>GetRelativeByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetRelativeByUserIdQuery query)</code></td><td><code>Optional&lt;Relative&gt;</code></td><td>public</td><td>Resuelve <code>GetRelativeByUserIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetRelativesByBusinessIdQuery query)</code></td><td><code>List&lt;Relative&gt;</code></td><td>public</td><td>Resuelve <code>GetRelativesByBusinessIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssistedPersonQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>AssistedPerson</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetAssistedPersonsByRelativeIdQuery query)</code></td><td><code>List&lt;AssistedPerson&gt;</code></td><td>public</td><td>Resuelve <code>GetAssistedPersonsByRelativeIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetAssistedPersonByIdQuery query)</code></td><td><code>Optional&lt;AssistedPerson&gt;</code></td><td>public</td><td>Resuelve <code>GetAssistedPersonByIdQuery</code>; devuelve vacío si no existe.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CaregiverQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Caregiver</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetCaregiversByAssistedPersonIdQuery query)</code></td><td><code>List&lt;Caregiver&gt;</code></td><td>public</td><td>Resuelve <code>GetCaregiversByAssistedPersonIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetCaregiversByUserIdQuery query)</code></td><td><code>List&lt;Caregiver&gt;</code></td><td>public</td><td>Resuelve <code>GetCaregiversByUserIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CareActivityQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>CareActivity</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetCareActivityByIdQuery query)</code></td><td><code>Optional&lt;CareActivity&gt;</code></td><td>public</td><td>Resuelve <code>GetCareActivityByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetCareActivitiesByAssistedPersonIdQuery query)</code></td><td><code>List&lt;CareActivity&gt;</code></td><td>public</td><td>Resuelve <code>GetCareActivitiesByAssistedPersonIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetAgendaByAssistedPersonIdQuery query)</code></td><td><code>List&lt;AgendaItem&gt;</code></td><td>public</td><td>Resuelve <code>GetAgendaByAssistedPersonIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetAgendaByCaregiverIdQuery query)</code></td><td><code>List&lt;AgendaItem&gt;</code></td><td>public</td><td>Resuelve <code>GetAgendaByCaregiverIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActivityLogQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>ActivityLog</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetActivityLogsByAssistedPersonIdQuery query)</code></td><td><code>List&lt;ActivityLog&gt;</code></td><td>public</td><td>Resuelve <code>GetActivityLogsByAssistedPersonIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetActivityLogsByCaregiverIdQuery query)</code></td><td><code>List&lt;ActivityLog&gt;</code></td><td>public</td><td>Resuelve <code>GetActivityLogsByCaregiverIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

#### Exceptions

<table>
<tr><th colspan="4" align="left"><code>InvitationNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe la invitación indicada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationNotPending</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la invitación ya fue aceptada o revocada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationNotPending()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationExpired</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta aceptar una invitación vencida.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationExpired()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationNotForUser</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando quien acepta no es el usuario asignado a la invitación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationNotForUser()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando ya hay una invitación <code>PENDING</code> al mismo email para esa persona.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CaregiverAccountNotAssigned</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta aceptar antes de que IAM asigne la cuenta.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CaregiverAccountNotAssigned()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RelativeNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe el familiar indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RelativeNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DniAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el DNI ya está registrado entre los clientes.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DniAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailAddressAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el email ya está registrado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmailAddressAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el negocio indicado no existe en Company.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssistedPersonNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe la persona asistida indicada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssistedPersonNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssistedPersonNotManagedByRelative</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la persona asistida no pertenece al familiar que opera.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssistedPersonNotManagedByRelative()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CaregiverNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe el cuidador o no cuida a esa persona.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CaregiverNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CaregiverAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando ese usuario ya es cuidador <code>ACTIVE</code> de esa persona.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CaregiverAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CaregiverNotActive</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el cuidador fue revocado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CaregiverNotActive()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CaregiverAlreadyRevoked</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta revocar un acceso ya revocado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CaregiverAlreadyRevoked()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CareActivityNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe la actividad indicada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CareActivityNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CareActivityNotActive</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la actividad está <code>INACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CareActivityNotActive()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActivityAssignmentNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la asignación no existe dentro de la actividad.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActivityAssignmentNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActivityAssignmentNotActive</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la asignación está <code>INACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActivityAssignmentNotActive()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidSchedule</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el horario no tiene la forma correcta o un <code>ONE_TIME</code> está en el pasado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidSchedule()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ScheduleConflict</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el horario choca con otra asignación <code>ACTIVE</code> del mismo cuidador.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ScheduleConflict()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ScheduleNotEditable</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta editar un <code>ONE_TIME</code> que ya tiene log.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ScheduleNotEditable()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>OccurrenceNotScheduled</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la asignación no tiene ocurrencia en esa fecha.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>OccurrenceNotScheduled()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>OccurrenceNotStarted</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta completar antes del inicio del horario.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>OccurrenceNotStarted()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>OccurrenceClosed</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la ocurrencia ya tiene log (completada, cancelada o perdida).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>OccurrenceClosed()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>OccurrenceEnded</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta completar o cancelar una ocurrencia que ya terminó.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>OccurrenceEnded()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>NotResponsibleForActivity</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando quien completa no es el responsable de la asignación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>NotResponsibleForActivity()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DayNotClosedYet</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta marcar como perdida una ocurrencia cuyo día aún no terminó.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DayNotClosedYet()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

#### Reglas generales del bounded context

**Contextos externos (fuera de este diagrama).**

**IAM** (ACL): el usuario es email + password. Al crear un `Relative` crea su cuenta personal con su password y devuelve el `userId`. Al invitar a un cuidador: si `inviteeEmail` ya tiene cuenta, devuelve su `userId` sin crear otra; si no, crea la cuenta y devuelve `userId` + url para cambiar la contraseña (`RegisterInvitedCaregiverCommand` de IAM). Cuando la contraseña se define, IAM registra `PasswordDefinedEvent` y se ejecuta `AcceptInvitationCommand`.

**Communication** (eventos, después del commit): `InvitationAccountCreatedEvent`: el correo con la url (`SendEmailCommand`, plantilla `CAREGIVER_INVITATION`). `InvitationNotificationRequestedEvent`: el aviso en la app y push (`CreateNotificationCommand`, `CAREGIVER_INVITATION`).

**Profiles** (ACL): dueño del `PersonProfile` de `Relative` y `AssistedPerson`. Al crear un `Relative` o una `AssistedPerson`, valida que el dni y el email no estén registrados entre los clientes y crea el `PersonProfile` (en la `AssistedPerson` el email es opcional). Al actualizarlos, recibe `UpdatePersonProfileCommand` (sin dni ni email).

**Company** (ACL): dueño del `Business`. Al crear un `Relative` valida que el negocio exista con su `businessId`.

**Contextos que leen Assistance** (ACL, solo lectura): Subscriptions y Support validan que la persona asistida exista y la gestione el familiar (`GetAssistedPersonByIdQuery`, `isManagedBy`). Communication obtiene el familiar, la agenda y los cuidadores de turno (`GetAssistedPersonByIdQuery`, `GetAgendaByAssistedPersonIdQuery`, `GetCaregiversByAssistedPersonIdQuery`).

`UserId` identifica al usuario de IAM (`Relative`, `Caregiver` e `Invitation` lo guardan). `PersonProfileId` identifica el `PersonProfile` de Profiles (`Relative` y `AssistedPerson` lo guardan). `BusinessId` identifica el `Business` de Company (`Relative` lo guarda).

**Retorno de los CommandService.** handle devuelve `Long`: el id del aggregate afectado (id del `ActivityLog` en `ActivityLogCommandService`; id de la `CareActivity` en las operaciones sobre sus asignaciones). void cuando no hay aggregate que devolver: `ReassignCaregiverActivitiesCommand` y `MarkMissedActivitiesCommand`. `Optional` solo en los QueryService.

Id inexistente: los commands lanzan la excepción NotFound del aggregate (`RelativeNotFound`, `AssistedPersonNotFound`, `InvitationNotFound`, `CaregiverNotFound`, `CareActivityNotFound`, `ActivityAssignmentNotFound`); las queries devuelven `Optional` vacío o lista vacía.

**Shared (importado).** **Herencia:** `Invitation`, `Relative`, `AssistedPerson`, `Caregiver`, `CareActivity` y `ActivityLog` extienden `AuditableAbstractAggregateRoot` (id, `createdAt`, `updatedAt`, `addDomainEvent()`). `ActivityAssignment` extiende `AuditableModel` (id, `createdAt`, `updatedAt`).

**Value Objects usados:** `UserId`, `PersonProfileId`, `BusinessId`, `EmailAddress`, `TimeRange` (start, end; overlaps, contains, `crossesMidnight`), `WeeklyPeriod` (days, range; `occursOn`, `overlapsWith`).

**Configuración global:** Zona horaria (`Clock`, America/Lima): se configura una vez en Shared. El dominio no consulta el reloj: recibe now / today como parámetro, calculados con esa zona horaria.

### 5.5.2. Interface Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.5.1.

### 5.5.3. Application Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.5.1.

### 5.5.4. Infrastructure Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.5.1.

### 5.5.6. Bounded Context Software Architecture Component Level Diagrams

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.5.1.

### 5.5.7. Bounded Context Software Architecture Code Level Diagrams

#### 5.5.7.1. Bounded Context Domain Layer Class Diagrams

El diagrama muestra los seis aggregates, la entidad `ActivityAssignment`, los value objects y enums con sus relaciones nombradas y su multiplicidad. Las referencias directas entre aggregates del mismo contexto se dibujan en morado; la composición `CareActivity` → `ActivityAssignments` → `ActivityAssignment`, en magenta. Las flechas naranjas indican el aggregate que crea o modifica cada command, y las verde azuladas, el flujo de eventos internos: el aggregate registra el evento y el evento activa el siguiente command (por ejemplo, la invitación: crear, asignar cuenta, avisar, aceptar y crear el cuidador). Los atributos de los commands con más datos se muestran en una nota enlazada a su clase; otras notas detallan las reglas de cada service y los contextos externos.

![Diagrama de clases de la capa de dominio - Asistencia Médica](../images/diagrams/img/chapter-5/assistance.svg)

#### 5.5.7.2. Bounded Context Database Design Diagram

La base de datos es PostgreSQL.

| Tabla o colección | Aggregate, entidad o value object | Llaves y restricciones |
|---|---|---|
| `relatives` | `Relative` | PK `id`. UK `user_id`, `person_profile_id`. Referencia a IAM sin FK: `user_id`. Referencia a Profiles sin FK: `person_profile_id`. Referencia a Company sin FK: `business_id`. |
| `assisted_persons` | `AssistedPerson` | PK `id`. UK `person_profile_id`. FK `relative_id`. Referencia a Profiles sin FK: `person_profile_id`. |
| `invitations` | `Invitation` | PK `id`. FK `assisted_person_id`, `inviter_relative_id`. Referencia a IAM sin FK: `caregiver_user_id`. <<UK parcial>> (`assisted_person_id`, `invitee_email`) WHERE status = '`PENDING`'. |
| `caregivers` | `Caregiver` | PK `id`. FK `assisted_person_id`. Referencia a IAM sin FK: `user_id`. <<UK parcial>> (`user_id`, `assisted_person_id`) WHERE status = '`ACTIVE`'. |
| `care_activities` | `CareActivity` | PK `id`. FK `assisted_person_id`. |
| `activity_assignments` | `ActivityAssignment` (con `Schedule` embebido) | PK `id`. FK `care_activity_id`, `caregiver_id`. |
| `activity_logs` | `ActivityLog` | PK `id`. FK `assisted_person_id`, `care_activity_id`, `assignment_id`, `assigned_caregiver_id`, `completed_by_caregiver_id`. <<UK>> (`assignment_id`, `occurrence_date`). |

Relaciones entre tablas: `relatives` a `assisted_persons` (gestiona); `relatives` a `invitations` (invita); `assisted_persons` a `invitations` (para); `assisted_persons` a `caregivers` (cuidada por); `assisted_persons` a `care_activities` (tiene); `care_activities` a `activity_assignments` (se asigna en); `caregivers` a `activity_assignments` (realiza (null = familiar)); `activity_assignments` a `activity_logs` (registra); `care_activities` a `activity_logs` (); `assisted_persons` a `activity_logs` (); `caregivers` a `activity_logs` (asignado / completó).

**relatives** (aggregate `Relative`). El familiar responsable: se registra solo en un `Business` y paga la suscripción. `user_id`: su cuenta personal de IAM. `person_profile_id`: su `PersonProfile` de cliente. Ambos únicos (el dni es único entre los clientes). Si también es empleado, tiene aparte un `StaffProfile` y una cuenta corporativa. `business_id`: el `Business` de Company (`BusinessId`). Sin FK; con índice para `GetRelativesByBusinessIdQuery`.



**`assisted_persons`** (aggregate `AssistedPerson`). Pertenece a un solo familiar y no se da de baja: no tiene columna de estado ni borrado.



**invitations** (aggregate `Invitation`) status: `PENDING`, `ACCEPTED` o `REVOKED`. "Vencida" se calcula con `expires_at`; no se guarda. `caregiver_user_id`: null hasta que IAM asigna la cuenta (nueva o existente). Índice único parcial: una sola invitación `PENDING` por persona y email; respalda `InvitationAlreadyExists`. Índice (`caregiver_user_id`, status) para `GetPendingInvitationsByCaregiverUserIdQuery`. La url para definir contraseña no se guarda: viaja solo en el evento y la gestiona IAM.



**caregivers** (aggregate `Caregiver`) status: `ACTIVE` o `REVOKED`. Al revocar no se borra: el historial sigue apuntando a él. Índice único parcial: un solo cuidador `ACTIVE` por usuario y persona; las filas `REVOKED` pueden repetirse. Respalda `CaregiverAlreadyExists`. Índice (`user_id`, status) para `GetCaregiversByUserIdQuery`.



**`activity_assignments`** (entidad `ActivityAssignment`). Vive dentro de `CareActivity`; no se borra, se desactiva. `caregiver_id` null: la hace el familiar. `Schedule` aplanado: `ONE_TIME`: `schedule_date`, sin `schedule_week_days`. `WEEKLY`: `schedule_week_days` (MONDAY,TUESDAY,...), sin `schedule_date`. `schedule_start_time` / `schedule_end_time`: el rango de cualquiera de las dos formas. Si end es anterior a start, cruza medianoche (22:00-06:00).



**`activity_logs`** (aggregate `ActivityLog`). Historial de cada ocurrencia: `COMPLETED`, `CANCELLED` o `MISSED`. Un solo log por asignación y fecha: índice único (`assignment_id`, `occurrence_date`), que respalda `OccurrenceClosed` y hace idempotente `MarkMissedActivitiesCommand`. `occurrence_date`: fecha en que empieza la ocurrencia. title, `start_time`, `end_time` y `assigned_caregiver_id` son una copia de lo vigente ese día. `completed_by_caregiver_id` y `completed_at` solo en `COMPLETED`; null en `completed_by` = lo hizo el familiar. Índices (`assisted_person_id`, `occurrence_date`) y (`assigned_caregiver_id`, `occurrence_date`) para el historial del familiar y del cuidador.

**Por qué en PostgreSQL y no en MongoDB** Completar o cancelar lee la actividad, la asignación y el cuidador y escribe el log en una sola transacción. `OccurrenceClosed`, `ScheduleNotEditable`, `MISSED` y la agenda cruzan logs con asignaciones. Es un registro de negocio con relaciones, no tracking. Si se necesita un historial para análisis, se copia a MongoDB por eventos, sin ser la fuente de verdad.


![Diagrama de base de datos - Asistencia Médica](../images/diagrams/img/chapter-5/assistance-database.svg)

<div style="page-break-after: always;"></div>

## 5.6. Bounded Context: Pagos y Suscripciones

En el código, este bounded context es el paquete `subscriptions`. Subscriptions gestiona los planes, la suscripción mensual de cada persona asistida y los cobros que hace Stripe. El familiar llega desde la landing page, elige un plan y los actuadores, se registra (Assistance e IAM), registra a su persona asistida y se suscribe. Stripe cobra cada mes y avisa por webhook: cada factura pagada o fallida es un `Payment`, y su resultado activa la suscripción o la deja `PAST_DUE`. Si la primera evaluación del hogar no cumple o el familiar no agenda otra cita a tiempo, Subscriptions devuelve el pago y cancela la suscripción; cuando la suscripción se cancela por cualquier motivo, Support apaga el servicio. Todo se cobra en soles (PEN). El contexto se basa en el módulo de pagos de veyra-backend, con las mejoras que se describen en las notas del diagrama.

### 5.6.1. Domain Layer

Este bounded context no declara Entities propios.

#### Aggregates

<table>
<tr><th colspan="4" align="left"><code>Plan</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Un plan de suscripción del catálogo, con sus precios en soles y sus dos <code>Price</code> de Stripe. <code>MINIMUM</code>: 1 actuador del tipo que elija el familiar. <code>CUSTOM</code>: de 1 a 4 actuadores, la cantidad que quiera de cada tipo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>code</code></td><td><code>PlanCode</code></td><td>private</td><td><code>MINIMUM</code> o <code>CUSTOM</code>.</td></tr>
<tr><td><code>basePrice</code></td><td><code>Money</code></td><td>private</td><td>Precio mensual de lo que toda instalación lleva (los dos edges y el micrófono), sin actuadores.</td></tr>
<tr><td><code>pricePerActuator</code></td><td><code>Money</code></td><td>private</td><td>Precio mensual de cada actuador, también el primero; así ninguno se cobra dos veces.</td></tr>
<tr><td><code>minActuators</code></td><td><code>Integer</code></td><td>private</td><td>Mínimo de actuadores del plan.</td></tr>
<tr><td><code>maxActuators</code></td><td><code>Integer</code></td><td>private</td><td>Máximo de actuadores del plan.</td></tr>
<tr><td><code>stripeBasePriceId</code></td><td><code>String</code></td><td>private</td><td><code>Price</code> de Stripe del precio base.</td></tr>
<tr><td><code>stripeActuatorPriceId</code></td><td><code>String</code></td><td>private</td><td><code>Price</code> de Stripe del precio por actuador.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Plan(PlanCode code, Money basePrice, Money pricePerActuator, Integer minActuators, Integer maxActuators, String stripeBasePriceId, String stripeActuatorPriceId)</code></td><td>(constructor)</td><td>public</td><td>Crea el plan. Los precios están en soles (PEN), 1 &lt;= <code>minActuators</code> &lt;= <code>maxActuators</code> y los dos <code>Price</code> id de Stripe no están vacíos (<code>InvalidPlan</code>).</td></tr>
<tr><td><code>allows(ActuatorSelection selection)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si <code>selection.total()</code> está entre <code>minActuators</code> y <code>maxActuators</code>.</td></tr>
<tr><td><code>monthlyPriceFor(ActuatorSelection selection)</code></td><td><code>Money</code></td><td>public</td><td>Precio mensual: <code>basePrice.plus(pricePerActuator.times(selection.total()))</code>. Es lo que cobra Stripe cada mes: un item base con cantidad 1 y un item por actuador con cantidad <code>total()</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Los precios deben coincidir con los de la landing page; cambian volviendo a cargar el catálogo (<code>SeedPlansCommand</code>).</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>basePrice / pricePerActuator</code>)</td><td><code>Money</code></td><td>1 a 2</td><td></td></tr>
<tr><td>Asociación dirigida (<code>code</code>)</td><td><code>PlanCode</code></td><td>0..* a 1</td><td><code>MINIMUM</code> o <code>CUSTOM</code>.</td></tr>
<tr><td>Dependencia "allows / <code>monthlyPriceFor</code>"</td><td><code>ActuatorSelection</code></td><td>No aplica</td><td></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Subscription</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">La suscripción mensual de una persona asistida, que paga su familiar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>UserId</code></td><td>private</td><td>Cuenta del familiar que paga (IAM).</td></tr>
<tr><td><code>assistedPersonId</code></td><td><code>AssistedPersonId</code></td><td>private</td><td>Persona asistida cubierta (Assistance).</td></tr>
<tr><td><code>businessId</code></td><td><code>BusinessId</code></td><td>private</td><td>Negocio del familiar (Company); Analytics separa las métricas por negocio.</td></tr>
<tr><td><code>plan</code></td><td><code>Plan</code></td><td>private</td><td><code>Plan</code> elegido.</td></tr>
<tr><td><code>actuators</code></td><td><code>ActuatorSelection</code></td><td>private</td><td>Actuadores que eligió el familiar; Support los copia en la instalación.</td></tr>
<tr><td><code>monthlyAmount</code></td><td><code>Money</code></td><td>private</td><td>Precio mensual calculado al suscribirse. Es una copia: no cambia si luego cambia el plan.</td></tr>
<tr><td><code>status</code></td><td><code>SubscriptionStatus</code></td><td>private</td><td><code>PENDING_PAYMENT</code>, <code>ACTIVE</code>, <code>PAST_DUE</code> o <code>CANCELED</code>.</td></tr>
<tr><td><code>stripeCustomerId</code></td><td><code>String</code></td><td>private</td><td>Customer de Stripe del familiar. Nulo solo mientras se crea.</td></tr>
<tr><td><code>stripeSubscriptionId</code></td><td><code>String</code></td><td>private</td><td>Suscripción de Stripe; con él se encuentra la suscripción al llegar un webhook. Nulo solo mientras se crea.</td></tr>
<tr><td><code>currentPeriod</code></td><td><code>BillingPeriod</code></td><td>private</td><td>Último periodo pagado. Nulo hasta el primer pago.</td></tr>
<tr><td><code>refunded</code></td><td><code>boolean</code></td><td>private</td><td>Verdadero si ya se devolvió el pago; evita devolver dos veces.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Subscription(UserId userId, AssistedPersonId assistedPersonId, BusinessId businessId, Plan plan, ActuatorSelection actuators)</code></td><td>(constructor)</td><td>public</td><td>Crea la suscripción <code>PENDING_PAYMENT</code>, sin periodo ni ids de Stripe. El plan permite la selección (<code>InvalidActuatorSelection</code>) y <code>monthlyAmount</code> = <code>plan.monthlyPriceFor(actuators)</code>.</td></tr>
<tr><td><code>linkStripe(String stripeCustomerId, String stripeSubscriptionId)</code></td><td><code>void</code></td><td>public</td><td>Guarda los ids de Stripe. Solo en <code>PENDING_PAYMENT</code> y sin ids previos (<code>InvalidSubscriptionStatusTransition</code>).</td></tr>
<tr><td><code>activate(BillingPeriod period)</code></td><td><code>void</code></td><td>public</td><td>De <code>PENDING_PAYMENT</code> o <code>PAST_DUE</code> a <code>ACTIVE</code>, o renueva una <code>ACTIVE</code>; guarda el periodo pagado. La primera vez registra <code>SubscriptionActivatedEvent</code>.</td></tr>
<tr><td><code>markPastDue()</code></td><td><code>void</code></td><td>public</td><td>De <code>ACTIVE</code> o <code>PENDING_PAYMENT</code> a <code>PAST_DUE</code>: un cobro falló.</td></tr>
<tr><td><code>cancel()</code></td><td><code>void</code></td><td>public</td><td>De cualquier estado salvo <code>CANCELED</code> a <code>CANCELED</code> (Stripe la eliminó); registra <code>SubscriptionCanceledEvent</code>. Si ya está <code>CANCELED</code>, no hace nada.</td></tr>
<tr><td><code>refund()</code></td><td><code>void</code></td><td>public</td><td>De <code>ACTIVE</code> a <code>CANCELED</code> con <code>refunded</code> verdadero; registra <code>SubscriptionRefundedEvent</code> y <code>SubscriptionCanceledEvent</code>. Si ya está <code>CANCELED</code> sin devolver (el webhook de cancelación llegó primero), solo marca <code>refunded</code> y registra <code>SubscriptionRefundedEvent</code>. Si ya se devolvió, no hace nada. En otro estado, <code>InvalidSubscriptionStatusTransition</code>.</td></tr>
<tr><td><code>isActive()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si está <code>ACTIVE</code>. La consulta Support.</td></tr>
<tr><td><code>isCurrent()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si está <code>PENDING_PAYMENT</code>, <code>ACTIVE</code> o <code>PAST_DUE</code>. La usa <code>CreateSubscriptionCommand</code> (<code>SubscriptionAlreadyExists</code>).</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Una persona asistida tiene a lo sumo una suscripción vigente. Una suscripción <code>PAST_DUE</code> sigue contando como actual: Stripe reintenta el cobro según su configuración y, si ninguno funciona, la cancela.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>plan</code>)</td><td><code>Plan</code></td><td>0..* a 1</td><td><code>Plan</code> elegido.</td></tr>
<tr><td>Composición (<code>actuators</code>)</td><td><code>ActuatorSelection</code></td><td>1 a 1</td><td>Actuadores que eligió el familiar; Support los copia en la instalación.</td></tr>
<tr><td>Composición (<code>monthlyAmount</code>)</td><td><code>Money</code></td><td>1 a 1</td><td>Precio mensual calculado al suscribirse.</td></tr>
<tr><td>Composición (<code>currentPeriod</code>)</td><td><code>BillingPeriod</code></td><td>1 a 0..1</td><td>Último periodo pagado.</td></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>SubscriptionStatus</code></td><td>0..* a 1</td><td><code>PENDING_PAYMENT</code>, <code>ACTIVE</code>, <code>PAST_DUE</code> o <code>CANCELED</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Payment</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Un cobro mensual de Stripe (una factura pagada o fallida). Lo crea el webhook de Stripe (<code>invoice.paid</code> o <code>invoice.payment_failed</code>) y no se modifica después, salvo para marcarlo devuelto.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>subscription</code></td><td><code>Subscription</code></td><td>private</td><td>Suscripción cobrada.</td></tr>
<tr><td><code>stripeInvoiceId</code></td><td><code>String</code></td><td>private</td><td>Factura de Stripe. Única: un webhook repetido no crea otro pago.</td></tr>
<tr><td><code>stripePaymentIntentId</code></td><td><code>String</code></td><td>private</td><td>Intento de pago de Stripe de la factura.</td></tr>
<tr><td><code>amount</code></td><td><code>Money</code></td><td>private</td><td>Monto cobrado.</td></tr>
<tr><td><code>status</code></td><td><code>PaymentStatus</code></td><td>private</td><td><code>SUCCEEDED</code>, <code>FAILED</code> o <code>REFUNDED</code>.</td></tr>
<tr><td><code>period</code></td><td><code>BillingPeriod</code></td><td>private</td><td>Periodo mensual que cubre el cobro.</td></tr>
<tr><td><code>receiptUrl</code></td><td><code>String</code></td><td>private</td><td>Url del recibo de Stripe (solo <code>SUCCEEDED</code>).</td></tr>
<tr><td><code>failureMessage</code></td><td><code>String</code></td><td>private</td><td>Motivo del fallo que informa Stripe (solo <code>FAILED</code>).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Payment(Subscription subscription, String stripeInvoiceId, String stripePaymentIntentId, Money amount, BillingPeriod period, PaymentResult result)</code></td><td>(constructor)</td><td>public</td><td>Crea el pago. El monto es igual a <code>subscription.monthlyAmount</code> (<code>PaymentAmountMismatch</code>). Con resultado <code>SUCCEEDED</code> guarda <code>receiptUrl</code> y registra <code>PaymentSucceededEvent</code>; con <code>FAILED</code> guarda <code>failureMessage</code> y registra <code>PaymentFailedEvent</code>.</td></tr>
<tr><td><code>markRefunded()</code></td><td><code>void</code></td><td>public</td><td>Marca el pago <code>REFUNDED</code>. Solo un pago <code>SUCCEEDED</code> (<code>PaymentNotRefundable</code>).</td></tr>
<tr><td><code>isSucceeded()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si está <code>SUCCEEDED</code>.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>subscription</code>)</td><td><code>Subscription</code></td><td>0..* a 1</td><td>Suscripción cobrada.</td></tr>
<tr><td>Composición (<code>amount</code>)</td><td><code>Money</code></td><td>1 a 1</td><td>Monto cobrado.</td></tr>
<tr><td>Composición (<code>period</code>)</td><td><code>BillingPeriod</code></td><td>1 a 1</td><td>Periodo mensual que cubre el cobro.</td></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>PaymentStatus</code></td><td>0..* a 1</td><td><code>SUCCEEDED</code>, <code>FAILED</code> o <code>REFUNDED</code>.</td></tr>
<tr><td>Dependencia "se crea con"</td><td><code>PaymentResult</code></td><td>No aplica</td><td></td></tr>
</table>

#### Value Objects

**Value objects de Shared que usa este contexto.** **`UserId`**: cuenta del familiar que paga (IAM). **`AssistedPersonId`**: persona asistida cubierta (Assistance). **`BusinessId`**: negocio del familiar (Company); lo usa Analytics para separar las métricas por negocio. Subscriptions solo guarda ids: nunca accede a esos contextos directamente. **Stripe** (fuera de Alivia): customer, subscription, invoice y Price. Sus ids se guardan como texto.

<table>
<tr><th colspan="4" align="left"><code>Money</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Un monto en soles.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>amount</code></td><td><code>BigDecimal</code></td><td>private final</td><td>Monto, mayor o igual a 0, con dos decimales.</td></tr>
<tr><td><code>currency</code></td><td><code>String</code></td><td>private final</td><td>Moneda. Siempre <code>PEN</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Money(BigDecimal amount, String currency)</code></td><td>(constructor)</td><td>public</td><td>Valida el monto y que la moneda sea <code>PEN</code> (<code>InvalidMoney</code>).</td></tr>
<tr><td><code>plus(Money other)</code></td><td><code>Money</code></td><td>public</td><td>Suma dos montos.</td></tr>
<tr><td><code>times(Integer quantity)</code></td><td><code>Money</code></td><td>public</td><td>Multiplica el monto por una cantidad.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Todo se cobra en soles y los <code>Price</code> de Stripe también están en PEN. <code>plus</code> y <code>times</code> los usa <code>Plan.monthlyPriceFor</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BillingPeriod</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Periodo mensual que cubre un cobro. Lo informa Stripe en la factura.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>start</code></td><td><code>LocalDateTime</code></td><td>private final</td><td>Inicio del periodo.</td></tr>
<tr><td><code>end</code></td><td><code>LocalDateTime</code></td><td>private final</td><td>Fin del periodo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BillingPeriod(LocalDateTime start, LocalDateTime end)</code></td><td>(constructor)</td><td>public</td><td>Valida que <code>start</code> sea anterior a <code>end</code> (<code>InvalidBillingPeriod</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PaymentResult</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Resultado de una factura de Stripe: pagada o fallida.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>status</code></td><td><code>PaymentStatus</code></td><td>private final</td><td><code>SUCCEEDED</code> o <code>FAILED</code>.</td></tr>
<tr><td><code>receiptUrl</code></td><td><code>String</code></td><td>private final</td><td>Url del recibo (solo <code>SUCCEEDED</code>).</td></tr>
<tr><td><code>failureMessage</code></td><td><code>String</code></td><td>private final</td><td>Motivo del fallo (solo <code>FAILED</code>).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PaymentResult(PaymentStatus status, String receiptUrl, String failureMessage)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico; solo lo usan las dos fábricas.</td></tr>
<tr><td><code>succeeded(String receiptUrl)</code></td><td><code>PaymentResult</code></td><td>public static</td><td>Resultado <code>SUCCEEDED</code> con la url del recibo.</td></tr>
<tr><td><code>failed(String failureMessage)</code></td><td><code>PaymentResult</code></td><td>public static</td><td>Resultado <code>FAILED</code> con el motivo.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>PaymentStatus</code></td><td>0..* a 1</td><td><code>SUCCEEDED</code> o <code>FAILED</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActuatorSelection</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Actuadores que eligió el familiar al suscribirse: cuántos de cada tipo (ej. 2 <code>DOOR</code>, 1 <code>LIGHT</code>). Support copia esta selección en la instalación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>items</code></td><td><code>List&lt;ActuatorQuantity&gt;</code></td><td>private final</td><td>Cantidad elegida de cada tipo. Cada tipo aparece una vez.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActuatorSelection(List&lt;ActuatorQuantity&gt; items)</code></td><td>(constructor)</td><td>public</td><td>Valida que cada tipo aparezca una vez y que cada cantidad sea mayor que 0 (<code>InvalidActuatorSelection</code>).</td></tr>
<tr><td><code>total()</code></td><td><code>Integer</code></td><td>public</td><td>Suma de las cantidades.</td></tr>
<tr><td><code>quantityOf(ActuatorType type)</code></td><td><code>Integer</code></td><td>public</td><td>Cantidad elegida de un tipo (0 si ninguno).</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>items</code>)</td><td><code>ActuatorQuantity</code></td><td>1 a 1..4</td><td>Cantidad elegida de cada tipo.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActuatorQuantity</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cantidad elegida de un tipo de actuador.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>type</code></td><td><code>ActuatorType</code></td><td>private final</td><td>Tipo de actuador.</td></tr>
<tr><td><code>quantity</code></td><td><code>Integer</code></td><td>private final</td><td>Cantidad, mayor que 0.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActuatorQuantity(ActuatorType type, Integer quantity)</code></td><td>(constructor)</td><td>public</td><td>Crea la cantidad de un tipo.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>type</code>)</td><td><code>ActuatorType</code></td><td>0..* a 1</td><td>Tipo de actuador.</td></tr>
</table>

#### Enumerations

<table>
<tr><th colspan="4" align="left"><code>PlanCode</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Código de un plan del catálogo.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>MINIMUM</code>, <code>CUSTOM</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActuatorType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tipos de actuador que el familiar puede elegir.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>DOOR</code>, <code>WINDOW</code>, <code>CURTAIN</code>, <code>LIGHT</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SubscriptionStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de la suscripción. <code>CANCELED</code> es final.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>PENDING_PAYMENT</code>, <code>ACTIVE</code>, <code>PAST_DUE</code>, <code>CANCELED</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PaymentStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de un pago.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>SUCCEEDED</code>, <code>FAILED</code>, <code>REFUNDED</code></td></tr>
</table>

#### Domain Events

`PaymentSucceededEvent` y `PaymentFailedEvent` se registran en el constructor de `Payment`, cuando aún no hay id: guardan el `Payment` y leen su id al publicarse.

**Dentro de Subscriptions.** `PaymentSucceededEvent`: activa `ActivateSubscriptionCommand` (primer pago o renovación). `PaymentFailedEvent`: activa `MarkSubscriptionPastDueCommand`.

**Hacia otros contextos.** `SubscriptionActivatedEvent`: Communication envía el correo de bienvenida al familiar (solo la primera activación). `PaymentFailedEvent`: Communication avisa al familiar que el cobro falló. `SubscriptionRefundedEvent`: Communication avisa al familiar de la devolución. `SubscriptionActivatedEvent`: Analytics cuenta un nuevo suscripto. `SubscriptionCanceledEvent`: Analytics cuenta una suscripción cancelada (una sola vez, también si fue por devolución); Support apaga el servicio de la instalación (`EndInstallationServiceCommand`; si aún no tenía equipos, la cancela y anula la cita activa; si ya estaba rechazada o cancelada, no hace nada). `PaymentSucceededEvent` y `SubscriptionRefundedEvent`: Analytics suma lo cobrado y lo devuelto.

<table>
<tr><th colspan="4" align="left"><code>PaymentSucceededEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que Stripe cobró una factura de la suscripción.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>payment</code></td><td><code>Payment</code></td><td>private</td><td>Pago que originó el evento; su id se lee al publicarse.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PaymentSucceededEvent(Payment payment)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con el aggregate que lo registra.</td></tr>
<tr><td><code>getPaymentId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>paymentId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getSubscriptionId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>subscriptionId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getBusinessId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>businessId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getAmount()</code></td><td><code>BigDecimal</code></td><td>public</td><td>Devuelve <code>amount</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getPeriodStart()</code></td><td><code>LocalDateTime</code></td><td>public</td><td>Devuelve <code>periodStart</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getPeriodEnd()</code></td><td><code>LocalDateTime</code></td><td>public</td><td>Devuelve <code>periodEnd</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Payment.constructor</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>ActivateSubscriptionCommand</code> (primer pago o renovación), síncrono. Después del commit, Analytics suma lo cobrado.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Se registra en el constructor de <code>Payment</code>, cuando aún no hay id: guarda el <code>Payment</code> y lee su id al publicarse.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PaymentFailedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que falló el cobro de una factura de la suscripción.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>payment</code></td><td><code>Payment</code></td><td>private</td><td>Pago que originó el evento; su id se lee al publicarse.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PaymentFailedEvent(Payment payment)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con el aggregate que lo registra.</td></tr>
<tr><td><code>getPaymentId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>paymentId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getSubscriptionId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>subscriptionId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getUserId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>userId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getFailureMessage()</code></td><td><code>String</code></td><td>public</td><td>Devuelve <code>failureMessage</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Payment.constructor</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>MarkSubscriptionPastDueCommand</code>, síncrono. Después del commit, Communication avisa al familiar que el cobro falló.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Se registra en el constructor de <code>Payment</code>, cuando aún no hay id.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SubscriptionActivatedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que la suscripción se activó con su primer pago.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>subscriptionId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la suscripción.</td></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta del familiar que paga.</td></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la persona asistida (Assistance).</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio (Company).</td></tr>
<tr><td><code>plan</code></td><td><code>PlanCode</code></td><td>private final</td><td><code>Plan</code> de la suscripción.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SubscriptionActivatedEvent(Long subscriptionId, Long userId, Long assistedPersonId, Long businessId, PlanCode plan)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Subscription.activate</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Communication envía el correo de bienvenida al familiar y Analytics cuenta un nuevo suscriptor. Después del commit.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SubscriptionRefundedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que se devolvió el pago de la suscripción.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>subscriptionId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la suscripción.</td></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta del familiar.</td></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la persona asistida (Assistance).</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio (Company).</td></tr>
<tr><td><code>amount</code></td><td><code>BigDecimal</code></td><td>private final</td><td>Monto devuelto.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SubscriptionRefundedEvent(Long subscriptionId, Long userId, Long assistedPersonId, Long businessId, BigDecimal amount)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Subscription.refund</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Communication avisa al familiar de la devolución y Analytics suma lo devuelto. Después del commit.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SubscriptionCanceledEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que la suscripción se canceló (baja del familiar, cobro no pagado a tiempo o devolución).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>subscriptionId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la suscripción.</td></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la persona asistida (Assistance).</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio (Company).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SubscriptionCanceledEvent(Long subscriptionId, Long assistedPersonId, Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Subscription.cancel</code>, <code>Subscription.refund</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Support apaga el servicio de la instalación (<code>EndInstallationServiceCommand</code>), síncrono: si aún no tenía equipos, la cancela y anula la cita activa; si ya estaba rechazada o cancelada, no hace nada. Después del commit, Analytics cuenta una suscripción cancelada (una sola vez, también si fue por devolución).</td></tr>
</table>

#### Commands

<table>
<tr><th colspan="4" align="left"><code>SeedPlansCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Carga los planes <code>MINIMUM</code> y <code>CUSTOM</code> desde la configuración (precios y <code>Price</code> id de Stripe) si no existen. Se ejecuta al iniciar la aplicación; no se expone en la API.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SeedPlansCommand()</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>PlanCommandService</code>, que devuelve <code>void</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateSubscriptionCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar se suscribe desde el checkout para una persona asistida, con el plan y los actuadores que eligió.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta del familiar (sale de la sesión).</td></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la persona asistida (Assistance).</td></tr>
<tr><td><code>planCode</code></td><td><code>String</code></td><td>private final</td><td>Código del plan elegido.</td></tr>
<tr><td><code>actuators</code></td><td><code>Map&lt;String, Integer&gt;</code></td><td>private final</td><td>Actuadores elegidos: tipo y cantidad. Pasa a <code>ActuatorSelection</code>.</td></tr>
<tr><td><code>paymentMethodId</code></td><td><code>String</code></td><td>private final</td><td>Método de pago de Stripe que registró el checkout.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateSubscriptionCommand(Long userId, Long assistedPersonId, String planCode, Map&lt;String, Integer&gt; actuators, String paymentMethodId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>SubscriptionCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lo envía el familiar desde el checkout, con sesión iniciada: su cuenta ya está <code>ACTIVE</code> porque verificó su correo con el código (IAM; sin eso no puede iniciar sesión). El plan existe (<code>PlanNotFound</code>). La persona asistida existe en Assistance (ACL, <code>GetAssistedPersonByIdQuery</code>; <code>AssistedPersonNotFound</code>) y la gestiona ese familiar (<code>NotRelativeOfAssistedPerson</code>); <code>businessId</code> sale del familiar en Assistance. No tiene otra suscripción vigente: <code>PENDING_PAYMENT</code>, <code>ACTIVE</code> o <code>PAST_DUE</code> (<code>SubscriptionAlreadyExists</code>). actuators pasa a <code>ActuatorSelection</code>. En una transacción: crea y guarda la <code>Subscription</code> en <code>PENDING_PAYMENT</code>; crea u obtiene el customer de Stripe del familiar y crea la suscripción de Stripe con los dos Price del plan, <code>paymentMethodId</code>, el id local como metadata e idempotency key; llama a <code>linkStripe</code>. Si Stripe falla, <code>PaymentGatewayError</code> y se revierte todo. Si el commit falla, cancela la suscripción en Stripe.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RecordPaymentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Registra una factura de Stripe, pagada o fallida. Lo envía infrastructure al recibir el webhook, después de verificar la firma.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>stripeInvoiceId</code></td><td><code>String</code></td><td>private final</td><td>Factura de Stripe.</td></tr>
<tr><td><code>stripeSubscriptionId</code></td><td><code>String</code></td><td>private final</td><td>Suscripción de Stripe de la factura.</td></tr>
<tr><td><code>stripePaymentIntentId</code></td><td><code>String</code></td><td>private final</td><td>Intento de pago de Stripe.</td></tr>
<tr><td><code>amount</code></td><td><code>BigDecimal</code></td><td>private final</td><td>Monto de la factura.</td></tr>
<tr><td><code>currency</code></td><td><code>String</code></td><td>private final</td><td>Moneda de la factura.</td></tr>
<tr><td><code>periodStart</code></td><td><code>LocalDateTime</code></td><td>private final</td><td>Inicio del periodo que cubre.</td></tr>
<tr><td><code>periodEnd</code></td><td><code>LocalDateTime</code></td><td>private final</td><td>Fin del periodo que cubre.</td></tr>
<tr><td><code>succeeded</code></td><td><code>boolean</code></td><td>private final</td><td>Verdadero si es <code>invoice.paid</code>; falso si es <code>invoice.payment_failed</code>.</td></tr>
<tr><td><code>receiptUrl</code></td><td><code>String</code></td><td>private final</td><td>Url del recibo (solo si se pagó).</td></tr>
<tr><td><code>failureMessage</code></td><td><code>String</code></td><td>private final</td><td>Motivo del fallo (solo si falló).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RecordPaymentCommand(String stripeInvoiceId, String stripeSubscriptionId, String stripePaymentIntentId, BigDecimal amount, String currency, LocalDateTime periodStart, LocalDateTime periodEnd, boolean succeeded, String receiptUrl, String failureMessage)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>PaymentCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lo envía infrastructure al recibir el webhook de Stripe invoice.paid (succeeded = true) o invoice.payment_failed (succeeded = false), después de verificar la firma. Si ya existe un pago con ese <code>stripeInvoiceId</code> (<code>ExistsPaymentByStripeInvoiceIdQuery</code>), devuelve su id sin crear otro: Stripe puede reenviar el mismo webhook. La suscripción se busca por <code>stripeSubscriptionId</code> (<code>GetSubscriptionByStripeSubscriptionIdQuery</code>; <code>SubscriptionNotFound</code>). Si no existe todavía (el webhook llegó antes del commit de la creación), infrastructure responde error para que Stripe lo reenvíe.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActivateSubscriptionCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Activa o renueva la suscripción con el periodo pagado. Lo activa <code>PaymentSucceededEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>subscriptionId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la suscripción.</td></tr>
<tr><td><code>periodStart</code></td><td><code>LocalDateTime</code></td><td>private final</td><td>Inicio del periodo pagado.</td></tr>
<tr><td><code>periodEnd</code></td><td><code>LocalDateTime</code></td><td>private final</td><td>Fin del periodo pagado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActivateSubscriptionCommand(Long subscriptionId, LocalDateTime periodStart, LocalDateTime periodEnd)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>SubscriptionCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Solo los activan los eventos de <code>Payment</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>MarkSubscriptionPastDueCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Deja la suscripción <code>PAST_DUE</code>. Lo activa <code>PaymentFailedEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>subscriptionId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la suscripción.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>MarkSubscriptionPastDueCommand(Long subscriptionId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>SubscriptionCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Solo los activan los eventos de <code>Payment</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RefundSubscriptionCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Devuelve el pago y cancela la suscripción de una persona asistida cuya instalación no se hizo. Lo activan <code>InstallationRejectedEvent</code> e <code>InstallationCanceledEvent</code> de Support.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la persona asistida (Assistance).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RefundSubscriptionCommand(Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>SubscriptionCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lo activan <code>InstallationRejectedEvent</code> (la primera evaluación no cumple) e <code>InstallationCanceledEvent</code> (no se agendó otra cita en 7 días hábiles) de Support, después del commit. Busca la suscripción más reciente de la persona asistida, <code>ACTIVE</code> o <code>CANCELED</code> sin devolver (<code>SubscriptionNotFound</code>); si ya se devolvió, no hace nada. Pide a Stripe la devolución del último pago <code>SUCCEEDED</code>, con el id del pago como idempotency key, y cancelar la suscripción (<code>PaymentGatewayError</code>); marca ese pago <code>REFUNDED</code> y llama a refund. Si Stripe falla, el handler lo reintenta (3 veces, con espera creciente).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CancelSubscriptionCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cancela la suscripción que Stripe eliminó. Lo activa el webhook <code>customer.subscription.deleted</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>stripeSubscriptionId</code></td><td><code>String</code></td><td>private final</td><td>Suscripción de Stripe eliminada.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CancelSubscriptionCommand(String stripeSubscriptionId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>SubscriptionCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lo activa el webhook customer.subscription.deleted de Stripe: el familiar se dio de baja, o la suscripción estaba <code>PAST_DUE</code> y Stripe agotó los reintentos de cobro. La suscripción existe (<code>SubscriptionNotFound</code>). Si ya está <code>CANCELED</code> (la canceló <code>RefundSubscriptionCommand</code>, o Stripe reenvió el webhook), devuelve su id sin cambiarla.</td></tr>
</table>

#### Queries

<table>
<tr><th colspan="4" align="left"><code>GetAllPlansQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Todos los planes. La usa el checkout para mostrar el precio según los actuadores elegidos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllPlansQuery()</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Plan&gt;</code> (<code>PlanQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetPlanByCodeQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3"><code>Plan</code> por código.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>code</code></td><td><code>PlanCode</code></td><td>private final</td><td>Código del plan.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetPlanByCodeQuery(PlanCode code)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Plan&gt;</code> (<code>PlanQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetSubscriptionByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Suscripción por id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>subscriptionId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la suscripción.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetSubscriptionByIdQuery(Long subscriptionId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Subscription&gt;</code> (<code>SubscriptionQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetActiveSubscriptionByAssistedPersonIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Suscripción <code>ACTIVE</code> de una persona asistida. La usa Support al registrar la instalación (copia el plan y los actuadores).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la persona asistida (Assistance).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetActiveSubscriptionByAssistedPersonIdQuery(Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Subscription&gt;</code> (<code>SubscriptionQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllSubscriptionsByUserIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Suscripciones que paga un familiar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta del familiar.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllSubscriptionsByUserIdQuery(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Subscription&gt;</code> (<code>SubscriptionQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllSubscriptionsByBusinessIdAndStatusQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Suscripciones de un negocio en un estado. La usa Analytics.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio (Company).</td></tr>
<tr><td><code>status</code></td><td><code>SubscriptionStatus</code></td><td>private final</td><td>Estado de las suscripciones.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllSubscriptionsByBusinessIdAndStatusQuery(Long businessId, SubscriptionStatus status)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Subscription&gt;</code> (<code>SubscriptionQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetSubscriptionByStripeSubscriptionIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Suscripción por su id de Stripe. La usa el webhook.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>stripeSubscriptionId</code></td><td><code>String</code></td><td>private final</td><td>Suscripción de Stripe.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetSubscriptionByStripeSubscriptionIdQuery(String stripeSubscriptionId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Subscription&gt;</code> (<code>SubscriptionQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllPaymentsBySubscriptionIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Pagos de una suscripción.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>subscriptionId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la suscripción.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllPaymentsBySubscriptionIdQuery(Long subscriptionId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Payment&gt;</code> (<code>PaymentQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ExistsPaymentByStripeInvoiceIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica si ya se registró una factura de Stripe; evita duplicar un webhook repetido.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>stripeInvoiceId</code></td><td><code>String</code></td><td>private final</td><td>Factura de Stripe.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ExistsPaymentByStripeInvoiceIdQuery(String stripeInvoiceId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>boolean</code> (<code>PaymentQueryService</code>)</td></tr>
</table>

#### Domain Services

<table>
<tr><th colspan="4" align="left"><code>PlanCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Plan</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(SeedPlansCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>SeedPlansCommand</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PlanQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Plan</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetAllPlansQuery query)</code></td><td><code>List&lt;Plan&gt;</code></td><td>public</td><td>Resuelve <code>GetAllPlansQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetPlanByCodeQuery query)</code></td><td><code>Optional&lt;Plan&gt;</code></td><td>public</td><td>Resuelve <code>GetPlanByCodeQuery</code>; devuelve vacío si no existe.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SubscriptionCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Subscription</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateSubscriptionCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateSubscriptionCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(ActivateSubscriptionCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ActivateSubscriptionCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(MarkSubscriptionPastDueCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>MarkSubscriptionPastDueCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(RefundSubscriptionCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>RefundSubscriptionCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(CancelSubscriptionCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CancelSubscriptionCommand</code> y devuelve el id de la suscripción (sin cambiarla si ya estaba <code>CANCELED</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SubscriptionQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Subscription</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetSubscriptionByIdQuery query)</code></td><td><code>Optional&lt;Subscription&gt;</code></td><td>public</td><td>Resuelve <code>GetSubscriptionByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetActiveSubscriptionByAssistedPersonIdQuery query)</code></td><td><code>Optional&lt;Subscription&gt;</code></td><td>public</td><td>Resuelve <code>GetActiveSubscriptionByAssistedPersonIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetAllSubscriptionsByUserIdQuery query)</code></td><td><code>List&lt;Subscription&gt;</code></td><td>public</td><td>Resuelve <code>GetAllSubscriptionsByUserIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetAllSubscriptionsByBusinessIdAndStatusQuery query)</code></td><td><code>List&lt;Subscription&gt;</code></td><td>public</td><td>Resuelve <code>GetAllSubscriptionsByBusinessIdAndStatusQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetSubscriptionByStripeSubscriptionIdQuery query)</code></td><td><code>Optional&lt;Subscription&gt;</code></td><td>public</td><td>Resuelve <code>GetSubscriptionByStripeSubscriptionIdQuery</code>; devuelve vacío si no existe.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PaymentCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Payment</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(RecordPaymentCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>RecordPaymentCommand</code> y devuelve el id del <code>Payment</code> (el existente si la factura ya se registró).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PaymentQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Payment</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetAllPaymentsBySubscriptionIdQuery query)</code></td><td><code>List&lt;Payment&gt;</code></td><td>public</td><td>Resuelve <code>GetAllPaymentsBySubscriptionIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(ExistsPaymentByStripeInvoiceIdQuery query)</code></td><td><code>boolean</code></td><td>public</td><td>Resuelve <code>ExistsPaymentByStripeInvoiceIdQuery</code>.</td></tr>
</table>

#### Exceptions

<table>
<tr><th colspan="4" align="left"><code>InvalidPlan</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando un plan del catálogo tiene precios, límites de actuadores o <code>Price</code> id inválidos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidPlan(PlanCode code)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PlanNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe el plan indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PlanNotFound(String planCode)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidMoney</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el monto es negativo, no tiene dos decimales o la moneda no es <code>PEN</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidMoney()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidBillingPeriod</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el inicio del periodo no es anterior a su fin.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidBillingPeriod()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidActuatorSelection</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la selección repite un tipo, tiene una cantidad no positiva o no cabe en el plan.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidActuatorSelection()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssistedPersonNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la persona asistida no existe en Assistance.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssistedPersonNotFound(Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>NotRelativeOfAssistedPerson</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la persona asistida no la gestiona el familiar que se suscribe.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>NotRelativeOfAssistedPerson(Long userId, Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SubscriptionAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la persona asistida ya tiene una suscripción vigente (<code>PENDING_PAYMENT</code>, <code>ACTIVE</code> o <code>PAST_DUE</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SubscriptionAlreadyExists(Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SubscriptionNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no se encuentra la suscripción (por id, por id de Stripe o, al devolver, una <code>ACTIVE</code> o <code>CANCELED</code> sin devolver).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SubscriptionNotFound(String reference)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidSubscriptionStatusTransition</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el cambio de estado de la suscripción no está permitido.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidSubscriptionStatusTransition(SubscriptionStatus from, SubscriptionStatus to)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PaymentAmountMismatch</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el monto de la factura no es el <code>monthlyAmount</code> de la suscripción. Infrastructure responde 200 a Stripe y deja la factura en el log de pagos a revisar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PaymentAmountMismatch(String stripeInvoiceId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PaymentNotRefundable</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta devolver un pago que no está <code>SUCCEEDED</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PaymentNotRefundable(Long paymentId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PaymentGatewayError</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando falla una llamada a Stripe (crear la suscripción o devolver el pago).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PaymentGatewayError(String message)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

### 5.6.2. Interface Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.6.1.

### 5.6.3. Application Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.6.1.

### 5.6.4. Infrastructure Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.6.1.

### 5.6.6. Bounded Context Software Architecture Component Level Diagrams

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.6.1.

### 5.6.7. Bounded Context Software Architecture Code Level Diagrams

#### 5.6.7.1. Bounded Context Domain Layer Class Diagrams

El diagrama muestra los aggregates `Plan`, `Subscription` y `Payment`, con sus referencias directas dentro del contexto (`Subscription` a `Plan` y `Payment` a `Subscription`). `Plan` y `Subscription` usan los value objects `Money`, `ActuatorSelection` y `BillingPeriod`; `Payment` se crea con un `PaymentResult`. Los aggregates registran cinco eventos: los de `Payment` activan, dentro del contexto, la activación o el atraso de la suscripción; los de `Subscription` los consumen Communication, Analytics y Support. Las notas detallan las reglas de cada service y el orden de las llamadas a Stripe.

![Diagrama de clases de la capa de dominio - Pagos y Suscripciones](../images/diagrams/img/chapter-5/subscriptions-backend-diagram.svg)

#### 5.6.7.2. Bounded Context Database Design Diagram

La base de datos es PostgreSQL.

| Tabla o colección | Aggregate, entidad o value object | Llaves y restricciones |
|---|---|---|
| `plans` | `Plan` | PK `id`. UK `code`. CHECK 1 <= `min_actuators` <= `max_actuators`. |
| `subscriptions` | `Subscription` (con `Money` y `BillingPeriod` embebidos) | PK `id`. UK `stripe_subscription_id`. FK `plan_id`. Referencia a IAM sin FK: `user_id`. Referencia a Assistance sin FK: `assisted_person_id`. Referencia a Company sin FK: `business_id`. UK parcial (`assisted_person_id`) WHERE status <> '`CANCELED`'. CHECK: `current_period_start` y `current_period_end` nulos los dos (sin primer pago) o no nulos los dos. |
| `subscription_actuators` | `ActuatorSelection` de `Subscription` | FK `subscription_id`. PK (`subscription_id`, `actuator_type`). CHECK quantity > 0. |
| `payments` | `Payment` | PK `id`. UK `stripe_invoice_id`. FK `subscription_id`. |

Relaciones entre tablas: `plans` a `subscriptions` (plan (0..*)); `subscriptions` a `subscription_actuators` (actuadores elegidos (1..4)); `subscriptions` a `payments` (cobros mensuales (0..*)).

**PostgreSQL**.

Todos los montos están en soles: currency siempre es 'PEN' (CHECK). plans: catálogo cargado al iniciar (`SeedPlansCommand`). Precio mensual = `base_price_amount` (dos edges y micrófono, sin actuadores) + `price_per_actuator_amount` x actuadores (también el primero). Los dos Price id son los de Stripe. subscriptions: una vigente por persona asistida (UK parcial). `monthly_amount` es la copia del precio al suscribirse. `stripe_subscription_id` es único: con él se encuentra la suscripción al llegar un webhook. Los dos ids de Stripe son nulos solo mientras se crea (se guarda antes de llamar a Stripe). refunded: la suscripción ya se devolvió; evita devolver dos veces. payments: un registro por factura de Stripe; `stripe_invoice_id` es único, así un webhook repetido no crea otro pago.

`user_id`, `assisted_person_id` y `business_id` son ids de IAM, Assistance y Company, sin FK. IDX (`business_id`): suscripciones de un negocio por estado. Las FK van de subscriptions a plans y de `subscription_actuators` y payments a subscriptions: no hay referencias circulares.


![Diagrama de base de datos - Pagos y Suscripciones](../images/diagrams/img/chapter-5/subscriptions-database-diagram.svg)

<div style="page-break-after: always;"></div>

## 5.7. Bounded Context: Soporte Técnico

En el código, este bounded context es el paquete `support`. Support gestiona la instalación de Alivia en el hogar de cada persona asistida y su soporte técnico. Después de suscribirse y pagar, el familiar registra la instalación con la dirección del hogar y agenda una cita con un día y un rango de horas en que está libre. El administrador asigna un técnico a la cita; en la visita, el técnico evalúa si el hogar es viable e instala los dos edges, el micrófono y los actuadores que se puedan (todos, algunos o ninguno). Una instalación parcial se completa con otra cita cuando el hogar se adecúa. Si un equipo falla, el familiar crea un ticket y el administrador asigna una visita de reparación. Cuando la suscripción se cancela, se apaga todo y un técnico recoge los equipos. Ningún aggregate modifica a otro: los cambios entre ellos pasan por eventos que activan commands, y la cadena interna es síncrona, en la misma transacción.

### 5.7.1. Domain Layer

Este bounded context no declara Entities propios.

#### Aggregates

<table>
<tr><th colspan="4" align="left"><code>Installation</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">La instalación de Alivia en el hogar de una persona asistida: su dirección, lo que eligió el familiar y los equipos instalados.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>AssistedPersonId</code></td><td>private</td><td>Persona asistida dueña de la instalación (Assistance).</td></tr>
<tr><td><code>requestedBy</code></td><td><code>UserId</code></td><td>private</td><td>Cuenta del familiar que la registró; solo él agenda citas y crea tickets.</td></tr>
<tr><td><code>businessId</code></td><td><code>BusinessId</code></td><td>private</td><td>Negocio dueño de los equipos (Company).</td></tr>
<tr><td><code>address</code></td><td><code>Address</code></td><td>private</td><td>Dirección del hogar. Inmutable: no tiene método para cambiarse.</td></tr>
<tr><td><code>plan</code></td><td><code>PlanCode</code></td><td>private</td><td>Copia del plan que pagó el familiar en Subscriptions.</td></tr>
<tr><td><code>requestedActuators</code></td><td><code>ActuatorSelection</code></td><td>private</td><td>Copia de los actuadores que eligió el familiar al suscribirse.</td></tr>
<tr><td><code>status</code></td><td><code>InstallationStatus</code></td><td>private</td><td>Estado de la instalación.</td></tr>
<tr><td><code>equipment</code></td><td><code>InstalledEquipment</code></td><td>private</td><td>Equipos instalados. Nulo hasta la primera instalación.</td></tr>
<tr><td><code>schedulingDeadline</code></td><td><code>LocalDate</code></td><td>private</td><td>Último día para agendar otra cita después de que venció la primera (7 días hábiles); nulo si no aplica.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Installation(AssistedPersonId assistedPersonId, UserId requestedBy, BusinessId businessId, Address address, PlanCode plan, ActuatorSelection requestedActuators)</code></td><td>(constructor)</td><td>public</td><td>Crea la instalación <code>PENDING_EVALUATION</code>, sin equipos. <code>plan</code> y <code>requestedActuators</code> son la copia de la suscripción <code>ACTIVE</code> (Subscriptions ya validó que caben en el plan).</td></tr>
<tr><td><code>install(EvaluationResult result, InstalledEquipment equipment)</code></td><td><code>void</code></td><td>public</td><td>Primera visita, solo en <code>PENDING_EVALUATION</code> y sin equipos: guarda el <code>InstalledEquipment</code>. Ningún tipo supera lo elegido (<code>ExceedsRequestedActuators</code>); <code>MEETS</code> si se instalaron todos los elegidos y <code>PARTIALLY_MEETS</code> si faltan (<code>EvaluationResultMismatch</code>). Pasa a <code>INSTALLED</code> o <code>PARTIALLY_INSTALLED</code> y registra <code>EquipmentInstalledEvent</code>.</td></tr>
<tr><td><code>addActuators(EvaluationResult result, List&lt;InstalledActuator&gt; actuators)</code></td><td><code>void</code></td><td>public</td><td>Re-evaluación, solo en <code>PENDING_EVALUATION</code>: suma los actuadores nuevos con las mismas reglas, contando los ya instalados. Registra <code>ActuatorsAddedEvent</code>.</td></tr>
<tr><td><code>markRequirementsNotMet()</code></td><td><code>void</code></td><td>public</td><td>Solo en <code>PENDING_EVALUATION</code>. Sin equipos pasa a <code>REJECTED</code> (final) y registra <code>InstallationRejectedEvent</code>, que devuelve el pago; con equipos vuelve a <code>PARTIALLY_INSTALLED</code>.</td></tr>
<tr><td><code>requestReevaluation()</code></td><td><code>void</code></td><td>public</td><td>De <code>PARTIALLY_INSTALLED</code> a <code>PENDING_EVALUATION</code>: el familiar agendó otra cita.</td></tr>
<tr><td><code>replaceEquipment(List&lt;EquipmentReplacement&gt; replacements)</code></td><td><code>void</code></td><td>public</td><td>Cambia equipos malogrados. La instalación tiene equipos (<code>InstallationWithoutEquipment</code>) y está en servicio, también durante una re-evaluación; el viejo está instalado (<code>EquipmentNotInstalled</code>) y el nuevo no (<code>EquipmentAlreadyInstalled</code>). Registra <code>EquipmentReplacedEvent</code>.</td></tr>
<tr><td><code>awaitNewAppointment(LocalDate expiredOn)</code></td><td><code>void</code></td><td>public</td><td>Venció la primera cita (<code>PENDING_EVALUATION</code> sin equipos): fija <code>schedulingDeadline</code> en <code>expiredOn</code> + 7 días hábiles (lunes a viernes, sin descontar feriados).</td></tr>
<tr><td><code>cancelReevaluation()</code></td><td><code>void</code></td><td>public</td><td>Venció una cita de re-evaluación: de <code>PENDING_EVALUATION</code> con equipos a <code>PARTIALLY_INSTALLED</code>, sin evento; el hogar sigue con su servicio.</td></tr>
<tr><td><code>cancelForMissingAppointment(LocalDate today)</code></td><td><code>void</code></td><td>public</td><td><code>PENDING_EVALUATION</code> sin equipos y con <code>schedulingDeadline</code> anterior a <code>today</code>: pasa a <code>CANCELED</code> (final) y registra <code>InstallationCanceledEvent</code>, que devuelve el pago.</td></tr>
<tr><td><code>endService()</code></td><td><code>void</code></td><td>public</td><td>Terminó la suscripción. Con equipos (<code>INSTALLED</code>, <code>PARTIALLY_INSTALLED</code> o <code>PENDING_EVALUATION</code>) pasa a <code>REMOVAL_PENDING</code>; sin equipos, a <code>CANCELED</code>, sin devolución. En ambos casos registra <code>InstallationServiceEndedEvent</code>. <code>REJECTED</code>, <code>CANCELED</code>, <code>REMOVAL_PENDING</code> y <code>REMOVED</code> no cambian.</td></tr>
<tr><td><code>completeRemoval()</code></td><td><code>void</code></td><td>public</td><td>De <code>REMOVAL_PENDING</code> a <code>REMOVED</code> (final): se recogieron los equipos. Registra <code>EquipmentRemovedEvent</code>.</td></tr>
<tr><td><code>isPendingEvaluation()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si está <code>PENDING_EVALUATION</code>. La usa <code>Appointment</code>.</td></tr>
<tr><td><code>isInService()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si está <code>PENDING_EVALUATION</code>, <code>INSTALLED</code> o <code>PARTIALLY_INSTALLED</code>. La usa <code>Ticket</code>.</td></tr>
<tr><td><code>isPendingRemoval()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si está <code>REMOVAL_PENDING</code>. La usa <code>RemovalAssignment</code>.</td></tr>
<tr><td><code>isPartiallyInstalled()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si está <code>PARTIALLY_INSTALLED</code>. La usa <code>Appointment</code>.</td></tr>
<tr><td><code>hasEquipment()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si ya tiene equipos instalados. La usa <code>Ticket</code>.</td></tr>
<tr><td><code>hasAddress(Address address)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la dirección es la misma. La usa <code>Appointment</code>.</td></tr>
<tr><td><code>isRequestedBy(UserId userId)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la registró ese familiar. La usan <code>Appointment</code> y <code>Ticket</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Las transiciones no permitidas lanzan <code>InvalidInstallationStatusTransition</code>. Los equipos instalados nunca superan lo elegido por el familiar. Una instalación <code>REJECTED</code>, <code>CANCELED</code> o <code>REMOVED</code> no impide registrar otra para la misma persona.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>requestedActuators</code>)</td><td><code>ActuatorSelection</code></td><td>1 a 1</td><td>Copia de los actuadores que eligió el familiar al suscribirse.</td></tr>
<tr><td>Composición (<code>equipment</code>)</td><td><code>InstalledEquipment</code></td><td>1 a 0..1</td><td>Equipos instalados.</td></tr>
<tr><td>Asociación dirigida (<code>plan</code>)</td><td><code>PlanCode</code></td><td>0..* a 1</td><td>Copia del plan que pagó el familiar en Subscriptions.</td></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>InstallationStatus</code></td><td>0..* a 1</td><td>Estado de la instalación.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Appointment</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">La cita que agenda el familiar para que un técnico evalúe el hogar e instale los equipos: un día y un rango de horas en que está libre (ej. lunes de 13:00 a 17:00).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installation</code></td><td><code>Installation</code></td><td>private</td><td>Instalación a evaluar.</td></tr>
<tr><td><code>requestedBy</code></td><td><code>UserId</code></td><td>private</td><td>Cuenta del familiar que la agendó.</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private</td><td>Día de la cita. No anterior a hoy.</td></tr>
<tr><td><code>availability</code></td><td><code>TimeRange</code></td><td>private</td><td>Rango de horas en que el familiar está libre ese día. No cruza medianoche.</td></tr>
<tr><td><code>reevaluation</code></td><td><code>boolean</code></td><td>private</td><td>Verdadero si la instalación ya tenía equipos (<code>PARTIALLY_INSTALLED</code>): solo se agregan los actuadores que faltan.</td></tr>
<tr><td><code>status</code></td><td><code>AppointmentStatus</code></td><td>private</td><td>Estado de la cita.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Appointment(Installation installation, UserId requestedBy, LocalDate date, TimeRange availability, Address confirmedAddress, LocalDate today)</code></td><td>(constructor)</td><td>public</td><td>Crea la cita <code>REQUESTED</code>. Solo el familiar que registró la instalación (<code>InstallationNotRequestedByUser</code>); la dirección escrita es la de la instalación (<code>AddressMismatch</code>; solo se compara, no se guarda); <code>date</code> no es anterior a hoy (<code>InvalidAppointmentDate</code>) y <code>availability</code> no cruza medianoche. La instalación está <code>PENDING_EVALUATION</code> (primera evaluación) o <code>PARTIALLY_INSTALLED</code> (re-evaluación); si no, <code>InstallationNotSchedulable</code>. Registra <code>AppointmentRequestedEvent</code>.</td></tr>
<tr><td><code>markScheduled()</code></td><td><code>void</code></td><td>public</td><td>De <code>REQUESTED</code> a <code>SCHEDULED</code>: se le asignó un técnico.</td></tr>
<tr><td><code>complete()</code></td><td><code>void</code></td><td>public</td><td>De <code>SCHEDULED</code> a <code>COMPLETED</code>: la visita se atendió.</td></tr>
<tr><td><code>expire(LocalDate today)</code></td><td><code>void</code></td><td>public</td><td>De <code>REQUESTED</code> o <code>SCHEDULED</code> con fecha anterior a <code>today</code> a <code>EXPIRED</code>. Registra <code>AppointmentExpiredEvent</code>.</td></tr>
<tr><td><code>cancel()</code></td><td><code>void</code></td><td>public</td><td>De <code>REQUESTED</code> o <code>SCHEDULED</code> a <code>CANCELED</code>: terminó el servicio. Registra <code>AppointmentCanceledEvent</code>.</td></tr>
<tr><td><code>isRequested()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si está <code>REQUESTED</code>. La usa <code>InstallationAssignment</code> al crearse.</td></tr>
<tr><td><code>isActive()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si está <code>REQUESTED</code> o <code>SCHEDULED</code>.</td></tr>
<tr><td><code>allows(TimeRange timeRange)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si las horas de la visita están dentro de <code>availability</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Las transiciones no permitidas lanzan <code>InvalidAppointmentStatusTransition</code>.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>installation</code>)</td><td><code>Installation</code></td><td>0..* a 1</td><td>Instalación a evaluar.</td></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>AppointmentStatus</code></td><td>0..* a 1</td><td>Estado de la cita.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Assignment</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Clase abstracta base de aggregates (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Base abstracta de las visitas de un técnico. No es un aggregate propio: no tiene repositorio. Es lo que el técnico ve en su lista de asignaciones.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>technicianId</code></td><td><code>EmployeeId</code></td><td>private</td><td>Técnico asignado (HCM).</td></tr>
<tr><td><code>scheduledDate</code></td><td><code>LocalDate</code></td><td>private</td><td>Fecha de la visita.</td></tr>
<tr><td><code>timeRange</code></td><td><code>TimeRange</code></td><td>private</td><td>Horas de la visita.</td></tr>
<tr><td><code>status</code></td><td><code>AssignmentStatus</code></td><td>private</td><td><code>ASSIGNED</code>, <code>ATTENDED</code> o <code>CANCELED</code>.</td></tr>
<tr><td><code>photos</code></td><td><code>List&lt;Photo&gt;</code></td><td>private</td><td>Fotos que sube el técnico al atenderla.</td></tr>
<tr><td><code>attendedAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Cuándo se atendió.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Assignment(EmployeeId technicianId, LocalDate scheduledDate, TimeRange timeRange, LocalDate today)</code></td><td>(constructor)</td><td>protected</td><td>Crea la visita <code>ASSIGNED</code>; <code>scheduledDate</code> no es anterior a hoy (<code>InvalidAssignmentDate</code>). Lo usan las subclases.</td></tr>
<tr><td><code>isAssignedTo(EmployeeId technicianId)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el técnico es el asignado; el que atiende debe serlo (<code>AssignmentNotForTechnician</code>).</td></tr>
<tr><td><code>overlapsWith(LocalDate date, TimeRange timeRange)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si es la misma fecha y las horas se cruzan.</td></tr>
<tr><td><code>reassign(EmployeeId technicianId, LocalDate scheduledDate, TimeRange timeRange, LocalDate today)</code></td><td><code>void</code></td><td>public</td><td>Solo <code>ASSIGNED</code> (<code>AssignmentAlreadyAttended</code>): cambia técnico, fecha y horas con las mismas reglas. Registra <code>AssignmentReassignedEvent</code>.</td></tr>
<tr><td><code>cancel()</code></td><td><code>void</code></td><td>public</td><td>De <code>ASSIGNED</code> a <code>CANCELED</code> (<code>AssignmentAlreadyAttended</code>): su cita venció o se canceló, o se cerró su ticket. Sin evento.</td></tr>
<tr><td><code>markAttended(List&lt;Photo&gt; photos, LocalDateTime now)</code></td><td><code>void</code></td><td>protected</td><td>Solo <code>ASSIGNED</code> (<code>AssignmentAlreadyAttended</code>), con al menos una foto (<code>PhotosRequired</code>): pasa a <code>ATTENDED</code> y guarda <code>attendedAt</code>. Lo usan las subclases.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>AssignmentStatus</code></td><td>0..* a 1</td><td><code>ASSIGNED</code>, <code>ATTENDED</code> o <code>CANCELED</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationAssignment</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>Assignment</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">La visita de una cita: el técnico evalúa si el hogar es viable y cuántos de los actuadores elegidos se pueden instalar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>appointment</code></td><td><code>Appointment</code></td><td>private</td><td>Cita que la originó.</td></tr>
<tr><td><code>reevaluation</code></td><td><code>boolean</code></td><td>private</td><td>Copia de la cita: verdadero si es una re-evaluación.</td></tr>
<tr><td><code>result</code></td><td><code>EvaluationResult</code></td><td>private</td><td>Resultado de la evaluación. Nulo hasta atenderla.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallationAssignment(Appointment appointment, EmployeeId technicianId, TimeRange timeRange, LocalDate today)</code></td><td>(constructor)</td><td>public</td><td>La cita está <code>REQUESTED</code> (<code>AppointmentNotRequested</code>); la fecha es el día de la cita y <code>timeRange</code> está dentro de su <code>availability</code> (<code>OutsideAppointmentAvailability</code>). Registra <code>InstallationAssignmentCreatedEvent</code>.</td></tr>
<tr><td><code>attendInstallation(EvaluationResult result, InstalledEquipment installed, List&lt;Photo&gt; photos, LocalDateTime now)</code></td><td><code>void</code></td><td>public</td><td>Primera visita (<code>EvaluationTypeMismatch</code>), con <code>MEETS</code> o <code>PARTIALLY_MEETS</code> (<code>InvalidEvaluationResult</code>). Registra <code>InstallationAssignmentAttendedEvent</code> con los equipos.</td></tr>
<tr><td><code>attendReevaluation(EvaluationResult result, List&lt;InstalledActuator&gt; actuators, List&lt;Photo&gt; photos, LocalDateTime now)</code></td><td><code>void</code></td><td>public</td><td>Re-evaluación (<code>EvaluationTypeMismatch</code>), con <code>MEETS</code> o <code>PARTIALLY_MEETS</code> (<code>InvalidEvaluationResult</code>) y al menos un actuador (<code>EquipmentRequired</code>). Registra <code>ReevaluationAssignmentAttendedEvent</code>.</td></tr>
<tr><td><code>attendRequirementsNotMet(List&lt;Photo&gt; photos, LocalDateTime now)</code></td><td><code>void</code></td><td>public</td><td>Cualquier visita de cita, con resultado <code>DOES_NOT_MEET</code> y sin equipos; las fotos muestran el hogar. Registra <code>RequirementsNotMetEvent</code>.</td></tr>
<tr><td><code>reassign(EmployeeId technicianId, LocalDate scheduledDate, TimeRange timeRange, LocalDate today)</code></td><td><code>void</code></td><td>public</td><td>Además de las reglas de <code>Assignment</code>, el día es el de la cita y las horas están dentro de su <code>availability</code> (<code>OutsideAppointmentAvailability</code>).</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Guarda solo el resultado y las fotos: los equipos viajan en el evento y los guarda <code>Installation</code>.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>appointment</code>)</td><td><code>Appointment</code></td><td>0..1 a 1</td><td>Cita que la originó.</td></tr>
<tr><td>Asociación dirigida (<code>result</code>)</td><td><code>EvaluationResult</code></td><td>0..* a 0..1</td><td>Resultado de la evaluación.</td></tr>
<tr><td>Herencia</td><td><code>Assignment</code></td><td>No aplica</td><td>Extiende la base abstracta <code>Assignment</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RepairAssignment</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>Assignment</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">La visita para atender un ticket: el técnico repara o cambia los equipos que fallan.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ticket</code></td><td><code>Ticket</code></td><td>private</td><td><code>Ticket</code> que atiende.</td></tr>
<tr><td><code>failureReason</code></td><td><code>String</code></td><td>private</td><td>Motivo de la falla que encontró el técnico.</td></tr>
<tr><td><code>replacements</code></td><td><code>List&lt;EquipmentReplacement&gt;</code></td><td>private</td><td>Equipos que cambió; vacía si solo reparó.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RepairAssignment(Ticket ticket, EmployeeId technicianId, LocalDate scheduledDate, TimeRange timeRange, LocalDate today)</code></td><td>(constructor)</td><td>public</td><td>El ticket está <code>OPEN</code> (<code>TicketNotOpen</code>). Registra <code>RepairAssignmentCreatedEvent</code>.</td></tr>
<tr><td><code>attend(String failureReason, List&lt;EquipmentReplacement&gt; replacements, List&lt;Photo&gt; photos, LocalDateTime now)</code></td><td><code>void</code></td><td>public</td><td>Motivo de la falla no vacío (<code>FailureReasonRequired</code>) y fotos de la reparación. Registra <code>RepairAssignmentAttendedEvent</code> con los cambios.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La fecha puede ser cualquier día de la semana.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>ticket</code>)</td><td><code>Ticket</code></td><td>0..1 a 1</td><td><code>Ticket</code> que atiende.</td></tr>
<tr><td>Composición (<code>replacements</code>)</td><td><code>EquipmentReplacement</code></td><td>1 a 0..*</td><td>Equipos que cambió; vacía si solo reparó.</td></tr>
<tr><td>Herencia</td><td><code>Assignment</code></td><td>No aplica</td><td>Extiende la base abstracta <code>Assignment</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RemovalAssignment</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>Assignment</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">La visita para recoger todos los equipos después de cancelarse la suscripción.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installation</code></td><td><code>Installation</code></td><td>private</td><td>Instalación a retirar.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RemovalAssignment(Installation installation, EmployeeId technicianId, LocalDate scheduledDate, TimeRange timeRange, LocalDate today)</code></td><td>(constructor)</td><td>public</td><td>La instalación está <code>REMOVAL_PENDING</code> (<code>InstallationNotPendingRemoval</code>). Registra <code>RemovalAssignmentCreatedEvent</code>.</td></tr>
<tr><td><code>attend(List&lt;Photo&gt; photos, LocalDateTime now)</code></td><td><code>void</code></td><td>public</td><td>Fotos de los equipos recogidos. Registra <code>RemovalAssignmentAttendedEvent</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Si una visita de retiro se cancela, el administrador puede asignar otra.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>installation</code>)</td><td><code>Installation</code></td><td>0..1 a 1</td><td>Instalación a retirar.</td></tr>
<tr><td>Herencia</td><td><code>Assignment</code></td><td>No aplica</td><td>Extiende la base abstracta <code>Assignment</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Ticket</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El reporte del familiar de que un equipo del hogar está fallando, solo con una descripción.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installation</code></td><td><code>Installation</code></td><td>private</td><td>Instalación con la falla.</td></tr>
<tr><td><code>createdBy</code></td><td><code>UserId</code></td><td>private</td><td>Cuenta del familiar que lo creó.</td></tr>
<tr><td><code>description</code></td><td><code>String</code></td><td>private</td><td>Descripción de la falla.</td></tr>
<tr><td><code>status</code></td><td><code>TicketStatus</code></td><td>private</td><td><code>OPEN</code>, <code>ASSIGNED</code>, <code>RESOLVED</code> o <code>CLOSED</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Ticket(Installation installation, UserId createdBy, String description)</code></td><td>(constructor)</td><td>public</td><td>Crea el ticket <code>OPEN</code>. La descripción no está vacía (<code>TicketDescriptionRequired</code>); solo el familiar que registró la instalación (<code>InstallationNotRequestedByUser</code>); la instalación tiene equipos (<code>InstallationWithoutEquipment</code>) y está en servicio (<code>InstallationOutOfService</code>).</td></tr>
<tr><td><code>markAssigned()</code></td><td><code>void</code></td><td>public</td><td>De <code>OPEN</code> a <code>ASSIGNED</code> (<code>TicketNotOpen</code>): se le asignó una visita.</td></tr>
<tr><td><code>resolve()</code></td><td><code>void</code></td><td>public</td><td>De <code>ASSIGNED</code> a <code>RESOLVED</code> (<code>InvalidTicketStatusTransition</code>): se atendió la visita.</td></tr>
<tr><td><code>close()</code></td><td><code>void</code></td><td>public</td><td>De <code>OPEN</code> o <code>ASSIGNED</code> a <code>CLOSED</code>: terminó el servicio. Registra <code>TicketClosedEvent</code>.</td></tr>
<tr><td><code>isOpen()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si está <code>OPEN</code>. La usa <code>RepairAssignment</code> al crearse.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>installation</code>)</td><td><code>Installation</code></td><td>0..* a 1</td><td>Instalación con la falla.</td></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>TicketStatus</code></td><td>0..* a 1</td><td><code>OPEN</code>, <code>ASSIGNED</code>, <code>RESOLVED</code> o <code>CLOSED</code>.</td></tr>
</table>

#### Value Objects

**Value objects de Shared que usa este contexto.** **`AssistedPersonId`**: persona asistida de Assistance dueña de la instalación. **`UserId`**: cuenta del familiar que registra la instalación, agenda las citas y crea los tickets. **`BusinessId`**: negocio (Alivia) dueño de los equipos. **`EmployeeId`**: técnico de HCM. **`EdgeId`, `DeviceId`**: equipos de Assets instalados. **`Address`**: dirección del hogar (inmutable). **`TimeRange`**: disponibilidad de la cita y horas de la visita. **`Photo`**: fotos de la instalación, la reparación y el retiro. Support solo guarda ids: nunca accede a esos contextos directamente.

<table>
<tr><th colspan="4" align="left"><code>ActuatorSelection</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Copia de los actuadores que eligió el familiar al suscribirse (Subscriptions): cuántos de cada tipo (ej. 2 <code>DOOR</code>, 1 <code>CURTAIN</code>, 1 <code>LIGHT</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>items</code></td><td><code>List&lt;ActuatorQuantity&gt;</code></td><td>private final</td><td>Cantidad elegida de cada tipo. Cada tipo aparece una vez.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActuatorSelection(List&lt;ActuatorQuantity&gt; items)</code></td><td>(constructor)</td><td>public</td><td>Valida que cada tipo aparezca una vez y que cada cantidad sea mayor que 0 (<code>InvalidActuatorSelection</code>).</td></tr>
<tr><td><code>total()</code></td><td><code>Integer</code></td><td>public</td><td>Suma de las cantidades.</td></tr>
<tr><td><code>quantityOf(ActuatorType type)</code></td><td><code>Integer</code></td><td>public</td><td>Cantidad elegida de un tipo (0 si ninguno).</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>items</code>)</td><td><code>ActuatorQuantity</code></td><td>1 a 1..4</td><td>Cantidad elegida de cada tipo.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActuatorQuantity</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cantidad elegida de un tipo de actuador.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>type</code></td><td><code>ActuatorType</code></td><td>private final</td><td>Tipo de actuador.</td></tr>
<tr><td><code>quantity</code></td><td><code>Integer</code></td><td>private final</td><td>Cantidad, mayor que 0.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActuatorQuantity(ActuatorType type, Integer quantity)</code></td><td>(constructor)</td><td>public</td><td>Crea la cantidad de un tipo.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>type</code>)</td><td><code>ActuatorType</code></td><td>0..* a 1</td><td>Tipo de actuador.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstalledActuator</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Un actuador de Assets instalado en el hogar, con su tipo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>deviceId</code></td><td><code>DeviceId</code></td><td>private final</td><td>Dispositivo de Assets.</td></tr>
<tr><td><code>type</code></td><td><code>ActuatorType</code></td><td>private final</td><td>Tipo del actuador; sale del <code>DeviceType</code> de Assets.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstalledActuator(DeviceId deviceId, ActuatorType type)</code></td><td>(constructor)</td><td>public</td><td>Crea el actuador instalado.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>type</code>)</td><td><code>ActuatorType</code></td><td>0..* a 1</td><td>Tipo del actuador; sale del <code>DeviceType</code> de Assets.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstalledEquipment</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Los equipos de Assets instalados en el hogar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>microphoneEdgeId</code></td><td><code>EdgeId</code></td><td>private final</td><td><code>Edge</code> de micrófono.</td></tr>
<tr><td><code>actuatorEdgeId</code></td><td><code>EdgeId</code></td><td>private final</td><td><code>Edge</code> de actuadores.</td></tr>
<tr><td><code>microphoneId</code></td><td><code>DeviceId</code></td><td>private final</td><td>Micrófono.</td></tr>
<tr><td><code>actuators</code></td><td><code>List&lt;InstalledActuator&gt;</code></td><td>private final</td><td>Actuadores instalados. Al menos uno, sin repetidos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstalledEquipment(EdgeId microphoneEdgeId, EdgeId actuatorEdgeId, DeviceId microphoneId, List&lt;InstalledActuator&gt; actuators)</code></td><td>(constructor)</td><td>public</td><td>Valida que esté completo: los dos edges y el micrófono no son nulos y hay al menos un actuador, sin repetidos (<code>IncompleteInstalledEquipment</code>).</td></tr>
<tr><td><code>countOf(ActuatorType type)</code></td><td><code>Integer</code></td><td>public</td><td>Cantidad de actuadores instalados de un tipo.</td></tr>
<tr><td><code>covers(ActuatorSelection selection)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si, de cada tipo, hay tantos instalados como los elegidos.</td></tr>
<tr><td><code>exceeds(ActuatorSelection selection)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si, de algún tipo, hay más instalados que los elegidos.</td></tr>
<tr><td><code>contains(AssetKind kind, Long assetId)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si un edge o un dispositivo está instalado.</td></tr>
<tr><td><code>addActuators(List&lt;InstalledActuator&gt; actuators)</code></td><td><code>InstalledEquipment</code></td><td>public</td><td>Devuelve el equipo con los actuadores nuevos; ninguno puede estar ya instalado (<code>EquipmentAlreadyInstalled</code>).</td></tr>
<tr><td><code>replace(EquipmentReplacement replacement)</code></td><td><code>InstalledEquipment</code></td><td>public</td><td>Devuelve el equipo con el nuevo en el lugar del viejo.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Siempre está completo y se guarda una sola vez, en <code>Installation</code>.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>actuators</code>)</td><td><code>InstalledActuator</code></td><td>1 a 1..*</td><td>Actuadores instalados.</td></tr>
<tr><td>Dependencia "covers / exceeds"</td><td><code>ActuatorSelection</code></td><td>No aplica</td><td></td></tr>
<tr><td>Dependencia "replace"</td><td><code>EquipmentReplacement</code></td><td>No aplica</td><td></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EquipmentReplacement</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Un equipo malogrado que el técnico cambió por otro en una reparación. El técnico los indica por MAC.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>kind</code></td><td><code>AssetKind</code></td><td>private final</td><td><code>EDGE</code> o <code>DEVICE</code>: sale de dónde se encontró la MAC en Assets.</td></tr>
<tr><td><code>oldAssetId</code></td><td><code>Long</code></td><td>private final</td><td>Equipo retirado.</td></tr>
<tr><td><code>newAssetId</code></td><td><code>Long</code></td><td>private final</td><td>Equipo nuevo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EquipmentReplacement(AssetKind kind, Long oldAssetId, Long newAssetId)</code></td><td>(constructor)</td><td>public</td><td>Valida que los dos equipos sean distintos (<code>InvalidReplacement</code>).</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Antes de atender la visita, la capa de aplicación valida con Assets que el nuevo sea del mismo tipo y esté <code>AVAILABLE</code> (<code>EquipmentTypeMismatch</code>, <code>EquipmentNotAvailable</code>).</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>kind</code>)</td><td><code>AssetKind</code></td><td>0..* a 1</td><td><code>EDGE</code> o <code>DEVICE</code>: sale de dónde se encontró la MAC en Assets.</td></tr>
</table>

#### Enumerations

<table>
<tr><th colspan="4" align="left"><code>PlanCode</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Copia del plan que el familiar pagó en Subscriptions.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>MINIMUM</code>, <code>CUSTOM</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActuatorType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tipos de actuador que se instalan.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>DOOR</code>, <code>WINDOW</code>, <code>CURTAIN</code>, <code>LIGHT</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssetKind</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Clase de equipo de Assets: edge o dispositivo.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>EDGE</code>, <code>DEVICE</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de la instalación. <code>REJECTED</code>, <code>CANCELED</code> y <code>REMOVED</code> son finales.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td><code>PENDING_EVALUATION</code></td><td colspan="3">Espera la visita de evaluación (primera o re-evaluación).</td></tr>
<tr><td><code>INSTALLED</code></td><td colspan="3">Se instalaron todos los actuadores elegidos.</td></tr>
<tr><td><code>PARTIALLY_INSTALLED</code></td><td colspan="3">Se instalaron algunos; falta adecuar el hogar.</td></tr>
<tr><td><code>REJECTED</code></td><td colspan="3">La primera evaluación no cumplió: se devuelve el pago.</td></tr>
<tr><td><code>CANCELED</code></td><td colspan="3">No se agendó otra cita a tiempo (con devolución) o terminó la suscripción antes de instalar (sin devolución).</td></tr>
<tr><td><code>REMOVAL_PENDING</code></td><td colspan="3">Terminó el servicio; falta recoger los equipos.</td></tr>
<tr><td><code>REMOVED</code></td><td colspan="3">Se recogieron los equipos.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AppointmentStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de la cita.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td><code>REQUESTED</code></td><td colspan="3">El familiar la agendó; espera técnico.</td></tr>
<tr><td><code>SCHEDULED</code></td><td colspan="3">Tiene una visita asignada.</td></tr>
<tr><td><code>COMPLETED</code></td><td colspan="3">La visita se atendió.</td></tr>
<tr><td><code>EXPIRED</code></td><td colspan="3">Pasó su día sin atenderse.</td></tr>
<tr><td><code>CANCELED</code></td><td colspan="3">Terminó el servicio.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EvaluationResult</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Resultado de la evaluación del hogar.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td><code>MEETS</code></td><td colspan="3">Se instalaron todos los actuadores elegidos.</td></tr>
<tr><td><code>PARTIALLY_MEETS</code></td><td colspan="3">Se instalaron algunos.</td></tr>
<tr><td><code>DOES_NOT_MEET</code></td><td colspan="3">No se instaló ninguno.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssignmentStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de una visita.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>ASSIGNED</code>, <code>ATTENDED</code>, <code>CANCELED</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>TicketStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de un ticket.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>OPEN</code>, <code>ASSIGNED</code>, <code>RESOLVED</code>, <code>CLOSED</code></td></tr>
</table>

#### Domain Events

**Dentro de Support.** `AppointmentRequestedEvent`: si es re-evaluación, activa `RequestReevaluationCommand`. `InstallationAssignmentCreatedEvent`: activa `MarkAppointmentScheduledCommand`. `InstallationAssignmentAttendedEvent`: activa `InstallEquipmentCommand` y `CompleteAppointmentCommand`. `ReevaluationAssignmentAttendedEvent`: activa `AddActuatorsCommand` y `CompleteAppointmentCommand`. `RequirementsNotMetEvent`: activa `MarkRequirementsNotMetCommand` y `CompleteAppointmentCommand`. `RepairAssignmentCreatedEvent`: activa `MarkTicketAssignedCommand`. `RepairAssignmentAttendedEvent`: activa `ResolveTicketCommand` y, si hubo cambios, `ReplaceEquipmentCommand`. `AppointmentExpiredEvent`: activa `CancelAssignmentCommand` si la cita tiene una visita `ASSIGNED`; si era re-evaluación, `CancelReevaluationCommand`; si no, `SetSchedulingDeadlineCommand`. `AppointmentCanceledEvent` y `TicketClosedEvent`: activan `CancelAssignmentCommand` si hay visita `ASSIGNED`. `InstallationServiceEndedEvent`: activa `CancelAppointmentCommand` (cita activa) y `CloseTicketCommand` (tickets `OPEN` o `ASSIGNED`). `RemovalAssignmentAttendedEvent`: activa `CompleteRemovalCommand`.

**Hacia otros contextos** (la capa de aplicación, por ACL) `EquipmentInstalledEvent`: Assets `CreateDeviceNetworkCommand` con los equipos. `ActuatorsAddedEvent`: Assets `AddDeviceToNetworkCommand` por cada actuador (red de `GetDeviceNetworkByInstallationIdQuery`). `EquipmentReplacedEvent`: Assets `ChangeEdgeStatusCommand` o `ChangeDeviceStatusCommand` con `BROKEN` para el viejo (lo retira de la red) y luego `AddEdgeToNetworkCommand` o `AddDeviceToNetworkCommand` con el nuevo. `InstallationRejectedEvent` e `InstallationCanceledEvent`: Subscriptions devuelve el pago (`RefundSubscriptionCommand`) y Communication avisa al familiar por correo y en la app. `InstallationServiceEndedEvent`: Assets `DeactivateDeviceNetworkCommand` (se apaga todo). `EquipmentRemovedEvent`: Assets `DismantleDeviceNetworkCommand` (libera los equipos). `InstallationAssignmentCreatedEvent`, `RepairAssignmentCreatedEvent`, `RemovalAssignmentCreatedEvent` y `AssignmentReassignedEvent`: Communication avisa al técnico asignado (`ASSIGNMENT_CREATED`).

**Desde otros contextos.** `SubscriptionCanceledEvent` (Subscriptions): activa `EndInstallationServiceCommand`. La credencial de cada edge nace al registrarlo en Assets; Support no la maneja.

<table>
<tr><th colspan="4" align="left"><code>AppointmentRequestedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que el familiar agendó una cita.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>appointment</code></td><td><code>Appointment</code></td><td>private</td><td>Cita que originó el evento; su id se lee al publicarse.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AppointmentRequestedEvent(Appointment appointment)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con el aggregate que lo registra.</td></tr>
<tr><td><code>getAppointmentId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>appointmentId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getInstallationId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>installationId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>isReevaluation()</code></td><td><code>boolean</code></td><td>public</td><td>Devuelve <code>reevaluation</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Appointment.constructor</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto, si es re-evaluación: <code>RequestReevaluationCommand</code> (síncrono).</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Se registra en el constructor de <code>Appointment</code>, cuando aún no hay id.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationAssignmentCreatedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que el administrador asignó un técnico a una cita.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assignment</code></td><td><code>InstallationAssignment</code></td><td>private</td><td>Visita que originó el evento; su id se lee al publicarse.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallationAssignmentCreatedEvent(InstallationAssignment assignment)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con el aggregate que lo registra.</td></tr>
<tr><td><code>getAssignmentId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>assignmentId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getAppointmentId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>appointmentId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getTechnicianId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>technicianId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getScheduledDate()</code></td><td><code>LocalDate</code></td><td>public</td><td>Devuelve <code>scheduledDate</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getTimeRange()</code></td><td><code>TimeRange</code></td><td>public</td><td>Devuelve <code>timeRange</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>InstallationAssignment.constructor</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>MarkAppointmentScheduledCommand</code> (síncrono). Después del commit, Communication avisa al técnico asignado (<code>ASSIGNMENT_CREATED</code>).</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Se registra en el constructor de la visita, cuando aún no hay id.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationAssignmentAttendedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que el técnico atendió la primera visita e instaló los equipos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la visita.</td></tr>
<tr><td><code>appointmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la cita.</td></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><td><code>result</code></td><td><code>EvaluationResult</code></td><td>private final</td><td><code>MEETS</code> o <code>PARTIALLY_MEETS</code>.</td></tr>
<tr><td><code>installed</code></td><td><code>InstalledEquipment</code></td><td>private final</td><td>Equipos instalados.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallationAssignmentAttendedEvent(Long assignmentId, Long appointmentId, Long installationId, EvaluationResult result, InstalledEquipment installed)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>InstallationAssignment.attendInstallation</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>InstallEquipmentCommand</code> y <code>CompleteAppointmentCommand</code> (síncrono). Si <code>install</code> falla (<code>ExceedsRequestedActuators</code>, <code>EvaluationResultMismatch</code>), se revierte también la visita y el técnico recibe el error.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ReevaluationAssignmentAttendedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que el técnico atendió una re-evaluación y agregó actuadores.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la visita.</td></tr>
<tr><td><code>appointmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la cita.</td></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><td><code>result</code></td><td><code>EvaluationResult</code></td><td>private final</td><td><code>MEETS</code> o <code>PARTIALLY_MEETS</code>.</td></tr>
<tr><td><code>actuators</code></td><td><code>List&lt;InstalledActuator&gt;</code></td><td>private final</td><td>Actuadores nuevos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ReevaluationAssignmentAttendedEvent(Long assignmentId, Long appointmentId, Long installationId, EvaluationResult result, List&lt;InstalledActuator&gt; actuators)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>InstallationAssignment.attendReevaluation</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>AddActuatorsCommand</code> y <code>CompleteAppointmentCommand</code> (síncrono).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RequirementsNotMetEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que el hogar no cumple los requisitos: no se instaló nada en la visita.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la visita.</td></tr>
<tr><td><code>appointmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la cita.</td></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RequirementsNotMetEvent(Long assignmentId, Long appointmentId, Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>InstallationAssignment.attendRequirementsNotMet</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>MarkRequirementsNotMetCommand</code> y <code>CompleteAppointmentCommand</code> (síncrono).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RepairAssignmentCreatedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que el administrador asignó una visita de reparación a un ticket.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assignment</code></td><td><code>RepairAssignment</code></td><td>private</td><td>Visita que originó el evento; su id se lee al publicarse.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RepairAssignmentCreatedEvent(RepairAssignment assignment)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con el aggregate que lo registra.</td></tr>
<tr><td><code>getAssignmentId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>assignmentId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getTicketId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>ticketId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getTechnicianId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>technicianId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getScheduledDate()</code></td><td><code>LocalDate</code></td><td>public</td><td>Devuelve <code>scheduledDate</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getTimeRange()</code></td><td><code>TimeRange</code></td><td>public</td><td>Devuelve <code>timeRange</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>RepairAssignment.constructor</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>MarkTicketAssignedCommand</code> (síncrono). Después del commit, Communication avisa al técnico asignado (<code>ASSIGNMENT_CREATED</code>).</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Se registra en el constructor de la visita, cuando aún no hay id.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RemovalAssignmentCreatedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que el administrador asignó la visita de retiro de los equipos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assignment</code></td><td><code>RemovalAssignment</code></td><td>private</td><td>Visita que originó el evento; su id se lee al publicarse.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RemovalAssignmentCreatedEvent(RemovalAssignment assignment)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con el aggregate que lo registra.</td></tr>
<tr><td><code>getAssignmentId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>assignmentId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getInstallationId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>installationId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getTechnicianId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>technicianId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getScheduledDate()</code></td><td><code>LocalDate</code></td><td>public</td><td>Devuelve <code>scheduledDate</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getTimeRange()</code></td><td><code>TimeRange</code></td><td>public</td><td>Devuelve <code>timeRange</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>RemovalAssignment.constructor</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Después del commit, Communication avisa al técnico asignado (<code>ASSIGNMENT_CREATED</code>).</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Se registra en el constructor de la visita, cuando aún no hay id.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssignmentReassignedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que el administrador reasignó una visita a otro técnico, fecha u horas.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la visita.</td></tr>
<tr><td><code>technicianId</code></td><td><code>Long</code></td><td>private final</td><td>Técnico nuevo.</td></tr>
<tr><td><code>scheduledDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha nueva.</td></tr>
<tr><td><code>timeRange</code></td><td><code>TimeRange</code></td><td>private final</td><td>Horas nuevas.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssignmentReassignedEvent(Long assignmentId, Long technicianId, LocalDate scheduledDate, TimeRange timeRange)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Assignment.reassign</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Después del commit, Communication avisa al técnico nuevo (<code>ASSIGNMENT_CREATED</code>); al que la pierde no se le avisa.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RemovalAssignmentAttendedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que el técnico recogió los equipos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la visita.</td></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RemovalAssignmentAttendedEvent(Long assignmentId, Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>RemovalAssignment.attend</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>CompleteRemovalCommand</code> (síncrono).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AppointmentExpiredEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que una cita pasó su día sin atenderse.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>appointmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la cita.</td></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><td><code>reevaluation</code></td><td><code>boolean</code></td><td>private final</td><td>Verdadero si era una re-evaluación.</td></tr>
<tr><td><code>expiredOn</code></td><td><code>LocalDate</code></td><td>private final</td><td>Día de la cita que venció.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AppointmentExpiredEvent(Long appointmentId, Long installationId, boolean reevaluation, LocalDate expiredOn)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Appointment.expire</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto (síncrono): <code>CancelAssignmentCommand</code> si la cita tiene una visita <code>ASSIGNED</code>; si era re-evaluación, <code>CancelReevaluationCommand</code>; si no, <code>SetSchedulingDeadlineCommand</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AppointmentCanceledEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que se canceló una cita porque terminó el servicio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>appointmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la cita.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AppointmentCanceledEvent(Long appointmentId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Appointment.cancel</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>CancelAssignmentCommand</code> si hay una visita <code>ASSIGNED</code> (síncrono).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>TicketClosedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que se cerró un ticket porque terminó el servicio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ticketId</code></td><td><code>Long</code></td><td>private final</td><td>Id del ticket.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>TicketClosedEvent(Long ticketId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Ticket.close</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>CancelAssignmentCommand</code> si hay una visita <code>ASSIGNED</code> (síncrono).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RepairAssignmentAttendedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que el técnico atendió una reparación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la visita.</td></tr>
<tr><td><code>ticketId</code></td><td><code>Long</code></td><td>private final</td><td>Id del ticket.</td></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><td><code>replacements</code></td><td><code>List&lt;EquipmentReplacement&gt;</code></td><td>private final</td><td>Equipos que cambió; vacía si solo reparó.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RepairAssignmentAttendedEvent(Long assignmentId, Long ticketId, Long installationId, List&lt;EquipmentReplacement&gt; replacements)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>RepairAssignment</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>ResolveTicketCommand</code> y, si hubo cambios, <code>ReplaceEquipmentCommand</code> (síncrono).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EquipmentInstalledEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que se instalaron los equipos en la primera visita.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Negocio dueño de los equipos.</td></tr>
<tr><td><code>installed</code></td><td><code>InstalledEquipment</code></td><td>private final</td><td>Equipos instalados.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EquipmentInstalledEvent(Long installationId, Long businessId, InstalledEquipment installed)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Installation.install</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Assets crea la red del hogar con los equipos (<code>CreateDeviceNetworkCommand</code>), síncrono.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActuatorsAddedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que se agregaron actuadores en una re-evaluación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><td><code>actuators</code></td><td><code>List&lt;InstalledActuator&gt;</code></td><td>private final</td><td>Actuadores nuevos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActuatorsAddedEvent(Long installationId, List&lt;InstalledActuator&gt; actuators)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Installation.addActuators</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Assets agrega cada actuador a la red de la instalación (<code>AddDeviceToNetworkCommand</code>, con la red de <code>GetDeviceNetworkByInstallationIdQuery</code>), síncrono.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EquipmentReplacedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que se cambiaron equipos malogrados en una reparación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Negocio dueño de los equipos.</td></tr>
<tr><td><code>replacements</code></td><td><code>List&lt;EquipmentReplacement&gt;</code></td><td>private final</td><td>Equipos cambiados.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EquipmentReplacedEvent(Long installationId, Long businessId, List&lt;EquipmentReplacement&gt; replacements)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Installation.replaceEquipment</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Assets marca el viejo <code>BROKEN</code> (<code>ChangeEdgeStatusCommand</code> o <code>ChangeDeviceStatusCommand</code>), lo que lo retira de la red, y agrega el nuevo (<code>AddEdgeToNetworkCommand</code> o <code>AddDeviceToNetworkCommand</code>). Síncrono.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationRejectedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que la primera evaluación no cumplió y la instalación quedó <code>REJECTED</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la persona asistida (Assistance).</td></tr>
<tr><td><code>requestedBy</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta del familiar.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallationRejectedEvent(Long installationId, Long assistedPersonId, Long requestedBy)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Installation.markRequirementsNotMet</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Después del commit, Subscriptions devuelve el pago (<code>RefundSubscriptionCommand</code>) y Communication avisa al familiar por correo y en la app.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationCanceledEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que la instalación se canceló porque el familiar no agendó otra cita en 7 días hábiles.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la persona asistida (Assistance).</td></tr>
<tr><td><code>requestedBy</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta del familiar.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallationCanceledEvent(Long installationId, Long assistedPersonId, Long requestedBy)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Installation.cancelForMissingAppointment</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Después del commit, Subscriptions devuelve el pago (<code>RefundSubscriptionCommand</code>) y Communication avisa al familiar por correo y en la app.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationServiceEndedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que terminó el servicio de la instalación porque se canceló la suscripción.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Negocio dueño de los equipos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallationServiceEndedEvent(Long installationId, Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Installation.endService</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto (síncrono): <code>CancelAppointmentCommand</code> para la cita activa y <code>CloseTicketCommand</code> para cada ticket <code>OPEN</code> o <code>ASSIGNED</code>; el handler los busca con <code>GetAllAppointmentsByInstallationIdQuery</code> y <code>GetAllTicketsByInstallationIdQuery</code>. Assets desactiva la red (<code>DeactivateDeviceNetworkCommand</code>), síncrono; sin equipos no hay red que apagar.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EquipmentRemovedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que se recogieron los equipos de la instalación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EquipmentRemovedEvent(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Installation.completeRemoval</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Assets desmonta la red y libera los equipos (<code>DismantleDeviceNetworkCommand</code>), síncrono.</td></tr>
</table>

#### Commands

<table>
<tr><th colspan="4" align="left"><code>RequestInstallationCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar registra la instalación de su persona asistida (formulario de instalación) con la dirección del hogar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la persona asistida (Assistance).</td></tr>
<tr><td><code>requestedBy</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta del familiar (sale de la sesión).</td></tr>
<tr><td><code>formattedAddress</code></td><td><code>String</code></td><td>private final</td><td>Dirección legible.</td></tr>
<tr><td><code>latitude</code></td><td><code>Double</code></td><td>private final</td><td>Latitud de la dirección.</td></tr>
<tr><td><code>longitude</code></td><td><code>Double</code></td><td>private final</td><td>Longitud de la dirección.</td></tr>
<tr><td><code>placeId</code></td><td><code>String</code></td><td>private final</td><td>Identificador del lugar en Google Maps.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RequestInstallationCommand(Long assistedPersonId, Long requestedBy, String formattedAddress, Double latitude, Double longitude, String placeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>InstallationCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La persona asistida existe en Assistance (<code>GetAssistedPersonByIdQuery</code>; <code>AssistedPersonNotFound</code>) y la gestiona ese familiar (<code>NotRelativeOfAssistedPerson</code>). No tiene otra instalación que no esté <code>REJECTED</code>, <code>CANCELED</code> o <code>REMOVED</code> (<code>InstallationAlreadyExists</code>). Tiene una suscripción <code>ACTIVE</code> (Subscriptions, <code>GetActiveSubscriptionByAssistedPersonIdQuery</code>; <code>SubscriptionNotPaid</code>): de ahí se copian el plan y los actuadores elegidos. <code>businessId</code> sale del familiar en Assistance.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ScheduleAppointmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar agenda una cita (primera evaluación o re-evaluación).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Instalación a evaluar.</td></tr>
<tr><td><code>requestedBy</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta del familiar (sale de la sesión).</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private final</td><td>Día de la cita.</td></tr>
<tr><td><code>availableFrom</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora desde la que el familiar está libre.</td></tr>
<tr><td><code>availableTo</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora hasta la que el familiar está libre.</td></tr>
<tr><td><code>formattedAddress</code></td><td><code>String</code></td><td>private final</td><td>Dirección que escribe el familiar; se compara con la de la instalación.</td></tr>
<tr><td><code>latitude</code></td><td><code>Double</code></td><td>private final</td><td>Latitud de la dirección escrita.</td></tr>
<tr><td><code>longitude</code></td><td><code>Double</code></td><td>private final</td><td>Longitud de la dirección escrita.</td></tr>
<tr><td><code>placeId</code></td><td><code>String</code></td><td>private final</td><td>Lugar de Google Maps de la dirección escrita.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ScheduleAppointmentCommand(Long installationId, Long requestedBy, LocalDate date, LocalTime availableFrom, LocalTime availableTo, String formattedAddress, Double latitude, Double longitude, String placeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AppointmentCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La instalación existe (<code>InstallationNotFound</code>) y no tiene otra cita <code>REQUESTED</code> o <code>SCHEDULED</code> (<code>AppointmentAlreadyExists</code>). <code>availableFrom</code> y <code>availableTo</code> forman la <code>availability</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>MarkAppointmentScheduledCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Deja la cita <code>SCHEDULED</code>. Lo activa <code>InstallationAssignmentCreatedEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>appointmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la cita.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>MarkAppointmentScheduledCommand(Long appointmentId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AppointmentCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La cita existe (<code>AppointmentNotFound</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CompleteAppointmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Deja la cita <code>COMPLETED</code>. Lo activan los eventos de la visita atendida.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>appointmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la cita.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CompleteAppointmentCommand(Long appointmentId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AppointmentCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La cita existe (<code>AppointmentNotFound</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ExpireOverdueAppointmentsCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Vence las citas que pasaron su día sin atenderse. Lo ejecuta el proceso programado cada día a las 00:05, con <code>today</code> = el día que empieza.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>today</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha actual (America/Lima), que calcula la capa de aplicación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ExpireOverdueAppointmentsCommand(LocalDate today)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AppointmentCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Llama a <code>expire</code> en cada cita <code>REQUESTED</code> o <code>SCHEDULED</code> con fecha anterior a <code>today</code>: su visita no se atendió, porque atenderla completa la cita en la misma transacción.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CancelAppointmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cancela la cita activa de una instalación cuyo servicio terminó. Lo activa <code>InstallationServiceEndedEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>appointmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la cita.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CancelAppointmentCommand(Long appointmentId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AppointmentCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lo activa <code>InstallationServiceEndedEvent</code> para la cita activa.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RequestReevaluationCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Pasa la instalación a <code>PENDING_EVALUATION</code> para una re-evaluación. Lo activa <code>AppointmentRequestedEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RequestReevaluationCommand(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>InstallationCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallEquipmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Guarda los equipos de la primera visita en la instalación. Lo activa <code>InstallationAssignmentAttendedEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><td><code>result</code></td><td><code>EvaluationResult</code></td><td>private final</td><td><code>MEETS</code> o <code>PARTIALLY_MEETS</code>.</td></tr>
<tr><td><code>installed</code></td><td><code>InstalledEquipment</code></td><td>private final</td><td>Equipos instalados.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallEquipmentCommand(Long installationId, EvaluationResult result, InstalledEquipment installed)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>InstallationCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AddActuatorsCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Suma los actuadores de una re-evaluación. Lo activa <code>ReevaluationAssignmentAttendedEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><td><code>result</code></td><td><code>EvaluationResult</code></td><td>private final</td><td><code>MEETS</code> o <code>PARTIALLY_MEETS</code>.</td></tr>
<tr><td><code>actuators</code></td><td><code>List&lt;InstalledActuator&gt;</code></td><td>private final</td><td>Actuadores nuevos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AddActuatorsCommand(Long installationId, EvaluationResult result, List&lt;InstalledActuator&gt; actuators)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>InstallationCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>MarkRequirementsNotMetCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Registra que el hogar no cumple. Lo activa <code>RequirementsNotMetEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>MarkRequirementsNotMetCommand(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>InstallationCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ReplaceEquipmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cambia en la instalación los equipos de una reparación. Lo activa <code>RepairAssignmentAttendedEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><td><code>replacements</code></td><td><code>List&lt;EquipmentReplacement&gt;</code></td><td>private final</td><td>Equipos cambiados.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ReplaceEquipmentCommand(Long installationId, List&lt;EquipmentReplacement&gt; replacements)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>InstallationCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SetSchedulingDeadlineCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Abre el plazo de 7 días hábiles para agendar otra cita después de que venció la primera. Lo activa <code>AppointmentExpiredEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><td><code>expiredOn</code></td><td><code>LocalDate</code></td><td>private final</td><td>Día de la cita que venció.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SetSchedulingDeadlineCommand(Long installationId, LocalDate expiredOn)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>InstallationCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CancelReevaluationCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Devuelve la instalación a <code>PARTIALLY_INSTALLED</code> cuando vence una cita de re-evaluación. Lo activa <code>AppointmentExpiredEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CancelReevaluationCommand(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>InstallationCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CancelInstallationsWithoutAppointmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cancela las instalaciones cuyo plazo para agendar otra cita venció. Lo ejecuta el proceso programado cada día a las 00:05.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>today</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha actual (America/Lima), que calcula la capa de aplicación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CancelInstallationsWithoutAppointmentCommand(LocalDate today)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>InstallationCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Toma las instalaciones <code>PENDING_EVALUATION</code> sin equipos, con <code>schedulingDeadline</code> anterior a <code>today</code> y sin cita <code>REQUESTED</code> o <code>SCHEDULED</code>, y llama a <code>cancelForMissingAppointment</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EndInstallationServiceCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Apaga el servicio de la instalación de una persona asistida. Lo activa <code>SubscriptionCanceledEvent</code> de Subscriptions.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la persona asistida (Assistance).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EndInstallationServiceCommand(Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>InstallationCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Busca la instalación de la persona asistida que no esté <code>REJECTED</code>, <code>CANCELED</code> o <code>REMOVED</code>; si no hay, no hace nada (la suscripción se canceló por un rechazo o una cancelación ya hechos). Llama a <code>endService</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CompleteRemovalCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Deja la instalación <code>REMOVED</code>. Lo activa <code>RemovalAssignmentAttendedEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CompleteRemovalCommand(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>InstallationCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateInstallationAssignmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El administrador asigna un técnico a una cita, con las horas de la visita.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>appointmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la cita.</td></tr>
<tr><td><code>technicianId</code></td><td><code>Long</code></td><td>private final</td><td>Técnico asignado (HCM).</td></tr>
<tr><td><code>startTime</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de inicio de la visita.</td></tr>
<tr><td><code>endTime</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de fin de la visita.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateInstallationAssignmentCommand(Long appointmentId, Long technicianId, LocalTime startTime, LocalTime endTime)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AssignmentCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La cita existe (<code>AppointmentNotFound</code>) y la instalación está <code>PENDING_EVALUATION</code> (<code>InstallationNotPendingEvaluation</code>). El técnico existe en HCM (<code>GetEmployeeByIdQuery</code>; <code>EmployeeNotFound</code>), es <code>TECH</code> y está <code>ACTIVE</code> (<code>EmployeeNotTechnician</code>); las horas caben en un turno de ese día (<code>WorkSchedule.covers</code>; <code>OutsideWorkingHours</code>); no está de vacaciones esa fecha (<code>Employee.isOnVacation</code>; <code>EmployeeOnVacation</code>); no se cruza con otra visita <code>ASSIGNED</code> suya (<code>AssignmentConflict</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateRepairAssignmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El administrador asigna una visita de reparación a un ticket.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ticketId</code></td><td><code>Long</code></td><td>private final</td><td>Id del ticket.</td></tr>
<tr><td><code>technicianId</code></td><td><code>Long</code></td><td>private final</td><td>Técnico asignado (HCM).</td></tr>
<tr><td><code>scheduledDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de la visita.</td></tr>
<tr><td><code>startTime</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de inicio.</td></tr>
<tr><td><code>endTime</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de fin.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateRepairAssignmentCommand(Long ticketId, Long technicianId, LocalDate scheduledDate, LocalTime startTime, LocalTime endTime)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AssignmentCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El ticket existe (<code>TicketNotFound</code>). La fecha puede ser cualquier día de la semana. Las mismas validaciones del técnico que <code>CreateInstallationAssignmentCommand</code> (<code>EmployeeNotFound</code>, <code>EmployeeNotTechnician</code>, <code>OutsideWorkingHours</code>, <code>EmployeeOnVacation</code>, <code>AssignmentConflict</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateRemovalAssignmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El administrador asigna la visita para recoger los equipos de una instalación <code>REMOVAL_PENDING</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><td><code>technicianId</code></td><td><code>Long</code></td><td>private final</td><td>Técnico asignado (HCM).</td></tr>
<tr><td><code>scheduledDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de la visita.</td></tr>
<tr><td><code>startTime</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de inicio.</td></tr>
<tr><td><code>endTime</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de fin.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateRemovalAssignmentCommand(Long installationId, Long technicianId, LocalDate scheduledDate, LocalTime startTime, LocalTime endTime)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AssignmentCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La instalación existe (<code>InstallationNotFound</code>) y está <code>REMOVAL_PENDING</code> (lo valida el constructor). Las mismas validaciones del técnico que <code>CreateInstallationAssignmentCommand</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ReassignAssignmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El administrador cambia el técnico, la fecha o las horas de una visita <code>ASSIGNED</code> (por ejemplo, si el técnico fue suspendido o cesado).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la visita.</td></tr>
<tr><td><code>technicianId</code></td><td><code>Long</code></td><td>private final</td><td>Técnico nuevo (HCM).</td></tr>
<tr><td><code>scheduledDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha nueva.</td></tr>
<tr><td><code>startTime</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de inicio.</td></tr>
<tr><td><code>endTime</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de fin.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ReassignAssignmentCommand(Long assignmentId, Long technicianId, LocalDate scheduledDate, LocalTime startTime, LocalTime endTime)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AssignmentCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La visita existe (<code>AssignmentNotFound</code>). Las mismas validaciones del técnico que <code>CreateInstallationAssignmentCommand</code>. El administrador encuentra las visitas del técnico con <code>GetAllAssignmentsByTechnicianIdQuery</code>. Es manual por diseño: el administrador suspende o cesa al técnico, así que no se le avisa; solo se avisa al técnico nuevo.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CancelAssignmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cancela la visita <code>ASSIGNED</code> de una cita vencida o cancelada, o de un ticket cerrado. Solo lo activan eventos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la visita.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CancelAssignmentCommand(Long assignmentId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AssignmentCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El handler busca la visita con <code>GetAssignmentByAppointmentIdQuery</code> o <code>GetAssignmentByTicketIdQuery</code>; si no hay una <code>ASSIGNED</code>, no hace nada.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AttendInstallationAssignmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El técnico atiende la primera visita de una instalación: resultado, MAC de los cuatro tipos de equipo y fotos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la visita.</td></tr>
<tr><td><code>technicianId</code></td><td><code>Long</code></td><td>private final</td><td>Técnico que atiende (sale del usuario autenticado, <code>GetEmployeeByUserIdQuery</code> de HCM).</td></tr>
<tr><td><code>result</code></td><td><code>EvaluationResult</code></td><td>private final</td><td><code>MEETS</code> o <code>PARTIALLY_MEETS</code>.</td></tr>
<tr><td><code>microphoneEdgeMacAddress</code></td><td><code>String</code></td><td>private final</td><td>MAC del edge de micrófono que instaló el técnico.</td></tr>
<tr><td><code>actuatorEdgeMacAddress</code></td><td><code>String</code></td><td>private final</td><td>MAC del edge de actuadores que instaló el técnico.</td></tr>
<tr><td><code>microphoneMacAddress</code></td><td><code>String</code></td><td>private final</td><td>MAC del micrófono que instaló el técnico.</td></tr>
<tr><td><code>actuatorMacAddresses</code></td><td><code>List&lt;String&gt;</code></td><td>private final</td><td>MAC de los actuadores instalados.</td></tr>
<tr><td><code>photosData</code></td><td><code>List&lt;byte[]&gt;</code></td><td>private final</td><td>Archivos de las fotos que sube el técnico.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AttendInstallationAssignmentCommand(Long assignmentId, Long technicianId, EvaluationResult result, String microphoneEdgeMacAddress, String actuatorEdgeMacAddress, String microphoneMacAddress, List&lt;String&gt; actuatorMacAddresses, List&lt;byte[]&gt; photosData)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AssignmentCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La visita existe (<code>AssignmentNotFound</code>) y es suya (<code>AssignmentNotForTechnician</code>). La capa de aplicación sube las fotos y busca cada MAC en Assets (<code>GetEdgeByMacAddressQuery</code>, <code>GetDeviceByMacAddressQuery</code>; <code>EquipmentNotFound</code>): pasa ids y, de cada actuador, su <code>ActuatorType</code>. Antes de llamar al aggregate valida que cada equipo esté <code>AVAILABLE</code> (<code>EquipmentNotAvailable</code>) y sea del tipo de su lugar: edge de micrófono, edge de actuadores, <code>MICROPHONE</code> o un actuador (<code>EquipmentTypeMismatch</code>). Si después de subir las fotos falla una validación, borra las fotos del almacenamiento.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AttendReevaluationAssignmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El técnico atiende una re-evaluación: resultado, MAC de los actuadores nuevos y fotos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la visita.</td></tr>
<tr><td><code>technicianId</code></td><td><code>Long</code></td><td>private final</td><td>Técnico que atiende (sale del usuario autenticado).</td></tr>
<tr><td><code>result</code></td><td><code>EvaluationResult</code></td><td>private final</td><td><code>MEETS</code> o <code>PARTIALLY_MEETS</code>.</td></tr>
<tr><td><code>actuatorMacAddresses</code></td><td><code>List&lt;String&gt;</code></td><td>private final</td><td>MAC de los actuadores nuevos.</td></tr>
<tr><td><code>photosData</code></td><td><code>List&lt;byte[]&gt;</code></td><td>private final</td><td>Archivos de las fotos que sube el técnico.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AttendReevaluationAssignmentCommand(Long assignmentId, Long technicianId, EvaluationResult result, List&lt;String&gt; actuatorMacAddresses, List&lt;byte[]&gt; photosData)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AssignmentCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Las mismas validaciones que <code>AttendInstallationAssignmentCommand</code>, solo con los actuadores nuevos.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ReportRequirementsNotMetCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El técnico informa que el hogar no cumple: solo fotos del hogar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la visita.</td></tr>
<tr><td><code>technicianId</code></td><td><code>Long</code></td><td>private final</td><td>Técnico que atiende (sale del usuario autenticado).</td></tr>
<tr><td><code>photosData</code></td><td><code>List&lt;byte[]&gt;</code></td><td>private final</td><td>Archivos de las fotos que sube el técnico.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ReportRequirementsNotMetCommand(Long assignmentId, Long technicianId, List&lt;byte[]&gt; photosData)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AssignmentCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La visita existe (<code>AssignmentNotFound</code>) y es suya (<code>AssignmentNotForTechnician</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AttendRepairAssignmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El técnico atiende una reparación: motivo de la falla, equipos cambiados por MAC y fotos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la visita.</td></tr>
<tr><td><code>technicianId</code></td><td><code>Long</code></td><td>private final</td><td>Técnico que atiende (sale del usuario autenticado).</td></tr>
<tr><td><code>failureReason</code></td><td><code>String</code></td><td>private final</td><td>Motivo de la falla que encontró el técnico.</td></tr>
<tr><td><code>replacedMacAddresses</code></td><td><code>Map&lt;String, String&gt;</code></td><td>private final</td><td>Equipos cambiados: MAC del equipo viejo a MAC del nuevo.</td></tr>
<tr><td><code>photosData</code></td><td><code>List&lt;byte[]&gt;</code></td><td>private final</td><td>Archivos de las fotos que sube el técnico.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AttendRepairAssignmentCommand(Long assignmentId, Long technicianId, String failureReason, Map&lt;String, String&gt; replacedMacAddresses, List&lt;byte[]&gt; photosData)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AssignmentCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La visita existe (<code>AssignmentNotFound</code>) y es suya (<code>AssignmentNotForTechnician</code>). Por cada MAC vieja a MAC nueva, la capa de aplicación busca los dos equipos en Assets (<code>EquipmentNotFound</code>); el <code>kind</code> sale de dónde se encontró la MAC. Valida que el nuevo esté <code>AVAILABLE</code> (<code>EquipmentNotAvailable</code>) y sea del mismo tipo que el viejo (<code>EquipmentTypeMismatch</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AttendRemovalAssignmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El técnico registra que recogió los equipos: solo fotos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la visita.</td></tr>
<tr><td><code>technicianId</code></td><td><code>Long</code></td><td>private final</td><td>Técnico que atiende (sale del usuario autenticado).</td></tr>
<tr><td><code>photosData</code></td><td><code>List&lt;byte[]&gt;</code></td><td>private final</td><td>Archivos de las fotos que sube el técnico.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AttendRemovalAssignmentCommand(Long assignmentId, Long technicianId, List&lt;byte[]&gt; photosData)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AssignmentCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La visita existe (<code>AssignmentNotFound</code>) y es suya (<code>AssignmentNotForTechnician</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateTicketCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar reporta que un equipo del hogar está fallando.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><td><code>createdBy</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta del familiar que crea el ticket (sale de la sesión).</td></tr>
<tr><td><code>description</code></td><td><code>String</code></td><td>private final</td><td>Descripción de la falla.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateTicketCommand(Long installationId, Long createdBy, String description)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>TicketCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lo envía el familiar que registró la instalación. La instalación existe (<code>InstallationNotFound</code>) y está en servicio (<code>InstallationOutOfService</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>MarkTicketAssignedCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Deja el ticket <code>ASSIGNED</code>. Lo activa <code>RepairAssignmentCreatedEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ticketId</code></td><td><code>Long</code></td><td>private final</td><td>Id del ticket.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>MarkTicketAssignedCommand(Long ticketId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>TicketCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El ticket existe (<code>TicketNotFound</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ResolveTicketCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Deja el ticket <code>RESOLVED</code>. Lo activa <code>RepairAssignmentAttendedEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ticketId</code></td><td><code>Long</code></td><td>private final</td><td>Id del ticket.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ResolveTicketCommand(Long ticketId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>TicketCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El ticket existe (<code>TicketNotFound</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CloseTicketCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cierra un ticket <code>OPEN</code> o <code>ASSIGNED</code> porque terminó el servicio. Lo activa <code>InstallationServiceEndedEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ticketId</code></td><td><code>Long</code></td><td>private final</td><td>Id del ticket.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CloseTicketCommand(Long ticketId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>TicketCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lo activa <code>InstallationServiceEndedEvent</code> para cada ticket <code>OPEN</code> o <code>ASSIGNED</code>.</td></tr>
</table>

#### Queries

<table>
<tr><th colspan="4" align="left"><code>GetInstallationByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Instalación por id. La usan Tracking y Communication (persona asistida de un reporte) y Analytics.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetInstallationByIdQuery(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Installation&gt;</code> (<code>InstallationQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetInstallationByAssistedPersonIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Instalación vigente de una persona asistida: la que no está <code>REJECTED</code>, <code>CANCELED</code> ni <code>REMOVED</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la persona asistida (Assistance).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetInstallationByAssistedPersonIdQuery(Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Installation&gt;</code> (<code>InstallationQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllInstallationsByBusinessIdAndStatusQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Instalaciones de un negocio en un estado, incluidas las anteriores que quedan como historial. La usan el administrador y Analytics.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio (Company).</td></tr>
<tr><td><code>status</code></td><td><code>InstallationStatus</code></td><td>private final</td><td>Estado de las instalaciones.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllInstallationsByBusinessIdAndStatusQuery(Long businessId, InstallationStatus status)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Installation&gt;</code> (<code>InstallationQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAppointmentByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cita por id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>appointmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la cita.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAppointmentByIdQuery(Long appointmentId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Appointment&gt;</code> (<code>AppointmentQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllAppointmentsByStatusQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Citas en un estado. El administrador ve las pendientes con <code>REQUESTED</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>status</code></td><td><code>AppointmentStatus</code></td><td>private final</td><td>Estado de las citas.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllAppointmentsByStatusQuery(AppointmentStatus status)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Appointment&gt;</code> (<code>AppointmentQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllAppointmentsByInstallationIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Citas de una instalación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllAppointmentsByInstallationIdQuery(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Appointment&gt;</code> (<code>AppointmentQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAssignmentByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Visita por id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la visita.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAssignmentByIdQuery(Long assignmentId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Assignment&gt;</code> (<code>AssignmentQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllAssignmentsByTechnicianIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Visitas de un técnico: su lista de asignaciones.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>technicianId</code></td><td><code>Long</code></td><td>private final</td><td>Id del técnico (HCM).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllAssignmentsByTechnicianIdQuery(Long technicianId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Assignment&gt;</code> (<code>AssignmentQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllAssignmentsByTechnicianIdAndDateQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Visitas de un técnico en una fecha; sirve para validar que no se crucen.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>technicianId</code></td><td><code>Long</code></td><td>private final</td><td>Id del técnico (HCM).</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de las visitas.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllAssignmentsByTechnicianIdAndDateQuery(Long technicianId, LocalDate date)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Assignment&gt;</code> (<code>AssignmentQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAssignmentByAppointmentIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Visita de una cita.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>appointmentId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la cita.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAssignmentByAppointmentIdQuery(Long appointmentId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Assignment&gt;</code> (<code>AssignmentQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAssignmentByTicketIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Visita de reparación de un ticket.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ticketId</code></td><td><code>Long</code></td><td>private final</td><td>Id del ticket.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAssignmentByTicketIdQuery(Long ticketId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Assignment&gt;</code> (<code>AssignmentQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetTicketByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3"><code>Ticket</code> por id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ticketId</code></td><td><code>Long</code></td><td>private final</td><td>Id del ticket.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetTicketByIdQuery(Long ticketId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Ticket&gt;</code> (<code>TicketQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllTicketsByInstallationIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tickets de una instalación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllTicketsByInstallationIdQuery(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Ticket&gt;</code> (<code>TicketQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllTicketsByStatusQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tickets en un estado. El administrador ve los pendientes con <code>OPEN</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>status</code></td><td><code>TicketStatus</code></td><td>private final</td><td>Estado de los tickets.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllTicketsByStatusQuery(TicketStatus status)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Ticket&gt;</code> (<code>TicketQueryService</code>)</td></tr>
</table>

#### Domain Services

<table>
<tr><th colspan="4" align="left"><code>InstallationCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Installation</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(RequestInstallationCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>RequestInstallationCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(RequestReevaluationCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>RequestReevaluationCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(InstallEquipmentCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>InstallEquipmentCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(AddActuatorsCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>AddActuatorsCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(MarkRequirementsNotMetCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>MarkRequirementsNotMetCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(ReplaceEquipmentCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ReplaceEquipmentCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(SetSchedulingDeadlineCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>SetSchedulingDeadlineCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(CancelReevaluationCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CancelReevaluationCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(CancelInstallationsWithoutAppointmentCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>CancelInstallationsWithoutAppointmentCommand</code>.</td></tr>
<tr><td><code>handle(EndInstallationServiceCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>EndInstallationServiceCommand</code>.</td></tr>
<tr><td><code>handle(CompleteRemovalCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CompleteRemovalCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Solo <code>RequestInstallationCommand</code> se expone en la API; los demás commands los activan eventos o el proceso programado. La instalación existe (<code>InstallationNotFound</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Installation</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetInstallationByIdQuery query)</code></td><td><code>Optional&lt;Installation&gt;</code></td><td>public</td><td>Resuelve <code>GetInstallationByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetInstallationByAssistedPersonIdQuery query)</code></td><td><code>Optional&lt;Installation&gt;</code></td><td>public</td><td>Resuelve <code>GetInstallationByAssistedPersonIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetAllInstallationsByBusinessIdAndStatusQuery query)</code></td><td><code>List&lt;Installation&gt;</code></td><td>public</td><td>Resuelve <code>GetAllInstallationsByBusinessIdAndStatusQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AppointmentCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Appointment</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(ScheduleAppointmentCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ScheduleAppointmentCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(MarkAppointmentScheduledCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>MarkAppointmentScheduledCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(CompleteAppointmentCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CompleteAppointmentCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(ExpireOverdueAppointmentsCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>ExpireOverdueAppointmentsCommand</code>.</td></tr>
<tr><td><code>handle(CancelAppointmentCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CancelAppointmentCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AppointmentQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Appointment</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetAppointmentByIdQuery query)</code></td><td><code>Optional&lt;Appointment&gt;</code></td><td>public</td><td>Resuelve <code>GetAppointmentByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetAllAppointmentsByStatusQuery query)</code></td><td><code>List&lt;Appointment&gt;</code></td><td>public</td><td>Resuelve <code>GetAllAppointmentsByStatusQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetAllAppointmentsByInstallationIdQuery query)</code></td><td><code>List&lt;Appointment&gt;</code></td><td>public</td><td>Resuelve <code>GetAllAppointmentsByInstallationIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssignmentCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Assignment</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateInstallationAssignmentCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateInstallationAssignmentCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(CreateRepairAssignmentCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateRepairAssignmentCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(ReassignAssignmentCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ReassignAssignmentCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(AttendInstallationAssignmentCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>AttendInstallationAssignmentCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(AttendReevaluationAssignmentCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>AttendReevaluationAssignmentCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(ReportRequirementsNotMetCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ReportRequirementsNotMetCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(AttendRepairAssignmentCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>AttendRepairAssignmentCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(CreateRemovalAssignmentCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateRemovalAssignmentCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(AttendRemovalAssignmentCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>AttendRemovalAssignmentCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(CancelAssignmentCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CancelAssignmentCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssignmentQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Assignment</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetAssignmentByIdQuery query)</code></td><td><code>Optional&lt;Assignment&gt;</code></td><td>public</td><td>Resuelve <code>GetAssignmentByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetAllAssignmentsByTechnicianIdQuery query)</code></td><td><code>List&lt;Assignment&gt;</code></td><td>public</td><td>Resuelve <code>GetAllAssignmentsByTechnicianIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetAllAssignmentsByTechnicianIdAndDateQuery query)</code></td><td><code>List&lt;Assignment&gt;</code></td><td>public</td><td>Resuelve <code>GetAllAssignmentsByTechnicianIdAndDateQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetAssignmentByAppointmentIdQuery query)</code></td><td><code>Optional&lt;Assignment&gt;</code></td><td>public</td><td>Resuelve <code>GetAssignmentByAppointmentIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetAssignmentByTicketIdQuery query)</code></td><td><code>Optional&lt;Assignment&gt;</code></td><td>public</td><td>Resuelve <code>GetAssignmentByTicketIdQuery</code>; devuelve vacío si no existe.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>TicketCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Ticket</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateTicketCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateTicketCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(MarkTicketAssignedCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>MarkTicketAssignedCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(ResolveTicketCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ResolveTicketCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(CloseTicketCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CloseTicketCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>TicketQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Ticket</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetTicketByIdQuery query)</code></td><td><code>Optional&lt;Ticket&gt;</code></td><td>public</td><td>Resuelve <code>GetTicketByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetAllTicketsByInstallationIdQuery query)</code></td><td><code>List&lt;Ticket&gt;</code></td><td>public</td><td>Resuelve <code>GetAllTicketsByInstallationIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetAllTicketsByStatusQuery query)</code></td><td><code>List&lt;Ticket&gt;</code></td><td>public</td><td>Resuelve <code>GetAllTicketsByStatusQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

#### Exceptions

<table>
<tr><th colspan="4" align="left"><code>SubscriptionNotPaid</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la persona asistida no tiene una suscripción <code>ACTIVE</code> al registrar la instalación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SubscriptionNotPaid(Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssistedPersonNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la persona asistida no existe en Assistance.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssistedPersonNotFound(Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>NotRelativeOfAssistedPerson</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la persona asistida no la gestiona el familiar que registra la instalación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>NotRelativeOfAssistedPerson(Long userId, Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe la instalación indicada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallationNotFound(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la persona asistida ya tiene una instalación que no está <code>REJECTED</code>, <code>CANCELED</code> ni <code>REMOVED</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallationAlreadyExists(Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationNotRequestedByUser</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando quien agenda una cita o crea un ticket no es el familiar que registró la instalación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallationNotRequestedByUser(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidActuatorSelection</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la selección repite un tipo o tiene una cantidad no positiva.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidActuatorSelection()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidInstallationStatusTransition</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el cambio de estado de la instalación no está permitido.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidInstallationStatusTransition(InstallationStatus from, InstallationStatus to)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationNotPendingEvaluation</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se asigna una visita a la cita de una instalación que no está <code>PENDING_EVALUATION</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallationNotPendingEvaluation(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationWithoutEquipment</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se crea un ticket o se cambian equipos en una instalación que aún no tiene equipos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallationWithoutEquipment(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationOutOfService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se crea un ticket para una instalación que no está en servicio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallationOutOfService(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationNotPendingRemoval</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se asigna una visita de retiro a una instalación que no está <code>REMOVAL_PENDING</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallationNotPendingRemoval(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>IncompleteInstalledEquipment</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando faltan los edges, el micrófono o un actuador, o hay actuadores repetidos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>IncompleteInstalledEquipment()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ExceedsRequestedActuators</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se instalan más actuadores de un tipo que los elegidos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ExceedsRequestedActuators(ActuatorType type)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EvaluationResultMismatch</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el resultado no coincide con lo instalado (<code>MEETS</code> sin todos los elegidos o <code>PARTIALLY_MEETS</code> con todos).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EvaluationResultMismatch(EvaluationResult result)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EquipmentRequired</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando una re-evaluación con resultado favorable no trae actuadores.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EquipmentRequired()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EquipmentNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando una MAC no corresponde a ningún equipo de Assets.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EquipmentNotFound(String macAddress)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EquipmentNotAvailable</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando un equipo nuevo no está <code>AVAILABLE</code> en Assets.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EquipmentNotAvailable(String macAddress)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EquipmentTypeMismatch</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando un equipo no es del tipo que corresponde a su lugar o al equipo que reemplaza.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EquipmentTypeMismatch(String macAddress)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EquipmentAlreadyInstalled</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando un equipo nuevo ya está instalado en el hogar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EquipmentAlreadyInstalled(Long assetId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EquipmentNotInstalled</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el equipo a reemplazar no está instalado en el hogar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EquipmentNotInstalled(Long assetId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidReplacement</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el equipo viejo y el nuevo son el mismo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidReplacement(Long oldAssetId, Long newAssetId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AppointmentNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe la cita indicada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AppointmentNotFound(Long appointmentId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AppointmentAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la instalación ya tiene una cita <code>REQUESTED</code> o <code>SCHEDULED</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AppointmentAlreadyExists(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AddressMismatch</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la dirección escrita en la cita no es la de la instalación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AddressMismatch(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidAppointmentDate</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la fecha de la cita es anterior a hoy.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidAppointmentDate(LocalDate date)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationNotSchedulable</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la instalación no está <code>PENDING_EVALUATION</code> ni <code>PARTIALLY_INSTALLED</code> al agendar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallationNotSchedulable(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AppointmentNotRequested</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se asigna una visita a una cita que no está <code>REQUESTED</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AppointmentNotRequested(Long appointmentId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>OutsideAppointmentAvailability</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la visita no es el día de la cita o sus horas no caben en la disponibilidad del familiar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>OutsideAppointmentAvailability(Long appointmentId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidAppointmentStatusTransition</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el cambio de estado de la cita no está permitido.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidAppointmentStatusTransition(AppointmentStatus from, AppointmentStatus to)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssignmentNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe la visita indicada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssignmentNotFound(Long assignmentId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidAssignmentDate</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la fecha de la visita es anterior a hoy.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidAssignmentDate(LocalDate scheduledDate)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el técnico no existe en HCM.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeNotFound(Long technicianId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeNotTechnician</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el empleado no es <code>TECH</code> o no está <code>ACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeNotTechnician(Long technicianId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>OutsideWorkingHours</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando las horas de la visita no caben en un turno del técnico ese día.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>OutsideWorkingHours(Long technicianId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeOnVacation</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el técnico está de vacaciones en la fecha de la visita.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeOnVacation(Long technicianId, LocalDate date)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssignmentConflict</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la visita se cruza con otra visita <code>ASSIGNED</code> del técnico.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssignmentConflict(Long technicianId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssignmentNotForTechnician</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando quien atiende la visita no es el técnico asignado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssignmentNotForTechnician(Long assignmentId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssignmentAlreadyAttended</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se atiende, reasigna o cancela una visita que ya no está <code>ASSIGNED</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssignmentAlreadyAttended(Long assignmentId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidEvaluationResult</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el resultado no corresponde al tipo de atención (<code>DOES_NOT_MEET</code> al instalar, por ejemplo).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidEvaluationResult(EvaluationResult result)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EvaluationTypeMismatch</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se atiende como primera visita una re-evaluación, o al revés.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EvaluationTypeMismatch(Long assignmentId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PhotosRequired</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se atiende una visita sin fotos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PhotosRequired()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>FailureReasonRequired</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se atiende una reparación sin motivo de la falla.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>FailureReasonRequired()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>TicketNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe el ticket indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>TicketNotFound(Long ticketId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>TicketDescriptionRequired</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el ticket no tiene descripción.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>TicketDescriptionRequired()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>TicketNotOpen</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se asigna una visita a un ticket que no está <code>OPEN</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>TicketNotOpen(Long ticketId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidTicketStatusTransition</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el cambio de estado del ticket no está permitido.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidTicketStatusTransition(TicketStatus from, TicketStatus to)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

### 5.7.2. Interface Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.7.1.

### 5.7.3. Application Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.7.1.

### 5.7.4. Infrastructure Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.7.1.

### 5.7.6. Bounded Context Software Architecture Component Level Diagrams

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.7.1.

### 5.7.7. Bounded Context Software Architecture Code Level Diagrams

#### 5.7.7.1. Bounded Context Domain Layer Class Diagrams

El diagrama muestra los aggregates `Installation`, `Appointment`, `Ticket` y la base abstracta `Assignment` con sus tres visitas (`InstallationAssignment`, `RepairAssignment` y `RemovalAssignment`), unidos por referencias directas del mismo contexto (en morado). Los value objects describen lo que eligió el familiar (`ActuatorSelection`), lo instalado (`InstalledEquipment`) y los cambios de una reparación (`EquipmentReplacement`). Los aggregates registran veinte eventos: los internos activan el siguiente command (flechas "activa") y una nota detalla los que salen hacia Assets, Subscriptions y Communication y el que llega desde Subscriptions. Las notas de los services detallan las validaciones con HCM, Assets, Assistance y Subscriptions.

![Diagrama de clases de la capa de dominio - Soporte Técnico](../images/diagrams/img/chapter-5/support-backend-diagram.svg)

#### 5.7.7.2. Bounded Context Database Design Diagram

La base de datos es PostgreSQL.

| Tabla o colección | Aggregate, entidad o value object | Llaves y restricciones |
|---|---|---|
| `installations` | `Installation` (con `Address` e `InstalledEquipment` embebidos) | PK `id`. Referencia a Assistance sin FK: `assisted_person_id`. Referencia a IAM sin FK: `requested_by`. Referencia a Company sin FK: `business_id`. Referencia a Assets sin FK: `microphone_edge_id`, `actuator_edge_id`, `microphone_id`. UK parcial (`assisted_person_id`) WHERE status NOT IN ('`REJECTED`', '`CANCELED`', '`REMOVED`'). IDX (`business_id`, `status`): instalaciones del negocio por estado. CHECK: `microphone_edge_id`, `actuator_edge_id` y `microphone_id` son nulos los tres (aún sin instalar) o no nulos los tres. |
| `installation_requested_actuators` | `ActuatorSelection` de `Installation` | FK `installation_id`. PK (`installation_id`, `actuator_type`). CHECK quantity > 0. |
| `installation_actuators` | `InstalledActuator` de `InstalledEquipment` | FK `installation_id`. Referencia a Assets sin FK: `device_id`. PK (`installation_id`, `device_id`). |
| `appointments` | `Appointment` | PK `id`. FK `installation_id`. Referencia a IAM sin FK: `requested_by`. UK parcial (`installation_id`) WHERE status IN ('`REQUESTED`', '`SCHEDULED`'). IDX (`status`, `date`): citas vencidas que expira el proceso diario. |
| `tickets` | `Ticket` | PK `id`. FK `installation_id`. Referencia a IAM sin FK: `created_by`. |
| `assignments` | `InstallationAssignment`, `RepairAssignment` y `RemovalAssignment` (una tabla, herencia `SINGLE_TABLE`) | PK `id`. UK `appointment_id`, `ticket_id`. FK `appointment_id`, `ticket_id`, `installation_id`. Referencia a HCM sin FK: `technician_id`. IDX (`technician_id`, `scheduled_date`). CHECK INSTALLATION: `appointment_id` no nulo; `ticket_id` e `installation_id` nulos. CHECK REPAIR: `ticket_id` no nulo; `appointment_id` e `installation_id` nulos. CHECK REMOVAL: `installation_id` no nulo; `appointment_id` y `ticket_id` nulos. |
| `assignment_replacements` | `EquipmentReplacement` de `RepairAssignment` | FK `assignment_id`. Referencia a Assets sin FK: `old_asset_id`, `new_asset_id`. PK (`assignment_id`, `old_asset_id`). |
| `assignment_photos` | `Photo` de cada visita | PK `id`. FK `assignment_id`. |

Relaciones entre tablas: `installations` a `installation_actuators` (actuators (0..*)); `installations` a `tickets` (tickets (0..*)); `installations` a `installation_requested_actuators` (actuadores elegidos (1..4)); `installations` a `appointments` (citas (0..*)); `appointments` a `assignments` (visita (0..1)); `tickets` a `assignments` (visita de reparación (0..1)); `installations` a `assignments` (visitas de retiro (0..*, solo REMOVAL)); `assignments` a `assignment_photos` (fotos (1..* al atenderse)); `assignments` a `assignment_replacements` (equipos cambiados (0..*, solo REPAIR)).

**PostgreSQL**.

installations: la dirección (`formatted_address`, latitude, longitude, `place_id`) no se actualiza nunca. `microphone_edge_id`, `actuator_edge_id`, `microphone_id` e `installation_actuators` son el `InstalledEquipment`: nulos hasta la primera instalación y, desde ahí, los tres llenos y al menos un actuador (lo valida el dominio). assignments: una sola tabla para `InstallationAssignment`, `RepairAssignment` y `RemovalAssignment` (herencia SINGLE_TABLE, columna `assignment_type`). plan e `installation_requested_actuators`: copia de lo que el familiar eligió al suscribirse (Subscriptions; `MINIMUM` 1, `CUSTOM` de 1 a 4); `installation_actuators`: lo instalado, con su tipo. Nunca hay más instalados que elegidos. appointments: la cita del familiar (día y rango libre); una sola activa por instalación. La dirección de la cita solo se compara, no se guarda. Una visita de instalación nace de una cita (`appointment_id` único) y guarda solo result, reevaluation y sus fotos. `failure_reason` y `assignment_replacements` son de la reparación (registro de qué equipo se cambió por cuál). `ticket_id` es único: un ticket tiene una sola visita de reparación. REMOVAL: visita para recoger los equipos cuando terminó el servicio; va directo a la instalación (`installation_id`). Puede haber otra si una se canceló. `scheduling_deadline`: hasta cuándo el familiar puede agendar otra cita después de que una venció (7 días hábiles, lunes a viernes); nulo si no aplica. Una instalación `CANCELED` o `REMOVED` no impide registrar otra. Las visitas `CANCELED` quedan como registro (su cita venció o se canceló, o se cerró su ticket). `assignment_replacements`: equipos que se cambiaron en una reparación; al cambiarlos, installations reemplaza el id viejo por el nuevo. Reasignar una visita actualiza `technician_id`, `scheduled_date` y las horas.

Los ids de Assistance, IAM, Company, HCM y Assets son valores sin FK. Las FK van de appointments, tickets y las tablas de actuadores hacia installations, y de assignments hacia appointments, tickets e installations: no hay referencias circulares.


![Diagrama de base de datos - Soporte Técnico](../images/diagrams/img/chapter-5/support-database-diagram.svg)

<div style="page-break-after: always;"></div>

## 5.8. Bounded Context: Comunicaciones

En el código, este bounded context es el paquete `communication`. Communication envía todo lo que Alivia comunica a las personas, por tres canales: la alarma del pedido de auxilio (`Alert`), que suena en el celular; los avisos en la app (`Notification`), que llegan por push al celular y aparecen en la lista de avisos de la web; y los correos (`Email`), enviados con plantillas de SendGrid. Registra además los celulares de cada usuario (`PushDevice`) para enviarles push por Firebase Cloud Messaging (FCM). Communication no decide cuándo avisar: reacciona a los eventos de IAM, HCM, Assistance, Subscriptions, Support y Tracking, después del commit. Sí decide a quién y por qué canal. Una alarma o un aviso que no llegó al celular se vuelve a enviar cada minuto a los mismos destinatarios, hasta 5 intentos. Se basa en los módulos de comunicaciones de restock-web-services y veyra-backend.

### 5.8.1. Domain Layer

Este bounded context no declara Entities ni Value Objects propios.

#### Aggregates

<table>
<tr><th colspan="4" align="left"><code>Alert</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">La alarma del pedido de auxilio para un destinatario: el familiar o un cuidador de turno. Solo va a celulares (Android e iOS), con prioridad alta y un sonido parecido al de la alerta sísmica. Suena una sola vez: nadie la marca como atendida.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>recipientId</code></td><td><code>UserId</code></td><td>private</td><td>Cuenta de IAM que recibe la alarma.</td></tr>
<tr><td><code>helpRequestId</code></td><td><code>String</code></td><td>private</td><td>Pedido de auxilio de Tracking (id de MongoDB), para que la app muestre el detalle.</td></tr>
<tr><td><code>title</code></td><td><code>String</code></td><td>private</td><td>Título de la alarma.</td></tr>
<tr><td><code>body</code></td><td><code>String</code></td><td>private</td><td>Texto de la alarma.</td></tr>
<tr><td><code>status</code></td><td><code>AlertStatus</code></td><td>private</td><td><code>PENDING</code>, <code>SENT</code> o <code>UNDELIVERED</code>.</td></tr>
<tr><td><code>sentAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Cuándo FCM aceptó el envío (solo <code>SENT</code>).</td></tr>
<tr><td><code>attempts</code></td><td><code>Integer</code></td><td>private</td><td>Intentos de envío que fallaron.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Alert(UserId recipientId, String helpRequestId, String title, String body)</code></td><td>(constructor)</td><td>public</td><td>Crea la alarma <code>PENDING</code>; <code>title</code> y <code>body</code> no vacíos (<code>InvalidMessageContent</code>). Registra <code>AlertCreatedEvent</code>.</td></tr>
<tr><td><code>markSent(LocalDateTime now)</code></td><td><code>void</code></td><td>public</td><td>De <code>PENDING</code> o <code>UNDELIVERED</code> a <code>SENT</code> y guarda <code>sentAt</code>: FCM aceptó el envío a al menos un celular del destinatario.</td></tr>
<tr><td><code>markUndelivered()</code></td><td><code>void</code></td><td>public</td><td>De <code>PENDING</code> o <code>UNDELIVERED</code> a <code>UNDELIVERED</code> y suma 1 a <code>attempts</code>: el destinatario no tiene celular registrado o FCM rechazó todos sus envíos.</td></tr>
<tr><td><code>canRetry(Integer maxAttempts)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si está <code>UNDELIVERED</code> y <code>attempts</code> es menor que <code>maxAttempts</code>. La usa el reintento programado.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Las transiciones no permitidas lanzan <code>InvalidAlertStatusTransition</code>.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>AlertStatus</code></td><td>0..* a 1</td><td><code>PENDING</code>, <code>SENT</code> o <code>UNDELIVERED</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Notification</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Un aviso en la app para un usuario. En el celular llega por push (app abierta o cerrada); en la web aparece en la lista de avisos al abrir la plataforma.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>recipientId</code></td><td><code>UserId</code></td><td>private</td><td>Cuenta de IAM que recibe el aviso.</td></tr>
<tr><td><code>type</code></td><td><code>NotificationType</code></td><td>private</td><td>Motivo del aviso.</td></tr>
<tr><td><code>sourceId</code></td><td><code>String</code></td><td>private</td><td>Id de lo que originó el aviso (reporte de Tracking, edge, invitación, pago, suscripción, instalación o visita), para que la app abra su detalle. Es texto porque Tracking usa ids de MongoDB.</td></tr>
<tr><td><code>title</code></td><td><code>String</code></td><td>private</td><td>Título del aviso.</td></tr>
<tr><td><code>body</code></td><td><code>String</code></td><td>private</td><td>Texto del aviso.</td></tr>
<tr><td><code>status</code></td><td><code>NotificationStatus</code></td><td>private</td><td><code>UNREAD</code> o <code>READ</code>.</td></tr>
<tr><td><code>readAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Cuándo se leyó (solo <code>READ</code>).</td></tr>
<tr><td><code>pushStatus</code></td><td><code>PushStatus</code></td><td>private</td><td>Resultado del envío al celular, aparte de leído o no leído.</td></tr>
<tr><td><code>pushAttempts</code></td><td><code>Integer</code></td><td>private</td><td>Intentos de envío al celular que fallaron.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Notification(UserId recipientId, NotificationType type, String sourceId, String title, String body)</code></td><td>(constructor)</td><td>public</td><td>Crea el aviso <code>UNREAD</code> con <code>pushStatus</code> <code>PENDING</code>; <code>title</code> y <code>body</code> no vacíos (<code>InvalidMessageContent</code>). Registra <code>NotificationCreatedEvent</code>.</td></tr>
<tr><td><code>markAsRead(UserId userId, LocalDateTime now)</code></td><td><code>void</code></td><td>public</td><td>Solo su destinatario (<code>NotificationNotForUser</code>): pasa a <code>READ</code> y guarda <code>readAt</code>. Si ya estaba <code>READ</code>, no cambia nada.</td></tr>
<tr><td><code>markPushSent()</code></td><td><code>void</code></td><td>public</td><td><code>pushStatus</code> de <code>PENDING</code> o <code>UNDELIVERED</code> a <code>SENT</code>.</td></tr>
<tr><td><code>markPushUndelivered()</code></td><td><code>void</code></td><td>public</td><td><code>pushStatus</code> de <code>PENDING</code> o <code>UNDELIVERED</code> a <code>UNDELIVERED</code>; suma 1 a <code>pushAttempts</code>.</td></tr>
<tr><td><code>canRetryPush(Integer maxAttempts)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si <code>pushStatus</code> es <code>UNDELIVERED</code> y <code>pushAttempts</code> es menor que <code>maxAttempts</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Si el push no llega, el aviso igual queda en la app.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>type</code>)</td><td><code>NotificationType</code></td><td>0..* a 1</td><td>Motivo del aviso.</td></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>NotificationStatus</code></td><td>0..* a 1</td><td><code>UNREAD</code> o <code>READ</code>.</td></tr>
<tr><td>Asociación dirigida (<code>pushStatus</code>)</td><td><code>PushStatus</code></td><td>0..* a 1</td><td>Resultado del envío al celular, aparte de leído o no leído.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Email</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Un correo enviado por SendGrid, con su plantilla y su resultado. Las variables no se guardan: algunas son secretas (código de verificación, contraseña temporal, enlaces); solo viajan al envío.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>EmailAddress</code></td><td>private</td><td>Correo destino.</td></tr>
<tr><td><code>template</code></td><td><code>EmailTemplate</code></td><td>private</td><td>Plantilla de SendGrid.</td></tr>
<tr><td><code>status</code></td><td><code>EmailStatus</code></td><td>private</td><td><code>PENDING</code>, <code>SENT</code> o <code>FAILED</code>.</td></tr>
<tr><td><code>sentAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Cuándo se envió (solo <code>SENT</code>).</td></tr>
<tr><td><code>failureReason</code></td><td><code>String</code></td><td>private</td><td>Motivo que devolvió SendGrid (solo <code>FAILED</code>).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Email(EmailAddress emailAddress, EmailTemplate template, Map&lt;String, String&gt; variables)</code></td><td>(constructor)</td><td>public</td><td>Crea el correo <code>PENDING</code>. <code>variables</code> trae todas las de <code>template.requiredVariables()</code> (<code>MissingTemplateVariable</code>).</td></tr>
<tr><td><code>markSent(LocalDateTime now)</code></td><td><code>void</code></td><td>public</td><td>De <code>PENDING</code> a <code>SENT</code>; guarda <code>sentAt</code>.</td></tr>
<tr><td><code>markFailed(String failureReason)</code></td><td><code>void</code></td><td>public</td><td>De <code>PENDING</code> a <code>FAILED</code>; guarda el motivo (no vacío).</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Las transiciones no permitidas lanzan <code>InvalidEmailStatusTransition</code>.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>template</code>)</td><td><code>EmailTemplate</code></td><td>0..* a 1</td><td>Plantilla de SendGrid.</td></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>EmailStatus</code></td><td>0..* a 1</td><td><code>PENDING</code>, <code>SENT</code> o <code>FAILED</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PushDevice</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Un celular donde el usuario inició sesión en la app móvil y que recibe push. La web no registra dispositivos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>UserId</code></td><td>private</td><td>Cuenta de IAM dueña del celular.</td></tr>
<tr><td><code>token</code></td><td><code>String</code></td><td>private</td><td>Registration token que FCM le da a la app. Único.</td></tr>
<tr><td><code>platform</code></td><td><code>PushPlatform</code></td><td>private</td><td><code>ANDROID</code> o <code>IOS</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PushDevice(UserId userId, String token, PushPlatform platform)</code></td><td>(constructor)</td><td>public</td><td>Registra el celular; el token no está vacío (<code>InvalidPushToken</code>).</td></tr>
<tr><td><code>reassignTo(UserId userId, PushPlatform platform)</code></td><td><code>void</code></td><td>public</td><td>El token ya estaba registrado con otra cuenta (en ese celular entró otro usuario): pasa al nuevo usuario, así no recibe avisos de la anterior.</td></tr>
<tr><td><code>belongsTo(UserId userId)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el celular es de ese usuario. La usa <code>UnregisterPushDeviceCommand</code> (<code>PushDeviceNotForUser</code>).</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>platform</code>)</td><td><code>PushPlatform</code></td><td>0..* a 1</td><td><code>ANDROID</code> o <code>IOS</code>.</td></tr>
</table>

#### Enumerations

<table>
<tr><th colspan="4" align="left"><code>NotificationType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Motivo de un aviso en la app.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td><code>LOW_BATTERY</code></td><td colspan="3">Un dispositivo llegó a 10 % o a 5 % de batería.</td></tr>
<tr><td><code>ACTUATOR_FAILURE</code></td><td colspan="3">Un actuador no pudo abrir, cerrar, prender o apagar.</td></tr>
<tr><td><code>CAREGIVER_INVITATION</code></td><td colspan="3">Invitación a un cuidador que ya tiene cuenta; la acepta desde la app.</td></tr>
<tr><td><code>PAYMENT_FAILED</code></td><td colspan="3">Falló el cobro de la suscripción. También va por correo.</td></tr>
<tr><td><code>SUBSCRIPTION_REFUNDED</code></td><td colspan="3">Se devolvió el pago. También va por correo.</td></tr>
<tr><td><code>INSTALLATION_REJECTED</code></td><td colspan="3">El hogar no cumplió en la primera evaluación. También va por correo.</td></tr>
<tr><td><code>INSTALLATION_CANCELED</code></td><td colspan="3">Se canceló la instalación por no agendar otra cita a tiempo. También va por correo.</td></tr>
<tr><td><code>HELP_REQUEST_DELAYED</code></td><td colspan="3">Pedido de auxilio que llegó tarde; dice la hora en que se pidió.</td></tr>
<tr><td><code>EDGE_DISCONNECTED</code></td><td colspan="3">No se recibe señal del sistema de la casa desde una hora. Solo al familiar.</td></tr>
<tr><td><code>EDGE_RECONNECTED</code></td><td colspan="3">Volvió la señal del sistema de la casa. Solo al familiar.</td></tr>
<tr><td><code>ASSIGNMENT_CREATED</code></td><td colspan="3">Al técnico, con la fecha y las horas de la visita (instalación, reparación o retiro), también cuando se le reasigna.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PushStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Resultado del envío de un aviso al celular.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>PENDING</code>, <code>SENT</code>, <code>UNDELIVERED</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AlertStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Resultado del envío de una alarma.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>PENDING</code>, <code>SENT</code>, <code>UNDELIVERED</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>NotificationStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Si el destinatario leyó el aviso.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>UNREAD</code>, <code>READ</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Resultado del envío de un correo.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>PENDING</code>, <code>SENT</code>, <code>FAILED</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PushPlatform</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Plataforma del celular.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>ANDROID</code>, <code>IOS</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailTemplate</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Plantillas de correo. El asunto y el HTML viven en SendGrid (dynamic template); el dominio solo nombra la plantilla y sus variables obligatorias.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td><code>VERIFICATION_CODE</code></td><td colspan="3">Código para verificar el correo. Variable: <code>code</code>.</td></tr>
<tr><td><code>CORPORATE_ACCOUNT</code></td><td colspan="3">Bienvenida del empleado con su contraseña temporal. Variable: <code>temporaryPassword</code>.</td></tr>
<tr><td><code>RESET_PASSWORD</code></td><td colspan="3">Enlace de recuperación. Variable: <code>resetUrl</code>.</td></tr>
<tr><td><code>CAREGIVER_INVITATION</code></td><td colspan="3">Invitación al cuidador sin cuenta. Variable: <code>passwordSetupUrl</code>.</td></tr>
<tr><td><code>SUBSCRIPTION_WELCOME</code></td><td colspan="3">Bienvenida al familiar al activarse la suscripción. Variable: <code>plan</code>.</td></tr>
<tr><td><code>PAYMENT_FAILED</code></td><td colspan="3">Cobro fallido. Variable: <code>failureMessage</code>.</td></tr>
<tr><td><code>SUBSCRIPTION_REFUNDED</code></td><td colspan="3">Devolución del pago. Variable: <code>amount</code> (en soles).</td></tr>
<tr><td><code>INSTALLATION_REJECTED</code></td><td colspan="3">Instalación rechazada. Sin variables.</td></tr>
<tr><td><code>INSTALLATION_CANCELED</code></td><td colspan="3">Instalación cancelada por no agendar otra cita. Sin variables.</td></tr>
<tr><td><code>EMPLOYEE_SUSPENDED</code></td><td colspan="3">Suspensión del empleado. Sin variables.</td></tr>
<tr><td><code>EMPLOYEE_REINSTATED</code></td><td colspan="3">Reincorporación del empleado. Sin variables.</td></tr>
<tr><td><code>EMPLOYEE_TERMINATED</code></td><td colspan="3">Cese del empleado. Sin variables.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>requiredVariables()</code></td><td><code>Set&lt;String&gt;</code></td><td>public</td><td>Variables obligatorias de la plantilla. La usa el constructor de <code>Email</code>.</td></tr>
</table>

#### Domain Events

<table>
<tr><th colspan="4" align="left"><code>AlertCreatedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que se guardó una alarma y hay que enviarla.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>alert</code></td><td><code>Alert</code></td><td>private</td><td>Alarma que originó el evento; su id se lee al publicarse.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AlertCreatedEvent(Alert alert)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con el aggregate que lo registra.</td></tr>
<tr><td><code>getAlertId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>alertId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Alert.constructor</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>SendAlertCommand</code>, después del commit, para que la alarma quede guardada aunque FCM falle. Ningún otro contexto lo consume.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Se registra en el constructor de <code>Alert</code>, cuando aún no hay id.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>NotificationCreatedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que se guardó un aviso y hay que enviarlo al celular.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>notification</code></td><td><code>Notification</code></td><td>private</td><td>Aviso que originó el evento; su id se lee al publicarse.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>NotificationCreatedEvent(Notification notification)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con el aggregate que lo registra.</td></tr>
<tr><td><code>getNotificationId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>notificationId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Notification.constructor</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>SendPushNotificationCommand</code>, después del commit. Ningún otro contexto lo consume.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Se registra en el constructor de <code>Notification</code>, cuando aún no hay id.</td></tr>
</table>

#### Commands

<table>
<tr><th colspan="4" align="left"><code>CreateAlertCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea la alarma de un pedido de auxilio para un destinatario. Solo lo usa la capa de aplicación al recibir <code>HelpRequestedEvent</code>; no se expone en la API.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>recipientUserId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta de IAM del destinatario.</td></tr>
<tr><td><code>helpRequestId</code></td><td><code>String</code></td><td>private final</td><td>Pedido de auxilio de Tracking.</td></tr>
<tr><td><code>title</code></td><td><code>String</code></td><td>private final</td><td>Título de la alarma.</td></tr>
<tr><td><code>body</code></td><td><code>String</code></td><td>private final</td><td>Texto de la alarma.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateAlertCommand(Long recipientUserId, String helpRequestId, String title, String body)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AlertCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Uno por destinatario. Si el evento llega 5 minutos o más después de <code>occurredAt</code>, no crea <code>Alert</code>: crea una <code>Notification</code> <code>HELP_REQUEST_DELAYED</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SendAlertCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Envía la alarma por FCM a cada celular del destinatario. Lo activa <code>AlertCreatedEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>alertId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la alarma.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SendAlertCommand(Long alertId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AlertCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lo activa <code>AlertCreatedEvent</code> después de guardar. La alerta existe (<code>AlertNotFound</code>). Envía a cada <code>PushDevice</code> del destinatario por FCM, con prioridad alta y como alarma: en Android, el canal de alarma de la app (sonido tipo alerta sísmica, importancia máxima); en iOS, Critical <code>Alert</code> con sonido propio (necesita el permiso de Apple; sin él, interruption level time-sensitive). Si FCM aceptó al menos un envío, <code>markSent</code>. Un error temporal de FCM (UNAVAILABLE, INTERNAL) se reintenta hasta 3 veces con espera creciente. Si no tiene celular o todos fallaron, <code>markUndelivered</code>; la alarma queda en el historial. Un token que FCM da por inválido (UNREGISTERED): <code>UnregisterPushDeviceCommand</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateNotificationCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea un aviso para un destinatario. Solo lo usa la capa de aplicación al reaccionar a un evento de otro contexto; no se expone en la API.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>recipientUserId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta de IAM del destinatario.</td></tr>
<tr><td><code>type</code></td><td><code>NotificationType</code></td><td>private final</td><td>Motivo del aviso.</td></tr>
<tr><td><code>sourceId</code></td><td><code>String</code></td><td>private final</td><td>Id de lo que originó el aviso.</td></tr>
<tr><td><code>title</code></td><td><code>String</code></td><td>private final</td><td>Título del aviso.</td></tr>
<tr><td><code>body</code></td><td><code>String</code></td><td>private final</td><td>Texto del aviso.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateNotificationCommand(Long recipientUserId, NotificationType type, String sourceId, String title, String body)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>NotificationCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Uno por destinatario.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SendPushNotificationCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Envía el aviso por push a cada celular del destinatario. Lo activa <code>NotificationCreatedEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>notificationId</code></td><td><code>Long</code></td><td>private final</td><td>Id del aviso.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SendPushNotificationCommand(Long notificationId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>NotificationCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lo activa <code>NotificationCreatedEvent</code> después de guardar. La notificación existe (<code>NotificationNotFound</code>). Envía un push normal a cada <code>PushDevice</code> del destinatario. Si un envío falla no detiene los demás: el aviso ya está en la app. Token inválido: <code>UnregisterPushDeviceCommand</code>. Si FCM aceptó al menos un envío, <code>markPushSent</code>; si no tiene celular o todos fallaron, <code>markPushUndelivered</code>: el aviso queda en la app (y en la web al abrirla).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RetryUndeliveredAlertsCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Vuelve a enviar las alarmas que no llegaron. Lo ejecuta el proceso programado cada minuto.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>maxAttempts</code></td><td><code>Integer</code></td><td>private final</td><td>Máximo de intentos en total (5, ajustable por configuración).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RetryUndeliveredAlertsCommand(Integer maxAttempts)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>AlertCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lo ejecuta cada minuto el proceso programado. Vuelve a enviar cada alerta <code>UNDELIVERED</code> con <code>canRetry</code> (hasta 5 intentos en total) al mismo destinatario: el familiar o el cuidador de turno en <code>occurredAt</code>, sin volver a calcularlos. Mismas reglas de envío que SendAlert. Si entretanto el destinatario registró su celular, ahora le llega.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RetryUndeliveredPushNotificationsCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Vuelve a enviar los avisos que no llegaron al celular. Lo ejecuta el proceso programado cada minuto.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>maxAttempts</code></td><td><code>Integer</code></td><td>private final</td><td>Máximo de intentos en total (5, ajustable por configuración).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RetryUndeliveredPushNotificationsCommand(Integer maxAttempts)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>NotificationCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Cada minuto, el proceso programado vuelve a enviar el push de cada notificación <code>UNDELIVERED</code> con <code>canRetryPush</code> (hasta 5 intentos en total) al mismo destinatario.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>MarkNotificationAsReadCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El destinatario marca un aviso como leído.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>notificationId</code></td><td><code>Long</code></td><td>private final</td><td>Id del aviso.</td></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta que lo marca (sale de la sesión).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>MarkNotificationAsReadCommand(Long notificationId, Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>NotificationCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lo envía el destinatario; <code>userId</code> sale de la sesión. La notificación existe (<code>NotificationNotFound</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SendEmailCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Envía un correo con una plantilla y sus variables. Solo lo usa la capa de aplicación al reaccionar a un evento; no se expone en la API.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo destino.</td></tr>
<tr><td><code>template</code></td><td><code>EmailTemplate</code></td><td>private final</td><td>Plantilla de SendGrid.</td></tr>
<tr><td><code>variables</code></td><td><code>Map&lt;String, String&gt;</code></td><td>private final</td><td>Variables de la plantilla. No se guardan.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SendEmailCommand(String emailAddress, EmailTemplate template, Map&lt;String, String&gt; variables)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EmailCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Solo lo usa la capa de aplicación al reaccionar a un evento; no se expone en la API. <code>emailAddress</code> es válido (<code>EmailAddress</code> de Shared). Crea el <code>Email</code> <code>PENDING</code> y lo guarda; envía la plantilla con sus variables por SendGrid; según la respuesta, <code>markSent</code> o <code>markFailed</code>. Un fallo no lanza error: queda <code>FAILED</code> con su motivo. El correo destino lo trae el evento (IAM, invitación) o la capa de aplicación lo busca en IAM con el <code>userId</code> (<code>GetUserByIdQuery</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RegisterPushDeviceCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">La app móvil registra el celular al iniciar sesión y cada vez que FCM le renueva el token.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta que inició sesión.</td></tr>
<tr><td><code>token</code></td><td><code>String</code></td><td>private final</td><td>Registration token de FCM.</td></tr>
<tr><td><code>platform</code></td><td><code>PushPlatform</code></td><td>private final</td><td><code>ANDROID</code> o <code>IOS</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RegisterPushDeviceCommand(Long userId, String token, PushPlatform platform)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>PushDeviceCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La app móvil lo envía al iniciar sesión y cada vez que FCM le renueva el token; <code>userId</code> sale de la sesión. Si el token ya existe llama a <code>reassignTo</code>; si no, crea el <code>PushDevice</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UnregisterPushDeviceCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Borra un celular al cerrar sesión o cuando FCM da su token por inválido.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta dueña del celular.</td></tr>
<tr><td><code>token</code></td><td><code>String</code></td><td>private final</td><td>Registration token de FCM.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UnregisterPushDeviceCommand(Long userId, String token)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>PushDeviceCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Al cerrar sesión, o cuando FCM da el token por inválido. El dispositivo existe (<code>PushDeviceNotFound</code>) y es de ese usuario (<code>PushDeviceNotForUser</code>). Se borra: no se guarda historial de dispositivos.</td></tr>
</table>

#### Queries

<table>
<tr><th colspan="4" align="left"><code>GetAllAlertsByUserIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Alarmas que recibió el usuario, de la más reciente a la más antigua (historial en la app móvil).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta del usuario (sale de la sesión).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllAlertsByUserIdQuery(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Alert&gt;</code> (<code>AlertQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetNotificationByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Aviso por id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>notificationId</code></td><td><code>Long</code></td><td>private final</td><td>Id del aviso.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetNotificationByIdQuery(Long notificationId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Notification&gt;</code> (<code>NotificationQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllNotificationsByUserIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Avisos del usuario que inició sesión, del más reciente al más antiguo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta del usuario (sale de la sesión).</td></tr>
<tr><td><code>status</code></td><td><code>NotificationStatus</code></td><td>private final</td><td>Filtro opcional por estado (nulo: todos).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllNotificationsByUserIdQuery(Long userId, NotificationStatus status)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Notification&gt;</code> (<code>NotificationQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllEmailsByStatusQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Correos en un estado. El administrador ve los <code>FAILED</code> para revisar el problema (por ejemplo, para renovar la contraseña temporal de un empleado que no la recibió).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>status</code></td><td><code>EmailStatus</code></td><td>private final</td><td>Estado de los correos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllEmailsByStatusQuery(EmailStatus status)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Email&gt;</code> (<code>EmailQueryService</code>)</td></tr>
</table>

#### Domain Services

<table>
<tr><th colspan="4" align="left"><code>AlertCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Alert</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateAlertCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateAlertCommand</code> y devuelve el id de la alarma.</td></tr>
<tr><td><code>handle(SendAlertCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>SendAlertCommand</code>.</td></tr>
<tr><td><code>handle(RetryUndeliveredAlertsCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>RetryUndeliveredAlertsCommand</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AlertQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Alert</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetAllAlertsByUserIdQuery query)</code></td><td><code>List&lt;Alert&gt;</code></td><td>public</td><td>Resuelve <code>GetAllAlertsByUserIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>NotificationCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Notification</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateNotificationCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateNotificationCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(SendPushNotificationCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>SendPushNotificationCommand</code>.</td></tr>
<tr><td><code>handle(RetryUndeliveredPushNotificationsCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>RetryUndeliveredPushNotificationsCommand</code>.</td></tr>
<tr><td><code>handle(MarkNotificationAsReadCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>MarkNotificationAsReadCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>NotificationQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Notification</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetNotificationByIdQuery query)</code></td><td><code>Optional&lt;Notification&gt;</code></td><td>public</td><td>Resuelve <code>GetNotificationByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetAllNotificationsByUserIdQuery query)</code></td><td><code>List&lt;Notification&gt;</code></td><td>public</td><td>Resuelve <code>GetAllNotificationsByUserIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Email</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(SendEmailCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>SendEmailCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Email</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetAllEmailsByStatusQuery query)</code></td><td><code>List&lt;Email&gt;</code></td><td>public</td><td>Resuelve <code>GetAllEmailsByStatusQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PushDeviceCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>PushDevice</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(RegisterPushDeviceCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>RegisterPushDeviceCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(UnregisterPushDeviceCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>UnregisterPushDeviceCommand</code>.</td></tr>
</table>

#### Exceptions

<table>
<tr><th colspan="4" align="left"><code>AlertNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe la alarma indicada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AlertNotFound(Long alertId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidAlertStatusTransition</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el cambio de estado de la alarma no está permitido.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidAlertStatusTransition(AlertStatus from, AlertStatus to)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>NotificationNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe el aviso indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>NotificationNotFound(Long notificationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>NotificationNotForUser</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando quien marca el aviso como leído no es su destinatario.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>NotificationNotForUser(Long notificationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidMessageContent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el título o el texto de una alarma o un aviso está vacío.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidMessageContent()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>MissingTemplateVariable</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando falta una variable obligatoria de la plantilla.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>MissingTemplateVariable(EmailTemplate template, String variable)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidEmailStatusTransition</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el cambio de estado del correo no está permitido.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidEmailStatusTransition(EmailStatus from, EmailStatus to)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidPushToken</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el token de FCM está vacío.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidPushToken()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PushDeviceNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe un celular registrado con ese token.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PushDeviceNotFound(String token)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PushDeviceNotForUser</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el celular no es del usuario que lo quiere borrar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PushDeviceNotForUser(String token)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

#### Reglas generales del bounded context

**Qué envía Communication y a quién.** **`Alert` (`CreateAlertCommand`):** `HelpRequestedEvent` (Tracking): al familiar y a los cuidadores de turno (nota de destinatarios).

**`Notification` (`CreateNotificationCommand`):** `LowBatteryDetectedEvent` (Tracking): `LOW_BATTERY`, con el tipo de dispositivo y el nivel (a 5 %: batería crítica). `ActuatorActionFailedEvent` (Tracking): `ACTUATOR_FAILURE`, con el actuador y la acción que no se completó. `HelpRequestedEvent` atrasado: `HELP_REQUEST_DELAYED`. Los tres: al familiar y a los cuidadores de turno. `EdgeDisconnectedEvent` y `EdgeReconnectedEvent` (Tracking): `EDGE_DISCONNECTED` y `EDGE_RECONNECTED`, solo al familiar. `InvitationNotificationRequestedEvent` (Assistance): `CAREGIVER_INVITATION` al cuidador que ya tiene cuenta (lo invitan a cuidar a otra persona); `sourceId` = `invitationId`. `PaymentFailedEvent`, `SubscriptionRefundedEvent` (Subscriptions), `InstallationRejectedEvent` e `InstallationCanceledEvent` (Support): al familiar, además del correo. `InstallationAssignmentCreatedEvent`, `RepairAssignmentCreatedEvent`, `RemovalAssignmentCreatedEvent` y `AssignmentReassignedEvent` (Support): `ASSIGNMENT_CREATED` al técnico (`userId` de HCM, `GetEmployeeByIdQuery`).

**`Email` (`SendEmailCommand`):** IAM: `EmailVerificationRequestedEvent` (`VERIFICATION_CODE`), `CorporateAccountCreatedEvent` (`CORPORATE_ACCOUNT`; es la bienvenida del empleado; también `TemporaryPasswordRenewedEvent`), `PasswordResetRequestedEvent` (`RESET_PASSWORD`); el correo viene en el evento. `InvitationAccountCreatedEvent` (Assistance): `CAREGIVER_INVITATION` al cuidador sin cuenta (primera invitación: define su contraseña con el enlace). Subscriptions: `SubscriptionActivatedEvent` (`SUBSCRIPTION_WELCOME`), `PaymentFailedEvent` (`PAYMENT_FAILED`), `SubscriptionRefundedEvent` (`SUBSCRIPTION_REFUNDED`); al familiar (`userId`). Support: `InstallationRejectedEvent` (`INSTALLATION_REJECTED`) e `InstallationCanceledEvent` (`INSTALLATION_CANCELED`); al familiar (`requestedBy`). HCM: `EmployeeSuspendedEvent`, `EmployeeReinstatedEvent` y `EmployeeTerminatedEvent` (EMPLOYEE_*); al correo corporativo (`userId`).

Todos se consumen después del commit (política de eventos en Shared); los de Tracking, con `fallbackExecution`.

**Destinatarios de los avisos de Tracking (auxilio, batería y falla; los de conexión del edge van solo al familiar, paso 2).** 1. Support (ACL, `GetInstallationByIdQuery`): con el `installationId` del evento, la persona asistida.

2. Assistance (ACL): `GetAssistedPersonByIdQuery` da el familiar (`userId` de su `Relative`). `GetAgendaByAssistedPersonIdQuery` con from = el día anterior a `occurredAt` y to = el día de `occurredAt`: los `AgendaItem` que no están `CANCELLED` y cuyo horario contiene `occurredAt`.

3. Solo los cuidadores de esos items (más de uno si coinciden dos actividades), no todos los de la persona. `GetCaregiversByAssistedPersonIdQuery` da su `userId` y confirma que siguen `ACTIVE` (`Caregiver.isActive`). Sin cuidadores de turno, solo el familiar. Un item con `caregiverId` nulo es del familiar: un solo aviso.

### 5.8.2. Interface Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.8.1.

### 5.8.3. Application Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.8.1.

### 5.8.4. Infrastructure Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.8.1.

### 5.8.6. Bounded Context Software Architecture Component Level Diagrams

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.8.1.

### 5.8.7. Bounded Context Software Architecture Code Level Diagrams

#### 5.8.7.1. Bounded Context Domain Layer Class Diagrams

El diagrama muestra un aggregate por canal (`Alert`, `Notification` y `Email`) y `PushDevice`, el registro de los celulares que usan los dos primeros. Cada aggregate se asocia con sus enums de estado, tipo, plantilla o plataforma. `Alert` y `Notification` registran un evento al crearse que activa su envío por FCM dentro del contexto. Las notas detallan las reglas de cada service, qué envía Communication por cada evento de otros contextos y cómo encuentra a los destinatarios de los avisos de Tracking.

![Diagrama de clases de la capa de dominio - Comunicaciones](../images/diagrams/img/chapter-5/communication-backend-diagram.svg)

#### 5.8.7.2. Bounded Context Database Design Diagram

La base de datos es PostgreSQL.

| Tabla o colección | Aggregate, entidad o value object | Llaves y restricciones |
|---|---|---|
| `alerts` | `Alert` | PK `id`. Referencia a IAM sin FK: `recipient_user_id`. Referencia a Tracking sin FK: `help_request_id`. IDX (`recipient_user_id`, `created_at DESC`). IDX (`status`, `attempts`): alertas por reintentar. |
| `notifications` | `Notification` | PK `id`. Referencia a IAM sin FK: `recipient_user_id`. IDX (`recipient_user_id`, `status`, `created_at DESC`). IDX (`push_status`, `push_attempts`): avisos por reintentar. |
| `emails` | `Email` | PK `id`. IDX (`status`, `created_at DESC`). |
| `push_devices` | `PushDevice` | PK `id`. UK `token`. Referencia a IAM sin FK: `user_id`. |

**PostgreSQL**.

alerts: una alarma por destinatario de cada pedido de auxilio. `help_request_id` es el id de MongoDB del `HelpRequest`. `sent_at` solo en `SENT`. IDX (`recipient_user_id`, `created_at` DESC): historial de alertas del usuario. notifications: un aviso por destinatario. `source_id` es texto porque puede ser un id de MongoDB (Tracking) o un id numérico (edge, invitación, pago, suscripción, instalación o visita). `read_at` solo en `READ`. IDX (`recipient_user_id`, status, `created_at` DESC): la lista de avisos del usuario, con o sin filtro de estado. emails: un registro por correo, sin sus variables (algunas son secretas). `failure_reason` solo en `FAILED`. IDX (status, `created_at` DESC): correos fallidos para el administrador. `push_devices`: token único (UK): un token registrado con otra cuenta se reasigna en vez de duplicarse. Solo celulares: la web no recibe push. Al cerrar sesión o si FCM da el token por inválido, la fila se borra.

`recipient_user_id` y `user_id` son ids de IAM; `help_request_id`, de Tracking: sin FK. Las cuatro tablas son independientes.


![Diagrama de base de datos - Comunicaciones](../images/diagrams/img/chapter-5/communication-database-diagram.svg)

<div style="page-break-after: always;"></div>

## 5.9. Bounded Context: Analíticas

En el código, este bounded context es el paquete `analytics`. Analytics calcula las métricas que ven el administrador y el familiar. Solo guarda lo que pasa, contado por día: contrataciones, suspensiones y ceses (HCM), nuevas suscripciones, cancelaciones, cobros y devoluciones (Subscriptions), equipos malogrados (Assets) y las acciones de los actuadores de cada instalación (Tracking). Con los días se arma cualquier periodo, un año o el total desde el inicio. El estado actual (empleados, suscripciones y equipos por estado) no se guarda: se cuenta al consultar, pidiéndolo por ACL a cada contexto dueño. Las métricas empiezan cuando empieza su dueño: un negocio desde que se creó y una instalación desde que se registró. Todo monto está en soles. Se basa en los módulos de analíticas de veyra-backend y restock-web-services.

### 5.9.1. Domain Layer

Este bounded context no declara Entities ni Domain Events propios.

#### Aggregates

<table>
<tr><th colspan="4" align="left"><code>BusinessMetric</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cuánto pasó de un tipo en un día en un negocio. Lo ve el administrador.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>BusinessId</code></td><td>private</td><td>Negocio (Company).</td></tr>
<tr><td><code>type</code></td><td><code>BusinessMetricType</code></td><td>private</td><td>Tipo de métrica.</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private</td><td>Día en que pasó, en la zona horaria global (America/Lima).</td></tr>
<tr><td><code>value</code></td><td><code>BigDecimal</code></td><td>private</td><td>Cantidad de veces, o soles en cobros y devoluciones.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessMetric(BusinessId businessId, BusinessMetricType type, LocalDate date, BigDecimal amount)</code></td><td>(constructor)</td><td>public</td><td>Crea la métrica del día con el primer evento; <code>amount</code> es mayor que 0 (<code>InvalidMetricValue</code>): 1 por contratación, suspensión, cese, suscripción, cancelación o equipo; el monto en soles en cobros y devoluciones.</td></tr>
<tr><td><code>add(BigDecimal amount)</code></td><td><code>void</code></td><td>public</td><td>Suma otro evento del mismo día, con la misma regla (<code>InvalidMetricValue</code>).</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Una sola por negocio, tipo y fecha.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>type</code>)</td><td><code>BusinessMetricType</code></td><td>0..* a 1</td><td>Tipo de métrica.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RelativeMetric</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cuántas acciones de un tipo hicieron en un día los actuadores de una instalación. La ve el familiar que registró la instalación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>InstallationId</code></td><td>private</td><td>Instalación (Support).</td></tr>
<tr><td><code>type</code></td><td><code>RelativeMetricType</code></td><td>private</td><td><code>ACTIONS_SUCCEEDED</code> o <code>ACTIONS_FAILED</code>.</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private</td><td>Día de la acción.</td></tr>
<tr><td><code>value</code></td><td><code>Long</code></td><td>private</td><td>Cantidad de acciones.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RelativeMetric(InstallationId installationId, RelativeMetricType type, LocalDate date)</code></td><td>(constructor)</td><td>public</td><td>Crea la métrica del día con <code>value</code> = 1 (la primera acción).</td></tr>
<tr><td><code>increment()</code></td><td><code>void</code></td><td>public</td><td>Suma 1.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Una sola por instalación, tipo y fecha.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>type</code>)</td><td><code>RelativeMetricType</code></td><td>0..* a 1</td><td><code>ACTIONS_SUCCEEDED</code> o <code>ACTIONS_FAILED</code>.</td></tr>
</table>

#### Value Objects

**Value objects de Shared que usa este contexto.** **`BusinessId`**: negocio de `BusinessMetric` (Company). **`InstallationId`**: instalación de `RelativeMetric` (Support). Los dos aggregates extienden `AuditableAbstractAggregateRoot`. Analytics solo guarda ids y números: nunca accede a otros contextos directamente.

<table>
<tr><th colspan="4" align="left"><code>Period</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Rango de fechas de una consulta, con ambas fechas incluidas.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>from</code></td><td><code>LocalDate</code></td><td>private final</td><td>Primer día del periodo.</td></tr>
<tr><td><code>to</code></td><td><code>LocalDate</code></td><td>private final</td><td>Último día del periodo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Period(LocalDate from, LocalDate to)</code></td><td>(constructor)</td><td>public</td><td>Valida que <code>from</code> no sea posterior a <code>to</code> (<code>InvalidPeriod</code>).</td></tr>
<tr><td><code>ofYear(Integer year)</code></td><td><code>Period</code></td><td>public static</td><td>Periodo del 1 de enero al 31 de diciembre de un año.</td></tr>
<tr><td><code>startingFrom(LocalDate start)</code></td><td><code>Period</code></td><td>public</td><td>Ajusta el periodo al día en que empezó su dueño (<code>start</code>: creación del negocio o registro de la instalación). Si <code>to</code> es anterior a <code>start</code>, no hay nada que mostrar (<code>PeriodBeforeStart</code>; ej. el año 1900). Si solo <code>from</code> es anterior, el periodo empieza en <code>start</code>. Sin <code>from</code> ni <code>to</code>, va de <code>start</code> a hoy (el total).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeCounts</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Empleados actuales de un negocio por estado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>active</code></td><td><code>Long</code></td><td>private final</td><td>Empleados <code>ACTIVE</code>.</td></tr>
<tr><td><code>suspended</code></td><td><code>Long</code></td><td>private final</td><td>Empleados <code>SUSPENDED</code>.</td></tr>
<tr><td><code>dismissed</code></td><td><code>Long</code></td><td>private final</td><td>Empleados <code>TERMINATED</code> por despido (<code>DISMISSED</code>).</td></tr>
<tr><td><code>resigned</code></td><td><code>Long</code></td><td>private final</td><td>Empleados <code>TERMINATED</code> por renuncia (<code>RESIGNED</code>).</td></tr>
<tr><td><code>total</code></td><td><code>Long</code></td><td>private final</td><td>La suma.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeCounts(Long active, Long suspended, Long dismissed, Long resigned, Long total)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SubscriptionCounts</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Suscripciones actuales de un negocio por situación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>current</code></td><td><code>Long</code></td><td>private final</td><td>Suscripciones <code>ACTIVE</code> o <code>PAST_DUE</code> (incluye las de cobro fallido hasta que Stripe las cancela, y las que están en re-evaluación), sin las que esperan su primera evaluación.</td></tr>
<tr><td><code>pendingEvaluation</code></td><td><code>Long</code></td><td>private final</td><td>Instalaciones que esperan la primera visita del técnico.</td></tr>
<tr><td><code>canceled</code></td><td><code>Long</code></td><td>private final</td><td>Suscripciones <code>CANCELED</code>.</td></tr>
<tr><td><code>total</code></td><td><code>Long</code></td><td>private final</td><td>La suma.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SubscriptionCounts(Long current, Long pendingEvaluation, Long canceled, Long total)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EquipmentCounts</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Equipos de un negocio por estado (edges, dispositivos o solo actuadores).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>available</code></td><td><code>Long</code></td><td>private final</td><td>Equipos <code>AVAILABLE</code>.</td></tr>
<tr><td><code>inUse</code></td><td><code>Long</code></td><td>private final</td><td>Equipos <code>IN_USE</code>.</td></tr>
<tr><td><code>maintenance</code></td><td><code>Long</code></td><td>private final</td><td>Equipos <code>MAINTENANCE</code>.</td></tr>
<tr><td><code>broken</code></td><td><code>Long</code></td><td>private final</td><td>Equipos <code>BROKEN</code>.</td></tr>
<tr><td><code>total</code></td><td><code>Long</code></td><td>private final</td><td>La suma.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EquipmentCounts(Long available, Long inUse, Long maintenance, Long broken, Long total)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessCurrentStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado actual del negocio por estado: empleados, suscripciones y equipos. No se guarda: se cuenta al consultar en cada contexto dueño. El frontend filtra por el estado que se quiera ver.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employees</code></td><td><code>EmployeeCounts</code></td><td>private final</td><td>Empleados por estado.</td></tr>
<tr><td><code>subscriptions</code></td><td><code>SubscriptionCounts</code></td><td>private final</td><td>Suscripciones por situación.</td></tr>
<tr><td><code>edges</code></td><td><code>EquipmentCounts</code></td><td>private final</td><td>Edges por estado.</td></tr>
<tr><td><code>devices</code></td><td><code>EquipmentCounts</code></td><td>private final</td><td>Micrófonos y actuadores por estado.</td></tr>
<tr><td><code>actuators</code></td><td><code>EquipmentCounts</code></td><td>private final</td><td>Solo actuadores por estado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessCurrentStatus(EmployeeCounts employees, SubscriptionCounts subscriptions, EquipmentCounts edges, EquipmentCounts devices, EquipmentCounts actuators)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>employees</code>)</td><td><code>EmployeeCounts</code></td><td>1 a 1</td><td>Empleados por estado.</td></tr>
<tr><td>Composición (<code>subscriptions</code>)</td><td><code>SubscriptionCounts</code></td><td>1 a 1</td><td>Suscripciones por situación.</td></tr>
<tr><td>Composición (<code>edges / devices / actuators</code>)</td><td><code>EquipmentCounts</code></td><td>1 a 3</td><td></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessPeriodReport</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Lo que pasó en el negocio en un periodo, o el total desde que existe.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>period</code></td><td><code>Period</code></td><td>private final</td><td>Periodo consultado.</td></tr>
<tr><td><code>values</code></td><td><code>Map&lt;BusinessMetricType, BigDecimal&gt;</code></td><td>private final</td><td>Suma de los días del periodo de cada tipo pedido (0 si no hubo).</td></tr>
<tr><td><code>netRevenue</code></td><td><code>BigDecimal</code></td><td>private final</td><td><code>REVENUE_COLLECTED</code> - <code>REVENUE_REFUNDED</code>, en soles; solo si se pidieron los dos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessPeriodReport(Period period, Map&lt;BusinessMetricType, BigDecimal&gt; values, BigDecimal netRevenue)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>period</code>)</td><td><code>Period</code></td><td>1 a 1</td><td>Periodo consultado.</td></tr>
<tr><td>Dependencia "suma"</td><td><code>BusinessMetric</code></td><td>No aplica</td><td></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RelativeReport</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Lo que ve el familiar: acciones de los actuadores de su instalación en un periodo, o el total desde que se registró. Suma las <code>RelativeMetric</code> del periodo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>period</code></td><td><code>Period</code></td><td>private final</td><td>Periodo consultado.</td></tr>
<tr><td><code>succeeded</code></td><td><code>Long</code></td><td>private final</td><td>Acciones completadas.</td></tr>
<tr><td><code>failed</code></td><td><code>Long</code></td><td>private final</td><td>Acciones fallidas.</td></tr>
<tr><td><code>total</code></td><td><code>Long</code></td><td>private final</td><td><code>succeeded</code> + <code>failed</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RelativeReport(Period period, Long succeeded, Long failed, Long total)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>period</code>)</td><td><code>Period</code></td><td>1 a 1</td><td>Periodo consultado.</td></tr>
<tr><td>Dependencia "suma"</td><td><code>RelativeMetric</code></td><td>No aplica</td><td></td></tr>
</table>

#### Enumerations

<table>
<tr><th colspan="4" align="left"><code>BusinessMetricType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tipos de métrica del negocio.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td><code>EMPLOYEES_HIRED</code></td><td colspan="3">Empleados contratados.</td></tr>
<tr><td><code>EMPLOYEES_SUSPENDED</code></td><td colspan="3">Empleados suspendidos.</td></tr>
<tr><td><code>EMPLOYEES_DISMISSED</code></td><td colspan="3">Empleados despedidos.</td></tr>
<tr><td><code>EMPLOYEES_RESIGNED</code></td><td colspan="3">Empleados que renunciaron.</td></tr>
<tr><td><code>SUBSCRIPTIONS_STARTED</code></td><td colspan="3">Nuevas suscripciones (primer pago).</td></tr>
<tr><td><code>SUBSCRIPTIONS_CANCELED</code></td><td colspan="3">Suscripciones canceladas, también las devueltas, que registran una sola cancelación.</td></tr>
<tr><td><code>REVENUE_COLLECTED</code></td><td colspan="3">Soles cobrados.</td></tr>
<tr><td><code>REVENUE_REFUNDED</code></td><td colspan="3">Soles devueltos.</td></tr>
<tr><td><code>EDGES_BROKEN</code></td><td colspan="3">Edges de ambos tipos marcados <code>BROKEN</code>.</td></tr>
<tr><td><code>DEVICES_BROKEN</code></td><td colspan="3">Micrófonos y actuadores marcados <code>BROKEN</code>.</td></tr>
<tr><td><code>ACTUATORS_BROKEN</code></td><td colspan="3">Solo actuadores marcados <code>BROKEN</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RelativeMetricType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tipos de métrica de una instalación.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td><code>ACTIONS_SUCCEEDED</code></td><td colspan="3">Acciones de actuadores que se completaron.</td></tr>
<tr><td><code>ACTIONS_FAILED</code></td><td colspan="3">Acciones de actuadores que fallaron.</td></tr>
</table>

#### Commands

<table>
<tr><th colspan="4" align="left"><code>RecordBusinessMetricCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Suma un evento a la métrica del día de un negocio. Solo lo activan eventos de otros contextos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Negocio del evento.</td></tr>
<tr><td><code>type</code></td><td><code>BusinessMetricType</code></td><td>private final</td><td>Tipo de métrica.</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private final</td><td>Día del evento.</td></tr>
<tr><td><code>amount</code></td><td><code>BigDecimal</code></td><td>private final</td><td>1, o el monto en soles en cobros y devoluciones.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RecordBusinessMetricCommand(Long businessId, BusinessMetricType type, LocalDate date, BigDecimal amount)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>BusinessMetricCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Si ya hay una métrica de ese negocio, tipo y fecha, suma (<code>add</code>); si no, la crea. <code>EmployeeHiredEvent</code> (HCM): <code>EMPLOYEES_HIRED</code>. <code>EmployeeSuspendedEvent</code>: <code>EMPLOYEES_SUSPENDED</code>. <code>EmployeeTerminatedEvent</code>, según su motivo: <code>EMPLOYEES_DISMISSED</code> o <code>EMPLOYEES_RESIGNED</code>. <code>SubscriptionActivatedEvent</code> (Subscriptions): <code>SUBSCRIPTIONS_STARTED</code>. <code>SubscriptionCanceledEvent</code>: <code>SUBSCRIPTIONS_CANCELED</code>. <code>SubscriptionRefundedEvent</code>: <code>REVENUE_REFUNDED</code> con el monto (la cancelación ya llega por <code>SubscriptionCanceledEvent</code>). <code>PaymentSucceededEvent</code>: <code>REVENUE_COLLECTED</code> con el monto. <code>AssetStatusChangedEvent</code> (Assets) con <code>BROKEN</code>: un edge, <code>EDGES_BROKEN</code>; un micrófono, <code>DEVICES_BROKEN</code>; un actuador, <code>DEVICES_BROKEN</code> y <code>ACTUATORS_BROKEN</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RecordRelativeMetricCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Suma una acción de actuador a la métrica del día de una instalación. Lo activan eventos de Tracking.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Instalación de la acción.</td></tr>
<tr><td><code>type</code></td><td><code>RelativeMetricType</code></td><td>private final</td><td><code>ACTIONS_SUCCEEDED</code> o <code>ACTIONS_FAILED</code>.</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private final</td><td>Día de <code>occurredAt</code> de la acción.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RecordRelativeMetricCommand(Long installationId, RelativeMetricType type, LocalDate date)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>RelativeMetricCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Si ya hay una métrica de esa instalación, tipo y fecha, suma (<code>increment</code>); si no, la crea. <code>ActuatorActionSucceededEvent</code>: <code>ACTIONS_SUCCEEDED</code>; <code>ActuatorActionFailedEvent</code>: <code>ACTIONS_FAILED</code>.</td></tr>
</table>

#### Queries

<table>
<tr><th colspan="4" align="left"><code>GetBusinessCurrentStatusQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado actual del negocio del administrador.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Negocio del administrador (sale de la sesión).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetBusinessCurrentStatusQuery(Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>BusinessCurrentStatus</code> (<code>BusinessMetricQueryService</code>)</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Cuenta al consultar, por ACL: HCM (<code>GetAllEmployeesByBusinessIdQuery</code>, por estado y motivo), Subscriptions (<code>GetAllSubscriptionsByBusinessIdAndStatusQuery</code>), Support (<code>GetAllInstallationsByBusinessIdAndStatusQuery</code>: <code>PENDING_EVALUATION</code> sin equipos) y Assets (<code>GetAllEdgesByBusinessIdQuery</code> y <code>GetAllDevicesByBusinessIdQuery</code>, por tipo y estado).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetBusinessMetricsByPeriodQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Lo que pasó en el negocio del administrador en un periodo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Negocio del administrador (sale de la sesión).</td></tr>
<tr><td><code>from</code></td><td><code>LocalDate</code></td><td>private final</td><td>Primer día del periodo. Opcional.</td></tr>
<tr><td><code>to</code></td><td><code>LocalDate</code></td><td>private final</td><td>Último día del periodo. Opcional.</td></tr>
<tr><td><code>types</code></td><td><code>Set&lt;BusinessMetricType&gt;</code></td><td>private final</td><td>Tipos que se quieren ver (vacío: todos).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetBusinessMetricsByPeriodQuery(Long businessId, LocalDate from, LocalDate to, Set&lt;BusinessMetricType&gt; types)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>BusinessPeriodReport</code> (<code>BusinessMetricQueryService</code>)</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3"><code>from</code> y <code>to</code> forman el <code>Period</code> (<code>InvalidPeriod</code>); sin los dos, el total. Luego se ajusta con <code>startingFrom</code> al día de creación del negocio (<code>PeriodBeforeStart</code>). Suma las <code>BusinessMetric</code> de esos tipos en el periodo.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetRelativeMetricsByPeriodQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Acciones de los actuadores de la instalación del familiar en un periodo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Instalación consultada.</td></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta del familiar (sale de la sesión).</td></tr>
<tr><td><code>from</code></td><td><code>LocalDate</code></td><td>private final</td><td>Primer día del periodo. Opcional.</td></tr>
<tr><td><code>to</code></td><td><code>LocalDate</code></td><td>private final</td><td>Último día del periodo. Opcional.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetRelativeMetricsByPeriodQuery(Long installationId, Long userId, LocalDate from, LocalDate to)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>RelativeReport</code> (<code>RelativeMetricQueryService</code>)</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La instalación existe (Support, <code>GetInstallationByIdQuery</code>; <code>InstallationNotFound</code>) y la registró ese familiar (<code>requestedBy</code>; <code>InstallationNotOfRelative</code>). El periodo se arma igual que en <code>GetBusinessMetricsByPeriodQuery</code>, ajustado al día en que se registró la instalación.</td></tr>
</table>

#### Domain Services

**Reglas comunes de `BusinessMetricCommandService`, `RelativeMetricCommandService`.** Los dos commands solo los activan eventos de otros contextos; no se exponen en la API. date = el día del evento. Si ya hay una métrica de ese dueño, tipo y fecha, suma (add o increment); si no, la crea. Cada evento se publica una sola vez (Subscriptions ya descarta los webhooks repetidos de Stripe; Tracking, los reportes repetidos del edge). `EmployeeHiredEvent` (HCM): `EMPLOYEES_HIRED`, 1. `EmployeeSuspendedEvent`: `EMPLOYEES_SUSPENDED`, 1. `EmployeeTerminatedEvent`, según su `TerminationReason`: `EMPLOYEES_DISMISSED` o `EMPLOYEES_RESIGNED`, 1. `SubscriptionActivatedEvent` (Subscriptions): `SUBSCRIPTIONS_STARTED`, 1. `SubscriptionCanceledEvent`: `SUBSCRIPTIONS_CANCELED`, 1. `SubscriptionRefundedEvent`: `REVENUE_REFUNDED`, el monto (la cancelación ya llega por `SubscriptionCanceledEvent`). `PaymentSucceededEvent`: `REVENUE_COLLECTED`, el monto. `AssetStatusChangedEvent` (Assets) con `BROKEN`: un edge, `EDGES_BROKEN`; un micrófono, `DEVICES_BROKEN`; un actuador, `DEVICES_BROKEN` y `ACTUATORS_BROKEN`. `ActuatorActionSucceededEvent` (Tracking): `ACTIONS_SUCCEEDED`; `ActuatorActionFailedEvent`: `ACTIONS_FAILED`. date = el día de `occurredAt`.

**Reglas comunes de `BusinessMetricQueryService`, `RelativeMetricQueryService`.** **Del administrador**: `businessId` sale de la sesión (Company, `GetAdministratorByUserIdQuery` y `GetBusinessByAdministratorIdQuery`). El negocio existe (`GetBusinessByIdQuery`; `BusinessNotFound`).

<table>
<tr><th colspan="4" align="left"><code>BusinessMetricCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>BusinessMetric</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(RecordBusinessMetricCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>RecordBusinessMetricCommand</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessMetricQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>BusinessMetric</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetBusinessCurrentStatusQuery query)</code></td><td><code>BusinessCurrentStatus</code></td><td>public</td><td>Resuelve <code>GetBusinessCurrentStatusQuery</code>; devuelve los conteos actuales.</td></tr>
<tr><td><code>handle(GetBusinessMetricsByPeriodQuery query)</code></td><td><code>BusinessPeriodReport</code></td><td>public</td><td>Resuelve <code>GetBusinessMetricsByPeriodQuery</code>; devuelve el reporte del periodo.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RelativeMetricCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>RelativeMetric</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(RecordRelativeMetricCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>RecordRelativeMetricCommand</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RelativeMetricQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>RelativeMetric</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetRelativeMetricsByPeriodQuery query)</code></td><td><code>RelativeReport</code></td><td>public</td><td>Resuelve <code>GetRelativeMetricsByPeriodQuery</code>; devuelve el reporte del periodo.</td></tr>
</table>

#### Exceptions

<table>
<tr><th colspan="4" align="left"><code>InvalidPeriod</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando <code>from</code> es posterior a <code>to</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidPeriod(LocalDate from, LocalDate to)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PeriodBeforeStart</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el periodo termina antes de que empezara su dueño (el negocio o la instalación).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PeriodBeforeStart(LocalDate start)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidMetricValue</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el valor que se suma no es mayor que 0.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidMetricValue(BigDecimal value)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el negocio no existe en Company.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessNotFound(Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la instalación no existe en Support.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallationNotFound(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationNotOfRelative</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la instalación no la registró el familiar que consulta.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallationNotOfRelative(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

### 5.9.2. Interface Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.9.1.

### 5.9.3. Application Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.9.1.

### 5.9.4. Infrastructure Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.9.1.

### 5.9.6. Bounded Context Software Architecture Component Level Diagrams

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.9.1.

### 5.9.7. Bounded Context Software Architecture Code Level Diagrams

#### 5.9.7.1. Bounded Context Domain Layer Class Diagrams

El diagrama muestra los aggregates `BusinessMetric` (por negocio) y `RelativeMetric` (por instalación), cada uno con su enum de tipos. Los value objects son los resultados de las consultas: `BusinessCurrentStatus` (con `EmployeeCounts`, `SubscriptionCounts` y tres `EquipmentCounts`), `BusinessPeriodReport` y `RelativeReport`, que suman las métricas de un `Period`. Las notas detallan qué evento suma cada tipo de métrica y qué consulta cada query en otros contextos.

![Diagrama de clases de la capa de dominio - Analíticas](../images/diagrams/img/chapter-5/analytics-backend-diagram.svg)

#### 5.9.7.2. Bounded Context Database Design Diagram

La base de datos es PostgreSQL.

| Tabla o colección | Aggregate, entidad o value object | Llaves y restricciones |
|---|---|---|
| `business_metrics` | `BusinessMetric` | PK `id`. Referencia a Company sin FK: `business_id`. UK (`business_id`, `type`, `date`). CHECK value > 0. |
| `relative_metrics` | `RelativeMetric` | PK `id`. Referencia a Support sin FK: `installation_id`. UK (`installation_id`, `type`, `date`). CHECK value >= 1. |

**PostgreSQL**.

Solo se guarda lo que pasa: una fila por dueño, tipo y día con cuántas veces pasó (o cuántos soles). No hay fotos diarias: el estado actual se cuenta al consultar en cada contexto dueño. `business_metrics`: la UK respalda que un evento sume sobre la fila del día y sirve de índice para el periodo (`business_id`, type y date entre from y to). value: contadores o soles con dos decimales. `relative_metrics`: una fila por instalación, tipo y día; value cuenta las acciones (desde 1). La UK es también el índice del periodo.

`business_id` (Company) e `installation_id` (Support) no tienen FK. Las dos tablas son independientes. Los reportes no se guardan: se calculan al consultar.


![Diagrama de base de datos - Analíticas](../images/diagrams/img/chapter-5/analytics-database-diagram.svg)

<div style="page-break-after: always;"></div>

## 5.10. Bounded Context: Telemetría

En el código, este bounded context es el paquete `tracking`. Tracking recibe en la nube lo que reportan los edges del hogar y lo guarda en MongoDB. Recibe tres tipos de reporte: el pedido de auxilio de la persona asistida, que el edge de micrófono envía directo a la nube sin pasar por el broker ni por el edge de actuadores; la batería baja de un dispositivo, a 10 % y a 5 %; y cada acción que ejecuta un actuador con su resultado. Cada reporte llega completo: el edge pide a Assets la tabla de su red al arrancar y cada 30 segundos, así Tracking no consulta a Assets por cada reporte. Si se corta la conexión, el edge guarda el reporte y lo reintenta con el mismo `reportId`, que evita duplicados. Tracking también sabe qué edges están en servicio (`EdgeConnection`): rechaza los reportes de un edge fuera de servicio y avisa al familiar si un edge pasa 5 minutos sin comunicarse. Con otros contextos se relaciona solo por `EdgeId`, `DeviceId` e `InstallationId`.

### 5.10.1. Domain Layer

Este bounded context no declara Entities propios.

#### Aggregates

<table>
<tr><th colspan="4" align="left"><code>HelpRequest</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableMongoAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Pedido de auxilio de la persona asistida. Lo detecta por voz el edge de micrófono y lo envía directo a la nube. Solo informa que pidió auxilio: no guarda lo que dijo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>reportId</code></td><td><code>ReportId</code></td><td>private</td><td>Id único del reporte, generado por el edge.</td></tr>
<tr><td><code>edgeId</code></td><td><code>EdgeId</code></td><td>private</td><td><code>Edge</code> de micrófono que envió el pedido.</td></tr>
<tr><td><code>microphoneId</code></td><td><code>DeviceId</code></td><td>private</td><td>Micrófono que captó el pedido.</td></tr>
<tr><td><code>installationId</code></td><td><code>InstallationId</code></td><td>private</td><td>Instalación de la red del edge.</td></tr>
<tr><td><code>occurredAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Cuándo lo detectó el edge. <code>createdAt</code> (base) es cuándo llegó a la nube.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>HelpRequest(ReportId reportId, EdgeId edgeId, DeviceId microphoneId, InstallationId installationId, LocalDateTime occurredAt)</code></td><td>(constructor)</td><td>public</td><td>Todos los datos son obligatorios. Registra <code>HelpRequestedEvent</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Es un registro: nadie lo marca como atendido.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>reportId</code>)</td><td><code>ReportId</code></td><td>1 a 1</td><td>Id único del reporte, generado por el edge.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>LowBatteryAlert</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableMongoAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Batería baja del micrófono o de un actuador. Cada edge envía la de los dispositivos que atiende, una sola vez al llegar a 10 % y otra al llegar a 5 %.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>reportId</code></td><td><code>ReportId</code></td><td>private</td><td>Id único del reporte, generado por el edge.</td></tr>
<tr><td><code>edgeId</code></td><td><code>EdgeId</code></td><td>private</td><td><code>Edge</code> que envió la alerta.</td></tr>
<tr><td><code>deviceId</code></td><td><code>DeviceId</code></td><td>private</td><td>Dispositivo con batería baja.</td></tr>
<tr><td><code>deviceType</code></td><td><code>DeviceType</code></td><td>private</td><td>Tipo del dispositivo al momento del reporte.</td></tr>
<tr><td><code>installationId</code></td><td><code>InstallationId</code></td><td>private</td><td>Instalación de la red del edge.</td></tr>
<tr><td><code>batteryLevel</code></td><td><code>BatteryLevel</code></td><td>private</td><td>Porcentaje de batería reportado.</td></tr>
<tr><td><code>occurredAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Cuándo la detectó el edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>LowBatteryAlert(ReportId reportId, EdgeId edgeId, DeviceId deviceId, DeviceType deviceType, InstallationId installationId, BatteryLevel batteryLevel, LocalDateTime occurredAt)</code></td><td>(constructor)</td><td>public</td><td>El nivel es bajo (<code>BatteryNotLow</code>). Registra <code>LowBatteryDetectedEvent</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Es un registro: no tiene estado ni métodos de cambio.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>reportId</code>)</td><td><code>ReportId</code></td><td>1 a 1</td><td>Id único del reporte, generado por el edge.</td></tr>
<tr><td>Composición (<code>batteryLevel</code>)</td><td><code>BatteryLevel</code></td><td>1 a 1</td><td>Porcentaje de batería reportado.</td></tr>
<tr><td>Asociación dirigida (<code>deviceType</code>)</td><td><code>DeviceType</code></td><td>0..* a 1</td><td>Tipo del dispositivo al momento del reporte.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActuatorAction</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableMongoAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Una acción que ejecutó un actuador y su resultado (por ejemplo, abrir la puerta). La envía el edge de actuadores.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>reportId</code></td><td><code>ReportId</code></td><td>private</td><td>Id único del reporte, generado por el edge.</td></tr>
<tr><td><code>edgeId</code></td><td><code>EdgeId</code></td><td>private</td><td><code>Edge</code> de actuadores que envió la acción.</td></tr>
<tr><td><code>actuatorId</code></td><td><code>DeviceId</code></td><td>private</td><td>Actuador que la ejecutó.</td></tr>
<tr><td><code>actuatorType</code></td><td><code>DeviceType</code></td><td>private</td><td>Tipo del actuador al momento del reporte.</td></tr>
<tr><td><code>installationId</code></td><td><code>InstallationId</code></td><td>private</td><td>Instalación de la red del edge.</td></tr>
<tr><td><code>action</code></td><td><code>ActionType</code></td><td>private</td><td><code>OPEN</code>, <code>CLOSE</code>, <code>TURN_ON</code> o <code>TURN_OFF</code>.</td></tr>
<tr><td><code>result</code></td><td><code>ActionResult</code></td><td>private</td><td><code>SUCCEEDED</code> o <code>FAILED</code>. <code>FAILED</code> lo detecta el sensor del actuador (no se completó) o el edge (el actuador no respondió); no se guarda el motivo.</td></tr>
<tr><td><code>occurredAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Cuándo se ejecutó.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActuatorAction(ReportId reportId, EdgeId edgeId, DeviceId actuatorId, DeviceType actuatorType, InstallationId installationId, ActionType action, ActionResult result, LocalDateTime occurredAt)</code></td><td>(constructor)</td><td>public</td><td>La acción corresponde al tipo de actuador; un <code>MICROPHONE</code> no ejecuta acciones (<code>InvalidActionForDevice</code>). Si el resultado es <code>FAILED</code>, registra <code>ActuatorActionFailedEvent</code>; si es <code>SUCCEEDED</code>, <code>ActuatorActionSucceededEvent</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Es un registro: no tiene estado ni métodos de cambio. Una acción <code>SUCCEEDED</code> no avisa a nadie: solo la cuenta Analytics.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>reportId</code>)</td><td><code>ReportId</code></td><td>1 a 1</td><td>Id único del reporte, generado por el edge.</td></tr>
<tr><td>Asociación dirigida (<code>actuatorType</code>)</td><td><code>DeviceType</code></td><td>0..* a 1</td><td>Tipo del actuador al momento del reporte.</td></tr>
<tr><td>Asociación dirigida (<code>action</code>)</td><td><code>ActionType</code></td><td>0..* a 1</td><td><code>OPEN</code>, <code>CLOSE</code>, <code>TURN_ON</code> o <code>TURN_OFF</code>.</td></tr>
<tr><td>Asociación dirigida (<code>result</code>)</td><td><code>ActionResult</code></td><td>0..* a 1</td><td><code>SUCCEEDED</code> o <code>FAILED</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EdgeConnection</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableMongoAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">La conexión de un edge en servicio: en qué instalación está y cuándo se comunicó por última vez. Hay una por cada vez que un edge entra a la red de una instalación, y a lo sumo una no <code>RETIRED</code> por edge.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>EdgeId</code></td><td>private</td><td><code>Edge</code> de Assets.</td></tr>
<tr><td><code>installationId</code></td><td><code>InstallationId</code></td><td>private</td><td>Instalación de la red del edge.</td></tr>
<tr><td><code>status</code></td><td><code>ConnectionStatus</code></td><td>private</td><td><code>PENDING</code>, <code>ONLINE</code>, <code>OFFLINE</code> o <code>RETIRED</code>.</td></tr>
<tr><td><code>lastSeenAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Último reporte o latido del edge. Nulo hasta el primero.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EdgeConnection(EdgeId edgeId, InstallationId installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la conexión <code>PENDING</code> (el edge aún no se comunicó desde que entró a la red), sin <code>lastSeenAt</code>. La crea <code>StartEdgeMonitoringCommand</code>.</td></tr>
<tr><td><code>markSeen(LocalDateTime now)</code></td><td><code>void</code></td><td>public</td><td>Guarda <code>lastSeenAt</code>. <code>PENDING</code> u <code>ONLINE</code> quedan <code>ONLINE</code>; <code>OFFLINE</code> pasa a <code>ONLINE</code> y registra <code>EdgeReconnectedEvent</code>. Si está <code>RETIRED</code>, <code>EdgeNotInService</code>.</td></tr>
<tr><td><code>markOfflineIfSilent(LocalDateTime now)</code></td><td><code>void</code></td><td>public</td><td>Solo en <code>ONLINE</code>: si <code>lastSeenAt</code> tiene 5 minutos o más, pasa a <code>OFFLINE</code> y registra <code>EdgeDisconnectedEvent</code>; si no, no cambia nada. Un edge <code>PENDING</code> no pasa a <code>OFFLINE</code>: todavía se está configurando.</td></tr>
<tr><td><code>retire()</code></td><td><code>void</code></td><td>public</td><td>De cualquier estado a <code>RETIRED</code> (final): el edge salió de la red o la red se desactivó. No avisa a nadie.</td></tr>
<tr><td><code>isInService()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si está <code>PENDING</code>, <code>ONLINE</code> u <code>OFFLINE</code>.</td></tr>
<tr><td><code>belongsTo(InstallationId installationId)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el <code>installationId</code> del reporte es el de la red del edge.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Las transiciones no permitidas lanzan <code>InvalidConnectionStatusTransition</code>. Un edge sin internet no puede avisar que no tiene internet: la nube lo detecta por la falta de latido.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>ConnectionStatus</code></td><td>0..* a 1</td><td><code>PENDING</code>, <code>ONLINE</code>, <code>OFFLINE</code> o <code>RETIRED</code>.</td></tr>
</table>

#### Value Objects

**Value objects de Shared que usa este contexto.** **`EdgeId`**: edge de Assets que envió el reporte. **`DeviceId`**: dispositivo de Assets del reporte (micrófono o actuador). **`InstallationId`**: instalación de Soporte Técnico de la red del edge. **`AuditableMongoAggregateRoot`**: base de los cuatro aggregates (id de texto, `createdAt` y eventos). Tracking solo guarda ids: nunca accede a esos contextos directamente.

<table>
<tr><th colspan="4" align="left"><code>ReportId</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Id único de un reporte, generado por el edge (<code>UUID</code>). Sirve para no guardar dos veces un reporte que el edge reintentó al cortarse la conexión.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>reportId</code></td><td><code>String</code></td><td>private final</td><td><code>UUID</code> del reporte.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ReportId(String reportId)</code></td><td>(constructor)</td><td>public</td><td>Valida que tenga formato <code>UUID</code> (<code>InvalidReportId</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BatteryLevel</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Porcentaje de batería de un dispositivo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>percentage</code></td><td><code>Integer</code></td><td>private final</td><td>Porcentaje entre 0 y 100.</td></tr>
<tr><td><code>LOW_THRESHOLD</code></td><td><code>Integer</code></td><td>public static final</td><td>Umbral de batería baja: 10.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BatteryLevel(Integer percentage)</code></td><td>(constructor)</td><td>public</td><td>Valida que esté entre 0 y 100 (<code>InvalidBatteryLevel</code>).</td></tr>
<tr><td><code>isLow()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si <code>percentage</code> es menor o igual a <code>LOW_THRESHOLD</code> (10 %). Lo usa el constructor de <code>LowBatteryAlert</code> (<code>BatteryNotLow</code>). El edge avisa a 10 % y a 5 %: los dos son bajos.</td></tr>
</table>

#### Enumerations

<table>
<tr><th colspan="4" align="left"><code>DeviceType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tipo de dispositivo. Es una copia propia de Tracking con los mismos valores que <code>DeviceType</code> de Assets: guarda el tipo al momento del reporte, así el historial no cambia si luego el equipo se retira de la red. <code>MICROPHONE</code> es el sensor; los demás son actuadores.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>MICROPHONE</code>, <code>DOOR</code>, <code>WINDOW</code>, <code>CURTAIN</code>, <code>LIGHT</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActionType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Acción de un actuador.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>OPEN</code>, <code>CLOSE</code>, <code>TURN_ON</code>, <code>TURN_OFF</code></td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>isValidFor(DeviceType type)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la acción corresponde al tipo: <code>OPEN</code> y <code>CLOSE</code> para <code>DOOR</code>, <code>WINDOW</code> y <code>CURTAIN</code>; <code>TURN_ON</code> y <code>TURN_OFF</code> para <code>LIGHT</code>; ninguna para <code>MICROPHONE</code>.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Dependencia "<code>isValidFor</code>"</td><td><code>DeviceType</code></td><td>No aplica</td><td></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActionResult</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Resultado de la acción.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>SUCCEEDED</code>, <code>FAILED</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ConnectionStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de la conexión de un edge. <code>RETIRED</code> es final.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td><code>PENDING</code></td><td colspan="3">Entró a la red y aún no se comunica.</td></tr>
<tr><td><code>ONLINE</code></td><td colspan="3">Se comunica.</td></tr>
<tr><td><code>OFFLINE</code></td><td colspan="3">Pasó 5 minutos o más sin comunicarse.</td></tr>
<tr><td><code>RETIRED</code></td><td colspan="3">Salió de la red o la red se desactivó.</td></tr>
</table>

#### Domain Events

HelpRequested, LowBatteryDetected y ActuatorActionFailed los consume Communication. ActuatorActionFailed y ActuatorActionSucceeded, Analytics (acciones de la instalación por día). Leen el id al publicarse, porque MongoDB lo asigna al guardar. EdgeDisconnected y EdgeReconnected son Record: se registran sobre una `EdgeConnection` ya guardada. Los consume Communication: solo al familiar, con una notificación al teléfono.

**A quién avisa Communication.** `HelpRequestedEvent`: al familiar y al cuidador asignado en ese momento. Si llega 5 minutos o más después de `occurredAt` (estuvo guardado en el edge sin internet), no suena como alarma: llega como notificación a los mismos destinatarios. `LowBatteryDetectedEvent`: al familiar y al cuidador asignado en ese momento, para que cargue el dispositivo. `ActuatorActionFailedEvent`: al familiar y al cuidador asignado en ese momento: el actuador no pudo abrir, cerrar, prender o apagar. "En ese momento" = `occurredAt` del reporte.

**Cómo encuentra a quién avisar.** 1. `installationId`: Support (`GetInstallationByIdQuery`) da la persona asistida.

2. Assistance: `GetAssistedPersonByIdQuery` da el familiar. `GetAgendaByAssistedPersonIdQuery` con from = el día anterior a `occurredAt` y to = el día de `occurredAt` (una ocurrencia que cruza medianoche pertenece al día en que empieza). De esos `AgendaItem` se toman los que no están `CANCELLED` y cuyo horario (`occurrenceStart` a `occurrenceEnd`) contiene `occurredAt`. Se compara con `occurredAt` y no con el status, porque el status se calcula con la hora de la consulta y un reporte reintentado llega tarde.

3. Solo se avisa a los cuidadores de esos items (puede haber más de uno si coinciden dos actividades), no a todos los cuidadores de la persona asistida. `GetCaregiversByAssistedPersonIdQuery` solo sirve para obtener su `userId` y confirmar que siguen `ACTIVE` (`Caregiver.isActive`). Si ningún cuidador tiene una ocurrencia en ese momento, solo se avisa al familiar. Un item con `caregiverId` nulo es del familiar: recibe un solo aviso.

<table>
<tr><th colspan="4" align="left"><code>HelpRequestedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que la persona asistida pidió auxilio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>helpRequest</code></td><td><code>HelpRequest</code></td><td>private</td><td>Pedido de auxilio que registró el evento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>HelpRequestedEvent(HelpRequest helpRequest)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><code>getHelpRequestId()</code></td><td><code>String</code></td><td>public</td><td>Devuelve <code>helpRequestId</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getEdgeId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>edgeId</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getMicrophoneId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>microphoneId</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getInstallationId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>installationId</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getOccurredAt()</code></td><td><code>LocalDateTime</code></td><td>public</td><td>Devuelve <code>occurredAt</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>HelpRequest.constructor</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Communication avisa al familiar y a los cuidadores de turno en <code>occurredAt</code> con una alarma (<code>CreateAlertCommand</code>); si llega 5 minutos o más tarde (estuvo guardado en el edge sin internet), con un aviso <code>HELP_REQUEST_DELAYED</code>. Después del commit, con <code>fallbackExecution</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lee el id al publicarse, porque MongoDB lo asigna al guardar.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>LowBatteryDetectedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que un dispositivo tiene batería baja.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>alert</code></td><td><code>LowBatteryAlert</code></td><td>private</td><td>Alerta de batería que registró el evento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>LowBatteryDetectedEvent(LowBatteryAlert alert)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><code>getAlertId()</code></td><td><code>String</code></td><td>public</td><td>Devuelve <code>alertId</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getEdgeId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>edgeId</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getDeviceId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>deviceId</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getDeviceType()</code></td><td><code>DeviceType</code></td><td>public</td><td>Devuelve <code>deviceType</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getInstallationId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>installationId</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getBatteryLevel()</code></td><td><code>Integer</code></td><td>public</td><td>Devuelve <code>batteryLevel</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getOccurredAt()</code></td><td><code>LocalDateTime</code></td><td>public</td><td>Devuelve <code>occurredAt</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>LowBatteryAlert.constructor</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Communication avisa al familiar y a los cuidadores de turno en <code>occurredAt</code> para que carguen el dispositivo (<code>LOW_BATTERY</code>). Después del commit, con <code>fallbackExecution</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lee el id al publicarse, porque MongoDB lo asigna al guardar.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActuatorActionFailedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que un actuador no pudo abrir, cerrar, prender o apagar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>action</code></td><td><code>ActuatorAction</code></td><td>private</td><td>Acción fallida que registró el evento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActuatorActionFailedEvent(ActuatorAction action)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><code>getActionId()</code></td><td><code>String</code></td><td>public</td><td>Devuelve <code>actionId</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getEdgeId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>edgeId</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getActuatorId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>actuatorId</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getActuatorType()</code></td><td><code>DeviceType</code></td><td>public</td><td>Devuelve <code>actuatorType</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getInstallationId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>installationId</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getAction()</code></td><td><code>ActionType</code></td><td>public</td><td>Devuelve <code>action</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getOccurredAt()</code></td><td><code>LocalDateTime</code></td><td>public</td><td>Devuelve <code>occurredAt</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>ActuatorAction.constructor</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Communication avisa al familiar y a los cuidadores de turno en <code>occurredAt</code> (<code>ACTUATOR_FAILURE</code>) y Analytics cuenta una acción fallida (<code>ACTIONS_FAILED</code>). Después del commit, con <code>fallbackExecution</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lee el id al publicarse. Expone <code>occurredAt</code>: Communication lo necesita para hallar a los cuidadores de turno y Analytics, para el día de la falla.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActuatorActionSucceededEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que un actuador completó una acción.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>action</code></td><td><code>ActuatorAction</code></td><td>private</td><td>Acción que registró el evento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActuatorActionSucceededEvent(ActuatorAction action)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con el aggregate que lo registra.</td></tr>
<tr><td><code>getActionId()</code></td><td><code>String</code></td><td>public</td><td>Devuelve <code>actionId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getInstallationId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>installationId</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><code>getOccurredAt()</code></td><td><code>LocalDateTime</code></td><td>public</td><td>Devuelve <code>occurredAt</code> del aggregate de origen; se lee al publicarse el evento.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>ActuatorAction.constructor</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Analytics cuenta una acción correcta de la instalación (<code>ACTIONS_SUCCEEDED</code>). Después del commit, con <code>fallbackExecution</code>. No avisa a nadie.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EdgeDisconnectedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que un edge pasó 5 minutos o más sin comunicarse.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge en Assets.</td></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Instalación de la red del edge.</td></tr>
<tr><td><code>lastSeenAt</code></td><td><code>LocalDateTime</code></td><td>private final</td><td>Última vez que se comunicó.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EdgeDisconnectedEvent(Long edgeId, Long installationId, LocalDateTime lastSeenAt)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>EdgeConnection.markOfflineIfSilent</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Communication avisa solo al familiar, con un aviso al teléfono (<code>EDGE_DISCONNECTED</code>). Después del commit, con <code>fallbackExecution</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Es <code>Record</code>: se registra sobre una <code>EdgeConnection</code> ya guardada.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EdgeReconnectedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que un edge desconectado volvió a comunicarse.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge en Assets.</td></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Instalación de la red del edge.</td></tr>
<tr><td><code>reconnectedAt</code></td><td><code>LocalDateTime</code></td><td>private final</td><td>Cuándo volvió a comunicarse.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EdgeReconnectedEvent(Long edgeId, Long installationId, LocalDateTime reconnectedAt)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>EdgeConnection.markSeen</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Communication avisa solo al familiar, con un aviso al teléfono (<code>EDGE_RECONNECTED</code>). Después del commit, con <code>fallbackExecution</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Es <code>Record</code>: se registra sobre una <code>EdgeConnection</code> ya guardada.</td></tr>
</table>

#### Commands

<table>
<tr><th colspan="4" align="left"><code>RecordHelpRequestCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Registra un pedido de auxilio. Lo envía el edge de micrófono, directo a la nube.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>reportId</code></td><td><code>String</code></td><td>private final</td><td>Id único del reporte (<code>UUID</code> que genera el edge).</td></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td><code>Edge</code> que envía (sale del token con el que IAM lo autenticó).</td></tr>
<tr><td><code>microphoneId</code></td><td><code>Long</code></td><td>private final</td><td>Micrófono que captó el pedido.</td></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Instalación de la red del edge, tomada de su tabla.</td></tr>
<tr><td><code>occurredAt</code></td><td><code>LocalDateTime</code></td><td>private final</td><td>Cuándo lo detectó el edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RecordHelpRequestCommand(String reportId, Long edgeId, Long microphoneId, Long installationId, LocalDateTime occurredAt)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>HelpRequestCommandService</code>, que devuelve <code>String</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RecordLowBatteryCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Registra una batería baja. Cada edge envía la de los dispositivos que atiende: el micrófono, por el edge de micrófono; los actuadores, por el edge de actuadores.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>reportId</code></td><td><code>String</code></td><td>private final</td><td>Id único del reporte (<code>UUID</code> que genera el edge).</td></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td><code>Edge</code> que envía (sale del token con el que IAM lo autenticó).</td></tr>
<tr><td><code>deviceId</code></td><td><code>Long</code></td><td>private final</td><td>Id del dispositivo.</td></tr>
<tr><td><code>deviceType</code></td><td><code>DeviceType</code></td><td>private final</td><td>Tipo del dispositivo, tomado de la tabla de la red.</td></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Instalación de la red del edge, tomada de su tabla.</td></tr>
<tr><td><code>batteryLevel</code></td><td><code>Integer</code></td><td>private final</td><td>Porcentaje de batería reportado (0 a 100).</td></tr>
<tr><td><code>occurredAt</code></td><td><code>LocalDateTime</code></td><td>private final</td><td>Cuándo la detectó el edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RecordLowBatteryCommand(String reportId, Long edgeId, Long deviceId, DeviceType deviceType, Long installationId, Integer batteryLevel, LocalDateTime occurredAt)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>LowBatteryAlertCommandService</code>, que devuelve <code>String</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3"><code>BatteryLevel</code> valida 0 a 100 (<code>InvalidBatteryLevel</code>) y el aggregate, que sea bajo (<code>BatteryNotLow</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RecordActuatorActionCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Registra una acción de actuador con su resultado. Lo envía el edge de actuadores.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>reportId</code></td><td><code>String</code></td><td>private final</td><td>Id único del reporte (<code>UUID</code> que genera el edge).</td></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td><code>Edge</code> que envía (sale del token con el que IAM lo autenticó).</td></tr>
<tr><td><code>actuatorId</code></td><td><code>Long</code></td><td>private final</td><td>Actuador que ejecutó la acción.</td></tr>
<tr><td><code>actuatorType</code></td><td><code>DeviceType</code></td><td>private final</td><td>Tipo del actuador, tomado de la tabla de la red.</td></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Instalación de la red del edge, tomada de su tabla.</td></tr>
<tr><td><code>action</code></td><td><code>ActionType</code></td><td>private final</td><td>Acción ejecutada.</td></tr>
<tr><td><code>result</code></td><td><code>ActionResult</code></td><td>private final</td><td><code>SUCCEEDED</code> o <code>FAILED</code>.</td></tr>
<tr><td><code>occurredAt</code></td><td><code>LocalDateTime</code></td><td>private final</td><td>Cuándo se ejecutó.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RecordActuatorActionCommand(String reportId, Long edgeId, Long actuatorId, DeviceType actuatorType, Long installationId, ActionType action, ActionResult result, LocalDateTime occurredAt)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>ActuatorActionCommandService</code>, que devuelve <code>String</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La acción corresponde al tipo de actuador (<code>InvalidActionForDevice</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>StartEdgeMonitoringCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Empieza a vigilar un edge que entró a la red de una instalación. Lo activa <code>AssetAssignedToNetworkEvent</code> de un edge (Assets).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge en Assets.</td></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>StartEdgeMonitoringCommand(Long edgeId, Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EdgeConnectionCommandService</code>, que devuelve <code>String</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Si el edge ya tiene una <code>EdgeConnection</code> no <code>RETIRED</code> de esa instalación, devuelve su id; si es de otra, la retira antes de crear la nueva.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>StopEdgeMonitoringCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Deja de vigilar un edge. Lo activan <code>AssetRemovedFromNetworkEvent</code> de un edge y <code>DeviceNetworkDeactivatedEvent</code> (uno por cada edge de la red).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge en Assets.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>StopEdgeMonitoringCommand(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EdgeConnectionCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Llama a <code>retire</code>; si no hay <code>EdgeConnection</code> en servicio, no hace nada.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RecordEdgeHeartbeatCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Latido del edge: lo envía cada 60 segundos con su token. Es un command propio y no la consulta de la tabla, porque una query no modifica estado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td><code>Edge</code> que envía (sale del token).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RecordEdgeHeartbeatCommand(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EdgeConnectionCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Llama a <code>markSeen</code>. Si el edge no está en servicio, <code>EdgeNotInService</code>: el edge debe dejar de reportar.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DetectDisconnectedEdgesCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Detecta los edges que dejaron de comunicarse. Lo ejecuta el proceso programado cada minuto, con la hora actual.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>now</code></td><td><code>LocalDateTime</code></td><td>private final</td><td>Fecha y hora actual (America/Lima), que calcula la capa de aplicación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DetectDisconnectedEdgesCommand(LocalDateTime now)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EdgeConnectionCommandService</code>, que devuelve <code>void</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Llama a <code>markOfflineIfSilent</code> en cada <code>EdgeConnection</code> <code>ONLINE</code>.</td></tr>
</table>

#### Queries

<table>
<tr><th colspan="4" align="left"><code>GetAllHelpRequestsByInstallationIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Pedidos de auxilio de una instalación. La consulta el familiar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación de Soporte Técnico.</td></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta que consulta (sale de la sesión).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllHelpRequestsByInstallationIdQuery(Long installationId, Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;HelpRequest&gt;</code> (<code>HelpRequestQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllLowBatteryAlertsByInstallationIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Alertas de batería de una instalación. La consulta el familiar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación de Soporte Técnico.</td></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta que consulta (sale de la sesión).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllLowBatteryAlertsByInstallationIdQuery(Long installationId, Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;LowBatteryAlert&gt;</code> (<code>LowBatteryAlertQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllActuatorActionsByInstallationIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Acciones de los actuadores de una instalación. La consulta el familiar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación de Soporte Técnico.</td></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta que consulta (sale de la sesión).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllActuatorActionsByInstallationIdQuery(Long installationId, Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;ActuatorAction&gt;</code> (<code>ActuatorActionQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllHelpRequestsByMicrophoneIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Pedidos de auxilio de un micrófono. La consultan el familiar (de su instalación) y el administrador (de su negocio).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>microphoneId</code></td><td><code>Long</code></td><td>private final</td><td>Micrófono consultado.</td></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta que consulta (sale de la sesión).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllHelpRequestsByMicrophoneIdQuery(Long microphoneId, Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;HelpRequest&gt;</code> (<code>HelpRequestQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllLowBatteryAlertsByDeviceIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Alertas de batería de un dispositivo. La consultan el familiar y el administrador.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>deviceId</code></td><td><code>Long</code></td><td>private final</td><td>Dispositivo consultado.</td></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta que consulta (sale de la sesión).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllLowBatteryAlertsByDeviceIdQuery(Long deviceId, Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;LowBatteryAlert&gt;</code> (<code>LowBatteryAlertQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllActuatorActionsByActuatorIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Acciones de un actuador. La consultan el familiar y el administrador.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>actuatorId</code></td><td><code>Long</code></td><td>private final</td><td>Actuador consultado.</td></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta que consulta (sale de la sesión).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllActuatorActionsByActuatorIdQuery(Long actuatorId, Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;ActuatorAction&gt;</code> (<code>ActuatorActionQueryService</code>)</td></tr>
</table>

#### Domain Services

**Reglas comunes de `HelpRequestCommandService`, `LowBatteryAlertCommandService`, `ActuatorActionCommandService`.** El edge se autentica en IAM con su credencial (`AuthenticateDeviceCommand`) y envía el reporte con el token que recibe; el `edgeId` sale de ese token. **El edge está en servicio**: tiene una `EdgeConnection` no `RETIRED` (`EdgeNotInService`) y el `installationId` del reporte es el de su red (`belongsTo`; `ReportInstallationMismatch`). Así un edge retirado, de una red desactivada o con datos ajenos no genera avisos, sin consultar a Assets. Cada reporte aceptado también cuenta como latido (`markSeen`). **El reporte llega completo**: el edge pide a Assets la tabla de su red (`GetEdgeAccessTableQuery`, con `networkId`, `installationId` y el tipo de cada dispositivo) al arrancar y cada cierto tiempo. El edge copia de ahí `installationId`, `deviceId` y tipo; Tracking no consulta a Assets por cada reporte, así el pedido de auxilio no depende de otra llamada. Un equipo retirado de la red ya no está en la tabla del edge, así que el edge no reporta por él. Todos los datos del command son obligatorios. **Reintentos**: si se corta la conexión, el edge guarda el reporte en su base local y lo reenvía al reconectarse, con el mismo `reportId` y su `occurredAt` original; el pedido de auxilio sale primero. Si ya existe un reporte con ese `reportId` en la colección, el CommandService devuelve el id guardado sin crear otro ni registrar el evento de nuevo. Si dos reintentos llegan a la vez y el segundo choca con el índice único de `report_id`, la capa de aplicación captura la clave duplicada y devuelve el id existente.

**Reglas comunes de `HelpRequestQueryService`, `LowBatteryAlertQueryService`, `ActuatorActionQueryService`.** `userId` sale de la sesión. La capa de aplicación valida a quién pertenece lo que se pide (`HistoryAccessDenied`): **Familiar**: la instalación es suya (Support, `GetInstallationByIdQuery`, `isRequestedBy`). Por dispositivo: el equipo está en la red de su instalación (Assets, `GetDeviceNetworkByDeviceIdQuery`). **Administrador**: el dispositivo es de su negocio (Assets, `GetDeviceByIdQuery` y `belongsTo`; el negocio del administrador sale de Company). Ve el historial de cada micrófono y actuador. Todas devuelven del más reciente al más antiguo (`occurredAt`).

<table>
<tr><th colspan="4" align="left"><code>HelpRequestCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>HelpRequest</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(RecordHelpRequestCommand command)</code></td><td><code>String</code></td><td>public</td><td>Ejecuta <code>RecordHelpRequestCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>HelpRequestQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>HelpRequest</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetAllHelpRequestsByInstallationIdQuery query)</code></td><td><code>List&lt;HelpRequest&gt;</code></td><td>public</td><td>Resuelve <code>GetAllHelpRequestsByInstallationIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetAllHelpRequestsByMicrophoneIdQuery query)</code></td><td><code>List&lt;HelpRequest&gt;</code></td><td>public</td><td>Resuelve <code>GetAllHelpRequestsByMicrophoneIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>LowBatteryAlertCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>LowBatteryAlert</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(RecordLowBatteryCommand command)</code></td><td><code>String</code></td><td>public</td><td>Ejecuta <code>RecordLowBatteryCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>LowBatteryAlertQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>LowBatteryAlert</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetAllLowBatteryAlertsByInstallationIdQuery query)</code></td><td><code>List&lt;LowBatteryAlert&gt;</code></td><td>public</td><td>Resuelve <code>GetAllLowBatteryAlertsByInstallationIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetAllLowBatteryAlertsByDeviceIdQuery query)</code></td><td><code>List&lt;LowBatteryAlert&gt;</code></td><td>public</td><td>Resuelve <code>GetAllLowBatteryAlertsByDeviceIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActuatorActionCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>ActuatorAction</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(RecordActuatorActionCommand command)</code></td><td><code>String</code></td><td>public</td><td>Ejecuta <code>RecordActuatorActionCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActuatorActionQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>ActuatorAction</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetAllActuatorActionsByInstallationIdQuery query)</code></td><td><code>List&lt;ActuatorAction&gt;</code></td><td>public</td><td>Resuelve <code>GetAllActuatorActionsByInstallationIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetAllActuatorActionsByActuatorIdQuery query)</code></td><td><code>List&lt;ActuatorAction&gt;</code></td><td>public</td><td>Resuelve <code>GetAllActuatorActionsByActuatorIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EdgeConnectionCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>EdgeConnection</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(StartEdgeMonitoringCommand command)</code></td><td><code>String</code></td><td>public</td><td>Ejecuta <code>StartEdgeMonitoringCommand</code> y devuelve el id de la <code>EdgeConnection</code>.</td></tr>
<tr><td><code>handle(StopEdgeMonitoringCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>StopEdgeMonitoringCommand</code>.</td></tr>
<tr><td><code>handle(RecordEdgeHeartbeatCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>RecordEdgeHeartbeatCommand</code>.</td></tr>
<tr><td><code>handle(DetectDisconnectedEdgesCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>DetectDisconnectedEdgesCommand</code>.</td></tr>
</table>

#### Exceptions

<table>
<tr><th colspan="4" align="left"><code>InvalidReportId</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el <code>reportId</code> no tiene formato <code>UUID</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidReportId(String reportId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidBatteryLevel</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el porcentaje de batería no está entre 0 y 100.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidBatteryLevel(Integer percentage)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BatteryNotLow</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se reporta una batería que no está en el umbral de batería baja.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BatteryNotLow(Integer percentage)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidActionForDevice</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la acción no corresponde al tipo de actuador o el dispositivo es un micrófono.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidActionForDevice(ActionType action, DeviceType type)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EdgeNotInService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando reporta o envía su latido un edge sin <code>EdgeConnection</code> en servicio (retirado o de una red desactivada).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EdgeNotInService(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ReportInstallationMismatch</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el <code>installationId</code> del reporte no es el de la red del edge.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ReportInstallationMismatch(Long edgeId, Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidConnectionStatusTransition</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el cambio de estado de la conexión no está permitido.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidConnectionStatusTransition(ConnectionStatus from, ConnectionStatus to)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>HistoryAccessDenied</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando quien consulta el historial no es el familiar de la instalación ni el administrador del negocio dueño del dispositivo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>HistoryAccessDenied(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

### 5.10.2. Interface Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.10.1.

### 5.10.3. Application Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.10.1.

### 5.10.4. Infrastructure Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.10.1.

### 5.10.6. Bounded Context Software Architecture Component Level Diagrams

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.10.1.

### 5.10.7. Bounded Context Software Architecture Code Level Diagrams

#### 5.10.7.1. Bounded Context Domain Layer Class Diagrams

El diagrama muestra los cuatro aggregates de Tracking: `HelpRequest`, `LowBatteryAlert` y `ActuatorAction`, registros independientes de cada reporte, y `EdgeConnection`, la conexión de un edge en servicio. Los tres registros se componen de su `ReportId`; `LowBatteryAlert` se compone además de `BatteryLevel`, y `ActuatorAction` se asocia con sus enums. Las flechas de eventos muestran qué aggregate registra cada aviso que consumen Communication y Analytics. Las notas detallan las reglas comunes de los reportes, el latido y la desconexión de los edges, el acceso al historial y cómo Communication encuentra a quién avisar.

![Diagrama de clases de la capa de dominio - Telemetría](../images/diagrams/img/chapter-5/tracking-backend-diagram.svg)

#### 5.10.7.2. Bounded Context Database Design Diagram

La base de datos es MongoDB: una colección por aggregate.

| Tabla o colección | Aggregate, entidad o value object | Llaves y restricciones |
|---|---|---|
| `help_requests` | `HelpRequest` | PK `_id`. UK `report_id`. Referencia a Assets sin FK: `edge_id`, `microphone_id`. Referencia a Soporte Técnico sin FK: `installation_id`. IDX (`installation_id`, `occurred_at DESC`). IDX (`microphone_id`, `occurred_at DESC`). |
| `low_battery_alerts` | `LowBatteryAlert` | PK `_id`. UK `report_id`. Referencia a Assets sin FK: `edge_id`, `device_id`. Referencia a Soporte Técnico sin FK: `installation_id`. IDX (`installation_id`, `occurred_at DESC`). IDX (`device_id`, `occurred_at DESC`). |
| `actuator_actions` | `ActuatorAction` | PK `_id`. UK `report_id`. Referencia a Assets sin FK: `edge_id`, `actuator_id`. Referencia a Soporte Técnico sin FK: `installation_id`. IDX (`installation_id`, `occurred_at DESC`). IDX (`actuator_id`, `occurred_at DESC`). |
| `edge_connections` | `EdgeConnection` | PK `_id`. Referencia a Assets sin FK: `edge_id`. Referencia a Soporte Técnico sin FK: `installation_id`. UK parcial (`edge_id`) WHERE status <> '`RETIRED`'. IDX (`status`, `last_seen_at`). |

**MongoDB: una colección por aggregate**.

Cada documento de reporte es de un edge y no se modifica después de guardarse. Las colecciones son independientes: no hay referencias entre ellas ni FK. `edge_id`, `microphone_id`, `device_id` y `actuator_id` son ids de Assets; `installation_id` es de Soporte Técnico. Los envía el edge en cada reporte, tomados de la tabla de su red (`EdgeAccessTable` de Assets).

IDX (`installation_id`, `occurred_at` DESC): historial de una instalación, del más reciente al más antiguo. IDX (`device_id`, `occurred_at` DESC), (`microphone_id`, ...) y (`actuator_id`, ...): historial de un dispositivo (familiar y administrador). UK (`report_id`) en cada colección de reportes: un reporte reenviado por el edge tras cortarse la conexión no se guarda dos veces.

`device_type`, `actuator_type`, action y result se guardan como texto del enum. Una batería genera como máximo dos documentos por descarga: 10 % y 5 %.

`edge_connections`: el único documento que cambia. Uno por cada vez que un edge entra a una red; a lo sumo uno no `RETIRED` por edge (índice único parcial). IDX (status, `last_seen_at`): el proceso programado busca cada minuto los `ONLINE` sin contacto por 5 minutos.


![Diagrama de base de datos - Telemetría](../images/diagrams/img/chapter-5/tracking-database-diagram.svg)

<div style="page-break-after: always;"></div>

## 5.11. Bounded Context: Bienes

En el código, este bounded context es el paquete `assets`. Assets gestiona el inventario de equipos de cada negocio y la red que se arma con ellos en cada hogar. Los equipos son los edges (de micrófono y de actuadores) y los dispositivos (el micrófono y los actuadores de puerta, ventana, cortina y luz). Cuando Support termina una instalación, Assets crea la red de esa instalación y calcula, para cada edge, la tabla de quién le puede enviar y a quién puede enviar; el edge la pide al arrancar y cada 30 segundos. Al registrar un edge, Assets pide a IAM su credencial. Cuando se cancela la suscripción, la red se desactiva y, cuando el técnico recoge los equipos, se desmonta y los equipos vuelven a estar disponibles.

### 5.11.1. Domain Layer

Este bounded context no declara Entities propios.

#### Aggregates

<table>
<tr><th colspan="4" align="left"><code>Asset</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Clase abstracta base de aggregates (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">(base abstracta de <code>Edge</code> y <code>Device</code>) No es un aggregate propio: no tiene repositorio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>BusinessId</code></td><td>private</td><td>Negocio dueño del equipo.</td></tr>
<tr><td><code>macAddress</code></td><td><code>MacAddress</code></td><td>private</td><td>MAC del equipo. No se repite entre edges y devices.</td></tr>
<tr><td><code>status</code></td><td><code>AssetStatus</code></td><td>private</td><td><code>AVAILABLE</code>, <code>IN_USE</code>, <code>MAINTENANCE</code> o <code>BROKEN</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Asset(BusinessId businessId, MacAddress macAddress)</code></td><td>(constructor)</td><td>protected</td><td>Estado <code>AVAILABLE</code> (en almacén). Las transiciones no permitidas lanzan <code>InvalidAssetStatusTransition</code>. . <code>sendToMaintenance</code>, <code>markBroken</code> y <code>markRepaired</code> registran <code>AssetStatusChangedEvent</code>; <code>markInUse</code> y release no (los activa la red).</td></tr>
<tr><td><code>belongsTo(BusinessId businessId)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si es del negocio indicado.</td></tr>
<tr><td><code>isAvailable()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si está <code>AVAILABLE</code>.</td></tr>
<tr><td><code>markInUse()</code></td><td><code>void</code></td><td>public</td><td><code>AVAILABLE</code> a <code>IN_USE</code> (se asigna a una red).</td></tr>
<tr><td><code>release()</code></td><td><code>void</code></td><td>public</td><td><code>IN_USE</code> a <code>AVAILABLE</code> (sale de una red).</td></tr>
<tr><td><code>sendToMaintenance()</code></td><td><code>void</code></td><td>public</td><td><code>AVAILABLE</code> o <code>IN_USE</code> a <code>MAINTENANCE</code>.</td></tr>
<tr><td><code>markBroken()</code></td><td><code>void</code></td><td>public</td><td><code>AVAILABLE</code>, <code>IN_USE</code> o <code>MAINTENANCE</code> a <code>BROKEN</code>.</td></tr>
<tr><td><code>markRepaired()</code></td><td><code>void</code></td><td>public</td><td><code>MAINTENANCE</code> o <code>BROKEN</code> a <code>AVAILABLE</code>. <code>IN_USE</code> y <code>AVAILABLE</code> por asignación solo cambian por la red (<code>AssetAssignedToNetworkEvent</code> y <code>AssetRemovedFromNetworkEvent</code>).</td></tr>
<tr><td><code>correctMacAddress(MacAddress macAddress)</code></td><td><code>void</code></td><td>protected</td><td>Solo si está <code>AVAILABLE</code> (<code>AssetNotEditable</code>).</td></tr>
<tr><td><code>nodeType()</code></td><td><code>NodeType</code></td><td>protected</td><td>Tipo de nodo del equipo en la tabla de accesos; lo define cada subclase.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3"><b>Equipo instalado con falla</b>: Soporte Técnico lo revisa y, si hay que cambiarlo, lo pasa de <code>IN_USE</code> a <code>MAINTENANCE</code> o <code>BROKEN</code>. Eso registra <code>AssetStatusChangedEvent</code> y la red lo retira.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>AssetStatus</code></td><td>0..* a 1</td><td><code>AVAILABLE</code>, <code>IN_USE</code>, <code>MAINTENANCE</code> o <code>BROKEN</code>.</td></tr>
<tr><td>Composición (<code>macAddress</code>)</td><td><code>MacAddress</code></td><td>1 a 1</td><td>MAC del equipo.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Edge</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>Asset</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Una aplicación edge del hogar. <code>MICROPHONE_EDGE</code> transcribe el audio del micrófono; <code>ACTUATOR_EDGE</code> ejecuta las acciones en los actuadores.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>type</code></td><td><code>EdgeType</code></td><td>private</td><td><code>MICROPHONE_EDGE</code> o <code>ACTUATOR_EDGE</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Edge(BusinessId businessId, MacAddress macAddress, EdgeType type)</code></td><td>(constructor)</td><td>public</td><td>Registra el edge en el inventario, en estado <code>AVAILABLE</code>.</td></tr>
<tr><td><code>isMicrophoneEdge()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si es el edge del micrófono.</td></tr>
<tr><td><code>isActuatorEdge()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si es el edge de los actuadores.</td></tr>
<tr><td><code>update(MacAddress macAddress, EdgeType type)</code></td><td><code>void</code></td><td>public</td><td>Corrige la MAC o el tipo mal registrados desde el frontend; solo si está <code>AVAILABLE</code> (<code>AssetNotEditable</code>).</td></tr>
<tr><td><code>nodeType()</code></td><td><code>NodeType</code></td><td>protected</td><td><code>MICROPHONE_EDGE</code> o <code>ACTUATOR_EDGE</code>, según su tipo.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Aplicación edge instalada en el hogar. <code>MICROPHONE_EDGE</code> transcribe el audio del micrófono; <code>ACTUATOR_EDGE</code> ejecuta las acciones en los actuadores.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>type</code>)</td><td><code>EdgeType</code></td><td>0..* a 1</td><td><code>MICROPHONE_EDGE</code> o <code>ACTUATOR_EDGE</code>.</td></tr>
<tr><td>Herencia</td><td><code>Asset</code></td><td>No aplica</td><td>Extiende la base abstracta <code>Asset</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Device</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>Asset</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Un dispositivo embebido: el micrófono, que recibe las órdenes por voz y el pedido de auxilio, o un actuador (puerta, ventana, cortina o luz).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>type</code></td><td><code>DeviceType</code></td><td>private</td><td><code>MICROPHONE</code>, <code>DOOR</code>, <code>WINDOW</code>, <code>CURTAIN</code> o <code>LIGHT</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Device(BusinessId businessId, MacAddress macAddress, DeviceType type)</code></td><td>(constructor)</td><td>public</td><td>Registra el dispositivo en el inventario, en estado <code>AVAILABLE</code>.</td></tr>
<tr><td><code>isMicrophone()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si es un micrófono.</td></tr>
<tr><td><code>isActuator()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si es un actuador (cualquier tipo distinto de <code>MICROPHONE</code>).</td></tr>
<tr><td><code>update(MacAddress macAddress, DeviceType type)</code></td><td><code>void</code></td><td>public</td><td>Corrige la MAC o el tipo mal registrados, solo si está <code>AVAILABLE</code> (<code>AssetNotEditable</code>). La MAC no se repite entre edges y devices (<code>MacAddressAlreadyExists</code>).</td></tr>
<tr><td><code>nodeType()</code></td><td><code>NodeType</code></td><td>protected</td><td><code>MICROPHONE</code> o <code>ACTUATOR</code>, según su tipo.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Dispositivo embebido. <code>MICROPHONE</code>: sensor; recibe las órdenes por voz y el pedido de auxilio. Actuadores: <code>DOOR</code>, <code>WINDOW</code>, <code>CURTAIN</code> y <code>LIGHT</code>. <b>Inventario</b>: un negocio registra todos los edges (de ambos tipos), micrófonos y actuadores que quiera; no hay límite. Un equipo sin red queda <code>AVAILABLE</code>.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>type</code>)</td><td><code>DeviceType</code></td><td>0..* a 1</td><td><code>MICROPHONE</code>, <code>DOOR</code>, <code>WINDOW</code>, <code>CURTAIN</code> o <code>LIGHT</code>.</td></tr>
<tr><td>Herencia</td><td><code>Asset</code></td><td>No aplica</td><td>Extiende la base abstracta <code>Asset</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceNetwork</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Red de dispositivos de una instalación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>InstallationId</code></td><td>private</td><td>Instalación de Soporte Técnico donde se monta la red.</td></tr>
<tr><td><code>businessId</code></td><td><code>BusinessId</code></td><td>private</td><td>Negocio dueño de los equipos.</td></tr>
<tr><td><code>status</code></td><td><code>NetworkStatus</code></td><td>private</td><td><code>ACTIVE</code> o <code>DEACTIVATED</code>.</td></tr>
<tr><td><code>microphoneEdge</code></td><td><code>Edge</code></td><td>private</td><td><code>Edge</code> del micrófono. Vacío mientras uno retirado no se reemplaza.</td></tr>
<tr><td><code>actuatorEdge</code></td><td><code>Edge</code></td><td>private</td><td><code>Edge</code> de los actuadores. Vacío mientras uno retirado no se reemplaza.</td></tr>
<tr><td><code>microphone</code></td><td><code>Device</code></td><td>private</td><td>Micrófono asignado. Vacío mientras uno retirado no se reemplaza.</td></tr>
<tr><td><code>actuators</code></td><td><code>List&lt;Device&gt;</code></td><td>private</td><td>Actuadores asignados a la red.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceNetwork(InstallationId installationId, BusinessId businessId, Edge microphoneEdge, Edge actuatorEdge, Device microphone, List&lt;Device&gt; actuators)</code></td><td>(constructor)</td><td>public</td><td>Estado <code>ACTIVE</code>; recibe los tres equipos únicos; cada uno es del tipo de su campo y actuators solo tiene actuadores (<code>InvalidNetworkMember</code>). Todo equipo es del mismo negocio (<code>AssetNotInBusiness</code>) y está <code>AVAILABLE</code> (<code>AssetNotAvailable</code>).</td></tr>
<tr><td><code>addEdge(Edge edge)</code></td><td><code>void</code></td><td>public</td><td>Ocupa el campo de su tipo si está vacío (<code>NodeTypeAlreadyInNetwork</code>).</td></tr>
<tr><td><code>addDevice(Device device)</code></td><td><code>void</code></td><td>public</td><td>El micrófono ocupa su campo si está vacío (<code>NodeTypeAlreadyInNetwork</code>); un actuador se suma a la lista si no está ya (<code>AssetAlreadyInNetwork</code>). <code>removeEdge</code> / <code>removeDevice</code>: el equipo está en la red (<code>containsEdge</code> / <code>containsDevice</code>; <code>AssetNotInNetwork</code>); su campo queda vacío hasta que Soporte Técnico asigne otro. <code>addDevice</code> usa <code>containsDevice</code> (<code>AssetAlreadyInNetwork</code>). add y remove solo en una red <code>ACTIVE</code> (<code>isActive</code>; <code>DeviceNetworkDeactivated</code>).</td></tr>
<tr><td><code>removeEdge(Long edgeId)</code></td><td><code>void</code></td><td>public</td><td>Retira un edge de la red (<code>AssetNotInNetwork</code>); su campo queda vacío.</td></tr>
<tr><td><code>removeDevice(Long deviceId)</code></td><td><code>void</code></td><td>public</td><td>Retira el micrófono o un actuador de la red (<code>AssetNotInNetwork</code>).</td></tr>
<tr><td><code>deactivate()</code></td><td><code>void</code></td><td>public</td><td><code>ACTIVE</code> a <code>DEACTIVATED</code> (se canceló la suscripción). Los equipos siguen asignados e <code>IN_USE</code> (están en el hogar); registra <code>DeviceNetworkDeactivatedEvent</code>.</td></tr>
<tr><td><code>dismantle()</code></td><td><code>void</code></td><td>public</td><td><code>DEACTIVATED</code> a <code>DISMANTLED</code> (el técnico recogió los equipos); retira todos y registra <code>AssetRemovedFromNetworkEvent</code> por cada uno (<code>InvalidNetworkStatusTransition</code>). Cada alta o baja registra <code>AssetAssignedToNetworkEvent</code> o <code>AssetRemovedFromNetworkEvent</code>.</td></tr>
<tr><td><code>containsEdge(Long edgeId)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el edge está asignado a la red.</td></tr>
<tr><td><code>containsDevice(Long deviceId)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el dispositivo está asignado a la red.</td></tr>
<tr><td><code>edgeIds()</code></td><td><code>List&lt;Long&gt;</code></td><td>public</td><td>Edges asignados a la red.</td></tr>
<tr><td><code>tableFor(Long edgeId)</code></td><td><code>EdgeAccessTable</code></td><td>public</td><td>Calcula la tabla de accesos del edge con los equipos asignados en ese momento.</td></tr>
<tr><td><code>isActive()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la red está <code>ACTIVE</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La crea Support al terminar la instalación: decide cuántos actuadores se instalan. <code>DeviceNetwork</code> enlaza los equipos asignados; solo los lee, nunca los modifica. Todo equipo es del mismo negocio (<code>AssetNotInBusiness</code>) y está <code>AVAILABLE</code> al crear la red (<code>AssetNotAvailable</code>). Agregar y retirar equipos solo en una red <code>ACTIVE</code> (<code>DeviceNetworkDeactivated</code>). Cada alta o baja registra <code>AssetAssignedToNetworkEvent</code> o <code>AssetRemovedFromNetworkEvent</code>. <code>tableFor</code> arma: micrófono a edge de micrófono, edge de micrófono a edge de actuadores (por el broker), edge de actuadores a cada actuador y cada edge a la nube; una red que no está <code>ACTIVE</code> no da tabla.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>status</code>)</td><td><code>NetworkStatus</code></td><td>0..* a 1</td><td><code>ACTIVE</code> o <code>DEACTIVATED</code>.</td></tr>
<tr><td>Asociación dirigida (<code>microphoneEdge</code>)</td><td><code>Edge</code></td><td>0..1 a 0..1</td><td><code>Edge</code> del micrófono.</td></tr>
<tr><td>Asociación dirigida (<code>actuatorEdge</code>)</td><td><code>Edge</code></td><td>0..1 a 0..1</td><td><code>Edge</code> de los actuadores.</td></tr>
<tr><td>Asociación dirigida (<code>microphone</code>)</td><td><code>Device</code></td><td>0..1 a 0..1</td><td>Micrófono asignado.</td></tr>
<tr><td>Asociación dirigida (<code>actuators</code>)</td><td><code>Device</code></td><td>0..1 a 0..*</td><td>Actuadores asignados a la red.</td></tr>
<tr><td>Dependencia "<code>tableFor</code>"</td><td><code>EdgeAccessTable</code></td><td>No aplica</td><td></td></tr>
</table>

#### Value Objects

**Value objects de Shared que usa este contexto.** **`BusinessId`**: negocio dueño de los equipos (Company). Lo guardan `Edge`, `Device` y `DeviceNetwork`. **`InstallationId`**: instalación de Soporte Técnico donde se monta la red. Lo guarda `DeviceNetwork`. Assets solo guarda sus ids: nunca accede a esos contextos directamente.

<table>
<tr><th colspan="4" align="left"><code>MacAddress</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Dirección MAC válida y normalizada de un equipo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>macAddress</code></td><td><code>String</code></td><td>private final</td><td>Seis pares hexadecimales en mayúsculas separados por ":" (<code>AA:BB:CC:DD:EE:FF</code>).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>MacAddress(String macAddress)</code></td><td>(constructor)</td><td>public</td><td>Acepta ":" o "-" como separador (<code>InvalidMacAddress</code>) y normaliza el valor, para comparar sin importar cómo se escribió.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Seis pares hexadecimales separados por ":" o "-" (<code>InvalidMacAddress</code>). Se normaliza a mayúsculas con ":" (AA:BB:CC:DD:EE:FF) para comparar sin importar cómo se escribió.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>NodeRef</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Un nodo de la tabla de un edge: el equipo con su MAC, que es con lo que el edge identifica a quien le envía.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>type</code></td><td><code>NodeType</code></td><td>private final</td><td>Tipo de nodo.</td></tr>
<tr><td><code>assetId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge o dispositivo. Nulo para <code>CLOUD</code>.</td></tr>
<tr><td><code>macAddress</code></td><td><code>MacAddress</code></td><td>private final</td><td>MAC del equipo. Nula para <code>CLOUD</code>.</td></tr>
<tr><td><code>deviceType</code></td><td><code>DeviceType</code></td><td>private final</td><td>Tipo del micrófono o del actuador (<code>DOOR</code>, <code>LIGHT</code>, etc.); nulo para edges y <code>CLOUD</code>. El edge de actuadores lo usa para ejecutar la acción y para reportarla a Tracking.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>NodeRef(NodeType type, Long assetId, MacAddress macAddress, DeviceType deviceType)</code></td><td>(constructor)</td><td>public</td><td>Crea el value object y valida sus invariantes.</td></tr>
<tr><td><code>of(Asset asset)</code></td><td><code>NodeRef</code></td><td>public static</td><td>Crea el nodo de un edge o dispositivo.</td></tr>
<tr><td><code>cloud()</code></td><td><code>NodeRef</code></td><td>public static</td><td>Crea el nodo de la nube.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Un nodo de la tabla de un edge: el equipo con su MAC, que es con lo que el edge identifica a quien le envía. Para <code>CLOUD</code>, <code>assetId</code> y <code>macAddress</code> son nulos (<code>NodeRef.cloud()</code>).</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>type</code>)</td><td><code>NodeType</code></td><td>0..* a 1</td><td>Tipo de nodo.</td></tr>
<tr><td>Asociación dirigida (<code>deviceType</code>)</td><td><code>DeviceType</code></td><td>0..* a 0..1</td><td>Tipo del micrófono o del actuador (<code>DOOR</code>, <code>LIGHT</code>, etc.); nulo para edges y <code>CLOUD</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EdgeAccessTable</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">La tabla de un edge: quién le puede enviar y a quién puede enviar. No se guarda: la calcula <code>DeviceNetwork.tableFor</code>. El edge la pide (<code>GetEdgeAccessTableQuery</code>) al arrancar y cada 30 segundos y reemplaza su copia local completa; la nube no se la envía.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td><code>Edge</code> al que pertenece la tabla.</td></tr>
<tr><td><code>networkId</code></td><td><code>Long</code></td><td>private final</td><td>Red del edge. El edge la agrega a cada reporte que envía a Tracking.</td></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Instalación de la red. El edge la agrega a cada reporte que envía a Tracking.</td></tr>
<tr><td><code>allowedSources</code></td><td><code>List&lt;NodeRef&gt;</code></td><td>private final</td><td>Quién le puede enviar (el micrófono o el otro edge).</td></tr>
<tr><td><code>allowedTargets</code></td><td><code>List&lt;NodeRef&gt;</code></td><td>private final</td><td>A quién puede enviar (el otro edge, los actuadores o <code>CLOUD</code>). El edge reemplaza su copia local (SQLite) completa cada vez que recibe una. Los dispositivos se conectan al edge por HTTP y, si falla el wifi, por Bluetooth; por los dos canales el edge los valida con la MAC de esta tabla.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EdgeAccessTable(Long edgeId, Long networkId, Long installationId, List&lt;NodeRef&gt; allowedSources, List&lt;NodeRef&gt; allowedTargets)</code></td><td>(constructor)</td><td>public</td><td>Crea el value object y valida sus invariantes.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Los dispositivos se conectan al edge por HTTP y, si falla el wifi, por Bluetooth; por los dos canales el edge los valida con la MAC de esta tabla.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>allowedSources / allowedTargets</code>)</td><td><code>NodeRef</code></td><td>1 a 0..*</td><td></td></tr>
</table>

#### Enumerations

<table>
<tr><th colspan="4" align="left"><code>EdgeType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tipo de edge.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>MICROPHONE_EDGE</code>, <code>ACTUATOR_EDGE</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tipo de dispositivo: el micrófono o un actuador.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>MICROPHONE</code>, <code>DOOR</code>, <code>WINDOW</code>, <code>CURTAIN</code>, <code>LIGHT</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssetStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de un equipo. <code>IN_USE</code> significa asignado a una red.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>AVAILABLE</code>, <code>IN_USE</code>, <code>MAINTENANCE</code>, <code>BROKEN</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>NetworkStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de una red.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>ACTIVE</code>, <code>DEACTIVATED</code>, <code>DISMANTLED</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>NodeType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tipo de nodo en la tabla de accesos y en los eventos.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>MICROPHONE</code>, <code>ACTUATOR</code>, <code>MICROPHONE_EDGE</code>, <code>ACTUATOR_EDGE</code>, <code>CLOUD</code></td></tr>
</table>

#### Domain Events

**Dentro de Assets.** `AssetAssignedToNetworkEvent`: activa `MarkEdgeInUseCommand` o `MarkDeviceInUseCommand`. `AssetRemovedFromNetworkEvent`: activa `ReleaseEdgeCommand` o `ReleaseDeviceCommand` si el equipo sigue `IN_USE`. `AssetStatusChangedEvent`: con `MAINTENANCE` o `BROKEN` y el equipo en una red, activa `RemoveEdgeFromNetworkCommand` o `RemoveDeviceFromNetworkCommand`.

**Hacia otros contextos.** `AssetAssignedToNetworkEvent` de un edge: Tracking `StartEdgeMonitoringCommand` (con `installationId`; se registra en el constructor de la red, antes de que exista `networkId`, por eso no lo lleva). `AssetRemovedFromNetworkEvent` de un edge: IAM `RevokeDeviceCredentialCommand` y Tracking `StopEdgeMonitoringCommand`. `DeviceNetworkDeactivatedEvent`: por cada edge, IAM `RevokeDeviceCredentialCommand` y Tracking `StopEdgeMonitoringCommand`. `AssetStatusChangedEvent` con `BROKEN`: Analytics cuenta un equipo malogrado de ese negocio.

<table>
<tr><th colspan="4" align="left"><code>AssetAssignedToNetworkEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que un equipo se asignó a una red.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>type</code></td><td><code>NodeType</code></td><td>private final</td><td>Tipo de actividad.</td></tr>
<tr><td><code>assetId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge o dispositivo.</td></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Instalación de la red.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssetAssignedToNetworkEvent(NodeType type, Long assetId, Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>DeviceNetwork.dismantle</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>MarkEdgeInUseCommand</code> o <code>MarkDeviceInUseCommand</code> (síncrono). De un edge: Tracking <code>StartEdgeMonitoringCommand</code> (síncrono).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssetRemovedFromNetworkEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que un equipo salió de una red.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>type</code></td><td><code>NodeType</code></td><td>private final</td><td>Tipo de actividad.</td></tr>
<tr><td><code>assetId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge o dispositivo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssetRemovedFromNetworkEvent(NodeType type, Long assetId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>DeviceNetwork.dismantle</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto: <code>ReleaseEdgeCommand</code> o <code>ReleaseDeviceCommand</code> si el equipo sigue <code>IN_USE</code> (síncrono). De un edge: IAM <code>RevokeDeviceCredentialCommand</code> y Tracking <code>StopEdgeMonitoringCommand</code> (síncrono).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceNetworkDeactivatedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que la red se desactivó porque se canceló la suscripción. Los equipos siguen <code>IN_USE</code> en el hogar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>networkId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la red.</td></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación (Soporte Técnico).</td></tr>
<tr><td><code>edgeIds</code></td><td><code>List&lt;Long&gt;</code></td><td>private final</td><td>Ids de los edges de la red.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceNetworkDeactivatedEvent(Long networkId, Long installationId, List&lt;Long&gt; edgeIds)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>DeviceNetwork.deactivate</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Por cada edge, IAM <code>RevokeDeviceCredentialCommand</code> y Tracking <code>StopEdgeMonitoringCommand</code> (síncrono).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssetStatusChangedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que un equipo cambió de estado por una acción manual: mantenimiento, falla o reparación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>type</code></td><td><code>NodeType</code></td><td>private final</td><td>Tipo de actividad.</td></tr>
<tr><td><code>assetId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge o dispositivo.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Negocio dueño del equipo.</td></tr>
<tr><td><code>status</code></td><td><code>AssetStatus</code></td><td>private final</td><td>Estado nuevo: <code>MAINTENANCE</code>, <code>BROKEN</code> o <code>AVAILABLE</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssetStatusChangedEvent(NodeType type, Long assetId, Long businessId, AssetStatus status)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Asset.constructor</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Dentro del contexto, con <code>MAINTENANCE</code> o <code>BROKEN</code> y el equipo en una red: <code>RemoveEdgeFromNetworkCommand</code> o <code>RemoveDeviceFromNetworkCommand</code> (síncrono). Con <code>BROKEN</code>, Analytics cuenta un equipo malogrado del negocio (después del commit).</td></tr>
</table>

#### Commands

<table>
<tr><th colspan="4" align="left"><code>RegisterEdgeCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El administrador registra un edge en el inventario y recibe su credencial.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>macAddress</code></td><td><code>String</code></td><td>private final</td><td>MAC del equipo; se valida y normaliza con <code>MacAddress</code>.</td></tr>
<tr><td><code>type</code></td><td><code>EdgeType</code></td><td>private final</td><td><code>MICROPHONE_EDGE</code> o <code>ACTUATOR_EDGE</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RegisterEdgeCommand(Long businessId, String macAddress, EdgeType type)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EdgeCommandService</code>, que devuelve <code>ImmutablePair&lt;Long, String&gt;</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Después de guardar el edge, la capa de aplicación pide a IAM su credencial (ACL, <code>IssueDeviceCredentialCommand</code>) y devuelve el id y el secreto una sola vez. El administrador lo copia en la configuración del edge (.env) antes de llevarlo al hogar; con <code>edgeId</code> y secreto el edge obtiene su token.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RegisterDeviceCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Registra un dispositivo, con las mismas reglas de MAC y negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>macAddress</code></td><td><code>String</code></td><td>private final</td><td>MAC del equipo; se valida y normaliza con <code>MacAddress</code>.</td></tr>
<tr><td><code>type</code></td><td><code>DeviceType</code></td><td>private final</td><td>Tipo de dispositivo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RegisterDeviceCommand(Long businessId, String macAddress, DeviceType type)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>DeviceCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateEdgeCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Corrige la MAC o el tipo de un edge. Existe (<code>EdgeNotFound</code>), es del negocio (<code>AssetNotInBusiness</code>), está <code>AVAILABLE</code> (<code>AssetNotEditable</code>) y la MAC nueva no la usa otro equipo (<code>MacAddressAlreadyExists</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>macAddress</code></td><td><code>String</code></td><td>private final</td><td>MAC del equipo; se valida y normaliza con <code>MacAddress</code>.</td></tr>
<tr><td><code>type</code></td><td><code>EdgeType</code></td><td>private final</td><td><code>MICROPHONE_EDGE</code> o <code>ACTUATOR_EDGE</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateEdgeCommand(Long edgeId, Long businessId, String macAddress, EdgeType type)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EdgeCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateDeviceCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Corrige la MAC o el tipo de un dispositivo, con las mismas reglas.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>deviceId</code></td><td><code>Long</code></td><td>private final</td><td>Id del dispositivo.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>macAddress</code></td><td><code>String</code></td><td>private final</td><td>MAC del equipo; se valida y normaliza con <code>MacAddress</code>.</td></tr>
<tr><td><code>type</code></td><td><code>DeviceType</code></td><td>private final</td><td>Tipo de dispositivo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateDeviceCommand(Long deviceId, Long businessId, String macAddress, DeviceType type)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>DeviceCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ChangeEdgeStatusCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Lo usa Soporte Técnico al revisar una falla. Solo acepta <code>MAINTENANCE</code>, <code>BROKEN</code> o <code>AVAILABLE</code> (reparado); <code>IN_USE</code> lo pone la red (<code>InvalidAssetStatusTransition</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>status</code></td><td><code>AssetStatus</code></td><td>private final</td><td><code>MAINTENANCE</code>, <code>BROKEN</code> o <code>AVAILABLE</code> (reparado).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ChangeEdgeStatusCommand(Long edgeId, Long businessId, AssetStatus status)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EdgeCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ChangeDeviceStatusCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Igual que el anterior, para un dispositivo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>deviceId</code></td><td><code>Long</code></td><td>private final</td><td>Id del dispositivo.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>status</code></td><td><code>AssetStatus</code></td><td>private final</td><td><code>MAINTENANCE</code>, <code>BROKEN</code> o <code>AVAILABLE</code> (reparado).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ChangeDeviceStatusCommand(Long deviceId, Long businessId, AssetStatus status)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>DeviceCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>MarkEdgeInUseCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Pasa el edge a <code>IN_USE</code>. Solo lo activa <code>AssetAssignedToNetworkEvent</code>; no se expone en la API.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>MarkEdgeInUseCommand(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EdgeCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ReleaseEdgeCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Devuelve el edge a <code>AVAILABLE</code>. Solo lo activa <code>AssetRemovedFromNetworkEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ReleaseEdgeCommand(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EdgeCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>MarkDeviceInUseCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Pasa el dispositivo a <code>IN_USE</code>. Solo lo activa <code>AssetAssignedToNetworkEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>deviceId</code></td><td><code>Long</code></td><td>private final</td><td>Id del dispositivo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>MarkDeviceInUseCommand(Long deviceId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>DeviceCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ReleaseDeviceCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Devuelve el dispositivo a <code>AVAILABLE</code>. Solo lo activa <code>AssetRemovedFromNetworkEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>deviceId</code></td><td><code>Long</code></td><td>private final</td><td>Id del dispositivo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ReleaseDeviceCommand(Long deviceId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>DeviceCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateDeviceNetworkCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea la red de una instalación con los equipos instalados. Lo activa <code>EquipmentInstalledEvent</code> de Support.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Instalación de Soporte Técnico.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Negocio dueño de los equipos.</td></tr>
<tr><td><code>microphoneEdgeId</code></td><td><code>Long</code></td><td>private final</td><td><code>Edge</code> del micrófono.</td></tr>
<tr><td><code>actuatorEdgeId</code></td><td><code>Long</code></td><td>private final</td><td><code>Edge</code> de los actuadores.</td></tr>
<tr><td><code>microphoneId</code></td><td><code>Long</code></td><td>private final</td><td>Micrófono asignado.</td></tr>
<tr><td><code>actuatorIds</code></td><td><code>List&lt;Long&gt;</code></td><td>private final</td><td>Ids de los actuadores en Assets.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateDeviceNetworkCommand(Long installationId, Long businessId, Long microphoneEdgeId, Long actuatorEdgeId, Long microphoneId, List&lt;Long&gt; actuatorIds)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>DeviceNetworkCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lo envía Soporte Técnico al terminar la instalación. La instalación no tiene otra red que no esté <code>DISMANTLED</code> (<code>DeviceNetworkAlreadyExists</code>). <code>GetDeviceNetworkByInstallationIdQuery</code> devuelve esa red, <code>ACTIVE</code> o <code>DEACTIVATED</code>: la usan ActuatorsAdded y EquipmentReplaced (<code>ACTIVE</code>), Deactivate (<code>ACTIVE</code>) y Dismantle (<code>DEACTIVATED</code>). Carga los <code>Edge</code> y <code>Device</code> por id (<code>EdgeNotFound</code>, <code>DeviceNotFound</code>) y se los pasa al constructor, que valida tipos, negocio y disponibilidad. El número de actuadores lo decide Soporte Técnico; Assets no lo limita. Add / Remove / Deactivate / Dismantle: la red existe (<code>DeviceNetworkNotFound</code>) y carga el equipo por id; las demás reglas las valida <code>DeviceNetwork</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AddEdgeToNetworkCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Asigna un edge a la red, por ejemplo para reemplazar uno retirado. La red existe (<code>DeviceNetworkNotFound</code>); las demás reglas las valida <code>DeviceNetwork.addEdge</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>networkId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la red.</td></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AddEdgeToNetworkCommand(Long networkId, Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>DeviceNetworkCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AddDeviceToNetworkCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Asigna el micrófono o un actuador a la red (<code>DeviceNetwork.addDevice</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>networkId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la red.</td></tr>
<tr><td><code>deviceId</code></td><td><code>Long</code></td><td>private final</td><td>Id del dispositivo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AddDeviceToNetworkCommand(Long networkId, Long deviceId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>DeviceNetworkCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RemoveEdgeFromNetworkCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Retira un edge de la red. También llega por <code>AssetStatusChangedEvent</code>: la capa de aplicación busca la red con <code>GetDeviceNetworkByEdgeIdQuery</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>networkId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la red.</td></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RemoveEdgeFromNetworkCommand(Long networkId, Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>DeviceNetworkCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RemoveDeviceFromNetworkCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Retira el micrófono o un actuador. También llega por <code>AssetStatusChangedEvent</code>, con <code>GetDeviceNetworkByDeviceIdQuery</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>networkId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la red.</td></tr>
<tr><td><code>deviceId</code></td><td><code>Long</code></td><td>private final</td><td>Id del dispositivo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RemoveDeviceFromNetworkCommand(Long networkId, Long deviceId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>DeviceNetworkCommandService</code>, que devuelve <code>Long</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeactivateDeviceNetworkCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Desactiva la red de una instalación cuyo servicio terminó. Lo activa <code>InstallationServiceEndedEvent</code> de Support.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>networkId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la red.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeactivateDeviceNetworkCommand(Long networkId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>DeviceNetworkCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lo activa el evento de Support que apaga el servicio al cancelarse la suscripción (<code>InstallationServiceEndedEvent</code>; la red se busca con <code>GetDeviceNetworkByInstallationIdQuery</code>). Si la instalación aún no tiene red, no hace nada.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DismantleDeviceNetworkCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Desmonta la red y libera los equipos que recogió el técnico. Lo activa <code>EquipmentRemovedEvent</code> de Support.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>networkId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la red.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DismantleDeviceNetworkCommand(Long networkId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>DeviceNetworkCommandService</code>, que devuelve <code>Long</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lo activa el evento de Support de la visita de retiro (<code>EquipmentRemovedEvent</code>). <code>RemoveEdgeFromNetworkCommand</code> y <code>RemoveDeviceFromNetworkCommand</code> también llegan por <code>AssetStatusChangedEvent</code>: la capa de aplicación busca la red con <code>GetDeviceNetworkByEdgeIdQuery</code> o <code>GetDeviceNetworkByDeviceIdQuery</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RenewEdgeCredentialCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El administrador pide otra credencial para un edge, para reutilizarlo o si se perdió el secreto.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge en Assets.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Negocio del administrador.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RenewEdgeCredentialCommand(Long edgeId, Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Lo atiende</b></td><td colspan="3"><code>EdgeCommandService</code>, que devuelve <code>String</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El edge existe, es del negocio y está <code>AVAILABLE</code> (<code>AssetNotAvailable</code>). La capa de aplicación revoca la credencial <code>ACTIVE</code> si la hay y pide una nueva a IAM; devuelve el secreto una sola vez. Se usa para reutilizar un edge que salió de una red o si se perdió el secreto. Update: el equipo existe y es del negocio; está <code>AVAILABLE</code> (<code>AssetNotEditable</code>); la MAC nueva es válida y no la usa otro edge o device (las mismas dos queries; <code>MacAddressAlreadyExists</code>). ChangeStatus: el equipo existe (<code>EdgeNotFound</code>, <code>DeviceNotFound</code>) y es del negocio (<code>AssetNotInBusiness</code>). Solo acepta <code>MAINTENANCE</code>, <code>BROKEN</code> o <code>AVAILABLE</code> (reparado); <code>IN_USE</code> lo pone la red (<code>InvalidAssetStatusTransition</code>). Lo usa Soporte Técnico cuando revisa una falla. MarkInUse y Release: solo los activan los eventos de la red; no se exponen en la API.</td></tr>
</table>

#### Queries

<table>
<tr><th colspan="4" align="left"><code>GetEdgeByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3"><code>Edge</code> por id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetEdgeByIdQuery(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Edge&gt;</code> (<code>EdgeQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllEdgesByBusinessIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Edges del inventario de un negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllEdgesByBusinessIdQuery(Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Edge&gt;</code> (<code>EdgeQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetDeviceByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Dispositivo por id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>deviceId</code></td><td><code>Long</code></td><td>private final</td><td>Id del dispositivo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetDeviceByIdQuery(Long deviceId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Device&gt;</code> (<code>DeviceQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllDevicesByBusinessIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Dispositivos del inventario de un negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllDevicesByBusinessIdQuery(Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Device&gt;</code> (<code>DeviceQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ExistsEdgeByMacAddressQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica si algún edge ya usa la MAC.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>macAddress</code></td><td><code>String</code></td><td>private final</td><td>MAC del equipo; se valida y normaliza con <code>MacAddress</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ExistsEdgeByMacAddressQuery(String macAddress)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>boolean</code> (<code>EdgeQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetEdgeByMacAddressQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3"><code>Edge</code> por MAC. La usa Support para identificar los equipos que instala o reemplaza el técnico.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>macAddress</code></td><td><code>String</code></td><td>private final</td><td>MAC del equipo; se valida y normaliza con <code>MacAddress</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetEdgeByMacAddressQuery(String macAddress)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Edge&gt;</code> (<code>EdgeQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetDeviceByMacAddressQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Dispositivo por MAC. La usa Support para identificar los equipos que instala o reemplaza el técnico.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>macAddress</code></td><td><code>String</code></td><td>private final</td><td>MAC del equipo; se valida y normaliza con <code>MacAddress</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetDeviceByMacAddressQuery(String macAddress)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Device&gt;</code> (<code>DeviceQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ExistsDeviceByMacAddressQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica si algún dispositivo ya usa la MAC.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>macAddress</code></td><td><code>String</code></td><td>private final</td><td>MAC del equipo; se valida y normaliza con <code>MacAddress</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ExistsDeviceByMacAddressQuery(String macAddress)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>boolean</code> (<code>DeviceQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetDeviceNetworkByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Red por id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>networkId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la red.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetDeviceNetworkByIdQuery(Long networkId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;DeviceNetwork&gt;</code> (<code>DeviceNetworkQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetDeviceNetworkByInstallationIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Red de una instalación que no está <code>DISMANTLED</code> (<code>ACTIVE</code> o <code>DEACTIVATED</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación de Soporte Técnico.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetDeviceNetworkByInstallationIdQuery(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;DeviceNetwork&gt;</code> (<code>DeviceNetworkQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetDeviceNetworkByEdgeIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Red que tiene asignado el edge.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetDeviceNetworkByEdgeIdQuery(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;DeviceNetwork&gt;</code> (<code>DeviceNetworkQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetDeviceNetworkByDeviceIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Red que tiene asignado el dispositivo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>deviceId</code></td><td><code>Long</code></td><td>private final</td><td>Id del dispositivo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetDeviceNetworkByDeviceIdQuery(Long deviceId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;DeviceNetwork&gt;</code> (<code>DeviceNetworkQueryService</code>)</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetEdgeAccessTableQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tabla del edge que la pide, con su token (el <code>edgeId</code> sale del token). Sin red <code>ACTIVE</code>, <code>Optional</code> vacío.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetEdgeAccessTableQuery(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;EdgeAccessTable&gt;</code> (<code>DeviceNetworkQueryService</code>)</td></tr>
</table>

#### Domain Services

**Reglas comunes de `EdgeCommandService`, `DeviceCommandService`.** Register: la MAC es válida (`InvalidMacAddress`) y no existe en ningún `Edge` ni `Device`: consulta `ExistsEdgeByMacAddressQuery` y `ExistsDeviceByMacAddressQuery` (`MacAddressAlreadyExists`). El negocio existe en Company (`BusinessNotFound`, vía ACL).

<table>
<tr><th colspan="4" align="left"><code>EdgeCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Edge</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(RegisterEdgeCommand command)</code></td><td><code>ImmutablePair&lt;Long, String&gt;</code></td><td>public</td><td>Ejecuta <code>RegisterEdgeCommand</code> y devuelve el id del edge y su secreto, una sola vez.</td></tr>
<tr><td><code>handle(RenewEdgeCredentialCommand command)</code></td><td><code>String</code></td><td>public</td><td>Ejecuta <code>RenewEdgeCredentialCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><code>handle(UpdateEdgeCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>UpdateEdgeCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(ChangeEdgeStatusCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ChangeEdgeStatusCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(MarkEdgeInUseCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>MarkEdgeInUseCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(ReleaseEdgeCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ReleaseEdgeCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EdgeQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Edge</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetEdgeByIdQuery query)</code></td><td><code>Optional&lt;Edge&gt;</code></td><td>public</td><td>Resuelve <code>GetEdgeByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetAllEdgesByBusinessIdQuery query)</code></td><td><code>List&lt;Edge&gt;</code></td><td>public</td><td>Resuelve <code>GetAllEdgesByBusinessIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(ExistsEdgeByMacAddressQuery query)</code></td><td><code>boolean</code></td><td>public</td><td>Resuelve <code>ExistsEdgeByMacAddressQuery</code>.</td></tr>
<tr><td><code>handle(GetEdgeByMacAddressQuery query)</code></td><td><code>Optional&lt;Edge&gt;</code></td><td>public</td><td>Resuelve <code>GetEdgeByMacAddressQuery</code>; devuelve vacío si no existe.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Device</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(RegisterDeviceCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>RegisterDeviceCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(UpdateDeviceCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>UpdateDeviceCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(ChangeDeviceStatusCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ChangeDeviceStatusCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(MarkDeviceInUseCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>MarkDeviceInUseCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(ReleaseDeviceCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ReleaseDeviceCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Device</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetDeviceByIdQuery query)</code></td><td><code>Optional&lt;Device&gt;</code></td><td>public</td><td>Resuelve <code>GetDeviceByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetAllDevicesByBusinessIdQuery query)</code></td><td><code>List&lt;Device&gt;</code></td><td>public</td><td>Resuelve <code>GetAllDevicesByBusinessIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(ExistsDeviceByMacAddressQuery query)</code></td><td><code>boolean</code></td><td>public</td><td>Resuelve <code>ExistsDeviceByMacAddressQuery</code>.</td></tr>
<tr><td><code>handle(GetDeviceByMacAddressQuery query)</code></td><td><code>Optional&lt;Device&gt;</code></td><td>public</td><td>Resuelve <code>GetDeviceByMacAddressQuery</code>; devuelve vacío si no existe.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceNetworkCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>DeviceNetwork</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateDeviceNetworkCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateDeviceNetworkCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(AddEdgeToNetworkCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>AddEdgeToNetworkCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(AddDeviceToNetworkCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>AddDeviceToNetworkCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(RemoveEdgeFromNetworkCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>RemoveEdgeFromNetworkCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(RemoveDeviceFromNetworkCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>RemoveDeviceFromNetworkCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(DeactivateDeviceNetworkCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>DeactivateDeviceNetworkCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(DismantleDeviceNetworkCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>DismantleDeviceNetworkCommand</code> y devuelve el id del aggregate creado o modificado.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Assets decide quién puede enviar a quién (<code>tableFor</code>). IAM solo autentica al edge cuando llama a la API: la credencial nace al registrar el edge y IAM la revoca cuando el edge sale de una red o la red se desactiva.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceNetworkQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>DeviceNetwork</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetDeviceNetworkByIdQuery query)</code></td><td><code>Optional&lt;DeviceNetwork&gt;</code></td><td>public</td><td>Resuelve <code>GetDeviceNetworkByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetDeviceNetworkByInstallationIdQuery query)</code></td><td><code>Optional&lt;DeviceNetwork&gt;</code></td><td>public</td><td>Resuelve <code>GetDeviceNetworkByInstallationIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetDeviceNetworkByEdgeIdQuery query)</code></td><td><code>Optional&lt;DeviceNetwork&gt;</code></td><td>public</td><td>Resuelve <code>GetDeviceNetworkByEdgeIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetDeviceNetworkByDeviceIdQuery query)</code></td><td><code>Optional&lt;DeviceNetwork&gt;</code></td><td>public</td><td>Resuelve <code>GetDeviceNetworkByDeviceIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetEdgeAccessTableQuery query)</code></td><td><code>Optional&lt;EdgeAccessTable&gt;</code></td><td>public</td><td>Resuelve <code>GetEdgeAccessTableQuery</code>; devuelve vacío si no existe.</td></tr>
</table>

#### Exceptions

<table>
<tr><th colspan="4" align="left"><code>EdgeNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe el edge indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EdgeNotFound(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe el dispositivo indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceNotFound(Long deviceId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceNetworkNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe la red indicada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceNetworkNotFound(Long networkId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidMacAddress</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la MAC no tiene seis pares hexadecimales separados por ":" o "-".</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidMacAddress(String macAddress)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>MacAddressAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la MAC ya la usa otro edge o dispositivo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>MacAddressAlreadyExists(String macAddress)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el negocio no existe en Company (validado vía ACL al registrar un equipo).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessNotFound(Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssetNotInBusiness</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el equipo no pertenece al negocio indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssetNotInBusiness(Long assetId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidAssetStatusTransition</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el cambio de estado no está permitido (ej. poner <code>IN_USE</code> a mano).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidAssetStatusTransition(AssetStatus from, AssetStatus to)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssetNotAvailable</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se asigna a una red un equipo que no está <code>AVAILABLE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssetNotAvailable(Long assetId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssetNotEditable</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se corrige la MAC o el tipo de un equipo que no está <code>AVAILABLE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssetNotEditable(Long assetId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidNetworkMember</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el equipo no es del tipo que pide su lugar en la red (ej. un actuador como micrófono).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidNetworkMember(Long assetId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>NodeTypeAlreadyInNetwork</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la red ya tiene un micrófono, un edge de micrófono o un edge de actuadores.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>NodeTypeAlreadyInNetwork(NodeType type)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssetAlreadyInNetwork</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el actuador ya está en la red.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssetAlreadyInNetwork(Long assetId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssetNotInNetwork</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se retira de la red un equipo que no está asignado a ella.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssetNotInNetwork(Long assetId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceNetworkAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la instalación ya tiene una red que no está <code>DISMANTLED</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceNetworkAlreadyExists(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceNetworkDeactivated</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta modificar una red desactivada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceNetworkDeactivated(Long networkId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidNetworkStatusTransition</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el cambio de estado de la red no está permitido (desactivar una red que no está <code>ACTIVE</code> o desmontar una que no está <code>DEACTIVATED</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidNetworkStatusTransition(NetworkStatus from, NetworkStatus to)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con el dato que la causó.</td></tr>
</table>

### 5.11.2. Interface Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.11.1.

### 5.11.3. Application Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.11.1.

### 5.11.4. Infrastructure Layer

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.11.1.

### 5.11.6. Bounded Context Software Architecture Component Level Diagrams

Pendiente. Se documenta cuando se diseñe esta capa, a partir del Domain Layer de la sección 5.11.1.

### 5.11.7. Bounded Context Software Architecture Code Level Diagrams

#### 5.11.7.1. Bounded Context Domain Layer Class Diagrams

El diagrama muestra la base abstracta `Asset` con sus dos aggregates (`Edge` y `Device`) y el aggregate `DeviceNetwork`, que referencia directamente a los equipos asignados (un edge de micrófono, un edge de actuadores, un micrófono y N actuadores). `DeviceNetwork` calcula la `EdgeAccessTable` de cada edge con sus `NodeRef`. Los eventos de la red y del estado de los equipos activan commands dentro del contexto y los consumen IAM, Tracking y Analytics. Las notas detallan las reglas de cada service.

![Diagrama de clases de la capa de dominio - Bienes](../images/diagrams/img/chapter-5/devices-backend-diagram.svg)

#### 5.11.7.2. Bounded Context Database Design Diagram

La base de datos es PostgreSQL.

| Tabla o colección | Aggregate, entidad o value object | Llaves y restricciones |
|---|---|---|
| `edges` | `Edge` (con `MacAddress` embebido) | PK `id`. UK `mac_address`. Referencia a Company sin FK: `business_id`. |
| `devices` | `Device` (con `MacAddress` embebido) | PK `id`. UK `mac_address`. Referencia a Company sin FK: `business_id`. |
| `device_networks` | `DeviceNetwork` | PK `id`. FK `microphone_edge_id`, `actuator_edge_id`, `microphone_id`. Referencia a Soporte Técnico sin FK: `installation_id`. Referencia a Company sin FK: `business_id`. UK parcial (`installation_id`) WHERE status <> '`DISMANTLED`'. UK (`microphone_edge_id`), UK (`actuator_edge_id`), UK (`microphone_id`). |
| `network_actuators` | Relación `actuators` de `DeviceNetwork` | UK `device_id`. FK `network_id`, `device_id`. |

Relaciones entre tablas: `device_networks` a `edges` (microphone_edge_id (0..1)); `device_networks` a `edges` (actuator_edge_id (0..1)); `device_networks` a `devices` (microphone_id (0..1)); `device_networks` a `network_actuators` (actuators (0..*)); `network_actuators` a `devices` (device_id).

**edges** (aggregate `Edge`) type: `MICROPHONE_EDGE` o `ACTUATOR_EDGE`. status: `AVAILABLE`, `IN_USE`, `MAINTENANCE` o `BROKEN`. `mac_address` normalizada (AA:BB:CC:DD:EE:FF). `business_id`: `Business` de Company. Sin FK. Sin límite de registros por negocio.



**devices** (aggregate `Device`) type: `MICROPHONE`, `DOOR`, `WINDOW`, `CURTAIN` o `LIGHT`. Mismos estados que edges. La MAC es única en cada tabla; que no se repita entre edges y devices lo valida el dominio (`MacAddressAlreadyExists`).



**`device_networks`** (aggregate `DeviceNetwork`) `installation_id`: instalación de Soporte Técnico (`InstallationId`). Sin FK: otro contexto. `microphone_edge_id`, `actuator_edge_id` y `microphone_id`: referencias directas (mismo contexto) con FK. Un solo campo por tipo: una red tiene 1 edge de micrófono, 1 edge de actuadores y 1 micrófono. Son nulos mientras el equipo retirado no se reemplaza. UK de cada campo de equipo: un equipo está en una sola red. PostgreSQL admite varios NULL en un UNIQUE, y al desmontar la red sus campos quedan vacíos. status: `DEACTIVATED` al cancelarse la suscripción (los equipos siguen en el hogar, la red no da tabla); `DISMANTLED` cuando el técnico los recoge (campos vacíos, equipos `AVAILABLE`). UK parcial de `installation_id`: una instalación tiene una sola red que no esté `DISMANTLED` (`ACTIVE` o `DEACTIVATED`); las desmontadas se conservan como historial.



**`network_actuators`**. Lista de actuadores de la red (`@ManyToMany` de `DeviceNetwork` a `Device`). Sin id propio. UK (`device_id`): un actuador está en una sola red a la vez. Al retirarlo o desmontar la red, su fila se borra.




![Diagrama de base de datos - Bienes](../images/diagrams/img/chapter-5/devices-database-diagram.svg)

<div style="page-break-after: always;"></div>
