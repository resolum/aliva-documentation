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

### 5.1.2. Interface Layer

### 5.1.3. Application Layer

### 5.1.4. Infrastructure Layer

### 5.1.5. Bounded Context Software Architecture Component Level Diagrams

### 5.1.6. Bounded Context Software Architecture Code Level Diagrams

#### 5.1.6.1. Bounded Context Domain Layer Class Diagrams

#### 5.1.6.2. Bounded Context Database Design Diagram

<div style="page-break-after: always;"></div>