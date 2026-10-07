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

## 5.3. Bounded Context: Perfiles

El bounded context **Perfiles** gestiona dos aggregates con sujetos distintos: el perfil genérico de cualquier titular de cuenta de Alivia —Cuidador, Empleado o Administrador— y el perfil de hogar de la persona asistida, incluyendo su ubicación y la asignación del cuidador principal. Es un subdominio de soporte con rol de contexto de ejecución. Participa como actor directo el **Cuidador**, quien crea y edita su propio perfil y el perfil de hogar; el resto de las altas de perfil llegan automáticamente desde IAM, Capital Humano y Gestión del Negocio al crearse o actualizarse una cuenta. Perfiles comparte un Shared Kernel con IAM (Context Mapping, 4.2.5): referencia a las cuentas mediante el `AccountId` de IAM en lugar de declarar un identificador propio de usuario.

### 5.3.1. Domain Layer

La Domain Layer de Perfiles modela dos aggregates independientes: `Profile`, el perfil genérico del titular de una cuenta (observación previa #1), y `HomeProfile`, el perfil de hogar de la persona asistida, con su ubicación y su cuidador principal.

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| Profile | Aggregate Root | Representa el perfil de cualquier titular de cuenta de Alivia (Cuidador, Empleado o Administrador): datos personales, foto y preferencias de comunicación. Solo el propio titular puede actualizarlo (observación previa #3); se inicializa automáticamente al recibir la señal de creación o actualización de su cuenta de origen. |
| HomeProfile | Aggregate Root | Representa el perfil de hogar de la persona asistida: datos personales, ubicación geocodificada y cuidador principal. Un Cuidador no puede ser principal de más de un HomeProfile a la vez (observación previa #2). |

No se identifican Entities en este bounded context: tanto `Profile` como `HomeProfile` son aggregates simples sin componentes internos con identidad propia.

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| ProfileId | Value Object | Identificador tipado del aggregate Profile; no admite valores nulos ni negativos. |
| HomeProfileId | Value Object | Identificador tipado del aggregate HomeProfile; no admite valores nulos ni negativos. |
| DisplayName | Value Object | Nombre del titular mostrado en el perfil; no admite valores vacíos. |
| PhotoUrl | Value Object | URL de la foto de perfil; valida que apunte a un recurso alojado en Cloudinary (decisión de negocio del Canvas: "toda foto de perfil se almacena en Cloudinary"). |
| CommunicationPreferences | Value Object | Canal de comunicación preferido del titular (`PreferredChannel`); no admite un canal nulo o no soportado. |
| AssistedPersonName | Value Object | Nombre de la persona asistida asociada a un HomeProfile; no admite valores vacíos. |
| HomeLocation | Value Object | Ubicación geocodificada del hogar (dirección, latitud y longitud) obtenida mediante Google Maps; no admite coordenadas nulas ni fuera de los rangos válidos (-90 a 90 de latitud, -180 a 180 de longitud). |

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| PreferredChannel | Enum | Canal de comunicación preferido por el titular del perfil: PUSH, EMAIL, SMS. No exhibe transiciones; es un valor categórico que puede reemplazarse libremente mediante UpdateCommunicationPreferencesCommand. |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| InitializeProfileCommand | Crea o refresca de forma idempotente el perfil genérico de un titular de cuenta, disparado automáticamente al crearse o actualizarse su cuenta en IAM, Capital Humano o Gestión del Negocio (observación previa #1). | accountId: Long, name: String |
| UpdateProfilePersonalDataCommand | Actualiza los datos personales del perfil; solo puede ser invocado por el propio titular (observación previa #3). | profileId: Long, name: String |
| UpdateProfilePhotoCommand | Actualiza la foto de perfil, almacenándola en Cloudinary. | profileId: Long, photoUrl: String |
| UpdateCommunicationPreferencesCommand | Actualiza el canal de comunicación preferido del titular. | profileId: Long, preferredChannel: PreferredChannel |
| CreateHomeProfileCommand | Crea el perfil de hogar de la persona asistida, geocodificando su dirección y asignando al Cuidador creador como cuidador principal. | accountId: Long, assistedPersonName: String, address: String, latitude: Double, longitude: Double |
| UpdateHomeProfileCommand | Actualiza los datos o la ubicación del perfil de hogar. | homeProfileId: Long, assistedPersonName: String, address: String, latitude: Double, longitude: Double |
| ReplacePrincipalCaregiverCommand | Reemplaza al cuidador principal del perfil de hogar, disparado al consumir el evento de reemplazo publicado por Cuidado (observación previa #4). | homeProfileId: Long, newPrincipalCaregiverAccountId: Long |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| GetProfileByIdQuery | Obtiene el detalle de un perfil por su identificador. | profileId: Long |
| GetProfileByAccountIdQuery | Obtiene el perfil asociado a una cuenta de IAM. | accountId: Long |
| GetHomeProfileByIdQuery | Obtiene el detalle de un perfil de hogar, incluyendo su ubicación y su cuidador principal. | homeProfileId: Long |

Ninguno de los siguientes Domain Events tiene un consumidor externo declarado en el Bounded Context Canvas (4.2.4): su Comunicación Saliente solo registra integraciones hacia Cloudinary y Google Maps, servicios externos sin interés en eventos de dominio. Se publican para dejar un historial de cambios y habilitar futuras integraciones (por ejemplo, Comunicaciones), sin que ello bloquee la trazabilidad de este bounded context.

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| ProfileInitialized | Se publica al inicializarse por primera vez el perfil de un titular. | profileId: Long, accountId: Long, name: String, initializedAt: LocalDateTime |
| ProfilePersonalDataUpdated | Se publica al actualizar los datos personales de un perfil. | profileId: Long, name: String, updatedAt: LocalDateTime |
| ProfilePhotoUpdated | Se publica al actualizar la foto de un perfil. | profileId: Long, photoUrl: String, updatedAt: LocalDateTime |
| CommunicationPreferencesUpdated | Se publica al actualizar el canal de comunicación preferido de un perfil. | profileId: Long, preferredChannel: PreferredChannel, updatedAt: LocalDateTime |
| HomeProfileCreated | Se publica al crearse el perfil de hogar de la persona asistida. | homeProfileId: Long, assistedPersonName: String, address: String, latitude: Double, longitude: Double, principalCaregiverId: Long, createdAt: LocalDateTime |
| HomeProfileUpdated | Se publica al actualizarse los datos o la ubicación del perfil de hogar. | homeProfileId: Long, updatedAt: LocalDateTime |
| PrincipalCaregiverAssigned | Se publica al asignarse o reemplazarse el cuidador principal de un perfil de hogar. | homeProfileId: Long, accountId: Long, assignedAt: LocalDateTime |

No se declaran Factories ni Domain Services en este bounded context: `Profile` y `HomeProfile` son aggregates simples cuya creación no requiere colaboración entre aggregates distintos. La única regla que involucra múltiples instancias —que un Cuidador no sea principal de más de un HomeProfile a la vez (observación previa #2)— se valida en `CreateHomeProfileCommandHandler` mediante una consulta a `HomeProfileRepository`, ya que es una restricción de unicidad entre instancias del mismo aggregate y no una colaboración entre aggregates de distinto tipo.

| Nombre | Aggregate que gestiona | Descripción |
| --- | --- | --- |
| ProfileRepository | Profile | Persiste y recupera el aggregate Profile; expone la búsqueda por accountId para soportar la inicialización idempotente. |
| HomeProfileRepository | HomeProfile | Persiste y recupera el aggregate HomeProfile; expone la búsqueda por principalCaregiverId para validar la unicidad de la observación previa #2. |

| Clase origen | Relación | Clase destino | Descripción |
| --- | --- | --- | --- |
| Profile | asociación | Account (IAM, Shared Kernel) | Profile referencia a su titular mediante accountId, el AccountId de IAM compartido vía Shared Kernel (Context Mapping 4.2.5). |
| HomeProfile | asociación | Account (IAM, Shared Kernel) | HomeProfile referencia a su cuidador principal mediante principalCaregiverId, el AccountId de IAM compartido vía Shared Kernel. |
| ProfileRepository | depende de | Profile | El repositorio persiste y recupera el aggregate Profile. |
| HomeProfileRepository | depende de | HomeProfile | El repositorio persiste y recupera el aggregate HomeProfile. |

### 5.3.2. Interface Layer

La Interface Layer expone dos controllers independientes, uno por cada aggregate root: `ProfileController` y `HomeProfileController`. Ninguno expone `InitializeProfileCommand` ni `ReplacePrincipalCaregiverCommand`, ya que ambos solo se invocan desde Event Handlers en la Application Layer (5.3.3), nunca desde un endpoint REST directo. Este bounded context no consume mensajería de dispositivos IoT. Expone además el facade `PerfilesFacade`, agregado para que otros bounded contexts (Comunicaciones, y más adelante Telemetría) resuelvan al cuidador principal de un hogar sin acceder directamente al aggregate `HomeProfile`, dado que `accountId` por sí solo no identifica quién es el responsable vigente de notificaciones.

| Propiedad | Valor |
| --- | --- |
| Nombre | ProfileController |
| Categoría | Controller |
| Propósito | Exponer la consulta y la actualización del perfil genérico de un titular de cuenta. |
| Aggregate/Entity relacionado | Profile |
| Ruta base | /api/v1/profiles |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| getProfileById | /{profileId} (GET) | path: profileId: Long | Obtiene el detalle de un perfil | GetProfileByIdQuery |
| getProfileByAccountId | /by-account/{accountId} (GET) | path: accountId: Long | Obtiene el perfil asociado a una cuenta | GetProfileByAccountIdQuery |
| updatePersonalData | /{profileId} (PUT) | path: profileId: Long; body: UpdateProfilePersonalDataResource { name: String } | Actualiza los datos personales del perfil | UpdateProfilePersonalDataCommand |
| updatePhoto | /{profileId}/photo (POST) | path: profileId: Long; body: UpdateProfilePhotoResource { photoUrl: String } | Actualiza la foto de perfil subida a Cloudinary | UpdateProfilePhotoCommand |
| updateCommunicationPreferences | /{profileId}/preferences (PUT) | path: profileId: Long; body: UpdateCommunicationPreferencesResource { preferredChannel: String } | Actualiza el canal de comunicación preferido | UpdateCommunicationPreferencesCommand |

| Propiedad | Valor |
| --- | --- |
| Nombre | HomeProfileController |
| Categoría | Controller |
| Propósito | Exponer la creación, la consulta y la actualización del perfil de hogar de la persona asistida. |
| Aggregate/Entity relacionado | HomeProfile |
| Ruta base | /api/v1/home-profiles |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| createHomeProfile | / (POST) | body: CreateHomeProfileResource { accountId: Long, assistedPersonName: String, address: String, latitude: Double, longitude: Double } | Crea el perfil de hogar y asigna al creador como cuidador principal | CreateHomeProfileCommand |
| getHomeProfileById | /{homeProfileId} (GET) | path: homeProfileId: Long | Obtiene el detalle del perfil de hogar | GetHomeProfileByIdQuery |
| updateHomeProfile | /{homeProfileId} (PUT) | path: homeProfileId: Long; body: UpdateHomeProfileResource { assistedPersonName: String, address: String, latitude: Double, longitude: Double } | Actualiza los datos o la ubicación del perfil de hogar | UpdateHomeProfileCommand |

| Nombre | Métodos expuestos | Propósito |
| --- | --- | --- |
| PerfilesFacade | getPrincipalCaregiverAccountId(homeProfileId: Long): Long | Permite que otros bounded contextos resuelvan el accountId del cuidador principal vigente de un hogar sin acceder directamente al aggregate HomeProfile. |

### 5.3.3. Application Layer

La Application Layer traduce cada Command y Query de la Domain Layer en un handler dedicado, y resuelve mediante Event Handlers las cuatro integraciones entrantes identificadas en el Canvas y en las Observaciones Previas: la creación de cuenta en IAM, la actualización de empleados en Capital Humano, la actualización de administradores en Gestión del Negocio, y el reemplazo de cuidador principal en Cuidado.

**AccountRegisteredEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | AccountRegisteredEventHandler |
| Categoría | Event Handler |
| Propósito | Inicializar el perfil genérico de un titular al crearse su cuenta en IAM. |
| Command/Query/Evento que maneja | AccountRegistered (evento externo, BC de origen: IAM, ver 5.1.1) |
| Repositorios y servicios que usa | InitializeProfileCommand (invocado internamente) |
| Eventos que publica | ProfileInitialized (vía el command invocado) |
| User story/capability que habilita | Decisión de negocio del Canvas: "el perfil se inicializa automáticamente al crearse una cuenta" |

**EmployeeUpdatedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | EmployeeUpdatedEventHandler |
| Categoría | Event Handler |
| Propósito | Inicializar o refrescar el perfil genérico de un empleado al actualizarse su registro en Capital Humano. |
| Command/Query/Evento que maneja | EmployeeUpdated (evento externo, BC de origen: Capital Humano, a formalizar en 5.4) |
| Repositorios y servicios que usa | InitializeProfileCommand (invocado internamente) |
| Eventos que publica | ProfileInitialized (vía el command invocado) |
| User story/capability que habilita | Comunicación Entrante del Canvas: "BC Capital Humano (empleado actualizado)" |

**BusinessAdministratorUpdatedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | BusinessAdministratorUpdatedEventHandler |
| Categoría | Event Handler |
| Propósito | Inicializar o refrescar el perfil genérico de un administrador al actualizarse su registro en Gestión del Negocio. |
| Command/Query/Evento que maneja | BusinessAdministratorUpdated (evento externo, BC de origen: Gestión del Negocio, ver 5.2.1) |
| Repositorios y servicios que usa | InitializeProfileCommand (invocado internamente) |
| Eventos que publica | ProfileInitialized (vía el command invocado) |
| User story/capability que habilita | Resuelve la observación previa #3 de Gestión del Negocio (5.2) |

**PrincipalCaregiverReplacedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | PrincipalCaregiverReplacedEventHandler |
| Categoría | Event Handler |
| Propósito | Mantener sincronizado el cuidador principal del perfil de hogar cuando Cuidado registra su reemplazo. |
| Command/Query/Evento que maneja | PrincipalCaregiverReplaced (evento externo, BC de origen: Cuidado, a formalizar en 5.5) |
| Repositorios y servicios que usa | ReplacePrincipalCaregiverCommand (invocado internamente) |
| Eventos que publica | PrincipalCaregiverAssigned (vía el command invocado) |
| User story/capability que habilita | Resuelve la observación previa #4 (gap de sincronización con Cuidado) |

**InitializeProfileCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | InitializeProfileCommandHandler |
| Categoría | Command Handler |
| Propósito | Crear el perfil si no existe, o refrescar sus datos básicos si ya existe (operación idempotente). |
| Command/Query/Evento que maneja | InitializeProfileCommand |
| Repositorios y servicios que usa | ProfileRepository |
| Eventos que publica | ProfileInitialized |
| User story/capability que habilita | Decisión de negocio del Canvas: inicialización automática del perfil |

**UpdateProfilePersonalDataCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | UpdateProfilePersonalDataCommandHandler |
| Categoría | Command Handler |
| Propósito | Actualizar los datos personales de un perfil a solicitud de su propio titular. |
| Command/Query/Evento que maneja | UpdateProfilePersonalDataCommand |
| Repositorios y servicios que usa | ProfileRepository |
| Eventos que publica | ProfilePersonalDataUpdated |
| User story/capability que habilita | Resuelve la observación previa #3 |

**UpdateProfilePhotoCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | UpdateProfilePhotoCommandHandler |
| Categoría | Command Handler |
| Propósito | Subir la nueva foto de perfil a Cloudinary y actualizar la referencia en el perfil. |
| Command/Query/Evento que maneja | UpdateProfilePhotoCommand |
| Repositorios y servicios que usa | ProfileRepository, PhotoStorageGateway |
| Eventos que publica | ProfilePhotoUpdated |
| User story/capability que habilita | Decisión de negocio del Canvas: "toda foto de perfil se almacena en Cloudinary" |

**UpdateCommunicationPreferencesCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | UpdateCommunicationPreferencesCommandHandler |
| Categoría | Command Handler |
| Propósito | Actualizar el canal de comunicación preferido del titular del perfil. |
| Command/Query/Evento que maneja | UpdateCommunicationPreferencesCommand |
| Repositorios y servicios que usa | ProfileRepository |
| Eventos que publica | CommunicationPreferencesUpdated |
| User story/capability que habilita | Derivado del Bounded Context Canvas 4.2.4 |

**CreateHomeProfileCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | CreateHomeProfileCommandHandler |
| Categoría | Command Handler |
| Propósito | Geocodificar la dirección del hogar mediante Google Maps, validar que el Cuidador creador no sea ya principal de otro HomeProfile (observación previa #2) y crear el perfil de hogar. |
| Command/Query/Evento que maneja | CreateHomeProfileCommand |
| Repositorios y servicios que usa | HomeProfileRepository, GeocodingService |
| Eventos que publica | HomeProfileCreated, PrincipalCaregiverAssigned |
| User story/capability que habilita | Resuelve la observación previa #2 |

**UpdateHomeProfileCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | UpdateHomeProfileCommandHandler |
| Categoría | Command Handler |
| Propósito | Actualizar los datos de la persona asistida o regeocodificar su ubicación cuando la dirección cambia. |
| Command/Query/Evento que maneja | UpdateHomeProfileCommand |
| Repositorios y servicios que usa | HomeProfileRepository, GeocodingService |
| Eventos que publica | HomeProfileUpdated |
| User story/capability que habilita | Derivado del Bounded Context Canvas 4.2.4 |

**ReplacePrincipalCaregiverCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | ReplacePrincipalCaregiverCommandHandler |
| Categoría | Command Handler |
| Propósito | Reemplazar el cuidador principal vigente de un perfil de hogar. |
| Command/Query/Evento que maneja | ReplacePrincipalCaregiverCommand |
| Repositorios y servicios que usa | HomeProfileRepository |
| Eventos que publica | PrincipalCaregiverAssigned |
| User story/capability que habilita | Resuelve la observación previa #4 (invocado únicamente por PrincipalCaregiverReplacedEventHandler) |

**GetProfileByIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetProfileByIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el detalle de un perfil por su identificador. |
| Command/Query/Evento que maneja | GetProfileByIdQuery |
| Repositorios y servicios que usa | ProfileRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getProfileById |

**GetProfileByAccountIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetProfileByAccountIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el perfil asociado a una cuenta de IAM. |
| Command/Query/Evento que maneja | GetProfileByAccountIdQuery |
| Repositorios y servicios que usa | ProfileRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getProfileByAccountId |

**GetHomeProfileByIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetHomeProfileByIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el detalle de un perfil de hogar, incluyendo su ubicación y su cuidador principal. |
| Command/Query/Evento que maneja | GetHomeProfileByIdQuery |
| Repositorios y servicios que usa | HomeProfileRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getHomeProfileById |

**PerfilesFacadeImpl**

| Propiedad | Valor |
| --- | --- |
| Nombre | PerfilesFacadeImpl |
| Categoría | Facade Implementation |
| Propósito | Implementar PerfilesFacade resolviendo el cuidador principal vigente a partir del aggregate HomeProfile. |
| Command/Query/Evento que maneja | No aplica (no despacha Commands/Queries; delega en HomeProfileRepository) |
| Repositorios y servicios que usa | HomeProfileRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Usado por Comunicaciones (5.8) para resolver al destinatario de PaymentPreauthorizationRejected |

### 5.3.4. Infrastructure Layer

La Infrastructure Layer implementa los repositorios de Profile y HomeProfile sobre PostgreSQL, consistente con el carácter transaccional y estructurado de los datos de perfil, y los adaptadores hacia Cloudinary y Google Maps, además del suscriptor del bus de eventos interno que conecta a Perfiles con IAM, Capital Humano, Gestión del Negocio y Cuidado.

| Nombre | Interfaz que implementa | Tecnología | Propósito |
| --- | --- | --- | --- |
| ProfileRepositoryJpa | ProfileRepository | Spring Data JPA sobre PostgreSQL | Persiste y recupera el aggregate Profile. |
| HomeProfileRepositoryJpa | HomeProfileRepository | Spring Data JPA sobre PostgreSQL | Persiste y recupera el aggregate HomeProfile. |

La persistencia se configura mediante `ProfileJpaConfiguration`, que habilita los repositorios Spring Data JPA (`@EnableJpaRepositories`) y el mapeo objeto-relacional de `Profile` y `HomeProfile` sobre el motor PostgreSQL.

| Nombre | Categoría | Interfaz que implementa | Servicio externo | Propósito |
| --- | --- | --- | --- | --- |
| CloudinaryPhotoGateway | Gateway | PhotoStorageGateway | Cloudinary | Sube y gestiona las fotos de perfil. |
| GoogleMapsGeocodingAdapter | Gateway | GeocodingService | Google Maps | Geocodifica la dirección del hogar al crear o actualizar un HomeProfile. |
| DomainEventBusSubscriber | Event Subscriber | AccountRegisteredListener, EmployeeUpdatedListener, BusinessAdministratorUpdatedListener, PrincipalCaregiverReplacedListener | Bus de eventos interno del monolito modular (Spring Application Events) | Enruta los eventos publicados por IAM, Capital Humano, Gestión del Negocio y Cuidado hacia los Event Handlers de Perfiles. |

| Tabla/Colección | Propósito |
| --- | --- |
| profiles | Almacena el aggregate Profile: datos personales, foto y preferencias de comunicación del titular de cualquier cuenta. |
| home_profiles | Almacena el aggregate HomeProfile: datos de la persona asistida, ubicación geocodificada y cuidador principal vigente. |

| Objeto | BC responsable | Justificación |
| --- | --- | --- |
| Cuenta / credenciales | IAM | La autenticación y el estado de acceso de la cuenta son responsabilidad de IAM; Perfiles solo referencia accountId vía Shared Kernel (Context Mapping 4.2.5). |
| Membresía de cuidadores (principal/autorizado, invitación) | Cuidado | La invitación, vinculación y desvinculación de cuidadores es responsabilidad de Cuidado; Perfiles solo refleja al cuidador principal vigente mediante PrincipalCaregiverReplacedEventHandler (observación previa #4). |
| Contrato laboral | Capital Humano | El ciclo de vida del contrato es responsabilidad de Capital Humano; Perfiles solo refresca los datos básicos del empleado al recibir EmployeeUpdated. |
| Perfil del negocio | Gestión del Negocio | El registro del negocio y sus administradores es responsabilidad de Gestión del Negocio; Perfiles solo refresca los datos básicos del administrador al recibir BusinessAdministratorUpdated. |

**Verificación de trazabilidad — Perfiles**

| Criterio | Cumple | Evidencia |
| --- | --- | --- |
| Todo Command/Query usado en un endpoint o consumer existe en Domain y tiene su handler en Application | Sí | Los 7 commands y las 3 queries de 5.3.1 tienen su handler correspondiente en 5.3.3. |
| Todo Command/Query declarado en Domain es usado por algún endpoint, consumer o event handler (o se justifica) | Sí | InitializeProfileCommand y ReplacePrincipalCaregiverCommand se usan exclusivamente desde Event Handlers (justificado en 5.3.2); el resto se usa desde los endpoints de ProfileController y HomeProfileController. |
| Los parámetros de cada endpoint cubren los parámetros del Command/Query que despacha | Sí | Cada Resource de las tablas de endpoints (5.3.2) mapea 1:1 los parámetros del Command correspondiente. |
| Todo controller está relacionado con un aggregate o entity existente en la Domain Layer | Sí | ProfileController se relaciona con Profile; HomeProfileController se relaciona con HomeProfile. |
| Toda interfaz de repositorio del Domain tiene implementación en Infrastructure, y viceversa | Sí | ProfileRepository ↔ ProfileRepositoryJpa; HomeProfileRepository ↔ HomeProfileRepositoryJpa. |
| Todo Domain Event publicado tiene al menos un handler o consumidor identificado (en este u otro BC) | Sí, con justificación | Ninguno de los 7 Domain Events de Perfiles tiene un consumidor externo declarado en el Canvas (4.2.4); se publican para auditoría y futuras integraciones (ver nota en 5.3.1), sin dejar incompleto ningún flujo de este bounded context. |
| Ningún aggregate de este BC es aggregate root en otro BC | Sí | Profile y HomeProfile son exclusivos de este bounded context. |
| Ninguna clase de Domain depende de Infrastructure ni de frameworks | Sí | PhotoStorageGateway y GeocodingService se declaran como puertos en Domain; sus implementaciones concretas (CloudinaryPhotoGateway, GoogleMapsGeocodingAdapter) están en Infrastructure (5.3.4). |

### 5.3.5. Bounded Context Software Architecture Component Level Diagrams

### 5.3.6. Bounded Context Software Architecture Code Level Diagrams

#### 5.3.6.1. Bounded Context Domain Layer Class Diagrams

#### 5.3.6.2. Bounded Context Database Design Diagram

<div style="page-break-after: always;"></div>

## 5.4. Bounded Context: Capital Humano

El bounded context **Capital Humano** gestiona el alta y la baja de empleados, y el ciclo de vida de sus contratos laborales: registro, renovación, suspensión y culminación. Es un subdominio de soporte con rol de contexto de ejecución. El único actor que participa es el **Administrador**, quien da de alta y despide empleados, y registra, renueva o suspende contratos. Este bounded context cierra un round-trip con IAM: al dar de alta a un empleado publica `EmployeeRegistered`, que IAM consume para crear su cuenta (5.1); al crearse esa cuenta, IAM publica `AccountRegistered`, que Capital Humano consume para registrar automáticamente el contrato (observación previa #1). También publica `EmployeeUpdated`, consumido por Perfiles para inicializar su perfil (5.3).

### 5.4.1. Domain Layer

La Domain Layer de Capital Humano modela dos aggregates independientes, fieles al EventStorming de Paso 10: `Employee`, que representa al empleado contratado, y `Contract`, que representa su acuerdo laboral. Ambos tienen ciclos de vida con estados propios y no sincronizados entre sí (observación previa #2).

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| Employee | Aggregate Root | Representa a la persona contratada que trabaja para el negocio. No permite operaciones de negocio una vez despedido (estado terminal DISMISSED); su suspensión es independiente del estado de sus contratos (observación previa #2). Retiene los términos de su contrato inicial hasta que IAM confirme la creación de la cuenta, momento en el que se emite el Contract correspondiente (observación previa #1). |
| Contract | Aggregate Root | Representa el acuerdo laboral de un empleado, referenciado mediante employeeId. No permite renovarse ni suspenderse una vez culminado (estado terminal CULMINATED); su ciclo de vida no se sincroniza automáticamente con el estado del Employee asociado (observación previa #2 y #4). |

No se identifican Entities en este bounded context: tanto `Employee` como `Contract` son aggregates simples sin componentes internos con identidad propia.

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| EmployeeId | Value Object | Identificador tipado del aggregate Employee; no admite valores nulos ni negativos. |
| ContractId | Value Object | Identificador tipado del aggregate Contract; no admite valores nulos ni negativos. |
| Email | Value Object | Dirección de correo electrónico del empleado; valida el formato y no admite valores vacíos o mal formados. Es un value object propio de este bounded context, sin acoplarse al Email de IAM (no existe Shared Kernel declarado entre ambos en el Context Mapping). |
| PhoneNumber | Value Object | Número de contacto del empleado; valida el formato del número registrado. |
| ContractTerms | Value Object | Condiciones del contrato: fecha de inicio, fecha de término (nula para contratos indefinidos) y puesto; no admite una fecha de término anterior a la fecha de inicio. |

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| EmployeeStatus | Enum | Estado del empleado. Transiciones permitidas: `ACTIVE` → `SUSPENDED` al suspenderse temporalmente su actividad; `SUSPENDED` → `ACTIVE` al reactivarse; `ACTIVE`/`SUSPENDED` → `DISMISSED` al despedirse, estado terminal que revoca su acceso en IAM (5.1) y no admite ninguna transición posterior. |
| ContractStatus | Enum | Estado del contrato. Transiciones permitidas: `ACTIVE` → `SUSPENDED` al suspenderse; `SUSPENDED` → `ACTIVE` al reactivarse; `ACTIVE`/`SUSPENDED` → `CULMINATED` al culminarse, estado terminal que no admite ninguna transición posterior. No está acoplado al EmployeeStatus del Employee referenciado (observación previa #2). |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| CreateEmployeeCommand | Da de alta a un nuevo empleado en estado ACTIVE, capturando además los términos de su contrato inicial, que quedan a la espera de que IAM confirme la creación de la cuenta (observación previa #1). | name: String, email: String, phone: String, startDate: LocalDate, endDate: LocalDate, position: String |
| UpdateEmployeeInfoCommand | Actualiza los datos básicos de contacto del empleado. | employeeId: Long, name: String, email: String, phone: String |
| SuspendEmployeeCommand | Suspende temporalmente la actividad del empleado. | employeeId: Long, reason: String |
| ReactivateEmployeeCommand | Reactiva a un empleado previamente suspendido. | employeeId: Long |
| DismissEmployeeCommand | Despide al empleado, llevándolo a su estado terminal DISMISSED. | employeeId: Long, reason: String |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| RegisterContractCommand | Registra un nuevo contrato para un empleado, de forma manual por el Administrador o automática al crearse su cuenta en IAM (observación previa #1). | employeeId: Long, startDate: LocalDate, endDate: LocalDate, position: String |
| RenewContractCommand | Renueva el contrato, extendiendo su fecha de término. | contractId: Long, newEndDate: LocalDate |
| SuspendContractCommand | Suspende el contrato. | contractId: Long, reason: String |
| ReactivateContractCommand | Reactiva un contrato previamente suspendido. | contractId: Long |
| CulminateContractCommand | Culmina el contrato, llevándolo a su estado terminal CULMINATED. | contractId: Long |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| GetEmployeeByIdQuery | Obtiene el detalle de un empleado. | employeeId: Long |
| GetContractByIdQuery | Obtiene el detalle de un contrato. | contractId: Long |
| GetContractsByEmployeeIdQuery | Lista los contratos de un empleado. | employeeId: Long |

Los eventos `EmployeeRegistered`, `EmployeeUpdated` y `EmployeeTerminated` reutilizan los nombres ya comprometidos como integraciones entrantes en 5.1 (IAM) y 5.3 (Perfiles); el resto no tiene un consumidor externo declarado en el Canvas (4.2.4) y se publica para auditoría y futuras integraciones.

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| EmployeeRegistered | Se publica al darse de alta un empleado; es consumido por `EmployeeRegisteredEventHandler` de IAM (5.1.3) para crear su cuenta. | employeeId: Long, name: String, email: String, phone: String, registeredAt: LocalDateTime |
| EmployeeUpdated | Se publica al darse de alta o actualizarse los datos básicos de un empleado; es consumido por `EmployeeUpdatedEventHandler` de Perfiles (5.3.3) para inicializar o refrescar su perfil. | employeeId: Long, name: String, email: String, phone: String, updatedAt: LocalDateTime |
| EmployeeSuspended | Se publica al suspenderse temporalmente la actividad de un empleado. | employeeId: Long, reason: String, suspendedAt: LocalDateTime |
| EmployeeReactivated | Se publica al reactivarse un empleado suspendido. | employeeId: Long, reactivatedAt: LocalDateTime |
| EmployeeTerminated | Se publica al despedirse un empleado; es consumido por `EmployeeTerminatedEventHandler` de IAM (5.1.3) para revocar su acceso. | employeeId: Long, reason: String, terminatedAt: LocalDateTime |
| ContractRegistered | Se publica al registrarse un nuevo contrato. | contractId: Long, employeeId: Long, startDate: LocalDate, endDate: LocalDate, position: String, registeredAt: LocalDateTime |
| ContractRenewed | Se publica al renovarse un contrato. | contractId: Long, newEndDate: LocalDate, renewedAt: LocalDateTime |
| ContractSuspended | Se publica al suspenderse un contrato. | contractId: Long, reason: String, suspendedAt: LocalDateTime |
| ContractReactivated | Se publica al reactivarse un contrato suspendido. | contractId: Long, reactivatedAt: LocalDateTime |
| ContractCulminated | Se publica al culminarse un contrato. | contractId: Long, culminatedAt: LocalDateTime |

No se declaran Factories ni Domain Services en este bounded context: `Employee` y `Contract` son aggregates independientes que solo se referencian por identificador (employeeId). La validación de que el empleado referenciado exista y esté activo al registrar un contrato se resuelve en `RegisterContractCommandHandler` mediante `EmployeeRepository`, sin requerir un Domain Service.

| Nombre | Aggregate que gestiona | Descripción |
| --- | --- | --- |
| EmployeeRepository | Employee | Persiste y recupera el aggregate Employee. |
| ContractRepository | Contract | Persiste y recupera el aggregate Contract; expone la búsqueda por employeeId para listar los contratos de un empleado. |

| Clase origen | Relación | Clase destino | Descripción |
| --- | --- | --- | --- |
| Contract | asociación | Employee | Contract referencia a su empleado mediante employeeId; son aggregates independientes, sin composición. |
| EmployeeRepository | depende de | Employee | El repositorio persiste y recupera el aggregate Employee. |
| ContractRepository | depende de | Contract | El repositorio persiste y recupera el aggregate Contract. |

### 5.4.2. Interface Layer

La Interface Layer expone dos controllers independientes, uno por cada aggregate root: `EmployeeController` y `ContractController`. Ninguno expone `RegisterContractCommand` como su único origen, ya que también puede invocarse manualmente por el Administrador (ver endpoint registerContract) o automáticamente desde un Event Handler (5.4.3). Este bounded context no consume mensajería de dispositivos IoT y no expone un facade/ACL: ningún otro bounded context consume a Capital Humano de forma síncrona según el Context Mapping (4.2.5); sus integraciones salientes se resuelven mediante Domain Events hacia IAM y Perfiles.

| Propiedad | Valor |
| --- | --- |
| Nombre | EmployeeController |
| Categoría | Controller |
| Propósito | Exponer el alta, la actualización, la suspensión, la reactivación y el despido de empleados. |
| Aggregate/Entity relacionado | Employee |
| Ruta base | /api/v1/employees |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| createEmployee | / (POST) | body: CreateEmployeeResource { name: String, email: String, phone: String, startDate: LocalDate, endDate: LocalDate, position: String } | Da de alta a un nuevo empleado junto con los términos de su contrato inicial | CreateEmployeeCommand |
| getEmployeeById | /{employeeId} (GET) | path: employeeId: Long | Obtiene el detalle de un empleado | GetEmployeeByIdQuery |
| updateEmployeeInfo | /{employeeId} (PUT) | path: employeeId: Long; body: UpdateEmployeeInfoResource { name: String, email: String, phone: String } | Actualiza los datos básicos del empleado | UpdateEmployeeInfoCommand |
| suspendEmployee | /{employeeId}/suspend (POST) | path: employeeId: Long; body: SuspendEmployeeResource { reason: String } | Suspende temporalmente al empleado | SuspendEmployeeCommand |
| reactivateEmployee | /{employeeId}/reactivate (POST) | path: employeeId: Long | Reactiva a un empleado suspendido | ReactivateEmployeeCommand |
| dismissEmployee | /{employeeId}/dismiss (POST) | path: employeeId: Long; body: DismissEmployeeResource { reason: String } | Despide al empleado | DismissEmployeeCommand |

| Propiedad | Valor |
| --- | --- |
| Nombre | ContractController |
| Categoría | Controller |
| Propósito | Exponer el registro, la renovación, la suspensión, la reactivación y la culminación de contratos. |
| Aggregate/Entity relacionado | Contract |
| Ruta base | /api/v1/contracts |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| registerContract | / (POST) | body: RegisterContractResource { employeeId: Long, startDate: LocalDate, endDate: LocalDate, position: String } | Registra un nuevo contrato para el empleado | RegisterContractCommand |
| getContractById | /{contractId} (GET) | path: contractId: Long | Obtiene el detalle de un contrato | GetContractByIdQuery |
| getContractsByEmployee | /by-employee/{employeeId} (GET) | path: employeeId: Long | Lista los contratos de un empleado | GetContractsByEmployeeIdQuery |
| renewContract | /{contractId}/renew (POST) | path: contractId: Long; body: RenewContractResource { newEndDate: LocalDate } | Renueva el contrato | RenewContractCommand |
| suspendContract | /{contractId}/suspend (POST) | path: contractId: Long; body: SuspendContractResource { reason: String } | Suspende el contrato | SuspendContractCommand |
| reactivateContract | /{contractId}/reactivate (POST) | path: contractId: Long | Reactiva un contrato suspendido | ReactivateContractCommand |
| culminateContract | /{contractId}/culminate (POST) | path: contractId: Long | Culmina el contrato | CulminateContractCommand |

### 5.4.3. Application Layer

La Application Layer traduce cada Command y Query de la Domain Layer en un handler dedicado, y resuelve mediante un Event Handler la integración entrante identificada en la observación previa #1: el registro automático del contrato al crearse la cuenta del empleado en IAM.

**AccountRegisteredEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | AccountRegisteredEventHandler |
| Categoría | Event Handler |
| Propósito | Localizar al empleado por el correo recibido en el evento, y registrar automáticamente su contrato usando los términos capturados en CreateEmployeeCommand, conforme a la decisión de negocio del Canvas: "al crearse la cuenta del empleado se registra su contrato". |
| Command/Query/Evento que maneja | AccountRegistered (evento externo, BC de origen: IAM, ver 5.1.1) |
| Repositorios y servicios que usa | EmployeeRepository (para localizar al empleado por correo), RegisterContractCommand (invocado internamente) |
| Eventos que publica | ContractRegistered (vía el command invocado) |
| User story/capability que habilita | Resuelve la observación previa #1 |

**CreateEmployeeCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | CreateEmployeeCommandHandler |
| Categoría | Command Handler |
| Propósito | Dar de alta al empleado en estado ACTIVE, reteniendo los términos de su contrato inicial hasta que IAM confirme la creación de la cuenta. |
| Command/Query/Evento que maneja | CreateEmployeeCommand |
| Repositorios y servicios que usa | EmployeeRepository |
| Eventos que publica | EmployeeRegistered, EmployeeUpdated |
| User story/capability que habilita | Decisión de negocio del Canvas; resuelve la observación previa #3 (EmployeeUpdated hacia Perfiles) |

**UpdateEmployeeInfoCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | UpdateEmployeeInfoCommandHandler |
| Categoría | Command Handler |
| Propósito | Actualizar los datos básicos de contacto de un empleado. |
| Command/Query/Evento que maneja | UpdateEmployeeInfoCommand |
| Repositorios y servicios que usa | EmployeeRepository |
| Eventos que publica | EmployeeUpdated |
| User story/capability que habilita | Resuelve la observación previa #3 |

**SuspendEmployeeCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | SuspendEmployeeCommandHandler |
| Categoría | Command Handler |
| Propósito | Suspender temporalmente la actividad de un empleado, sin afectar el estado de sus contratos (observación previa #2). |
| Command/Query/Evento que maneja | SuspendEmployeeCommand |
| Repositorios y servicios que usa | EmployeeRepository |
| Eventos que publica | EmployeeSuspended |
| User story/capability que habilita | Resuelve la observación previa #2 |

**ReactivateEmployeeCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | ReactivateEmployeeCommandHandler |
| Categoría | Command Handler |
| Propósito | Reactivar a un empleado previamente suspendido. |
| Command/Query/Evento que maneja | ReactivateEmployeeCommand |
| Repositorios y servicios que usa | EmployeeRepository |
| Eventos que publica | EmployeeReactivated |
| User story/capability que habilita | Derivado del Bounded Context Canvas 4.2.4 |

**DismissEmployeeCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | DismissEmployeeCommandHandler |
| Categoría | Command Handler |
| Propósito | Despedir al empleado, llevándolo a su estado terminal DISMISSED, sin culminar automáticamente sus contratos (observación previa #4). |
| Command/Query/Evento que maneja | DismissEmployeeCommand |
| Repositorios y servicios que usa | EmployeeRepository |
| Eventos que publica | EmployeeTerminated |
| User story/capability que habilita | Resuelve la observación previa #4; consumido por EmployeeTerminatedEventHandler de IAM (5.1.3) |

**RegisterContractCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RegisterContractCommandHandler |
| Categoría | Command Handler |
| Propósito | Validar que el empleado exista y esté ACTIVE, y registrar su contrato con los términos provistos, ya sea de forma manual (Administrador) o automática (AccountRegisteredEventHandler). |
| Command/Query/Evento que maneja | RegisterContractCommand |
| Repositorios y servicios que usa | ContractRepository, EmployeeRepository |
| Eventos que publica | ContractRegistered |
| User story/capability que habilita | Decisión de negocio del Canvas; resuelve la observación previa #1 |

**RenewContractCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RenewContractCommandHandler |
| Categoría | Command Handler |
| Propósito | Extender la fecha de término de un contrato vigente. |
| Command/Query/Evento que maneja | RenewContractCommand |
| Repositorios y servicios que usa | ContractRepository |
| Eventos que publica | ContractRenewed |
| User story/capability que habilita | Derivado del Bounded Context Canvas 4.2.4 |

**SuspendContractCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | SuspendContractCommandHandler |
| Categoría | Command Handler |
| Propósito | Suspender un contrato, sin afectar el estado del Employee asociado (observación previa #2). |
| Command/Query/Evento que maneja | SuspendContractCommand |
| Repositorios y servicios que usa | ContractRepository |
| Eventos que publica | ContractSuspended |
| User story/capability que habilita | Resuelve la observación previa #2 |

**ReactivateContractCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | ReactivateContractCommandHandler |
| Categoría | Command Handler |
| Propósito | Reactivar un contrato previamente suspendido. |
| Command/Query/Evento que maneja | ReactivateContractCommand |
| Repositorios y servicios que usa | ContractRepository |
| Eventos que publica | ContractReactivated |
| User story/capability que habilita | Derivado del Bounded Context Canvas 4.2.4 |

**CulminateContractCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | CulminateContractCommandHandler |
| Categoría | Command Handler |
| Propósito | Culminar un contrato, llevándolo a su estado terminal, independientemente del estado del Employee asociado (observación previa #4). |
| Command/Query/Evento que maneja | CulminateContractCommand |
| Repositorios y servicios que usa | ContractRepository |
| Eventos que publica | ContractCulminated |
| User story/capability que habilita | Resuelve la observación previa #4 |

**GetEmployeeByIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetEmployeeByIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el detalle de un empleado. |
| Command/Query/Evento que maneja | GetEmployeeByIdQuery |
| Repositorios y servicios que usa | EmployeeRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getEmployeeById |

**GetContractByIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetContractByIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el detalle de un contrato. |
| Command/Query/Evento que maneja | GetContractByIdQuery |
| Repositorios y servicios que usa | ContractRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getContractById |

**GetContractsByEmployeeIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetContractsByEmployeeIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Listar los contratos de un empleado. |
| Command/Query/Evento que maneja | GetContractsByEmployeeIdQuery |
| Repositorios y servicios que usa | ContractRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getContractsByEmployee |

### 5.4.4. Infrastructure Layer

La Infrastructure Layer implementa los repositorios de Employee y Contract sobre PostgreSQL, consistente con el carácter transaccional y estructurado de los datos de personal, y el suscriptor del bus de eventos interno que conecta a Capital Humano con IAM.

| Nombre | Interfaz que implementa | Tecnología | Propósito |
| --- | --- | --- | --- |
| EmployeeRepositoryJpa | EmployeeRepository | Spring Data JPA sobre PostgreSQL | Persiste y recupera el aggregate Employee. |
| ContractRepositoryJpa | ContractRepository | Spring Data JPA sobre PostgreSQL | Persiste y recupera el aggregate Contract. |

La persistencia se configura mediante `EmployeeJpaConfiguration`, que habilita los repositorios Spring Data JPA (`@EnableJpaRepositories`) y el mapeo objeto-relacional de `Employee` y `Contract` sobre el motor PostgreSQL.

| Nombre | Categoría | Interfaz que implementa | Servicio externo | Propósito |
| --- | --- | --- | --- | --- |
| DomainEventBusSubscriber | Event Subscriber | AccountRegisteredListener | Bus de eventos interno del monolito modular (Spring Application Events) | Enruta el evento AccountRegistered publicado por IAM hacia AccountRegisteredEventHandler (observación previa #1). |

| Tabla/Colección | Propósito |
| --- | --- |
| employees | Almacena el aggregate Employee: datos de contacto, estado y términos del contrato inicial pendiente. |
| contracts | Almacena el aggregate Contract: términos, estado y referencia al empleado (employeeId). |

| Objeto | BC responsable | Justificación |
| --- | --- | --- |
| Cuenta / credenciales | IAM | La creación y la autenticación de la cuenta del empleado son responsabilidad exclusiva de IAM, consumiendo EmployeeRegistered (observación previa, resuelto en 5.1). |
| Perfil del empleado | Perfiles | El perfil detallado del empleado (foto, preferencias) se gestiona en Perfiles al consumir EmployeeUpdated (observación previa #3, resuelto en 5.3). |

**Verificación de trazabilidad — Capital Humano**

| Criterio | Cumple | Evidencia |
| --- | --- | --- |
| Todo Command/Query usado en un endpoint o consumer existe en Domain y tiene su handler en Application | Sí | Los 10 commands y las 3 queries de 5.4.1 tienen su handler correspondiente en 5.4.3. |
| Todo Command/Query declarado en Domain es usado por algún endpoint, consumer o event handler (o se justifica) | Sí | RegisterContractCommand se usa tanto desde el endpoint manual como desde AccountRegisteredEventHandler (observación previa #1); el resto se usa desde los endpoints de EmployeeController y ContractController. |
| Los parámetros de cada endpoint cubren los parámetros del Command/Query que despacha | Sí | Cada Resource de las tablas de endpoints (5.4.2) mapea 1:1 los parámetros del Command correspondiente. |
| Todo controller está relacionado con un aggregate o entity existente en la Domain Layer | Sí | EmployeeController se relaciona con Employee; ContractController se relaciona con Contract. |
| Toda interfaz de repositorio del Domain tiene implementación en Infrastructure, y viceversa | Sí | EmployeeRepository ↔ EmployeeRepositoryJpa; ContractRepository ↔ ContractRepositoryJpa. |
| Todo Domain Event publicado tiene al menos un handler o consumidor identificado (en este u otro BC) | Sí, con justificación | EmployeeRegistered y EmployeeTerminated los consume IAM (5.1); EmployeeUpdated lo consume Perfiles (5.3); el resto no tiene consumidor externo declarado en el Canvas (4.2.4) y se publica para auditoría. |
| Ningún aggregate de este BC es aggregate root en otro BC | Sí | Employee y Contract son exclusivos de este bounded context. |
| Ninguna clase de Domain depende de Infrastructure ni de frameworks | Sí | Los repositorios se declaran como puertos en Domain; sus implementaciones concretas (EmployeeRepositoryJpa, ContractRepositoryJpa) están en Infrastructure (5.4.4). |

### 5.4.5. Bounded Context Software Architecture Component Level Diagrams

### 5.4.6. Bounded Context Software Architecture Code Level Diagrams

#### 5.4.6.1. Bounded Context Domain Layer Class Diagrams

#### 5.4.6.2. Bounded Context Database Design Diagram

<div style="page-break-after: always;"></div>

## 5.5. Bounded Context: Cuidado

El bounded context **Cuidado** gestiona la red de cuidado de la persona con discapacidad: el registro del familiar responsable y de las labores de cuidado, la invitación y vinculación de cuidadores adicionales, y el seguimiento de horarios y asignaciones cumplidas. A diferencia de los bounded contexts anteriores (soporte o genéricos), Cuidado está clasificado como **dominio núcleo** en el Bounded Context Canvas (4.2.4): es la razón de ser diferenciadora de Alivia. El actor principal es el **Familiar** (el cliente responsable de IAM), quien registra labores de cuidado e invita cuidadores; el **Cuidador** da seguimiento a sus horarios y asignaciones. Este bounded context cierra el compromiso pendiente con Perfiles: publica `PrincipalCaregiverReplaced`, consumido por `PrincipalCaregiverReplacedEventHandler` (5.3.3).

### 5.5.1. Domain Layer

La Domain Layer de Cuidado modela cuatro aggregates independientes, fieles al EventStorming de Paso 10: `FamilyMember`, que representa al familiar responsable de la red de cuidado; `CareTask`, que representa una labor de cuidado asignable; `Invitation`, que representa la solicitud enviada a un cuidador; y `Caregiver`, que representa a un cuidador vinculado a una red de cuidado específica (observación previa #1).

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| FamilyMember | Aggregate Root | Representa al familiar (cliente responsable) que gestiona la red de cuidado de la persona asistida. Referencia su accountId (IAM) y su homeProfileId (Perfiles), pasados como parámetros al registrarse, sin requerir una integración entrante de otro BC. |
| CareTask | Aggregate Root | Representa una labor de cuidado registrada por el Familiar. Toda labor se asigna a un cuidador responsable (decisión de negocio del Canvas), pero puede quedar sin responsable si este es desvinculado (observación previa #2). |
| Invitation | Aggregate Root | Representa la solicitud enviada a un cuidador para vincularse a la red de cuidado. Una vez aceptada o rechazada queda en un estado terminal: una invitación aceptada vincula al cuidador como cuidador adicional; una rechazada no lo vincula (decisiones de negocio del Canvas). |
| Caregiver | Aggregate Root | Representa a un cuidador vinculado a una red de cuidado específica (familyMemberId). No es un aggregate global: un mismo accountId de IAM puede estar vinculado a varios Caregiver independientes, uno por cada red de cuidado a la que fue invitado (observación previa #1). El cuidador principal puede ser reemplazado (decisión de negocio del Canvas). |

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| Schedule | Entity | Representa un turno y horario dentro del ciclo de vida de un Caregiver: un periodo en que tiene asignaciones por cumplir. No admite una hora de término anterior a la hora de inicio. |

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| FamilyMemberId | Value Object | Identificador tipado del aggregate FamilyMember; no admite valores nulos ni negativos. |
| CareTaskId | Value Object | Identificador tipado del aggregate CareTask; no admite valores nulos ni negativos. |
| InvitationId | Value Object | Identificador tipado del aggregate Invitation; no admite valores nulos ni negativos. |
| CaregiverId | Value Object | Identificador tipado del aggregate Caregiver; no admite valores nulos ni negativos. |
| ScheduleId | Value Object | Identificador tipado de un Schedule; no admite valores nulos ni negativos. |
| Email | Value Object | Dirección de correo electrónico del cuidador invitado; valida el formato y no admite valores vacíos o mal formados. Es un value object propio de este bounded context, sin acoplarse al Email de IAM. |
| CareTaskDescription | Value Object | Descripción de la labor de cuidado; no admite valores vacíos. |

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| InvitationStatus | Enum | Estado de la invitación. Transiciones permitidas: `SENT` → `ACCEPTED`, estado terminal que vincula al cuidador como cuidador adicional; `SENT` → `REJECTED`, estado terminal que no vincula al cuidador. Ninguno de los dos estados terminales admite una transición posterior (decisiones de negocio del Canvas). |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| RegisterFamilyMemberCommand | Registra al familiar responsable de una red de cuidado, referenciando su cuenta en IAM y su perfil de hogar en Perfiles. | accountId: Long, homeProfileId: Long, name: String |
| UpdateFamilyMemberInfoCommand | Actualiza el nombre del familiar. | familyMemberId: Long, name: String |
| RegisterCareTaskCommand | Registra una nueva labor de cuidado. | familyMemberId: Long, description: String |
| AssignCareTaskResponsibleCommand | Asigna un cuidador responsable a una labor de cuidado. | careTaskId: Long, caregiverId: Long |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| InviteCaregiverCommand | Envía una invitación a un cuidador para vincularse a la red de cuidado. | familyMemberId: Long, invitedEmail: String |
| AcceptInvitationCommand | Acepta la invitación; el cuidador invitado ya cuenta con un accountId válido en IAM (nuevo o existente) al momento de invocarla (observación previa #3). | invitationId: Long, accountId: Long |
| RejectInvitationCommand | Rechaza la invitación, sin vincular al cuidador. | invitationId: Long |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| CreateCaregiverCommand | Crea al cuidador vinculado a una red de cuidado específica, invocado únicamente por el Event Handler que reacciona a la aceptación de una invitación (observación previa #3). | familyMemberId: Long, accountId: Long, principal: Boolean |
| RegisterScheduleCommand | Registra un nuevo turno y horario para el cuidador. | caregiverId: Long, startTime: LocalDateTime, endTime: LocalDateTime |
| RecordCompletedAssignmentsCommand | Registra el cumplimiento de las asignaciones de un turno. | caregiverId: Long, scheduleId: Long |
| UnlinkCaregiverCommand | Desvincula al cuidador de la red de cuidado. | caregiverId: Long |
| ReplacePrincipalCaregiverCommand | Reemplaza al cuidador principal de una red de cuidado. | familyMemberId: Long, newCaregiverId: Long |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| GetFamilyMemberByIdQuery | Obtiene el detalle de un familiar. | familyMemberId: Long |
| GetCareTasksByFamilyMemberIdQuery | Lista las labores de cuidado de una red de cuidado. | familyMemberId: Long |
| GetInvitationByIdQuery | Obtiene el detalle de una invitación. | invitationId: Long |
| GetCaregiverByIdQuery | Obtiene el detalle de un cuidador, incluyendo sus turnos y horarios. | caregiverId: Long |

Salvo `PrincipalCaregiverReplaced`, ninguno de los siguientes Domain Events tiene un consumidor externo declarado en el Bounded Context Canvas (4.2.4); se publican para auditoría y futuras integraciones.

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| FamilyMemberRegistered | Se publica al registrarse un familiar. | familyMemberId: Long, accountId: Long, homeProfileId: Long, name: String, registeredAt: LocalDateTime |
| FamilyMemberInfoUpdated | Se publica al actualizarse el nombre de un familiar. | familyMemberId: Long, name: String, updatedAt: LocalDateTime |
| CareTaskRegistered | Se publica al registrarse una labor de cuidado. | careTaskId: Long, familyMemberId: Long, description: String, registeredAt: LocalDateTime |
| CareTaskResponsibleAssigned | Se publica al asignarse un cuidador responsable a una labor de cuidado. | careTaskId: Long, caregiverId: Long, assignedAt: LocalDateTime |
| CareTaskUnassigned | Se publica al quedar una labor de cuidado sin responsable, por la desvinculación del cuidador asignado (observación previa #2). | careTaskId: Long, unassignedAt: LocalDateTime |
| CaregiverInvited | Se publica al enviarse una invitación; lo consume `CaregiverInvitedEventHandler` propio para solicitar el envío del correo mediante Sendgrid. | invitationId: Long, familyMemberId: Long, invitedEmail: String, invitedAt: LocalDateTime |
| InvitationAccepted | Se publica al aceptarse una invitación; lo consume `InvitationAcceptedEventHandler` propio para crear al Caregiver (observación previa #3). | invitationId: Long, familyMemberId: Long, accountId: Long, acceptedAt: LocalDateTime |
| InvitationRejected | Se publica al rechazarse una invitación. | invitationId: Long, rejectedAt: LocalDateTime |
| CaregiverCreated | Se publica al crearse un cuidador vinculado a una red de cuidado. | caregiverId: Long, familyMemberId: Long, accountId: Long, principal: Boolean, createdAt: LocalDateTime |
| ScheduleRegistered | Se publica al registrarse un turno y horario. | scheduleId: Long, caregiverId: Long, startTime: LocalDateTime, endTime: LocalDateTime, registeredAt: LocalDateTime |
| CompletedAssignmentsRecorded | Se publica al registrarse el cumplimiento de las asignaciones de un turno. | caregiverId: Long, scheduleId: Long, recordedAt: LocalDateTime |
| CaregiverUnlinked | Se publica al desvincularse un cuidador; lo consume `CaregiverUnlinkedEventHandler` propio para liberar sus labores asignadas (observación previa #2). | caregiverId: Long, unlinkedAt: LocalDateTime |
| PrincipalCaregiverReplaced | Se publica al reemplazarse al cuidador principal; es consumido por `PrincipalCaregiverReplacedEventHandler` de Perfiles (5.3.3), cerrando el compromiso pendiente. | familyMemberId: Long, newCaregiverId: Long, previousCaregiverId: Long, replacedAt: LocalDateTime |

No se declaran Factories ni Domain Services en este bounded context: los cuatro aggregates se referencian solo por identificador. La única regla que involucra a dos aggregates distintos —liberar las CareTask de un Caregiver desvinculado (observación previa #2)— se resuelve en `CaregiverUnlinkedEventHandler` mediante `CareTaskRepository`, ya que es una reacción a un evento y no una colaboración síncrona en el mismo proceso de escritura.

| Nombre | Aggregate que gestiona | Descripción |
| --- | --- | --- |
| FamilyMemberRepository | FamilyMember | Persiste y recupera el aggregate FamilyMember. |
| CareTaskRepository | CareTask | Persiste y recupera el aggregate CareTask; expone la búsqueda por responsibleCaregiverId para resolver la observación previa #2. |
| InvitationRepository | Invitation | Persiste y recupera el aggregate Invitation. |
| CaregiverRepository | Caregiver | Persiste y recupera el aggregate Caregiver; expone la búsqueda por accountId para listar las redes de cuidado que atiende (observación previa #1). |

| Clase origen | Relación | Clase destino | Descripción |
| --- | --- | --- | --- |
| CareTask | asociación | FamilyMember | CareTask referencia a su familiar mediante familyMemberId. |
| CareTask | asociación | Caregiver | CareTask referencia a su cuidador responsable mediante responsibleCaregiverId, nulo si quedó sin asignar (observación previa #2). |
| Invitation | asociación | FamilyMember | Invitation referencia a su familiar mediante familyMemberId. |
| Caregiver | asociación | FamilyMember | Caregiver referencia a la red de cuidado a la que pertenece mediante familyMemberId; no es global (observación previa #1). |
| Caregiver | composición | Schedule | Caregiver gestiona el ciclo de vida de sus turnos y horarios. |
| FamilyMemberRepository | depende de | FamilyMember | El repositorio persiste y recupera el aggregate FamilyMember. |
| CareTaskRepository | depende de | CareTask | El repositorio persiste y recupera el aggregate CareTask. |
| InvitationRepository | depende de | Invitation | El repositorio persiste y recupera el aggregate Invitation. |
| CaregiverRepository | depende de | Caregiver | El repositorio persiste y recupera el aggregate Caregiver. |

### 5.5.2. Interface Layer

La Interface Layer expone un controller por cada aggregate root: `FamilyMemberController`, `CareTaskController`, `InvitationController` y `CaregiverController`. Ninguno expone `CreateCaregiverCommand`, ya que solo se invoca desde `InvitationAcceptedEventHandler` en la Application Layer (observación previa #3). Este bounded context no consume mensajería de dispositivos IoT y no expone un facade/ACL: ningún otro bounded context consume a Cuidado de forma síncrona según el Context Mapping (4.2.5); sus integraciones salientes se resuelven mediante el adaptador de Sendgrid y el Domain Event `PrincipalCaregiverReplaced` hacia Perfiles.

| Propiedad | Valor |
| --- | --- |
| Nombre | FamilyMemberController |
| Categoría | Controller |
| Propósito | Exponer el registro y la actualización del familiar responsable de una red de cuidado. |
| Aggregate/Entity relacionado | FamilyMember |
| Ruta base | /api/v1/family-members |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| registerFamilyMember | / (POST) | body: RegisterFamilyMemberResource { accountId: Long, homeProfileId: Long, name: String } | Registra al familiar responsable de la red de cuidado | RegisterFamilyMemberCommand |
| getFamilyMemberById | /{familyMemberId} (GET) | path: familyMemberId: Long | Obtiene el detalle de un familiar | GetFamilyMemberByIdQuery |
| updateFamilyMemberInfo | /{familyMemberId} (PUT) | path: familyMemberId: Long; body: UpdateFamilyMemberInfoResource { name: String } | Actualiza el nombre del familiar | UpdateFamilyMemberInfoCommand |
| replacePrincipalCaregiver | /{familyMemberId}/principal-caregiver (PUT) | path: familyMemberId: Long; body: ReplacePrincipalCaregiverResource { newCaregiverId: Long } | Reemplaza al cuidador principal de la red de cuidado | ReplacePrincipalCaregiverCommand |

| Propiedad | Valor |
| --- | --- |
| Nombre | CareTaskController |
| Categoría | Controller |
| Propósito | Exponer el registro, la consulta y la asignación de responsables de las labores de cuidado. |
| Aggregate/Entity relacionado | CareTask |
| Ruta base | /api/v1/care-tasks |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| registerCareTask | / (POST) | body: RegisterCareTaskResource { familyMemberId: Long, description: String } | Registra una nueva labor de cuidado | RegisterCareTaskCommand |
| getCareTasksByFamilyMember | /by-family-member/{familyMemberId} (GET) | path: familyMemberId: Long | Lista las labores de cuidado de una red de cuidado | GetCareTasksByFamilyMemberIdQuery |
| assignCareTaskResponsible | /{careTaskId}/assign (POST) | path: careTaskId: Long; body: AssignCareTaskResponsibleResource { caregiverId: Long } | Asigna un cuidador responsable a la labor de cuidado | AssignCareTaskResponsibleCommand |

| Propiedad | Valor |
| --- | --- |
| Nombre | InvitationController |
| Categoría | Controller |
| Propósito | Exponer el envío, la consulta, la aceptación y el rechazo de invitaciones a cuidadores. |
| Aggregate/Entity relacionado | Invitation |
| Ruta base | /api/v1/invitations |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| inviteCaregiver | / (POST) | body: InviteCaregiverResource { familyMemberId: Long, invitedEmail: String } | Envía una invitación a un cuidador | InviteCaregiverCommand |
| getInvitationById | /{invitationId} (GET) | path: invitationId: Long | Obtiene el detalle de una invitación | GetInvitationByIdQuery |
| acceptInvitation | /{invitationId}/accept (POST) | path: invitationId: Long; body: AcceptInvitationResource { accountId: Long } | Acepta la invitación y vincula al cuidador | AcceptInvitationCommand |
| rejectInvitation | /{invitationId}/reject (POST) | path: invitationId: Long | Rechaza la invitación | RejectInvitationCommand |

| Propiedad | Valor |
| --- | --- |
| Nombre | CaregiverController |
| Categoría | Controller |
| Propósito | Exponer la consulta de cuidadores, el registro de turnos y horarios, el cumplimiento de asignaciones y la desvinculación de cuidadores. Schedule se expone como sub-recurso de Caregiver, su entidad interna. |
| Aggregate/Entity relacionado | Caregiver (incluye el sub-recurso Schedule) |
| Ruta base | /api/v1/caregivers |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| getCaregiverById | /{caregiverId} (GET) | path: caregiverId: Long | Obtiene el detalle de un cuidador y sus turnos | GetCaregiverByIdQuery |
| registerSchedule | /{caregiverId}/schedules (POST) | path: caregiverId: Long; body: RegisterScheduleResource { startTime: LocalDateTime, endTime: LocalDateTime } | Registra un nuevo turno y horario | RegisterScheduleCommand |
| recordCompletedAssignments | /{caregiverId}/schedules/{scheduleId}/complete (POST) | path: caregiverId: Long, scheduleId: Long | Registra el cumplimiento de las asignaciones del turno | RecordCompletedAssignmentsCommand |
| unlinkCaregiver | /{caregiverId}/unlink (POST) | path: caregiverId: Long | Desvincula al cuidador de la red de cuidado | UnlinkCaregiverCommand |

### 5.5.3. Application Layer

La Application Layer traduce cada Command y Query de la Domain Layer en un handler dedicado, y resuelve mediante dos Event Handlers propios las observaciones previas #2 y #3: ninguno consume eventos de otro bounded context, ya que ambas reacciones son políticas internas de Cuidado.

**InvitationAcceptedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | InvitationAcceptedEventHandler |
| Categoría | Event Handler |
| Propósito | Crear al Caregiver correspondiente cuando una invitación es aceptada, con el accountId ya disponible en el evento. |
| Command/Query/Evento que maneja | InvitationAccepted (evento propio de Cuidado) |
| Repositorios y servicios que usa | CreateCaregiverCommand (invocado internamente) |
| Eventos que publica | CaregiverCreated (vía el command invocado) |
| User story/capability que habilita | Resuelve la observación previa #3 |

**CaregiverUnlinkedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | CaregiverUnlinkedEventHandler |
| Categoría | Event Handler |
| Propósito | Liberar las labores de cuidado que tenían como responsable al cuidador desvinculado. |
| Command/Query/Evento que maneja | CaregiverUnlinked (evento propio de Cuidado) |
| Repositorios y servicios que usa | CareTaskRepository |
| Eventos que publica | CareTaskUnassigned (uno por cada CareTask liberada) |
| User story/capability que habilita | Resuelve la observación previa #2 |

**RegisterFamilyMemberCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RegisterFamilyMemberCommandHandler |
| Categoría | Command Handler |
| Propósito | Registrar al familiar responsable, referenciando su cuenta en IAM y su perfil de hogar en Perfiles. |
| Command/Query/Evento que maneja | RegisterFamilyMemberCommand |
| Repositorios y servicios que usa | FamilyMemberRepository |
| Eventos que publica | FamilyMemberRegistered |
| User story/capability que habilita | Derivado del Bounded Context Canvas 4.2.4 |

**UpdateFamilyMemberInfoCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | UpdateFamilyMemberInfoCommandHandler |
| Categoría | Command Handler |
| Propósito | Actualizar el nombre del familiar. |
| Command/Query/Evento que maneja | UpdateFamilyMemberInfoCommand |
| Repositorios y servicios que usa | FamilyMemberRepository |
| Eventos que publica | FamilyMemberInfoUpdated |
| User story/capability que habilita | Derivado del Bounded Context Canvas 4.2.4 |

**RegisterCareTaskCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RegisterCareTaskCommandHandler |
| Categoría | Command Handler |
| Propósito | Registrar una nueva labor de cuidado para la red de cuidado. |
| Command/Query/Evento que maneja | RegisterCareTaskCommand |
| Repositorios y servicios que usa | CareTaskRepository |
| Eventos que publica | CareTaskRegistered |
| User story/capability que habilita | Decisión de negocio del Canvas: "toda labor de cuidado se asigna a un cuidador responsable" |

**AssignCareTaskResponsibleCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | AssignCareTaskResponsibleCommandHandler |
| Categoría | Command Handler |
| Propósito | Asignar un cuidador responsable a una labor de cuidado. |
| Command/Query/Evento que maneja | AssignCareTaskResponsibleCommand |
| Repositorios y servicios que usa | CareTaskRepository, CaregiverRepository |
| Eventos que publica | CareTaskResponsibleAssigned |
| User story/capability que habilita | Decisión de negocio del Canvas |

**InviteCaregiverCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | InviteCaregiverCommandHandler |
| Categoría | Command Handler |
| Propósito | Crear la invitación en estado SENT y disparar el envío del correo de invitación. |
| Command/Query/Evento que maneja | InviteCaregiverCommand |
| Repositorios y servicios que usa | InvitationRepository |
| Eventos que publica | CaregiverInvited |
| User story/capability que habilita | Supuesto del Canvas: "Sendgrid envía los correos de invitación" |

**AcceptInvitationCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | AcceptInvitationCommandHandler |
| Categoría | Command Handler |
| Propósito | Aceptar la invitación, llevándola a su estado terminal ACCEPTED. |
| Command/Query/Evento que maneja | AcceptInvitationCommand |
| Repositorios y servicios que usa | InvitationRepository |
| Eventos que publica | InvitationAccepted |
| User story/capability que habilita | Decisión de negocio del Canvas: "una invitación aceptada vincula al cuidador como cuidador adicional" |

**RejectInvitationCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RejectInvitationCommandHandler |
| Categoría | Command Handler |
| Propósito | Rechazar la invitación, llevándola a su estado terminal REJECTED. |
| Command/Query/Evento que maneja | RejectInvitationCommand |
| Repositorios y servicios que usa | InvitationRepository |
| Eventos que publica | InvitationRejected |
| User story/capability que habilita | Decisión de negocio del Canvas: "una invitación rechazada no vincula al cuidador" |

**CreateCaregiverCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | CreateCaregiverCommandHandler |
| Categoría | Command Handler |
| Propósito | Crear al Caregiver vinculado a la red de cuidado, scoped por familyMemberId (observación previa #1). |
| Command/Query/Evento que maneja | CreateCaregiverCommand |
| Repositorios y servicios que usa | CaregiverRepository |
| Eventos que publica | CaregiverCreated |
| User story/capability que habilita | Resuelve la observación previa #1 y #3; invocado únicamente por InvitationAcceptedEventHandler |

**RegisterScheduleCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RegisterScheduleCommandHandler |
| Categoría | Command Handler |
| Propósito | Registrar un nuevo turno y horario para el cuidador. |
| Command/Query/Evento que maneja | RegisterScheduleCommand |
| Repositorios y servicios que usa | CaregiverRepository |
| Eventos que publica | ScheduleRegistered |
| User story/capability que habilita | Derivado del Bounded Context Canvas 4.2.4 |

**RecordCompletedAssignmentsCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RecordCompletedAssignmentsCommandHandler |
| Categoría | Command Handler |
| Propósito | Registrar el cumplimiento de las asignaciones de un turno. |
| Command/Query/Evento que maneja | RecordCompletedAssignmentsCommand |
| Repositorios y servicios que usa | CaregiverRepository |
| Eventos que publica | CompletedAssignmentsRecorded |
| User story/capability que habilita | Derivado del Bounded Context Canvas 4.2.4 |

**UnlinkCaregiverCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | UnlinkCaregiverCommandHandler |
| Categoría | Command Handler |
| Propósito | Desvincular al cuidador de la red de cuidado. |
| Command/Query/Evento que maneja | UnlinkCaregiverCommand |
| Repositorios y servicios que usa | CaregiverRepository |
| Eventos que publica | CaregiverUnlinked |
| User story/capability que habilita | Resuelve la observación previa #2; consumido por CaregiverUnlinkedEventHandler |

**ReplacePrincipalCaregiverCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | ReplacePrincipalCaregiverCommandHandler |
| Categoría | Command Handler |
| Propósito | Reemplazar al cuidador principal de una red de cuidado. |
| Command/Query/Evento que maneja | ReplacePrincipalCaregiverCommand |
| Repositorios y servicios que usa | CaregiverRepository |
| Eventos que publica | PrincipalCaregiverReplaced |
| User story/capability que habilita | Decisión de negocio del Canvas; consumido por PrincipalCaregiverReplacedEventHandler de Perfiles (5.3.3) |

**GetFamilyMemberByIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetFamilyMemberByIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el detalle de un familiar. |
| Command/Query/Evento que maneja | GetFamilyMemberByIdQuery |
| Repositorios y servicios que usa | FamilyMemberRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getFamilyMemberById |

**GetCareTasksByFamilyMemberIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetCareTasksByFamilyMemberIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Listar las labores de cuidado de una red de cuidado. |
| Command/Query/Evento que maneja | GetCareTasksByFamilyMemberIdQuery |
| Repositorios y servicios que usa | CareTaskRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getCareTasksByFamilyMember |

**GetInvitationByIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetInvitationByIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el detalle de una invitación. |
| Command/Query/Evento que maneja | GetInvitationByIdQuery |
| Repositorios y servicios que usa | InvitationRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getInvitationById |

**GetCaregiverByIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetCaregiverByIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el detalle de un cuidador, incluyendo sus turnos y horarios. |
| Command/Query/Evento que maneja | GetCaregiverByIdQuery |
| Repositorios y servicios que usa | CaregiverRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getCaregiverById |

### 5.5.4. Infrastructure Layer

La Infrastructure Layer implementa los repositorios de los cuatro aggregates sobre PostgreSQL, consistente con el carácter transaccional y estructurado de los datos de la red de cuidado, y el adaptador hacia Sendgrid para el correo de invitación. A diferencia de los bounded contexts anteriores, no declara un suscriptor del bus de eventos interno: ninguna de sus integraciones entrantes proviene de otro BC (observación previa #3).

| Nombre | Interfaz que implementa | Tecnología | Propósito |
| --- | --- | --- | --- |
| FamilyMemberRepositoryJpa | FamilyMemberRepository | Spring Data JPA sobre PostgreSQL | Persiste y recupera el aggregate FamilyMember. |
| CareTaskRepositoryJpa | CareTaskRepository | Spring Data JPA sobre PostgreSQL | Persiste y recupera el aggregate CareTask. |
| InvitationRepositoryJpa | InvitationRepository | Spring Data JPA sobre PostgreSQL | Persiste y recupera el aggregate Invitation. |
| CaregiverRepositoryJpa | CaregiverRepository | Spring Data JPA sobre PostgreSQL | Persiste y recupera el aggregate Caregiver junto con su entidad interna Schedule. |

La persistencia se configura mediante `CuidadoJpaConfiguration`, que habilita los repositorios Spring Data JPA (`@EnableJpaRepositories`) y el mapeo objeto-relacional de los cuatro aggregates sobre el motor PostgreSQL.

| Nombre | Categoría | Interfaz que implementa | Servicio externo | Propósito |
| --- | --- | --- | --- | --- |
| SendgridEmailGateway | Gateway | EmailGateway | Sendgrid | Envía el correo de invitación a un cuidador. |

| Tabla/Colección | Propósito |
| --- | --- |
| family_members | Almacena el aggregate FamilyMember: datos del familiar y referencias a accountId y homeProfileId. |
| care_tasks | Almacena el aggregate CareTask: descripción, estado y referencia al cuidador responsable (nulo si quedó sin asignar). |
| invitations | Almacena el aggregate Invitation: correo invitado, estado y referencia al familiar. |
| caregivers | Almacena el aggregate Caregiver: referencia a accountId y familyMemberId, y si es principal. |
| caregiver_schedules | Almacena la entidad Schedule: turnos y horarios de cada cuidador. |

| Objeto | BC responsable | Justificación |
| --- | --- | --- |
| Cuenta / credenciales | IAM | La autenticación y el estado de acceso de las cuentas de familiares y cuidadores son responsabilidad de IAM; Cuidado solo referencia accountId. |
| Perfil de usuario / perfil de hogar | Perfiles | Los datos personales y la ubicación del hogar se gestionan en Perfiles; Cuidado solo referencia homeProfileId y publica PrincipalCaregiverReplaced para mantener sincronizado al cuidador principal (observación previa #5). |

**Verificación de trazabilidad — Cuidado**

| Criterio | Cumple | Evidencia |
| --- | --- | --- |
| Todo Command/Query usado en un endpoint o consumer existe en Domain y tiene su handler en Application | Sí | Los 12 commands y las 4 queries de 5.5.1 tienen su handler correspondiente en 5.5.3. |
| Todo Command/Query declarado en Domain es usado por algún endpoint, consumer o event handler (o se justifica) | Sí | CreateCaregiverCommand se usa exclusivamente desde InvitationAcceptedEventHandler (justificado en 5.5.2); el resto se usa desde los endpoints de los cuatro controllers. |
| Los parámetros de cada endpoint cubren los parámetros del Command/Query que despacha | Sí | Cada Resource de las tablas de endpoints (5.5.2) mapea 1:1 los parámetros del Command correspondiente. |
| Todo controller está relacionado con un aggregate o entity existente en la Domain Layer | Sí | Cada uno de los cuatro controllers se relaciona con su aggregate root correspondiente. |
| Toda interfaz de repositorio del Domain tiene implementación en Infrastructure, y viceversa | Sí | Los cuatro repositorios de 5.5.1 tienen su implementación Jpa correspondiente en 5.5.4. |
| Todo Domain Event publicado tiene al menos un handler o consumidor identificado (en este u otro BC) | Sí, con justificación | CaregiverInvited lo consume el adaptador de Sendgrid; InvitationAccepted y CaregiverUnlinked los consumen los Event Handlers propios (5.5.3); PrincipalCaregiverReplaced lo consume Perfiles (5.3.3); el resto no tiene consumidor externo declarado en el Canvas y se publica para auditoría. |
| Ningún aggregate de este BC es aggregate root en otro BC | Sí | FamilyMember, CareTask, Invitation y Caregiver son exclusivos de este bounded context. |
| Ninguna clase de Domain depende de Infrastructure ni de frameworks | Sí | EmailGateway se declara como puerto en Domain; su implementación concreta (SendgridEmailGateway) está en Infrastructure (5.5.4). |

### 5.5.5. Bounded Context Software Architecture Component Level Diagrams

### 5.5.6. Bounded Context Software Architecture Code Level Diagrams

#### 5.5.6.1. Bounded Context Domain Layer Class Diagrams

#### 5.5.6.2. Bounded Context Database Design Diagram

<div style="page-break-after: always;"></div>

## 5.6. Bounded Context: Pagos y Suscripciones

El bounded context **Pagos y Suscripciones** gestiona la comparación y contratación de planes, el procesamiento de pagos en dos etapas (preautorización y cobro) vía Stripe, y la adaptación del plan cuando la vivienda resulta solo parcialmente viable. Es un subdominio de soporte orientado a ingresos. Participan el **Visitante** (compara planes), el **Cuidador** (confirma la contratación con sus datos de pago) y el **Gestor de suscripciones** (ajusta planes desde el dashboard). Este bounded context depende de dos integraciones entrantes desde Soporte Técnico que el Canvas no declara explícitamente pero que el flujo requiere (observaciones previas #3 y #4): el resultado de la evaluación de viabilidad de la vivienda, y la confirmación o el fallo de la instalación. Ambas se formalizarán del lado de Soporte Técnico en 5.7.

### 5.6.1. Domain Layer

La Domain Layer modela dos aggregates independientes: `Subscription`, que representa el contrato de servicio elegido para la persona asistida, y `Payment`, que representa el procesamiento del pago asociado. El catálogo de planes no se modela como aggregate: no se identificaron comandos que gestionen su ciclo de vida en el material disponible, por lo que se trata como un read model estático consultado por `GetAvailablePlansQuery`.

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| Subscription | Aggregate Root | Representa el contrato de servicio elegido para la persona asistida. No se activa sin un Payment confirmado (`CHARGED`); si la vivienda resulta parcialmente viable, requiere que la adaptación del plan sea aceptada antes de continuar (decisiones de negocio del Canvas). |
| Payment | Aggregate Root | Representa el procesamiento del pago de una Subscription en dos etapas: preautorización y cobro. Un cobro rechazado libera el importe retenido y devuelve el monto (decisión de negocio del Canvas); no almacena datos bancarios, solo una referencia al método de pago en Stripe (Supuesto del Canvas). |

No se identifican Entities en este bounded context: ambos aggregates son simples, sin componentes internos con identidad propia.

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| SubscriptionId | Value Object | Identificador tipado del aggregate Subscription; no admite valores nulos ni negativos. |
| PaymentId | Value Object | Identificador tipado del aggregate Payment; no admite valores nulos ni negativos. |
| PlanSnapshot | Value Object | Copia de los datos del plan (nombre, precio) tomada al momento de seleccionar la suscripción; no cambia aunque el catálogo se actualice después. |
| Money | Value Object | Monto con su moneda, usado en la preautorización, el cobro y la devolución; no admite valores negativos. |
| PaymentMethodReference | Value Object | Referencia al método de pago registrado en Stripe; no almacena datos bancarios localmente (Supuesto del Canvas). |

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| SubscriptionStatus | Enum | Estado de la suscripción. Transiciones permitidas: `SELECTED` → `AWAITING_EVALUATION` al confirmarse la contratación y preautorizarse el pago; `AWAITING_EVALUATION` → `ADAPTATION_PROPOSED` si la vivienda resulta parcialmente viable; `AWAITING_EVALUATION` → `CANCELLED` si la vivienda no es viable o si el cobro es rechazado; `AWAITING_EVALUATION` → `ACTIVE` al confirmarse el cobro; `ADAPTATION_PROPOSED` → `AWAITING_EVALUATION` al aceptarse la adaptación; `ADAPTATION_PROPOSED` → `CANCELLED` al rechazarse (observación previa #2). Si la preautorización es rechazada, la suscripción permanece en `SELECTED` para permitir un nuevo intento manual (observación previa #1). |
| PaymentStatus | Enum | Estado del pago. Transiciones permitidas: (inicial) → `PREAUTHORIZED` si Stripe aprueba la preautorización, o → `PREAUTHORIZATION_REJECTED` (terminal) si la rechaza; `PREAUTHORIZED` → `CHARGED` (terminal) al confirmarse el cobro; `PREAUTHORIZED` → `CHARGE_REJECTED` (terminal) al rechazarse el cobro, liberando el importe retenido y devolviendo el monto (decisión de negocio del Canvas). |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| SelectSubscriptionCommand | Selecciona un plan de suscripción para la persona asistida de un hogar, en estado SELECTED. | accountId: Long, homeProfileId: Long, planId: Long |
| ConfirmContractingCommand | Confirma la contratación y dispara la preautorización del pago (observación previa #1). | subscriptionId: Long, paymentMethodReference: String |
| ProposeAdaptationCommand | Propone una adaptación del plan cuando la vivienda resulta parcialmente viable, de forma manual (Gestor de suscripciones) o automática (observación previa #3 y #5). | subscriptionId: Long, adaptedPlanId: Long, proposedBy: Long |
| AcceptAdaptationCommand | Acepta la adaptación propuesta, retomando el proceso hacia la instalación. | subscriptionId: Long |
| RejectAdaptationCommand | Rechaza la adaptación propuesta, cancelando la suscripción (observación previa #2). | subscriptionId: Long |
| ActivateSubscriptionCommand | Activa la suscripción al confirmarse el cobro, invocado únicamente por PaymentChargedEventHandler. | subscriptionId: Long |
| CancelSubscriptionCommand | Cancela la suscripción, invocado por la vivienda no viable, el rechazo de la adaptación o el rechazo del cobro. | subscriptionId: Long, reason: String |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| PreauthorizePaymentCommand | Crea el Payment y preautoriza el monto en Stripe, invocado únicamente por ConfirmContractingCommandHandler. | subscriptionId: Long, amount: Money, paymentMethodReference: String |
| ConfirmChargeCommand | Confirma el cobro tras completarse la instalación, invocado únicamente por InstallationCompletedEventHandler (observación previa #4). | paymentId: Long |
| RejectChargeCommand | Rechaza el cobro y libera/devuelve el importe retenido, invocado únicamente por InstallationFailedEventHandler (observación previa #4). | paymentId: Long, reason: String |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| GetAvailablePlansQuery | Lista el catálogo de planes disponibles para comparar. | — |
| GetSubscriptionByIdQuery | Obtiene el detalle de una suscripción. | subscriptionId: Long |
| GetPaymentByIdQuery | Obtiene el detalle de un pago. | paymentId: Long |
| GetPaymentsBySubscriptionIdQuery | Lista los pagos asociados a una suscripción. | subscriptionId: Long |

`ContractingConfirmed` lo consume Soporte Técnico para iniciar la evaluación de viabilidad; `PaymentPreauthorizationRejected` lo consume Comunicaciones (observación previa #1); `PaymentCharged` y `SubscriptionActivated` los consume Analíticas; `PlanAdaptationAccepted` lo consume Soporte Técnico para coordinar la instalación. Estas cuatro integraciones salientes se formalizarán del lado receptor en 5.7 (Soporte Técnico), 5.8 (Comunicaciones) y 5.9 (Analíticas) respectivamente. El resto no tiene consumidor externo declarado en el Canvas y se publica para auditoría.

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| SubscriptionSelected | Se publica al seleccionarse un plan de suscripción. | subscriptionId: Long, accountId: Long, homeProfileId: Long, planId: Long, selectedAt: LocalDateTime |
| ContractingConfirmed | Se publica al confirmarse la contratación; es consumido por Soporte Técnico para iniciar la evaluación de viabilidad de la vivienda. | subscriptionId: Long, confirmedAt: LocalDateTime |
| PlanAdaptationProposed | Se publica al proponerse una adaptación del plan. | subscriptionId: Long, adaptedPlanId: Long, proposedAt: LocalDateTime |
| PlanAdaptationAccepted | Se publica al aceptarse la adaptación; es consumido por Soporte Técnico para coordinar la fecha de instalación. | subscriptionId: Long, acceptedAt: LocalDateTime |
| PlanAdaptationRejected | Se publica al rechazarse la adaptación (observación previa #2). | subscriptionId: Long, rejectedAt: LocalDateTime |
| SubscriptionActivated | Se publica al activarse la suscripción; es consumido por Analíticas. | subscriptionId: Long, activatedAt: LocalDateTime |
| SubscriptionCancelled | Se publica al cancelarse la suscripción. | subscriptionId: Long, reason: String, cancelledAt: LocalDateTime |
| PaymentPreauthorized | Se publica al preautorizarse el pago en Stripe. | paymentId: Long, subscriptionId: Long, amount: Money, preauthorizedAt: LocalDateTime |
| PaymentPreauthorizationRejected | Se publica al rechazar Stripe la preautorización; es consumido por Comunicaciones para notificar al cuidador principal del hogar, sin reintento automático (observación previa #1). Incluye homeProfileId para que Comunicaciones resuelva al destinatario vía PerfilesFacade (5.3.2), sin acceder directamente a Subscription. | paymentId: Long, subscriptionId: Long, homeProfileId: Long, rejectedAt: LocalDateTime |
| PaymentCharged | Se publica al confirmarse el cobro; es consumido por Analíticas y dispara internamente ActivateSubscriptionCommand. | paymentId: Long, subscriptionId: Long, chargedAt: LocalDateTime |
| PaymentChargeRejected | Se publica al rechazarse el cobro; dispara internamente CancelSubscriptionCommand. | paymentId: Long, subscriptionId: Long, reason: String, rejectedAt: LocalDateTime |

No se declaran Factories ni Domain Services en este bounded context: `Subscription` y `Payment` se referencian solo por identificador. La creación de un Payment al confirmar la contratación se resuelve en `ConfirmContractingCommandHandler` invocando `PreauthorizePaymentCommand`, sin requerir colaboración en el mismo proceso de escritura entre ambos aggregates.

| Nombre | Aggregate que gestiona | Descripción |
| --- | --- | --- |
| SubscriptionRepository | Subscription | Persiste y recupera el aggregate Subscription. |
| PaymentRepository | Payment | Persiste y recupera el aggregate Payment; expone la búsqueda por subscriptionId. |

| Clase origen | Relación | Clase destino | Descripción |
| --- | --- | --- | --- |
| Payment | asociación | Subscription | Payment referencia a su suscripción mediante subscriptionId; son aggregates independientes, sin composición. |
| SubscriptionRepository | depende de | Subscription | El repositorio persiste y recupera el aggregate Subscription. |
| PaymentRepository | depende de | Payment | El repositorio persiste y recupera el aggregate Payment. |

### 5.6.2. Interface Layer

La Interface Layer expone un controller por cada aggregate root: `SubscriptionController` y `PaymentController`. Este último solo expone consultas: `PreauthorizePaymentCommand`, `ConfirmChargeCommand` y `RejectChargeCommand` se invocan exclusivamente desde Event Handlers (5.6.3), nunca desde un endpoint REST, consistente con el patrón de integración por eventos entre bounded contexts usado en todo el capítulo (observación previa #4). Este bounded context no consume mensajería de dispositivos IoT y no expone un facade/ACL: sus integraciones salientes se resuelven mediante el adaptador de Stripe y los Domain Events hacia Soporte Técnico, Comunicaciones y Analíticas.

| Propiedad | Valor |
| --- | --- |
| Nombre | SubscriptionController |
| Categoría | Controller |
| Propósito | Exponer la comparación de planes, la selección y contratación de suscripciones, y la aceptación o el rechazo de adaptaciones de plan. |
| Aggregate/Entity relacionado | Subscription |
| Ruta base | /api/v1/subscriptions |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| getAvailablePlans | /plans (GET) | — | Lista el catálogo de planes disponibles | GetAvailablePlansQuery |
| selectSubscription | / (POST) | body: SelectSubscriptionResource { accountId: Long, homeProfileId: Long, planId: Long } | Selecciona un plan de suscripción | SelectSubscriptionCommand |
| getSubscriptionById | /{subscriptionId} (GET) | path: subscriptionId: Long | Obtiene el detalle de una suscripción | GetSubscriptionByIdQuery |
| confirmContracting | /{subscriptionId}/confirm-contracting (POST) | path: subscriptionId: Long; body: ConfirmContractingResource { paymentMethodReference: String } | Confirma la contratación y preautoriza el pago | ConfirmContractingCommand |
| proposeAdaptation | /{subscriptionId}/adaptation/propose (POST) | path: subscriptionId: Long; body: ProposeAdaptationResource { adaptedPlanId: Long, proposedBy: Long } | Propone una adaptación del plan (observación previa #5) | ProposeAdaptationCommand |
| acceptAdaptation | /{subscriptionId}/adaptation/accept (POST) | path: subscriptionId: Long | Acepta la adaptación propuesta | AcceptAdaptationCommand |
| rejectAdaptation | /{subscriptionId}/adaptation/reject (POST) | path: subscriptionId: Long | Rechaza la adaptación propuesta y cancela la suscripción | RejectAdaptationCommand |

| Propiedad | Valor |
| --- | --- |
| Nombre | PaymentController |
| Categoría | Controller |
| Propósito | Exponer la consulta del detalle de pagos y de los pagos asociados a una suscripción. |
| Aggregate/Entity relacionado | Payment |
| Ruta base | /api/v1/payments |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| getPaymentById | /{paymentId} (GET) | path: paymentId: Long | Obtiene el detalle de un pago | GetPaymentByIdQuery |
| getPaymentsBySubscription | /by-subscription/{subscriptionId} (GET) | path: subscriptionId: Long | Lista los pagos asociados a una suscripción | GetPaymentsBySubscriptionIdQuery |

### 5.6.3. Application Layer

La Application Layer traduce cada Command y Query de la Domain Layer en un handler dedicado, y resuelve mediante cinco Event Handlers las integraciones identificadas en las Observaciones Previas: tres consumen eventos externos de Soporte Técnico (observaciones previas #3 y #4, a formalizar en 5.7), y dos reaccionan a eventos propios de Payment.

**HomeViabilityEvaluatedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | HomeViabilityEvaluatedEventHandler |
| Categoría | Event Handler |
| Propósito | Según el resultado de la evaluación, proponer la adaptación del plan (parcialmente viable) o cancelar la suscripción (no viable); si es viable, no realiza ninguna acción adicional. |
| Command/Query/Evento que maneja | HomeViabilityEvaluated (evento externo, BC de origen: Soporte Técnico, a formalizar en 5.7) |
| Repositorios y servicios que usa | ProposeAdaptationCommand, CancelSubscriptionCommand (invocados internamente) |
| Eventos que publica | PlanAdaptationProposed o SubscriptionCancelled (vía los commands invocados) |
| User story/capability que habilita | Resuelve la observación previa #3 |

**InstallationCompletedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | InstallationCompletedEventHandler |
| Categoría | Event Handler |
| Propósito | Confirmar el cobro del pago asociado a la suscripción instalada. |
| Command/Query/Evento que maneja | InstallationCompleted (evento externo, BC de origen: Soporte Técnico, a formalizar en 5.7) |
| Repositorios y servicios que usa | PaymentRepository (para localizar el Payment por subscriptionId), ConfirmChargeCommand (invocado internamente) |
| Eventos que publica | PaymentCharged (vía el command invocado) |
| User story/capability que habilita | Resuelve la observación previa #4; Supuesto del Canvas: "Soporte técnico solicita el cobro cuando la instalación queda completada" |

**InstallationFailedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | InstallationFailedEventHandler |
| Categoría | Event Handler |
| Propósito | Rechazar el cobro del pago asociado cuando la instalación no pudo completarse. |
| Command/Query/Evento que maneja | InstallationFailed (evento externo, BC de origen: Soporte Técnico, a formalizar en 5.7) |
| Repositorios y servicios que usa | PaymentRepository (para localizar el Payment por subscriptionId), RejectChargeCommand (invocado internamente) |
| Eventos que publica | PaymentChargeRejected (vía el command invocado) |
| User story/capability que habilita | Resuelve la observación previa #4 |

**PaymentChargedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | PaymentChargedEventHandler |
| Categoría | Event Handler |
| Propósito | Activar la suscripción cuando su pago asociado queda cobrado. |
| Command/Query/Evento que maneja | PaymentCharged (evento propio de Pagos y Suscripciones) |
| Repositorios y servicios que usa | ActivateSubscriptionCommand (invocado internamente) |
| Eventos que publica | SubscriptionActivated (vía el command invocado) |
| User story/capability que habilita | Decisión de negocio del Canvas: "la cuenta se habilita y la suscripción se activa al confirmarse el cobro" |

**PaymentChargeRejectedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | PaymentChargeRejectedEventHandler |
| Categoría | Event Handler |
| Propósito | Cancelar la suscripción cuando su pago asociado es rechazado. |
| Command/Query/Evento que maneja | PaymentChargeRejected (evento propio de Pagos y Suscripciones) |
| Repositorios y servicios que usa | CancelSubscriptionCommand (invocado internamente) |
| Eventos que publica | SubscriptionCancelled (vía el command invocado) |
| User story/capability que habilita | Decisión de negocio del Canvas |

**SelectSubscriptionCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | SelectSubscriptionCommandHandler |
| Categoría | Command Handler |
| Propósito | Crear la suscripción en estado SELECTED con una copia del plan elegido. |
| Command/Query/Evento que maneja | SelectSubscriptionCommand |
| Repositorios y servicios que usa | SubscriptionRepository |
| Eventos que publica | SubscriptionSelected |
| User story/capability que habilita | Derivado del Bounded Context Canvas 4.2.4 |

**ConfirmContractingCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | ConfirmContractingCommandHandler |
| Categoría | Command Handler |
| Propósito | Confirmar la contratación y preautorizar el pago; si la preautorización es rechazada, la suscripción permanece en SELECTED (observación previa #1). |
| Command/Query/Evento que maneja | ConfirmContractingCommand |
| Repositorios y servicios que usa | SubscriptionRepository, PreauthorizePaymentCommand (invocado internamente) |
| Eventos que publica | ContractingConfirmed |
| User story/capability que habilita | Decisión de negocio del Canvas: "el pago se procesa en dos etapas" |

**ProposeAdaptationCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | ProposeAdaptationCommandHandler |
| Categoría | Command Handler |
| Propósito | Proponer la adaptación del plan cuando la vivienda resulta parcialmente viable. |
| Command/Query/Evento que maneja | ProposeAdaptationCommand |
| Repositorios y servicios que usa | SubscriptionRepository |
| Eventos que publica | PlanAdaptationProposed |
| User story/capability que habilita | Resuelve la observación previa #5; invocado manualmente por el Gestor de suscripciones o automáticamente por HomeViabilityEvaluatedEventHandler |

**AcceptAdaptationCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | AcceptAdaptationCommandHandler |
| Categoría | Command Handler |
| Propósito | Aceptar la adaptación propuesta, retomando el proceso hacia la coordinación de instalación. |
| Command/Query/Evento que maneja | AcceptAdaptationCommand |
| Repositorios y servicios que usa | SubscriptionRepository |
| Eventos que publica | PlanAdaptationAccepted |
| User story/capability que habilita | Decisión de negocio del Canvas |

**RejectAdaptationCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RejectAdaptationCommandHandler |
| Categoría | Command Handler |
| Propósito | Rechazar la adaptación propuesta y cancelar la suscripción. |
| Command/Query/Evento que maneja | RejectAdaptationCommand |
| Repositorios y servicios que usa | SubscriptionRepository, CancelSubscriptionCommand (invocado internamente) |
| Eventos que publica | PlanAdaptationRejected |
| User story/capability que habilita | Resuelve la observación previa #2 |

**ActivateSubscriptionCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | ActivateSubscriptionCommandHandler |
| Categoría | Command Handler |
| Propósito | Activar la suscripción. |
| Command/Query/Evento que maneja | ActivateSubscriptionCommand |
| Repositorios y servicios que usa | SubscriptionRepository |
| Eventos que publica | SubscriptionActivated |
| User story/capability que habilita | Invocado únicamente por PaymentChargedEventHandler |

**CancelSubscriptionCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | CancelSubscriptionCommandHandler |
| Categoría | Command Handler |
| Propósito | Cancelar la suscripción. |
| Command/Query/Evento que maneja | CancelSubscriptionCommand |
| Repositorios y servicios que usa | SubscriptionRepository |
| Eventos que publica | SubscriptionCancelled |
| User story/capability que habilita | Invocado por HomeViabilityEvaluatedEventHandler, RejectAdaptationCommandHandler o PaymentChargeRejectedEventHandler |

**PreauthorizePaymentCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | PreauthorizePaymentCommandHandler |
| Categoría | Command Handler |
| Propósito | Crear el Payment y preautorizar el monto en Stripe. |
| Command/Query/Evento que maneja | PreauthorizePaymentCommand |
| Repositorios y servicios que usa | PaymentRepository, PaymentGateway |
| Eventos que publica | PaymentPreauthorized o PaymentPreauthorizationRejected |
| User story/capability que habilita | Invocado únicamente por ConfirmContractingCommandHandler |

**ConfirmChargeCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | ConfirmChargeCommandHandler |
| Categoría | Command Handler |
| Propósito | Confirmar el cobro del monto preautorizado en Stripe. |
| Command/Query/Evento que maneja | ConfirmChargeCommand |
| Repositorios y servicios que usa | PaymentRepository, PaymentGateway |
| Eventos que publica | PaymentCharged |
| User story/capability que habilita | Invocado únicamente por InstallationCompletedEventHandler |

**RejectChargeCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RejectChargeCommandHandler |
| Categoría | Command Handler |
| Propósito | Rechazar el cobro y liberar/devolver el importe retenido en Stripe. |
| Command/Query/Evento que maneja | RejectChargeCommand |
| Repositorios y servicios que usa | PaymentRepository, PaymentGateway |
| Eventos que publica | PaymentChargeRejected |
| User story/capability que habilita | Invocado únicamente por InstallationFailedEventHandler |

**GetAvailablePlansQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetAvailablePlansQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el catálogo de planes disponibles para comparar. |
| Command/Query/Evento que maneja | GetAvailablePlansQuery |
| Repositorios y servicios que usa | PlanCatalogReadModel |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getAvailablePlans |

**GetSubscriptionByIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetSubscriptionByIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el detalle de una suscripción. |
| Command/Query/Evento que maneja | GetSubscriptionByIdQuery |
| Repositorios y servicios que usa | SubscriptionRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getSubscriptionById |

**GetPaymentByIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetPaymentByIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el detalle de un pago. |
| Command/Query/Evento que maneja | GetPaymentByIdQuery |
| Repositorios y servicios que usa | PaymentRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getPaymentById |

**GetPaymentsBySubscriptionIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetPaymentsBySubscriptionIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Listar los pagos asociados a una suscripción. |
| Command/Query/Evento que maneja | GetPaymentsBySubscriptionIdQuery |
| Repositorios y servicios que usa | PaymentRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getPaymentsBySubscription |

### 5.6.4. Infrastructure Layer

La Infrastructure Layer implementa los repositorios de Subscription y Payment sobre PostgreSQL, consistente con el carácter transaccional de cuentas y suscripciones (TS-47), el adaptador hacia Stripe, y el suscriptor del bus de eventos interno que conecta a Pagos y Suscripciones con Soporte Técnico.

| Nombre | Interfaz que implementa | Tecnología | Propósito |
| --- | --- | --- | --- |
| SubscriptionRepositoryJpa | SubscriptionRepository | Spring Data JPA sobre PostgreSQL | Persiste y recupera el aggregate Subscription. |
| PaymentRepositoryJpa | PaymentRepository | Spring Data JPA sobre PostgreSQL | Persiste y recupera el aggregate Payment. |
| PlanCatalogReadModelJpa | PlanCatalogReadModel | Spring Data JPA sobre PostgreSQL | Expone el catálogo estático de planes consultado por GetAvailablePlansQuery; no gestiona su ciclo de vida (5.6.1). |

La persistencia se configura mediante `PagosSuscripcionesJpaConfiguration`, que habilita los repositorios Spring Data JPA (`@EnableJpaRepositories`) y el mapeo objeto-relacional de `Subscription` y `Payment` sobre el motor PostgreSQL.

| Nombre | Categoría | Interfaz que implementa | Servicio externo | Propósito |
| --- | --- | --- | --- | --- |
| StripePaymentGateway | Gateway | PaymentGateway | Stripe | Preautoriza, cobra y devuelve montos sin almacenar datos bancarios localmente (Supuesto del Canvas). |
| DomainEventBusSubscriber | Event Subscriber | HomeViabilityEvaluatedListener, InstallationCompletedListener, InstallationFailedListener | Bus de eventos interno del monolito modular (Spring Application Events) | Enruta los eventos publicados por Soporte Técnico hacia los Event Handlers de Pagos y Suscripciones (observaciones previas #3 y #4). |

| Tabla/Colección | Propósito |
| --- | --- |
| subscriptions | Almacena el aggregate Subscription: plan elegido, estado y referencias a accountId y homeProfileId. |
| payments | Almacena el aggregate Payment: montos, estado y referencia a subscriptionId. |
| plan_catalog | Almacena el catálogo estático de planes consultado por GetAvailablePlansQuery (5.6.1). |

| Objeto | BC responsable | Justificación |
| --- | --- | --- |
| Cuenta / credenciales | IAM | La autenticación y el estado de acceso de la cuenta son responsabilidad de IAM; Pagos y Suscripciones solo referencia accountId. |
| Perfil de hogar | Perfiles | Los datos y la ubicación del hogar se gestionan en Perfiles; Pagos y Suscripciones solo referencia homeProfileId. |
| Evaluación de viabilidad / instalación | Soporte Técnico | La evaluación técnica de la vivienda y la instalación de dispositivos son responsabilidad de Soporte Técnico; Pagos y Suscripciones solo reacciona a sus eventos (observaciones previas #3 y #4, a formalizar en 5.7). |

**Verificación de trazabilidad — Pagos y Suscripciones**

| Criterio | Cumple | Evidencia |
| --- | --- | --- |
| Todo Command/Query usado en un endpoint o consumer existe en Domain y tiene su handler en Application | Sí | Los 10 commands y las 4 queries de 5.6.1 tienen su handler correspondiente en 5.6.3. |
| Todo Command/Query declarado en Domain es usado por algún endpoint, consumer o event handler (o se justifica) | Sí | ProposeAdaptationCommand se usa tanto desde el endpoint manual como desde HomeViabilityEvaluatedEventHandler (observación previa #5); PreauthorizePaymentCommand, ConfirmChargeCommand, RejectChargeCommand, ActivateSubscriptionCommand y CancelSubscriptionCommand se usan exclusivamente desde Event Handlers, justificado en 5.6.2 y 5.6.3. |
| Los parámetros de cada endpoint cubren los parámetros del Command/Query que despacha | Sí | Cada Resource de las tablas de endpoints (5.6.2) mapea 1:1 los parámetros del Command correspondiente. |
| Todo controller está relacionado con un aggregate o entity existente en la Domain Layer | Sí | SubscriptionController se relaciona con Subscription; PaymentController se relaciona con Payment. |
| Toda interfaz de repositorio del Domain tiene implementación en Infrastructure, y viceversa | Sí | SubscriptionRepository ↔ SubscriptionRepositoryJpa; PaymentRepository ↔ PaymentRepositoryJpa. |
| Todo Domain Event publicado tiene al menos un handler o consumidor identificado (en este u otro BC) | Sí, con justificación | ContractingConfirmed y PlanAdaptationAccepted los consume Soporte Técnico; PaymentPreauthorizationRejected lo consume Comunicaciones; PaymentCharged y SubscriptionActivated los consume Analíticas; PaymentCharged y PaymentChargeRejected además disparan Event Handlers propios (5.6.3); el resto no tiene consumidor externo declarado en el Canvas y se publica para auditoría. |
| Ningún aggregate de este BC es aggregate root en otro BC | Sí | Subscription y Payment son exclusivos de este bounded context. |
| Ninguna clase de Domain depende de Infrastructure ni de frameworks | Sí | PaymentGateway se declara como puerto en Domain; su implementación concreta (StripePaymentGateway) está en Infrastructure (5.6.4). |

### 5.6.5. Bounded Context Software Architecture Component Level Diagrams

### 5.6.6. Bounded Context Software Architecture Code Level Diagrams

#### 5.6.6.1. Bounded Context Domain Layer Class Diagrams

#### 5.6.6.2. Bounded Context Database Design Diagram

<div style="page-break-after: always;"></div>

## 5.7. Bounded Context: Soporte Técnico

El bounded context **Soporte Técnico** gestiona las operaciones técnicas de campo: evaluar la viabilidad técnica de la vivienda, coordinar e instalar los dispositivos, y atender incidencias técnicas. Es un subdominio de soporte orientado a reducción de costos. Participan el **Cuidador** (solicita la evaluación, reporta dispositivos) y el **Técnico** (evalúa, instala, atiende incidencias y genera informes). Este bounded context cierra los tres compromisos pendientes con Pagos y Suscripciones (5.6): consume `ContractingConfirmed` y `PlanAdaptationAccepted`, y publica `HomeViabilityEvaluated`, `InstallationCompleted` e `InstallationFailed`.

### 5.7.1. Domain Layer

La Domain Layer modela tres aggregates independientes, fieles al EventStorming de Paso 10: `Evaluation`, que determina la viabilidad técnica de la vivienda; `Installation`, que despliega los dispositivos; e `Incident`, que gestiona el reporte, la atención y el informe de incidencias técnicas.

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| Evaluation | Aggregate Root | Representa el proceso de verificar si una vivienda es técnicamente viable. El veredicto se determina evaluando la instalación eléctrica y la compatibilidad de dispositivos (observación previa #1): viable, parcialmente viable o no viable. |
| Installation | Aggregate Root | Representa el despliegue físico de los dispositivos en la vivienda. Solo se programa tras una vivienda viable o una adaptación de plan aceptada; puede fallar (observación previa #5), lo que rechaza el cobro asociado en Pagos y Suscripciones. |
| Incident | Aggregate Root | Representa un problema reportado sobre un dispositivo que requiere atención de soporte, desde su clasificación hasta la generación del informe técnico. Un dispositivo clasificado en una incidencia se avisa a la administración (decisión de negocio del Canvas). |

No se identifican Entities en este bounded context: los tres aggregates son simples, sin componentes internos con identidad propia.

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| EvaluationId | Value Object | Identificador tipado del aggregate Evaluation; no admite valores nulos ni negativos. |
| InstallationId | Value Object | Identificador tipado del aggregate Installation; no admite valores nulos ni negativos. |
| IncidentId | Value Object | Identificador tipado del aggregate Incident; no admite valores nulos ni negativos. |
| HomeAddress | Value Object | Dirección de la vivienda a evaluar, geocodificada mediante Google Maps (Supuesto del Canvas); no admite valores vacíos. |
| CompatibilityResult | Value Object | Resultado de evaluar la instalación eléctrica y la compatibilidad de dispositivos de una vivienda; determina el veredicto de viabilidad (observación previa #1). |
| IncidentDescription | Value Object | Descripción del problema reportado sobre un dispositivo; no admite valores vacíos. |

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| ViabilityResult | Enum | Veredicto de una Evaluation: `VIABLE` (permite programar la instalación directamente), `PARTIALLY_VIABLE` (requiere adaptar el plan de suscripción antes de instalar), `NOT_VIABLE` (cancela la suscripción, observación previa #2). No exhibe transiciones: es el resultado final de RecordEvaluationResultCommand. |
| InstallationStatus | Enum | Estado de la instalación. Transiciones permitidas: `SCHEDULED` → `IN_PROGRESS` al iniciarse; `IN_PROGRESS` → `COMPLETED` (terminal) al instalarse los dispositivos; `IN_PROGRESS` → `FAILED` (terminal) si no puede completarse (observación previa #5). |

No se declaran Factories ni Domain Services en este bounded context: los tres aggregates se referencian solo por identificador (subscriptionId, homeProfileId), sin colaboración síncrona entre ellos en el mismo proceso de escritura.

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| RequestHomeEvaluationCommand | Solicita la evaluación técnica de una vivienda y programa la visita del técnico, de forma manual (Cuidador) o automática al confirmarse la contratación. | subscriptionId: Long, homeProfileId: Long, address: String, requestedBy: Long |
| RecordEvaluationResultCommand | Registra el resultado de la visita técnica y determina el veredicto de viabilidad (observación previa #1). | evaluationId: Long, electricalInstallationOk: Boolean, deviceCompatible: Boolean |
| ScheduleInstallationCommand | Programa la fecha de instalación, invocado automáticamente tras una vivienda viable o una adaptación de plan aceptada. | evaluationId: Long, subscriptionId: Long, scheduledDate: LocalDateTime |
| InstallDevicesCommand | Instala los dispositivos en la vivienda y completa la instalación. | installationId: Long |
| MarkInstallationAsFailedCommand | Marca la instalación como fallida (observación previa #5). | installationId: Long, reason: String |
| ReportDeviceIssueCommand | Reporta un problema sobre un dispositivo e inicia una incidencia técnica. | deviceId: Long, description: String, reportedBy: Long |
| AttendTechnicalIncidentCommand | Atiende la incidencia: genera la alerta, programa mantenimiento si corresponde, diagnostica, repara y restablece el servicio. | incidentId: Long |
| GenerateTechnicalReportCommand | Genera el informe técnico que resume el diagnóstico y la resolución de la incidencia (observación previa #4). | incidentId: Long |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| GetEvaluationByIdQuery | Obtiene el detalle de una evaluación. | evaluationId: Long |
| GetInstallationByIdQuery | Obtiene el detalle de una instalación. | installationId: Long |
| GetIncidentByIdQuery | Obtiene el detalle de una incidencia, incluyendo su informe técnico. | incidentId: Long |
| GetIncidentsByDeviceIdQuery | Lista las incidencias reportadas sobre un dispositivo. | deviceId: Long |

`HomeViabilityEvaluated` lo consume `HomeViabilityEvaluatedEventHandler` de Pagos y Suscripciones (5.6.3); `InstallationCompleted` e `InstallationFailed` los consumen `InstallationCompletedEventHandler` e `InstallationFailedEventHandler` de Pagos y Suscripciones (5.6.3), respectivamente; `DeviceIssueReported` lo consume Comunicaciones (a formalizar en 5.8). El resto no tiene consumidor externo declarado en el Canvas y se publica para auditoría.

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| HomeEvaluationRequested | Se publica al solicitarse la evaluación de una vivienda y programarse la visita técnica. | evaluationId: Long, subscriptionId: Long, homeProfileId: Long, address: String, requestedAt: LocalDateTime |
| HomeViabilityEvaluated | Se publica al determinarse el veredicto de viabilidad; es consumido por Pagos y Suscripciones (5.6.3) para activar, adaptar o cancelar la suscripción. | evaluationId: Long, subscriptionId: Long, result: ViabilityResult, evaluatedAt: LocalDateTime |
| InstallationScheduled | Se publica al programarse la fecha de instalación. | installationId: Long, evaluationId: Long, subscriptionId: Long, scheduledDate: LocalDateTime |
| InstallationStarted | Se publica al iniciarse la instalación. | installationId: Long, startedAt: LocalDateTime |
| InstallationCompleted | Se publica al completarse la instalación; es consumido por Pagos y Suscripciones (5.6.3) para confirmar el cobro. | installationId: Long, subscriptionId: Long, completedAt: LocalDateTime |
| InstallationFailed | Se publica al no poder completarse la instalación; es consumido por Pagos y Suscripciones (5.6.3) para rechazar el cobro (observación previa #5). | installationId: Long, subscriptionId: Long, reason: String, failedAt: LocalDateTime |
| DeviceIssueReported | Se publica al reportarse y clasificarse un problema sobre un dispositivo; es consumido por Comunicaciones para avisar a la administración (decisión de negocio del Canvas, a formalizar en 5.8). | incidentId: Long, deviceId: Long, classification: String, reportedAt: LocalDateTime |
| IncidentAttended | Se publica al completarse la atención de una incidencia (alerta, mantenimiento, diagnóstico, reparación y restablecimiento del servicio). | incidentId: Long, attendedAt: LocalDateTime |
| TechnicalReportGenerated | Se publica al generarse el informe técnico de una incidencia (observación previa #4). | incidentId: Long, generatedAt: LocalDateTime |

| Nombre | Aggregate que gestiona | Descripción |
| --- | --- | --- |
| EvaluationRepository | Evaluation | Persiste y recupera el aggregate Evaluation. |
| InstallationRepository | Installation | Persiste y recupera el aggregate Installation; expone la búsqueda por subscriptionId para los Event Handlers de Pagos y Suscripciones. |
| IncidentRepository | Incident | Persiste y recupera el aggregate Incident; expone la búsqueda por deviceId. |

| Clase origen | Relación | Clase destino | Descripción |
| --- | --- | --- | --- |
| Installation | asociación | Evaluation | Installation referencia a la evaluación que la originó mediante evaluationId. |
| EvaluationRepository | depende de | Evaluation | El repositorio persiste y recupera el aggregate Evaluation. |
| InstallationRepository | depende de | Installation | El repositorio persiste y recupera el aggregate Installation. |
| IncidentRepository | depende de | Incident | El repositorio persiste y recupera el aggregate Incident. |

### 5.7.2. Interface Layer

La Interface Layer expone un controller por cada aggregate root: `EvaluationController`, `InstallationController` e `IncidentController`. `ScheduleInstallationCommand` no se expone directamente, ya que se invoca únicamente desde Event Handlers (5.7.3). Este bounded context no consume mensajería de dispositivos IoT y no expone un facade/ACL: sus integraciones salientes se resuelven mediante el adaptador de Google Maps y los Domain Events hacia Pagos y Suscripciones y Comunicaciones.

| Propiedad | Valor |
| --- | --- |
| Nombre | EvaluationController |
| Categoría | Controller |
| Propósito | Exponer la solicitud de evaluación de vivienda y el registro de su resultado. |
| Aggregate/Entity relacionado | Evaluation |
| Ruta base | /api/v1/evaluations |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| requestHomeEvaluation | / (POST) | body: RequestHomeEvaluationResource { subscriptionId: Long, homeProfileId: Long, address: String, requestedBy: Long } | Solicita la evaluación técnica de una vivienda | RequestHomeEvaluationCommand |
| getEvaluationById | /{evaluationId} (GET) | path: evaluationId: Long | Obtiene el detalle de una evaluación | GetEvaluationByIdQuery |
| recordEvaluationResult | /{evaluationId}/result (POST) | path: evaluationId: Long; body: RecordEvaluationResultResource { electricalInstallationOk: Boolean, deviceCompatible: Boolean } | Registra el resultado y determina el veredicto de viabilidad | RecordEvaluationResultCommand |

| Propiedad | Valor |
| --- | --- |
| Nombre | InstallationController |
| Categoría | Controller |
| Propósito | Exponer la consulta, la ejecución y el registro de fallas de la instalación de dispositivos. |
| Aggregate/Entity relacionado | Installation |
| Ruta base | /api/v1/installations |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| getInstallationById | /{installationId} (GET) | path: installationId: Long | Obtiene el detalle de una instalación | GetInstallationByIdQuery |
| installDevices | /{installationId}/install (POST) | path: installationId: Long | Instala los dispositivos y completa la instalación | InstallDevicesCommand |
| markInstallationAsFailed | /{installationId}/fail (POST) | path: installationId: Long; body: MarkInstallationAsFailedResource { reason: String } | Marca la instalación como fallida (observación previa #5) | MarkInstallationAsFailedCommand |

| Propiedad | Valor |
| --- | --- |
| Nombre | IncidentController |
| Categoría | Controller |
| Propósito | Exponer el reporte de dispositivos, la atención de incidencias técnicas y la generación de su informe. |
| Aggregate/Entity relacionado | Incident |
| Ruta base | /api/v1/incidents |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| reportDeviceIssue | / (POST) | body: ReportDeviceIssueResource { deviceId: Long, description: String, reportedBy: Long } | Reporta un problema sobre un dispositivo | ReportDeviceIssueCommand |
| getIncidentById | /{incidentId} (GET) | path: incidentId: Long | Obtiene el detalle de una incidencia | GetIncidentByIdQuery |
| getIncidentsByDevice | /by-device/{deviceId} (GET) | path: deviceId: Long | Lista las incidencias reportadas sobre un dispositivo | GetIncidentsByDeviceIdQuery |
| attendIncident | /{incidentId}/attend (POST) | path: incidentId: Long | Atiende la incidencia técnica | AttendTechnicalIncidentCommand |
| generateTechnicalReport | /{incidentId}/report (POST) | path: incidentId: Long | Genera el informe técnico de la incidencia | GenerateTechnicalReportCommand |

### 5.7.3. Application Layer

La Application Layer traduce cada Command y Query de la Domain Layer en un handler dedicado, y resuelve mediante tres Event Handlers las integraciones con Pagos y Suscripciones: dos consumen eventos externos (`ContractingConfirmed`, `PlanAdaptationAccepted`) y uno reacciona al propio `HomeViabilityEvaluated` para programar la instalación cuando la vivienda es viable sin necesitar la confirmación de otro bounded context.

**ContractingConfirmedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | ContractingConfirmedEventHandler |
| Categoría | Event Handler |
| Propósito | Solicitar automáticamente la evaluación técnica de la vivienda al confirmarse la contratación. |
| Command/Query/Evento que maneja | ContractingConfirmed (evento externo, BC de origen: Pagos y Suscripciones, ver 5.6.1) |
| Repositorios y servicios que usa | RequestHomeEvaluationCommand (invocado internamente) |
| Eventos que publica | HomeEvaluationRequested (vía el command invocado) |
| User story/capability que habilita | Supuesto del Canvas: "el BC Pagos y suscripciones inicia la evaluación" |

**PlanAdaptationAcceptedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | PlanAdaptationAcceptedEventHandler |
| Categoría | Event Handler |
| Propósito | Programar la fecha de instalación tras aceptarse la adaptación del plan. |
| Command/Query/Evento que maneja | PlanAdaptationAccepted (evento externo, BC de origen: Pagos y Suscripciones, ver 5.6.1) |
| Repositorios y servicios que usa | ScheduleInstallationCommand (invocado internamente) |
| Eventos que publica | InstallationScheduled (vía el command invocado) |
| User story/capability que habilita | Comunicación Entrante del Canvas: "BC Pagos y suscripciones (coordinar fecha de instalación)" |

**HomeViabilityEvaluatedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | HomeViabilityEvaluatedEventHandler |
| Categoría | Event Handler |
| Propósito | Programar la instalación directamente cuando la vivienda resulta viable, sin esperar una confirmación externa; si resulta parcialmente viable o no viable, no realiza ninguna acción adicional (la reacción ocurre en Pagos y Suscripciones, 5.6.3). |
| Command/Query/Evento que maneja | HomeViabilityEvaluated (evento propio de Soporte Técnico) |
| Repositorios y servicios que usa | ScheduleInstallationCommand (invocado internamente, solo si result = VIABLE) |
| Eventos que publica | InstallationScheduled (vía el command invocado) |
| User story/capability que habilita | Decisión de negocio del Canvas: "una vivienda declarada viable permite programar la fecha de instalación" |

**RequestHomeEvaluationCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RequestHomeEvaluationCommandHandler |
| Categoría | Command Handler |
| Propósito | Crear la evaluación, geocodificar la dirección y programar la visita técnica. |
| Command/Query/Evento que maneja | RequestHomeEvaluationCommand |
| Repositorios y servicios que usa | EvaluationRepository, GeocodingService |
| Eventos que publica | HomeEvaluationRequested |
| User story/capability que habilita | Invocado manualmente por el Cuidador o automáticamente por ContractingConfirmedEventHandler |

**RecordEvaluationResultCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RecordEvaluationResultCommandHandler |
| Categoría | Command Handler |
| Propósito | Registrar el resultado de la visita técnica y determinar el veredicto de viabilidad (observación previa #1). |
| Command/Query/Evento que maneja | RecordEvaluationResultCommand |
| Repositorios y servicios que usa | EvaluationRepository |
| Eventos que publica | HomeViabilityEvaluated |
| User story/capability que habilita | Resuelve las observaciones previas #1, #2 y #3 |

**ScheduleInstallationCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | ScheduleInstallationCommandHandler |
| Categoría | Command Handler |
| Propósito | Crear la instalación en estado SCHEDULED con la fecha coordinada. |
| Command/Query/Evento que maneja | ScheduleInstallationCommand |
| Repositorios y servicios que usa | InstallationRepository |
| Eventos que publica | InstallationScheduled |
| User story/capability que habilita | Invocado únicamente por HomeViabilityEvaluatedEventHandler o PlanAdaptationAcceptedEventHandler |

**InstallDevicesCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | InstallDevicesCommandHandler |
| Categoría | Command Handler |
| Propósito | Iniciar y completar la instalación de los dispositivos en la vivienda. |
| Command/Query/Evento que maneja | InstallDevicesCommand |
| Repositorios y servicios que usa | InstallationRepository |
| Eventos que publica | InstallationStarted, InstallationCompleted |
| User story/capability que habilita | Decisión de negocio del Canvas: "al completarse la instalación se solicita el cobro" |

**MarkInstallationAsFailedCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | MarkInstallationAsFailedCommandHandler |
| Categoría | Command Handler |
| Propósito | Marcar la instalación como fallida. |
| Command/Query/Evento que maneja | MarkInstallationAsFailedCommand |
| Repositorios y servicios que usa | InstallationRepository |
| Eventos que publica | InstallationFailed |
| User story/capability que habilita | Resuelve la observación previa #5 |

**ReportDeviceIssueCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | ReportDeviceIssueCommandHandler |
| Categoría | Command Handler |
| Propósito | Crear la incidencia, identificar y clasificar el dispositivo objetivo. |
| Command/Query/Evento que maneja | ReportDeviceIssueCommand |
| Repositorios y servicios que usa | IncidentRepository |
| Eventos que publica | DeviceIssueReported |
| User story/capability que habilita | Decisión de negocio del Canvas: "un dispositivo clasificado en una incidencia se avisa a la administración" |

**AttendTechnicalIncidentCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | AttendTechnicalIncidentCommandHandler |
| Categoría | Command Handler |
| Propósito | Atender la incidencia: generar la alerta, programar mantenimiento si corresponde, diagnosticar, reparar y restablecer el servicio. |
| Command/Query/Evento que maneja | AttendTechnicalIncidentCommand |
| Repositorios y servicios que usa | IncidentRepository |
| Eventos que publica | IncidentAttended |
| User story/capability que habilita | Derivado del Bounded Context Canvas 4.2.4 |

**GenerateTechnicalReportCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GenerateTechnicalReportCommandHandler |
| Categoría | Command Handler |
| Propósito | Generar el informe técnico de diagnóstico y resolución de la incidencia. |
| Command/Query/Evento que maneja | GenerateTechnicalReportCommand |
| Repositorios y servicios que usa | IncidentRepository |
| Eventos que publica | TechnicalReportGenerated |
| User story/capability que habilita | Resuelve la observación previa #4 |

**GetEvaluationByIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetEvaluationByIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el detalle de una evaluación. |
| Command/Query/Evento que maneja | GetEvaluationByIdQuery |
| Repositorios y servicios que usa | EvaluationRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getEvaluationById |

**GetInstallationByIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetInstallationByIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el detalle de una instalación. |
| Command/Query/Evento que maneja | GetInstallationByIdQuery |
| Repositorios y servicios que usa | InstallationRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getInstallationById |

**GetIncidentByIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetIncidentByIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el detalle de una incidencia, incluyendo su informe técnico. |
| Command/Query/Evento que maneja | GetIncidentByIdQuery |
| Repositorios y servicios que usa | IncidentRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getIncidentById |

**GetIncidentsByDeviceIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetIncidentsByDeviceIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Listar las incidencias reportadas sobre un dispositivo. |
| Command/Query/Evento que maneja | GetIncidentsByDeviceIdQuery |
| Repositorios y servicios que usa | IncidentRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getIncidentsByDevice |

### 5.7.4. Infrastructure Layer

La Infrastructure Layer implementa los repositorios de los tres aggregates sobre PostgreSQL, el adaptador hacia Google Maps, y el suscriptor del bus de eventos interno que conecta a Soporte Técnico con Pagos y Suscripciones.

| Nombre | Interfaz que implementa | Tecnología | Propósito |
| --- | --- | --- | --- |
| EvaluationRepositoryJpa | EvaluationRepository | Spring Data JPA sobre PostgreSQL | Persiste y recupera el aggregate Evaluation. |
| InstallationRepositoryJpa | InstallationRepository | Spring Data JPA sobre PostgreSQL | Persiste y recupera el aggregate Installation. |
| IncidentRepositoryJpa | IncidentRepository | Spring Data JPA sobre PostgreSQL | Persiste y recupera el aggregate Incident. |

La persistencia se configura mediante `SoporteTecnicoJpaConfiguration`, que habilita los repositorios Spring Data JPA (`@EnableJpaRepositories`) y el mapeo objeto-relacional de los tres aggregates sobre el motor PostgreSQL.

| Nombre | Categoría | Interfaz que implementa | Servicio externo | Propósito |
| --- | --- | --- | --- | --- |
| GoogleMapsGeocodingAdapter | Gateway | GeocodingService | Google Maps | Geocodifica la dirección de la vivienda a evaluar. |
| DomainEventBusSubscriber | Event Subscriber | ContractingConfirmedListener, PlanAdaptationAcceptedListener | Bus de eventos interno del monolito modular (Spring Application Events) | Enruta los eventos publicados por Pagos y Suscripciones hacia los Event Handlers de Soporte Técnico. |

| Tabla/Colección | Propósito |
| --- | --- |
| evaluations | Almacena el aggregate Evaluation: dirección, resultado de compatibilidad y veredicto de viabilidad. |
| installations | Almacena el aggregate Installation: estado y referencias a evaluationId y subscriptionId. |
| incidents | Almacena el aggregate Incident: clasificación del dispositivo, atención e informe técnico. |

| Objeto | BC responsable | Justificación |
| --- | --- | --- |
| Suscripción / pago | Pagos y Suscripciones | El estado comercial de la suscripción y el procesamiento del pago son responsabilidad de Pagos y Suscripciones; Soporte Técnico solo reacciona a sus eventos y publica el veredicto de viabilidad y el resultado de la instalación (5.6). |
| Perfil de hogar | Perfiles | Los datos y la ubicación base del hogar se gestionan en Perfiles; Soporte Técnico solo referencia homeProfileId al solicitar la evaluación. |
| Dispositivo (bien) | Bienes | El registro y la configuración del dispositivo como activo de la vivienda son responsabilidad de Bienes; Soporte Técnico solo referencia deviceId al reportar o instalar (a formalizar en 5.11). |

**Verificación de trazabilidad — Soporte Técnico**

| Criterio | Cumple | Evidencia |
| --- | --- | --- |
| Todo Command/Query usado en un endpoint o consumer existe en Domain y tiene su handler en Application | Sí | Los 8 commands y las 4 queries de 5.7.1 tienen su handler correspondiente en 5.7.3. |
| Todo Command/Query declarado en Domain es usado por algún endpoint, consumer o event handler (o se justifica) | Sí | RequestHomeEvaluationCommand se usa desde el endpoint manual y desde ContractingConfirmedEventHandler; ScheduleInstallationCommand se usa exclusivamente desde los dos Event Handlers de viabilidad/adaptación, justificado en 5.7.2. |
| Los parámetros de cada endpoint cubren los parámetros del Command/Query que despacha | Sí | Cada Resource de las tablas de endpoints (5.7.2) mapea 1:1 los parámetros del Command correspondiente. |
| Todo controller está relacionado con un aggregate o entity existente en la Domain Layer | Sí | Cada uno de los tres controllers se relaciona con su aggregate root correspondiente. |
| Toda interfaz de repositorio del Domain tiene implementación en Infrastructure, y viceversa | Sí | Los tres repositorios de 5.7.1 tienen su implementación Jpa correspondiente en 5.7.4. |
| Todo Domain Event publicado tiene al menos un handler o consumidor identificado (en este u otro BC) | Sí | HomeViabilityEvaluated, InstallationCompleted e InstallationFailed los consume Pagos y Suscripciones (5.6.3); HomeViabilityEvaluated también lo consume el propio HomeViabilityEvaluatedEventHandler (5.7.3); DeviceIssueReported lo consume Comunicaciones (a formalizar en 5.8); el resto se publica para auditoría. |
| Ningún aggregate de este BC es aggregate root en otro BC | Sí | Evaluation, Installation e Incident son exclusivos de este bounded context. |
| Ninguna clase de Domain depende de Infrastructure ni de frameworks | Sí | GeocodingService se declara como puerto en Domain; su implementación concreta (GoogleMapsGeocodingAdapter) está en Infrastructure (5.7.4). |

### 5.7.5. Bounded Context Software Architecture Component Level Diagrams

### 5.7.6. Bounded Context Software Architecture Code Level Diagrams

#### 5.7.6.1. Bounded Context Domain Layer Class Diagrams

#### 5.7.6.2. Bounded Context Database Design Diagram

<div style="page-break-after: always;"></div>

## 5.8. Bounded Context: Comunicaciones

El bounded context **Comunicaciones** gestiona la generación, priorización y envío de notificaciones y alertas hacia el cuidador principal, asegurando que se registre su confirmación y que las notificaciones críticas se reenvíen si no son atendidas a tiempo. Es un dominio núcleo orientado a interacción. El Context Mapping (4.2.5) lo describe como nodo central alimentado por seis bounded contexts proveedores (IAM, Cuidado, Bienes, Telemetría, Pagos y Suscripciones, Soporte Técnico), mientras que su propio Bounded Context Canvas (4.2.4) solo detalla explícitamente a dos de ellos (Telemetría y Soporte Técnico) además del actor Cuidador. Este capítulo honra el Context Mapping como fuente de verdad sobre qué bounded contexts integran, formalizando las integraciones concretas con los que ya fueron modelados (IAM, Pagos y Suscripciones, Soporte Técnico, Telemetría); Cuidado y Bienes quedan fuera del alcance actual por no tener un evento de origen nombrado en ningún Canvas (ver "Objetos excluidos", 5.8.4).

### 5.8.1. Domain Layer

La Domain Layer modela un único aggregate, `Notification`, fiel al EventStorming de Paso 10, con un campo `audience` que distingue si el destinatario es el cuidador principal de un hogar o la administración del negocio (observación previa #1, criterio de prioridad), evitando que este bounded context necesite conocer la estructura interna de los bounded contexts que lo alimentan.

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| Notification | Aggregate Root | Representa un mensaje generado para alertar sobre un evento relevante. Toda notificación registra su estado (enviada, atendida, confirmada, cerrada) en el historial (decisión de negocio del Canvas); si es de prioridad CRITICAL y no se confirma dentro del tiempo límite configurable, se repite (observación previa #2). |

No se identifican Entities en este bounded context: `Notification` es un aggregate simple sin componentes internos con identidad propia.

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| NotificationId | Value Object | Identificador tipado del aggregate Notification; no admite valores nulos ni negativos. |
| NotificationMessage | Value Object | Contenido del mensaje a enviar; no admite valores vacíos. |

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| NotificationStatus | Enum | Estado de la notificación. Transiciones permitidas: `GENERATED` → `SENT` al enviarse vía Firebase; `SENT` → `PENDING_CRITICAL` si vence el tiempo límite sin confirmación y la prioridad es CRITICAL; `PENDING_CRITICAL` → `SENT` al reenviarse (observación previa #2); `SENT`/`PENDING_CRITICAL` → `CONFIRMED` (terminal intermedio) al confirmar el cuidador; `CONFIRMED` → `CLOSED` (terminal) al cerrarse. |
| NotificationPriority | Enum | Prioridad de la notificación: `NORMAL` o `CRITICAL`. Se determina por el tipo de evento de origen (observación previa #1): eventos de Telemetría y Soporte Técnico se clasifican CRITICAL por defecto; eventos de IAM y Pagos y Suscripciones se clasifican NORMAL. No exhibe transiciones adicionales. |
| NotificationAudience | Enum | Destinatario de la notificación: `ACCOUNT_HOLDER` (el recipientAccountId viaja directamente en el evento de origen, como en los eventos de IAM); `PRINCIPAL_CAREGIVER` (el evento de origen solo trae homeProfileId/subscriptionId, y el recipientAccountId se resuelve vía PerfilesFacade, 5.3.2); o `ADMINISTRATION` (sin accountId específico; se distribuye a un canal de administración configurado en Infrastructure). |

No se declaran Factories ni Domain Services en este bounded context: `Notification` es un aggregate autónomo cuya creación no requiere colaboración con otros aggregates del mismo tipo.

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| GenerateNotificationCommand | Genera una notificación a partir de un evento de origen, determinando su prioridad y su destinatario. | sourceEventType: String, sourceBc: String, message: String, priority: NotificationPriority, audience: NotificationAudience, recipientAccountId: Long |
| SendNotificationCommand | Envía la notificación vía Firebase Cloud Messaging, invocado automáticamente tras generarse. | notificationId: Long |
| ConfirmNotificationCommand | Confirma la notificación por parte del cuidador y la cierra. | notificationId: Long, caregiverAccountId: Long |
| RepeatNotificationCommand | Reenvía una notificación crítica no confirmada dentro del tiempo límite, invocado por el scheduler de Infrastructure (observación previa #2). | notificationId: Long |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| GetNotificationByIdQuery | Obtiene el detalle de una notificación. | notificationId: Long |
| GetNotificationsByCaregiverIdQuery | Lista el historial de notificaciones de un cuidador, para el panel de notificaciones. | caregiverAccountId: Long |

Ninguno de los siguientes Domain Events tiene un consumidor externo declarado en el Bounded Context Canvas (4.2.4): su Comunicación Saliente solo registra integraciones hacia Firebase Cloud Messaging y el panel de notificaciones interno.

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| NotificationGenerated | Se publica al generarse una notificación. | notificationId: Long, sourceEventType: String, sourceBc: String, priority: NotificationPriority, audience: NotificationAudience, generatedAt: LocalDateTime |
| NotificationSent | Se publica al enviarse la notificación vía Firebase. | notificationId: Long, sentAt: LocalDateTime |
| NotificationConfirmed | Se publica al confirmarse la notificación. | notificationId: Long, confirmedAt: LocalDateTime |
| NotificationClosed | Se publica al cerrarse la notificación tras su confirmación. | notificationId: Long, closedAt: LocalDateTime |
| NotificationRepeated | Se publica al reenviarse una notificación crítica no atendida a tiempo. | notificationId: Long, repeatedAt: LocalDateTime |

| Nombre | Aggregate que gestiona | Descripción |
| --- | --- | --- |
| NotificationRepository | Notification | Persiste y recupera el aggregate Notification; expone la búsqueda por recipientAccountId para el panel de notificaciones y por estado para el proceso de reenvío. |

| Clase origen | Relación | Clase destino | Descripción |
| --- | --- | --- | --- |
| NotificationRepository | depende de | Notification | El repositorio persiste y recupera el aggregate Notification. |

### 5.8.2. Interface Layer

La Interface Layer expone un único controller, `NotificationController`. `GenerateNotificationCommand`, `SendNotificationCommand` y `RepeatNotificationCommand` no se exponen vía REST: el primero se invoca exclusivamente desde los Event Handlers de la Application Layer (5.8.3), y los otros dos son reacciones internas. Este bounded context no consume mensajería de dispositivos IoT y no expone un facade/ACL propio: consume el `PerfilesFacade` de Perfiles (5.3.2) para resolver destinatarios, y sus integraciones entrantes se resuelven mediante Domain Events de IAM, Pagos y Suscripciones, Soporte Técnico y Telemetría.

| Propiedad | Valor |
| --- | --- |
| Nombre | NotificationController |
| Categoría | Controller |
| Propósito | Exponer la consulta del historial de notificaciones y la confirmación por parte del cuidador. |
| Aggregate/Entity relacionado | Notification |
| Ruta base | /api/v1/notifications |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| getNotificationById | /{notificationId} (GET) | path: notificationId: Long | Obtiene el detalle de una notificación | GetNotificationByIdQuery |
| getNotificationsByCaregiver | /by-caregiver/{caregiverAccountId} (GET) | path: caregiverAccountId: Long | Lista el historial de notificaciones de un cuidador | GetNotificationsByCaregiverIdQuery |
| confirmNotification | /{notificationId}/confirm (POST) | path: notificationId: Long; body: ConfirmNotificationResource { caregiverAccountId: Long } | Confirma la notificación y la cierra | ConfirmNotificationCommand |

### 5.8.3. Application Layer

La Application Layer traduce cada Command y Query en un handler dedicado, y resuelve mediante ocho Event Handlers las integraciones entrantes: cuatro consumen eventos de IAM (5.1.1), uno de Pagos y Suscripciones (5.6.1), uno de Soporte Técnico (5.7.1), y dos de Telemetría (a formalizar en 5.10). Todos convergen en `GenerateNotificationCommand`.

**AccountEmailVerifiedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | AccountEmailVerifiedEventHandler |
| Categoría | Event Handler |
| Propósito | Notificar al titular la activación de su cuenta. |
| Command/Query/Evento que maneja | AccountEmailVerified (evento externo, BC de origen: IAM, ver 5.1.1) |
| Repositorios y servicios que usa | GenerateNotificationCommand (invocado internamente) |
| Eventos que publica | NotificationGenerated (vía el command invocado) |
| User story/capability que habilita | Resuelve la integración declarada en 5.1.1 (Context Mapping 4.2.5) |

**PasswordResetEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | PasswordResetEventHandler |
| Categoría | Event Handler |
| Propósito | Notificar al titular el cambio de su contraseña. |
| Command/Query/Evento que maneja | PasswordReset (evento externo, BC de origen: IAM, ver 5.1.1) |
| Repositorios y servicios que usa | GenerateNotificationCommand (invocado internamente) |
| Eventos que publica | NotificationGenerated (vía el command invocado) |
| User story/capability que habilita | Resuelve la integración declarada en 5.1.1 |

**AccountSuspendedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | AccountSuspendedEventHandler |
| Categoría | Event Handler |
| Propósito | Notificar al titular la suspensión de su cuenta. |
| Command/Query/Evento que maneja | AccountSuspended (evento externo, BC de origen: IAM, ver 5.1.1) |
| Repositorios y servicios que usa | GenerateNotificationCommand (invocado internamente) |
| Eventos que publica | NotificationGenerated (vía el command invocado) |
| User story/capability que habilita | Resuelve la integración declarada en 5.1.1 |

**AccountReactivatedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | AccountReactivatedEventHandler |
| Categoría | Event Handler |
| Propósito | Notificar al titular la reactivación de su cuenta. |
| Command/Query/Evento que maneja | AccountReactivated (evento externo, BC de origen: IAM, ver 5.1.1) |
| Repositorios y servicios que usa | GenerateNotificationCommand (invocado internamente) |
| Eventos que publica | NotificationGenerated (vía el command invocado) |
| User story/capability que habilita | Resuelve la integración declarada en 5.1.1 |

**PaymentPreauthorizationRejectedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | PaymentPreauthorizationRejectedEventHandler |
| Categoría | Event Handler |
| Propósito | Resolver al cuidador principal del hogar vía PerfilesFacade y notificarle el rechazo de la preautorización, sin reintento automático (observación previa #1 de Pagos y Suscripciones). |
| Command/Query/Evento que maneja | PaymentPreauthorizationRejected (evento externo, BC de origen: Pagos y Suscripciones, ver 5.6.1) |
| Repositorios y servicios que usa | PerfilesFacade, GenerateNotificationCommand (invocado internamente) |
| Eventos que publica | NotificationGenerated (vía el command invocado) |
| User story/capability que habilita | Resuelve la integración declarada en 5.6.1 |

**DeviceIssueReportedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | DeviceIssueReportedEventHandler |
| Categoría | Event Handler |
| Propósito | Avisar a la administración cuando un dispositivo es clasificado en una incidencia técnica. |
| Command/Query/Evento que maneja | DeviceIssueReported (evento externo, BC de origen: Soporte Técnico, ver 5.7.1) |
| Repositorios y servicios que usa | GenerateNotificationCommand (invocado internamente, audience = ADMINISTRATION) |
| Eventos que publica | NotificationGenerated (vía el command invocado) |
| User story/capability que habilita | Decisión de negocio del Canvas de Soporte Técnico: "un dispositivo clasificado en una incidencia se avisa a la administración" |

**DeviceFailureDetectedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | DeviceFailureDetectedEventHandler |
| Categoría | Event Handler |
| Propósito | Resolver al cuidador principal del hogar vía PerfilesFacade y notificarle la falla detectada en un dispositivo. |
| Command/Query/Evento que maneja | DeviceFailureDetected (evento externo, BC de origen: Telemetría, a formalizar en 5.10) |
| Repositorios y servicios que usa | PerfilesFacade, GenerateNotificationCommand (invocado internamente) |
| Eventos que publica | NotificationGenerated (vía el command invocado) |
| User story/capability que habilita | Comunicación Entrante del Canvas: "BC Telemetría (fallas y batería baja del dispositivo)" |

**LowBatteryDetectedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | LowBatteryDetectedEventHandler |
| Categoría | Event Handler |
| Propósito | Resolver al cuidador principal del hogar vía PerfilesFacade y notificarle la batería baja de un dispositivo. |
| Command/Query/Evento que maneja | LowBatteryDetected (evento externo, BC de origen: Telemetría, a formalizar en 5.10) |
| Repositorios y servicios que usa | PerfilesFacade, GenerateNotificationCommand (invocado internamente) |
| Eventos que publica | NotificationGenerated (vía el command invocado) |
| User story/capability que habilita | Comunicación Entrante del Canvas: "BC Telemetría (fallas y batería baja del dispositivo)" |

**GenerateNotificationCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GenerateNotificationCommandHandler |
| Categoría | Command Handler |
| Propósito | Crear la notificación en estado GENERATED y disparar su envío. |
| Command/Query/Evento que maneja | GenerateNotificationCommand |
| Repositorios y servicios que usa | NotificationRepository, SendNotificationCommand (invocado internamente) |
| Eventos que publica | NotificationGenerated |
| User story/capability que habilita | Invocado por los ocho Event Handlers entrantes (5.8.3) |

**SendNotificationCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | SendNotificationCommandHandler |
| Categoría | Command Handler |
| Propósito | Enviar la notificación push vía Firebase Cloud Messaging al destinatario resuelto. |
| Command/Query/Evento que maneja | SendNotificationCommand |
| Repositorios y servicios que usa | NotificationRepository, PushNotificationGateway |
| Eventos que publica | NotificationSent |
| User story/capability que habilita | Supuesto del Canvas: "Firebase Cloud Messaging es el proveedor de envío" |

**ConfirmNotificationCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | ConfirmNotificationCommandHandler |
| Categoría | Command Handler |
| Propósito | Confirmar la notificación por parte del cuidador y cerrarla. |
| Command/Query/Evento que maneja | ConfirmNotificationCommand |
| Repositorios y servicios que usa | NotificationRepository |
| Eventos que publica | NotificationConfirmed, NotificationClosed |
| User story/capability que habilita | Decisión de negocio del Canvas: "toda notificación registra su estado (atendida, confirmada, cerrada)" |

**RepeatNotificationCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RepeatNotificationCommandHandler |
| Categoría | Command Handler |
| Propósito | Reenviar una notificación crítica que no fue confirmada dentro del tiempo límite configurable. |
| Command/Query/Evento que maneja | RepeatNotificationCommand |
| Repositorios y servicios que usa | NotificationRepository, PushNotificationGateway |
| Eventos que publica | NotificationRepeated |
| User story/capability que habilita | Resuelve la observación previa #2; invocado únicamente por el scheduler de Infrastructure (5.8.4) |

**GetNotificationByIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetNotificationByIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el detalle de una notificación. |
| Command/Query/Evento que maneja | GetNotificationByIdQuery |
| Repositorios y servicios que usa | NotificationRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getNotificationById |

**GetNotificationsByCaregiverIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetNotificationsByCaregiverIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el historial de notificaciones de un cuidador para el panel de notificaciones. |
| Command/Query/Evento que maneja | GetNotificationsByCaregiverIdQuery |
| Repositorios y servicios que usa | NotificationRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getNotificationsByCaregiver |

### 5.8.4. Infrastructure Layer

La Infrastructure Layer implementa el repositorio de Notification sobre PostgreSQL, el adaptador hacia Firebase Cloud Messaging, un scheduler que detecta notificaciones críticas vencidas, y el suscriptor del bus de eventos interno que conecta a Comunicaciones con IAM, Pagos y Suscripciones, Soporte Técnico y Telemetría.

| Nombre | Interfaz que implementa | Tecnología | Propósito |
| --- | --- | --- | --- |
| NotificationRepositoryJpa | NotificationRepository | Spring Data JPA sobre PostgreSQL | Persiste y recupera el aggregate Notification. |

La persistencia se configura mediante `ComunicacionesJpaConfiguration`, que habilita el repositorio Spring Data JPA (`@EnableJpaRepositories`) y el mapeo objeto-relacional de `Notification` sobre el motor PostgreSQL.

| Nombre | Categoría | Interfaz que implementa | Servicio externo | Propósito |
| --- | --- | --- | --- | --- |
| FirebaseCloudMessagingGateway | Gateway | PushNotificationGateway | Firebase Cloud Messaging | Envía las notificaciones push al dispositivo móvil del destinatario. |
| NotificationExpirationScheduler | Scheduler | — (tarea programada local) | — | Detecta notificaciones CRITICAL en SENT que vencieron su tiempo límite configurable sin confirmación e invoca RepeatNotificationCommand (observación previa #2). |
| DomainEventBusSubscriber | Event Subscriber | AccountEmailVerifiedListener, PasswordResetListener, AccountSuspendedListener, AccountReactivatedListener, PaymentPreauthorizationRejectedListener, DeviceIssueReportedListener, DeviceFailureDetectedListener, LowBatteryDetectedListener | Bus de eventos interno del monolito modular (Spring Application Events) | Enruta los eventos de IAM, Pagos y Suscripciones, Soporte Técnico y Telemetría hacia los ocho Event Handlers de Comunicaciones. |

| Tabla/Colección | Propósito |
| --- | --- |
| notifications | Almacena el aggregate Notification: mensaje, prioridad, audiencia, destinatario y estado. |

| Objeto | BC responsable | Justificación |
| --- | --- | --- |
| Cuenta / credenciales | IAM | La identidad del destinatario es responsabilidad de IAM; Comunicaciones solo referencia recipientAccountId. |
| Cuidador principal de un hogar | Perfiles | La asignación del cuidador principal es responsabilidad de Perfiles; Comunicaciones la resuelve vía PerfilesFacade (5.3.2), sin acceder directamente a HomeProfile. |
| Invitación / vinculación de cuidadores | Cuidado | No se modela una integración entrante desde Cuidado en este capítulo: ningún Canvas (ni el de Cuidado ni el de Comunicaciones) nombra un evento concreto que la sustente, pese a que el Context Mapping (4.2.5) lo mencione como proveedor. Queda como una brecha de documentación a nivel estratégico, no resuelta aquí para no inventar un contrato sin evidencia. |
| Alertas de dispositivos (Bienes) | Bienes | Mismo caso que Cuidado: el Context Mapping lo nombra como proveedor, pero ningún Canvas concreto nombra el evento; no se modela para evitar inventar un contrato sin evidencia (a revisar si surge evidencia en 5.11). |

**Verificación de trazabilidad — Comunicaciones**

| Criterio | Cumple | Evidencia |
| --- | --- | --- |
| Todo Command/Query usado en un endpoint o consumer existe en Domain y tiene su handler en Application | Sí | Los 4 commands y las 2 queries de 5.8.1 tienen su handler correspondiente en 5.8.3. |
| Todo Command/Query declarado en Domain es usado por algún endpoint, consumer o event handler (o se justifica) | Sí | GenerateNotificationCommand se usa desde los ocho Event Handlers entrantes; SendNotificationCommand y RepeatNotificationCommand se usan desde GenerateNotificationCommandHandler y el scheduler respectivamente, justificado en 5.8.2. |
| Los parámetros de cada endpoint cubren los parámetros del Command/Query que despacha | Sí | Cada Resource de la tabla de endpoints (5.8.2) mapea 1:1 los parámetros del Command correspondiente. |
| Todo controller está relacionado con un aggregate o entity existente en la Domain Layer | Sí | NotificationController se relaciona con Notification. |
| Toda interfaz de repositorio del Domain tiene implementación en Infrastructure, y viceversa | Sí | NotificationRepository ↔ NotificationRepositoryJpa. |
| Todo Domain Event publicado tiene al menos un handler o consumidor identificado (en este u otro BC) | Sí, con justificación | Los eventos del ciclo de vida de Notification no tienen consumidor externo declarado en el Canvas (4.2.4) y se publican para auditoría; esto es consistente con el patrón de otros bounded contexts terminales del flujo de notificación. |
| Ningún aggregate de este BC es aggregate root en otro BC | Sí | Notification es exclusivo de este bounded context. |
| Ninguna clase de Domain depende de Infrastructure ni de frameworks | Sí | PushNotificationGateway se declara como puerto en Domain; su implementación concreta (FirebaseCloudMessagingGateway) está en Infrastructure (5.8.4). |

### 5.8.5. Bounded Context Software Architecture Component Level Diagrams

### 5.8.6. Bounded Context Software Architecture Code Level Diagrams

#### 5.8.6.1. Bounded Context Domain Layer Class Diagrams

#### 5.8.6.2. Bounded Context Database Design Diagram

<div style="page-break-after: always;"></div>

## 5.9. Bounded Context: Analíticas

El bounded context **Analíticas** consolida y expone las métricas del sistema —globales, de ventas y de rendimiento de dispositivos— a través de un dashboard principal, según el rol del usuario (decisión de negocio del Canvas). A diferencia de los bounded contexts anteriores (contexto de ejecución), Analíticas tiene rol de **contexto de análisis** (4.2.4): sus datos se calculan en tiempo real a partir de registros ya existentes en Pagos y Suscripciones y Telemetría, sin refresco periódico ni histórico almacenado (Supuesto del Canvas: "el dashboard se actualiza al momento de solicitar las métricas"), lo que resuelve directamente las dos preguntas abiertas del Canvas. Participan el **Administrador** (métricas globales), el **Gestor de suscripciones** (ventas) y el **Cuidador** (rendimiento de dispositivos); el BC Bienes también consulta las métricas globales como colaborador de lectura.

### 5.9.1. Domain Layer

La Domain Layer modela dos aggregates de solo registro (append-only), fieles al EventStorming de Paso 10: `Sale`, que representa una venta de suscripción concluida, y `DeviceMetric`, que representa un registro de rendimiento de un dispositivo. Ninguno tiene ciclo de vida con estados: ambos se crean una vez y no se modifican.

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| Sale | Aggregate Root | Representa una venta de suscripción concluida, relevante para el Gestor de suscripciones (lenguaje ubicuo del Canvas). Se crea al consumir SubscriptionActivated de Pagos y Suscripciones (5.6.1); no se modifica después de creada. |
| DeviceMetric | Aggregate Root | Representa un indicador de rendimiento de un dispositivo, calculado a partir de la telemetría. Se crea al consumir el registro de métricas de Telemetría (a formalizar en 5.10); no se modifica después de creado. |

No se identifican Entities ni Enums en este bounded context: ambos aggregates son registros simples sin estados ni componentes internos con identidad propia.

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| SaleId | Value Object | Identificador tipado del aggregate Sale; no admite valores nulos ni negativos. |
| DeviceMetricId | Value Object | Identificador tipado del aggregate DeviceMetric; no admite valores nulos ni negativos. |
| MetricValue | Value Object | Valor numérico de una métrica con su unidad; no admite valores nulos. |

No se declaran Factories ni Domain Services en este bounded context: `Sale` y `DeviceMetric` son aggregates de solo registro, sin colaboración entre sí ni con otros aggregates en el mismo proceso de escritura. Las métricas agregadas (globales, de ventas, de rendimiento) se calculan en tiempo real dentro de los Query Handlers (5.9.3), no mediante un Domain Service, dado que no imponen ninguna regla de negocio, solo lectura y agregación.

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| RegisterSaleCommand | Registra una venta de suscripción concluida, invocado únicamente por SubscriptionActivatedEventHandler. | subscriptionId: Long, planId: Long, amount: Money |
| RegisterDeviceMetricCommand | Registra un indicador de rendimiento de un dispositivo, invocado únicamente por DeviceMetricsRegisteredEventHandler. | deviceId: Long, metricType: String, value: Double |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| GetGlobalMetricsQuery | Calcula en tiempo real las métricas globales del sistema a partir de Sale y DeviceMetric, visibles para el Administrador (decisión de negocio del Canvas: "cada rol accede solo a las métricas relevantes para su función"). | — |
| GetSalesMetricsQuery | Calcula en tiempo real las métricas de ventas a partir de Sale, relevantes para el Gestor de suscripciones. | — |
| GetDevicePerformanceQuery | Calcula en tiempo real el rendimiento de un dispositivo a partir de DeviceMetric, consultable por el Cuidador. | deviceId: Long |

Ninguno de los siguientes Domain Events tiene un consumidor externo declarado en el Canvas (4.2.4): este bounded context es terminal en el flujo de datos (contexto de análisis) y no alimenta a otro BC.

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| SaleRegistered | Se publica al registrarse una venta de suscripción concluida. | saleId: Long, subscriptionId: Long, planId: Long, amount: Money, registeredAt: LocalDateTime |
| DeviceMetricRegistered | Se publica al registrarse un indicador de rendimiento de un dispositivo. | metricId: Long, deviceId: Long, metricType: String, value: Double, registeredAt: LocalDateTime |

| Nombre | Aggregate que gestiona | Descripción |
| --- | --- | --- |
| SaleRepository | Sale | Persiste y recupera el aggregate Sale. |
| DeviceMetricRepository | DeviceMetric | Persiste y recupera el aggregate DeviceMetric; expone la búsqueda por deviceId. |

| Clase origen | Relación | Clase destino | Descripción |
| --- | --- | --- | --- |
| SaleRepository | depende de | Sale | El repositorio persiste y recupera el aggregate Sale. |
| DeviceMetricRepository | depende de | DeviceMetric | El repositorio persiste y recupera el aggregate DeviceMetric. |

### 5.9.2. Interface Layer

La Interface Layer expone un único controller, `AnalyticsController`, en lugar de un controller por aggregate: ni `Sale` ni `DeviceMetric` se manipulan directamente vía REST (se crean exclusivamente desde Event Handlers, 5.9.3); lo que los actores consumen son las tres queries agregadas del dashboard. Este bounded context no consume mensajería de dispositivos IoT directamente y no expone un facade/ACL: es terminal en el flujo de datos, consumiendo de Pagos y Suscripciones y Telemetría mediante Domain Events.

| Propiedad | Valor |
| --- | --- |
| Nombre | AnalyticsController |
| Categoría | Controller |
| Propósito | Exponer las métricas globales, de ventas y de rendimiento de dispositivos del dashboard principal. |
| Aggregate/Entity relacionado | Sale, DeviceMetric |
| Ruta base | /api/v1/analytics |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| getGlobalMetrics | /global-metrics (GET) | — | Obtiene las métricas globales del sistema | GetGlobalMetricsQuery |
| getSalesMetrics | /sales-metrics (GET) | — | Obtiene las métricas de ventas | GetSalesMetricsQuery |
| getDevicePerformance | /devices/{deviceId}/performance (GET) | path: deviceId: Long | Obtiene el rendimiento de un dispositivo | GetDevicePerformanceQuery |

### 5.9.3. Application Layer

La Application Layer traduce cada Command y Query en un handler dedicado, y resuelve mediante dos Event Handlers las integraciones entrantes: una con Pagos y Suscripciones (ya modelada, 5.6.1) y una con Telemetría (a formalizar en 5.10).

**SubscriptionActivatedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | SubscriptionActivatedEventHandler |
| Categoría | Event Handler |
| Propósito | Registrar la venta concluida al activarse una suscripción. |
| Command/Query/Evento que maneja | SubscriptionActivated (evento externo, BC de origen: Pagos y Suscripciones, ver 5.6.1) |
| Repositorios y servicios que usa | RegisterSaleCommand (invocado internamente) |
| Eventos que publica | SaleRegistered (vía el command invocado) |
| User story/capability que habilita | Lenguaje ubicuo del Canvas: "Venta: transacción de suscripción concluida" |

**DeviceMetricsRegisteredEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | DeviceMetricsRegisteredEventHandler |
| Categoría | Event Handler |
| Propósito | Registrar el indicador de rendimiento calculado a partir de la telemetría de un dispositivo. |
| Command/Query/Evento que maneja | DeviceMetricsRegistered (evento externo, BC de origen: Telemetría, a formalizar en 5.10) |
| Repositorios y servicios que usa | RegisterDeviceMetricCommand (invocado internamente) |
| Eventos que publica | DeviceMetricRegistered (vía el command invocado) |
| User story/capability que habilita | Supuesto del Canvas: "las métricas de rendimiento de dispositivos provienen del BC Telemetría" |

**RegisterSaleCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RegisterSaleCommandHandler |
| Categoría | Command Handler |
| Propósito | Crear el registro de venta concluida. |
| Command/Query/Evento que maneja | RegisterSaleCommand |
| Repositorios y servicios que usa | SaleRepository |
| Eventos que publica | SaleRegistered |
| User story/capability que habilita | Invocado únicamente por SubscriptionActivatedEventHandler |

**RegisterDeviceMetricCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RegisterDeviceMetricCommandHandler |
| Categoría | Command Handler |
| Propósito | Crear el registro de rendimiento de un dispositivo. |
| Command/Query/Evento que maneja | RegisterDeviceMetricCommand |
| Repositorios y servicios que usa | DeviceMetricRepository |
| Eventos que publica | DeviceMetricRegistered |
| User story/capability que habilita | Invocado únicamente por DeviceMetricsRegisteredEventHandler |

**GetGlobalMetricsQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetGlobalMetricsQueryHandler |
| Categoría | Query Handler |
| Propósito | Calcular en tiempo real las métricas globales agregando Sale y DeviceMetric. |
| Command/Query/Evento que maneja | GetGlobalMetricsQuery |
| Repositorios y servicios que usa | SaleRepository, DeviceMetricRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getGlobalMetrics, usado también por el BC Bienes |

**GetSalesMetricsQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetSalesMetricsQueryHandler |
| Categoría | Query Handler |
| Propósito | Calcular en tiempo real las métricas de ventas agregando Sale. |
| Command/Query/Evento que maneja | GetSalesMetricsQuery |
| Repositorios y servicios que usa | SaleRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getSalesMetrics |

**GetDevicePerformanceQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetDevicePerformanceQueryHandler |
| Categoría | Query Handler |
| Propósito | Calcular en tiempo real el rendimiento de un dispositivo agregando DeviceMetric. |
| Command/Query/Evento que maneja | GetDevicePerformanceQuery |
| Repositorios y servicios que usa | DeviceMetricRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getDevicePerformance |

### 5.9.4. Infrastructure Layer

La Infrastructure Layer implementa el repositorio de Sale sobre PostgreSQL y el de DeviceMetric sobre MongoDB, honrando la persistencia políglota decidida en el capítulo 4 (TS-47/TS-48): datos transaccionales de ventas en PostgreSQL, datos de telemetría de alto volumen y esquema variable en MongoDB.

| Nombre | Interfaz que implementa | Tecnología | Propósito |
| --- | --- | --- | --- |
| SaleRepositoryJpa | SaleRepository | Spring Data JPA sobre PostgreSQL | Persiste y recupera el aggregate Sale. |
| DeviceMetricRepositoryMongo | DeviceMetricRepository | Spring Data MongoDB | Persiste y recupera el aggregate DeviceMetric. |

La persistencia se configura mediante `AnaliticasPersistenceConfiguration`, que habilita los repositorios Spring Data JPA (`@EnableJpaRepositories`) para `Sale` y Spring Data MongoDB (`@EnableMongoRepositories`) para `DeviceMetric`.

| Nombre | Categoría | Interfaz que implementa | Servicio externo | Propósito |
| --- | --- | --- | --- | --- |
| DomainEventBusSubscriber | Event Subscriber | SubscriptionActivatedListener, DeviceMetricsRegisteredListener | Bus de eventos interno del monolito modular (Spring Application Events) | Enruta los eventos de Pagos y Suscripciones y Telemetría hacia los Event Handlers de Analíticas. |

| Tabla/Colección | Propósito |
| --- | --- |
| sales (PostgreSQL) | Almacena el aggregate Sale: suscripción, plan y monto de cada venta concluida. |
| device_metrics (MongoDB) | Almacena el aggregate DeviceMetric: indicadores de rendimiento por dispositivo. |

| Objeto | BC responsable | Justificación |
| --- | --- | --- |
| Suscripción / pago | Pagos y Suscripciones | El ciclo de vida comercial de la suscripción es responsabilidad de Pagos y Suscripciones; Analíticas solo registra la venta concluida al consumir SubscriptionActivated. |
| Telemetría cruda de dispositivos | Telemetría | Los datos crudos de telemetría son responsabilidad de Telemetría; Analíticas solo registra los indicadores ya calculados (a formalizar en 5.10). |
| Datos operativos de Soporte Técnico y Bienes | Soporte Técnico / Bienes | El Context Mapping (4.2.5) menciona un patrón conformista hacia estos dos BC, pero ningún Canvas concreto (ni el de Soporte Técnico ni el de Analíticas) nombra un evento de métricas que lo sustente; no se modela para evitar inventar un contrato sin evidencia (misma brecha documentada en 5.8.4 para Comunicaciones). |

**Verificación de trazabilidad — Analíticas**

| Criterio | Cumple | Evidencia |
| --- | --- | --- |
| Todo Command/Query usado en un endpoint o consumer existe en Domain y tiene su handler en Application | Sí | Los 2 commands y las 3 queries de 5.9.1 tienen su handler correspondiente en 5.9.3. |
| Todo Command/Query declarado en Domain es usado por algún endpoint, consumer o event handler (o se justifica) | Sí | RegisterSaleCommand y RegisterDeviceMetricCommand se usan exclusivamente desde sus Event Handlers respectivos, justificado en 5.9.2; las 3 queries se usan desde AnalyticsController. |
| Los parámetros de cada endpoint cubren los parámetros del Command/Query que despacha | Sí | Cada endpoint de la tabla (5.9.2) mapea 1:1 los parámetros de la Query correspondiente. |
| Todo controller está relacionado con un aggregate o entity existente en la Domain Layer | Sí | AnalyticsController se relaciona con Sale y DeviceMetric, justificado como excepción deliberada en 5.9.2. |
| Toda interfaz de repositorio del Domain tiene implementación en Infrastructure, y viceversa | Sí | SaleRepository ↔ SaleRepositoryJpa; DeviceMetricRepository ↔ DeviceMetricRepositoryMongo. |
| Todo Domain Event publicado tiene al menos un handler o consumidor identificado (en este u otro BC) | Sí, con justificación | SaleRegistered y DeviceMetricRegistered no tienen consumidor externo declarado en el Canvas (4.2.4): este bounded context es terminal en el flujo de datos (contexto de análisis). |
| Ningún aggregate de este BC es aggregate root en otro BC | Sí | Sale y DeviceMetric son exclusivos de este bounded context. |
| Ninguna clase de Domain depende de Infrastructure ni de frameworks | Sí | Los repositorios se declaran como puertos en Domain; sus implementaciones concretas (SaleRepositoryJpa, DeviceMetricRepositoryMongo) están en Infrastructure (5.9.4). |

### 5.9.5. Bounded Context Software Architecture Component Level Diagrams

### 5.9.6. Bounded Context Software Architecture Code Level Diagrams

#### 5.9.6.1. Bounded Context Domain Layer Class Diagrams

#### 5.9.6.2. Bounded Context Database Design Diagram

<div style="page-break-after: always;"></div>

## 5.10. Bounded Context: Telemetría

El bounded context **Telemetría** monitorea el estado y las fallas de los dispositivos del hogar, informa ese estado a cuidadores y técnicos, y garantiza la continuidad del servicio cuando se pierde la conexión mediante almacenamiento local y sincronización posterior. Es un dominio núcleo. Participan el **Técnico** (monitorea el estado) y el **Cuidador** (reporta irregularidades). Los datos capturados de los dispositivos llegan desde el BC Bienes (Supuesto del Canvas), a formalizar en 5.11. Este bounded context cierra dos compromisos pendientes: publica `DeviceMetricsRegistered` (consumido por Analíticas, 5.9.3) y `DeviceFailureDetected`/`LowBatteryDetected` (consumidos por Comunicaciones, 5.8.3); además resuelve su propia pregunta abierta sobre alertas de auxilio publicando `HelpAlertDetected`, que agrega como un tercer compromiso con Comunicaciones (observación previa #1).

### 5.10.1. Domain Layer

La Domain Layer modela dos aggregates independientes, fieles al EventStorming de Paso 10: `Monitoring`, que registra el seguimiento del estado y las fallas de un dispositivo, y `Synchronization`, que gestiona la operación sin conexión y la sincronización posterior de eventos.

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| Monitoring | Aggregate Root | Representa el seguimiento del estado y de las fallas de un dispositivo. Las fallas, la batería baja y las alertas de auxilio se comunican al cuidador principal (decisión de negocio del Canvas, observación previa #1); las métricas se registran al informar el estado del dispositivo. |
| Synchronization | Aggregate Root | Representa la operación sin conexión de un dispositivo. Si se pierde la conexión, los eventos se almacenan localmente y se sincronizan al restablecerse (decisión de negocio del Canvas); no se modela un límite de tiempo ni un escalamiento adicional por desconexión prolongada (observación previa #2). |

No se identifican Entities en este bounded context: ambos aggregates son simples, sin componentes internos con identidad propia.

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| MonitoringId | Value Object | Identificador tipado del aggregate Monitoring; no admite valores nulos ni negativos. |
| SynchronizationId | Value Object | Identificador tipado del aggregate Synchronization; no admite valores nulos ni negativos. |
| IrregularityDescription | Value Object | Descripción de la irregularidad reportada por el Cuidador; no admite valores vacíos. |

| Nombre | Categoría | Descripción |
| --- | --- | --- |
| DeviceEventType | Enum | Tipo de evento capturado de un dispositivo: `DOOR_FAILURE`, `WINDOW_FAILURE`, `LIGHTING_FAILURE`, `MICROPHONE_FAILURE`, `LOW_BATTERY`, `HELP_ALERT` (observación previa #1) o `STATUS_UPDATE`. No exhibe transiciones: determina qué Domain Event publica RegisterDeviceEventCommand. |
| SynchronizationStatus | Enum | Estado de la sincronización de un dispositivo. Transiciones permitidas: `ONLINE` → `OFFLINE` al perderse la conexión; `OFFLINE` → `SYNCING` al restablecerse; `SYNCING` → `COMPLETED` al sincronizarse los eventos almacenados; `COMPLETED` → `ONLINE`, cerrando el ciclo (decisión de negocio del Canvas). |

No se declaran Factories ni Domain Services en este bounded context: `Monitoring` y `Synchronization` son aggregates independientes por dispositivo, sin colaboración entre sí en el mismo proceso de escritura.

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| RegisterDeviceEventCommand | Registra un evento capturado de un dispositivo (falla, batería baja, alerta de auxilio o actualización de estado), invocado al consumir los datos del BC Bienes. | deviceId: Long, eventType: DeviceEventType, detail: String |
| ReportIrregularityCommand | Reporta una irregularidad sobre un dispositivo, a solicitud del Cuidador. | deviceId: Long, description: String, reportedBy: Long |
| StartOfflineOperationCommand | Marca un dispositivo como operando sin conexión, invocado al consumir la pérdida de conexión reportada por el BC Bienes. | deviceId: Long |
| SynchronizeEventsCommand | Sincroniza los eventos almacenados localmente al restablecerse la conexión. | deviceId: Long, eventCount: Int |

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| GetMonitoringByDeviceIdQuery | Obtiene el estado de monitoreo de un dispositivo. | deviceId: Long |
| GetSynchronizationByDeviceIdQuery | Obtiene el estado de sincronización de un dispositivo. | deviceId: Long |

`DeviceFailureDetected`, `LowBatteryDetected` y `HelpAlertDetected` los consume Comunicaciones (5.8.3, el tercero a agregar como seguimiento de esta sección); `DeviceMetricsRegistered` lo consume Analíticas (5.9.3). El resto no tiene consumidor externo declarado en el Canvas y se publica para auditoría.

| Nombre | Descripción | Parámetros |
| --- | --- | --- |
| DeviceFailureDetected | Se publica al registrarse una falla de puerta, ventana, iluminación o micrófono; es consumido por Comunicaciones (5.8.3). | deviceId: Long, failureType: DeviceEventType, detectedAt: LocalDateTime |
| LowBatteryDetected | Se publica al detectarse batería baja; es consumido por Comunicaciones (5.8.3). | deviceId: Long, detectedAt: LocalDateTime |
| HelpAlertDetected | Se publica al detectarse una alerta de auxilio; resuelve la observación previa #1 y es consumido por Comunicaciones. | deviceId: Long, detectedAt: LocalDateTime |
| DeviceStatusUpdated | Se publica al actualizarse el estado rutinario de un dispositivo. | deviceId: Long, updatedAt: LocalDateTime |
| DeviceMetricsRegistered | Se publica al informar el estado del dispositivo o al completar una sincronización; es consumido por Analíticas (5.9.3). | deviceId: Long, metricType: String, value: Double, registeredAt: LocalDateTime |
| IrregularityReported | Se publica al reportarse una irregularidad sobre un dispositivo. | monitoringId: Long, deviceId: Long, description: String, reportedAt: LocalDateTime |
| OfflineOperationStarted | Se publica al marcarse un dispositivo como operando sin conexión. | synchronizationId: Long, deviceId: Long, startedAt: LocalDateTime |
| EventsSynchronized | Se publica al completarse la sincronización de los eventos almacenados localmente (observación previa #2: sin límite de tiempo evidenciado). | synchronizationId: Long, deviceId: Long, eventCount: Int, completedAt: LocalDateTime |

| Nombre | Aggregate que gestiona | Descripción |
| --- | --- | --- |
| MonitoringRepository | Monitoring | Persiste y recupera el aggregate Monitoring; expone la búsqueda por deviceId. |
| SynchronizationRepository | Synchronization | Persiste y recupera el aggregate Synchronization; expone la búsqueda por deviceId. |

| Clase origen | Relación | Clase destino | Descripción |
| --- | --- | --- | --- |
| MonitoringRepository | depende de | Monitoring | El repositorio persiste y recupera el aggregate Monitoring. |
| SynchronizationRepository | depende de | Synchronization | El repositorio persiste y recupera el aggregate Synchronization. |

### 5.10.2. Interface Layer

La Interface Layer expone un controller por cada aggregate root: `MonitoringController` y `SynchronizationController`. `RegisterDeviceEventCommand`, `StartOfflineOperationCommand` y `SynchronizeEventsCommand` no se exponen vía REST: se invocan exclusivamente desde los Event Handlers que consumen datos del BC Bienes (5.10.3). Este bounded context no expone un facade/ACL: sus integraciones salientes se resuelven mediante el adaptador de Firebase y los Domain Events hacia Comunicaciones y Analíticas.

| Propiedad | Valor |
| --- | --- |
| Nombre | MonitoringController |
| Categoría | Controller |
| Propósito | Exponer la consulta del estado de monitoreo y el reporte de irregularidades de un dispositivo. |
| Aggregate/Entity relacionado | Monitoring |
| Ruta base | /api/v1/monitoring |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| getMonitoringByDevice | /{deviceId} (GET) | path: deviceId: Long | Obtiene el estado de monitoreo de un dispositivo | GetMonitoringByDeviceIdQuery |
| reportIrregularity | /{deviceId}/irregularities (POST) | path: deviceId: Long; body: ReportIrregularityResource { description: String, reportedBy: Long } | Reporta una irregularidad sobre un dispositivo | ReportIrregularityCommand |

| Propiedad | Valor |
| --- | --- |
| Nombre | SynchronizationController |
| Categoría | Controller |
| Propósito | Exponer la consulta del estado de sincronización de un dispositivo. |
| Aggregate/Entity relacionado | Synchronization |
| Ruta base | /api/v1/synchronization |

| Nombre | Ruta REST (verbo HTTP) | Parámetros | Acción | Command/Query que maneja |
| --- | --- | --- | --- | --- |
| getSynchronizationByDevice | /{deviceId} (GET) | path: deviceId: Long | Obtiene el estado de sincronización de un dispositivo | GetSynchronizationByDeviceIdQuery |

### 5.10.3. Application Layer

La Application Layer traduce cada Command y Query en un handler dedicado, y resuelve mediante tres Event Handlers las integraciones entrantes desde el BC Bienes (Supuesto del Canvas: "los datos capturados de los dispositivos llegan desde el BC Bienes"), a formalizar en 5.11.

**DeviceDataCapturedEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | DeviceDataCapturedEventHandler |
| Categoría | Event Handler |
| Propósito | Registrar el evento capturado de un dispositivo (falla, batería baja, alerta de auxilio o actualización de estado). |
| Command/Query/Evento que maneja | DeviceDataCaptured (evento externo, BC de origen: Bienes, a formalizar en 5.11) |
| Repositorios y servicios que usa | RegisterDeviceEventCommand (invocado internamente) |
| Eventos que publica | DeviceFailureDetected, LowBatteryDetected, HelpAlertDetected, DeviceStatusUpdated o DeviceMetricsRegistered, según el tipo de evento (vía el command invocado) |
| User story/capability que habilita | Comunicación Entrante del Canvas: "BC Bienes (datos capturados de los dispositivos) → Monitorear dispositivo" |

**DeviceConnectionLostEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | DeviceConnectionLostEventHandler |
| Categoría | Event Handler |
| Propósito | Marcar el dispositivo como operando sin conexión. |
| Command/Query/Evento que maneja | DeviceConnectionLost (evento externo, BC de origen: Bienes, a formalizar en 5.11) |
| Repositorios y servicios que usa | StartOfflineOperationCommand (invocado internamente) |
| Eventos que publica | OfflineOperationStarted (vía el command invocado) |
| User story/capability que habilita | Comunicación Entrante del Canvas: "BC Bienes (datos capturados de los dispositivos) → Operar sin conexión" |

**DeviceConnectionRestoredEventHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | DeviceConnectionRestoredEventHandler |
| Categoría | Event Handler |
| Propósito | Sincronizar los eventos almacenados localmente durante la desconexión. |
| Command/Query/Evento que maneja | DeviceConnectionRestored (evento externo, BC de origen: Bienes, a formalizar en 5.11) |
| Repositorios y servicios que usa | SynchronizeEventsCommand (invocado internamente) |
| Eventos que publica | EventsSynchronized, DeviceMetricsRegistered (vía el command invocado) |
| User story/capability que habilita | Decisión de negocio del Canvas: "si se pierde la conexión, los eventos se almacenan localmente y se sincronizan al restablecerse" |

**RegisterDeviceEventCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | RegisterDeviceEventCommandHandler |
| Categoría | Command Handler |
| Propósito | Registrar el evento en Monitoring y publicar el Domain Event correspondiente según su tipo. |
| Command/Query/Evento que maneja | RegisterDeviceEventCommand |
| Repositorios y servicios que usa | MonitoringRepository |
| Eventos que publica | DeviceFailureDetected, LowBatteryDetected, HelpAlertDetected, DeviceStatusUpdated o DeviceMetricsRegistered, según eventType |
| User story/capability que habilita | Invocado únicamente por DeviceDataCapturedEventHandler |

**ReportIrregularityCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | ReportIrregularityCommandHandler |
| Categoría | Command Handler |
| Propósito | Registrar la irregularidad reportada por el Cuidador sobre un dispositivo. |
| Command/Query/Evento que maneja | ReportIrregularityCommand |
| Repositorios y servicios que usa | MonitoringRepository |
| Eventos que publica | IrregularityReported |
| User story/capability que habilita | Comunicación Entrante del Canvas: "Cuidador → Monitorear irregularidades del dispositivo" |

**StartOfflineOperationCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | StartOfflineOperationCommandHandler |
| Categoría | Command Handler |
| Propósito | Marcar el dispositivo como OFFLINE. |
| Command/Query/Evento que maneja | StartOfflineOperationCommand |
| Repositorios y servicios que usa | SynchronizationRepository |
| Eventos que publica | OfflineOperationStarted |
| User story/capability que habilita | Invocado únicamente por DeviceConnectionLostEventHandler |

**SynchronizeEventsCommandHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | SynchronizeEventsCommandHandler |
| Categoría | Command Handler |
| Propósito | Completar la sincronización de los eventos almacenados localmente y registrar las métricas resultantes. |
| Command/Query/Evento que maneja | SynchronizeEventsCommand |
| Repositorios y servicios que usa | SynchronizationRepository |
| Eventos que publica | EventsSynchronized, DeviceMetricsRegistered |
| User story/capability que habilita | Decisión de negocio del Canvas: "las métricas se registran... al completar la sincronización"; invocado únicamente por DeviceConnectionRestoredEventHandler |

**GetMonitoringByDeviceIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetMonitoringByDeviceIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el estado de monitoreo de un dispositivo. |
| Command/Query/Evento que maneja | GetMonitoringByDeviceIdQuery |
| Repositorios y servicios que usa | MonitoringRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getMonitoringByDevice |

**GetSynchronizationByDeviceIdQueryHandler**

| Propiedad | Valor |
| --- | --- |
| Nombre | GetSynchronizationByDeviceIdQueryHandler |
| Categoría | Query Handler |
| Propósito | Recuperar el estado de sincronización de un dispositivo. |
| Command/Query/Evento que maneja | GetSynchronizationByDeviceIdQuery |
| Repositorios y servicios que usa | SynchronizationRepository |
| Eventos que publica | No aplica |
| User story/capability que habilita | Soporta la consulta desde el endpoint getSynchronizationByDevice |

### 5.10.4. Infrastructure Layer

La Infrastructure Layer implementa los repositorios de Monitoring y Synchronization sobre MongoDB, consistente con la decisión TS-48 de persistencia de telemetría y eventos IoT de alto volumen; el adaptador hacia Firebase para informar el estado del dispositivo; y el suscriptor del bus de eventos interno que conecta a Telemetría con Bienes.

| Nombre | Interfaz que implementa | Tecnología | Propósito |
| --- | --- | --- | --- |
| MonitoringRepositoryMongo | MonitoringRepository | Spring Data MongoDB | Persiste y recupera el aggregate Monitoring. |
| SynchronizationRepositoryMongo | SynchronizationRepository | Spring Data MongoDB | Persiste y recupera el aggregate Synchronization. |

La persistencia se configura mediante `TelemetriaPersistenceConfiguration`, que habilita los repositorios Spring Data MongoDB (`@EnableMongoRepositories`) para `Monitoring` y `Synchronization`.

| Nombre | Categoría | Interfaz que implementa | Servicio externo | Propósito |
| --- | --- | --- | --- | --- |
| FirebaseCloudMessagingGateway | Gateway | DeviceStatusGateway | Firebase Cloud Messaging | Informa el estado del dispositivo (Supuesto del Canvas). |
| DomainEventBusSubscriber | Event Subscriber | DeviceDataCapturedListener, DeviceConnectionLostListener, DeviceConnectionRestoredListener | Bus de eventos interno del monolito modular (Spring Application Events) | Enruta los eventos publicados por Bienes hacia los Event Handlers de Telemetría. |

| Tabla/Colección | Propósito |
| --- | --- |
| monitoring (MongoDB) | Almacena el aggregate Monitoring: eventos, fallas e irregularidades por dispositivo. |
| synchronization (MongoDB) | Almacena el aggregate Synchronization: estado de conectividad y sincronización por dispositivo. |

| Objeto | BC responsable | Justificación |
| --- | --- | --- |
| Dispositivo (registro, configuración) | Bienes | El registro y la configuración del dispositivo como activo son responsabilidad de Bienes; Telemetría solo referencia deviceId y consume sus eventos de datos capturados (a formalizar en 5.11). |
| Notificación al cuidador | Comunicaciones | El envío y la confirmación de la notificación son responsabilidad de Comunicaciones; Telemetría solo publica los eventos de origen (DeviceFailureDetected, LowBatteryDetected, HelpAlertDetected). |
| Métrica agregada del dashboard | Analíticas | El cálculo y la exposición de las métricas agregadas son responsabilidad de Analíticas; Telemetría solo publica el registro individual (DeviceMetricsRegistered). |

**Verificación de trazabilidad — Telemetría**

| Criterio | Cumple | Evidencia |
| --- | --- | --- |
| Todo Command/Query usado en un endpoint o consumer existe en Domain y tiene su handler en Application | Sí | Los 4 commands y las 2 queries de 5.10.1 tienen su handler correspondiente en 5.10.3. |
| Todo Command/Query declarado en Domain es usado por algún endpoint, consumer o event handler (o se justifica) | Sí | RegisterDeviceEventCommand, StartOfflineOperationCommand y SynchronizeEventsCommand se usan exclusivamente desde los tres Event Handlers entrantes, justificado en 5.10.2; ReportIrregularityCommand se usa desde el endpoint manual. |
| Los parámetros de cada endpoint cubren los parámetros del Command/Query que despacha | Sí | Cada Resource de las tablas de endpoints (5.10.2) mapea 1:1 los parámetros del Command correspondiente. |
| Todo controller está relacionado con un aggregate o entity existente en la Domain Layer | Sí | MonitoringController se relaciona con Monitoring; SynchronizationController se relaciona con Synchronization. |
| Toda interfaz de repositorio del Domain tiene implementación en Infrastructure, y viceversa | Sí | MonitoringRepository ↔ MonitoringRepositoryMongo; SynchronizationRepository ↔ SynchronizationRepositoryMongo. |
| Todo Domain Event publicado tiene al menos un handler o consumidor identificado (en este u otro BC) | Sí | DeviceFailureDetected, LowBatteryDetected y HelpAlertDetected los consume Comunicaciones (5.8.3, el tercero a agregar como seguimiento); DeviceMetricsRegistered lo consume Analíticas (5.9.3); el resto se publica para auditoría. |
| Ningún aggregate de este BC es aggregate root en otro BC | Sí | Monitoring y Synchronization son exclusivos de este bounded context. |
| Ninguna clase de Domain depende de Infrastructure ni de frameworks | Sí | DeviceStatusGateway se declara como puerto en Domain; su implementación concreta (FirebaseCloudMessagingGateway) está en Infrastructure (5.10.4). |

### 5.10.5. Bounded Context Software Architecture Component Level Diagrams

### 5.10.6. Bounded Context Software Architecture Code Level Diagrams

#### 5.10.6.1. Bounded Context Domain Layer Class Diagrams

#### 5.10.6.2. Bounded Context Database Design Diagram

<div style="page-break-after: always;"></div>

<div style="page-break-after: always;"></div>