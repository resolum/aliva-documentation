# Capítulo 7: Product Implementation, Validation & Deployment

## 7.1. Software Configuration Management

### 7.1.1. Software Development Environment Configuration

Se describen las herramientas requeridas para el desarrollo del proyecto. Entre las herramientas, se separan por categorías relacionadas con diversas actividades como la gestión del proyecto, diseño del producto, desarrollo de software, testing de software y el despliegue de los productos de software.

<table style="max-width: 100%;">
  <tr>
    <th style="text-align:center;">Actividad</th>
    <th style="text-align:center;">Herramienta</th>
    <th style="text-align:center;">Propósito</th>
    <th style="text-align:center;">Referencia</th>
  </tr>
  <tr>
    <td rowspan="2">Project Management</td>
    <td>Atlassian Jira</td>
    <td>Gestión del progreso de actividades del equipo mediante asignaciones, Sprint backlogs basados en Kanban Boards y automatizaciones de estados de tareas</td>
    <td>https://www.atlassian.com/es/software/jira</td>
  </tr>
  <tr>
    <td>Notion</td>
    <td>Documentación interna de procesos y gestión de conocimiento compartido del equipo</td>
    <td>https://www.notion.com/es</td>
  </tr>
  <tr>
    <td rowspan="5">Product Design</td>
    <td>Structurizr</td>
    <td>Diseño de los diagramas de arquitectura de software y vistas arquitectónicas en base al enfoque de C4 Model</td>
    <td>https://playground.structurizr.com/</td>
  </tr>
  <tr>
    <td>PlantUML</td>
    <td>Diseño de la arquitectura de bajo nivel del software incluyendo diagramas de clase para la capa de dominio</td>
    <td>https://plantuml.com/</td>
  </tr>
  <tr>
    <td>Google Stitch</td>
    <td>Diseño de wireframes y mockups para las aplicaciones cliente: aplicaciones web y móvil de la solución</td>
    <td>https://stitch.google.com/</td>
  </tr>
  <tr>
    <td>Figma</td>
    <td>Refinamiento de mockups de las aplicaciones cliente y creación de prototipos para flujos de usuario</td>
    <td>https://figma.com/</td>
  </tr>
  <tr>
    <td>Wokwi</td>
    <td>Diseño del prototipo funcional y físico del dispositivo IoT integrando el hardware y software necesario</td>
    <td>https://wokwi.com/</td>
  </tr>
  <tr>
    <td rowspan="11">Software Development</td>
    <td>Git & GitHub</td>
    <td>Control de versiones de los productos de software y trazabilidad del desarrollo de software</td>
    <td>https://github.com/</td>
  </tr>
  <tr>
    <td>JetBrains WebStorm</td>
    <td>IDE para el desarrollo del sitio web estático y las aplicaciones web para administradores y usuarios</td>
    <td>https://www.jetbrains.com/es-es/webstorm/</td>
  </tr>
  <tr>
    <td>Node.js & Node Package Manager (NPM)</td>
    <td>Entorno de ejecución de sitio web estático y aplicaciones web. También provee de un gestor de dependencias para las mismas aplicaciones</td>
    <td>https://nodejs.org/es/download/current</td>
  </tr>
  <tr>
    <td>JetBrains IntelliJ IDEA</td>
    <td>IDE para el desarrollo de la aplicación backend (API REST)</td>
    <td>https://www.jetbrains.com/idea/</td>
  </tr>
  <tr>
    <td>Java</td>
    <td>Lenguaje de programación para el desarrollo del API</td>
    <td>https://www.java.com/es/download/manual.jsp</td>
  </tr>
  <tr>
    <td>Android Studio</td>
    <td>IDE para el desarrollo de la aplicación móvil para dispositivos Android</td>
    <td>https://developer.android.com/studio?hl=es-419</td>
  </tr>
  <tr>
    <td>JetBrains PyCharm</td>
    <td>IDE para el desarrollo de los servicios en el borde de la solución</td>
    <td>https://www.jetbrains.com/es-es/pycharm/</td>
  </tr>
  <tr>
    <td>Python</td>
    <td>Lenguaje de programación utilizado para el desarrollo de los servicios en el borde</td>
    <td>https://www.python.org/downloads/</td>
  </tr>
  <tr>
    <td>Arduino IDE</td>
    <td>IDE para el desarrollo de las aplicaciones embebidas en los dispositivos IoT</td>
    <td>https://www.arduino.cc/en/software</td>
  </tr>
  <tr>
    <td>MongoDB Compass</td>
    <td>Gestor de base de datos para gestionar la base de datos de telemetría</td>
    <td>https://www.mongodb.com/products/tools/compass</td>
  </tr>
  <tr>
    <td>pgAdmin4</td>
    <td>Herramienta gráfica para gestionar la base de datos operacional del sistema</td>
    <td>https://www.pgadmin.org/download/pgadmin-4-windows/</td>
  </tr>
  <tr>
    <td rowspan="3">Software Testing</td>
    <td>jUnit, Mockito</td>
    <td>Integración de pruebas de código (jUnit) y simulación de acceso a la persistencia (Mockito)</td>
    <td>https://junit.org/ / https://site.mockito.org/</td>
  </tr>
  <tr>
    <td>pytest</td>
    <td>Integración de pruebas de código para Python</td>
    <td>https://docs.pytest.org/</td>
  </tr>
  <tr>
    <td>Postman</td>
    <td>Herramienta para realizar tests de los endpoints REST del API y verificar su comportamiento ante varios escenarios</td>
    <td>https://www.postman.com/downloads/</td>
  </tr>
  <tr>
    <td rowspan="5">Software Deployment</td>
    <td>Cloudflare Pages</td>
    <td>Servicio en la nube para desplegar el sitio web estático y de las aplicaciones web (administrativa y de usuarios)</td>
    <td>https://www.cloudflare.com/es-es/developer-platform/products/pages/</td>
  </tr>
  <tr>
    <td>Oracle Cloud Infrastructure</td>
    <td>Servicio en la nube para desplegar el API y gestionar el balanceador de carga</td>
    <td>https://www.oracle.com/latam/cloud/</td>
  </tr>
  <tr>
    <td>Oracle Autonomous Database</td>
    <td>Servicio en la nube para desplegar la base de datos operacional en PostgreSQL</td>
    <td>https://www.oracle.com/latam/autonomous-database/</td>
  </tr>
  <tr>
    <td>MongoDB Atlas</td>
    <td>Servicio en la nube para el despliegue de la base de datos de telemetría en MongoDB</td>
    <td>https://www.mongodb.com/products/platform/atlas-database</td>
  </tr>
  <tr>
    <td>Firebase App Distribution</td>
    <td>Plataforma para gestionar los lanzamientos de las versiones de la aplicación para dispositivos Android</td>
    <td>https://firebase.google.com/docs/cli?hl=es-419#install_the_firebase_cli</td>
  </tr>
</table>

### 7.1.2. Source Code Management

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
