# Capítulo 7: Product Implementation, Validation & Deployment

## 7.1. Software Configuration Management

### 7.1.1. Software Development Environment Configuration

### 7.1.2. Source Code Management

El control de versiones del código fuente de los productos de software para el proyecto se gestiona siguiendo un esquema orientado al trabajo efectivo. Para ello, se utiliza GitHub como plataforma en la nube para el almacenamiento del código de los productos en repositorios asignados para cada uno. Por otro lado, se usa Git Flow como flujo de trabajo para el desarrollo de las funcionalidades de las aplicaciones y la creación de ramas para el trabajo en paralelo del proyecto. A su vez, para un mejor entendimiento del trabajo implementado en cada confirmación (commit), se utiliza Conventional Commits como norma general para cada entrega de avance en los repositorios. Finalmente, se aplica SemVer para el nombrado de versiones de los productos de software.

**Repositorios de los productos de software**

| Producto de software                | URL del repositorio en Github                            |
| ----------------------------------- | -------------------------------------------------------- |
| Sitio web estático                  | https://github.com/resolum/alivia-landing-page           |
| Aplicación web - Usuarios           | https://github.com/resolum/alivia-users-web-application  |
| Aplicación web - Administrativa     | https://github.com/resolum/alivia-admin-web-application  |
| Aplicación móvil - Android          | https://github.com/resolum/alivia-android-application    |
| Aplicación móvil - iOS              | https://github.com/resolum/alivia-ios-application        |
| Servicios Web - REST API            | https://github.com/resolum/alivia-web-services           |
| Servicios en el borde - Controlador | https://github.com/resolum/alivia-control-edge-service   |
| Servicios en el borde - Actuadores  | https://github.com/resolum/alivia-actuators-edge-service |
| Aplicación embebida - Controlador   |                                                          |
| Aplicación embebida - Actuadores    |                                                          |

**Aplicación de Git Flow**

A continuación, se realiza una explicación más detallada sobre el uso de Git Flow en el proyecto. A su vez, se describen las principales reglas que aplican a cada tipo de rama.

<table style="max-width: 100%;">
  <tr>
    <th style="text-align:center;">Rama</th>
    <th style="text-align:center;">Objetivo</th>
    <th style="text-align:center;">Reglas</th>
  </tr>
  <tr>
    <td>main</td>
    <td>Se almacena la última versión más estable del producto lista para fase de producción.</td>
    <td>
      <ul>
        <li>No se realizan commits a esta rama.</li>
        <li>Esta rama solo puede aceptar Pull Requests que provengan desde alguna rama de tipo release.</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>develop</td>
    <td>Esta rama sirve como integradora de todos los cambios realizados relacionados a nuevas funciones o correcciones.</td>
    <td>
      <ul>
        <li>No se realizan commits a esta rama.</li>
        <li>Esta rama solo puede aceptar Pull Requests que provengan desde alguna rama de tipo feature o bugfix.</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>release</td>
    <td>El conjunto de estas ramas facilitan el versionamiento y lanzamiento de nuevas versiones del producto de software.</td>
    <td>
      <ul>
        <li>No se realizan commits a esta rama.</li>
        <li>Esta rama solo puede aceptar Pull Requests que provengan desde alguna rama de tipo bugfix.</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>feature</td>
    <td>El conjunto de estas ramas permiten el desarrollo de nuevas funcionalidades o correcciones previas a la fase de staging</td>
    <td>
      <ul>
        <li>Solo se deben realizar commits acorde a la rama creada.</li>
        <li>Cada rama debe ser nombrada según la funcionalidad que se va a implementar.</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>bugfix</td>
    <td>El conjunto de estas ramas permiten las correcciones de bugs o errores encontrados en la rama release</td>
    <td>
      <ul>
        <li>Los cambios hechos en esta rama deben verse reflejados tanto en la rama develop como en release.</li>
        <li>Cada rama debe ser nombrada según el bug a corregir.</li>
      </ul>
    </td>
  </tr>
</table>

**Uso de Semantic Versioning**

En esta sección, se explica brevemente la forma de aplicación de Semantic Versioning (SemVer). Para ello, se describen los principales componentes que dan forma a la versión de un producto de software.

