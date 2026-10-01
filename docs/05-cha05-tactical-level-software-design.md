# Capítulo 5: Tactical-Level Software Design

## 5.1. Bounded Context: IAM

El bounded context **IAM (Gestión de Identidad y Acceso)** gestiona el ciclo de vida de las cuentas de Alivia: el registro y la verificación de correo, la autenticación y el cierre de sesión, la recuperación de contraseña, y la asignación o el retiro de roles de acceso. Es un subdominio genérico que actúa como contexto de puerta de enlace (*gateway context*): toda otra interacción de la plataforma exige primero una cuenta activa y un rol vigente emitidos aquí. Participan como actores el **Administrador de la plataforma**, el **Cuidador** —incluyendo a quien se registra a partir de una invitación enviada desde el bounded context Cuidado— y el **Empleado** —técnico, instalador o personal de soporte dado de alta desde Capital Humano—. El aggregate `Account` materializa el concepto de «Cuenta» del lenguaje ubicuo, es decir, la identidad registrada en el sistema, mientras que «Usuario» designa a la persona que la posee.

### 5.1.1. Domain Layer

La Domain Layer de IAM concentra las reglas de identidad y acceso de Alivia. El aggregate `Account` es la única raíz del contexto y encapsula las entidades `Session` y `RoleAssignment`, junto con los value objects que garantizan la integridad de las credenciales y de los códigos de verificación.

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| Account | Aggregate Root | Representa la identidad registrada de un usuario de Alivia (Administrador, Cuidador o Empleado). No permite más de una cuenta activa por correo electrónico, no autentica mientras el estado sea distinto de `ACTIVE`, y no admite la asignación de roles incompatibles entre sí (US17). |

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| Session | Entity | Representa un periodo autenticado de uso activo emitido para un `Account`. Su vigencia no puede exceder los 30 minutos desde su emisión (QAS-10) y queda invalidada al cerrarse explícitamente o al expirar. |
| RoleAssignment | Entity | Representa un rol vigente otorgado a un `Account`. No permite roles duplicados ni combinaciones incompatibles según la política de negocio (US17, escenarios #2 y #5). |

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| AccountId | Value Object | Identificador tipado del aggregate `Account`; no admite valores nulos ni negativos. |
| SessionId | Value Object | Identificador tipado de una `Session`; se genera al emitirse un nuevo token de acceso. |
| Email | Value Object | Dirección de correo electrónico del titular de la cuenta; valida el formato y no admite valores vacíos o mal formados. |
| PhoneNumber | Value Object | Número de contacto del titular de la cuenta; valida el formato del número registrado en el flujo de registro (TS-01). |
| PasswordHash | Value Object | Representación de la contraseña ya derivada mediante una función de hash resistente a fuerza bruta (QAS-11); nunca almacena ni expone la contraseña en texto plano. |
| VerificationCode | Value Object | Código enviado por correo para verificar la identidad del titular; incluye su propósito (`VerificationPurpose`) y su vencimiento, y no puede validarse dos veces ni después de vencido (TS-01, escenario #4). |

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| AccountStatus | Enum | Estado del ciclo de vida de la cuenta. Transiciones permitidas: `PENDING_VERIFICATION` → `ACTIVE` al verificarse el correo; `ACTIVE` → `SUSPENDED` al revocarse el acceso (por ejemplo, ante el despido de un empleado en Capital Humano); `SUSPENDED` → `ACTIVE` al reactivarse manualmente. Ninguna transición permite autenticar fuera del estado `ACTIVE`. |
| Role | Enum | Rol de acceso otorgable a una cuenta: `RESPONSIBLE_CLIENT`, `ASSISTED_PERSON`, `PRINCIPAL_CAREGIVER`, `AUTHORIZED_CAREGIVER`, `TECHNICIAN`, `SUPPORT_STAFF`, `SUBSCRIPTION_MANAGER`, `BUSINESS_ADMIN`, `PLATFORM_ADMIN` (US17). Una misma cuenta puede mantener varios roles compatibles de forma simultánea; cada uno se otorga o se retira de forma independiente. |
| VerificationPurpose | Enum | Propósito de un `VerificationCode`: `EMAIL_VERIFICATION` (registro y reenvío), `PASSWORD_RECOVERY` (recuperación de contraseña) y `SECOND_FACTOR` (reservado como punto de extensión para una futura autenticación de dos pasos, observación previa #2; no se emite en el flujo de login actual, alineado con TS-03). |

No se declaran Factories ni Domain Services en este bounded context: la creación de `Account` es una operación de un único aggregate que no requiere colaboración con otros aggregates, y las reglas de compatibilidad de roles (US17) se validan directamente dentro de `Account` al invocar `AssignRoleCommand`.

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| RegisterAccountCommand | Registra una nueva cuenta en estado `PENDING_VERIFICATION` y dispara el envío del código de verificación de correo (TS-01). | name: String, email: String, phone: String, password: String, termsAccepted: Boolean, invitationId: String |
| VerifyEmailCommand | Activa la cuenta tras validar un código de verificación vigente (TS-01). | accountId: Long, code: String |
| ResendVerificationCodeCommand | Invalida el código de verificación anterior y emite uno nuevo, respetando el límite de frecuencia de reenvío (TS-02). | email: String |
| LoginCommand | Autentica las credenciales de la cuenta y emite una nueva `Session` (TS-03). | email: String, password: String |
| RefreshSessionCommand | Renueva la vigencia de una `Session` activa a partir de un refresh token válido (TS-03, escenario #4). | refreshToken: String |
| LogoutCommand | Cierra explícitamente una `Session` activa. | sessionId: Long |
| RequestPasswordRecoveryCommand | Emite un código de verificación con propósito `PASSWORD_RECOVERY` para la cuenta asociada al correo. | email: String |
| ResetPasswordCommand | Restablece la contraseña de la cuenta validando el código de recuperación vigente. | accountId: Long, code: String, newPassword: String |
| AssignRoleCommand | Otorga un rol adicional a la cuenta, validando su compatibilidad con los roles ya vigentes (US17). | accountId: Long, role: Role, grantedBy: Long |
| RevokeRoleCommand | Retira un rol previamente otorgado a la cuenta sin afectar los demás roles vigentes (US17, escenario #4). | accountId: Long, role: Role, revokedBy: Long |
| SuspendAccountCommand | Suspende la cuenta, impidiendo la autenticación hasta su reactivación. | accountId: Long, reason: String |
| ReactivateAccountCommand | Reactiva una cuenta previamente suspendida. | accountId: Long |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| GetAccountByIdQuery | Obtiene el detalle de una cuenta, incluyendo su estado y los roles vigentes asociados. | accountId: Long |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| AccountRegistered | Se publica al registrarse una nueva cuenta; es consumido por Perfiles para inicializar el perfil del usuario (Canvas IAM, observación previa #1). | accountId: Long, email: String, name: String, registeredAt: LocalDateTime |
| VerificationCodeIssued | Se publica al emitirse un código de verificación (registro, reenvío o recuperación de contraseña); lo consume `VerificationCodeIssuedEventHandler` para solicitar el envío del correo mediante Sendgrid. | accountId: Long, email: String, code: String, purpose: VerificationPurpose, expiresAt: LocalDateTime |
| AccountEmailVerified | Se publica al activarse la cuenta; es consumido por Comunicaciones para notificar la activación (Context Mapping: IAM como proveedor de Comunicaciones). | accountId: Long, verifiedAt: LocalDateTime |
| SessionStarted | Se publica al iniciarse o renovarse una `Session`. | sessionId: Long, accountId: Long, role: Role, issuedAt: LocalDateTime, expiresAt: LocalDateTime |
| SessionEnded | Se publica al cerrarse explícitamente una `Session`. | sessionId: Long, endedAt: LocalDateTime |
| PasswordReset | Se publica al restablecerse la contraseña; es consumido por Comunicaciones para notificar el cambio al titular. | accountId: Long, resetAt: LocalDateTime |
| RoleAssigned | Se publica al otorgarse un rol a la cuenta. | accountId: Long, role: Role, grantedAt: LocalDateTime |
| RoleRevoked | Se publica al retirarse un rol de la cuenta. | accountId: Long, role: Role, revokedAt: LocalDateTime |
| AccountSuspended | Se publica al suspenderse la cuenta; es consumido por Comunicaciones para notificar la suspensión al titular. | accountId: Long, reason: String, suspendedAt: LocalDateTime |
| AccountReactivated | Se publica al reactivarse la cuenta; es consumido por Comunicaciones para notificar la reactivación al titular. | accountId: Long, reactivatedAt: LocalDateTime |

| Nombre | Aggregate que gestiona | Descripción |
| --- | --- | --- |
| AccountRepository | Account | Persiste y recupera el aggregate `Account` junto con sus entidades internas `Session` y `RoleAssignment`; expone la búsqueda por `AccountId` y por `Email` para validar unicidad en el registro. |

| Clase origen | Relación | Clase destino | Descripción |
| --- | --- | --- | --- |
| Account | composición | Session | `Account` crea y gestiona el ciclo de vida de sus sesiones activas. |
| Account | composición | RoleAssignment | `Account` gestiona el conjunto de roles vigentes que le fueron otorgados. |
| Account | asociación | VerificationCode | `Account` emite y valida los códigos de verificación ligados a su identidad. |
| AccountRepository | depende de | Account | El repositorio persiste y recupera el aggregate `Account`. |

### 5.1.2. Interface Layer

La Interface Layer expone un único controller, `AccountController`, dado que `Session` y `RoleAssignment` son entidades internas del aggregate `Account` y se exponen como sub-recursos bajo su misma ruta. IAM no consume mensajería de dispositivos IoT, por lo que no declara consumers de broker; sus integraciones entrantes desde Capital Humano y Gestión del Negocio se resuelven mediante Event Handlers en la Application Layer (ver 5.1.3). Al ser un contexto de puerta de enlace, IAM expone además el facade `IamFacade` para que otros bounded contexts validen tokens sin acceder directamente al aggregate, conforme al patrón Shared Kernel documentado en el Context Mapping (4.2.5).

| Propiedad | Valor |
| --- | --- |
| Nombre | AccountController |
| Categoría | Controller |
| Propósito | Exponer el registro, la autenticación, la recuperación de acceso y la gestión de roles de las cuentas de Alivia. |
| Aggregate/Entity relacionado | Account (incluye los sub-recursos Session y RoleAssignment) |
| Ruta base | /api/v1/accounts (gestión) y /api/v1/auth (autenticación, conforme a TS-01/TS-02/TS-03) |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| registerAccount | /api/v1/auth/register (POST) | body: RegisterAccountResource { name: String, email: String, phone: String, password: String, termsAccepted: Boolean, invitationId: String } | Registra una nueva cuenta en estado PENDING_VERIFICATION | RegisterAccountCommand |
| verifyEmail | /api/v1/auth/verify-email (POST) | body: VerifyEmailResource { accountId: Long, code: String } | Activa la cuenta tras validar el código de verificación | VerifyEmailCommand |
| resendVerificationCode | /api/v1/auth/resend-verification (POST) | body: ResendVerificationResource { email: String } | Reenvía el código de verificación de correo | ResendVerificationCodeCommand |
| login | /api/v1/auth/login (POST) | body: LoginResource { email: String, password: String } | Autentica la cuenta y emite los tokens de acceso | LoginCommand |
| refreshSession | /api/v1/auth/refresh (POST) | body: RefreshSessionResource { refreshToken: String } | Renueva el par de tokens de una sesión vigente | RefreshSessionCommand |
| logout | /api/v1/auth/logout (POST) | body: LogoutResource { sessionId: Long } | Cierra la sesión activa de la cuenta | LogoutCommand |
| requestPasswordRecovery | /api/v1/auth/password-recovery (POST) | body: RequestPasswordRecoveryResource { email: String } | Solicita el restablecimiento de contraseña | RequestPasswordRecoveryCommand |
| resetPassword | /api/v1/auth/password-reset (POST) | body: ResetPasswordResource { accountId: Long, code: String, newPassword: String } | Restablece la contraseña usando el código vigente | ResetPasswordCommand |
| getAccountById | /{accountId} (GET) | path: accountId: Long | Obtiene el detalle de una cuenta y sus roles vigentes | GetAccountByIdQuery |
| assignRole | /{accountId}/roles (POST) | path: accountId: Long; body: AssignRoleResource { role: String } | Asigna un rol adicional a la cuenta | AssignRoleCommand |
| revokeRole | /{accountId}/roles/{role} (DELETE) | path: accountId: Long, role: String | Retira un rol previamente asignado a la cuenta | RevokeRoleCommand |
| suspendAccount | /{accountId}/suspend (POST) | path: accountId: Long; body: SuspendAccountResource { reason: String } | Suspende manualmente una cuenta | SuspendAccountCommand |
| reactivateAccount | /{accountId}/reactivate (POST) | path: accountId: Long | Reactiva una cuenta previamente suspendida | ReactivateAccountCommand |

| Nombre | Métodos expuestos | Propósito |
| --- | --- | --- |
| IamFacade | validateAccessToken(token: String): AuthenticatedPrincipal; getAccountSummary(accountId: Long): AccountSummaryResource | Permite que otros bounded contexts (Perfiles, Cuidado, Pagos y Suscripciones, entre otros) validen los tokens emitidos por IAM y obtengan un resumen mínimo de la cuenta sin acceder directamente al aggregate Account, implementando el patrón Shared Kernel acordado en el Context Mapping. |

### 5.1.3. Application Layer

La Application Layer traduce cada Command y Query de la Domain Layer en un handler dedicado, y resuelve mediante Event Handlers las integraciones entrantes identificadas en las Observaciones Previas: el alta y la baja de empleados publicadas por Capital Humano, y el alta de administradores publicada por Gestión del Negocio.

**RegisterAccountCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RegisterAccountCommandHandler |
| Categoría | Command Handler |
| Propósito | Crear la cuenta en estado PENDING_VERIFICATION, derivar y almacenar el hash de la contraseña, y emitir el código de verificación de correo. |
| Command/Query/Evento que maneja | RegisterAccountCommand |
| Repositorios y servicios que usa | AccountRepository, PasswordHasher, VerificationCodeGenerator |
| Eventos que publica | AccountRegistered, VerificationCodeIssued |
| User story/capability que habilita | TS-01, US05 |

**VerifyEmailCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | VerifyEmailCommandHandler |
| Categoría | Command Handler |
| Propósito | Validar el código de verificación vigente y activar la cuenta. |
| Command/Query/Evento que maneja | VerifyEmailCommand |
| Repositorios y servicios que usa | AccountRepository |
| Eventos que publica | AccountEmailVerified |
| User story/capability que habilita | TS-01 |

**ResendVerificationCodeCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | ResendVerificationCodeCommandHandler |
| Categoría | Command Handler |
| Propósito | Invalidar el código de verificación anterior y emitir uno nuevo, respetando el límite de frecuencia de reenvío. |
| Command/Query/Evento que maneja | ResendVerificationCodeCommand |
| Repositorios y servicios que usa | AccountRepository, VerificationCodeGenerator, RateLimiter |
| Eventos que publica | VerificationCodeIssued |
| User story/capability que habilita | TS-02 |

**LoginCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | LoginCommandHandler |
| Categoría | Command Handler |
| Propósito | Autenticar las credenciales de la cuenta, verificar su estado ACTIVE y emitir una nueva Session con sus tokens asociados. |
| Command/Query/Evento que maneja | LoginCommand |
| Repositorios y servicios que usa | AccountRepository, PasswordHasher, TokenProvider |
| Eventos que publica | SessionStarted |
| User story/capability que habilita | TS-03, US15 |

**RefreshSessionCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RefreshSessionCommandHandler |
| Categoría | Command Handler |
| Propósito | Validar la vigencia del refresh token y emitir un nuevo par de tokens para la Session existente. |
| Command/Query/Evento que maneja | RefreshSessionCommand |
| Repositorios y servicios que usa | AccountRepository, TokenProvider |
| Eventos que publica | SessionStarted |
| User story/capability que habilita | TS-03, escenario #4 |

**LogoutCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | LogoutCommandHandler |
| Categoría | Command Handler |
| Propósito | Invalidar la Session activa indicada. |
| Command/Query/Evento que maneja | LogoutCommand |
| Repositorios y servicios que usa | AccountRepository |
| Eventos que publica | SessionEnded |
| User story/capability que habilita | Derivado del EventStorming (comando Cerrar sesión) |

**RequestPasswordRecoveryCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RequestPasswordRecoveryCommandHandler |
| Categoría | Command Handler |
| Propósito | Emitir un código de verificación con propósito PASSWORD_RECOVERY para la cuenta asociada al correo indicado. |
| Command/Query/Evento que maneja | RequestPasswordRecoveryCommand |
| Repositorios y servicios que usa | AccountRepository, VerificationCodeGenerator |
| Eventos que publica | VerificationCodeIssued |
| User story/capability que habilita | Derivado del EventStorming (flujo de recuperación de contraseña) |

**ResetPasswordCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | ResetPasswordCommandHandler |
| Categoría | Command Handler |
| Propósito | Validar el código de recuperación vigente y reemplazar el hash de la contraseña de la cuenta. |
| Command/Query/Evento que maneja | ResetPasswordCommand |
| Repositorios y servicios que usa | AccountRepository, PasswordHasher |
| Eventos que publica | PasswordReset |
| User story/capability que habilita | Derivado del EventStorming (flujo de recuperación de contraseña) |

**AssignRoleCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | AssignRoleCommandHandler |
| Categoría | Command Handler |
| Propósito | Otorgar un rol adicional a la cuenta, validando su compatibilidad con los roles vigentes. |
| Command/Query/Evento que maneja | AssignRoleCommand |
| Repositorios y servicios que usa | AccountRepository |
| Eventos que publica | RoleAssigned |
| User story/capability que habilita | US17 |

**RevokeRoleCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RevokeRoleCommandHandler |
| Categoría | Command Handler |
| Propósito | Retirar un rol previamente otorgado a la cuenta sin afectar los demás roles vigentes. |
| Command/Query/Evento que maneja | RevokeRoleCommand |
| Repositorios y servicios que usa | AccountRepository |
| Eventos que publica | RoleRevoked |
| User story/capability que habilita | US17, escenario #4 |

**SuspendAccountCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | SuspendAccountCommandHandler |
| Categoría | Command Handler |
| Propósito | Suspender la cuenta e impedir su autenticación hasta una reactivación explícita. |
| Command/Query/Evento que maneja | SuspendAccountCommand |
| Repositorios y servicios que usa | AccountRepository |
| Eventos que publica | AccountSuspended |
| User story/capability que habilita | Invocado manualmente por un Administrador o automáticamente por EmployeeTerminatedEventHandler |

**ReactivateAccountCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | ReactivateAccountCommandHandler |
| Categoría | Command Handler |
| Propósito | Reactivar una cuenta previamente suspendida. |
| Command/Query/Evento que maneja | ReactivateAccountCommand |
| Repositorios y servicios que usa | AccountRepository |
| Eventos que publica | AccountReactivated |
| User story/capability que habilita | Invocado manualmente por un Administrador |

**GetAccountByIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetAccountByIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el detalle de una cuenta junto con sus roles vigentes. |
| Command/Query/Evento que maneja | GetAccountByIdQuery |
| Repositorios y servicios que usa | AccountRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta de cuenta desde el endpoint getAccountById |

**VerificationCodeIssuedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | VerificationCodeIssuedEventHandler |
| Categoría | Event Handler |
| Propósito | Solicitar al adaptador de Sendgrid el envío del correo correspondiente al propósito del código emitido. |
| Command/Query/Evento que maneja | VerificationCodeIssued (evento propio de IAM) |
| Repositorios y servicios que usa | EmailGateway |
| Eventos que publica | No aplica |
| User story/capability que habilita | TS-01, TS-02, flujo de recuperación de contraseña |

**EmployeeRegisteredEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | EmployeeRegisteredEventHandler |
| Categoría | Event Handler |
| Propósito | Crear la cuenta correspondiente a un empleado recién dado de alta y asignarle el rol operativo inicial. |
| Command/Query/Evento que maneja | EmployeeRegistered (evento externo, BC de origen: Capital Humano) |
| Repositorios y servicios que usa | RegisterAccountCommand, AssignRoleCommand (invocados internamente) |
| Eventos que publica | AccountRegistered, VerificationCodeIssued, RoleAssigned (vía los commands invocados) |
| User story/capability que habilita | Resuelve la observación previa #3 (integración entrante de Capital Humano) |

**EmployeeTerminatedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | EmployeeTerminatedEventHandler |
| Categoría | Event Handler |
| Propósito | Suspender la cuenta de un empleado al registrarse su despido. |
| Command/Query/Evento que maneja | EmployeeTerminated (evento externo, BC de origen: Capital Humano) |
| Repositorios y servicios que usa | SuspendAccountCommand (invocado internamente) |
| Eventos que publica | AccountSuspended (vía el command invocado) |
| User story/capability que habilita | Resuelve la observación previa #3 (integración entrante de Capital Humano) |

**AdministratorRegisteredEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | AdministratorRegisteredEventHandler |
| Categoría | Event Handler |
| Propósito | Crear la cuenta correspondiente a un administrador del negocio recién registrado y asignarle el rol BUSINESS_ADMIN. |
| Command/Query/Evento que maneja | BusinessAdministratorRegistered (evento externo, BC de origen: Gestión del Negocio) |
| Repositorios y servicios que usa | RegisterAccountCommand, AssignRoleCommand (invocados internamente) |
| Eventos que publica | AccountRegistered, VerificationCodeIssued, RoleAssigned (vía los commands invocados) |
| User story/capability que habilita | Resuelve la observación previa #5 (integración entrante de Gestión del Negocio) |

**IamFacadeImpl**

| Propiedad | Valor |
| --- | --- |
| Nombre | IamFacadeImpl |
| Categoría | Facade Implementation |
| Propósito | Implementar IamFacade para que otros bounded contexts validen tokens y obtengan un resumen de cuenta sin acceder al aggregate Account. |
| Command/Query/Evento que maneja | No aplica (no despacha Commands/Queries; delega en AccountRepository y TokenProvider) |
| Repositorios y servicios que usa | AccountRepository, TokenProvider |
| Eventos que publica | No aplica |
| User story/capability que habilita | Patrón Shared Kernel documentado en el Context Mapping (4.2.5) |

### 5.1.4. Infrastructure Layer

La Infrastructure Layer implementa el repositorio de Account sobre PostgreSQL, consistente con la decisión TS-47 de persistencia transaccional para cuentas, y los adaptadores hacia Sendgrid, el proveedor de tokens y el hasher de contraseñas, además del suscriptor del bus de eventos interno que conecta a IAM con Capital Humano y Gestión del Negocio.

| Nombre | Interfaz que implementa | Tecnología | Propósito |
| --- | --- | --- | --- |
| AccountRepositoryJpa | AccountRepository | Spring Data JPA sobre PostgreSQL | Persiste y recupera el aggregate Account junto con sus entidades internas Session y RoleAssignment. |

La persistencia se configura mediante `AccountJpaConfiguration`, que habilita los repositorios Spring Data JPA (`@EnableJpaRepositories`) y el mapeo objeto-relacional de `Account`, `Session`, `RoleAssignment` y `VerificationCode` sobre el motor PostgreSQL definido en TS-47.

| Nombre | Categoría | Interfaz que implementa | Servicio externo | Propósito |
| --- | --- | --- | --- | --- |
| SendgridEmailGateway | Gateway | EmailGateway | Sendgrid | Envía los correos de verificación y de recuperación de contraseña. |
| JwtTokenProvider | Service Adapter | TokenProvider | Librería JWT local | Genera y valida los pares de accessToken/refreshToken firmados. |
| BcryptPasswordHasher | Service Adapter | PasswordHasher | Librería de hashing local | Aplica la función de derivación de claves resistente a fuerza bruta (QAS-11). |
| DomainEventBusSubscriber | Event Subscriber | EmployeeRegisteredListener, EmployeeTerminatedListener, AdministratorRegisteredListener | Bus de eventos interno del monolito modular (Spring Application Events) | Enruta los eventos publicados por Capital Humano y Gestión del Negocio hacia los Event Handlers de IAM. |

| Tabla/Colección | Propósito |
| --- | --- |
| accounts | Almacena el aggregate Account: estado, credenciales hasheadas y datos de contacto. |
| account_role_assignments | Almacena los roles vigentes otorgados a cada cuenta (entity RoleAssignment). |
| account_sessions | Almacena las sesiones activas y expiradas emitidas por cuenta (entity Session). |
| verification_codes | Almacena los códigos de verificación emitidos (value object VerificationCode), su propósito y su vigencia. |

| Objeto | BC responsable | Justificación |
| --- | --- | --- |
| Invitación (aggregate) | Cuidado | Gestiona la invitación y vinculación de cuidadores; IAM solo recibe RegisterAccountCommand cuando el invitado completa su registro (observación previa #1). |
| Perfil / Perfil de hogar | Perfiles | Los datos personales, la foto y el cuidador principal del hogar se gestionan en Perfiles, inicializados al consumir AccountRegistered (observación previa #1). |
| Contrato laboral | Capital Humano | El ciclo de vida del contrato (alta, renovación, suspensión, culminación) es responsabilidad de Capital Humano; IAM solo refleja el estado de acceso derivado mediante EmployeeRegisteredEventHandler/EmployeeTerminatedEventHandler (observación previa #3). |
| Perfil del negocio | Gestión del Negocio | El registro del negocio y los datos de negocio del administrador se gestionan en Gestión del Negocio; IAM solo crea la cuenta y las credenciales mediante AdministratorRegisteredEventHandler (observación previa #5). |

**Verificación de trazabilidad — IAM**

| Criterio | Cumple | Evidencia |
| --- | --- | --- |
| Todo Command/Query usado en un endpoint o consumer existe en Domain y tiene su handler en Application | Sí | Los 12 commands y la query de 5.1.1 tienen su handler correspondiente en 5.1.3. |
| Todo Command/Query declarado en Domain es usado por algún endpoint, consumer o event handler (o se justifica) | Sí | RegisterAccountCommand y AssignRoleCommand se usan desde endpoints REST y desde los Event Handlers que resuelven las observaciones previas #3 y #5; SuspendAccountCommand se usa desde el endpoint manual y desde EmployeeTerminatedEventHandler. |
| Los parámetros de cada endpoint cubren los parámetros del Command/Query que despacha | Sí | Cada Resource de la tabla de endpoints (5.1.2) mapea 1:1 los parámetros del Command correspondiente. |
| Todo controller está relacionado con un aggregate o entity existente en la Domain Layer | Sí | AccountController está relacionado con el aggregate Account. |
| Toda interfaz de repositorio del Domain tiene implementación en Infrastructure, y viceversa | Sí | AccountRepository (5.1.1) se implementa en AccountRepositoryJpa (5.1.4). |
| Todo Domain Event publicado tiene al menos un handler o consumidor identificado (en este u otro BC) | Sí | VerificationCodeIssued lo consume VerificationCodeIssuedEventHandler (propio); el resto se consumen en Perfiles o Comunicaciones, según se detalla en la tabla de Domain Events (5.1.1). |
| Ningún aggregate de este BC es aggregate root en otro BC | Sí | Account es exclusivo de IAM; Invitación se excluyó explícitamente hacia Cuidado (observación previa #1, tabla de objetos excluidos 5.1.4). |
| Ninguna clase de Domain depende de Infrastructure ni de frameworks | Sí | PasswordHash, TokenProvider y EmailGateway se declaran como puertos/value objects en Domain; sus implementaciones concretas (BcryptPasswordHasher, JwtTokenProvider, SendgridEmailGateway) están en Infrastructure (5.1.4). |

### 5.1.5. Bounded Context Software Architecture Component Level Diagrams

### 5.1.6. Bounded Context Software Architecture Code Level Diagrams

#### 5.1.6.1. Bounded Context Domain Layer Class Diagrams

#### 5.1.6.2. Bounded Context Database Design Diagram

<div style="page-break-after: always;"></div>

## 5.2. Bounded Context: Gestión del Negocio

El bounded context **Gestión del Negocio** administra la información del negocio de Alivia y de los administradores responsables de gestionarlo: el registro del negocio con su ubicación, la actualización de su perfil, y el registro y la actualización de los administradores. Es un subdominio de soporte con rol de contexto de ejecución (no de puerta de enlace como IAM). El único actor que participa es el **Administrador**, quien registra el negocio y da de alta a otros administradores. A diferencia de IAM, este bounded context no posee contratos técnicos (TS/US) propios en los capítulos 2-3; sus comandos y parámetros se derivan directamente del lenguaje ubicuo del Bounded Context Canvas (4.2.4).

### 5.2.1. Domain Layer

La Domain Layer de Gestión del Negocio modela dos aggregates independientes, fieles al EventStorming de Paso 10: `Business`, que representa al negocio de Alivia con su ubicación y perfil, y `BusinessAdministrator`, que representa a cada administrador responsable de gestionarlo. Ambos son aggregates simples, sin entidades internas con identidad propia.

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| Business | Aggregate Root | Representa el negocio de Alivia registrado con su ubicación y su perfil. No admite más de una instancia activa en la plataforma (observación previa #1: Alivia no es una plataforma multi-tenant) ni una ubicación sin geocodificar mediante Google Maps. |
| BusinessAdministrator | Aggregate Root | Representa a un administrador responsable de gestionar el negocio. Referencia a `Business` mediante `businessId` (un `Business` puede tener varios administradores asociados, resolviendo la observación previa #1). |

No se identifican Entities en este bounded context: tanto `Business` como `BusinessAdministrator` son aggregates simples sin componentes internos con identidad propia.

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| BusinessId | Value Object | Identificador tipado del aggregate Business; no admite valores nulos ni negativos. |
| BusinessAdministratorId | Value Object | Identificador tipado del aggregate BusinessAdministrator; no admite valores nulos ni negativos. |
| GeoLocation | Value Object | Ubicación geocodificada del negocio (latitud, longitud y dirección) obtenida mediante Google Maps; no admite coordenadas nulas ni fuera de los rangos válidos (-90 a 90 de latitud, -180 a 180 de longitud), conforme a la decisión de negocio del Canvas. |
| BusinessName | Value Object | Nombre del negocio; no admite valores vacíos. |
| Email | Value Object | Dirección de correo electrónico del administrador; valida el formato y no admite valores vacíos o mal formados. Es un value object propio de este bounded context, sin acoplarse al `Email` de IAM (no existe Shared Kernel declarado entre ambos en el Context Mapping). |
| PhoneNumber | Value Object | Número de contacto del administrador; valida el formato del número registrado. |

No se declaran Enums en este bounded context: ni `Business` ni `BusinessAdministrator` exhiben estados con transiciones; el ciclo de vida de acceso (activo/suspendido) de la cuenta del administrador es responsabilidad exclusiva de IAM (ver 5.1, `AccountStatus`).

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| RegisterBusinessCommand | Registra el negocio de Alivia con su ubicación geocodificada mediante Google Maps. | name: String, description: String, address: String, latitude: Double, longitude: Double |
| UpdateBusinessProfileCommand | Actualiza el perfil del negocio (nombre, descripción o ubicación). | businessId: Long, name: String, description: String, address: String, latitude: Double, longitude: Double |
| RegisterBusinessAdministratorCommand | Registra un nuevo administrador responsable de gestionar el negocio. | businessId: Long, name: String, email: String, phone: String |
| UpdateBusinessAdministratorCommand | Actualiza los datos de contacto de un administrador. | administratorId: Long, name: String, email: String, phone: String |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| GetBusinessByIdQuery | Obtiene el detalle del negocio, incluyendo su perfil y ubicación. | businessId: Long |
| GetBusinessAdministratorByIdQuery | Obtiene el detalle de un administrador del negocio. | administratorId: Long |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| BusinessRegistered | Se publica al registrarse el negocio de Alivia con su ubicación geocodificada. | businessId: Long, name: String, address: String, latitude: Double, longitude: Double, registeredAt: LocalDateTime |
| BusinessProfileUpdated | Se publica al actualizarse el perfil del negocio. | businessId: Long, updatedAt: LocalDateTime |
| BusinessAdministratorRegistered | Se publica al registrarse un nuevo administrador; es consumido por `AdministratorRegisteredEventHandler` de IAM (5.1.3) para crear su cuenta y asignarle el rol BUSINESS_ADMIN (observación previa #2). | administratorId: Long, businessId: Long, name: String, email: String, phone: String, registeredAt: LocalDateTime |
| BusinessAdministratorUpdated | Se publica al actualizarse los datos de un administrador; dispara la creación de su perfil en Perfiles, conforme a la decisión de negocio del Canvas (observación previa #3, a formalizar en 5.3). | administratorId: Long, name: String, email: String, phone: String, updatedAt: LocalDateTime |

No se declaran Factories ni Domain Services en este bounded context: `Business` y `BusinessAdministrator` son aggregates independientes que solo se referencian por identificador (`businessId`), sin que su creación requiera colaboración ni validación cruzada en memoria entre ambos.

| Nombre | Aggregate que gestiona | Descripción |
| --- | --- | --- |
| BusinessRepository | Business | Persiste y recupera el aggregate Business; garantiza la unicidad de la instancia activa del negocio (observación previa #1). |
| BusinessAdministratorRepository | BusinessAdministrator | Persiste y recupera el aggregate BusinessAdministrator; expone la búsqueda por businessId para listar a los administradores de un negocio. |

| Clase origen | Relación | Clase destino | Descripción |
| --- | --- | --- | --- |
| BusinessAdministrator | asociación | Business | BusinessAdministrator referencia a su negocio mediante businessId; son aggregates independientes, sin composición. |
| BusinessRepository | depende de | Business | El repositorio persiste y recupera el aggregate Business. |
| BusinessAdministratorRepository | depende de | BusinessAdministrator | El repositorio persiste y recupera el aggregate BusinessAdministrator. |

### 5.2.2. Interface Layer

La Interface Layer expone dos controllers independientes, uno por cada aggregate root: `BusinessController` y `BusinessAdministratorController`. Este bounded context no consume mensajería de dispositivos IoT y no expone un facade/ACL: sus integraciones salientes se resuelven mediante Domain Events (hacia IAM y Perfiles, ver 5.2.1) y mediante el adaptador de Google Maps (ver 5.2.4), no mediante llamadas síncronas de otros BC hacia este.

| Propiedad | Valor |
| --- | --- |
| Nombre | BusinessController |
| Categoría | Controller |
| Propósito | Exponer el registro y la actualización del perfil del negocio de Alivia. |
| Aggregate/Entity relacionado | Business |
| Ruta base | /api/v1/business |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| registerBusiness | / (POST) | body: RegisterBusinessResource { name: String, description: String, address: String, latitude: Double, longitude: Double } | Registra el negocio de Alivia con su ubicación | RegisterBusinessCommand |
| updateBusinessProfile | /{businessId} (PUT) | path: businessId: Long; body: UpdateBusinessProfileResource { name: String, description: String, address: String, latitude: Double, longitude: Double } | Actualiza el perfil del negocio | UpdateBusinessProfileCommand |
| getBusiness | /{businessId} (GET) | path: businessId: Long | Obtiene el detalle del negocio | GetBusinessByIdQuery |

| Propiedad | Valor |
| --- | --- |
| Nombre | BusinessAdministratorController |
| Categoría | Controller |
| Propósito | Exponer el registro y la actualización de los administradores del negocio. |
| Aggregate/Entity relacionado | BusinessAdministrator |
| Ruta base | /api/v1/business/administrators |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| registerBusinessAdministrator | / (POST) | body: RegisterBusinessAdministratorResource { businessId: Long, name: String, email: String, phone: String } | Registra un nuevo administrador para el negocio | RegisterBusinessAdministratorCommand |
| updateBusinessAdministrator | /{administratorId} (PUT) | path: administratorId: Long; body: UpdateBusinessAdministratorResource { name: String, email: String, phone: String } | Actualiza los datos de un administrador | UpdateBusinessAdministratorCommand |
| getBusinessAdministratorById | /{administratorId} (GET) | path: administratorId: Long | Obtiene el detalle de un administrador | GetBusinessAdministratorByIdQuery |

### 5.2.3. Application Layer

La Application Layer traduce cada Command y Query de la Domain Layer en un handler dedicado. Este bounded context no declara Event Handlers de eventos externos: su Comunicación Entrante (Canvas 4.2.4) proviene únicamente del actor Administrador, sin integraciones entrantes desde otros BC.

**RegisterBusinessCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RegisterBusinessCommandHandler |
| Categoría | Command Handler |
| Propósito | Geocodificar la dirección ingresada mediante Google Maps y registrar el negocio, validando que no exista ya una instancia activa (observación previa #1). |
| Command/Query/Evento que maneja | RegisterBusinessCommand |
| Repositorios y servicios que usa | BusinessRepository, GeocodingService |
| Eventos que publica | BusinessRegistered |
| User story/capability que habilita | Derivado del Bounded Context Canvas 4.2.4 |

**UpdateBusinessProfileCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | UpdateBusinessProfileCommandHandler |
| Categoría | Command Handler |
| Propósito | Actualizar el perfil del negocio, regeocodificando la ubicación cuando la dirección cambia. |
| Command/Query/Evento que maneja | UpdateBusinessProfileCommand |
| Repositorios y servicios que usa | BusinessRepository, GeocodingService |
| Eventos que publica | BusinessProfileUpdated |
| User story/capability que habilita | Derivado del Bounded Context Canvas 4.2.4 |

**RegisterBusinessAdministratorCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RegisterBusinessAdministratorCommandHandler |
| Categoría | Command Handler |
| Propósito | Registrar un nuevo administrador, validando que el negocio referenciado exista. |
| Command/Query/Evento que maneja | RegisterBusinessAdministratorCommand |
| Repositorios y servicios que usa | BusinessAdministratorRepository, BusinessRepository |
| Eventos que publica | BusinessAdministratorRegistered |
| User story/capability que habilita | Resuelve la observación previa #2 (integración saliente hacia IAM) |

**UpdateBusinessAdministratorCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | UpdateBusinessAdministratorCommandHandler |
| Categoría | Command Handler |
| Propósito | Actualizar los datos de contacto de un administrador. |
| Command/Query/Evento que maneja | UpdateBusinessAdministratorCommand |
| Repositorios y servicios que usa | BusinessAdministratorRepository |
| Eventos que publica | BusinessAdministratorUpdated |
| User story/capability que habilita | Resuelve la observación previa #3 (integración saliente hacia Perfiles) |

**GetBusinessByIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetBusinessByIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el detalle del negocio, incluyendo su perfil y ubicación. |
| Command/Query/Evento que maneja | GetBusinessByIdQuery |
| Repositorios y servicios que usa | BusinessRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getBusiness |

**GetBusinessAdministratorByIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetBusinessAdministratorByIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el detalle de un administrador del negocio. |
| Command/Query/Evento que maneja | GetBusinessAdministratorByIdQuery |
| Repositorios y servicios que usa | BusinessAdministratorRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getBusinessAdministratorById |

### 5.2.4. Infrastructure Layer

La Infrastructure Layer implementa los repositorios de Business y BusinessAdministrator sobre PostgreSQL, consistente con el carácter transaccional y estructurado de los datos del negocio (TS-47), y el adaptador hacia Google Maps para geocodificar direcciones.

| Nombre | Interfaz que implementa | Tecnología | Propósito |
| --- | --- | --- | --- |
| BusinessRepositoryJpa | BusinessRepository | Spring Data JPA sobre PostgreSQL | Persiste y recupera el aggregate Business. |
| BusinessAdministratorRepositoryJpa | BusinessAdministratorRepository | Spring Data JPA sobre PostgreSQL | Persiste y recupera el aggregate BusinessAdministrator. |

La persistencia se configura mediante `BusinessJpaConfiguration`, que habilita los repositorios Spring Data JPA (`@EnableJpaRepositories`) y el mapeo objeto-relacional de `Business` y `BusinessAdministrator` sobre el motor PostgreSQL.

| Nombre | Categoría | Interfaz que implementa | Servicio externo | Propósito |
| --- | --- | --- | --- | --- |
| GoogleMapsGeocodingAdapter | Gateway | GeocodingService | Google Maps | Geocodifica la dirección ingresada a coordenadas válidas al registrar o actualizar el negocio. |

| Tabla/Colección | Propósito |
| --- | --- |
| businesses | Almacena el aggregate Business: nombre, descripción y ubicación geocodificada. |
| business_administrators | Almacena el aggregate BusinessAdministrator: datos de contacto y referencia a su negocio (businessId). |

| Objeto | BC responsable | Justificación |
| --- | --- | --- |
| Cuenta / credenciales del administrador | IAM | La creación y gestión de la cuenta de acceso del administrador es responsabilidad exclusiva de IAM, invocada mediante BusinessAdministratorRegistered (observación previa #2, resuelto en 5.1). |
| Perfil del administrador | Perfiles | El perfil detallado del administrador (foto, preferencias) se gestiona en Perfiles al consumir BusinessAdministratorUpdated (observación previa #3, decisión de negocio del Canvas, a formalizar en 5.3). |

**Verificación de trazabilidad — Gestión del Negocio**

| Criterio | Cumple | Evidencia |
| --- | --- | --- |
| Todo Command/Query usado en un endpoint o consumer existe en Domain y tiene su handler en Application | Sí | Los 4 commands y las 2 queries de 5.2.1 tienen su handler correspondiente en 5.2.3. |
| Todo Command/Query declarado en Domain es usado por algún endpoint, consumer o event handler (o se justifica) | Sí | Los 4 commands y las 2 queries se usan desde los endpoints de BusinessController y BusinessAdministratorController (5.2.2); no hay event handlers en este BC (justificado en 5.2.3). |
| Los parámetros de cada endpoint cubren los parámetros del Command/Query que despacha | Sí | Cada Resource de las tablas de endpoints (5.2.2) mapea 1:1 los parámetros del Command correspondiente. |
| Todo controller está relacionado con un aggregate o entity existente en la Domain Layer | Sí | BusinessController se relaciona con Business; BusinessAdministratorController se relaciona con BusinessAdministrator. |
| Toda interfaz de repositorio del Domain tiene implementación en Infrastructure, y viceversa | Sí | BusinessRepository ↔ BusinessRepositoryJpa; BusinessAdministratorRepository ↔ BusinessAdministratorRepositoryJpa. |
| Todo Domain Event publicado tiene al menos un handler o consumidor identificado (en este u otro BC) | Sí | BusinessAdministratorRegistered lo consume IAM (5.1.3); BusinessAdministratorUpdated lo consume Perfiles (a formalizar en 5.3); BusinessRegistered y BusinessProfileUpdated quedan disponibles para Analíticas/Comunicaciones sin un consumidor obligatorio adicional en el alcance actual. |
| Ningún aggregate de este BC es aggregate root en otro BC | Sí | Business y BusinessAdministrator son exclusivos de este bounded context. |
| Ninguna clase de Domain depende de Infrastructure ni de frameworks | Sí | GeocodingService se declara como puerto en Domain; su implementación concreta (GoogleMapsGeocodingAdapter) está en Infrastructure (5.2.4). |

### 5.2.5. Bounded Context Software Architecture Component Level Diagrams

### 5.2.6. Bounded Context Software Architecture Code Level Diagrams

#### 5.2.6.1. Bounded Context Domain Layer Class Diagrams

#### 5.2.6.2. Bounded Context Database Design Diagram

<div style="page-break-after: always;"></div>