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

La Interface Layer expone dos controllers independientes, uno por cada aggregate root: `ProfileController` y `HomeProfileController`. Ninguno expone `InitializeProfileCommand` ni `ReplacePrincipalCaregiverCommand`, ya que ambos solo se invocan desde Event Handlers en la Application Layer (5.3.3), nunca desde un endpoint REST directo. Este bounded context no consume mensajería de dispositivos IoT y no expone un facade/ACL: sus únicas integraciones salientes son hacia servicios externos (Cloudinary, Google Maps); ningún otro bounded context consume a Perfiles de forma síncrona según el Context Mapping (4.2.5).

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

### 5.5.5. Bounded Context Software Architecture Component Level Diagrams

### 5.5.6. Bounded Context Software Architecture Code Level Diagrams

#### 5.5.6.1. Bounded Context Domain Layer Class Diagrams

#### 5.5.6.2. Bounded Context Database Design Diagram

<div style="page-break-after: always;"></div>