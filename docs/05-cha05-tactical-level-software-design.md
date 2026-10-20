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
| Referencia a otro contexto | Un bounded context nunca guarda objetos de otro: solo su identidad mediante un value object de Shared (`UserId`, `PersonProfileId`, `StaffProfileId`, `BusinessProfileId`, `BusinessId`). |
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

**Formato del diccionario de clases.** Cada clase se presenta en un recuadro con su nombre, categoría, propósito, atributos (nombre, tipo de dato, visibilidad y descripción), métodos (firma, tipo de retorno, visibilidad y descripción), reglas o invariantes y relaciones con otras clases (tipo, clase relacionada, multiplicidad y descripción). Las clases se agrupan por categoría: Aggregates, Entities, Value Objects, Enumerations, Domain Events, Commands, Queries, Domain Services y Exceptions.


## Elementos compartidos (Shared)

Shared reúne los elementos que usan todos los bounded contexts de Alivia: las bases auditables de aggregates y entidades, y los value objects comunes. No tiene commands, queries ni services propios: no representa un proceso de negocio, sino el vocabulario común con el que los demás contextos se referencian entre sí.

### Domain Layer

#### Aggregates (bases abstractas)

<table>
<tr><th colspan="4" align="left"><code>AuditableAbstractAggregateRoot</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Clase abstracta base de aggregates</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Base de todos los aggregates guardados en PostgreSQL. Aporta el id, las fechas de auditoría y el registro de eventos de dominio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>id</code></td><td><code>Long</code></td><td>private</td><td>Identificador generado por la base de datos.</td></tr>
<tr><td><code>createdAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Fecha y hora de creación.</td></tr>
<tr><td><code>updatedAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Fecha y hora de la última modificación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>addDomainEvent(Object event)</code></td><td><code>void</code></td><td>public</td><td>Registra un evento de dominio que se publica después de guardar el aggregate.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AuditableMongoAggregateRoot</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Clase abstracta base de aggregates</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">La misma base que la anterior, para aggregates guardados en MongoDB (tracking). Su id es de texto.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>id</code></td><td><code>String</code></td><td>private</td><td>Identificador del documento en MongoDB.</td></tr>
<tr><td><code>createdAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Fecha y hora de creación.</td></tr>
<tr><td><code>updatedAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Fecha y hora de la última modificación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>addDomainEvent(Object event)</code></td><td><code>void</code></td><td>public</td><td>Registra un evento de dominio que se publica después de guardar el aggregate.</td></tr>
</table>

#### Entities (base abstracta)

<table>
<tr><th colspan="4" align="left"><code>AuditableModel</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Clase abstracta base de entidades</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Base de las entidades internas de un aggregate (por ejemplo, <code>ActivityAssignment</code>, <code>Contract</code>, <code>Vacation</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>id</code></td><td><code>Long</code></td><td>private</td><td>Identificador generado por la base de datos.</td></tr>
<tr><td><code>createdAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Fecha y hora de creación.</td></tr>
<tr><td><code>updatedAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Fecha y hora de la última modificación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

#### Value Objects

**Value objects de identidad**

Representan la identidad de un aggregate de otro contexto. Son la única forma en que un bounded context referencia a otro.

<table>
<tr><th colspan="4" align="left"><code>UserId</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record), identidad</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Identidad de <code>User</code> de IAM en otro bounded context.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UserId(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Crea la instancia y valida sus invariantes.</td></tr>
<tr><td><b>Invariantes</b></td><td colspan="3">No nulo y mayor que 0.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PersonProfileId</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record), identidad</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Identidad de <code>PersonProfile</code> de Profiles (clientes) en otro bounded context.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>personProfileId</code></td><td><code>Long</code></td><td>private final</td><td>Su perfil de cliente en Profiles.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PersonProfileId(Long personProfileId)</code></td><td>(constructor)</td><td>public</td><td>Crea la instancia y valida sus invariantes.</td></tr>
<tr><td><b>Invariantes</b></td><td colspan="3">No nulo y mayor que 0.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>StaffProfileId</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record), identidad</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Identidad de <code>StaffProfile</code> de Profiles (personal de Alivia) en otro bounded context.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>staffProfileId</code></td><td><code>Long</code></td><td>private final</td><td>Su perfil de personal en Profiles.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>StaffProfileId(Long staffProfileId)</code></td><td>(constructor)</td><td>public</td><td>Crea la instancia y valida sus invariantes.</td></tr>
<tr><td><b>Invariantes</b></td><td colspan="3">No nulo y mayor que 0.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessProfileId</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record), identidad</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Identidad de <code>BusinessProfile</code> de Profiles en otro bounded context.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessProfileId</code></td><td><code>Long</code></td><td>private final</td><td>Identidad de sus datos en Profiles.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessProfileId(Long businessProfileId)</code></td><td>(constructor)</td><td>public</td><td>Crea la instancia y valida sus invariantes.</td></tr>
<tr><td><b>Invariantes</b></td><td colspan="3">No nulo y mayor que 0.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessId</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record), identidad</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Identidad de <code>Business</code> de Company en otro bounded context.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessId(Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Crea la instancia y valida sus invariantes.</td></tr>
<tr><td><b>Invariantes</b></td><td colspan="3">No nulo y mayor que 0.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InstallationId</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record), identidad</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Identidad de Instalación de Soporte Técnico en otro bounded context.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación de Soporte Técnico.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InstallationId(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la instancia y valida sus invariantes.</td></tr>
<tr><td><b>Invariantes</b></td><td colspan="3">No nulo y mayor que 0.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailAddress</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Correo electrónico válido y normalizado. Permite que la validación de correo ya registrado trate <code>Ana@x.com</code> y <code>ana@x.com</code> como el mismo correo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo con formato válido, sin espacios y en minúsculas.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmailAddress(String emailAddress)</code></td><td>(constructor)</td><td>public</td><td>Valida el formato y normaliza el correo.</td></tr>
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
<tr><td><code>PhoneNumber(String phoneNumber)</code></td><td>(constructor)</td><td>public</td><td>Rechaza letras, espacios y símbolos, y números que no son válidos según el plan de numeración del país de su código (ej. Perú: 51 + móvil de 9 dígitos que empieza en 9).</td></tr>
<tr><td><code>countryCallingCode()</code></td><td><code>String</code></td><td>public</td><td>Devuelve el código de país del número.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Photo</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Referencia a una imagen ya subida a almacenamiento externo. El archivo se sube fuera del dominio; el aggregate solo guarda la referencia.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>photoUrl</code></td><td><code>String</code></td><td>private final</td><td>URL pública de la imagen. No vacía.</td></tr>
<tr><td><code>photoPublicId</code></td><td><code>String</code></td><td>private final</td><td>Identificador de la imagen en el servicio de almacenamiento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Photo(String photoUrl, String photoPublicId)</code></td><td>(constructor)</td><td>public</td><td>Crea la referencia; rechaza una URL vacía.</td></tr>
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
<tr><td><code>Address(String formattedAddress, Double latitude, Double longitude, String placeId)</code></td><td>(constructor)</td><td>public</td><td>Valida la dirección y el rango de las coordenadas.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>TimeRange</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Intervalo de horas semiabierto <code>[start, end)</code>. Lo usan los horarios del negocio, de trabajo y de cuidado. Si <code>end</code> es anterior a <code>start</code>, el rango cruza medianoche (22:00-06:00); cada contexto decide si lo acepta.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>start</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de inicio (incluida).</td></tr>
<tr><td><code>end</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de fin (excluida). Distinta de <code>start</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>TimeRange(LocalTime start, LocalTime end)</code></td><td>(constructor)</td><td>public</td><td>Rechaza horas nulas o iguales.</td></tr>
<tr><td><code>contains(LocalTime time)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si una hora está dentro del rango. En 22:00-06:00, las 23:00 y las 03:00 están dentro.</td></tr>
<tr><td><code>contains(TimeRange other)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si otro rango está completamente dentro de este.</td></tr>
<tr><td><code>overlaps(TimeRange other)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si ambos rangos comparten algún tramo, empezando el mismo día. 09:00-10:00 y 10:00-11:00 no se cruzan.</td></tr>
<tr><td><code>duration()</code></td><td><code>Duration</code></td><td>public</td><td>Tiempo total del rango (22:00-06:00 dura 8 horas).</td></tr>
<tr><td><code>crossesMidnight()</code></td><td><code>boolean</code></td><td>public</td><td>Verdadero si <code>end</code> es anterior a <code>start</code>.</td></tr>
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
<tr><td><code>WeeklyPeriod(Set&lt;DayOfWeek&gt; days, TimeRange range)</code></td><td>(constructor)</td><td>public</td><td>Rechaza días vacíos o un rango nulo.</td></tr>
<tr><td><code>occursOn(LocalDate date)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el periodo empieza en el día de la semana de esa fecha.</td></tr>
<tr><td><code>overlapsWith(WeeklyPeriod other)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si alguna ocurrencia de uno se cruza con alguna del otro. Si un rango cruza medianoche, también compara con el día siguiente (lunes 22:00-06:00 se cruza con martes 05:00-07:00).</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>range</code>)</td><td><code>TimeRange</code></td><td>1 a 1</td><td>Cada periodo tiene un único rango de horas.</td></tr>
</table>

#### Enumerations

<table>
<tr><th colspan="4" align="left"><code>EmailTemplate</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Plantillas de los correos que envía la plataforma. Se trasladará al bounded context Communication.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td><code>WELCOME</code></td><td colspan="3">Plantilla del correo de bienvenida.</td></tr>
<tr><td><code>RESET_PASSWORD</code></td><td colspan="3">Plantilla del correo para restablecer la contraseña.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
<tr><td><b>Notas</b></td><td colspan="3">Esta enumeración se trasladará al bounded context Communication cuando se diseñe ese contexto.</td></tr>
</table>

### Code Level Diagrams

#### Domain Layer Class Diagram

El diagrama muestra las bases abstractas y los value objects compartidos, con sus atributos, métodos y visibilidad. La única relación propia de Shared es la composición entre `WeeklyPeriod` y `TimeRange` (1 a 1). Las notas del diagrama documentan las invariantes de cada value object.

![Diagrama de clases de la capa de dominio - Shared](../images/diagrams/img/chapter-5/shared-backend-diagram.svg)

#### Database Design Diagram

Shared no tiene tablas propias. Sus bases se reflejan en las tablas de cada contexto: toda tabla de aggregate o entidad tiene `id` (`BIGINT`, identity), `created_at` y `updated_at` (`TIMESTAMP`). Sus value objects se guardan como columnas de la tabla que los usa (por ejemplo, `Address` se guarda como `address_formatted_address`, `address_latitude`, `address_longitude` y `address_place_id` en `business_profiles`), y los value objects de identidad, como columnas `BIGINT` sin llave foránea, porque apuntan a otro bounded context.


<div style="page-break-after: always;"></div>

## 5.1. Bounded Context: IAM

En el código, este bounded context es el paquete `iam`. IAM gestiona las cuentas con las que las personas y los edges acceden a Alivia: el registro con verificación de correo, el inicio de sesión, las contraseñas, los roles y las credenciales de los edges. Una cuenta se identifica con su correo, que es el mismo del perfil de la persona, y cada correo es una sola cuenta. Las cuentas son personales (familiar o cuidador, con un solo rol) o corporativas (administrador y empleados). Los demás contextos guardan solo el `UserId` de la cuenta y le piden a IAM, mediante su ACL, que la cree; IAM no guarda ids de otros contextos de personas. Se basa en el contexto IAM del repositorio de referencia (`User`, `Role`, `SignUp`, `SignIn` y la carga inicial de roles), con el hash de contraseñas y los tokens JWT en la capa de aplicación.

### 5.1.1. Domain Layer

#### Aggregates

<table>
<tr><th colspan="4" align="left"><code>User</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Una cuenta de Alivia: correo, contraseña, tipo de cuenta, estado y roles.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>EmailAddress</code></td><td>private</td><td>Correo de la cuenta, normalizado en minúsculas. Es el usuario para iniciar sesión y no se repite (<code>EmailAddressAlreadyExists</code>).</td></tr>
<tr><td><code>password</code></td><td><code>HashedPassword</code></td><td>private</td><td>Contraseña hasheada. Vacía mientras un cuidador invitado no define la suya.</td></tr>
<tr><td><code>temporaryPassword</code></td><td><code>boolean</code></td><td>private</td><td>Verdadero mientras el empleado no cambia su contraseña temporal.</td></tr>
<tr><td><code>accountType</code></td><td><code>AccountType</code></td><td>private</td><td><code>PERSONAL</code> o <code>CORPORATE</code>.</td></tr>
<tr><td><code>status</code></td><td><code>AccountStatus</code></td><td>private</td><td><code>PENDING</code>, <code>ACTIVE</code>, <code>BLOCKED</code> o <code>DEACTIVATED</code>.</td></tr>
<tr><td><code>roles</code></td><td><code>Set&lt;Role&gt;</code></td><td>private</td><td>Roles de la cuenta. Una cuenta personal tiene un solo rol: <code>ROLE_RELATIVE</code> o <code>ROLE_CAREGIVER</code>.</td></tr>
<tr><td><code>passwordToken</code></td><td><code>PasswordToken</code></td><td>private</td><td>Enlace vigente para definir o recuperar la contraseña, si lo hay.</td></tr>
<tr><td><code>emailVerified</code></td><td><code>boolean</code></td><td>private</td><td>Verdadero cuando el correo está verificado.</td></tr>
<tr><td><code>verificationCode</code></td><td><code>VerificationCode</code></td><td>private</td><td>Código de verificación vigente, si lo hay.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>signUp(EmailAddress emailAddress, HashedPassword password, Role role, VerificationCode code, String rawCode)</code></td><td><code>User</code></td><td>public static</td><td>Cuenta de quien se registra solo (administrador o familiar): <code>PENDING</code> hasta verificar su correo. El tipo de cuenta sale del rol. Registra <code>EmailVerificationRequestedEvent</code>.</td></tr>
<tr><td><code>invited(EmailAddress emailAddress, Role caregiverRole, PasswordToken token)</code></td><td><code>User</code></td><td>public static</td><td>Cuenta personal <code>PENDING</code> de un cuidador invitado, sin contraseña, con <code>ROLE_CAREGIVER</code> y un token <code>SETUP</code>.</td></tr>
<tr><td><code>corporate(EmailAddress emailAddress, HashedPassword temporaryPassword, Role role)</code></td><td><code>User</code></td><td>public static</td><td>Cuenta corporativa <code>PENDING</code> de un empleado, con contraseña temporal y su rol. Registra <code>CorporateAccountCreatedEvent</code>.</td></tr>
<tr><td><code>replaceCorporateRole(Role role)</code></td><td><code>void</code></td><td>public</td><td>Cambia el rol de un empleado; solo en cuentas corporativas con rol de empleado.</td></tr>
<tr><td><code>hasRole(Roles role)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la cuenta tiene el rol.</td></tr>
<tr><td><code>verifyEmail(String codeHash, LocalDateTime now)</code></td><td><code>void</code></td><td>public</td><td>Verifica el correo: el código coincide (<code>InvalidVerificationCode</code>), no venció (<code>VerificationCodeExpired</code>) y el correo no estaba verificado (<code>EmailAlreadyVerified</code>). Deja la cuenta <code>ACTIVE</code>.</td></tr>
<tr><td><code>renewVerificationCode(VerificationCode code, String rawCode)</code></td><td><code>void</code></td><td>public</td><td>Reemplaza el código si el correo no está verificado (<code>EmailAlreadyVerified</code>). Registra <code>EmailVerificationRequestedEvent</code>.</td></tr>
<tr><td><code>issuePasswordToken(PasswordToken token)</code></td><td><code>void</code></td><td>public</td><td><code>SETUP</code>: solo en una cuenta <code>PENDING</code> sin contraseña (regenera el enlace). <code>RESET</code>: solo en una cuenta <code>ACTIVE</code> (<code>AccountNotActive</code>); registra <code>PasswordResetRequestedEvent</code>.</td></tr>
<tr><td><code>definePassword(String tokenHash, HashedPassword password, LocalDateTime now)</code></td><td><code>void</code></td><td>public</td><td>Define la contraseña con el enlace: el token coincide (<code>InvalidPasswordToken</code>) y no venció (<code>PasswordTokenExpired</code>). Deja la cuenta <code>ACTIVE</code> y, si estaba <code>PENDING</code>, registra <code>PasswordDefinedEvent</code>.</td></tr>
<tr><td><code>changeTemporaryPassword(HashedPassword password)</code></td><td><code>void</code></td><td>public</td><td>El empleado reemplaza su contraseña temporal (<code>PasswordNotTemporary</code>). Deja la cuenta <code>ACTIVE</code> y registra <code>PasswordDefinedEvent</code>.</td></tr>
<tr><td><code>changePassword(HashedPassword password)</code></td><td><code>void</code></td><td>public</td><td>Cambia la contraseña de una cuenta <code>ACTIVE</code> (<code>AccountNotActive</code>).</td></tr>
<tr><td><code>block()</code></td><td><code>void</code></td><td>public</td><td>De <code>PENDING</code> o <code>ACTIVE</code> a <code>BLOCKED</code> (empleado suspendido).</td></tr>
<tr><td><code>unblock()</code></td><td><code>void</code></td><td>public</td><td>De <code>BLOCKED</code> a <code>ACTIVE</code>, o a <code>PENDING</code> si aún no completó su activación.</td></tr>
<tr><td><code>deactivate()</code></td><td><code>void</code></td><td>public</td><td>A <code>DEACTIVATED</code>, estado final (empleado cesado).</td></tr>
<tr><td><code>canSignIn()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la cuenta está <code>ACTIVE</code>.</td></tr>
<tr><td><code>hasDefinedPassword()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si ya tiene una contraseña.</td></tr>
<tr><td><code>isEmailVerified()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el correo está verificado.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Cada rol se asigna solo a su tipo de cuenta (<code>RoleNotAllowedForAccountType</code>). Una transición de estado no permitida lanza <code>InvalidAccountStatusTransition</code>. Una cuenta <code>ACTIVE</code> siempre tiene el correo verificado y una contraseña definitiva. El cuidador invitado y el empleado verifican su correo al activarse, porque el enlace o la contraseña temporal les llegó a ese correo.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>roles</code>)</td><td><code>Role</code></td><td>0..* a 1..*</td><td>Roles de la cuenta.</td></tr>
<tr><td>Composición (<code>password</code>)</td><td><code>HashedPassword</code></td><td>1 a 0..1</td><td>Contraseña hasheada.</td></tr>
<tr><td>Composición (<code>passwordToken</code>)</td><td><code>PasswordToken</code></td><td>1 a 0..1</td><td>Enlace vigente.</td></tr>
<tr><td>Composición (<code>verificationCode</code>)</td><td><code>VerificationCode</code></td><td>1 a 0..1</td><td>Código vigente.</td></tr>
<tr><td>Asociaciones (<code>accountType</code>, <code>status</code>)</td><td><code>AccountType</code>, <code>AccountStatus</code></td><td>0..* a 1</td><td>Tipo y estado de la cuenta.</td></tr>
<tr><td>Dependencia "registra"</td><td>Eventos de la cuenta</td><td>No aplica</td><td>Verificación, contraseña definida, cuenta corporativa y recuperación.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceCredential</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Credencial con la que un edge se autentica ante la API. Assets decide qué puede enviar el edge; IAM solo lo autentica.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private</td><td>Id del <code>Edge</code> de Assets.</td></tr>
<tr><td><code>secret</code></td><td><code>HashedPassword</code></td><td>private</td><td>Secreto del edge, hasheado.</td></tr>
<tr><td><code>status</code></td><td><code>CredentialStatus</code></td><td>private</td><td><code>ACTIVE</code> o <code>REVOKED</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceCredential(Long edgeId, HashedPassword secret)</code></td><td>(constructor)</td><td>public</td><td>Crea la credencial <code>ACTIVE</code>.</td></tr>
<tr><td><code>revoke()</code></td><td><code>void</code></td><td>public</td><td>De <code>ACTIVE</code> a <code>REVOKED</code> (<code>DeviceCredentialRevoked</code> si ya lo está).</td></tr>
<tr><td><code>isActive()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la credencial está <code>ACTIVE</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Un edge tiene una sola credencial <code>ACTIVE</code> (<code>DeviceCredentialAlreadyExists</code>). Se emite cuando el edge se asigna a una red; el secreto se genera en la capa de aplicación, se muestra una sola vez para configurar el edge y se guarda hasheado. Se revoca cuando el edge sale de la red.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>secret</code>)</td><td><code>HashedPassword</code></td><td>1 a 1</td><td>Secreto hasheado.</td></tr>
<tr><td>Asociación (<code>status</code>)</td><td><code>CredentialStatus</code></td><td>0..* a 1</td><td>Estado de la credencial.</td></tr>
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
<tr><td>Asociación (<code>name</code>)</td><td><code>Roles</code></td><td>0..* a 1</td><td>Valor del rol.</td></tr>
</table>

#### Value Objects

<table>
<tr><th colspan="4" align="left"><code>HashedPassword</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Contraseña o secreto ya hasheado por <code>HashingService</code> en la capa de aplicación. No vacío.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>value</code></td><td><code>String</code></td><td>private final</td><td>Hash de la contraseña o del secreto.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>HashedPassword(String value)</code></td><td>(constructor)</td><td>public</td><td>Crea la instancia y valida sus invariantes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PasswordToken</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Enlace de un solo uso para definir la contraseña de una cuenta invitada (<code>SETUP</code>) o recuperarla (<code>RESET</code>). El token real va en la url; aquí solo su hash.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>tokenHash</code></td><td><code>String</code></td><td>private final</td><td>Hash del token.</td></tr>
<tr><td><code>purpose</code></td><td><code>TokenPurpose</code></td><td>private final</td><td><code>SETUP</code> o <code>RESET</code>.</td></tr>
<tr><td><code>expiresAt</code></td><td><code>LocalDateTime</code></td><td>private final</td><td>Vencimiento. <code>SETUP</code> vence con la invitación; <code>RESET</code>, según configuración.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PasswordToken(String tokenHash, TokenPurpose purpose, LocalDateTime expiresAt)</code></td><td>(constructor)</td><td>public</td><td>Crea el token.</td></tr>
<tr><td><code>matches(String tokenHash, TokenPurpose purpose)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el token y el propósito coinciden.</td></tr>
<tr><td><code>isExpired(LocalDateTime now)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si venció.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación (<code>purpose</code>)</td><td><code>TokenPurpose</code></td><td>0..* a 1</td><td>Propósito del token.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VerificationCode</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Código numérico que llega al correo al registrarse. Se guarda solo su hash; la vigencia se configura en la capa de aplicación.</td></tr>
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
<tr><td><b>Propósito</b></td><td colspan="3">Roles de Alivia. Los de empleado son los <code>EmployeeRole</code> de HCM.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>ROLE_ADMIN</code>, <code>ROLE_TECH</code>, <code>ROLE_SUBSCRIPTION_MANAGER</code>, <code>ROLE_CLEANING</code>, <code>ROLE_RELATIVE</code>, <code>ROLE_CAREGIVER</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AccountType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cuenta de cliente (familiar o cuidador) o del personal (administrador o empleado).</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>PERSONAL</code>, <code>CORPORATE</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AccountStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de la cuenta. <code>PENDING</code>: aún no verifica su correo, no define su contraseña o tiene una contraseña temporal.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>PENDING</code>, <code>ACTIVE</code>, <code>BLOCKED</code>, <code>DEACTIVATED</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>TokenPurpose</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Propósito de un enlace de contraseña.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>SETUP</code>, <code>RESET</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CredentialStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de la credencial de un edge.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>ACTIVE</code>, <code>REVOKED</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