![Referencia a una versión utilizando Semantic Versioning 2.0](https://miro.medium.com/v2/resize:fit:1200/1*S0S5Qv9AK3mc1M3Vq39nPQ.jpeg)

<table style="max-width: 100%;">
  <tr>
    <th style="text-align:center;">Componente</th>
    <th style="text-align:center;">Objetivo</th>
    <th style="text-align:center;">Reglas</th>
  </tr>
  <tr>
    <td>MAJOR</td>
    <td>Indica la implementación de un cambio que rompe las versiones anteriores</td>
    <td>En Alivia, se utiliza esta versión para el lanzamiento de versiones que incluyan un conjunto sólido de funcionalidades.</td>
  </tr>
  <tr>
    <td>MINOR</td>
    <td>Indica la implementación cambios menores que no afectan la integridad del producto</td>
    <td>En Alivia, se utiliza esta versión cuando se finaliza el desarrollo de un componente que forma parte de un conjunto de funcionalidades.</td>
  </tr>
  <tr>
    <td>PATCH</td>
    <td>Indica la implementación de correcciones pequeñas en el producto</td>
    <td>En Alivia, se utiliza esta versión para indicar que se ha realizado una corrección de un bug ya sea en una rama feature o bugfix.</td>
  </tr>
</table>

**Aplicación de Conventional Commits**

Los commits son necesarios para dar una descripción breve al equipo acerca del contenido agregado o modificado dentro del código de los productos de software. Por ello, se debe seguir un estándar interno que facilite la lectura de estos mensajes y dejen clara qué se ha implementado. A continuación, se explica el estándar definido para los commits dentro de la organización:

<div align="center">
  <img src="https://imgur.com/vfirypa.png" alt="mensaje de ejemplo para commits">
</div>

<table style="max-width: 100%;">
  <tr>
    <th style="text-align:center;">Tipo de commit</th>
    <th style="text-align:center;">Objetivo</th>
    <th style="text-align:center;">Ejemplo</th>
  </tr>
  <tr>
    <td>feat</td>
    <td>Indica la implementación de un componente nuevo de funcionalidad.</td>
    <td>feat(sign-in): add login page.</td>
  </tr>
  <tr>
    <td>fix</td>
    <td>Indica la corrección de un error o bug encontrado en el producto.</td>
    <td>fix: remove hard-coded database password.</td>
  </tr>
  <tr>
    <td>docs</td>
    <td>Indica que se añadió documentación referida al producto de software.</td>
    <td>docs: add iam context domain class diagram.</td>
  </tr>
  <tr>
    <td>ci</td>
    <td>Indica la implementación de componentes de integración continua al repositorio.</td>
    <td>ci: add static code analysis workflow.</td>
  </tr>
  <tr>
    <td>refactor</td>
    <td>Indica la modificación de la estructura de un componente de código sin modificar su comportamiento externo.</td>
    <td>refactor: extract verification logic into a new independent service.</td>
  </tr>
  <tr>
    <td>test</td>
    <td>Indica la implementación de algún tipo de prueba en código dentro del producto de software.</td>
    <td>test(sign-in): add password secure storage validation</td>
  </tr>
  <tr>
    <td>chore</td>
    <td>Indica la actualización de dependencias o tareas de mantenimiento del código.</td>
    <td>chore: update mongodb driver dependency.</td>
  </tr>
  <tr>
    <td>build</td>
    <td>Indica la modificación del sistema de compilación y ejecución del producto asociado</td>
    <td>build: update java version to 26.</td>
  </tr>
</table>

### 7.1.3. Source Code Style Guide & Conventions

### 7.1.4. Software Deployment Configuration

## 7.2. Solution Implementation

### 7.2.1. Sprint 1

En este sprint se planifica el primer incremento de Alivia, centrado en el control de luces, puertas y ventanas por voz, la consulta del estado de los dispositivos y la validación inicial de la propuesta de valor. Las siguientes secciones reúnen la planificación y las evidencias de desarrollo, pruebas, despliegue y colaboración del equipo.

### 7.2.1.1. Sprint 1 Planning

<table>
  <tbody>
    <tr>
      <th>Sprint #</th>
      <th>Sprint 1</th>
    </tr>
    <tr>
      <th colspan="2">Sprint Planning Background</th>
    </tr>
    <tr>
      <td>Date</td>
      <td>22 de octubre de 2026</td>
    </tr>
    <tr>
      <td>Time</td>
      <td>08:00 AM (GMT-5)</td>
    </tr>
    <tr>
      <td>Location</td>
      <td>Reunión virtual mediante Discord</td>
    </tr>
    <tr>
      <td>Prepared By</td>
      <td>Coronel Espinoza, Farid Sebastian</td>
    </tr>
    <tr>
      <td>Attendees (to planning meeting)</td>
      <td>Oscar Javier Armas Sánchez; Renato Guillermo Calvo Yalan; Farid Sebastian Coronel Espinoza; Matias Sebastian Diaz Quispe; Nicolas Emilio Walter Juarez Leon; Dayro Richard Rios Piñan.</td>
    </tr>
    <tr>
      <th colspan="2">Sprint Goal &amp; User Stories</th>
    </tr>
    <tr>
      <td>Sprint 1 Goal</td>
      <td>
        <p><strong>Nos enfocamos en ofrecer</strong> un primer incremento de Alivia que permita a las personas con discapacidad motora severa controlar las luces, puertas y ventanas mediante comandos de voz, facilite a sus cuidadores la consulta del estado de los dispositivos y permita a nuestro negocio validar la propuesta de valor que sustenta la comercialización de suscripciones y dispositivos.</p>
        <p><strong>Creemos que esto proporciona</strong> mayor autonomía a la persona con discapacidad, una menor carga de asistencia rutinaria y mayor visibilidad del entorno para el cuidador, y evidencia para que nuestro negocio ajuste su oferta y evalúe su aceptación comercial.</p>
        <p><strong>Esto se confirmará cuando</strong>, en las tareas evaluadas durante el sprint, las personas usuarias puedan realizarlas sin ayuda en al menos el <strong>70 % de las ocasiones</strong>, las intervenciones del cuidador disminuyan en un <strong>65 % respecto a la medición inicial</strong>, los cuidadores puedan consultar el estado actualizado de los dispositivos desde la aplicación web y el control local funcione en al menos el <strong>99 % de los escenarios probados sin Internet</strong>. Para el negocio, se evaluará la disposición de los participantes a contratar una suscripción y adquirir los dispositivos, registrando sus motivos de aceptación o rechazo para ajustar la oferta.</p>
      </td>
    </tr>
    <tr>
      <td>Sprint 1 Velocity</td>
      <td>-</td>
    </tr>
    <tr>
      <td>Sum of Story Points</td>
      <td>-</td>
    </tr>
  </tbody>
</table>

### Aspect Leaders and Collaborators

La siguiente matriz muestra la participación de cada integrante en los aspectos del proyecto. **L** identifica al responsable principal, **C** a quien colabora y **—** indica que no tiene una participación asignada en ese aspecto.

| **Team Member**                    | **GitHub Username** | IAM   | Company | Profiles | HCM   | Medical Assistance | Subscriptions | Support | Assets | Tracking | Communications | Analytics | Shared |
|------------------------------------|---------------------|-------|---------|----------|-------|--------------------|---------------|---------|--------|----------|----------------|-----------|--------|
| Armas Sánchez, Oscar Javier        | Racso24k            | C     | —       | —        | —     | C                  | —             | **L**   | —      | —        | C              | —         | **L**  |
| Calvo Yalan, Renato Guillermo      | RenatoCY            | —     | —       | —        | —     | C                  | —             | —       | **L**  | **L**    | —              | C         | C      |
| Coronel Espinoza, Farid Sebastian  | Far14z              | —     | C       | C        | **L** | —                  | **L**         | C       | C      | —        | —              | —         | —      |
| Diaz Quispe, Matías Sebastian      | equinox-1092        | C     | —       | —        | —     | C                  | —             | —       | —      | C        | **L**          | **L**     | C      |
| Juarez Leon, Nicolas Emilio Walter | JuarezLn10          | **L** | —       | C        | —     | **L**              | —             | —       | C      | C        | —              | —         | —      |
| Rios Piñan, Dayro Richard          | Addicted2you        | —     | **L**   | **L**    | C     | —                  | C             | —       | C      | C        | —              | —         | —      |

#### 7.2.1.3. Development Evidence for Sprint 1 Review

#### 7.2.1.4. Testing Suite Evidence for Sprint 1 Review

#### 7.2.1.5. Execution Evidence for Sprint 1 Review

#### 7.2.1.6. Services Documentation Evidence for Sprint 1 Review

#### 7.2.1.7. Software Deployment Evidence for Sprint 1 Review

#### 7.2.1.8. Team Collaboration Insights during Sprint 1

## 7.3. Validation Interviews

### 7.3.1. Diseño de entrevistas de validación

### 7.3.2. Registro de entrevistas de validación

**Segmento 1: Nombre del segmento 1**

<table>
    <tr>
        <th colspan="2" style="text-align:center;">Entrevista #1</th>
    </tr>
    <tr>
        <td><strong>Nombre</strong></td>
        <td>Nombre del entrevistado</td>
    </tr>
    <tr>
        <td><strong>Apellidos</strong></td>
        <td>Apellidos del entrevistado</td>
    </tr>
    <tr>
        <td><strong>Edad</strong></td>
        <td>XX años</td>
    </tr>
    <tr>
        <td><strong>Rol</strong></td>
        <td>Rol o puesto del entrevistado</td>
    </tr>
    <tr>
        <td><strong>Evidencia</strong></td>
        <td>
        <div align="center">
            <img 
                src="" 
                style="width:100%; max-width:720px; height:500px; object-fit:cover; object-position:center; display:block; margin:0 auto;"
                alt="">
        </div>
        </td>
    </tr>
    <tr>
        <td><strong>Link</strong></td>
        <td><a href="https://bit.ly/41kf54H">https://bit.ly/41kf54H</a></td>
    </tr>
    <tr>
        <td><strong>Timing donde inicia la entrevista</strong></td>
        <td>00:08 min</td>
    </tr>
    <tr>
        <td><strong>Duración de la entrevista</strong></td>
        <td>04:31 min</td>
    </tr>
    <tr>
        <td><strong>Resumen</strong></td>
        <td>
        Resumen de la entrevista
        </td>
    </tr>
</table>

**Segmento 2: Nombre del segmento 2**

### 7.3.3. Evaluación según heurísticas

## 7.4. Video About-the-Product

<div style="page-break-after: always;"></div>
