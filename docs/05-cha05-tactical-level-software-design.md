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

### 5.1.3. Application Layer

### 5.1.4. Infrastructure Layer

### 5.1.5. Bounded Context Software Architecture Component Level Diagrams

### 5.1.6. Bounded Context Software Architecture Code Level Diagrams

#### 5.1.6.1. Bounded Context Domain Layer Class Diagrams

#### 5.1.6.2. Bounded Context Database Design Diagram

<div style="page-break-after: always;"></div>