#### Domain Events

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
<tr><td><b>Lo registra</b></td><td colspan="3"><code>User.signUp</code> y <code>User.renewVerificationCode</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Communication envía el código al correo. Lee el id al publicarse, porque una cuenta nueva aún no lo tiene.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PasswordDefinedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que una cuenta definió su primera contraseña y quedó activa.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PasswordDefinedEvent(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>User.definePassword</code> y <code>User.changeTemporaryPassword</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Assistance acepta las invitaciones pendientes del cuidador.</td></tr>
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
<tr><td><b>Activa</b></td><td colspan="3">Communication envía la contraseña temporal al correo corporativo. La contraseña temporal solo viaja en el evento; se guarda hasheada.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PasswordResetRequestedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que una cuenta pidió recuperar su contraseña.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><td><code>resetUrl</code></td><td><code>String</code></td><td>private final</td><td>Url del enlace de recuperación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PasswordResetRequestedEvent(Long userId, String emailAddress, String resetUrl)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>User.issuePasswordToken</code> con <code>RESET</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Communication envía el enlace de recuperación.</td></tr>
</table>

#### Commands

Reglas: `ChangeUserRoleCommand`, `BlockUserCommand`, `UnblockUserCommand` y `DeactivateUserCommand` validan que el usuario exista (`UserNotFound`).

<table>
<tr><th colspan="4" align="left"><code>SeedRolesCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea los roles que falten al iniciar la aplicación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SeedRolesCommand()</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SignUpCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Registro del administrador (Company, <code>ROLE_ADMIN</code>) o del familiar (Assistance, <code>ROLE_RELATIVE</code>). El correo no tiene cuenta (<code>EmailAddressAlreadyExists</code>): un cuidador que se registra como familiar usa otro correo. El rol existe (<code>RoleNotFound</code>). La cuenta queda <code>PENDING</code> hasta verificar el correo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><td><code>password</code></td><td><code>String</code></td><td>private final</td><td>Contraseña de su cuenta. Se oculta en <code>toString()</code>.</td></tr>
<tr><td><code>role</code></td><td><code>Roles</code></td><td>private final</td><td>Rol en el negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SignUpCommand(String emailAddress, String password, Roles role)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VerifyEmailCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Verifica el correo con el código recibido (<code>User.verifyEmail</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><td><code>code</code></td><td><code>String</code></td><td>private final</td><td>Código de verificación recibido en el correo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>VerifyEmailCommand(String emailAddress, String code)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ResendVerificationCodeCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Envía un código nuevo; el anterior deja de valer. Si el correo no existe no lanza error.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ResendVerificationCodeCommand(String emailAddress)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SignInCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Inicia sesión y devuelve el token. El correo existe y la contraseña coincide (<code>InvalidCredentials</code>, el mismo error en ambos casos); el correo está verificado (<code>EmailNotVerified</code>); si la contraseña es temporal, pide cambiarla (<code>PasswordChangeRequired</code>); la cuenta está <code>ACTIVE</code> (<code>AccountNotActive</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><td><code>password</code></td><td><code>String</code></td><td>private final</td><td>Contraseña de su cuenta. Se oculta en <code>toString()</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SignInCommand(String emailAddress, String password)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RegisterInvitedCaregiverCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Invitación de un cuidador (Assistance). Correo sin cuenta: crea la cuenta invitada y devuelve el token del enlace. Cuenta invitada sin contraseña: regenera el enlace. Cuenta de cuidador activa (cuida a otra persona): la reutiliza sin token. Cuenta de familiar o corporativa: <code>EmailAddressAlreadyExists</code>, se usa otro correo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><td><code>expiresAt</code></td><td><code>LocalDateTime</code></td><td>private final</td><td>Fecha y hora de vencimiento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RegisterInvitedCaregiverCommand(String emailAddress, LocalDateTime expiresAt)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateCorporateAccountCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cuenta corporativa de un empleado (HCM) con su rol. El correo no tiene cuenta (<code>EmailAddressAlreadyExists</code>) y el rol es de empleado. La capa de aplicación genera la contraseña temporal.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><td><code>role</code></td><td><code>Roles</code></td><td>private final</td><td>Rol en el negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateCorporateAccountCommand(String emailAddress, Roles role)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DefinePasswordCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define la contraseña con un enlace de invitación o de recuperación. La cuenta se busca por el hash del token (<code>InvalidPasswordToken</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>token</code></td><td><code>String</code></td><td>private final</td><td>Token recibido en el enlace.</td></tr>
<tr><td><code>purpose</code></td><td><code>TokenPurpose</code></td><td>private final</td><td><code>SETUP</code> (invitación) o <code>RESET</code> (recuperación).</td></tr>
<tr><td><code>newPassword</code></td><td><code>String</code></td><td>private final</td><td>Contraseña nueva.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DefinePasswordCommand(String token, TokenPurpose purpose, String newPassword)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ChangeTemporaryPasswordCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El empleado cambia su contraseña temporal; la temporal coincide (<code>InvalidCredentials</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><td><code>temporaryPassword</code></td><td><code>String</code></td><td>private final</td><td>Contraseña temporal del empleado.</td></tr>
<tr><td><code>newPassword</code></td><td><code>String</code></td><td>private final</td><td>Contraseña nueva.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ChangeTemporaryPasswordCommand(String emailAddress, String temporaryPassword, String newPassword)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ChangePasswordCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cambio de contraseña con la sesión iniciada; la actual coincide (<code>InvalidCredentials</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><td><code>currentPassword</code></td><td><code>String</code></td><td>private final</td><td>Contraseña actual.</td></tr>
<tr><td><code>newPassword</code></td><td><code>String</code></td><td>private final</td><td>Contraseña nueva.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ChangePasswordCommand(Long userId, String currentPassword, String newPassword)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RequestPasswordResetCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Pide un enlace de recuperación. Si el correo no tiene cuenta no lanza error, para no revelar qué correos existen.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RequestPasswordResetCommand(String emailAddress)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ChangeUserRoleCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cambia el rol de un empleado. Lo activa <code>EmployeeRoleChangedEvent</code> de HCM.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><td><code>role</code></td><td><code>Roles</code></td><td>private final</td><td>Rol en el negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ChangeUserRoleCommand(Long userId, Roles role)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BlockUserCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Bloquea la cuenta. Lo activa <code>EmployeeSuspendedEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BlockUserCommand(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UnblockUserCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Desbloquea la cuenta. Lo activa <code>EmployeeReinstatedEvent</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UnblockUserCommand(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeactivateUserCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Desactiva la cuenta. Lo activa <code>EmployeeTerminatedEvent</code>; la cuenta personal de la misma persona, si la tiene, no cambia.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeactivateUserCommand(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>IssueDeviceCredentialCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea la credencial de un edge al asignarlo a una red (Assets, por ACL); devuelve el secreto una sola vez. El edge no tiene otra credencial <code>ACTIVE</code> (<code>DeviceCredentialAlreadyExists</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>IssueDeviceCredentialCommand(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RevokeDeviceCredentialCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Revoca la credencial cuando el edge sale de la red (<code>AssetRemovedFromNetworkEvent</code>). Existe (<code>DeviceCredentialNotFound</code>) y está <code>ACTIVE</code> (<code>DeviceCredentialRevoked</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RevokeDeviceCredentialCommand(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AuthenticateDeviceCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Autentica al edge y devuelve su token. Existe (<code>DeviceCredentialNotFound</code>), está <code>ACTIVE</code> (<code>DeviceCredentialRevoked</code>) y el secreto coincide (<code>InvalidCredentials</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><td><code>secret</code></td><td><code>String</code></td><td>private final</td><td>Secreto del edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AuthenticateDeviceCommand(Long edgeId, String secret)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

#### Queries

<table>
<tr><th colspan="4" align="left"><code>GetUserByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cuenta por id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetUserByIdQuery(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;User&gt;</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;User&gt;</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>boolean</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllUsersQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Todas las cuentas.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllUsersQuery()</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;User&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllRolesQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Todos los roles.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllRolesQuery()</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Role&gt;</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Role&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetDeviceCredentialByEdgeIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Credencial activa de un edge.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetDeviceCredentialByEdgeIdQuery(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;DeviceCredential&gt;</code></td></tr>
</table>

#### Domain Services

<table>
<tr><th colspan="4" align="left"><code>UserCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>User</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
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
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetUserByIdQuery query)</code></td><td><code>Optional&lt;User&gt;</code></td><td>public</td><td>Resuelve <code>GetUserByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetUserByEmailAddressQuery query)</code></td><td><code>Optional&lt;User&gt;</code></td><td>public</td><td>Resuelve <code>GetUserByEmailAddressQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(ExistsUserByEmailAddressQuery query)</code></td><td><code>boolean</code></td><td>public</td><td>Resuelve <code>ExistsUserByEmailAddressQuery</code>.</td></tr>
<tr><td><code>handle(GetAllUsersQuery query)</code></td><td><code>List&lt;User&gt;</code></td><td>public</td><td>Resuelve <code>GetAllUsersQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RoleCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Role</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(SeedRolesCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>SeedRolesCommand</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RoleQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Role</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetAllRolesQuery query)</code></td><td><code>List&lt;Role&gt;</code></td><td>public</td><td>Resuelve <code>GetAllRolesQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetRoleByNameQuery query)</code></td><td><code>Optional&lt;Role&gt;</code></td><td>public</td><td>Resuelve <code>GetRoleByNameQuery</code>; devuelve vacío si no existe.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceCredentialCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>DeviceCredential</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
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
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetDeviceCredentialByEdgeIdQuery query)</code></td><td><code>Optional&lt;DeviceCredential&gt;</code></td><td>public</td><td>Resuelve <code>GetDeviceCredentialByEdgeIdQuery</code>; devuelve vacío si no existe.</td></tr>
</table>

#### Exceptions

<table>
<tr><th colspan="4" align="left"><code>UserNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe la cuenta indicada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UserNotFound(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailAddressAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el correo ya tiene una cuenta (o, en una invitación, es de un familiar o de una cuenta corporativa).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmailAddressAlreadyExists(String emailAddress)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidCredentials</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el correo, la contraseña o el secreto no coinciden.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidCredentials()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AccountNotActive</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la operación pide una cuenta <code>ACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AccountNotActive(AccountStatus status)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PasswordChangeRequired</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el empleado inicia sesión con su contraseña temporal.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PasswordChangeRequired()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailNotVerified</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se inicia sesión sin verificar el correo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmailNotVerified()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailAlreadyVerified</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se verifica o se pide un código para un correo ya verificado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmailAlreadyVerified()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidVerificationCode</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el código de verificación no coincide.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidVerificationCode()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VerificationCodeExpired</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el código de verificación venció.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>VerificationCodeExpired()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PasswordNotTemporary</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se cambia como temporal una contraseña que no lo es.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PasswordNotTemporary()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidPasswordToken</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el enlace no existe, ya se usó o no es del propósito esperado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidPasswordToken()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PasswordTokenExpired</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el enlace venció.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PasswordTokenExpired()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RoleNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el rol no existe en el catálogo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RoleNotFound(Roles name)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RoleNotAllowedForAccountType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el rol no corresponde al tipo de cuenta.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RoleNotAllowedForAccountType(Roles role, AccountType type)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidAccountStatusTransition</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el cambio de estado de la cuenta no está permitido.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidAccountStatusTransition(AccountStatus from, AccountStatus to)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceCredentialNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el edge no tiene credencial.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceCredentialNotFound(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceCredentialAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el edge ya tiene una credencial <code>ACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceCredentialAlreadyExists(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceCredentialRevoked</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la credencial del edge está revocada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceCredentialRevoked(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

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

El diagrama muestra los aggregates `User` y `DeviceCredential` y la entidad de catálogo `Role`, con la asociación dirigida "roles" (0..* a 1..*). `User` se compone de sus value objects `HashedPassword`, `PasswordToken` y `VerificationCode` (0..1 cada uno) y registra los cuatro eventos que consumen Assistance y Communication. Los services reciben sus commands y queries, y las notas detallan las reglas de cada service y los contextos que usan IAM: Company, Assistance, HCM, Assets y Communication.

![Diagrama de clases de la capa de dominio - IAM](../images/diagrams/img/chapter-5/iam-backend-diagram.svg)

#### 5.1.7.2. Bounded Context Database Design Diagram

La base de datos es PostgreSQL.

| Tabla | Aggregate, entidad o value object | Llaves y restricciones |
|---|---|---|
| `users` | `User` (con `PasswordToken` y `VerificationCode` embebidos) | PK `id`. UK `email_address`. UK `password_token_hash`. Los tokens y códigos se guardan solo como hash. |
| `roles` | `Role` | PK `id`. UK `name`. |
| `user_roles` | Relación `roles` de `User` | PK compuesta (`user_id`, `role_id`). FK hacia `users` y `roles`. |
| `device_credentials` | `DeviceCredential` | PK `id`. UK parcial `edge_id` donde `status = 'ACTIVE'` (referencia a Assets, sin FK). |

Relaciones: una cuenta tiene uno o más roles y un rol lo tienen cero o más cuentas, mediante `user_roles`. `device_credentials` no se relaciona con las demás tablas. Ninguna cuenta ni credencial se borra: las desactivadas y revocadas quedan como historial.

![Diagrama de base de datos - IAM](../images/diagrams/img/chapter-5/iam-database-diagram.svg)

<div style="page-break-after: always;"></div>

## 5.2. Bounded Context: Gestión del Negocio

En el código, este bounded context es el paquete `company`. Company representa el negocio que opera la plataforma (hoy, Alivia) y a la persona que lo gestiona. Su id es el `BusinessId` que usan los demás contextos; guardarlo permite abrir más negocios en el futuro. Los datos públicos y legales del negocio viven en `BusinessProfile` (Profiles) y los datos personales del administrador en su `StaffProfile` (Profiles): Company solo guarda la identidad de cada uno y quién gestiona el negocio. El administrador registra su propia cuenta corporativa y después crea el negocio.

### 5.2.1. Domain Layer

Este bounded context no declara Entities, Value Objects, Enumerations ni Domain Events propios.

#### Aggregates

<table>
<tr><th colspan="4" align="left"><code>Business</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El negocio cliente de la plataforma. Enlaza su <code>BusinessProfile</code> y su administrador.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessProfileId</code></td><td><code>BusinessProfileId</code></td><td>private</td><td>Identidad de sus datos en Profiles.</td></tr>
<tr><td><code>administrator</code></td><td><code>Administrator</code></td><td>private</td><td>Administrador que gestiona el negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Business(BusinessProfileId businessProfileId, Administrator administrator)</code></td><td>(constructor)</td><td>public</td><td>Crea el negocio con su perfil y su administrador.</td></tr>
<tr><td><code>isManagedBy(Administrator administrator)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el administrador recibido es quien gestiona el negocio. Se usa antes de modificar sus datos.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida "gestionado por"</td><td><code>Administrator</code></td><td>0..1 <code>Business</code> a 1 <code>Administrator</code></td><td>Un negocio tiene un administrador; un administrador gestiona a lo sumo un negocio.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Administrator</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">La persona que gestiona el negocio. Es personal de Alivia: enlaza su cuenta corporativa de IAM y su <code>StaffProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>UserId</code></td><td>private</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><td><code>staffProfileId</code></td><td><code>StaffProfileId</code></td><td>private</td><td>Su perfil de personal en Profiles.</td></tr>
<tr><td><code>backupPersonalEmail</code></td><td><code>EmailAddress</code></td><td>private</td><td>Correo personal de respaldo. Opcional y único entre administradores.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Administrator(UserId userId, StaffProfileId staffProfileId, EmailAddress backupPersonalEmail)</code></td><td>(constructor)</td><td>public</td><td>Crea el administrador con su cuenta y su perfil.</td></tr>
<tr><td><code>updateBackupPersonalEmail(EmailAddress backupPersonalEmail)</code></td><td><code>void</code></td><td>public</td><td>Cambia el correo de respaldo. Es el único dato que el aggregate modifica; los datos personales se actualizan en su <code>StaffProfile</code>.</td></tr>
</table>

#### Commands

<table>
<tr><th colspan="4" align="left"><code>CreateAdministratorCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Registra al administrador: su cuenta corporativa en IAM, su <code>StaffProfile</code> en Profiles y el aggregate <code>Administrator</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>corporateEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo corporativo: cuenta en IAM y email de su <code>StaffProfile</code>.</td></tr>
<tr><td><code>password</code></td><td><code>String</code></td><td>private final</td><td>Contraseña de su cuenta. Se oculta en <code>toString()</code>.</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo de la foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo de la foto.</td></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><td><code>dni</code></td><td><code>String</code></td><td>private final</td><td>DNI.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>backupPersonalEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo personal de respaldo. Opcional.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateAdministratorCommand(String corporateEmail, String password, byte[] photoData, String photoFileName, String firstName, String lastName, String dni, String phoneNumber, String backupPersonalEmail)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El administrador registra su propia cuenta. El DNI no está entre el personal (<code>DniAlreadyExists</code>) y el correo corporativo no está registrado (<code>EmailAddressAlreadyExists</code>); Profiles crea el <code>StaffProfile</code> e IAM crea la cuenta corporativa. Un administrador no puede ser también empleado, porque ambos son personal y el DNI es único entre el personal. El correo de respaldo no pertenece a otro administrador (<code>BackupPersonalEmailAlreadyExists</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateAdministratorCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Actualiza los datos personales del administrador (en su <code>StaffProfile</code>) y su correo personal de respaldo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>administratorId</code></td><td><code>Long</code></td><td>private final</td><td>Id del administrador.</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo de la foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo de la foto.</td></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>backupPersonalEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo de respaldo. Opcional.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateAdministratorCommand(Long administratorId, byte[] photoData, String photoFileName, String firstName, String lastName, String phoneNumber, String backupPersonalEmail)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El administrador existe (<code>AdministratorNotFound</code>). El aggregate solo cambia el correo de respaldo; los demás datos se actualizan en su <code>StaffProfile</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateBusinessCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea el negocio que gestiona un administrador: Profiles crea el <code>BusinessProfile</code> y <code>Business</code> guarda su id.</td></tr>
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
<tr><td><code>businessHours</code></td><td><code>String</code></td><td>private final</td><td>Horario en texto o JSON; Profiles lo convierte a <code>BusinessHours</code>.</td></tr>
<tr><td><code>supportEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo de soporte.</td></tr>
<tr><td><code>emergencyPhone</code></td><td><code>String</code></td><td>private final</td><td>Teléfono de emergencia.</td></tr>
<tr><td><code>whatsappNum</code></td><td><code>String</code></td><td>private final</td><td>WhatsApp.</td></tr>
<tr><td><code>slogan</code></td><td><code>String</code></td><td>private final</td><td>Eslogan.</td></tr>
<tr><td><code>administratorId</code></td><td><code>Long</code></td><td>private final</td><td>Administrador que crea el negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateBusinessCommand(byte[] photoData, String photoFileName, String businessName, String legalName, Long ruc, String mainActivity, String description, String emailAddress, String phoneNumber, String formattedAddress, Double latitude, Double longitude, String placeId, String businessHours, String supportEmail, String emergencyPhone, String whatsappNum, String slogan, Long administratorId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El administrador existe (<code>AdministratorNotFound</code>) y no gestiona otro negocio (<code>BusinessAlreadyExistsForAdministrator</code>). Profiles crea el <code>BusinessProfile</code> y devuelve su id; si rechaza email, RUC, nombre comercial o razón social ya registrados, se traduce a <code>EmailAddressAlreadyExists</code>, <code>RucAlreadyExists</code>, <code>BusinessNameAlreadyExists</code> o <code>LegalNameAlreadyExists</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateBusinessCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Actualiza los datos del negocio en su <code>BusinessProfile</code>. Solo lo ejecuta el administrador que lo gestiona.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>administratorId</code></td><td><code>Long</code></td><td>private final</td><td>Administrador que solicita el cambio.</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo del logo o foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo.</td></tr>
<tr><td><code>businessName</code></td><td><code>String</code></td><td>private final</td><td>Nombre comercial.</td></tr>
<tr><td><code>legalName</code></td><td><code>String</code></td><td>private final</td><td>Razón social.</td></tr>
<tr><td><code>mainActivity</code></td><td><code>String</code></td><td>private final</td><td>Actividad principal.</td></tr>
<tr><td><code>description</code></td><td><code>String</code></td><td>private final</td><td>Descripción.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>businessHours</code></td><td><code>String</code></td><td>private final</td><td>Horario en texto o JSON.</td></tr>
<tr><td><code>supportEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo de soporte.</td></tr>
<tr><td><code>emergencyPhone</code></td><td><code>String</code></td><td>private final</td><td>Teléfono de emergencia.</td></tr>
<tr><td><code>whatsappNum</code></td><td><code>String</code></td><td>private final</td><td>WhatsApp.</td></tr>
<tr><td><code>slogan</code></td><td><code>String</code></td><td>private final</td><td>Eslogan.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateBusinessCommand(Long businessId, Long administratorId, byte[] photoData, String photoFileName, String businessName, String legalName, String mainActivity, String description, String phoneNumber, String businessHours, String supportEmail, String emergencyPhone, String whatsappNum, String slogan)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El negocio existe (<code>BusinessNotFound</code>). Solo su administrador lo modifica, incluida la razón social (<code>business.isManagedBy(administrator)</code>). No incluye RUC, email ni ubicación, que no se modifican. Nombre comercial y razón social siguen siendo únicos (<code>BusinessNameAlreadyExists</code>, <code>LegalNameAlreadyExists</code>). <code>Business</code> no cambia: los datos se actualizan en <code>BusinessProfile</code>.</td></tr>
</table>

#### Queries

<table>
<tr><th colspan="4" align="left"><code>GetBusinessByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Obtiene un negocio por su id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetBusinessByIdQuery(Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Business&gt;</code></td></tr>
</table>

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
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Business&gt;</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Administrator&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAdministratorByUserIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Obtiene el administrador del usuario que inició sesión.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAdministratorByUserIdQuery(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Administrator&gt;</code></td></tr>
</table>

#### Domain Services

Todos los métodos son `public` (interfaces).

<table>
<tr><th colspan="4" align="left"><code>AdministratorCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Administrator</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateAdministratorCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Registra al administrador y devuelve su id.</td></tr>
<tr><td><code>handle(UpdateAdministratorCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Actualiza sus datos y devuelve su id.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AdministratorQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Administrator</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetAdministratorByIdQuery query)</code></td><td><code>Optional&lt;Administrator&gt;</code></td><td>public</td><td>Administrador por id.</td></tr>
<tr><td><code>handle(GetAdministratorByUserIdQuery query)</code></td><td><code>Optional&lt;Administrator&gt;</code></td><td>public</td><td>Administrador por usuario.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Business</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateBusinessCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Crea el negocio y devuelve su id.</td></tr>
<tr><td><code>handle(UpdateBusinessCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Actualiza el negocio y devuelve su id.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Business</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetBusinessByIdQuery query)</code></td><td><code>Optional&lt;Business&gt;</code></td><td>public</td><td>Negocio por id.</td></tr>
<tr><td><code>handle(GetBusinessByAdministratorIdQuery query)</code></td><td><code>Optional&lt;Business&gt;</code></td><td>public</td><td>Negocio por administrador.</td></tr>
</table>

#### Exceptions

Cada excepción tiene un constructor `public` sin parámetros. Las que repiten nombre con Profiles traducen su rechazo a este contexto, sin importar clases de otro bounded context.

<table>
<tr><th colspan="4" align="left"><code>BusinessNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe un negocio con el id indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AdministratorNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe un administrador con el id indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AdministratorNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessAlreadyExistsForAdministrator</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el administrador ya gestiona un negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessAlreadyExistsForAdministrator()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DniAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el DNI ya está registrado entre el personal.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DniAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailAddressAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el correo corporativo o el email del negocio ya está registrado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmailAddressAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessNameAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el nombre comercial ya pertenece a otro negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessNameAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>LegalNameAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la razón social ya pertenece a otro negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>LegalNameAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RucAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el RUC ya pertenece a otro negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RucAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BackupPersonalEmailAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
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

El diagrama muestra los aggregates `Business` y `Administrator`, relacionados por la asociación dirigida "gestionado por" (0..1 a 1). Los colores distinguen el flujo de escritura (naranja: el command service recibe el command y crea o actualiza el aggregate) y el de lectura (verde: el query service recibe la query y devuelve el aggregate). Los atributos de cada command se muestran dentro de su clase; las notas detallan sus validaciones.

![Diagrama de clases de la capa de dominio - Gestión del Negocio](../images/diagrams/img/chapter-5/Business.svg)

#### 5.2.7.2. Bounded Context Database Design Diagram

| Tabla | Aggregate | Llaves y restricciones |
|---|---|---|
| `administrators` | `Administrator` | PK `id`. UK `user_id` y UK `staff_profile_id` (referencias a IAM y Profiles, sin FK por ser otros contextos). UK `backup_personal_email` (admite nulos). |
| `businesses` | `Business` | PK `id`. UK `business_profile_id` (referencia a Profiles, sin FK). FK `administrator_id` hacia `administrators`, también única. |

Relación: un administrador gestiona cero o un negocio (1 a 0..1). El administrador se registra primero y después crea su negocio, por eso puede existir sin uno.

![Diagrama de base de datos - Gestión del Negocio](../images/diagrams/img/chapter-5/Business-database.svg)

<div style="page-break-after: always;"></div>

## 5.3. Bounded Context: Perfiles

En el código, este bounded context es el paquete `profiles`. Profiles guarda los datos personales y de contacto de las personas y los datos públicos y legales del negocio. Distingue dos tipos de perfil de persona según su relación con Alivia: `PersonProfile` para los clientes (familiares y personas asistidas) y `StaffProfile` para el personal (administrador y empleados). Si una misma persona es cliente y personal, tiene los dos perfiles con sus datos por separado, porque son dos relaciones distintas con Alivia. Los demás contextos referencian los perfiles solo por su id; ningún perfil se busca ni se recupera por DNI ni por email.

### 5.3.1. Domain Layer

Este bounded context no declara Entities, Enumerations ni Domain Events propios.

#### Aggregates

<table>
<tr><th colspan="4" align="left"><code>Profile</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Clase abstracta base (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Datos de contacto comunes a todos los perfiles. No es un aggregate propio: no tiene repositorio ni services.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>EmailAddress</code></td><td>private</td><td>Correo del perfil. No se modifica.</td></tr>
<tr><td><code>photo</code></td><td><code>Photo</code></td><td>private</td><td>Foto de perfil.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>PhoneNumber</code></td><td>private</td><td>Teléfono de contacto. Puede repetirse entre perfiles.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Profile(EmailAddress emailAddress, Photo photo, PhoneNumber phoneNumber)</code></td><td>(constructor)</td><td>protected</td><td>Inicializa los datos de contacto desde las subclases.</td></tr>
<tr><td><code>updateContactInformation(PhoneNumber phoneNumber, Photo photo)</code></td><td><code>void</code></td><td>protected</td><td>Actualiza teléfono y foto.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Generalización</td><td><code>PersonProfile</code>, <code>StaffProfile</code>, <code>BusinessProfile</code></td><td>1 base, 3 subclases</td><td>Cada perfil concreto extiende <code>Profile</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PersonProfile</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>Profile</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Datos personales de un cliente de Alivia: familiar o persona asistida. Assistance lo referencia por <code>PersonProfileId</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>personName</code></td><td><code>PersonName</code></td><td>private</td><td>Nombres y apellidos.</td></tr>
<tr><td><code>dni</code></td><td><code>Dni</code></td><td>private</td><td>Documento de identidad. Único entre los clientes; no se modifica.</td></tr>
<tr><td><code>birthDate</code></td><td><code>BirthDate</code></td><td>private</td><td>Fecha de nacimiento. No se modifica.</td></tr>
<tr><td><code>emailAddress</code> (heredado)</td><td><code>EmailAddress</code></td><td>private</td><td>Opcional: la persona asistida puede no tener correo. Si existe, no se repite entre <code>PersonProfile</code> y <code>StaffProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PersonProfile(EmailAddress emailAddress, Photo photo, PhoneNumber phoneNumber, PersonName personName, Dni dni, BirthDate birthDate)</code></td><td>(constructor)</td><td>public</td><td>Crea el perfil de un cliente.</td></tr>
<tr><td><code>updatePersonalInformation(PersonName personName, PhoneNumber phoneNumber, Photo photo)</code></td><td><code>void</code></td><td>public</td><td>Actualiza nombre, teléfono y foto. DNI, fecha de nacimiento y email no cambian.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>personName</code>)</td><td><code>PersonName</code></td><td>1 a 1</td><td>Nombre de la persona.</td></tr>
<tr><td>Composición (<code>dni</code>)</td><td><code>Dni</code></td><td>1 a 1</td><td>Documento de identidad.</td></tr>
<tr><td>Composición (<code>birthDate</code>)</td><td><code>BirthDate</code></td><td>1 a 1</td><td>Fecha de nacimiento.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>StaffProfile</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>Profile</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Datos personales del personal de Alivia: administrador o empleado, con su correo corporativo. Company y HCM lo referencian por <code>StaffProfileId</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>personName</code></td><td><code>PersonName</code></td><td>private</td><td>Nombres y apellidos.</td></tr>
<tr><td><code>dni</code></td><td><code>Dni</code></td><td>private</td><td>Documento de identidad. Único entre el personal: nadie es empleado dos veces y un administrador no puede ser empleado. No se modifica.</td></tr>
<tr><td><code>birthDate</code></td><td><code>BirthDate</code></td><td>private</td><td>Fecha de nacimiento. No se modifica.</td></tr>
<tr><td><code>emailAddress</code> (heredado)</td><td><code>EmailAddress</code></td><td>private</td><td>Correo corporativo. Obligatorio, único entre <code>PersonProfile</code> y <code>StaffProfile</code>, y no se modifica.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>StaffProfile(EmailAddress corporateEmail, Photo photo, PhoneNumber phoneNumber, PersonName personName, Dni dni, BirthDate birthDate)</code></td><td>(constructor)</td><td>public</td><td>Crea el perfil de un miembro del personal.</td></tr>
<tr><td><code>updatePersonalInformation(PersonName personName, PhoneNumber phoneNumber, Photo photo)</code></td><td><code>void</code></td><td>public</td><td>Actualiza nombre, teléfono y foto. DNI, fecha de nacimiento y correo corporativo no cambian.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>personName</code>)</td><td><code>PersonName</code></td><td>1 a 1</td><td>Nombre de la persona.</td></tr>
<tr><td>Composición (<code>dni</code>)</td><td><code>Dni</code></td><td>1 a 1</td><td>Documento de identidad.</td></tr>
<tr><td>Composición (<code>birthDate</code>)</td><td><code>BirthDate</code></td><td>1 a 1</td><td>Fecha de nacimiento.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessProfile</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>Profile</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Datos públicos y legales del negocio: RUC, razón social, nombre comercial, horario, ubicación y contacto. Company lo referencia por <code>BusinessProfileId</code>.</td></tr>
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
<tr><td><code>emailAddress</code> (heredado)</td><td><code>EmailAddress</code></td><td>private</td><td>Correo del negocio. Obligatorio, único entre los negocios y no se modifica.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessProfile(EmailAddress emailAddress, Photo photo, PhoneNumber phoneNumber, Ruc ruc, BusinessName businessName, LegalName legalName, String description, String mainActivity, PhoneNumber whatsappNum, PhoneNumber emergencyPhone, BusinessHours businessHours, String slogan, EmailAddress supportEmail, Address address)</code></td><td>(constructor)</td><td>public</td><td>Crea el perfil del negocio.</td></tr>
<tr><td><code>updateInformation(Photo photo, PhoneNumber phoneNumber, BusinessName businessName, LegalName legalName, String description, String mainActivity, PhoneNumber whatsappNum, PhoneNumber emergencyPhone, BusinessHours businessHours, String slogan, EmailAddress supportEmail)</code></td><td><code>void</code></td><td>public</td><td>Actualiza los datos modificables. RUC, email y dirección no cambian.</td></tr>
<tr><td><code>isOpenAt(DayOfWeek day, LocalTime time)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el negocio atiende ese día a esa hora.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>ruc</code>)</td><td><code>Ruc</code></td><td>1 a 1</td><td>RUC del negocio.</td></tr>
<tr><td>Composición (<code>businessName</code>)</td><td><code>BusinessName</code></td><td>1 a 1</td><td>Nombre comercial.</td></tr>
<tr><td>Composición (<code>legalName</code>)</td><td><code>LegalName</code></td><td>1 a 1</td><td>Razón social.</td></tr>
<tr><td>Composición (<code>businessHours</code>)</td><td><code>BusinessHours</code></td><td>1 a 1</td><td>Horario de atención.</td></tr>
</table>

#### Value Objects

<table>
<tr><th colspan="4" align="left"><code>PersonName</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Nombres y apellidos de una persona. Ninguno vacío. Dos personas pueden llamarse igual.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PersonName(String firstName, String lastName)</code></td><td>(constructor)</td><td>public</td><td>Valida la invariante y rechaza valores inválidos.</td></tr>
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
<tr><td><code>Dni(String dni)</code></td><td>(constructor)</td><td>public</td><td>Valida la invariante y rechaza valores inválidos.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BirthDate</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Fecha de nacimiento. No posterior a hoy.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>birthDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de nacimiento. No se modifica.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BirthDate(LocalDate birthDate)</code></td><td>(constructor)</td><td>public</td><td>Valida la invariante y rechaza valores inválidos.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Ruc</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Registro Único de Contribuyentes: 11 dígitos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ruc</code></td><td><code>Long</code></td><td>private final</td><td>RUC del negocio. Único y no se modifica.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Ruc(Long ruc)</code></td><td>(constructor)</td><td>public</td><td>Valida la invariante y rechaza valores inválidos.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessName</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Nombre comercial. No vacío.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessName</code></td><td><code>String</code></td><td>private final</td><td>Nombre comercial. Único.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessName(String businessName)</code></td><td>(constructor)</td><td>public</td><td>Valida la invariante y rechaza valores inválidos.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>LegalName</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Razón social. No vacía.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>legalName</code></td><td><code>String</code></td><td>private final</td><td>Razón social. Única; solo la modifica el administrador del negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>LegalName(String legalName)</code></td><td>(constructor)</td><td>public</td><td>Valida la invariante y rechaza valores inválidos.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessHours</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Horario de atención del negocio. Agrupa un <code>WeeklyPeriod</code> (Shared) por cada bloque de días con el mismo horario. Ejemplo: Lun-Vie 09:00-18:00 y Sáb 09:00-13:00 son dos periodos.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>periods</code></td><td><code>List&lt;WeeklyPeriod&gt;</code></td><td>private final</td><td>Al menos un periodo. Ningún rango cruza medianoche y ningún par de periodos se cruza el mismo día (<code>InvalidBusinessHours</code>).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessHours(List&lt;WeeklyPeriod&gt; periods)</code></td><td>(constructor)</td><td>public</td><td>Valida las invariantes del horario.</td></tr>
<tr><td><code>isOpenAt(DayOfWeek day, LocalTime time)</code></td><td><code>boolean</code></td><td>public</td><td>Revisa todos los periodos para saber si el negocio está abierto.</td></tr>
<tr><td><b>Notas</b></td><td colspan="3">Los commands reciben <code>BusinessHours</code> ya construido: la conversión desde el texto o JSON de la solicitud se hace en el borde del contexto.</td></tr>
</table>

#### Commands

<table>
<tr><th colspan="4" align="left"><code>CreatePersonProfileCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea el perfil de un cliente de Alivia (familiar o persona asistida). Lo envía Assistance mediante su ACL.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Opcional (la persona asistida puede no tener correo).</td></tr>
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
<tr><td><b>Reglas</b></td><td colspan="3">Si viene el email, no pertenece a otro <code>PersonProfile</code> ni a un <code>StaffProfile</code> (<code>EmailAddressAlreadyExists</code>). El DNI no pertenece a otro <code>PersonProfile</code> (<code>DniAlreadyExists</code>); sí puede existir un <code>StaffProfile</code> con el mismo DNI.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdatePersonProfileCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Actualiza los datos personales editables de un cliente.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>id</code></td><td><code>Long</code></td><td>private final</td><td>Id del <code>PersonProfile</code>.</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo de la foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo de la foto.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdatePersonProfileCommand(Long id, byte[] photoData, String photoFileName, String phoneNumber, String firstName, String lastName)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El perfil existe (<code>PersonProfileNotFound</code>). DNI, fecha de nacimiento y email no se modifican.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateStaffProfileCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea el perfil de un miembro del personal (administrador o empleado). Lo envían Company y HCM mediante su ACL.</td></tr>
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
<tr><td><b>Reglas</b></td><td colspan="3">El correo corporativo no pertenece a otro <code>StaffProfile</code> ni a un <code>PersonProfile</code> (<code>EmailAddressAlreadyExists</code>). El DNI no pertenece a otro <code>StaffProfile</code> (<code>DniAlreadyExists</code>); sí puede existir un <code>PersonProfile</code> con el mismo DNI.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateStaffProfileCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Actualiza los datos personales editables de un miembro del personal.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>id</code></td><td><code>Long</code></td><td>private final</td><td>Id del <code>StaffProfile</code>.</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo de la foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo de la foto.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateStaffProfileCommand(Long id, byte[] photoData, String photoFileName, String phoneNumber, String firstName, String lastName)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El perfil existe (<code>StaffProfileNotFound</code>). DNI, fecha de nacimiento y correo corporativo no se modifican. No cambia el <code>PersonProfile</code> de la misma persona, si lo tiene.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateBusinessProfileCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea el perfil público y legal del negocio. Lo envía Company al crear el <code>Business</code>.</td></tr>
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
<tr><td><b>Reglas</b></td><td colspan="3">Email, RUC, nombre comercial y razón social no pertenecen a otro <code>BusinessProfile</code> (<code>EmailAddressAlreadyExists</code>, <code>RucAlreadyExists</code>, <code>BusinessNameAlreadyExists</code>, <code>LegalNameAlreadyExists</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateBusinessProfileCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Actualiza los datos editables del perfil del negocio.</td></tr>
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
<tr><td><b>Reglas</b></td><td colspan="3">El perfil existe (<code>BusinessProfileNotFound</code>). RUC, dirección y email no se modifican. Si cambian el nombre comercial o la razón social, no pertenecen a otro negocio (<code>BusinessNameAlreadyExists</code>, <code>LegalNameAlreadyExists</code>). Solo llega desde Company, que valida que quien actualiza es el administrador del negocio; Profiles no valida roles.</td></tr>
</table>

#### Queries

<table>
<tr><th colspan="4" align="left"><code>GetPersonProfileByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Obtiene un perfil de cliente por su id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>id</code></td><td><code>Long</code></td><td>private final</td><td>Identificador generado por la base de datos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetPersonProfileByIdQuery(Long id)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;PersonProfile&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllPersonProfilesQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Lista los perfiles de clientes.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllPersonProfilesQuery()</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;PersonProfile&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ExistsPersonProfileByDniQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica si el DNI ya está registrado entre los clientes. No devuelve el perfil.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>dni</code></td><td><code>Dni</code></td><td>private final</td><td>Documento de identidad. Único entre los clientes; no se modifica.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ExistsPersonProfileByDniQuery(Dni dni)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>boolean</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ExistsPersonProfileByEmailAddressQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica si el email ya está registrado en un perfil de cliente.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>EmailAddress</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ExistsPersonProfileByEmailAddressQuery(EmailAddress emailAddress)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>boolean</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetStaffProfileByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Obtiene un perfil de personal por su id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>id</code></td><td><code>Long</code></td><td>private final</td><td>Identificador generado por la base de datos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetStaffProfileByIdQuery(Long id)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;StaffProfile&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllStaffProfilesQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Lista los perfiles del personal.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllStaffProfilesQuery()</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;StaffProfile&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ExistsStaffProfileByDniQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica si el DNI ya está registrado entre el personal.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>dni</code></td><td><code>Dni</code></td><td>private final</td><td>Documento de identidad. Único entre los clientes; no se modifica.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ExistsStaffProfileByDniQuery(Dni dni)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>boolean</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ExistsStaffProfileByEmailAddressQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica si el correo corporativo ya está registrado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>EmailAddress</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ExistsStaffProfileByEmailAddressQuery(EmailAddress emailAddress)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>boolean</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetBusinessProfileByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Obtiene el perfil de un negocio por su id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>id</code></td><td><code>Long</code></td><td>private final</td><td>Identificador generado por la base de datos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetBusinessProfileByIdQuery(Long id)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;BusinessProfile&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllBusinessProfilesQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Lista los perfiles de negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllBusinessProfilesQuery()</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;BusinessProfile&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ExistsBusinessProfileByEmailAddressQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica si el email ya está registrado en un negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>emailAddress</code></td><td><code>EmailAddress</code></td><td>private final</td><td>Correo de la cuenta.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ExistsBusinessProfileByEmailAddressQuery(EmailAddress emailAddress)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>boolean</code></td></tr>
</table>

#### Domain Services

Todos los métodos son `public` (interfaces).

<table>
<tr><th colspan="4" align="left"><code>PersonProfileCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>PersonProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreatePersonProfileCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Crea el perfil y devuelve su id.</td></tr>
<tr><td><code>handle(UpdatePersonProfileCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Actualiza el perfil y devuelve su id.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PersonProfileQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>PersonProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetPersonProfileByIdQuery query)</code></td><td><code>Optional&lt;PersonProfile&gt;</code></td><td>public</td><td>Perfil por id.</td></tr>
<tr><td><code>handle(ExistsPersonProfileByEmailAddressQuery query)</code></td><td><code>boolean</code></td><td>public</td><td>Email registrado o no.</td></tr>
<tr><td><code>handle(ExistsPersonProfileByDniQuery query)</code></td><td><code>boolean</code></td><td>public</td><td>DNI registrado o no.</td></tr>
<tr><td><code>handle(GetAllPersonProfilesQuery query)</code></td><td><code>List&lt;PersonProfile&gt;</code></td><td>public</td><td>Todos los perfiles de clientes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>StaffProfileCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>StaffProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateStaffProfileCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Crea el perfil y devuelve su id.</td></tr>
<tr><td><code>handle(UpdateStaffProfileCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Actualiza el perfil y devuelve su id.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>StaffProfileQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>StaffProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetStaffProfileByIdQuery query)</code></td><td><code>Optional&lt;StaffProfile&gt;</code></td><td>public</td><td>Perfil por id.</td></tr>
<tr><td><code>handle(ExistsStaffProfileByEmailAddressQuery query)</code></td><td><code>boolean</code></td><td>public</td><td>Correo corporativo registrado o no.</td></tr>
<tr><td><code>handle(ExistsStaffProfileByDniQuery query)</code></td><td><code>boolean</code></td><td>public</td><td>DNI registrado o no.</td></tr>
<tr><td><code>handle(GetAllStaffProfilesQuery query)</code></td><td><code>List&lt;StaffProfile&gt;</code></td><td>public</td><td>Todos los perfiles del personal.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessProfileCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>BusinessProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateBusinessProfileCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Crea el perfil y devuelve su id.</td></tr>
<tr><td><code>handle(UpdateBusinessProfileCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Actualiza el perfil y devuelve su id.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessProfileQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>BusinessProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetBusinessProfileByIdQuery query)</code></td><td><code>Optional&lt;BusinessProfile&gt;</code></td><td>public</td><td>Perfil por id.</td></tr>
<tr><td><code>handle(ExistsBusinessProfileByEmailAddressQuery query)</code></td><td><code>boolean</code></td><td>public</td><td>Email registrado o no.</td></tr>
<tr><td><code>handle(GetAllBusinessProfilesQuery query)</code></td><td><code>List&lt;BusinessProfile&gt;</code></td><td>public</td><td>Todos los perfiles de negocio.</td></tr>
</table>

#### Exceptions

Cada excepción tiene un constructor `public` sin parámetros.

<table>
<tr><th colspan="4" align="left"><code>DniAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el DNI ya está registrado en otro perfil del mismo tipo (cliente o personal).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DniAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailAddressAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el email ya está registrado: entre <code>PersonProfile</code> y <code>StaffProfile</code>, o entre negocios.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmailAddressAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RucAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el RUC ya pertenece a otro negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RucAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessNameAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el nombre comercial ya pertenece a otro negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessNameAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>LegalNameAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la razón social ya pertenece a otro negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>LegalNameAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>PersonProfileNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe un <code>PersonProfile</code> con el id indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>PersonProfileNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>StaffProfileNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe un <code>StaffProfile</code> con el id indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>StaffProfileNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessProfileNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe un <code>BusinessProfile</code> con el id indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessProfileNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidBusinessHours</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el horario está vacío, tiene un rango que cruza medianoche o periodos que se cruzan el mismo día.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidBusinessHours()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

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

El diagrama muestra la base abstracta `Profile` y sus tres aggregates (`PersonProfile`, `StaffProfile` y `BusinessProfile`), relacionados por generalización. Cada aggregate se compone de sus value objects propios con multiplicidad 1 a 1. Los services reciben sus commands y queries mediante dependencias nombradas ("recibe"). Los atributos de cada command se muestran dentro de su clase; las notas detallan sus validaciones y las invariantes de los value objects.

![Diagrama de clases de la capa de dominio - Perfiles](../images/diagrams/img/chapter-5/profile-backend-diagram.svg)

#### 5.3.7.2. Bounded Context Database Design Diagram

La base de datos es PostgreSQL. Cada aggregate tiene su tabla; `Profile` no tiene tabla propia porque es abstracta, y sus columnas (email, foto y teléfono) se repiten en las tres tablas.

| Tabla | Aggregate o value object | Llaves y restricciones |
|---|---|---|
| `person_profiles` | `PersonProfile` | PK `id`. UK `dni`. UK `email_address` (admite varios nulos, por la persona asistida sin correo). |
| `staff_profiles` | `StaffProfile` | PK `id`. UK `dni`. UK `corporate_email`. |
| `business_profiles` | `BusinessProfile` | PK `id`. UK `email_address`, `ruc`, `business_name`, `legal_name`. La dirección se guarda en las columnas `address_*`. |
| `business_profile_opening_periods` | `BusinessHours` (colección de `WeeklyPeriod`) | FK `business_profile_id` hacia `business_profiles`. Sin id propio: es parte del valor del aggregate. `week_days` guarda los días separados por coma. |

Relación: un `business_profiles` tiene uno o más `business_profile_opening_periods` (1 a 1..*). La unicidad del email entre `person_profiles` y `staff_profiles` la valida el dominio, porque está en dos tablas distintas.

![Diagrama de base de datos - Perfiles](../images/diagrams/img/chapter-5/profile-database-diagram.svg)

<div style="page-break-after: always;"></div>

## 5.4. Bounded Context: Capital Humano

En el código, este bounded context es el paquete `hcm`. HCM (Human Capital Management) gestiona al personal de cada negocio (hoy, Alivia): datos laborales, rol, estado, horario de trabajo, contratos y vacaciones. Todo gira en torno al `BusinessId`: cada operación valida que el empleado pertenezca al negocio. El administrador del negocio crea la cuenta corporativa de cada empleado; los datos personales del empleado viven en su `StaffProfile` (Profiles) y su cuenta en IAM. Una persona que es familiar puede trabajar en Alivia y conserva aparte su perfil y su cuenta de cliente.

### 5.4.1. Domain Layer

#### Aggregates

<table>
<tr><th colspan="4" align="left"><code>Employee</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Una persona que trabaja para un negocio. Guarda su rol, su estado laboral, su horario, sus contratos y sus vacaciones.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>BusinessId</code></td><td>private</td><td>Negocio al que pertenece.</td></tr>
<tr><td><code>userId</code></td><td><code>UserId</code></td><td>private</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><td><code>staffProfileId</code></td><td><code>StaffProfileId</code></td><td>private</td><td>Su perfil de personal en Profiles.</td></tr>
<tr><td><code>role</code></td><td><code>EmployeeRole</code></td><td>private</td><td>Rol en el negocio.</td></tr>
<tr><td><code>status</code></td><td><code>EmployeeStatus</code></td><td>private</td><td><code>ACTIVE</code>, <code>SUSPENDED</code> o <code>TERMINATED</code>.</td></tr>
<tr><td><code>workSchedule</code></td><td><code>WorkSchedule</code></td><td>private</td><td>Turnos semanales.</td></tr>
<tr><td><code>contractHistory</code></td><td><code>ContractHistory</code></td><td>private</td><td>Todos sus contratos.</td></tr>
<tr><td><code>vacationHistory</code></td><td><code>VacationHistory</code></td><td>private</td><td>Todas sus vacaciones.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Employee(BusinessId businessId, UserId userId, StaffProfileId staffProfileId, EmployeeRole role, WorkSchedule workSchedule, OperatingHours operatingHours, ContractPeriod firstContractPeriod, TypeOfContract firstContractType, LocalDate today)</code></td><td>(constructor)</td><td>public</td><td>Contrata al empleado: estado <code>ACTIVE</code>, crea su primer contrato, valida que el horario quepa en el del negocio y registra <code>EmployeeHiredEvent</code>.</td></tr>
<tr><td><code>belongsTo(BusinessId businessId)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si es del negocio indicado.</td></tr>
<tr><td><code>changeRole(EmployeeRole role)</code></td><td><code>void</code></td><td>public</td><td>Cambia el rol y registra <code>EmployeeRoleChangedEvent</code>.</td></tr>
<tr><td><code>updateWorkSchedule(WorkSchedule workSchedule, OperatingHours operatingHours)</code></td><td><code>void</code></td><td>public</td><td>Cambia el horario; cada turno cabe en el horario del negocio (<code>WorkScheduleOutsideOperatingHours</code>).</td></tr>
<tr><td><code>addContract(ContractPeriod period, TypeOfContract type, LocalDate today)</code></td><td><code>void</code></td><td>public</td><td>Renueva con un nuevo contrato: no empieza antes de <code>today</code> (<code>InvalidContractPeriod</code>) y no se cruza con otro <code>ACTIVE</code> (<code>ContractOverlap</code>).</td></tr>
<tr><td><code>terminateContract(Long contractId)</code></td><td><code>void</code></td><td>public</td><td>Termina un contrato existente (<code>ContractNotFound</code>) y <code>ACTIVE</code> (<code>ContractNotActive</code>).</td></tr>
<tr><td><code>scheduleVacation(VacationPeriod period, LocalDate today)</code></td><td><code>void</code></td><td>public</td><td>Programa vacaciones: no empiezan antes de <code>today</code> (<code>InvalidVacationPeriod</code>), caen dentro de un contrato <code>ACTIVE</code> (<code>VacationOutsideContract</code>) y no se cruzan con otras (<code>VacationOverlap</code>).</td></tr>
<tr><td><code>cancelVacation(Long vacationId, LocalDate today)</code></td><td><code>void</code></td><td>public</td><td>Cancela vacaciones existentes (<code>VacationNotFound</code>) que aún no empezaron (<code>VacationNotCancelable</code>).</td></tr>
<tr><td><code>suspend()</code></td><td><code>void</code></td><td>public</td><td>De <code>ACTIVE</code> a <code>SUSPENDED</code>. Registra <code>EmployeeSuspendedEvent</code>.</td></tr>
<tr><td><code>reinstate()</code></td><td><code>void</code></td><td>public</td><td>De <code>SUSPENDED</code> a <code>ACTIVE</code>. Registra <code>EmployeeReinstatedEvent</code>.</td></tr>
<tr><td><code>terminate(LocalDate today)</code></td><td><code>void</code></td><td>public</td><td>De <code>ACTIVE</code> o <code>SUSPENDED</code> a <code>TERMINATED</code> (final): termina el contrato vigente, cancela las vacaciones futuras y registra <code>EmployeeTerminatedEvent</code>.</td></tr>
<tr><td><code>currentContract(LocalDate today)</code></td><td><code>Optional&lt;Contract&gt;</code></td><td>public</td><td>Contrato vigente a la fecha, si lo hay.</td></tr>
<tr><td><code>isOnVacation(LocalDate today)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la fecha cae en unas vacaciones programadas. "De vacaciones" se calcula; no es un estado.</td></tr>
<tr><td><code>isTerminated()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si fue cesado.</td></tr>
<tr><td><b>Notas</b></td><td colspan="3">Ningún método modifica a un empleado <code>TERMINATED</code> (<code>EmployeeTerminated</code>), y una transición no permitida lanza <code>InvalidEmployeeStatusTransition</code>. Un empleado sin contrato vigente sigue <code>ACTIVE</code> hasta que el administrador lo renueve (<code>addContract</code>) o lo cese (<code>terminate</code>); no hay proceso automático.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>workSchedule</code>)</td><td><code>WorkSchedule</code></td><td>1 a 1</td><td>Horario del empleado.</td></tr>
<tr><td>Composición (<code>contractHistory</code>)</td><td><code>ContractHistory</code></td><td>1 a 1</td><td>Historial de contratos.</td></tr>
<tr><td>Composición (<code>vacationHistory</code>)</td><td><code>VacationHistory</code></td><td>1 a 1</td><td>Historial de vacaciones.</td></tr>
<tr><td>Asociaciones (<code>role</code>, <code>status</code>)</td><td><code>EmployeeRole</code>, <code>EmployeeStatus</code></td><td>0..* a 1</td><td>Rol y estado.</td></tr>
<tr><td>Dependencia "valida turnos con"</td><td><code>OperatingHours</code></td><td>No aplica</td><td>Horario del negocio que limita los turnos.</td></tr>
<tr><td>Dependencia "registra"</td><td>Eventos del empleado</td><td>No aplica</td><td>Contratación, suspensión, reincorporación y cese.</td></tr>
</table>

#### Entities

<table>
<tr><th colspan="4" align="left"><code>Contract</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Entity (extiende <code>AuditableModel</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Un contrato laboral. Siempre tiene fecha de fin. Vive dentro de <code>Employee</code> y solo se modifica por él.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employee</code></td><td><code>Employee</code></td><td>private</td><td>Referencia a su aggregate root.</td></tr>
<tr><td><code>period</code></td><td><code>ContractPeriod</code></td><td>private</td><td>Fechas de inicio y fin.</td></tr>
<tr><td><code>type</code></td><td><code>TypeOfContract</code></td><td>private</td><td>Tiempo completo o parcial.</td></tr>
<tr><td><code>status</code></td><td><code>ContractStatus</code></td><td>private</td><td><code>ACTIVE</code> o <code>TERMINATED</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Contract(Employee employee, ContractPeriod period, TypeOfContract type)</code></td><td>(constructor)</td><td>public</td><td>Crea el contrato en <code>ACTIVE</code>.</td></tr>
<tr><td><code>terminate()</code></td><td><code>void</code></td><td>public</td><td>De <code>ACTIVE</code> a <code>TERMINATED</code>, antes de su fecha de fin.</td></tr>
<tr><td><code>isActive()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si está <code>ACTIVE</code>.</td></tr>
<tr><td><code>isExpired(LocalDate today)</code></td><td><code>boolean</code></td><td>public</td><td><code>ACTIVE</code> con fecha de fin anterior a <code>today</code>. Se calcula; no se guarda.</td></tr>
<tr><td><code>isCurrentOn(LocalDate date)</code></td><td><code>boolean</code></td><td>public</td><td><code>ACTIVE</code> y la fecha está dentro de su periodo.</td></tr>
<tr><td><code>overlapsWith(ContractPeriod period)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si su periodo se cruza con otro.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>period</code>)</td><td><code>ContractPeriod</code></td><td>1 a 1</td><td>Periodo del contrato.</td></tr>
<tr><td>Asociaciones (<code>type</code>, <code>status</code>)</td><td><code>TypeOfContract</code>, <code>ContractStatus</code></td><td>0..* a 1</td><td>Tipo y estado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Vacation</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Entity (extiende <code>AuditableModel</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Un periodo de vacaciones programado. Vive dentro de <code>Employee</code>. Una vacación que ya terminó sigue <code>SCHEDULED</code>: es el historial de lo que tomó.</td></tr>
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
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>period</code>)</td><td><code>VacationPeriod</code></td><td>1 a 1</td><td>Periodo de la vacación.</td></tr>
<tr><td>Asociación (<code>status</code>)</td><td><code>VacationStatus</code></td><td>0..* a 1</td><td>Estado.</td></tr>
</table>

#### Value Objects y componentes embebidos

<table>
<tr><th colspan="4" align="left"><code>ContractHistory</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Componente embebido en <code>Employee</code></td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Agrupa todos los contratos del empleado, vigentes y pasados. Es mutable y contiene entidades; se ubica en <code>valueobjects</code> porque se embebe en el aggregate.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>contracts</code></td><td><code>List&lt;Contract&gt;</code></td><td>private</td><td>Lista mutable; inicia vacía.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ContractHistory()</code></td><td>(constructor)</td><td>public</td><td>Inicia la lista vacía.</td></tr>
<tr><td><code>addContract(Employee employee, ContractPeriod period, TypeOfContract type)</code></td><td><code>Contract</code></td><td>public</td><td>Crea y agrega un contrato.</td></tr>
<tr><td><code>getContractWithId(Long contractId)</code></td><td><code>Contract</code></td><td>public</td><td>Devuelve el contrato o lanza <code>ContractNotFound</code>.</td></tr>
<tr><td><code>currentContract(LocalDate today)</code></td><td><code>Optional&lt;Contract&gt;</code></td><td>public</td><td>Contrato vigente a la fecha.</td></tr>
<tr><td><code>hasActiveContractOverlapping(ContractPeriod period)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si un contrato <code>ACTIVE</code> se cruza con el periodo.</td></tr>
<tr><td><code>hasActiveContractCovering(VacationPeriod period)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si un contrato <code>ACTIVE</code> cubre las vacaciones.</td></tr>
<tr><td><code>terminateActiveContracts()</code></td><td><code>void</code></td><td>public</td><td>Termina los contratos <code>ACTIVE</code> (al cesar al empleado).</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>contracts</code>)</td><td><code>Contract</code></td><td>1 a 1..*</td><td>Al menos el primer contrato.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VacationHistory</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Componente embebido en <code>Employee</code></td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Agrupa las vacaciones del empleado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>vacations</code></td><td><code>List&lt;Vacation&gt;</code></td><td>private</td><td>Lista mutable; inicia vacía.</td></tr>
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
<tr><td>Composición (<code>vacations</code>)</td><td><code>Vacation</code></td><td>1 a 0..*</td><td>Vacaciones del empleado.</td></tr>
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
<tr><td><b>Propósito</b></td><td colspan="3">Horario de trabajo semanal del empleado, fuera del contrato: un <code>WeeklyPeriod</code> (Shared) por cada bloque de días con el mismo turno (ej. Lun-Vie 08:00-16:00 y Sáb 08:00-12:00).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>shifts</code></td><td><code>List&lt;WeeklyPeriod&gt;</code></td><td>private final</td><td>Al menos un turno; ninguno cruza medianoche ni se cruza con otro (<code>InvalidWorkSchedule</code>).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>WorkSchedule(List&lt;WeeklyPeriod&gt; shifts)</code></td><td>(constructor)</td><td>public</td><td>Valida los turnos.</td></tr>
<tr><td><code>isWorkingAt(DayOfWeek day, LocalTime time)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si trabaja ese día a esa hora.</td></tr>
<tr><td><code>fitsWithin(OperatingHours operatingHours)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si cada turno cabe en el horario del negocio.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>OperatingHours</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Horario de atención del negocio del empleado (por ejemplo, hasta las 22:00). Es la traducción que hace el ACL del <code>BusinessHours</code> de Profiles; no cruza medianoche.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>periods</code></td><td><code>List&lt;WeeklyPeriod&gt;</code></td><td>private final</td><td>Periodos de atención.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>OperatingHours(List&lt;WeeklyPeriod&gt; periods)</code></td><td>(constructor)</td><td>public</td><td>Crea el horario.</td></tr>
<tr><td><code>covers(WeeklyPeriod shift)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si un turno queda dentro del horario de atención.</td></tr>
</table>

#### Enumerations

<table>
<tr><th colspan="4" align="left"><code>EmployeeStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado laboral. <code>TERMINATED</code> es final.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>ACTIVE</code>, <code>SUSPENDED</code>, <code>TERMINATED</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeRole</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Rol del empleado.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>TECH</code>, <code>SUBSCRIPTION_MANAGER</code>, <code>CLEANING</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ContractStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de un contrato. "Vencido" se calcula con la fecha de fin.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>ACTIVE</code>, <code>TERMINATED</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>TypeOfContract</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tiempo completo o parcial.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>FULL_TIME</code>, <code>PART_TIME</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VacationStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de unas vacaciones.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>SCHEDULED</code>, <code>CANCELLED</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

#### Domain Events

Los consumen IAM (habilita, bloquea o desactiva la cuenta corporativa) y Communication (avisa al empleado por su correo corporativo). La cuenta personal de familiar, si la tiene, no cambia.

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
<tr><td><b>Lo registra</b></td><td colspan="3">Constructor de <code>Employee</code></td></tr>
<tr><td><b>Reacción esperada</b></td><td colspan="3">Communication avisa la contratación. La contraseña temporal la envía Communication con el evento <code>CorporateAccountCreatedEvent</code> de IAM, que recibe el rol al crear la cuenta. Lee el id al publicarse, porque al registrarse el empleado aún no tiene id.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeSuspendedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que se suspendió a un empleado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeSuspendedEvent(Long employeeId, Long businessId, Long userId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Employee.suspend</code></td></tr>
<tr><td><b>Reacción esperada</b></td><td colspan="3">IAM bloquea la cuenta corporativa.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeReinstatedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que un empleado suspendido volvió a estar activo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeReinstatedEvent(Long employeeId, Long businessId, Long userId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Employee.reinstate</code></td></tr>
<tr><td><b>Reacción esperada</b></td><td colspan="3">IAM vuelve a habilitar la cuenta.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeTerminatedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que se cesó a un empleado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeTerminatedEvent(Long employeeId, Long businessId, Long userId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Employee.terminate</code></td></tr>
<tr><td><b>Reacción esperada</b></td><td colspan="3">IAM desactiva la cuenta corporativa.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeRoleChangedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que cambió el rol de un empleado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><td><code>role</code></td><td><code>EmployeeRole</code></td><td>private final</td><td>Rol en el negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeRoleChangedEvent(Long employeeId, Long businessId, Long userId, EmployeeRole role)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Employee.changeRole</code></td></tr>
<tr><td><b>Reacción esperada</b></td><td colspan="3">IAM cambia el rol de la cuenta corporativa.</td></tr>
</table>

#### Commands

Todo command lleva `businessId`: el empleado existe (`EmployeeNotFound`) y pertenece a ese negocio (`EmployeeNotInBusiness`). El `businessId` lo resuelve la capa de aplicación desde el usuario que inició sesión.

<table>
<tr><th colspan="4" align="left"><code>CreateEmployeeCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Contrata a un empleado: su <code>StaffProfile</code>, su cuenta corporativa en IAM, el aggregate <code>Employee</code> y su primer contrato.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Negocio que contrata.</td></tr>
<tr><td><code>corporateEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo corporativo. Obligatorio.</td></tr>
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
<tr><td><b>Reglas</b></td><td colspan="3">Lo ejecuta el administrador. El negocio existe (<code>BusinessNotFound</code>). El DNI no está entre el personal (<code>DniAlreadyExists</code>) y el correo corporativo no está registrado (<code>EmailAddressAlreadyExists</code>): nadie es empleado dos veces y un administrador no puede ser empleado. Profiles crea el <code>StaffProfile</code>; IAM crea la cuenta corporativa con una contraseña temporal, que Communication envía al correo corporativo; el empleado no tiene acceso hasta cambiarla.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateEmployeeCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Actualiza los datos personales del empleado en su <code>StaffProfile</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Negocio.</td></tr>
<tr><td><code>photoData</code></td><td><code>byte[]</code></td><td>private final</td><td>Archivo de la foto.</td></tr>
<tr><td><code>photoFileName</code></td><td><code>String</code></td><td>private final</td><td>Nombre del archivo.</td></tr>
<tr><td><code>phoneNumber</code></td><td><code>String</code></td><td>private final</td><td>Teléfono.</td></tr>
<tr><td><code>firstName</code></td><td><code>String</code></td><td>private final</td><td>Nombres.</td></tr>
<tr><td><code>lastName</code></td><td><code>String</code></td><td>private final</td><td>Apellidos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateEmployeeCommand(Long employeeId, Long businessId, byte[] photoData, String photoFileName, String phoneNumber, String firstName, String lastName)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Actualiza los datos personales en su <code>StaffProfile</code>; <code>Employee</code> no cambia. El empleado no está <code>TERMINATED</code> (<code>EmployeeTerminated</code>). Email, DNI y fecha de nacimiento no se modifican.</td></tr>
</table>

**Commands de rol, horario, estado, contratos y vacaciones**

<table>
<tr><th colspan="4" align="left"><code>ChangeEmployeeRoleCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cambia el rol (<code>Employee.changeRole</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>role</code></td><td><code>EmployeeRole</code></td><td>private final</td><td>Rol en el negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ChangeEmployeeRoleCommand(Long employeeId, Long businessId, EmployeeRole role)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
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
</table>

<table>
<tr><th colspan="4" align="left"><code>TerminateEmployeeCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Lo cesa: termina su contrato, cancela vacaciones futuras y desactiva su cuenta corporativa (<code>Employee.terminate</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>TerminateEmployeeCommand(Long employeeId, Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateContractCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Renueva con un nuevo contrato (<code>Employee.addContract</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>startDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de inicio.</td></tr>
<tr><td><code>endDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de fin.</td></tr>
<tr><td><code>type</code></td><td><code>TypeOfContract</code></td><td>private final</td><td>Tipo de actividad.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateContractCommand(Long employeeId, Long businessId, LocalDate startDate, LocalDate endDate, TypeOfContract type)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
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
</table>

#### Queries

<table>
<tr><th colspan="4" align="left"><code>GetAllEmployeesByBusinessIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Personal de un negocio; <code>status</code> y <code>role</code> son filtros opcionales (nulo: sin filtro).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>status</code></td><td><code>EmployeeStatus</code></td><td>private final</td><td>Estado de la invitación.</td></tr>
<tr><td><code>role</code></td><td><code>EmployeeRole</code></td><td>private final</td><td>Rol en el negocio.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllEmployeesByBusinessIdQuery(Long businessId, EmployeeStatus status, EmployeeRole role)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Employee&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetEmployeeByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Empleado por id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetEmployeeByIdQuery(Long employeeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Employee&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetEmployeeByUserIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Empleado del usuario que inició sesión.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetEmployeeByUserIdQuery(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Employee&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllContractsByEmployeeIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Contratos que se cruzan con <code>[from, to]</code>; filtros opcionales.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>from</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha inicial del rango consultado.</td></tr>
<tr><td><code>to</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha final del rango consultado.</td></tr>
<tr><td><code>status</code></td><td><code>ContractStatus</code></td><td>private final</td><td>Estado de la invitación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllContractsByEmployeeIdQuery(Long employeeId, LocalDate from, LocalDate to, ContractStatus status)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Contract&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetContractByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Contrato buscado dentro de su empleado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>contractId</code></td><td><code>Long</code></td><td>private final</td><td>Id del contrato.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetContractByIdQuery(Long employeeId, Long contractId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Contract&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllVacationsByEmployeeIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Vacaciones que se cruzan con <code>[from, to]</code>; filtros opcionales.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>employeeId</code></td><td><code>Long</code></td><td>private final</td><td>Empleado.</td></tr>
<tr><td><code>from</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha inicial del rango consultado.</td></tr>
<tr><td><code>to</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha final del rango consultado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllVacationsByEmployeeIdQuery(Long employeeId, LocalDate from, LocalDate to)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Vacation&gt;</code></td></tr>
</table>

#### Domain Services

Todos los métodos son `public` (interfaces). Los commands devuelven el id del `Employee`; los de contrato o vacación, el id del `Contract` o de la `Vacation`.

<table>
<tr><th colspan="4" align="left"><code>EmployeeCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Employee</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateEmployeeCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateEmployeeCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(UpdateEmployeeCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>UpdateEmployeeCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(ChangeEmployeeRoleCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ChangeEmployeeRoleCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(UpdateEmployeeWorkScheduleCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>UpdateEmployeeWorkScheduleCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(SuspendEmployeeCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>SuspendEmployeeCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(ReinstateEmployeeCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ReinstateEmployeeCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(TerminateEmployeeCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>TerminateEmployeeCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(CreateContractCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateContractCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(TerminateContractCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>TerminateContractCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(ScheduleVacationCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ScheduleVacationCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(CancelVacationCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CancelVacationCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Employee</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetAllEmployeesByBusinessIdQuery query)</code></td><td><code>List&lt;Employee&gt;</code></td><td>public</td><td>Resuelve <code>GetAllEmployeesByBusinessIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetEmployeeByIdQuery query)</code></td><td><code>Optional&lt;Employee&gt;</code></td><td>public</td><td>Resuelve <code>GetEmployeeByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetEmployeeByUserIdQuery query)</code></td><td><code>Optional&lt;Employee&gt;</code></td><td>public</td><td>Resuelve <code>GetEmployeeByUserIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetAllContractsByEmployeeIdQuery query)</code></td><td><code>List&lt;Contract&gt;</code></td><td>public</td><td>Resuelve <code>GetAllContractsByEmployeeIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetContractByIdQuery query)</code></td><td><code>Optional&lt;Contract&gt;</code></td><td>public</td><td>Resuelve <code>GetContractByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetAllVacationsByEmployeeIdQuery query)</code></td><td><code>List&lt;Vacation&gt;</code></td><td>public</td><td>Resuelve <code>GetAllVacationsByEmployeeIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

#### Exceptions

Cada excepción tiene un constructor `public` sin parámetros.

<table>
<tr><th colspan="4" align="left"><code>EmployeeNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe el empleado indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeNotInBusiness</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el empleado no pertenece al negocio indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeNotInBusiness()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el negocio no existe en Company.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmployeeTerminated</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta modificar a un empleado cesado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmployeeTerminated()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidEmployeeStatusTransition</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la transición de estado no está permitida (ej. suspender a un suspendido).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidEmployeeStatusTransition()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DniAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el DNI ya está registrado entre el personal.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DniAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailAddressAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el correo corporativo ya está registrado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmailAddressAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ContractNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el contrato no existe dentro del empleado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ContractNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ContractNotActive</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta terminar un contrato que no está <code>ACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ContractNotActive()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ContractOverlap</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el nuevo contrato se cruza con otro <code>ACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ContractOverlap()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidContractPeriod</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando fechas inválidas o inicio anterior a hoy.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidContractPeriod()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidWorkSchedule</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando horario vacío, con turnos que cruzan medianoche o que se cruzan entre sí.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidWorkSchedule()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>WorkScheduleOutsideOperatingHours</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando un turno queda fuera del horario de atención del negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>WorkScheduleOutsideOperatingHours()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VacationNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando las vacaciones no existen dentro del empleado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>VacationNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidVacationPeriod</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando fechas inválidas o inicio anterior a hoy.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidVacationPeriod()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VacationOverlap</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se cruzan con otras vacaciones programadas.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>VacationOverlap()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VacationOutsideContract</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no caen dentro de un contrato <code>ACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>VacationOutsideContract()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>VacationNotCancelable</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando ya empezaron o ya fueron canceladas.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>VacationNotCancelable()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

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

El diagrama muestra el aggregate `Employee` con sus componentes embebidos (`WorkSchedule`, `ContractHistory`, `VacationHistory`) y las entidades `Contract` (1..*) y `Vacation` (0..*), todo por composición con nombre y multiplicidad. Los enums se enlazan con la clase que los usa. `Employee` registra los cuatro eventos y depende de `OperatingHours` para validar los turnos. Los services reciben sus commands y queries, y las notas detallan las reglas de los commands y los contextos externos (Company, Profiles, IAM y Communication).

![Diagrama de clases de la capa de dominio - Capital Humano](../images/diagrams/img/chapter-5/hcm-backend-diagram.svg)

#### 5.4.7.2. Bounded Context Database Design Diagram

| Tabla | Aggregate, entidad o value object | Llaves y restricciones |
|---|---|---|
| `employees` | `Employee` | PK `id`. UK `user_id` y UK `staff_profile_id` (sin FK, otros contextos). Índice `business_id`. |
| `employee_work_shifts` | `WorkSchedule` (colección de `WeeklyPeriod`) | FK `employee_id`. Sin id propio: es parte del valor del aggregate. |
| `contracts` | `Contract` | PK `id`. FK `employee_id`. `CHECK (end_date >= start_date)`. Opcional: restricción de exclusión que impide dos contratos `ACTIVE` que se cruzan. |
| `vacations` | `Vacation` | PK `id`. FK `employee_id`. `CHECK (end_date >= start_date)`. Opcional: restricción de exclusión para vacaciones `SCHEDULED`. |

Relaciones: un empleado tiene uno o más turnos (1 a 1..*), uno o más contratos (1 a 1..*) y cero o más vacaciones (1 a 0..*). Ningún registro se borra: un empleado cesado, un contrato terminado y unas vacaciones canceladas quedan como historial.

![Diagrama de base de datos - Capital Humano](../images/diagrams/img/chapter-5/hcm-database-diagram.svg)

<div style="page-break-after: always;"></div>

## 5.5. Bounded Context: Asistencia Médica

En el código, este bounded context es el paquete `assistance`. Assistance gestiona el cuidado de las personas asistidas. El familiar (`Relative`) se registra por su cuenta, paga la suscripción y gestiona a sus personas asistidas: invita cuidadores por correo, crea actividades de cuidado (medicación, baño, comida, etc.) y las asigna a un cuidador o a sí mismo con un horario. Cada responsable marca como realizadas solo sus propias asignaciones y solo dentro de su horario. Las ocurrencias de una actividad no se guardan: se calculan con el horario, y solo se guarda lo que pasó con cada una (`ActivityLog`). Dentro del contexto los aggregates se referencian directamente; con otros contextos, solo por `UserId`, `PersonProfileId` y `BusinessId`.

### 5.5.1. Domain Layer

#### Aggregates

Todos extienden `AuditableAbstractAggregateRoot` (id, createdAt, updatedAt y registro de eventos).

<table>
<tr><th colspan="4" align="left"><code>Relative</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar responsable. Se registra en un negocio, paga la suscripción, gestiona a sus personas asistidas e invita cuidadores.</td></tr>
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
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">La persona con discapacidad que recibe el cuidado. Pertenece a un solo familiar, no tiene cuenta en IAM y no se da de baja.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>personProfileId</code></td><td><code>PersonProfileId</code></td><td>private</td><td>Su perfil de cliente en Profiles (puede no tener email).</td></tr>
<tr><td><code>relative</code></td><td><code>Relative</code></td><td>private</td><td>Familiar que la gestiona.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssistedPerson(PersonProfileId personProfileId, Relative relative)</code></td><td>(constructor)</td><td>public</td><td>Crea la persona asistida bajo su familiar.</td></tr>
<tr><td><code>isManagedBy(Relative relative)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la gestiona ese familiar. Se usa para validar pertenencia.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación "gestionada por"</td><td><code>Relative</code></td><td>0..* a 1</td><td>Un familiar gestiona varias personas asistidas; cada una tiene un solo familiar.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Invitation</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Invitación de un familiar a un cuidador, por correo, para cuidar a una persona asistida. Ciclo: <code>PENDING</code>, <code>ACCEPTED</code> o <code>REVOKED</code>. "Vencida" se calcula; no es un estado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPerson</code></td><td><code>AssistedPerson</code></td><td>private</td><td>Persona a cuidar.</td></tr>
<tr><td><code>inviter</code></td><td><code>Relative</code></td><td>private</td><td>Familiar que invita.</td></tr>
<tr><td><code>inviteeEmail</code></td><td><code>EmailAddress</code></td><td>private</td><td>Correo del cuidador invitado.</td></tr>
<tr><td><code>caregiverUserId</code></td><td><code>UserId</code></td><td>private</td><td>Cuenta de IAM asignada al cuidador. Nula hasta que IAM la asigna.</td></tr>
<tr><td><code>status</code></td><td><code>InvitationStatus</code></td><td>private</td><td>Estado de la invitación.</td></tr>
<tr><td><code>expiresAt</code></td><td><code>LocalDateTime</code></td><td>private</td><td>Fecha y hora de vencimiento.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Invitation(AssistedPerson assistedPerson, Relative inviter, EmailAddress inviteeEmail, LocalDateTime expiresAt)</code></td><td>(constructor)</td><td>public</td><td>Valida que la persona sea del familiar (<code>AssistedPersonNotManagedByRelative</code>), inicia en <code>PENDING</code> y registra <code>InvitationCreatedEvent</code>.</td></tr>
<tr><td><code>assignCaregiverAccount(UserId userId, String passwordSetupUrl)</code></td><td><code>void</code></td><td>public</td><td>Asigna una cuenta nueva creada por IAM. Requiere <code>PENDING</code>; en un reenvío, el mismo userId. Registra <code>InvitationAccountCreatedEvent</code>.</td></tr>
<tr><td><code>assignExistingCaregiverAccount(UserId userId)</code></td><td><code>void</code></td><td>public</td><td>Asigna la cuenta que el cuidador ya tenía. Mismas reglas. Registra <code>InvitationNotificationRequestedEvent</code>.</td></tr>
<tr><td><code>accept(UserId caregiverUserId, LocalDateTime now)</code></td><td><code>void</code></td><td>public</td><td>Acepta la invitación. Requiere <code>PENDING</code> (<code>InvitationNotPending</code>), no vencida (<code>InvitationExpired</code>), cuenta asignada (<code>CaregiverAccountNotAssigned</code>) y que acepte el usuario asignado (<code>InvitationNotForUser</code>). Registra <code>InvitationAcceptedEvent</code>.</td></tr>
<tr><td><code>renew(LocalDateTime newExpiresAt)</code></td><td><code>void</code></td><td>public</td><td>Da una nueva vigencia para reenviarla. Requiere <code>PENDING</code>. Registra <code>InvitationResentEvent</code>.</td></tr>
<tr><td><code>revoke()</code></td><td><code>void</code></td><td>public</td><td>Revoca la invitación. Requiere <code>PENDING</code>.</td></tr>
<tr><td><code>isExpired(LocalDateTime now)</code></td><td><code>boolean</code></td><td>public</td><td><code>PENDING</code> con <code>expiresAt</code> anterior a <code>now</code>.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación "invita a cuidar a"</td><td><code>AssistedPerson</code></td><td>0..* a 1</td><td>Una persona puede recibir varias invitaciones.</td></tr>
<tr><td>Asociación "enviada por" (<code>inviter</code>)</td><td><code>Relative</code></td><td>0..* a 1</td><td>Un familiar envía varias invitaciones.</td></tr>
<tr><td>Asociación (<code>status</code>)</td><td><code>InvitationStatus</code></td><td>0..* a 1</td><td>Estado actual.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Caregiver</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El acceso de un usuario como cuidador de una persona asistida. Se crea al aceptar la invitación; el familiar puede revocarlo. Un usuario puede ser cuidador de varias personas.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>UserId</code></td><td>private</td><td>Cuenta del cuidador en IAM.</td></tr>
<tr><td><code>assistedPerson</code></td><td><code>AssistedPerson</code></td><td>private</td><td>Persona que cuida.</td></tr>
<tr><td><code>status</code></td><td><code>CaregiverStatus</code></td><td>private</td><td><code>ACTIVE</code> o <code>REVOKED</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Caregiver(UserId userId, AssistedPerson assistedPerson)</code></td><td>(constructor)</td><td>public</td><td>Crea el acceso en estado <code>ACTIVE</code>.</td></tr>
<tr><td><code>revoke()</code></td><td><code>void</code></td><td>public</td><td>Revoca el acceso. Requiere <code>ACTIVE</code> (<code>CaregiverAlreadyRevoked</code>). Registra <code>CaregiverAccessRevokedEvent</code>.</td></tr>
<tr><td><code>isActive()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el acceso sigue vigente.</td></tr>
<tr><td><code>isCaregiverOf(AssistedPerson assistedPerson)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si cuida a esa persona.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación "cuida a"</td><td><code>AssistedPerson</code></td><td>0..* a 1</td><td>Una persona puede tener varios cuidadores.</td></tr>
<tr><td>Asociación (<code>status</code>)</td><td><code>CaregiverStatus</code></td><td>0..* a 1</td><td>Estado actual.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CareActivity</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Una actividad de cuidado de una persona asistida. Contiene sus asignaciones: quién la realiza y cuándo.</td></tr>
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
<tr><td><code>assign(Caregiver caregiver, Schedule schedule, LocalDate today)</code></td><td><code>void</code></td><td>public</td><td>Agrega una asignación. Requiere actividad <code>ACTIVE</code> (<code>CareActivityNotActive</code>); si hay cuidador, <code>ACTIVE</code> (<code>CaregiverNotActive</code>) y de esa persona (<code>CaregiverNotFound</code>); un <code>ONE_TIME</code> no puede estar en el pasado (<code>InvalidSchedule</code>). <code>caregiver</code> nulo: la realiza el familiar.</td></tr>
<tr><td><code>updateAssignment(Long assignmentId, Caregiver caregiver, Schedule schedule, LocalDate today)</code></td><td><code>void</code></td><td>public</td><td>Cambia responsable y horario. Mismas reglas; la asignación existe (<code>ActivityAssignmentNotFound</code>).</td></tr>
<tr><td><code>activateAssignment(Long assignmentId)</code></td><td><code>void</code></td><td>public</td><td>Activa una asignación.</td></tr>
<tr><td><code>deactivateAssignment(Long assignmentId)</code></td><td><code>void</code></td><td>public</td><td>Desactiva una asignación.</td></tr>
<tr><td><code>reassignToRelative(Caregiver revokedCaregiver)</code></td><td><code>void</code></td><td>public</td><td>Pasa al familiar las asignaciones de un cuidador revocado.</td></tr>
<tr><td><code>occurrencesOn(LocalDate date)</code></td><td><code>List&lt;ActivityAssignment&gt;</code></td><td>public</td><td>Asignaciones que ocurren en esa fecha.</td></tr>
<tr><td><code>isActive()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la actividad está <code>ACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación "cuidado de"</td><td><code>AssistedPerson</code></td><td>0..* a 1</td><td>Una persona tiene varias actividades.</td></tr>
<tr><td>Composición (<code>activityAssignments</code>)</td><td><code>ActivityAssignments</code></td><td>1 a 1</td><td>Componente que agrupa sus asignaciones.</td></tr>
<tr><td>Asociaciones (<code>type</code>, <code>status</code>)</td><td><code>CareActivityType</code>, <code>ActivityStatus</code></td><td>0..* a 1</td><td>Tipo y estado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActivityLog</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Lo que pasó con una ocurrencia: completada, cancelada o perdida. Es el historial que consulta el familiar (todo) y cada cuidador (lo suyo). Un solo log por asignación y fecha.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPerson</code></td><td><code>AssistedPerson</code></td><td>private</td><td>Persona asistida (tomada de la actividad).</td></tr>
<tr><td><code>careActivity</code></td><td><code>CareActivity</code></td><td>private</td><td>Actividad registrada.</td></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private</td><td>Asignación registrada. Se guarda por id porque es entidad interna de <code>CareActivity</code>.</td></tr>
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
<tr><td><code>completed(CareActivity activity, ActivityAssignment assignment, LocalDate date, Caregiver completedBy, LocalDateTime at, String notes)</code></td><td><code>ActivityLog</code></td><td>public static</td><td>Registra una ocurrencia completada. Requiere actividad y asignación <code>ACTIVE</code>, que la asignación ocurra ese día (<code>OccurrenceNotScheduled</code>), que complete el responsable (<code>NotResponsibleForActivity</code>) y que <code>at</code> esté dentro del horario (<code>OccurrenceNotStarted</code>, <code>OccurrenceEnded</code>).</td></tr>
<tr><td><code>cancelled(CareActivity activity, ActivityAssignment assignment, LocalDate date, LocalDateTime at)</code></td><td><code>ActivityLog</code></td><td>public static</td><td>Registra una ocurrencia cancelada por el familiar. Puede ser cualquier fecha que aún no terminó (<code>OccurrenceEnded</code>). <code>at</code> solo valida; el momento queda en <code>createdAt</code>.</td></tr>
<tr><td><code>missed(CareActivity activity, ActivityAssignment assignment, LocalDate date, LocalDate today)</code></td><td><code>ActivityLog</code></td><td>public static</td><td>Registra una ocurrencia perdida. Su fecha de cierre debe ser anterior a <code>today</code> (<code>DayNotClosedYet</code>).</td></tr>
<tr><td><b>Notas</b></td><td colspan="3">En las tres fábricas, la persona, el título y el horario se toman de la actividad y la asignación, por lo que no pueden contradecirse.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación "historial de"</td><td><code>AssistedPerson</code></td><td>0..* a 1</td><td>Historial de la persona.</td></tr>
<tr><td>Asociación "registra ocurrencia de"</td><td><code>CareActivity</code></td><td>0..* a 1</td><td>Actividad registrada.</td></tr>
<tr><td>Asociación (<code>assignedCaregiver</code>, <code>completedBy</code>)</td><td><code>Caregiver</code></td><td>0..* a 0..1</td><td>Responsable y quien completó.</td></tr>
<tr><td>Asociación (<code>status</code>)</td><td><code>ActivityLogStatus</code></td><td>0..* a 1</td><td>Resultado.</td></tr>
</table>

#### Entities

<table>
<tr><th colspan="4" align="left"><code>ActivityAssignment</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Entity (extiende <code>AuditableModel</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Quién realiza una actividad (un cuidador o el familiar) y cuándo. Vive dentro de <code>CareActivity</code> y solo se accede por ella. No se borra: se desactiva.</td></tr>
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
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación "realizada por"</td><td><code>Caregiver</code></td><td>0..* a 0..1</td><td>Nulo significa que la realiza el familiar.</td></tr>
<tr><td>Composición (<code>schedule</code>)</td><td><code>Schedule</code></td><td>1 a 1</td><td>Horario de la asignación.</td></tr>
<tr><td>Asociación (<code>status</code>)</td><td><code>ActivityStatus</code></td><td>0..* a 1</td><td>Estado.</td></tr>
</table>

#### Value Objects y componentes embebidos

<table>
<tr><th colspan="4" align="left"><code>ActivityAssignments</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Componente embebido en <code>CareActivity</code></td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Agrupa las asignaciones de una actividad. No es un value object estricto (es mutable y contiene entidades); se ubica en <code>valueobjects</code> porque se embebe en el aggregate.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>activityAssignments</code></td><td><code>List&lt;ActivityAssignment&gt;</code></td><td>private</td><td>Lista mutable; inicia vacía.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActivityAssignments()</code></td><td>(constructor)</td><td>public</td><td>Inicia la lista vacía y mutable.</td></tr>
<tr><td><code>getAssignmentWithId(Long assignmentId)</code></td><td><code>ActivityAssignment</code></td><td>public</td><td>Devuelve la asignación o lanza <code>ActivityAssignmentNotFound</code>; nunca devuelve null.</td></tr>
<tr><td><code>getFirstAssignmentWhere(Predicate&lt;ActivityAssignment&gt; predicate)</code></td><td><code>ActivityAssignment</code></td><td>private</td><td>Búsqueda interna que usa el método anterior.</td></tr>
<tr><td><code>addAssignment(CareActivity careActivity, Caregiver caregiver, Schedule schedule)</code></td><td><code>ActivityAssignment</code></td><td>public</td><td>Crea y agrega una asignación.</td></tr>
<tr><td><code>updateAssignment(Long assignmentId, Caregiver caregiver, Schedule schedule)</code></td><td><code>void</code></td><td>public</td><td>Actualiza una asignación.</td></tr>
<tr><td><code>activateAssignment(Long assignmentId)</code></td><td><code>void</code></td><td>public</td><td>Activa una asignación.</td></tr>
<tr><td><code>deactivateAssignment(Long assignmentId)</code></td><td><code>void</code></td><td>public</td><td>Desactiva una asignación.</td></tr>
<tr><td><code>reassignToRelative(Caregiver revokedCaregiver)</code></td><td><code>void</code></td><td>public</td><td>Pasa al familiar las asignaciones del cuidador revocado.</td></tr>
<tr><td><code>occurrencesOn(LocalDate date)</code></td><td><code>List&lt;ActivityAssignment&gt;</code></td><td>public</td><td>Asignaciones que ocurren esa fecha.</td></tr>
<tr><td><code>isEmpty()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si no hay asignaciones.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición "contiene"</td><td><code>ActivityAssignment</code></td><td>1 a 0..*</td><td>Asignaciones de la actividad.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>Schedule</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cuándo ocurre una asignación: una fecha puntual (<code>ONE_TIME</code>) o ciertos días de la semana (<code>WEEKLY</code>), con su rango de horas. Admite rangos que cruzan medianoche: la ocurrencia pertenece a la fecha en que empieza.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>type</code></td><td><code>ScheduleType</code></td><td>private final</td><td><code>ONE_TIME</code> o <code>WEEKLY</code>.</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha (solo <code>ONE_TIME</code>).</td></tr>
<tr><td><code>timeRange</code></td><td><code>TimeRange</code></td><td>private final</td><td>Rango (solo <code>ONE_TIME</code>).</td></tr>
<tr><td><code>weeklyPeriod</code></td><td><code>WeeklyPeriod</code></td><td>private final</td><td>Días y rango (solo <code>WEEKLY</code>).</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>oneTime(LocalDate date, TimeRange timeRange)</code></td><td><code>Schedule</code></td><td>public static</td><td>Fábrica de un horario puntual.</td></tr>
<tr><td><code>weekly(WeeklyPeriod weeklyPeriod)</code></td><td><code>Schedule</code></td><td>public static</td><td>Fábrica de un horario semanal.</td></tr>
<tr><td><code>occursOn(LocalDate date)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si hay una ocurrencia que empieza esa fecha.</td></tr>
<tr><td><code>effectiveTimeRange()</code></td><td><code>TimeRange</code></td><td>public</td><td>Rango de cualquiera de las dos formas (es el que se copia al log).</td></tr>
<tr><td><code>occurrenceStart(LocalDate date)</code></td><td><code>LocalDateTime</code></td><td>public</td><td>Fecha y hora real de inicio de la ocurrencia.</td></tr>
<tr><td><code>occurrenceEnd(LocalDate date)</code></td><td><code>LocalDateTime</code></td><td>public</td><td>Fecha y hora real de fin (lunes 22:00-06:00 termina el martes 06:00).</td></tr>
<tr><td><code>closingDate(LocalDate date)</code></td><td><code>LocalDate</code></td><td>public</td><td>Día en que termina la ocurrencia; ese día se cierra como <code>MISSED</code> si no tiene log.</td></tr>
<tr><td><code>overlapsWith(Schedule other)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si alguna ocurrencia se cruza en el tiempo con la del otro horario.</td></tr>
<tr><td><b>Invariantes</b></td><td colspan="3"><code>ONE_TIME</code> exige fecha y rango; <code>WEEKLY</code> exige al menos un día (<code>InvalidSchedule</code>). Que la fecha no esté en el pasado lo valida <code>CareActivity</code>, porque al reconstruir una asignación antigua el constructor fallaría.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación (<code>type</code>)</td><td><code>ScheduleType</code></td><td>0..* a 1</td><td>Forma del horario.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AgendaItem</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record), modelo de lectura</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Una ocurrencia calculada para mostrar en la agenda, con su estado actual. No se guarda.</td></tr>
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
<tr><td><code>of(CareActivity activity, ActivityAssignment assignment, LocalDate date, ActivityLog log, LocalDateTime now)</code></td><td><code>AgendaItem</code></td><td>public static</td><td>Calcula el estado: si hay log, su resultado; si no, <code>SCHEDULED</code> antes del inicio, <code>IN_PROGRESS</code> dentro del horario y <code>MISSED</code> después del fin.</td></tr>
<tr><td><code>AgendaItem(Long careActivityId, Long assignmentId, String title, CareActivityType type, LocalDate date, TimeRange timeRange, Long caregiverId, boolean recurring, OccurrenceStatus status)</code></td><td>(constructor)</td><td>public</td><td>Crea la instancia y valida sus invariantes.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación (<code>status</code>)</td><td><code>OccurrenceStatus</code></td><td>0..* a 1</td><td>Estado de la ocurrencia.</td></tr>
</table>

#### Enumerations

<table>
<tr><th colspan="4" align="left"><code>ScheduleType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Fecha puntual o días de la semana.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>ONE_TIME</code>, <code>WEEKLY</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CareActivityType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tipo de actividad de cuidado.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>MEDICATION</code>, <code>BATH</code>, <code>MEAL</code>, <code>EXERCISE</code>, <code>THERAPY</code>, <code>APPOINTMENT</code>, <code>OTHER</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActivityStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de una actividad o de una asignación.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>ACTIVE</code>, <code>INACTIVE</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActivityLogStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Resultado registrado de una ocurrencia.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>COMPLETED</code>, <code>CANCELLED</code>, <code>MISSED</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>OccurrenceStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado calculado de una ocurrencia en la agenda.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>SCHEDULED</code>, <code>IN_PROGRESS</code>, <code>COMPLETED</code>, <code>CANCELLED</code>, <code>MISSED</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Ciclo de una invitación.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>PENDING</code>, <code>ACCEPTED</code>, <code>REVOKED</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CaregiverStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado del acceso de un cuidador.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>ACTIVE</code>, <code>REVOKED</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

#### Domain Events

Son eventos internos: cada uno activa el siguiente command del flujo.

<table>
<tr><th colspan="4" align="left"><code>InvitationCreatedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que un familiar creó una invitación para un cuidador.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitation</code></td><td><code>Invitation</code></td><td>private</td><td>Invitación que originó el evento; su id se lee al publicarse.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>getInvitationId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve el id de la invitación al publicarse el evento.</td></tr>
<tr><td><code>InvitationCreatedEvent(Invitation invitation)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3">Constructor de <code>Invitation</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3"><code>RegisterCaregiverAccountCommand</code>. Lee el id al publicarse, porque al registrarse la invitación aún no tiene id.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationResentEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que se reenvió una invitación pendiente con una nueva vigencia.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationResentEvent(Long invitationId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Invitation.renew</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3"><code>RegisterCaregiverAccountCommand</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationAccountCreatedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que IAM creó la cuenta del cuidador invitado y que debe enviársele el correo para definir su contraseña.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><td><code>inviteeEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo del cuidador invitado.</td></tr>
<tr><td><code>passwordSetupUrl</code></td><td><code>String</code></td><td>private final</td><td>Url para que el cuidador defina su contraseña.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationAccountCreatedEvent(Long invitationId, String inviteeEmail, String passwordSetupUrl)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Invitation.assignCaregiverAccount</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3"><code>SendInvitationEmailCommand</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationNotificationRequestedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que el cuidador invitado ya tenía cuenta y debe recibir la invitación como notificación en la app.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><td><code>caregiverUserId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta de IAM asignada al cuidador. Nula hasta que IAM la asigna.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationNotificationRequestedEvent(Long invitationId, Long caregiverUserId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Invitation.assignExistingCaregiverAccount</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3"><code>SendInvitationNotificationCommand</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationAcceptedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que el cuidador aceptó la invitación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><td><code>caregiverUserId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta de IAM asignada al cuidador. Nula hasta que IAM la asigna.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationAcceptedEvent(Long invitationId, Long assistedPersonId, Long caregiverUserId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Invitation.accept</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3"><code>CreateCaregiverCommand</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CaregiverAccessRevokedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que el familiar revocó el acceso de un cuidador a una persona asistida.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>caregiverId</code></td><td><code>Long</code></td><td>private final</td><td>Cuidador responsable (nulo: el familiar).</td></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CaregiverAccessRevokedEvent(Long caregiverId, Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Caregiver.revoke</code></td></tr>
<tr><td><b>Activa</b></td><td colspan="3"><code>ReassignCaregiverActivitiesCommand</code></td></tr>
</table>

#### Commands

<table>
<tr><th colspan="4" align="left"><code>CreateRelativeCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Registra a un familiar: su cuenta en IAM con email y contraseña, su <code>PersonProfile</code> en Profiles y el aggregate <code>Relative</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Negocio de Company.</td></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Obligatorio: es su cuenta en IAM y el email de su <code>PersonProfile</code>.</td></tr>
<tr><td><code>password</code></td><td><code>String</code></td><td>private final</td><td>Obligatoria. Se oculta en <code>toString()</code>.</td></tr>
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
<tr><td><b>Reglas</b></td><td colspan="3">Lo ejecuta el propio familiar. El negocio existe (<code>BusinessNotFound</code>). El DNI no está entre los clientes (<code>DniAlreadyExists</code>) y el email no está registrado (<code>EmailAddressAlreadyExists</code>); nadie se registra dos veces como familiar. Profiles crea el <code>PersonProfile</code> e IAM la cuenta personal. Si también es empleado de Alivia, conserva aparte su <code>StaffProfile</code> y su cuenta corporativa.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateAssistedPersonCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Registra a una persona asistida que gestiona un familiar: su <code>PersonProfile</code> (sin cuenta en IAM) y el aggregate <code>AssistedPerson</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que la registra.</td></tr>
<tr><td><code>emailAddress</code></td><td><code>String</code></td><td>private final</td><td>Opcional.</td></tr>
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
<tr><td><b>Reglas</b></td><td colspan="3">El familiar existe (<code>RelativeNotFound</code>). El DNI no está entre los clientes (<code>DniAlreadyExists</code>) y el email, si viene, tampoco (<code>EmailAddressAlreadyExists</code>). No tiene cuenta en IAM.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateCareActivityCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea una actividad de cuidado para una persona asistida del familiar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que opera.</td></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><td><code>type</code></td><td><code>CareActivityType</code></td><td>private final</td><td>Tipo de actividad.</td></tr>
<tr><td><code>title</code></td><td><code>String</code></td><td>private final</td><td>Título.</td></tr>
<tr><td><code>description</code></td><td><code>String</code></td><td>private final</td><td>Descripción.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateCareActivityCommand(Long relativeId, Long assistedPersonId, CareActivityType type, String title, String description)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La persona asistida pertenece al familiar (<code>AssistedPersonNotManagedByRelative</code>); en Update, la actividad existe (<code>CareActivityNotFound</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateCareActivityCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Modifica el tipo, el título y la descripción de una actividad.</td></tr>
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
<tr><td><b>Reglas</b></td><td colspan="3">La persona asistida pertenece al familiar (<code>AssistedPersonNotManagedByRelative</code>); en Update, la actividad existe (<code>CareActivityNotFound</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssignCareActivityCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Asigna una actividad a un cuidador o al propio familiar, con su horario.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que asigna.</td></tr>
<tr><td><code>caregiverId</code></td><td><code>Long</code></td><td>private final</td><td>Opcional: nulo, la realiza el familiar.</td></tr>
<tr><td><code>scheduleType</code></td><td><code>ScheduleType</code></td><td>private final</td><td><code>ONE_TIME</code> o <code>WEEKLY</code>.</td></tr>
<tr><td><code>days</code></td><td><code>Set&lt;DayOfWeek&gt;</code></td><td>private final</td><td>Solo <code>WEEKLY</code>.</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private final</td><td>Solo <code>ONE_TIME</code>.</td></tr>
<tr><td><code>startTime</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de inicio.</td></tr>
<tr><td><code>endTime</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de fin; si es anterior al inicio, cruza medianoche.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssignCareActivityCommand(Long careActivityId, Long relativeId, Long caregiverId, ScheduleType scheduleType, Set&lt;DayOfWeek&gt; days, LocalDate date, LocalTime startTime, LocalTime endTime)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Actividad <code>ACTIVE</code> y de una persona del familiar; si hay cuidador, <code>ACTIVE</code> y de esa persona; horario válido (<code>InvalidSchedule</code>); un <code>ONE_TIME</code> no está en el pasado; no choca con otra asignación <code>ACTIVE</code> del mismo cuidador en cualquier actividad (<code>ScheduleConflict</code>). En Update, un <code>ONE_TIME</code> que ya tiene log no se edita (<code>ScheduleNotEditable</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>UpdateActivityAssignmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Modifica el responsable o el horario de una asignación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad.</td></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Asignación a modificar.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que asigna.</td></tr>
<tr><td><code>caregiverId</code></td><td><code>Long</code></td><td>private final</td><td>Opcional: nulo, la realiza el familiar.</td></tr>
<tr><td><code>scheduleType</code></td><td><code>ScheduleType</code></td><td>private final</td><td><code>ONE_TIME</code> o <code>WEEKLY</code>.</td></tr>
<tr><td><code>days</code></td><td><code>Set&lt;DayOfWeek&gt;</code></td><td>private final</td><td>Solo <code>WEEKLY</code>.</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private final</td><td>Solo <code>ONE_TIME</code>.</td></tr>
<tr><td><code>startTime</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de inicio.</td></tr>
<tr><td><code>endTime</code></td><td><code>LocalTime</code></td><td>private final</td><td>Hora de fin; si es anterior al inicio, cruza medianoche.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateActivityAssignmentCommand(Long careActivityId, Long assignmentId, Long relativeId, Long caregiverId, ScheduleType scheduleType, Set&lt;DayOfWeek&gt; days, LocalDate date, LocalTime startTime, LocalTime endTime)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Actividad <code>ACTIVE</code> y de una persona del familiar; si hay cuidador, <code>ACTIVE</code> y de esa persona; horario válido (<code>InvalidSchedule</code>); un <code>ONE_TIME</code> no está en el pasado; no choca con otra asignación <code>ACTIVE</code> del mismo cuidador en cualquier actividad (<code>ScheduleConflict</code>). En Update, un <code>ONE_TIME</code> que ya tiene log no se edita (<code>ScheduleNotEditable</code>).</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CompleteActivityCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Marca como realizada una ocurrencia de una asignación. Solo la marca su responsable (cuidador o familiar).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad.</td></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Asignación.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Informado si completa el familiar.</td></tr>
<tr><td><code>caregiverId</code></td><td><code>Long</code></td><td>private final</td><td>Informado si completa un cuidador (exactamente uno de los dos).</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha de la ocurrencia.</td></tr>
<tr><td><code>notes</code></td><td><code>String</code></td><td>private final</td><td>Observaciones.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CompleteActivityCommand(Long careActivityId, Long assignmentId, Long relativeId, Long caregiverId, LocalDate date, String notes)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Las de <code>ActivityLog.completed(...)</code>: cada responsable marca solo su asignación y solo dentro de su horario. Además, no existe log para esa asignación y fecha (<code>OccurrenceClosed</code>).</td></tr>
</table>

**Commands con identificadores**

<table>
<tr><th colspan="4" align="left"><code>CreateInvitationCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Invita a un cuidador. No hay otra invitación <code>PENDING</code> al mismo email para esa persona (<code>InvitationAlreadyExists</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que la registra.</td></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><td><code>inviteeEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo del cuidador invitado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateInvitationCommand(Long relativeId, Long assistedPersonId, String inviteeEmail)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RegisterCaregiverAccountCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Pide a IAM la cuenta del cuidador: si ya existe, la reutiliza (sin crear otra) tras validar <code>CaregiverAlreadyExists</code>; si no, IAM la crea con una url para definir la contraseña.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RegisterCaregiverAccountCommand(Long invitationId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SendInvitationEmailCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Communication envía el correo con la url (cuenta nueva).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><td><code>inviteeEmail</code></td><td><code>String</code></td><td>private final</td><td>Correo del cuidador invitado.</td></tr>
<tr><td><code>passwordSetupUrl</code></td><td><code>String</code></td><td>private final</td><td>Url para que el cuidador defina su contraseña.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SendInvitationEmailCommand(Long invitationId, String inviteeEmail, String passwordSetupUrl)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>SendInvitationNotificationCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Communication envía la notificación en la app (cuenta existente).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><td><code>caregiverUserId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta de IAM asignada al cuidador. Nula hasta que IAM la asigna.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>SendInvitationNotificationCommand(Long invitationId, Long caregiverUserId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AcceptInvitationCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Acepta la invitación (reglas de <code>Invitation.accept</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><td><code>caregiverUserId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta de IAM asignada al cuidador. Nula hasta que IAM la asigna.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AcceptInvitationCommand(Long invitationId, Long caregiverUserId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RevokeInvitationCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Revoca una invitación <code>PENDING</code> del familiar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que la registra.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RevokeInvitationCommand(Long invitationId, Long relativeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ResendInvitationCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Reenvía una invitación <code>PENDING</code>, vigente o vencida, con nueva vigencia.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>invitationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la invitación.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que la registra.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ResendInvitationCommand(Long invitationId, Long relativeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CreateCaregiverCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea el acceso del cuidador. No existe otro <code>ACTIVE</code> de ese usuario para esa persona (<code>CaregiverAlreadyExists</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><td><code>caregiverUserId</code></td><td><code>Long</code></td><td>private final</td><td>Cuenta de IAM asignada al cuidador. Nula hasta que IAM la asigna.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateCaregiverCommand(Long assistedPersonId, Long caregiverUserId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RevokeCaregiverAccessCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Revoca el acceso de un cuidador de una persona del familiar.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>caregiverId</code></td><td><code>Long</code></td><td>private final</td><td>Cuidador responsable (nulo: el familiar).</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que la registra.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RevokeCaregiverAccessCommand(Long caregiverId, Long relativeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActivateCareActivityCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Activa una actividad.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que la registra.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActivateCareActivityCommand(Long careActivityId, Long relativeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeactivateCareActivityCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Desactiva una actividad.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que la registra.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeactivateCareActivityCommand(Long careActivityId, Long relativeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActivateActivityAssignmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Activa una asignación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad.</td></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Asignación registrada. Se guarda por id porque es entidad interna de <code>CareActivity</code>.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que la registra.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActivateActivityAssignmentCommand(Long careActivityId, Long assignmentId, Long relativeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeactivateActivityAssignmentCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Desactiva una asignación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad.</td></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Asignación registrada. Se guarda por id porque es entidad interna de <code>CareActivity</code>.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que la registra.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeactivateActivityAssignmentCommand(Long careActivityId, Long assignmentId, Long relativeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ReassignCaregiverActivitiesCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Pasa al familiar las asignaciones del cuidador revocado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>caregiverId</code></td><td><code>Long</code></td><td>private final</td><td>Cuidador responsable (nulo: el familiar).</td></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ReassignCaregiverActivitiesCommand(Long caregiverId, Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CancelActivityOccurrenceCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">El familiar cancela una ocurrencia que aún no terminó, incluso futura; las pasadas no (<code>OccurrenceEnded</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>careActivityId</code></td><td><code>Long</code></td><td>private final</td><td>Actividad.</td></tr>
<tr><td><code>assignmentId</code></td><td><code>Long</code></td><td>private final</td><td>Asignación registrada. Se guarda por id porque es entidad interna de <code>CareActivity</code>.</td></tr>
<tr><td><code>date</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha en que empieza la ocurrencia.</td></tr>
<tr><td><code>relativeId</code></td><td><code>Long</code></td><td>private final</td><td>Familiar que la registra.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CancelActivityOccurrenceCommand(Long careActivityId, Long assignmentId, LocalDate date, Long relativeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>MarkMissedActivitiesCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Lo dispara un proceso programado cada día. Crea un log <code>MISSED</code> por cada ocurrencia <code>ACTIVE</code> sin log cuya fecha de cierre es <code>closingDate</code> (<code>DayNotClosedYet</code> si aún no terminó). Es idempotente.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>closingDate</code></td><td><code>LocalDate</code></td><td>private final</td><td>Día que se cierra: sus ocurrencias sin log pasan a <code>MISSED</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>MarkMissedActivitiesCommand(LocalDate closingDate)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

#### Queries

Las queries solo llevan el id por el que se busca y, en agenda e historial, el rango de fechas. No validan pertenencia: esa validación se hace antes, desde el usuario que inició sesión.

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
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Relative&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetRelativeByUserIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Familiar del usuario que inició sesión.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetRelativeByUserIdQuery(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Relative&gt;</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Relative&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAssistedPersonByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Persona asistida por id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAssistedPersonByIdQuery(Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;AssistedPerson&gt;</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;AssistedPerson&gt;</code></td></tr>
</table>

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
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Invitation&gt;</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Invitation&gt;</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Invitation&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetCaregiversByAssistedPersonIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Cuidadores de una persona.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetCaregiversByAssistedPersonIdQuery(Long assistedPersonId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Caregiver&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetCaregiversByUserIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Accesos de cuidador <code>ACTIVE</code> del usuario que inició sesión.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>userId</code></td><td><code>Long</code></td><td>private final</td><td>Su cuenta corporativa en IAM.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetCaregiversByUserIdQuery(Long userId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Caregiver&gt;</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;CareActivity&gt;</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;CareActivity&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAgendaByAssistedPersonIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Agenda completa de la persona (familiar y cuidadores).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><td><code>from</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha inicial del rango consultado.</td></tr>
<tr><td><code>to</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha final del rango consultado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAgendaByAssistedPersonIdQuery(Long assistedPersonId, LocalDate from, LocalDate to)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;AgendaItem&gt;</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;AgendaItem&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetActivityLogsByAssistedPersonIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Historial completo de la persona.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>assistedPersonId</code></td><td><code>Long</code></td><td>private final</td><td>Persona asistida.</td></tr>
<tr><td><code>from</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha inicial del rango consultado.</td></tr>
<tr><td><code>to</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha final del rango consultado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetActivityLogsByAssistedPersonIdQuery(Long assistedPersonId, LocalDate from, LocalDate to)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;ActivityLog&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetActivityLogsByCaregiverIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Historial propio de un cuidador.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>caregiverId</code></td><td><code>Long</code></td><td>private final</td><td>Cuidador responsable (nulo: el familiar).</td></tr>
<tr><td><code>from</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha inicial del rango consultado.</td></tr>
<tr><td><code>to</code></td><td><code>LocalDate</code></td><td>private final</td><td>Fecha final del rango consultado.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetActivityLogsByCaregiverIdQuery(Long caregiverId, LocalDate from, LocalDate to)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;ActivityLog&gt;</code></td></tr>
</table>

#### Domain Services

Todos los métodos son `public` (interfaces). Los command services devuelven el id del aggregate afectado (`Long`), o `void` cuando no hay aggregate que devolver.

Las reglas que cruzan varios aggregates se validan en el service y no en un aggregate: `ScheduleConflict` (compara con asignaciones de otras actividades), `ScheduleNotEditable` y `OccurrenceClosed` (consultan los logs existentes).

<table>
<tr><th colspan="4" align="left"><code>RelativeCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Relative</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateRelativeCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateRelativeCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssistedPersonCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>AssistedPerson</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateAssistedPersonCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateAssistedPersonCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Invitation</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateInvitationCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateInvitationCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(RegisterCaregiverAccountCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>RegisterCaregiverAccountCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(SendInvitationEmailCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>SendInvitationEmailCommand</code>.</td></tr>
<tr><td><code>handle(SendInvitationNotificationCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>SendInvitationNotificationCommand</code>.</td></tr>
<tr><td><code>handle(AcceptInvitationCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>AcceptInvitationCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(RevokeInvitationCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>RevokeInvitationCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(ResendInvitationCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ResendInvitationCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CaregiverCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Caregiver</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateCaregiverCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateCaregiverCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(RevokeCaregiverAccessCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>RevokeCaregiverAccessCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CareActivityCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>CareActivity</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
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
</table>

<table>
<tr><th colspan="4" align="left"><code>ActivityLogCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>ActivityLog</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CompleteActivityCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CompleteActivityCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(CancelActivityOccurrenceCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CancelActivityOccurrenceCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(MarkMissedActivitiesCommand command)</code></td><td><code>void</code></td><td>public</td><td>Ejecuta <code>MarkMissedActivitiesCommand</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RelativeQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Relative</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
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
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetAssistedPersonsByRelativeIdQuery query)</code></td><td><code>List&lt;AssistedPerson&gt;</code></td><td>public</td><td>Resuelve <code>GetAssistedPersonsByRelativeIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetAssistedPersonByIdQuery query)</code></td><td><code>Optional&lt;AssistedPerson&gt;</code></td><td>public</td><td>Resuelve <code>GetAssistedPersonByIdQuery</code>; devuelve vacío si no existe.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Invitation</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetInvitationByIdQuery query)</code></td><td><code>Optional&lt;Invitation&gt;</code></td><td>public</td><td>Resuelve <code>GetInvitationByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetInvitationsByAssistedPersonIdQuery query)</code></td><td><code>List&lt;Invitation&gt;</code></td><td>public</td><td>Resuelve <code>GetInvitationsByAssistedPersonIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetPendingInvitationsByCaregiverUserIdQuery query)</code></td><td><code>List&lt;Invitation&gt;</code></td><td>public</td><td>Resuelve <code>GetPendingInvitationsByCaregiverUserIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CaregiverQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Caregiver</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetCaregiversByAssistedPersonIdQuery query)</code></td><td><code>List&lt;Caregiver&gt;</code></td><td>public</td><td>Resuelve <code>GetCaregiversByAssistedPersonIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetCaregiversByUserIdQuery query)</code></td><td><code>List&lt;Caregiver&gt;</code></td><td>public</td><td>Resuelve <code>GetCaregiversByUserIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CareActivityQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>CareActivity</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
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
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetActivityLogsByAssistedPersonIdQuery query)</code></td><td><code>List&lt;ActivityLog&gt;</code></td><td>public</td><td>Resuelve <code>GetActivityLogsByAssistedPersonIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetActivityLogsByCaregiverIdQuery query)</code></td><td><code>List&lt;ActivityLog&gt;</code></td><td>public</td><td>Resuelve <code>GetActivityLogsByCaregiverIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
</table>

#### Exceptions

Cada excepción tiene un constructor `public` sin parámetros.

<table>
<tr><th colspan="4" align="left"><code>RelativeNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe el familiar indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RelativeNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssistedPersonNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe la persona asistida indicada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssistedPersonNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssistedPersonNotManagedByRelative</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la persona asistida no pertenece al familiar que opera.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssistedPersonNotManagedByRelative()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el negocio indicado no existe en Company.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DniAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el DNI ya está registrado entre los clientes.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DniAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EmailAddressAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el email ya está registrado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EmailAddressAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe la invitación indicada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationNotPending</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la invitación ya fue aceptada o revocada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationNotPending()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationExpired</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta aceptar una invitación vencida.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationExpired()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationNotForUser</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando quien acepta no es el usuario asignado a la invitación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationNotForUser()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvitationAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando ya hay una invitación <code>PENDING</code> al mismo email para esa persona.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvitationAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CaregiverAccountNotAssigned</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta aceptar antes de que IAM asigne la cuenta.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CaregiverAccountNotAssigned()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CaregiverNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe el cuidador, o no cuida a esa persona.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CaregiverNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CaregiverAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando ese usuario ya es cuidador <code>ACTIVE</code> de esa persona.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CaregiverAlreadyExists()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CaregiverNotActive</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el cuidador fue revocado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CaregiverNotActive()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CaregiverAlreadyRevoked</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta revocar un acceso ya revocado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CaregiverAlreadyRevoked()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CareActivityNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe la actividad indicada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CareActivityNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>CareActivityNotActive</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la actividad está <code>INACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CareActivityNotActive()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActivityAssignmentNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la asignación no existe dentro de la actividad.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActivityAssignmentNotFound()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ActivityAssignmentNotActive</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la asignación está <code>INACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ActivityAssignmentNotActive()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidSchedule</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el horario no tiene la forma correcta o un <code>ONE_TIME</code> está en el pasado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidSchedule()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ScheduleConflict</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el horario choca con otra asignación <code>ACTIVE</code> del mismo cuidador.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ScheduleConflict()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ScheduleNotEditable</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta editar un <code>ONE_TIME</code> que ya tiene log.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ScheduleNotEditable()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>OccurrenceNotScheduled</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la asignación no tiene ocurrencia en esa fecha.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>OccurrenceNotScheduled()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>OccurrenceNotStarted</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta completar antes del inicio del horario.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>OccurrenceNotStarted()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>OccurrenceEnded</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta completar o cancelar una ocurrencia que ya terminó.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>OccurrenceEnded()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>OccurrenceClosed</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la ocurrencia ya tiene log (completada, cancelada o perdida).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>OccurrenceClosed()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>NotResponsibleForActivity</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando quien completa no es el responsable de la asignación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>NotResponsibleForActivity()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DayNotClosedYet</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta marcar como perdida una ocurrencia cuyo día aún no terminó.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DayNotClosedYet()</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

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

El diagrama muestra los seis aggregates, la entidad `ActivityAssignment`, los value objects y enums con sus relaciones nombradas y su multiplicidad. Las referencias directas entre aggregates del mismo contexto se dibujan en morado; la composición `CareActivity` → `ActivityAssignments` → `ActivityAssignment` en magenta. Las flechas naranjas indican el aggregate que crea o modifica cada command, y las verde azuladas, el flujo de eventos internos: el aggregate registra el evento y el evento activa el siguiente command (por ejemplo, la invitación: crear, asignar cuenta, avisar, aceptar y crear el cuidador). Los atributos de cada command se muestran dentro de su clase; las notas detallan las reglas de los commands y de cada service.

![Diagrama de clases de la capa de dominio - Asistencia Médica](../images/diagrams/img/chapter-5/assistance.svg)

#### 5.5.7.2. Bounded Context Database Design Diagram

`ActivityLog` se guarda en PostgreSQL y no en MongoDB: completar o cancelar lee la actividad, la asignación y el cuidador y escribe el log en una misma transacción, y varias reglas cruzan logs con asignaciones. Es un registro de negocio con relaciones, no tracking.

| Tabla | Aggregate o entidad | Llaves y restricciones |
|---|---|---|
| `relatives` | `Relative` | PK `id`. UK `user_id` y UK `person_profile_id` (sin FK, otros contextos). Índice `business_id`. |
| `assisted_persons` | `AssistedPerson` | PK `id`. UK `person_profile_id`. FK `relative_id`. Sin columna de estado: no se da de baja. |
| `invitations` | `Invitation` | PK `id`. FK `assisted_person_id`, `inviter_relative_id`. Índice único parcial (`assisted_person_id`, `invitee_email`) donde `status = 'PENDING'`. |
| `caregivers` | `Caregiver` | PK `id`. FK `assisted_person_id`. Índice único parcial (`user_id`, `assisted_person_id`) donde `status = 'ACTIVE'`. |
| `care_activities` | `CareActivity` | PK `id`. FK `assisted_person_id`. |
| `activity_assignments` | `ActivityAssignment` (con `Schedule` aplanado) | PK `id`. FK `care_activity_id`. FK `caregiver_id` (nula: la hace el familiar). |
| `activity_logs` | `ActivityLog` | PK `id`. FK `assisted_person_id`, `care_activity_id`, `assignment_id`, `assigned_caregiver_id`, `completed_by_caregiver_id`. UK (`assignment_id`, `occurrence_date`). |

Relaciones: un familiar tiene varias personas asistidas e invitaciones; una persona asistida tiene varias invitaciones, cuidadores, actividades y logs; una actividad tiene varias asignaciones y logs; un cuidador puede tener varias asignaciones y logs.

![Diagrama de base de datos - Asistencia Médica](../images/diagrams/img/chapter-5/assistance-database.svg)

<div style="page-break-after: always;"></div>

## 5.6. Bounded Context: Pagos y Suscripciones

En el código, este bounded context es el paquete `subscriptions`. Gestiona los planes, el pago mediante Stripe y la suscripción que paga el familiar.

### 5.6.1. Domain Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.6.2. Interface Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.6.3. Application Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.6.4. Infrastructure Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.6.6. Bounded Context Software Architecture Component Level Diagrams

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.6.7. Bounded Context Software Architecture Code Level Diagrams

#### 5.6.7.1. Bounded Context Domain Layer Class Diagrams

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

#### 5.6.7.2. Bounded Context Database Design Diagram

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

<div style="page-break-after: always;"></div>

## 5.7. Bounded Context: Soporte Técnico

En el código, este bounded context es el paquete `support`. Gestiona la evaluación técnica de la vivienda, la instalación de los dispositivos y la atención de incidencias.

### 5.7.1. Domain Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.7.2. Interface Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.7.3. Application Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.7.4. Infrastructure Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.7.6. Bounded Context Software Architecture Component Level Diagrams

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.7.7. Bounded Context Software Architecture Code Level Diagrams

#### 5.7.7.1. Bounded Context Domain Layer Class Diagrams

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

#### 5.7.7.2. Bounded Context Database Design Diagram

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

<div style="page-break-after: always;"></div>

## 5.8. Bounded Context: Comunicaciones

En el código, este bounded context es el paquete `communication`. Envía los correos y las notificaciones de la plataforma. Aquí se trasladará la enumeración `EmailTemplate` de Shared.

### 5.8.1. Domain Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.8.2. Interface Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.8.3. Application Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.8.4. Infrastructure Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.8.6. Bounded Context Software Architecture Component Level Diagrams

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.8.7. Bounded Context Software Architecture Code Level Diagrams

#### 5.8.7.1. Bounded Context Domain Layer Class Diagrams

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

#### 5.8.7.2. Bounded Context Database Design Diagram

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

<div style="page-break-after: always;"></div>

## 5.9. Bounded Context: Analíticas

En el código, este bounded context es el paquete `analytics`. Calcula las métricas globales, de ventas y de rendimiento de los dispositivos.

### 5.9.1. Domain Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.9.2. Interface Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.9.3. Application Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.9.4. Infrastructure Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.9.6. Bounded Context Software Architecture Component Level Diagrams

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.9.7. Bounded Context Software Architecture Code Level Diagrams

#### 5.9.7.1. Bounded Context Domain Layer Class Diagrams

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

#### 5.9.7.2. Bounded Context Database Design Diagram

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

<div style="page-break-after: always;"></div>

## 5.10. Bounded Context: Telemetría

En el código, este bounded context es el paquete `tracking`. Monitorea el estado de los dispositivos instalados. Sus datos se guardan en MongoDB.

### 5.10.1. Domain Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.10.2. Interface Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.10.3. Application Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.10.4. Infrastructure Layer

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.10.6. Bounded Context Software Architecture Component Level Diagrams

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

### 5.10.7. Bounded Context Software Architecture Code Level Diagrams

#### 5.10.7.1. Bounded Context Domain Layer Class Diagrams

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

#### 5.10.7.2. Bounded Context Database Design Diagram

Pendiente. Se documenta cuando se diseñe el Domain Layer de este bounded context.

<div style="page-break-after: always;"></div>

## 5.11. Bounded Context: Bienes

En el código, este bounded context es el paquete `assets`. Assets gestiona los equipos físicos del hogar y la red que forman en cada instalación. Lleva el inventario de edges y dispositivos de cada negocio (sin límite de registros) y, cuando Soporte Técnico termina una instalación, enlaza los equipos asignados en una red: un edge de micrófono, un edge de actuadores, un micrófono y los actuadores que Soporte Técnico decidió instalar. A partir de esa red calcula la tabla de accesos de cada edge (quién le puede enviar y a quién puede enviar) y se la envía por eventos cada vez que la red cambia. IAM solo autentica al edge cuando llama a la API, y Telemetría guarda las acciones y estados que reportan los edges; Assets no los guarda. Con otros contextos se relaciona solo por `BusinessId` e `InstallationId`.

### 5.11.1. Domain Layer

Este bounded context no declara Entities propios.

#### Aggregates

<table>
<tr><th colspan="4" align="left"><code>Asset</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Clase abstracta base (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Lo común a todo equipo: MAC, negocio y estado con sus transiciones. No es un aggregate propio: no tiene repositorio ni services.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>BusinessId</code></td><td>private</td><td>Negocio dueño del equipo.</td></tr>
<tr><td><code>macAddress</code></td><td><code>MacAddress</code></td><td>private</td><td>MAC del equipo. No se repite entre edges y devices.</td></tr>
<tr><td><code>status</code></td><td><code>AssetStatus</code></td><td>private</td><td><code>AVAILABLE</code>, <code>IN_USE</code>, <code>MAINTENANCE</code> o <code>BROKEN</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>Asset(BusinessId businessId, MacAddress macAddress)</code></td><td>(constructor)</td><td>protected</td><td>Inicializa el equipo en estado <code>AVAILABLE</code> (en almacén).</td></tr>
<tr><td><code>belongsTo(BusinessId businessId)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si es del negocio indicado.</td></tr>
<tr><td><code>isAvailable()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si está <code>AVAILABLE</code>.</td></tr>
<tr><td><code>markInUse()</code></td><td><code>void</code></td><td>public</td><td>De <code>AVAILABLE</code> a <code>IN_USE</code>: se asignó a una red.</td></tr>
<tr><td><code>release()</code></td><td><code>void</code></td><td>public</td><td>De <code>IN_USE</code> a <code>AVAILABLE</code>: salió de una red.</td></tr>
<tr><td><code>sendToMaintenance()</code></td><td><code>void</code></td><td>public</td><td>De <code>AVAILABLE</code> o <code>IN_USE</code> a <code>MAINTENANCE</code>. Si estaba <code>IN_USE</code>, registra <code>AssetStatusChangedEvent</code>.</td></tr>
<tr><td><code>markBroken()</code></td><td><code>void</code></td><td>public</td><td>De <code>AVAILABLE</code>, <code>IN_USE</code> o <code>MAINTENANCE</code> a <code>BROKEN</code>. Si estaba <code>IN_USE</code>, registra <code>AssetStatusChangedEvent</code>.</td></tr>
<tr><td><code>markRepaired()</code></td><td><code>void</code></td><td>public</td><td>De <code>MAINTENANCE</code> o <code>BROKEN</code> a <code>AVAILABLE</code>.</td></tr>
<tr><td><code>correctMacAddress(MacAddress macAddress)</code></td><td><code>void</code></td><td>protected</td><td>Corrige la MAC; solo si está <code>AVAILABLE</code> (<code>AssetNotEditable</code>).</td></tr>
<tr><td><code>nodeType()</code></td><td><code>NodeType</code></td><td>protected</td><td>Tipo de nodo del equipo en la tabla de accesos; lo define cada subclase.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Una transición no permitida lanza <code>InvalidAssetStatusTransition</code>. <code>IN_USE</code> y la vuelta a <code>AVAILABLE</code> por salir de una red solo las pone la red, mediante sus eventos. Un equipo instalado que falla solo cambia cuando Soporte Técnico lo revisa y lo pasa a <code>MAINTENANCE</code> o <code>BROKEN</code>; recién ahí la red lo retira.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Generalización</td><td><code>Edge</code>, <code>Device</code></td><td>1 base, 2 subclases</td><td>Cada equipo concreto extiende <code>Asset</code>.</td></tr>
<tr><td>Composición (<code>macAddress</code>)</td><td><code>MacAddress</code></td><td>1 a 1</td><td>MAC del equipo.</td></tr>
<tr><td>Asociación (<code>status</code>)</td><td><code>AssetStatus</code></td><td>0..* a 1</td><td>Estado del equipo.</td></tr>
<tr><td>Dependencia "registra"</td><td><code>AssetStatusChangedEvent</code></td><td>No aplica</td><td>Salida de <code>IN_USE</code> por mantenimiento o falla.</td></tr>
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
<tr><td><b>Reglas</b></td><td colspan="3">El inventario no tiene límite; un negocio registra todos los edges de ambos tipos que necesite.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Generalización</td><td><code>Asset</code></td><td>1 a 1</td><td>Hereda MAC, negocio y estado.</td></tr>
<tr><td>Asociación (<code>type</code>)</td><td><code>EdgeType</code></td><td>0..* a 1</td><td>Tipo de edge.</td></tr>
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
<tr><td><code>update(MacAddress macAddress, DeviceType type)</code></td><td><code>void</code></td><td>public</td><td>Corrige la MAC o el tipo mal registrados desde el frontend; solo si está <code>AVAILABLE</code> (<code>AssetNotEditable</code>).</td></tr>
<tr><td><code>nodeType()</code></td><td><code>NodeType</code></td><td>protected</td><td><code>MICROPHONE</code> o <code>ACTUATOR</code>, según su tipo.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">El inventario no tiene límite; puede haber varios micrófonos y actuadores registrados aunque cada red use un solo micrófono.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Generalización</td><td><code>Asset</code></td><td>1 a 1</td><td>Hereda MAC, negocio y estado.</td></tr>
<tr><td>Asociación (<code>type</code>)</td><td><code>DeviceType</code></td><td>0..* a 1</td><td>Tipo de dispositivo.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceNetwork</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Aggregate Root (extiende <code>AuditableAbstractAggregateRoot</code>)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">La red de dispositivos de una instalación. Enlaza los equipos asignados por Soporte Técnico y calcula la tabla de accesos de cada edge. Solo lee a <code>Edge</code> y <code>Device</code>; nunca los modifica.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>InstallationId</code></td><td>private</td><td>Instalación de Soporte Técnico donde se monta la red.</td></tr>
<tr><td><code>businessId</code></td><td><code>BusinessId</code></td><td>private</td><td>Negocio dueño de los equipos.</td></tr>
<tr><td><code>status</code></td><td><code>NetworkStatus</code></td><td>private</td><td><code>ACTIVE</code> o <code>DEACTIVATED</code>.</td></tr>
<tr><td><code>microphoneEdge</code></td><td><code>Edge</code></td><td>private</td><td>Edge del micrófono. Vacío mientras uno retirado no se reemplaza.</td></tr>
<tr><td><code>actuatorEdge</code></td><td><code>Edge</code></td><td>private</td><td>Edge de los actuadores. Vacío mientras uno retirado no se reemplaza.</td></tr>
<tr><td><code>microphone</code></td><td><code>Device</code></td><td>private</td><td>Micrófono asignado. Vacío mientras uno retirado no se reemplaza.</td></tr>
<tr><td><code>actuators</code></td><td><code>List&lt;Device&gt;</code></td><td>private</td><td>Actuadores asignados al edge de actuadores.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceNetwork(InstallationId installationId, BusinessId businessId, Edge microphoneEdge, Edge actuatorEdge, Device microphone, List&lt;Device&gt; actuators)</code></td><td>(constructor)</td><td>public</td><td>Crea la red <code>ACTIVE</code> con los equipos de la instalación. Cada equipo es del tipo de su campo (<code>InvalidNetworkMember</code>), del mismo negocio (<code>AssetNotInBusiness</code>) y está <code>AVAILABLE</code> (<code>AssetNotAvailable</code>). Registra <code>AssetAssignedToNetworkEvent</code> por equipo y <code>AccessTableUpdatedEvent</code>.</td></tr>
<tr><td><code>addEdge(Edge edge)</code></td><td><code>void</code></td><td>public</td><td>Asigna un edge al campo de su tipo si está vacío (<code>NodeTypeAlreadyInNetwork</code>).</td></tr>
<tr><td><code>addDevice(Device device)</code></td><td><code>void</code></td><td>public</td><td>Asigna el micrófono si su campo está vacío (<code>NodeTypeAlreadyInNetwork</code>) o suma un actuador que no esté ya (<code>AssetAlreadyInNetwork</code>).</td></tr>
<tr><td><code>removeEdge(Long edgeId)</code></td><td><code>void</code></td><td>public</td><td>Retira un edge de la red (<code>AssetNotInNetwork</code>); su campo queda vacío.</td></tr>
<tr><td><code>removeDevice(Long deviceId)</code></td><td><code>void</code></td><td>public</td><td>Retira el micrófono o un actuador de la red (<code>AssetNotInNetwork</code>).</td></tr>
<tr><td><code>deactivate()</code></td><td><code>void</code></td><td>public</td><td>De <code>ACTIVE</code> a <code>DEACTIVATED</code> (desinstalación): retira todos los equipos.</td></tr>
<tr><td><code>containsEdge(Long edgeId)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el edge está asignado a la red.</td></tr>
<tr><td><code>containsDevice(Long deviceId)</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el dispositivo está asignado a la red.</td></tr>
<tr><td><code>edgeIds()</code></td><td><code>List&lt;Long&gt;</code></td><td>public</td><td>Edges asignados; a ellos se les envía la tabla.</td></tr>
<tr><td><code>tableFor(Long edgeId)</code></td><td><code>EdgeAccessTable</code></td><td>public</td><td>Calcula la tabla de accesos del edge con los equipos asignados en ese momento.</td></tr>
<tr><td><code>isActive()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si la red está <code>ACTIVE</code>.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">La asignación es 1 edge de micrófono, 1 edge de actuadores, 1 micrófono y N actuadores; el número de actuadores lo decide Soporte Técnico. Todo equipo nuevo es del mismo negocio y está <code>AVAILABLE</code>. Ningún método modifica una red <code>DEACTIVATED</code> (<code>DeviceNetworkDeactivated</code>). Cada alta registra <code>AssetAssignedToNetworkEvent</code>, cada baja <code>AssetRemovedFromNetworkEvent</code>, y toda alta o baja registra <code>AccessTableUpdatedEvent</code>. La tabla de accesos se calcula así: micrófono a <code>MICROPHONE_EDGE</code>, <code>MICROPHONE_EDGE</code> a <code>ACTUATOR_EDGE</code> (por el broker), <code>ACTUATOR_EDGE</code> a cada actuador y cada edge a <code>CLOUD</code>; un equipo retirado ya no aparece.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación dirigida (<code>microphoneEdge</code>)</td><td><code>Edge</code></td><td>0..1 a 0..1</td><td>Edge del micrófono asignado.</td></tr>
<tr><td>Asociación dirigida (<code>actuatorEdge</code>)</td><td><code>Edge</code></td><td>0..1 a 0..1</td><td>Edge de actuadores asignado.</td></tr>
<tr><td>Asociación dirigida (<code>microphone</code>)</td><td><code>Device</code></td><td>0..1 a 0..1</td><td>Micrófono asignado.</td></tr>
<tr><td>Asociación dirigida (<code>actuators</code>)</td><td><code>Device</code></td><td>0..1 a 0..*</td><td>Actuadores asignados.</td></tr>
<tr><td>Asociación (<code>status</code>)</td><td><code>NetworkStatus</code></td><td>0..* a 1</td><td>Estado de la red.</td></tr>
<tr><td>Dependencia "tableFor"</td><td><code>EdgeAccessTable</code></td><td>No aplica</td><td>Tabla calculada para un edge.</td></tr>
<tr><td>Dependencia "registra"</td><td>Eventos de la red</td><td>No aplica</td><td>Asignación, retiro y tabla actualizada.</td></tr>
</table>

#### Value Objects

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
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>NodeRef(NodeType type, Long assetId, MacAddress macAddress)</code></td><td>(constructor)</td><td>public</td><td>Crea el nodo; para tipos distintos de <code>CLOUD</code>, id y MAC son obligatorios.</td></tr>
<tr><td><code>of(Asset asset)</code></td><td><code>NodeRef</code></td><td>public static</td><td>Crea el nodo de un edge o dispositivo.</td></tr>
<tr><td><code>cloud()</code></td><td><code>NodeRef</code></td><td>public static</td><td>Crea el nodo de la nube.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Asociación (<code>type</code>)</td><td><code>NodeType</code></td><td>0..* a 1</td><td>Tipo de nodo.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EdgeAccessTable</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Value Object (record), modelo de lectura</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">La tabla que se envía a un edge. No se guarda: la calcula <code>DeviceNetwork.tableFor</code>. El edge reemplaza su copia local (SQLite) completa cada vez que recibe una.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Edge al que pertenece la tabla.</td></tr>
<tr><td><code>allowedSources</code></td><td><code>List&lt;NodeRef&gt;</code></td><td>private final</td><td>Quién le puede enviar: el micrófono o el otro edge.</td></tr>
<tr><td><code>allowedTargets</code></td><td><code>List&lt;NodeRef&gt;</code></td><td>private final</td><td>A quién puede enviar: el otro edge, los actuadores o <code>CLOUD</code>.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EdgeAccessTable(Long edgeId, List&lt;NodeRef&gt; allowedSources, List&lt;NodeRef&gt; allowedTargets)</code></td><td>(constructor)</td><td>public</td><td>Crea la tabla del edge.</td></tr>
<tr><td><code>canSendToCloud()</code></td><td><code>boolean</code></td><td>public</td><td>Indica si el edge puede enviar a la nube.</td></tr>
<tr><th colspan="4" align="left">Relaciones</th></tr>
<tr><th>Relación</th><th>Clase relacionada</th><th>Multiplicidad</th><th>Descripción</th></tr>
<tr><td>Composición (<code>allowedSources</code>, <code>allowedTargets</code>)</td><td><code>NodeRef</code></td><td>1 a 0..*</td><td>Nodos permitidos.</td></tr>
</table>

#### Enumerations

<table>
<tr><th colspan="4" align="left"><code>EdgeType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tipo de edge.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>MICROPHONE_EDGE</code>, <code>ACTUATOR_EDGE</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tipo de dispositivo: el micrófono o un actuador.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>MICROPHONE</code>, <code>DOOR</code>, <code>WINDOW</code>, <code>CURTAIN</code>, <code>LIGHT</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssetStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de un equipo. <code>IN_USE</code> significa asignado a una red.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>AVAILABLE</code>, <code>IN_USE</code>, <code>MAINTENANCE</code>, <code>BROKEN</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>NetworkStatus</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Estado de una red.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>ACTIVE</code>, <code>DEACTIVATED</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>NodeType</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Enumeration</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tipo de nodo en la tabla de accesos y en los eventos.</td></tr>
<tr><th colspan="4" align="left">Valores</th></tr>
<tr><td colspan="4"><code>MICROPHONE</code>, <code>ACTUATOR</code>, <code>MICROPHONE_EDGE</code>, <code>ACTUATOR_EDGE</code>, <code>CLOUD</code></td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><td colspan="4">No declara métodos propios.</td></tr>
</table>

#### Domain Events

<table>
<tr><th colspan="4" align="left"><code>AssetAssignedToNetworkEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que un equipo se asignó a una red.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>type</code></td><td><code>NodeType</code></td><td>private final</td><td>Tipo de actividad.</td></tr>
<tr><td><code>assetId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge o dispositivo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssetAssignedToNetworkEvent(NodeType type, Long assetId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>DeviceNetwork</code> al asignar un equipo</td></tr>
<tr><td><b>Activa</b></td><td colspan="3"><code>MarkEdgeInUseCommand</code> o <code>MarkDeviceInUseCommand</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssetRemovedFromNetworkEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que un equipo salió de una red.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>type</code></td><td><code>NodeType</code></td><td>private final</td><td>Tipo de actividad.</td></tr>
<tr><td><code>assetId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge o dispositivo.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssetRemovedFromNetworkEvent(NodeType type, Long assetId)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>DeviceNetwork</code> al retirar un equipo</td></tr>
<tr><td><b>Activa</b></td><td colspan="3"><code>ReleaseEdgeCommand</code> o <code>ReleaseDeviceCommand</code>, si el equipo sigue <code>IN_USE</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AccessTableUpdatedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que cambiaron los equipos de una red y que sus edges deben recibir su tabla de accesos actualizada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>network</code></td><td><code>DeviceNetwork</code></td><td>private</td><td>Red que originó el evento; su id se lee al publicarse.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AccessTableUpdatedEvent(DeviceNetwork network)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><code>getNetworkId()</code></td><td><code>Long</code></td><td>public</td><td>Devuelve <code>networkId</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><code>getEdgeIds()</code></td><td><code>List&lt;Long&gt;</code></td><td>public</td><td>Devuelve <code>edgeIds</code> del aggregate de origen; se lee al publicarse el evento, cuando ya tiene id.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>DeviceNetwork</code> en cada alta o baja</td></tr>
<tr><td><b>Activa</b></td><td colspan="3">Infrastructure calcula <code>tableFor</code> de cada edge de la red y se la envía. Lee el id al publicarse, porque una red nueva aún no lo tiene.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssetStatusChangedEvent</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Event</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Indica que un equipo instalado salió de <code>IN_USE</code> por mantenimiento o falla.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>type</code></td><td><code>NodeType</code></td><td>private final</td><td>Tipo de actividad.</td></tr>
<tr><td><code>assetId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge o dispositivo.</td></tr>
<tr><td><code>status</code></td><td><code>AssetStatus</code></td><td>private final</td><td>Estado de la invitación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssetStatusChangedEvent(NodeType type, Long assetId, AssetStatus status)</code></td><td>(constructor)</td><td>public</td><td>Crea el evento con los datos del aggregate que lo registra.</td></tr>
<tr><td><b>Lo registra</b></td><td colspan="3"><code>Asset</code> al salir de <code>IN_USE</code> por mantenimiento o falla</td></tr>
<tr><td><b>Activa</b></td><td colspan="3"><code>RemoveEdgeFromNetworkCommand</code> o <code>RemoveDeviceFromNetworkCommand</code>, si el equipo está en una red.</td></tr>
</table>

#### Commands

<table>
<tr><th colspan="4" align="left"><code>CreateDeviceNetworkCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Crea la red de una instalación con los equipos que asignó Soporte Técnico.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Instalación de Soporte Técnico.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Negocio dueño de los equipos.</td></tr>
<tr><td><code>microphoneEdgeId</code></td><td><code>Long</code></td><td>private final</td><td>Edge del micrófono.</td></tr>
<tr><td><code>actuatorEdgeId</code></td><td><code>Long</code></td><td>private final</td><td>Edge de los actuadores.</td></tr>
<tr><td><code>microphoneId</code></td><td><code>Long</code></td><td>private final</td><td>Micrófono asignado.</td></tr>
<tr><td><code>actuatorIds</code></td><td><code>List&lt;Long&gt;</code></td><td>private final</td><td>Actuadores que Soporte Técnico asignó al edge de actuadores.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>CreateDeviceNetworkCommand(Long installationId, Long businessId, Long microphoneEdgeId, Long actuatorEdgeId, Long microphoneId, List&lt;Long&gt; actuatorIds)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Reglas</b></td><td colspan="3">Lo envía Soporte Técnico al terminar la instalación. La instalación no tiene otra red <code>ACTIVE</code> (<code>DeviceNetworkAlreadyExists</code>). Los edges y dispositivos existen (<code>EdgeNotFound</code>, <code>DeviceNotFound</code>); el constructor de <code>DeviceNetwork</code> valida tipos, negocio y disponibilidad. Assets no limita el número de actuadores.</td></tr>
</table>

**Commands de inventario**

<table>
<tr><th colspan="4" align="left"><code>RegisterEdgeCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Registra un edge. La MAC es válida (<code>InvalidMacAddress</code>) y no existe en ningún edge ni dispositivo (<code>ExistsEdgeByMacAddressQuery</code>, <code>ExistsDeviceByMacAddressQuery</code>; <code>MacAddressAlreadyExists</code>). El negocio existe en Company (<code>BusinessNotFound</code>, vía ACL).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>macAddress</code></td><td><code>String</code></td><td>private final</td><td>MAC del equipo; se valida y normaliza con <code>MacAddress</code>.</td></tr>
<tr><td><code>type</code></td><td><code>EdgeType</code></td><td>private final</td><td>Tipo de actividad.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RegisterEdgeCommand(Long businessId, String macAddress, EdgeType type)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>RegisterDeviceCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Registra un dispositivo, con las mismas reglas de MAC y negocio.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>macAddress</code></td><td><code>String</code></td><td>private final</td><td>MAC del equipo; se valida y normaliza con <code>MacAddress</code>.</td></tr>
<tr><td><code>type</code></td><td><code>DeviceType</code></td><td>private final</td><td>Tipo de actividad.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RegisterDeviceCommand(Long businessId, String macAddress, DeviceType type)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
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
<tr><td><code>type</code></td><td><code>EdgeType</code></td><td>private final</td><td>Tipo de actividad.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateEdgeCommand(Long edgeId, Long businessId, String macAddress, EdgeType type)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
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
<tr><td><code>type</code></td><td><code>DeviceType</code></td><td>private final</td><td>Tipo de actividad.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>UpdateDeviceCommand(Long deviceId, Long businessId, String macAddress, DeviceType type)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ChangeEdgeStatusCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Lo usa Soporte Técnico al revisar una falla. Solo acepta <code>MAINTENANCE</code>, <code>BROKEN</code> o <code>AVAILABLE</code> (reparado); <code>IN_USE</code> lo pone la red (<code>InvalidAssetStatusTransition</code>).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>status</code></td><td><code>AssetStatus</code></td><td>private final</td><td>Estado de la invitación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ChangeEdgeStatusCommand(Long edgeId, Long businessId, AssetStatus status)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>ChangeDeviceStatusCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Igual que el anterior, para un dispositivo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>deviceId</code></td><td><code>Long</code></td><td>private final</td><td>Id del dispositivo.</td></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>status</code></td><td><code>AssetStatus</code></td><td>private final</td><td>Estado de la invitación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>ChangeDeviceStatusCommand(Long deviceId, Long businessId, AssetStatus status)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
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
</table>

**Commands de la red**

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
</table>

<table>
<tr><th colspan="4" align="left"><code>RemoveEdgeFromNetworkCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Retira un edge de la red. También llega por <code>AssetStatusChangedEvent</code>: application busca la red con <code>GetDeviceNetworkByEdgeIdQuery</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>networkId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la red.</td></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>RemoveEdgeFromNetworkCommand(Long networkId, Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
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
</table>

<table>
<tr><th colspan="4" align="left"><code>DeactivateDeviceNetworkCommand</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Command (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Desinstala la red: pasa a <code>DEACTIVATED</code> y sus equipos vuelven a <code>AVAILABLE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>networkId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la red.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeactivateDeviceNetworkCommand(Long networkId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
</table>

#### Queries

<table>
<tr><th colspan="4" align="left"><code>GetEdgeByIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Edge por id.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetEdgeByIdQuery(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Edge&gt;</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Edge&gt;</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>boolean</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;Device&gt;</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Device&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetAllDevicesByBusinessIdAndStatusQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Dispositivos de un negocio filtrados por estado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>businessId</code></td><td><code>Long</code></td><td>private final</td><td>Id del negocio.</td></tr>
<tr><td><code>status</code></td><td><code>AssetStatus</code></td><td>private final</td><td>Estado de la invitación.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetAllDevicesByBusinessIdAndStatusQuery(Long businessId, AssetStatus status)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>List&lt;Device&gt;</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>boolean</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;DeviceNetwork&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetDeviceNetworkByInstallationIdQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Red activa de una instalación.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>installationId</code></td><td><code>Long</code></td><td>private final</td><td>Id de la instalación de Soporte Técnico.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetDeviceNetworkByInstallationIdQuery(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;DeviceNetwork&gt;</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;DeviceNetwork&gt;</code></td></tr>
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
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;DeviceNetwork&gt;</code></td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>GetEdgeAccessTableQuery</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Query (record)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Tabla de accesos de un edge. La pide el edge al reconectarse si estuvo desconectado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><th>Nombre</th><th>Tipo de dato</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>edgeId</code></td><td><code>Long</code></td><td>private final</td><td>Id del edge.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>GetEdgeAccessTableQuery(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Constructor canónico del record: recibe todos sus componentes.</td></tr>
<tr><td><b>Resultado</b></td><td colspan="3"><code>Optional&lt;EdgeAccessTable&gt;</code></td></tr>
</table>

#### Domain Services

<table>
<tr><th colspan="4" align="left"><code>EdgeCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Edge</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(RegisterEdgeCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>RegisterEdgeCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(UpdateEdgeCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>UpdateEdgeCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(ChangeEdgeStatusCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ChangeEdgeStatusCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(MarkEdgeInUseCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>MarkEdgeInUseCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(ReleaseEdgeCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>ReleaseEdgeCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>EdgeQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>Edge</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetEdgeByIdQuery query)</code></td><td><code>Optional&lt;Edge&gt;</code></td><td>public</td><td>Resuelve <code>GetEdgeByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetAllEdgesByBusinessIdQuery query)</code></td><td><code>List&lt;Edge&gt;</code></td><td>public</td><td>Resuelve <code>GetAllEdgesByBusinessIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(ExistsEdgeByMacAddressQuery query)</code></td><td><code>boolean</code></td><td>public</td><td>Resuelve <code>ExistsEdgeByMacAddressQuery</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>Device</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
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
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(GetDeviceByIdQuery query)</code></td><td><code>Optional&lt;Device&gt;</code></td><td>public</td><td>Resuelve <code>GetDeviceByIdQuery</code>; devuelve vacío si no existe.</td></tr>
<tr><td><code>handle(GetAllDevicesByBusinessIdQuery query)</code></td><td><code>List&lt;Device&gt;</code></td><td>public</td><td>Resuelve <code>GetAllDevicesByBusinessIdQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(GetAllDevicesByBusinessIdAndStatusQuery query)</code></td><td><code>List&lt;Device&gt;</code></td><td>public</td><td>Resuelve <code>GetAllDevicesByBusinessIdAndStatusQuery</code>; devuelve una lista, vacía si no hay resultados.</td></tr>
<tr><td><code>handle(ExistsDeviceByMacAddressQuery query)</code></td><td><code>boolean</code></td><td>public</td><td>Resuelve <code>ExistsDeviceByMacAddressQuery</code>.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceNetworkCommandService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las operaciones de escritura (commands) sobre <code>DeviceNetwork</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>handle(CreateDeviceNetworkCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>CreateDeviceNetworkCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(AddEdgeToNetworkCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>AddEdgeToNetworkCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(AddDeviceToNetworkCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>AddDeviceToNetworkCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(RemoveEdgeFromNetworkCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>RemoveEdgeFromNetworkCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(RemoveDeviceFromNetworkCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>RemoveDeviceFromNetworkCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
<tr><td><code>handle(DeactivateDeviceNetworkCommand command)</code></td><td><code>Long</code></td><td>public</td><td>Ejecuta <code>DeactivateDeviceNetworkCommand</code> y devuelve el id del registro creado o modificado.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceNetworkQueryService</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Domain Service (interface)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Define las consultas (queries) sobre <code>DeviceNetwork</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
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
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe el edge indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>EdgeNotFound(Long edgeId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe el dispositivo indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceNotFound(Long deviceId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceNetworkNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando no existe la red indicada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceNetworkNotFound(Long networkId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidMacAddress</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la MAC no tiene seis pares hexadecimales separados por ":" o "-".</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidMacAddress(String macAddress)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>MacAddressAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la MAC ya la usa otro edge o dispositivo.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>MacAddressAlreadyExists(String macAddress)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>BusinessNotFound</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el negocio no existe en Company (validado vía ACL al registrar un equipo).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>BusinessNotFound(Long businessId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssetNotInBusiness</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el equipo no pertenece al negocio indicado.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssetNotInBusiness(Long assetId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidAssetStatusTransition</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el cambio de estado no está permitido (ej. poner <code>IN_USE</code> a mano).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidAssetStatusTransition(AssetStatus from, AssetStatus to)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssetNotAvailable</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se asigna a una red un equipo que no está <code>AVAILABLE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssetNotAvailable(Long assetId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssetNotEditable</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se corrige la MAC o el tipo de un equipo que no está <code>AVAILABLE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssetNotEditable(Long assetId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>InvalidNetworkMember</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el equipo no es del tipo que pide su lugar en la red (ej. un actuador como micrófono).</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>InvalidNetworkMember(Long assetId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>NodeTypeAlreadyInNetwork</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la red ya tiene un micrófono, un edge de micrófono o un edge de actuadores.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>NodeTypeAlreadyInNetwork(NodeType type)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssetAlreadyInNetwork</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando el actuador ya está en la red.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssetAlreadyInNetwork(Long assetId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>AssetNotInNetwork</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se retira de la red un equipo que no está asignado a ella.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>AssetNotInNetwork(Long assetId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceNetworkAlreadyExists</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando la instalación ya tiene una red <code>ACTIVE</code>.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceNetworkAlreadyExists(Long installationId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
</table>

<table>
<tr><th colspan="4" align="left"><code>DeviceNetworkDeactivated</code></th></tr>
<tr><td><b>Categoría</b></td><td colspan="3">Exception (domain.exceptions)</td></tr>
<tr><td><b>Propósito</b></td><td colspan="3">Se lanza cuando se intenta modificar una red desactivada.</td></tr>
<tr><th colspan="4" align="left">Atributos</th></tr>
<tr><td colspan="4">No tiene atributos.</td></tr>
<tr><th colspan="4" align="left">Métodos</th></tr>
<tr><th>Firma</th><th>Tipo de retorno</th><th>Visibilidad</th><th>Descripción</th></tr>
<tr><td><code>DeviceNetworkDeactivated(Long networkId)</code></td><td>(constructor)</td><td>public</td><td>Crea la excepción con su mensaje.</td></tr>
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

El diagrama muestra la base abstracta `Asset` con sus dos aggregates (`Edge` y `Device`), relacionados por generalización, y el aggregate `DeviceNetwork`, que referencia directamente a sus edges, a su micrófono (0..1 cada uno) y a sus actuadores (0..*). `DeviceNetwork` calcula `EdgeAccessTable`, formada por `NodeRef`. Las flechas de eventos muestran qué aggregate registra cada evento y qué command activa. Los services reciben sus commands y queries, y las notas detallan las reglas de cada service y los value objects de Shared que usa el contexto (`BusinessId` e `InstallationId`).

![Diagrama de clases de la capa de dominio - Bienes](../images/diagrams/img/chapter-5/devices-backend-diagram.svg)

#### 5.11.7.2. Bounded Context Database Design Diagram

La base de datos es PostgreSQL. Las acciones y estados que envían los edges los guarda Telemetría en MongoDB, no Assets.

| Tabla | Aggregate o value object | Llaves y restricciones |
|---|---|---|
| `edges` | `Edge` | PK `id`. UK `mac_address`. Índice `business_id` (referencia a Company, sin FK). |
| `devices` | `Device` | PK `id`. UK `mac_address`. Índice `business_id`. |
| `device_networks` | `DeviceNetwork` | PK `id`. FK `microphone_edge_id` y `actuator_edge_id` hacia `edges`, y `microphone_id` hacia `devices`, cada una única y nula mientras el equipo no se reemplaza. UK parcial `installation_id` donde `status = 'ACTIVE'` (referencia a Soporte Técnico, sin FK). |
| `network_actuators` | Lista `actuators` de `DeviceNetwork` | FK `network_id` hacia `device_networks` y FK `device_id` hacia `devices`. UK `device_id`. Sin id propio. |

Relaciones: una red apunta a cero o un edge de cada tipo y a cero o un micrófono, y tiene cero o más actuadores. `edges` y `devices` no apuntan a ninguna tabla, así que no hay referencias circulares. La tabla de accesos no tiene tabla propia: `DeviceNetwork.tableFor` la calcula con estas columnas. Que la MAC no se repita entre `edges` y `devices` lo valida el dominio con las queries `Exists...ByMacAddressQuery`.

![Diagrama de base de datos - Bienes](../images/diagrams/img/chapter-5/devices-database-diagram.svg)

<div style="page-break-after: always;"></div>
