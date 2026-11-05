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

A continuación, se definen las convenciones de estilo de código que el equipo de desarrollo adoptará para el desarrollo de los productos de software del proyecto. El objetivo de esta guía es mantener la uniformidad del código desarrollado, que sea legible y se alinee con estándares y guías oficiales ofrecidas por las empresas encargadas del mantenimiento de los lenguajes de programación utilizados.

<table style="max-width: 100%;">
  <tr>
    <th style="text-align:center;">Lenguaje de programación</th>
    <th style="text-align:center;">Producto de software</th>
    <th style="text-align:center;">Referencia adoptada</th>
  </tr>
  <tr>
    <td>TypeScript</td>
    <td>Sitio web estático, Aplicación web - Usuarios y Administrativa</td>
    <td>Google TypeScript Style Guide - https://google.github.io/styleguide/tsguide.html</td>
  </tr>
  <tr>
    <td>Astro.js</td>
    <td>Sitio web estático</td>
    <td>Astro Project Structure - https://docs.astro.build/en/basics/project-structure/</td>
  </tr>
  <tr>
    <td>HTML & CSS</td>
    <td>Aplicación web - Usuarios y Administrativa</td>
    <td>Google HTML/CSS Style Guide - https://google.github.io/styleguide/htmlcssguide.html</td>
  </tr>
  <tr>
    <td>React.js</td>
    <td>Aplicación web - Usuarios</td>
    <td>Rules of React - https://react.dev/reference/rules</td>
  </tr>
  <tr>
    <td>Angular.js</td>
    <td>Aplicación web - Administrativa</td>
    <td>Angular Coding Style Guide - https://v19.angular.dev/style-guide</td>
  </tr>
  <tr>
    <td>Kotlin</td>
    <td>Aplicación móvil Android</td>
    <td>Kotlin Coding Conventions - https://kotlinlang.org/docs/coding-conventions.html</td>
  </tr>
  <tr>
    <td>Jetpack Compose</td>
    <td>Aplicación móvil Android</td>
    <td>Guía oficial de Android Developers sobre Jetpack Compose - https://developer.android.com/develop/ui/compose</td>
  </tr>
  <tr>
    <td>Swift</td>
    <td>Aplicación móvil iOS</td>
    <td>Swift API Guidelines - https://swift.org/documentation/api-design-guidelines/</td>
  </tr>
  <tr>
    <td>Swift</td>
    <td>Aplicación móvil iOS</td>
    <td>Google Swift Style Guide - https://google.github.io/swift/</td>
  </tr>
  <tr>
    <td>Java</td>
    <td>Servicios web (API)</td>
    <td>Google Java Style Guide - https://google.github.io/styleguide/javaguide.html</td>
  </tr>
  <tr>
    <td>Spring Boot</td>
    <td>Servicios web (API)</td>
    <td>Documentación oficial de Spring Boot - https://docs.spring.io/spring-boot/index.html</td>
  </tr>
  <tr>
    <td>Python</td>
    <td>Servicios en el borde</td>
    <td>PEP8: Pÿthon Coding Style Guide - https://peps.python.org/pep-0008/</td>
  </tr>
  <tr>
    <td>Python</td>
    <td>Servicios en el borde</td>
    <td>PEP 257: Docstring Conventions - https://peps.python.org/pep-0257/</td>
  </tr>
  <tr>
    <td>Flask</td>
    <td>Servicios en el borde</td>
    <td>Documentación oficial de Flask - https://flask.palletsprojects.com/</td>
  </tr>
  <tr>
    <td>C++</td>
    <td>Aplicaciones embebidas</td>
    <td>Google C++ Style Guide - https://google.github.io/styleguide/cppguide.html</td>
  </tr>
  <tr>
    <td>C++</td>
    <td>Aplicaciones embebidas</td>
    <td>Documentación de CMake - https://cmake.org/cmake/help/latest/</td>
  </tr>
</table>

#### Sitio web estático — Astro + TypeScript

**Referencias adoptadas:**

- [Astro Project Structure](https://docs.astro.build/en/basics/project-structure/).
- [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html).
- [Google HTML/CSS Style Guide](https://google.github.io/styleguide/htmlcssguide.html).

**Convenciones generales**

- Extensiones principales: `.astro`, `.ts`, `.js`, `.html`, `.css` y `.md`/`.mdx`, según el tipo de contenido.
- Indentación de 2 espacios para TypeScript, HTML, CSS y archivos Astro.
- Organizar el proyecto en `src/components/`, `src/layouts/`, `src/pages/`, `src/styles/` y `src/scripts/`, cuando corresponda.
- Utilizar `src/pages/` para definir las rutas del sitio mediante archivos y directorios.
- Utilizar componentes Astro para encapsular estructuras de interfaz reutilizables.
- Reservar los layouts para estructuras compartidas entre páginas, como encabezados, pies de página y plantillas.
- Utilizar TypeScript para la lógica, los datos estructurados y las interfaces de configuración.
- Mantener separados el contenido, la presentación y la lógica de interacción.
- Priorizar el renderizado estático de Astro y añadir JavaScript del lado del cliente únicamente cuando sea necesario.
- Utilizar etiquetas HTML semánticas, atributos accesibles y selectores CSS descriptivos.
- Evitar estilos en línea y duplicación de reglas CSS cuando se puedan reutilizar clases o estilos compartidos.

**Convenciones de nomenclatura**

| Elemento | Convención | Ejemplo |
|---|---|---|
| Componentes Astro | PascalCase | `ProductCard.astro` |
| Layouts | PascalCase | `MainLayout.astro` |
| Páginas y rutas | kebab-case | `product-details.astro` |
| Archivos TypeScript | kebab-case | `product-service.ts` |
| Interfaces y tipos | PascalCase | `Product`, `ProductResponse` |
| Variables | camelCase | `productList` |
| Funciones | camelCase | `getProductDetails()` |
| Constantes globales | UPPER_SNAKE_CASE | `MAX_ITEMS_PER_PAGE` |
| Clases CSS | kebab-case | `.product-card` |
| Variables CSS | kebab-case con prefijo `--` | `--primary-color` |
| Propiedades de componentes | camelCase | `productName` |
| Directorios de features | kebab-case | `product-catalog/` |

**Estructura de referencia**

```text
alivia-landing-page/
├── public/
│   ├── device/
│   ├── hero/
│   ├── favicon.ico
│   └── favicon.svg
├── src/
│   ├── assets/
│   ├── components/
│   │   ├── ui/
│   │   ├── legal/
│   │   ├── devices/
│   │   ├── plans/
│   │   └── sections/
│   ├── data/
│   │   ├── legal/
│   │   ├── plans.ts
│   │   ├── team.ts
│   │   ├── testimonials.ts
│   │   └── faq.ts
│   ├── i18n/
│   │   ├── locales/
│   │   │   ├── en/
│   │   │   └── es/
│   │   ├── ui.ts
│   │   └── utils.ts
│   ├── layouts/
│   │   └── Layout.astro
│   ├── pages/
│   │   ├── en/
│   │   ├── es/
│   │   ├── index.astro
│   │   ├── privacy-policy.astro
│   │   └── terms-and-conditions.astro
│   ├── scripts/
│   └── styles/
│       └── global.css
├── .github/workflows/
├── astro.config.mjs
├── package.json
├── pnpm-lock.yaml
└── README.md
```

#### Aplicación web — Usuarios (React + TypeScript)

**Referencias adoptadas:**

- [Rules of React](https://react.dev/reference/rules).
- [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html).
- [Google HTML/CSS Style Guide](https://google.github.io/styleguide/htmlcssguide.html).

**Convenciones generales**

- Extensiones principales: `.tsx` para componentes React con JSX, `.ts` para lógica y tipos, y `.css` para estilos.
- Indentación de 2 espacios.
- Los componentes funcionales deben encargarse de la representación de la interfaz y de la lógica propia de presentación.
- Extraer a hooks personalizados la lógica reutilizable relacionada con el estado y el ciclo de vida de la interfaz.
- Centralizar la comunicación con APIs en módulos de servicios o clientes HTTP, evitando llamadas duplicadas en los componentes.
- Definir interfaces o tipos para las propiedades de componentes, las respuestas de API y los datos del dominio.
- Respetar las reglas de los Hooks: invocarlos únicamente en componentes funcionales o hooks personalizados y en el nivel superior de su ejecución.
- Mantener puros los componentes y hooks durante el renderizado; realizar los efectos secundarios en los mecanismos apropiados.
- Tratar las propiedades y el estado como datos inmutables.
- Preferir componentes pequeños, reutilizables y con responsabilidades claras.
- Utilizar `key` estables en listas y evitar índices como claves cuando los elementos puedan cambiar de orden.
- Evitar el uso indiscriminado de `any`; preferir tipos explícitos, uniones y `unknown` cuando corresponda.

**Convenciones de nomenclatura**

| Elemento | Convención | Ejemplo |
|---|---|---|
| Componentes React | PascalCase | `InventoryDashboard` |
| Archivos de componentes | PascalCase | `InventoryDashboard.tsx` |
| Hooks personalizados | camelCase con prefijo `use` | `useInventory.ts` |
| Funciones de componentes | PascalCase para componentes | `InventoryDashboard` |
| Funciones auxiliares | camelCase | `formatStockQuantity()` |
| Servicios | camelCase | `inventoryService.ts` |
| Interfaces y tipos | PascalCase | `InventoryItem`, `InventoryResponse` |
| Props de componentes | PascalCase para el tipo; camelCase para sus propiedades | `InventoryCardProps`, `productName` |
| Variables y estados | camelCase | `selectedProduct` |
| Constantes globales | UPPER_SNAKE_CASE | `DEFAULT_PAGE_SIZE` |
| Contextos | PascalCase con sufijo `Context` | `AuthContext` |
| Proveedores de contexto | PascalCase con sufijo `Provider` | `AuthProvider` |
| Funciones de actualización de estado | Prefijo `set` | `setSelectedProduct` |
| Clases CSS | kebab-case | `.inventory-card` |
| Rutas | kebab-case | `/inventory-history` |
| Pruebas | Nombre del elemento + `.test` o `.spec` | `InventoryDashboard.test.tsx` |

**Estructura de referencia**

```text
alivia-users-web-application/
├── public/
├── src/
│   ├── app/
│   │   ├── router.tsx
│   │   ├── providers.tsx
│   │   └── RequireAccess.tsx
│   ├── shared/
│   │   ├── domain/
│   │   │   └── model/
│   │   ├── infrastructure/
│   │   │   ├── base-api.ts
│   │   │   ├── base-api-endpoint.ts
│   │   │   ├── base-assembler.ts
│   │   │   └── base-response.ts
│   │   └── presentation/
│   │       ├── components/
│   │       ├── hooks/
│   │       ├── session/
│   │       └── i18n/
│   ├── iam/
│   │   ├── domain/
│   │   │   └── model/
│   │   ├── application/
│   │   │   ├── commands/
│   │   │   ├── queries/
│   │   │   └── services/
│   │   ├── infrastructure/
│   │   │   ├── endpoints/
│   │   │   └── assemblers/
│   │   └── presentation/
│   │       ├── components/
│   │       ├── hooks/
│   │       └── views/
│   ├── profiles/
│   │   ├── domain/
│   │   ├── application/
│   │   ├── infrastructure/
│   │   └── presentation/
│   ├── care/
│   │   ├── domain/
│   │   ├── application/
│   │   ├── infrastructure/
│   │   └── presentation/
│   ├── subscriptions/
│   ├── support/
│   ├── communications/
│   ├── telemetry/
│   ├── analytics/
│   ├── App.tsx
│   ├── main.tsx
│   └── index.css
├── tests/
├── package.json
├── pnpm-lock.yaml
├── vite.config.ts
└── README.md
```
#### Aplicación web — Administrativa (Angular + TypeScript)

**Referencias adoptadas:**

- [Angular Coding Style Guide](https://v19.angular.dev/style-guide).
- [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html).
- [Google HTML/CSS Style Guide](https://google.github.io/styleguide/htmlcssguide.html).

**Convenciones generales**

- Extensiones principales: `.ts`, `.html` y `.css`; se permite `.scss` si se adopta como estándar del proyecto.
- Indentación de 2 espacios.
- Utilizar componentes para gestionar la presentación y la interacción de la interfaz.
- Centralizar las llamadas HTTP y la lógica de acceso a datos en servicios inyectables.
- Aplicar inyección de dependencias mediante los mecanismos de Angular.
- Utilizar interfaces y tipos para representar las estructuras de datos intercambiadas con la API.
- Preferir formularios reactivos cuando se requiera validación estructurada y control explícito del estado.
- Declarar rutas de manera centralizada o por funcionalidad, según la arquitectura adoptada.
- Utilizar `Observable` y los mecanismos de RxJS cuando corresponda al flujo asíncrono.
- Limitar las suscripciones manuales y gestionar correctamente su ciclo de vida.
- Evitar componentes excesivamente grandes; extraer responsabilidades reutilizables a servicios, pipes, directivas o componentes específicos.
- Mantener consistencia con la estructura de nombres recomendada por Angular: `feature.type.ts`.

**Convenciones de nomenclatura**

| Elemento | Convención | Ejemplo |
|---|---|---|
| Componentes | PascalCase con sufijo `Component` | `InventoryDashboardComponent` |
| Archivos de componentes | kebab-case + `.component` | `inventory-dashboard.component.ts` |
| Servicios | PascalCase con sufijo `Service` | `InventoryService` |
| Archivos de servicios | kebab-case + `.service` | `inventory.service.ts` |
| Interfaces | PascalCase | `InventoryItem` |
| Clases | PascalCase | `StockRecord` |
| Directivas | PascalCase con sufijo `Directive` | `HighlightDirective` |
| Pipes | PascalCase con sufijo `Pipe` | `CurrencyFormatPipe` |
| Guards | PascalCase con sufijo `Guard` | `AuthGuard` |
| Modelos y tipos | PascalCase | `InventoryResponse` |
| Variables y propiedades | camelCase | `currentStock` |
| Métodos | camelCase | `loadInventory()` |
| Constantes globales | UPPER_SNAKE_CASE | `DEFAULT_PAGE_SIZE` |
| Archivos de rutas | kebab-case + `.routes` | `inventory.routes.ts` |
| Selectores de componentes | kebab-case con prefijo del proyecto | `app-inventory-dashboard` |
| Clases CSS | kebab-case | `.inventory-summary` |
| Pruebas | Nombre del elemento + `.spec.ts` | `inventory.service.spec.ts` |

**Estructura de referencia**

```text
alivia-admin-web-application/
├── public/
├── src/
│   ├── app/
│   │   ├── shared/
│   │   │   ├── domain/
│   │   │   ├── infrastructure/
│   │   │   └── presentation/
│   │   ├── domains/
│   │   │   ├── iam/
│   │   │   │   ├── domain/
│   │   │   │   ├── application/
│   │   │   │   ├── infrastructure/
│   │   │   │   └── presentation/
│   │   │   ├── care-management/
│   │   │   │   ├── domain/
│   │   │   │   ├── application/
│   │   │   │   ├── infrastructure/
│   │   │   │   └── presentation/
│   │   │   ├── technical-work/
│   │   │   │   ├── domain/
│   │   │   │   ├── application/
│   │   │   │   ├── infrastructure/
│   │   │   │   └── presentation/
│   │   │   └── support/
│   │   │       ├── domain/
│   │   │       ├── application/
│   │   │       ├── infrastructure/
│   │   │       └── presentation/
│   │   ├── app.config.ts
│   │   └── app.routes.ts
│   ├── styles.css
│   └── main.ts
├── public/
├── angular.json
├── package.json
├── tsconfig.json
└── README.md
```

**Nota:** el sufijo `Component` en el nombre de la clase es una convención explícita del proyecto. Angular utiliza el sufijo `.component.ts` para los archivos, pero no exige universalmente que el nombre de cada clase termine en `Component`.

#### API REST — Spring Boot + Java

**Referencias adoptadas:**

- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html).
- [Documentación oficial de Spring Boot](https://docs.spring.io/spring-boot/index.html)

**Convenciones generales**

- Extensión principal: `.java`.
- Indentación de 2 espacios, conforme a Google Java Style Guide.
- Organizar los paquetes por funcionalidad o contexto de dominio, manteniendo separadas las responsabilidades de presentación, aplicación, dominio e infraestructura cuando se adopte una arquitectura por capas.
- Los controladores REST deben gestionar las solicitudes HTTP y delegar la lógica de aplicación.
- Los servicios de aplicación deben coordinar los casos de uso y las operaciones del dominio.
- Los repositorios deben encapsular el acceso a datos y evitar que los controladores dependan directamente de la persistencia.
- Utilizar DTO (*Data Transfer Objects*) para definir las estructuras de entrada y salida de la API cuando corresponda.
- Validar los datos recibidos mediante mecanismos como Jakarta Bean Validation.
- Mantener una gestión centralizada y consistente de errores HTTP.
- Utilizar inyección de dependencias de Spring, preferentemente mediante constructores.
- Evitar imports comodín; importar explícitamente las clases utilizadas.
- Documentar las clases y métodos públicos cuando la intención o el contrato no sean evidentes, mediante Javadoc cuando corresponda.
- Evitar la exposición directa de entidades de persistencia como contratos públicos de la API.
- Escribir pruebas unitarias para la lógica aislada y pruebas de integración para los límites entre componentes, la API y la persistencia.

**Convenciones de nomenclatura**

| Elemento | Convención | Ejemplo |
|---|---|---|
| Paquetes | minúsculas, sin guiones ni guiones bajos | `com.example.inventory.service` |
| Clases | PascalCase | `InventoryService` |
| Interfaces | PascalCase, sin prefijo `I` | `InventoryRepository` |
| Implementaciones | PascalCase con sufijo descriptivo | `InventoryRepositoryImpl` |
| Controladores | PascalCase + `Controller` | `InventoryController` |
| Servicios | PascalCase + `Service` | `InventoryService` |
| Repositorios | PascalCase + `Repository` | `InventoryRepository` |
| DTO de entrada | PascalCase + `Request` | `CreateProductRequest` |
| DTO de salida | PascalCase + `Response` | `ProductResponse` |
| Entidades | PascalCase | `InventoryItem` |
| Enumeraciones | PascalCase | `InventoryStatus` |
| Excepciones | PascalCase + `Exception` | `ProductNotFoundException` |
| Métodos | camelCase | `findProductById()` |
| Variables y atributos | camelCase | `currentStock` |
| Constantes `static final` | UPPER_SNAKE_CASE | `MAX_PAGE_SIZE` |
| Archivos Java | Nombre de la clase pública | `InventoryController.java` |
| Métodos de prueba | camelCase descriptivo | `shouldReturnProductWhenIdExists()` |

**Organización recomendada por capas**

```text
alivia-web-services/
├── src/
│   ├── main/
│   │   ├── java/<paquete-base>/
│   │   │   ├── iam/
│   │   │   │   ├── domain/
│   │   │   │   │   ├── model/
│   │   │   │   │   ├── services/
│   │   │   │   │   └── repositories/
│   │   │   │   ├── application/
│   │   │   │   │   ├── internal/
│   │   │   │   │   └── acl/
│   │   │   │   ├── infrastructure/
│   │   │   │   │   ├── persistence/
│   │   │   │   │   │   ├── jpa/
│   │   │   │   │   │   └── springdata/
│   │   │   │   │   └── adapters/
│   │   │   │   └── interfaces/
│   │   │   │       └── rest/
│   │   │   │           ├── controllers/
│   │   │   │           ├── resources/
│   │   │   │           └── assemblers/
│   │   │   ├── profiles/
│   │   │   ├── care/
│   │   │   ├── subscriptions/
│   │   │   ├── support/
│   │   │   ├── communications/
│   │   │   ├── telemetry/
│   │   │   ├── analytics/
│   │   │   └── configuration/
│   │   └── resources/
│   │       ├── application.yml
│   │       └── db/
│   └── test/
│       └── java/<paquete-base>/
│           ├── iam/
│           │   ├── domain/
│           │   ├── application/
│           │   ├── infrastructure/
│           │   └── interfaces/
│           └── ...
├── docs/
├── compose.yaml
├── pom.xml
├── mvnw
└── README.md
```

#### Aplicación móvil — Android (Jetpack Compose + Kotlin)

**Referencias adoptadas:**

- [Kotlin Coding Conventions](https://kotlinlang.org/docs/coding-conventions.html).
- [Guía oficial de Android Developers sobre Jetpack Compose](https://developer.android.com/develop/ui/compose).

**Convenciones generales**

- Extensión principal: `.kt`.
- Indentación de 4 espacios.
- Organizar el código por funcionalidades, separando interfaz, estado, lógica de aplicación y acceso a datos.
- Utilizar funciones `@Composable` para construir componentes de interfaz.
- Nombrar las funciones `@Composable` que devuelven `Unit` mediante PascalCase, siguiendo la convención especial de Kotlin.
- Mantener los composables enfocados en la representación visual y evitar efectos secundarios durante la composición.
- Gestionar el estado de la interfaz de forma explícita y favorecer el flujo unidireccional de datos.
- Elevar el estado (*state hoisting*) cuando deba compartirse entre componentes o gestionarse desde una capa superior.
- Utilizar `ViewModel` para gestionar el estado de pantalla y coordinar la lógica de presentación cuando corresponda.
- Centralizar las operaciones de acceso a APIs y persistencia en repositorios.
- Preferir `val` sobre `var` cuando no se necesite mutabilidad.
- Utilizar clases `data class` para representar datos y `sealed class` o `sealed interface` para modelar estados o resultados finitos cuando resulte apropiado.
- Evitar operaciones bloqueantes en el hilo principal; utilizar corrutinas y mecanismos asíncronos adecuados.
- Separar los recursos de interfaz, como cadenas, colores e iconos, del código de los composables.
- Mantener los paquetes alineados con la organización de los módulos y funcionalidades.

**Convenciones de nomenclatura**

| Elemento | Convención | Ejemplo |
|---|---|---|
| Paquetes | minúsculas, sin guiones bajos | `com.example.inventory` |
| Composables | PascalCase | `InventoryScreen` |
| ViewModels | PascalCase + `ViewModel` | `InventoryViewModel` |
| Repositorios | PascalCase + `Repository` | `InventoryRepository` |
| Clases de datos | PascalCase | `InventoryItem` |
| Estados de UI | PascalCase descriptivo | `InventoryUiState` |
| Eventos de UI | PascalCase descriptivo | `InventoryUiEvent` |
| Interfaces | PascalCase | `InventoryDataSource` |
| Funciones | camelCase | `loadInventory()` |
| Propiedades y variables | camelCase | `selectedProduct` |
| Constantes inmutables de compilación | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Objetos singleton | PascalCase | `InventoryDefaults` |
| Enumeraciones | PascalCase; valores según el estándar del proyecto | `InventoryStatus.AVAILABLE` |
| Archivos con una clase principal | Nombre de la clase | `InventoryViewModel.kt` |
| Archivos de funciones relacionadas | PascalCase descriptivo | `InventoryFormatters.kt` |
| Pruebas | Nombre de la clase o componente + `Test` | `InventoryViewModelTest.kt` |

**Convenciones específicas para Jetpack Compose**

| Elemento | Convención | Ejemplo |
|---|---|---|
| Pantallas | `*Screen` | `InventoryScreen` |
| Componentes visuales | Nombre del elemento visual | `ProductCard` |
| Funciones de vista previa | `Preview` + nombre del componente | `PreviewInventoryScreen` |
| Estado de pantalla | `*UiState` | `InventoryUiState` |
| Eventos de pantalla | `*UiEvent` | `InventoryUiEvent` |
| Funciones de callbacks | Verbos o acciones en camelCase | `onProductSelected` |
| Parámetros de modificador | `modifier` | `modifier: Modifier = Modifier` |

**Estructura de referencia**

```text
alivia-android-application/
├── app/
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/<paquete-base>/
│   │   │   │   ├── core/
│   │   │   │   │   ├── network/
│   │   │   │   │   ├── database/
│   │   │   │   │   ├── notifications/
│   │   │   │   │   └── di/
│   │   │   │   ├── shared/
│   │   │   │   │   └── presentation/
│   │   │   │   ├── features/
│   │   │   │   │   ├── iam/
│   │   │   │   │   │   ├── domain/
│   │   │   │   │   │   ├── data/
│   │   │   │   │   │   └── presentation/
│   │   │   │   │   ├── care/
│   │   │   │   │   ├── telemetry/
│   │   │   │   │   ├── communications/
│   │   │   │   │   ├── subscriptions/
│   │   │   │   │   └── profiles/
│   │   │   │   ├── navigation/
│   │   │   │   └── MainActivity.kt
│   │   │   └── res/
│   │   ├── test/
│   │   └── androidTest/
│   └── build.gradle.kts
├── gradle/
├── build.gradle.kts
├── settings.gradle.kts
└── README.md
```

```text
care/
├── domain/
│   ├── model/
│   ├── repository/
│   └── usecase/
├── data/
│   ├── remote/
│   ├── local/
│   ├── mapper/
│   └── repository/
└── presentation/
    ├── screens/
    ├── components/
    ├── viewmodel/
    └── state/
```

#### Aplicación móvil — iOS (Swift)

**Referencias adoptadas:**

- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).
- [Google Swift Style Guide](https://google.github.io/swift/).

**Convenciones generales**

- Extensión principal: `.swift`.
- Indentación de 4 espacios como estándar adoptado por el proyecto; mantener la configuración de formato consistente en Xcode y las herramientas elegidas.
- Organizar el código por funcionalidades, separando vistas, modelos, servicios y lógica de presentación.
- Utilizar `struct` para modelos de datos y vistas de SwiftUI cuando corresponda, y `class` cuando se requiera identidad de referencia o semántica de referencia.
- Mantener las vistas enfocadas en la presentación; trasladar las operaciones de negocio y acceso a datos a componentes apropiados.
- Utilizar `Observable` o `ObservableObject`, según las tecnologías y versiones adoptadas, para gestionar el estado observable.
- Preferir `let` sobre `var` cuando el valor no deba cambiar.
- Definir protocolos para abstraer dependencias y facilitar las pruebas.
- Utilizar `async`/`await` para operaciones asíncronas cuando corresponda.
- Nombrar los métodos de manera que su uso resulte claro y natural.
- Evitar abreviaturas innecesarias y nombres que repitan información ya evidente en el contexto.
- Documentar las declaraciones públicas relevantes mediante comentarios de documentación con `///`.
- Gestionar errores explícitamente y evitar el uso indiscriminado de valores opcionales forzados (`!`).
- Mantener separadas las responsabilidades de las vistas, los modelos de presentación y los servicios.

**Convenciones de nomenclatura**

| Elemento | Convención | Ejemplo |
|---|---|---|
| Tipos y clases | UpperCamelCase | `InventoryItem` |
| Estructuras | UpperCamelCase | `InventoryViewState` |
| Protocolos | UpperCamelCase | `InventoryRepository` |
| Enumeraciones | UpperCamelCase | `InventoryStatus` |
| Casos de enumeración | lowerCamelCase | `.available` |
| Vistas SwiftUI | PascalCase + `View` | `InventoryView` |
| ViewModels | PascalCase + `ViewModel` | `InventoryViewModel` |
| Servicios | PascalCase + `Service` | `InventoryService` |
| Métodos | lowerCamelCase | `loadInventory()` |
| Variables y propiedades | lowerCamelCase | `currentStock` |
| Constantes | lowerCamelCase | `maximumRetryCount` |
| Funciones de creación | Prefijo `make` | `makeInventoryView()` |
| Tipos de error | PascalCase + `Error` | `InventoryError` |
| Archivos Swift | PascalCase descriptivo | `InventoryView.swift` |
| Pruebas | Nombre del tipo + `Tests` | `InventoryViewModelTests.swift` |

**Estructura de referencia**

```text
alivia-ios-application/
├── Alivia.xcodeproj/
├── Alivia/
│   ├── App/
│   │   ├── AliviaApp.swift
│   │   ├── AppConfiguration.swift
│   │   └── DependencyContainer.swift
│   ├── Core/
│   │   ├── Networking/
│   │   ├── Persistence/
│   │   ├── Notifications/
│   │   └── Utilities/
│   ├── Shared/
│   │   └── Presentation/
│   ├── Features/
│   │   ├── IAM/
│   │   │   ├── Domain/
│   │   │   ├── Data/
│   │   │   └── Presentation/
│   │   ├── Care/
│   │   │   ├── Domain/
│   │   │   ├── Data/
│   │   │   └── Presentation/
│   │   ├── Telemetry/
│   │   ├── Communications/
│   │   ├── Profiles/
│   │   └── Subscriptions/
│   ├── Resources/
│   └── Info.plist
└── AliviaTests/
    ├── Domain/
    ├── Application/
    └── Data/
```

```
Care/
├── Domain/
│   ├── Models/
│   ├── ValueObjects/
│   ├── Repositories/
│   └── UseCases/
├── Data/
│   ├── Remote/
│   ├── Local/
│   ├── DTOs/
│   └── Repositories/
└── Presentation/
    ├── Views/
    ├── ViewModels/
    └── Components/
```

#### Servicios en el borde — Flask + Python

**Referencias adoptadas:**

- [PEP 8 — Style Guide for Python Code](https://peps.python.org/pep-0008/).
- [PEP 257 — Docstring Conventions](https://peps.python.org/pep-0257/).
- [Documentación oficial de Flask](https://flask.palletsprojects.com/).

**Convenciones generales**

- Extensión principal: `.py`.
- Indentación de 4 espacios, sin tabulaciones para la indentación.
- Organizar el proyecto por módulos y paquetes, separando rutas HTTP, lógica de procesamiento, acceso a datos y configuración.
- Utilizar Blueprints de Flask para agrupar rutas relacionadas cuando la aplicación tenga varios módulos funcionales.
- Mantener las funciones de los endpoints enfocadas en recibir solicitudes, validar entradas y devolver respuestas.
- Separar la lógica de procesamiento de telemetría de los controladores HTTP.
- Centralizar las operaciones de acceso a servicios externos, brokers MQTT y almacenamiento en módulos específicos.
- Utilizar type hints en parámetros, retornos y estructuras de datos relevantes.
- Definir clases o estructuras de datos explícitas para representar mensajes de telemetría y resultados de procesamiento.
- Utilizar docstrings para documentar módulos, clases y funciones públicas.
- Gestionar las excepciones y los errores de comunicación de forma explícita, evitando capturar excepciones genéricas sin tratamiento adecuado.
- Mantener las credenciales y la configuración sensible fuera del código fuente.
- Evitar variables globales mutables para almacenar el estado de ejecución.
- Escribir pruebas unitarias para los algoritmos de procesamiento y pruebas de integración para endpoints, MQTT y dependencias externas.
- Utilizar un entorno virtual y un archivo de dependencias versionado.

**Convenciones de nomenclatura**

| Elemento | Convención | Ejemplo |
|---|---|---|
| Paquetes | Minúsculas | `telemetry` |
| Módulos y archivos | `snake_case` | `telemetry_processor.py` |
| Clases | PascalCase | `TelemetryProcessor` |
| Blueprints | `snake_case` | `telemetry_bp` |
| Funciones | `snake_case` | `process_telemetry()` |
| Métodos | `snake_case` | `validate_reading()` |
| Variables | `snake_case` | `current_temperature` |
| Constantes | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Excepciones propias | PascalCase + `Error` | `TelemetryValidationError` |
| Modelos de datos | PascalCase | `TelemetryReading` |
| Esquemas de validación | PascalCase + `Schema` | `TelemetryReadingSchema` |
| Funciones de rutas | `snake_case` descriptivo | `get_telemetry_history()` |
| Pruebas | Prefijo `test_` | `test_process_telemetry.py` |
| Funciones de prueba | Prefijo `test_` | `test_invalid_reading_is_rejected()` |

**Organización recomendada**

```text
alivia-actuators-edge-service/
├── app/
│   ├── __init__.py
│   ├── domain/
│   │   ├── actuators/
│   │   │   ├── entities.py
│   │   │   ├── value_objects.py
│   │   │   ├── policies.py
│   │   │   └── events.py
│   │   ├── commands/
│   │   └── exceptions.py
│   ├── application/
│   │   ├── commands/
│   │   │   └── execute_actuator_command.py
│   │   ├── queries/
│   │   ├── ports/
│   │   │   ├── actuator_controller.py
│   │   │   └── actuator_repository.py
│   │   └── dto/
│   ├── infrastructure/
│   │   ├── persistence/
│   │   │   ├── models.py
│   │   │   └── repositories.py
│   │   ├── mqtt/
│   │   ├── hardware/
│   │   └── configuration/
│   └── interfaces/
│       ├── http/
│       │   ├── routes.py
│       │   └── schemas.py
│       └── messaging/
│           └── mqtt_handlers.py
├── tests/
│   ├── unit/
│   │   ├── domain/
│   │   └── application/
│   └── integration/
│       ├── http/
│       ├── mqtt/
│       └── persistence/
├── app.py
├── requirements.txt
└── README.md
```

#### Aplicaciones embebidas — C++

**Referencias adoptadas:**

- [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html).
- [Documentación de CMake](https://cmake.org/cmake/help/latest/).

**Convenciones generales**

- Extensiones principales: `.h` para cabeceras y `.cc` para archivos de implementación, siguiendo Google C++ Style Guide.
- Indentación de 2 espacios.
- Organizar el código en módulos, con separación entre controladores de hardware, lógica de negocio, comunicaciones y configuración.
- Mantener las cabeceras autocontenidas e incluir únicamente las dependencias necesarias.
- Ordenar los `#include` según la guía adoptada: cabecera asociada, cabeceras del sistema C, biblioteca estándar de C++, bibliotecas externas y cabeceras propias.
- Utilizar clases y estructuras para encapsular el estado y el comportamiento de los componentes.
- Preferir la gestión segura de recursos mediante RAII y tipos de la biblioteca estándar cuando sean compatibles con las restricciones del dispositivo.
- Evitar asignaciones dinámicas innecesarias en rutas críticas o sistemas con memoria limitada.
- Utilizar tipos de tamaño explícito, como `std::uint32_t`, cuando el ancho del dato sea relevante para el hardware o el protocolo.
- Aplicar `const` siempre que ayude a expresar que un dato o parámetro no debe modificarse.
- Evitar macros cuando puedan sustituirse por constantes, funciones o mecanismos de C++ más seguros.
- Documentar las interfaces de hardware y los supuestos relacionados con interrupciones, concurrencia, temporización y recursos.
- Mantener separada la lógica de control de hardware de la lógica que pueda probarse mediante pruebas unitarias.
- Utilizar pruebas unitarias para la lógica aislada y pruebas en hardware o simuladores para validar el comportamiento físico.
- Definir reglas explícitas para el manejo de errores, límites de memoria y tiempos de ejecución.
- No adoptar mecanismos de C++ que no sean compatibles con la versión del estándar o el compilador del dispositivo.

**Convenciones de nomenclatura**

| Elemento | Convención | Ejemplo |
|---|---|---|
| Clases | PascalCase | `TemperatureSensor` |
| Estructuras (`struct`) | PascalCase | `TelemetryReading` |
| Enumeraciones | PascalCase | `SensorStatus` |
| Valores de enumeraciones | PascalCase | `SensorStatus::ReadFailed` |
| Funciones | PascalCase | `ReadTemperature()` |
| Variables locales | `snake_case` | `current_temperature` |
| Parámetros | `snake_case` | `sensor_address` |
| Atributos de clases | `snake_case` con guion bajo final | `temperature_` |
| Miembros de `struct` | `snake_case` sin guion bajo final | `temperature` |
| Constantes de ámbito de clase o espacio de nombres | `k` + PascalCase | `kMaxRetryCount` |
| Macros | UPPER_SNAKE_CASE con prefijo del proyecto | `ALIVIA_MAX_RETRIES` |
| Espacios de nombres | `snake_case` | `alivia::sensors` |
| Alias de tipos | PascalCase | `SensorReading` |
| Archivos de cabecera | Minúsculas con guiones bajos | `temperature_sensor.h` |
| Archivos de implementación | Mismo nombre que la cabecera | `temperature_sensor.cc` |
| Archivos de prueba | Nombre del módulo + `_test.cc` | `temperature_sensor_test.cc` |

**Organización recomendada**

```text
alivia-embedded-controller/
├── include/
├── src/
├── tests/
│   ├── unit/
│   └── integration/
├── CMakeLists.txt
└── README.md
```

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

### 6.2.1.3. Sprint Backlog 1

Como se mencionó previamente en el planeamiento del Sprint 1, el objetivo es desarrollar un primer incremento funcional de Alivia que contribuya a la autonomía de las personas con discapacidad motora severa mediante el control de luces, puertas y ventanas por comandos de voz, complementado con capacidades de supervisión y gestión del servicio. Para ello, el sprint reúne funcionalidades de presentación del producto, contratación, administración de hogares y cuidadores, gestión de empleados, seguimiento del cuidado e integración de los componentes web, móviles, backend, Edge y dispositivos embebidos. Asimismo, contempla el reconocimiento local de voz y la continuidad de las operaciones esenciales sin conexión a Internet.

Luego de definir el objetivo del sprint, se seleccionaron las historias de usuario, historias técnicas y demás elementos correspondientes, y se descompusieron en subtareas relacionadas con su implementación y validación. Para organizar el trabajo, asignar responsables y dar seguimiento al progreso, se utilizó Jira.

Proyecto en Jira: [Alivia-Project](https://resolum-emergentes.atlassian.net/?continue=https%3A%2F%2Fresolum-emergentes.atlassian.net%2Fwelcome%2Fsoftware%3FprojectId%3D10001&atlOrigin=eyJpIjoiMDk5NGFlZWNjYjgxNGJiNDgzNjY3OWZmOTZlMWQwMTUiLCJwIjoiamlyYS1zb2Z0d2FyZSJ9)

![Sprint Backlog 1 de Alivia](https://i.imgur.com/rAwfXzG.png)

A continuación, se presenta la tabla con las tareas necesarias para completar el primer sprint. Cada subtarea se encuentra agrupada bajo su historia correspondiente e incluye su descripción, estimación en horas, responsable y estado actual en Jira.

La tabla contiene exclusivamente las 128 historias y los demás elementos principales asignados a **Alivia - Sprint 1**, junto con sus **436 subtareas**. Los identificadores US, TS, DMS, DUS y SP se conservan según el título de cada elemento, mientras que los títulos se presentan sin ese prefijo. Los estados y nombres de los responsables se reproducen como aparecen en Jira, consultado el **5 de noviembre de 2026**.

| User Story | Título | Work Item/Task | Título | Descripción | Estimation (Hours) | Assigned to | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| [US-01](https://resolum-emergentes.atlassian.net/browse/AP-13) | Conocer Alivia y sus beneficios | [AP-149](https://resolum-emergentes.atlassian.net/browse/AP-149) | Landing - Sección del problema y dispositivos incluidos | Sección de la landing que explica el problema que atiende Alivia y muestra los dispositivos incluidos (luz, puerta, ventana, micrófono). | 3 | Matias D. | Finalizada |
|  |  | [AP-150](https://resolum-emergentes.atlassian.net/browse/AP-150) | Landing - Sección de beneficios de autonomía y seguridad | Bloque con los beneficios para la persona asistida: control por voz, autonomía y seguridad en el hogar. | 3 | Matias D. | Finalizada |
|  |  | [AP-151](https://resolum-emergentes.atlassian.net/browse/AP-151) | Landing - Sección de beneficios de supervisión | Bloque con los beneficios para familiares y cuidadores: supervisión remota, alertas y coordinación. | 3 | Matias D. | Finalizada |
| [US-02](https://resolum-emergentes.atlassian.net/browse/AP-14) | Conocer el producto y al equipo mediante contenido audiovisual | [AP-152](https://resolum-emergentes.atlassian.net/browse/AP-152) | Landing - Reproductor del video del producto | Incrustar el video de presentación del producto con controles de reproducción. | 3 | Matias D. | Finalizada |
|  |  | [AP-153](https://resolum-emergentes.atlassian.net/browse/AP-153) | Landing - Reproductor del video del equipo | Incrustar el video de presentación del equipo con controles de reproducción. | 3 | Matias D. | Finalizada |
|  |  | [AP-154](https://resolum-emergentes.atlassian.net/browse/AP-154) | Landing - Mostrar alternativa textual accesible para contenido audiovisual | Mostrar un texto o resumen alternativo cuando el contenido audiovisual no pueda reproducirse. | 3 | Matias D. | Finalizada |
| [US-03](https://resolum-emergentes.atlassian.net/browse/AP-15) | Consultar testimonios y respaldo del servicio | [AP-155](https://resolum-emergentes.atlassian.net/browse/AP-155) | Landing - Sección de testimonios autorizados | Mostrar testimonios de personas relacionadas con Alivia y el beneficio que obtuvieron. | 3 | Matias D. | Finalizada |
|  |  | [AP-156](https://resolum-emergentes.atlassian.net/browse/AP-156) | Landing - Sección del equipo y su respaldo profesional | Presentar al equipo y su respaldo profesional para generar confianza. | 3 | Matias D. | Finalizada |
|  |  | [AP-157](https://resolum-emergentes.atlassian.net/browse/AP-157) | Landing - Anonimizar testimonios sin autorización de identidad completa | Mostrar solo identidad parcial o anónima cuando no hay autorización para publicar el nombre completo. | 4 | Matias D. | Finalizada |
| [US-04](https://resolum-emergentes.atlassian.net/browse/AP-16) | Consultar planes y continuar a la contratación | [AP-158](https://resolum-emergentes.atlassian.net/browse/AP-158) | Landing - Implementar comparativa de planes, precios y dispositivos incluidos | Tabla comparativa de planes con precios y características. | 6 | Matias D. | Finalizada |
|  |  | [AP-159](https://resolum-emergentes.atlassian.net/browse/AP-159) | Landing - Implementar redirección hacia la contratación en la web del cuidador | Botones que llevan a la aplicación web de contratación y muestran la disponibilidad en Android e iOS. | 6 | Matias D. | Finalizada |
|  |  | [AP-160](https://resolum-emergentes.atlassian.net/browse/AP-160) | Landing - Mostrar disponibilidad de la aplicación para Android e iOS | La aplicación web de usuarios lee el plan elegido enviado desde la landing y lo precarga al iniciar la contratación. | 3 | Matias D. | Finalizada |
| [US-05](https://resolum-emergentes.atlassian.net/browse/AP-17) | Registrar y verificar al responsable y crear la cuenta del hogar | [AP-161](https://resolum-emergentes.atlassian.net/browse/AP-161) | Web cuidador - Implementar formulario de registro del responsable | Endpoint de registro del cliente responsable en IAM y envío del código/enlace de verificación por SendGrid. | 6 | Matias D. | Finalizada |
|  |  | [AP-162](https://resolum-emergentes.atlassian.net/browse/AP-162) | Web cuidador - Implementar pantalla de verificación y reenvío del correo | Endpoint para validar el enlace o código, manejar enlaces inválidos o vencidos y reenviar la verificación. | 6 | Matias D. | Finalizada |
|  |  | [AP-163](https://resolum-emergentes.atlassian.net/browse/AP-163) | Web usuarios - Formulario de registro y verificación de correo | Pantallas de registro, aviso de correo enviado, verificación y reenvío. | 4 | Oscar Javier Armas Sanchez | Finalizada |
|  |  | [AP-164](https://resolum-emergentes.atlassian.net/browse/AP-164) | Web usuarios - Creación de la cuenta del hogar | Formulario para crear la cuenta compartida del hogar y validar datos obligatorios. | 4 | Matias D. | Finalizada |
| [US-06](https://resolum-emergentes.atlassian.net/browse/AP-18) | Seleccionar el plan de contratación | [AP-165](https://resolum-emergentes.atlassian.net/browse/AP-165) | Web cuidador - Implementar comparación de planes Base y Personalizado | Registrar el plan y la periodicidad elegidos como preliminares, sin activar suscripción, y validar disponibilidad. | 6 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-166](https://resolum-emergentes.atlassian.net/browse/AP-166) | Web cuidador - Implementar configuración del plan personalizado | Pantalla para elegir plan, periodicidad y cambiarlos antes de confirmar. | 6 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-167](https://resolum-emergentes.atlassian.net/browse/AP-167) | Web cuidador - Gestionar selección preliminar y disponibilidad del plan | Manejar el caso en que el plan elegido ya no está disponible y ofrecer alternativas. | 4 | Dayro Richard Rios Piñan | Finalizada |
| [US-07](https://resolum-emergentes.atlassian.net/browse/AP-19) | Autorizar temporalmente el importe | [AP-168](https://resolum-emergentes.atlassian.net/browse/AP-168) | Web cuidador - Implementar formulario de autorización con Stripe Elements | Formulario de pago con Stripe Elements para autorizar temporalmente el importe sin cobrar la suscripción. | 6 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-169](https://resolum-emergentes.atlassian.net/browse/AP-169) | Web cuidador - Mostrar confirmación de autorización temporal | Crear la suscripción/intención de pago con retención (autorización sin captura) en Stripe. | 3 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-170](https://resolum-emergentes.atlassian.net/browse/AP-170) | Web cuidador - Gestionar autorización rechazada o vencida | Procesar eventos de Stripe para medios de pago que no permiten retención y para autorizaciones vencidas. | 4 | Dayro Richard Rios Piñan | Finalizada |
| [US-08](https://resolum-emergentes.atlassian.net/browse/AP-20) | Seleccionar el horario de la evaluación técnica | [AP-171](https://resolum-emergentes.atlassian.net/browse/AP-171) | Web cuidador - Mostrar bloques disponibles para la evaluación técnica | Consultar bloques con capacidad disponible y reservar descontando capacidad. | 3 | Farid Coronel | Finalizada |
|  |  | [AP-172](https://resolum-emergentes.atlassian.net/browse/AP-172) | Web cuidador - Implementar reserva y reprogramación del horario | Pantalla para ver bloques, reservar y reprogramar una evaluación aún no realizada. | 6 | Farid Coronel | Finalizada |
|  |  | [AP-173](https://resolum-emergentes.atlassian.net/browse/AP-173) | Web cuidador - Gestionar indisponibilidad y visita no completada | Registrar la ausencia del cliente y liberar o reprogramar la capacidad. | 4 | Farid Coronel | Finalizada |
| [US-09](https://resolum-emergentes.atlassian.net/browse/AP-21) | Registrar la evaluación de compatibilidad | [AP-174](https://resolum-emergentes.atlassian.net/browse/AP-174) | Mobile técnico - Implementar revisión y confirmación del dictamen | Registrar resultado de puertas, ventanas, iluminación y conectividad, con dictamen favorable, parcial o desfavorable. | 6 | Farid Coronel | Finalizada |
|  |  | [AP-175](https://resolum-emergentes.atlassian.net/browse/AP-175) | Android técnico - Implementar formulario de evaluación de compatibilidad | Pantalla para que el técnico registre la evaluación en la vivienda. | 6 | Farid Coronel | Finalizada |
|  |  | [AP-176](https://resolum-emergentes.atlassian.net/browse/AP-176) | iOS técnico - Implementar formulario de evaluación de compatibilidad | Pantalla equivalente en iOS para el técnico. | 6 | Farid Coronel | Finalizada |
|  |  | [AP-177](https://resolum-emergentes.atlassian.net/browse/AP-177) | Web empresa - Implementar consulta del dictamen técnico | Vista para que la empresa consulte el dictamen y su detalle. | 6 | Farid Coronel | Finalizada |
| [US-10](https://resolum-emergentes.atlassian.net/browse/AP-22) | Continuar la contratación según el resultado técnico | [AP-178](https://resolum-emergentes.atlassian.net/browse/AP-178) | Web cuidador - Mostrar resultado de la evaluación técnica | Capturar el importe si es viable, ajustarlo en adaptación aceptada o liberarlo si se rechaza o no es viable. | 3 | Farid Coronel | Finalizada |
|  |  | [AP-179](https://resolum-emergentes.atlassian.net/browse/AP-179) | Web cuidador - Implementar revisión de la adaptación propuesta | Registrar la respuesta del cliente a la adaptación y actualizar el plan e importe. | 6 | Farid Coronel | Finalizada |
|  |  | [AP-180](https://resolum-emergentes.atlassian.net/browse/AP-180) | Web cuidador - Permitir aceptar o rechazar la adaptación | Mostrar el resultado de la evaluación, la propuesta de adaptación y los botones de aceptar o rechazar. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-181](https://resolum-emergentes.atlassian.net/browse/AP-181) | Web cuidador - Gestionar autorización vencida o cobro rechazado | Manejar el vencimiento de la autorización o el rechazo de la captura e informar al cliente. | 4 | Farid Coronel | Finalizada |
| [US-11](https://resolum-emergentes.atlassian.net/browse/AP-23) | Instalar y comprobar el servicio | [AP-182](https://resolum-emergentes.atlassian.net/browse/AP-182) | Android técnico - Implementar checklist de instalación y configuración | Registrar la instalación, configuración y resultados de las pruebas por dispositivo. | 6 | Farid Coronel | Finalizada |
|  |  | [AP-183](https://resolum-emergentes.atlassian.net/browse/AP-183) | iOS técnico - Implementar checklist de instalación y configuración | Activar el servicio y la suscripción cuando todas las pruebas pasan y el cliente da su conformidad. | 6 | Farid Coronel | Finalizada |
|  |  | [AP-184](https://resolum-emergentes.atlassian.net/browse/AP-184) | Android técnico - Registrar pruebas, fallas y conformidad del cliente | Pantalla del técnico para configurar y probar cada dispositivo. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-185](https://resolum-emergentes.atlassian.net/browse/AP-185) | iOS técnico - Registrar pruebas, fallas y conformidad del cliente | Pantalla equivalente en iOS. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-186](https://resolum-emergentes.atlassian.net/browse/AP-186) | Web empresa - Consultar avance y resultado de la instalación | Rutina de prueba del edge de micrófono (conexión al broker y captura de voz). | 4 | Farid Coronel | Finalizada |
|  |  | [AP-187](https://resolum-emergentes.atlassian.net/browse/AP-187) | Mobile técnico - Mostrar instalación pendiente por dispositivo con falla | Rutina de prueba del edge de actuadores (movimiento y estado de luz, puerta y ventana). | 3 | Farid Coronel | Finalizada |
| [US-12](https://resolum-emergentes.atlassian.net/browse/AP-24) | Registrar a una persona asistida en el hogar | [AP-188](https://resolum-emergentes.atlassian.net/browse/AP-188) | Web cuidador - Implementar formulario de registro de persona asistida | Comando en profiles/assets para registrar a la persona asistida vinculada a la cuenta del hogar. | 6 | Farid Coronel | To-Do |
|  |  | [AP-189](https://resolum-emergentes.atlassian.net/browse/AP-189) | Web cuidador - Consultar y actualizar a la persona asistida registrada | Pantalla con formulario y validación de campos obligatorios. | 4 | Farid Coronel | To-Do |
|  |  | [AP-190](https://resolum-emergentes.atlassian.net/browse/AP-190) | Web cuidador - Gestionar datos incompletos, duplicados y falta de permisos | Rechazar perfiles duplicados y usuarios sin permiso de administración. | 4 | Farid Coronel | To-Do |
| [US-13](https://resolum-emergentes.atlassian.net/browse/AP-25) | Invitar y gestionar cuidadores vinculados al hogar | [AP-191](https://resolum-emergentes.atlassian.net/browse/AP-191) | Web cuidador - Invitar cuidador y definir responsabilidades | Crear invitación pendiente y enviarla por correo; rechazar si el miembro ya está vinculado. | 4 | Matias D. | Finalizada |
|  |  | [AP-192](https://resolum-emergentes.atlassian.net/browse/AP-192) | Web cuidador - Implementar aceptación o rechazo de la invitación | Aceptar invitación vigente con permisos autorizados; rechazadas o vencidas no crean membresía. | 6 | Matias D. | Finalizada |
|  |  | [AP-193](https://resolum-emergentes.atlassian.net/browse/AP-193) | Web cuidador - Gestionar desvinculación y responsabilidades pendientes | Desvincular cuidador validando que no tenga responsabilidades activas pendientes. | 4 | Matias D. | Finalizada |
|  |  | [AP-194](https://resolum-emergentes.atlassian.net/browse/AP-194) | Web cuidador - Consultar la red de cuidado y estados de invitación | Pantalla para invitar, ver estado y desvincular cuidadores. | 4 | Matias D. | Finalizada |
|  |  | [AP-195](https://resolum-emergentes.atlassian.net/browse/AP-195) | Android cuidador - Aceptar invitación y consultar la red de cuidado | Pantalla móvil para aceptar o rechazar invitaciones y ver cuidadores. | 4 | Oscar Javier Armas Sanchez | To-Do |
|  |  | [AP-196](https://resolum-emergentes.atlassian.net/browse/AP-196) | iOS cuidador - Aceptar invitación y consultar la red de cuidado | Pantalla equivalente en iOS. | 4 | Oscar Javier Armas Sanchez | To-Do |
| [US-14](https://resolum-emergentes.atlassian.net/browse/AP-26) | Actualizar el perfil personal | [AP-197](https://resolum-emergentes.atlassian.net/browse/AP-197) | Web cuidador - Actualizar datos y preferencias del perfil personal | Comando para actualizar datos personales y preferencias de comunicación, sin permitir editar perfiles ajenos ni DNI/correo. | 4 | Nicolás Juárez | In-Progress |
|  |  | [AP-198](https://resolum-emergentes.atlassian.net/browse/AP-198) | Web cuidador - Gestionar cambio y verificación del correo | Flujo de cambio de correo pendiente hasta verificarlo. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-199](https://resolum-emergentes.atlassian.net/browse/AP-199) | Web cuidador - Gestionar validaciones y estados del perfil | Pantalla para ver y editar el perfil. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-200](https://resolum-emergentes.atlassian.net/browse/AP-200) | Web empresa - Consultar y actualizar el perfil personal | Pantalla equivalente para el personal de la empresa. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-201](https://resolum-emergentes.atlassian.net/browse/AP-201) | Android - Consultar y actualizar el perfil personal | Pantalla de perfil en Android. | 4 | Farid Coronel | To-Do |
|  |  | [AP-202](https://resolum-emergentes.atlassian.net/browse/AP-202) | iOS - Consultar y actualizar el perfil personal | Pantalla de perfil en iOS. | 4 | Farid Coronel | To-Do |
| [US-15](https://resolum-emergentes.atlassian.net/browse/AP-27) | Acceder a Alivia | [AP-203](https://resolum-emergentes.atlassian.net/browse/AP-203) | Web cuidador - Implementar pantalla de inicio de sesión | Endpoint de login que emite el token según el rol. | 6 | Matias D. | Finalizada |
|  |  | [AP-204](https://resolum-emergentes.atlassian.net/browse/AP-204) | Web empresa - Implementar pantalla de inicio de sesión | Respuestas claras para datos incorrectos y cuentas suspendidas o pendientes. | 6 | Matias D. | To-Do |
|  |  | [AP-205](https://resolum-emergentes.atlassian.net/browse/AP-205) | Android - Implementar pantalla de inicio de sesión | Formulario de login y manejo de errores. | 6 | Oscar Javier Armas Sanchez | To-Do |
|  |  | [AP-206](https://resolum-emergentes.atlassian.net/browse/AP-206) | iOS - Implementar pantalla de inicio de sesión | Formulario de login para personal de la empresa. | 6 | Oscar Javier Armas Sanchez | To-Do |
|  |  | [AP-207](https://resolum-emergentes.atlassian.net/browse/AP-207) | Web - Gestionar credenciales incorrectas y cuentas no habilitadas | Login en Android con almacenamiento seguro del token. | 4 | Matias D. | Finalizada |
|  |  | [AP-208](https://resolum-emergentes.atlassian.net/browse/AP-208) | Mobile - Gestionar credenciales incorrectas y cuentas no habilitadas | Login en iOS con almacenamiento seguro del token. | 4 | Oscar Javier Armas Sanchez | To-Do |
| [US-16](https://resolum-emergentes.atlassian.net/browse/AP-28) | Recuperar el acceso | [AP-209](https://resolum-emergentes.atlassian.net/browse/AP-209) | Web cuidador - Recuperar contraseña mediante enlace enviado por correo | Enviar instrucciones temporales al correo registrado; respuesta neutra si el contacto no existe. | 4 | Matias D. | Finalizada |
|  |  | [AP-210](https://resolum-emergentes.atlassian.net/browse/AP-210) | Web empresa - Recuperar contraseña mediante enlace enviado por correo | Validar el enlace o código y rechazar los vencidos. | 4 | Matias D. | To-Do |
|  |  | [AP-211](https://resolum-emergentes.atlassian.net/browse/AP-211) | Android - Recuperar contraseña mediante código de seis dígitos | Pantallas de solicitud y restablecimiento. | 4 | Oscar Javier Armas Sanchez | To-Do |
|  |  | [AP-212](https://resolum-emergentes.atlassian.net/browse/AP-212) | iOS - Recuperar contraseña mediante código de seis dígitos | Pantallas de recuperación en Android. | 4 | Oscar Javier Armas Sanchez | To-Do |
|  |  | [AP-213](https://resolum-emergentes.atlassian.net/browse/AP-213) | Web y Mobile - Gestionar instrucciones vencidas y reenvío de recuperación | Pantallas de recuperación en iOS. | 4 | Oscar Javier Armas Sanchez | To-Do |
| [US-17](https://resolum-emergentes.atlassian.net/browse/AP-29) | Autorizar capacidades según responsabilidad | [AP-214](https://resolum-emergentes.atlassian.net/browse/AP-214) | Web empresa - Consultar usuarios y responsabilidades asignadas | Asignar roles (ADMIN, TECH, SUBSCRIPTION_MANAGER, CLEANING, RELATIVE, CAREGIVER) y retirarlos sin afectar otros. | 4 | Matias D. | To-Do |
|  |  | [AP-215](https://resolum-emergentes.atlassian.net/browse/AP-215) | Web empresa - Asignar y retirar responsabilidades autorizadas | Rechazar combinaciones incompatibles y evitar permisos duplicados. | 4 | Matias D. | To-Do |
|  |  | [AP-216](https://resolum-emergentes.atlassian.net/browse/AP-216) | Web empresa - Gestionar responsabilidades incompatibles y permisos duplicados | Rechazar operaciones fuera de los permisos del usuario. | 4 | Matias D. | To-Do |
|  |  | [AP-217](https://resolum-emergentes.atlassian.net/browse/AP-217) | Web empresa - Mostrar capacidades habilitadas según responsabilidad | Pantalla para asignar y retirar roles a usuarios. | 3 | Matias D. | To-Do |
| [US-18](https://resolum-emergentes.atlassian.net/browse/AP-30) | Controlar la iluminación mediante voz | [AP-219](https://resolum-emergentes.atlassian.net/browse/AP-219) | Web cuidador - Consultar el estado y la última acción de iluminación | Detectar la palabra de activación y transcribir localmente el comando para encender y apagar la luz (umbral de confianza 75%). | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-221](https://resolum-emergentes.atlassian.net/browse/AP-221) | Android cuidador - Mostrar el estado y los eventos de iluminación | Recibir el comando por MQTT, accionar el relé y confirmar el estado. | 3 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-223](https://resolum-emergentes.atlassian.net/browse/AP-223) | iOS cuidador - Mostrar el estado y los eventos de iluminación | Firmware C++ del nodo ESP32 para encender y apagar y leer el sensor de estado. | 3 | Farid Coronel | To-Do |
|  |  | [AP-225](https://resolum-emergentes.atlassian.net/browse/AP-225) | Mobile cuidador - Mostrar alerta ante una falla de iluminación | Registrar la acción en Tracking y generar alerta al cuidador si no hay respuesta o hay bloqueo. | 3 | Farid Coronel | To-Do |
| [US-19](https://resolum-emergentes.atlassian.net/browse/AP-31) | Controlar la puerta mediante voz | [AP-227](https://resolum-emergentes.atlassian.net/browse/AP-227) | Web cuidador - Consultar el estado y la última acción de la puerta | Detectar la palabra de activación y transcribir localmente el comando para abrir y cerrar la puerta (umbral de confianza 75%). | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-229](https://resolum-emergentes.atlassian.net/browse/AP-229) | Android cuidador - Mostrar el estado y los eventos de la puerta | Recibir el comando por MQTT, accionar el servo y confirmar el estado. | 3 | Farid Coronel | To-Do |
|  |  | [AP-231](https://resolum-emergentes.atlassian.net/browse/AP-231) | iOS cuidador - Mostrar el estado y los eventos de la puerta | Firmware C++ del nodo ESP32 para abrir y cerrar y leer el sensor de estado. | 3 | Farid Coronel | To-Do |
|  |  | [AP-233](https://resolum-emergentes.atlassian.net/browse/AP-233) | Mobile cuidador - Mostrar alerta ante bloqueo o falla de la puerta | Registrar la acción en Tracking y generar alerta al cuidador si no hay respuesta o hay bloqueo. | 3 | Farid Coronel | To-Do |
| [US-20](https://resolum-emergentes.atlassian.net/browse/AP-32) | Controlar la ventana mediante voz | [AP-235](https://resolum-emergentes.atlassian.net/browse/AP-235) | Web cuidador - Consultar el estado y la última acción de la ventana | Detectar la palabra de activación y transcribir localmente el comando para abrir y cerrar la ventana (umbral de confianza 75%). | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-237](https://resolum-emergentes.atlassian.net/browse/AP-237) | Android cuidador - Mostrar el estado y los eventos de la ventana | Recibir el comando por MQTT, accionar el servo y confirmar el estado. | 3 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-239](https://resolum-emergentes.atlassian.net/browse/AP-239) | iOS cuidador - Mostrar el estado y los eventos de la ventana | Firmware C++ del nodo ESP32 para abrir y cerrar y leer el sensor de estado. | 3 | Farid Coronel | To-Do |
|  |  | [AP-241](https://resolum-emergentes.atlassian.net/browse/AP-241) | Mobile cuidador - Mostrar alerta ante resistencia o falla de la ventana | Registrar la acción en Tracking y generar alerta al cuidador si no hay respuesta o hay bloqueo. | 3 | Dayro Richard Rios Piñan | To-Do |
| [US-21](https://resolum-emergentes.atlassian.net/browse/AP-33) | Mantener el control esencial sin Internet | [AP-243](https://resolum-emergentes.atlassian.net/browse/AP-243) | Web cuidador - Mostrar indicador de hogar sin conexión | Asegurar que el reconocimiento de voz funciona totalmente en local. | 3 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-245](https://resolum-emergentes.atlassian.net/browse/AP-245) | Web cuidador - Mostrar eventos pendientes y última sincronización | Ejecutar acciones en local y guardar eventos en SQLite mientras no hay Internet. | 3 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-247](https://resolum-emergentes.atlassian.net/browse/AP-247) | Android cuidador - Mostrar estado de operación sin conexión | Enviar los eventos pendientes al backend con reportId. | 3 | Farid Coronel | To-Do |
|  |  | [AP-249](https://resolum-emergentes.atlassian.net/browse/AP-249) | iOS cuidador - Mostrar estado de operación sin conexión | Aceptar reportId repetidos sin duplicar eventos. | 3 | Farid Coronel | To-Do |
|  |  | [AP-251](https://resolum-emergentes.atlassian.net/browse/AP-251) | Web y Mobile - Mostrar resultado de sincronización sin eventos duplicados | Mostrar que la vivienda está sin conexión y hay eventos pendientes. | 3 | Farid Coronel | To-Do |
| [US-22](https://resolum-emergentes.atlassian.net/browse/AP-34) | Supervisar remotamente a la persona asistida | [AP-254](https://resolum-emergentes.atlassian.net/browse/AP-254) | Web cuidador - Implementar panel de supervisión remota | Endpoints de Tracking para estado, historial de acciones y alertas recientes, solo para cuidadores autorizados. | 6 | Matias D. | Finalizada |
|  |  | [AP-257](https://resolum-emergentes.atlassian.net/browse/AP-257) | Android cuidador - Implementar supervisión remota | Panel con estado de dispositivos, historial y aviso de vivienda sin conexión. | 6 | Oscar Javier Armas Sanchez | To-Do |
|  |  | [AP-260](https://resolum-emergentes.atlassian.net/browse/AP-260) | iOS cuidador - Implementar supervisión remota | Pantalla móvil de estado e historial. | 6 | Oscar Javier Armas Sanchez | To-Do |
|  |  | [AP-263](https://resolum-emergentes.atlassian.net/browse/AP-263) | Web y Mobile - Mostrar último estado, actualización y vivienda desconectada | Pantalla móvil de estado e historial. | 3 | Oscar Javier Armas Sanchez | To-Do |
| [US-23](https://resolum-emergentes.atlassian.net/browse/AP-35) | Recibir alertas escritas de rápida lectura | [AP-218](https://resolum-emergentes.atlassian.net/browse/AP-218) | Web cuidador - Implementar bandeja emergente de alertas | Crear alertas en Communication con prioridad normal o crítica y contenido de rápida lectura. | 6 | Oscar Javier Armas Sanchez | To-Do |
|  |  | [AP-220](https://resolum-emergentes.atlassian.net/browse/AP-220) | Web cuidador - Implementar detalle de alerta escrita | Enviar por Firebase FCM y conservar como pendientes las alertas no entregadas. | 6 | Oscar Javier Armas Sanchez | To-Do |
|  |  | [AP-222](https://resolum-emergentes.atlassian.net/browse/AP-222) | Android cuidador - Implementar notificaciones y centro de alertas | Bandeja de alertas con prioridad diferenciada. | 6 | Oscar Javier Armas Sanchez | To-Do |
|  |  | [AP-224](https://resolum-emergentes.atlassian.net/browse/AP-224) | iOS cuidador - Implementar notificaciones y centro de alertas | Notificación push y pantalla de alertas. | 6 | Oscar Javier Armas Sanchez | To-Do |
|  |  | [AP-226](https://resolum-emergentes.atlassian.net/browse/AP-226) | Mobile cuidador - Mostrar prioridad, estado y confirmación de alertas | Notificación push y pantalla de alertas. | 3 | Oscar Javier Armas Sanchez | To-Do |
| [US-26](https://resolum-emergentes.atlassian.net/browse/AP-38) | Organizar turnos y disponibilidad | [AP-248](https://resolum-emergentes.atlassian.net/browse/AP-248) | Web cuidador - Implementar calendario de turnos | Comandos para asignar un cuidador a un turno y consultar el responsable de un periodo. | 6 | Matias D. | Finalizada |
|  |  | [AP-250](https://resolum-emergentes.atlassian.net/browse/AP-250) | Web cuidador - Crear y editar turnos de cuidado | Validar coincidencias con otra responsabilidad. | 4 | Matias D. | Finalizada |
|  |  | [AP-252](https://resolum-emergentes.atlassian.net/browse/AP-252) | Web cuidador - Mostrar superposiciones de turnos | Vista de turnos y disponibilidad. | 3 | Matias D. | Finalizada |
|  |  | [AP-255](https://resolum-emergentes.atlassian.net/browse/AP-255) | Android cuidador - Consultar turnos asignados | Vista y registro de turnos. | 4 | Oscar Javier Armas Sanchez | To-Do |
|  |  | [AP-258](https://resolum-emergentes.atlassian.net/browse/AP-258) | iOS cuidador - Consultar turnos asignados | Vista y registro de turnos. | 4 | Oscar Javier Armas Sanchez | To-Do |
| [US-27](https://resolum-emergentes.atlassian.net/browse/AP-39) | Transferir la responsabilidad del cuidado | [AP-261](https://resolum-emergentes.atlassian.net/browse/AP-261) | Web cuidador - Iniciar transferencia de responsabilidad | Solicitar, aceptar y registrar el relevo. | 4 | Matias D. | Finalizada |
|  |  | [AP-264](https://resolum-emergentes.atlassian.net/browse/AP-264) | Web cuidador - Mostrar resumen de asuntos atendidos y pendientes | Generar el resumen de asuntos atendidos y pendientes, escalar relevos sin respuesta y asignar sustituto. | 3 | Matias D. | Finalizada |
|  |  | [AP-266](https://resolum-emergentes.atlassian.net/browse/AP-266) | Android cuidador - Aceptar o rechazar el relevo | Solicitar, aceptar y ver el resumen del relevo. | 4 | Oscar Javier Armas Sanchez | To-Do |
|  |  | [AP-268](https://resolum-emergentes.atlassian.net/browse/AP-268) | iOS cuidador - Aceptar o rechazar el relevo | Solicitar y aceptar relevo. | 4 | Oscar Javier Armas Sanchez | To-Do |
|  |  | [AP-271](https://resolum-emergentes.atlassian.net/browse/AP-271) | Web y Mobile - Gestionar relevo pendiente, sustitución y escalamiento | Solicitar y aceptar relevo. | 4 | Oscar Javier Armas Sanchez | To-Do |
| [US-28](https://resolum-emergentes.atlassian.net/browse/AP-40) | Coordinar actividades de cuidado | [AP-272](https://resolum-emergentes.atlassian.net/browse/AP-272) | Web cuidador - Registrar actividades de cuidado | Programar alimentación, higiene y movilización con horario. | 4 | Matias D. | Finalizada |
|  |  | [AP-274](https://resolum-emergentes.atlassian.net/browse/AP-274) | Web cuidador - Mostrar actividades en lista y calendario | Registrar la atención y marcar MISSED con el job de las 00:05 las no confirmadas. | 3 | Matias D. | Finalizada |
|  |  | [AP-276](https://resolum-emergentes.atlassian.net/browse/AP-276) | Web cuidador - Gestionar responsables y estados de actividades | Programar y registrar actividades. | 4 | Matias D. | Finalizada |
|  |  | [AP-278](https://resolum-emergentes.atlassian.net/browse/AP-278) | Android cuidador - Consultar y registrar resultado de actividades | Programar y registrar actividades. | 4 | Oscar Javier Armas Sanchez | To-Do |
|  |  | [AP-280](https://resolum-emergentes.atlassian.net/browse/AP-280) | iOS cuidador - Consultar y registrar resultado de actividades | Programar y registrar actividades. | 4 | Oscar Javier Armas Sanchez | To-Do |
| [US-29](https://resolum-emergentes.atlassian.net/browse/AP-41) | Programar la administración de medicamentos | [AP-282](https://resolum-emergentes.atlassian.net/browse/AP-282) | Web cuidador - Registrar programación de medicamentos | Registrar medicamento, dosis, horario y responsable sin modificar la indicación. | 4 | Matias D. | Finalizada |
|  |  | [AP-284](https://resolum-emergentes.atlassian.net/browse/AP-284) | Web cuidador - Actualizar o suspender programación de medicamentos | Actualizar o suspender con autorización y sustento, conservando el historial. | 4 | Matias D. | Finalizada |
|  |  | [AP-286](https://resolum-emergentes.atlassian.net/browse/AP-286) | Web cuidador - Gestionar validaciones y autorizaciones de medicamentos | Programar y administrar medicamentos. | 4 | Matias D. | Finalizada |
|  |  | [AP-288](https://resolum-emergentes.atlassian.net/browse/AP-288) | Android cuidador - Consultar medicamentos y recordatorios | Programar y administrar medicamentos. | 4 | Oscar Javier Armas Sanchez | To-Do |
|  |  | [AP-290](https://resolum-emergentes.atlassian.net/browse/AP-290) | iOS cuidador - Consultar medicamentos y recordatorios | Programar y administrar medicamentos. | 4 | Oscar Javier Armas Sanchez | To-Do |
| [US-30](https://resolum-emergentes.atlassian.net/browse/AP-42) | Consultar el estado de los dispositivos | [AP-292](https://resolum-emergentes.atlassian.net/browse/AP-292) | Web cuidador - Mostrar dispositivos agrupados por habitación | Enviar heartbeat cada 60 s con conexión, batería y funcionamiento. | 3 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-294](https://resolum-emergentes.atlassian.net/browse/AP-294) | Web cuidador - Mostrar detalle del dispositivo | Enviar heartbeat cada 60 s del micrófono. | 3 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-296](https://resolum-emergentes.atlassian.net/browse/AP-296) | Android cuidador - Mostrar lista de dispositivos | Guardar último estado y marcar sin conexión tras 5 min sin heartbeat. | 3 | Sin asignar | To-Do |
|  |  | [AP-298](https://resolum-emergentes.atlassian.net/browse/AP-298) | Android cuidador - Mostrar detalle del dispositivo | Generar alerta cuando la batería baja del umbral. | 3 | Sin asignar | To-Do |
|  |  | [AP-300](https://resolum-emergentes.atlassian.net/browse/AP-300) | iOS cuidador - Mostrar lista de dispositivos | Lista con conexión, batería y funcionamiento. | 3 | Sin asignar | To-Do |
|  |  | [AP-302](https://resolum-emergentes.atlassian.net/browse/AP-302) | iOS cuidador - Mostrar detalle del dispositivo | Lista de estado. | 3 | Sin asignar | To-Do |
|  |  | [AP-304](https://resolum-emergentes.atlassian.net/browse/AP-304) | Web y Mobile - Mostrar batería baja, desconexión y último estado conocido | Lista de estado. | 3 | Dayro Richard Rios Piñan | To-Do |
| [US-31](https://resolum-emergentes.atlassian.net/browse/AP-43) | Reportar una falla y coordinar su atención técnica | [AP-306](https://resolum-emergentes.atlassian.net/browse/AP-306) | Web cuidador - Implementar formulario de reporte de incidencia | Crear incidencia y evitar duplicados abiertos para el mismo dispositivo. | 6 | Farid Coronel | Finalizada |
|  |  | [AP-307](https://resolum-emergentes.atlassian.net/browse/AP-307) | Web cuidador - Adjuntar fotografías a la incidencia | Subir fotos a Cloudinary y reservar un bloque disponible. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-309](https://resolum-emergentes.atlassian.net/browse/AP-309) | Web cuidador - Seleccionar horario de atención cuando corresponda | Formulario y seguimiento del estado. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-311](https://resolum-emergentes.atlassian.net/browse/AP-311) | Web cuidador - Consultar seguimiento de la incidencia | Formulario con cámara y seguimiento. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-313](https://resolum-emergentes.atlassian.net/browse/AP-313) | Web cuidador - Mostrar incidencia equivalente actualmente abierta | Formulario con cámara y seguimiento. | 3 | Farid Coronel | Finalizada |
| [US-32](https://resolum-emergentes.atlassian.net/browse/AP-44) | Gestionar mantenimiento y reemplazo | [AP-315](https://resolum-emergentes.atlassian.net/browse/AP-315) | Web empresa - Consultar incidencias técnicas asignadas | Registrar diagnóstico y mantenimiento de un dispositivo y devolverlo a disponible. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-317](https://resolum-emergentes.atlassian.net/browse/AP-317) | Web empresa - Registrar diagnóstico y mantenimiento | Aprobar reemplazo por garantía o informar alternativa si no aplica. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-319](https://resolum-emergentes.atlassian.net/browse/AP-319) | Web empresa - Gestionar garantía y reemplazo de dispositivos | Conservar el historial de mantenimiento y reemplazos. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-321](https://resolum-emergentes.atlassian.net/browse/AP-321) | Android técnico - Registrar atención técnica | Pantalla para el personal de soporte. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-323](https://resolum-emergentes.atlassian.net/browse/AP-323) | iOS técnico - Registrar atención técnica | Pantalla de reemplazo con garantía y alternativa. | 4 | Farid Coronel | Finalizada |
| [US-33](https://resolum-emergentes.atlassian.net/browse/AP-45) | Administrar planes y condiciones comerciales | [AP-325](https://resolum-emergentes.atlassian.net/browse/AP-325) | Web empresa - Listar planes y condiciones comerciales | Crear, habilitar, modificar y retirar planes con condiciones obligatorias. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-327](https://resolum-emergentes.atlassian.net/browse/AP-327) | Web empresa - Crear o editar planes y condiciones | Alta, edición y retiro de planes. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-329](https://resolum-emergentes.atlassian.net/browse/AP-329) | Web empresa - Retirar un plan conservando contrataciones vigentes | Aplicar los cambios solo a nuevas contrataciones. | 4 | Dayro Richard Rios Piñan | Finalizada |
| [US-34](https://resolum-emergentes.atlassian.net/browse/AP-46) | Administrar órdenes, técnicos disponibles y dispositivos requeridos | [AP-253](https://resolum-emergentes.atlassian.net/browse/AP-253) | Web empresa - Mostrar listado y calendario de órdenes técnicas | Crear y administrar órdenes de evaluación, instalación e incidencia. | 3 | Farid Coronel | Finalizada |
|  |  | [AP-256](https://resolum-emergentes.atlassian.net/browse/AP-256) | Web empresa - Consultar detalle de la orden técnica | Asignar técnicos elegibles, incluso equivalentes, y reasignar por indisponibilidad. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-259](https://resolum-emergentes.atlassian.net/browse/AP-259) | Web empresa - Asignar o reasignar técnico elegible | Reservar los dispositivos requeridos según disponibilidad. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-262](https://resolum-emergentes.atlassian.net/browse/AP-262) | Web empresa - Reservar dispositivos requeridos por la orden | Pantalla de órdenes con estado. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-265](https://resolum-emergentes.atlassian.net/browse/AP-265) | Web empresa - Mostrar alternativas cuando no exista capacidad | Pantalla para asignar y reservar. | 3 | Farid Coronel | Finalizada |
| [US-35](https://resolum-emergentes.atlassian.net/browse/AP-47) | Consultar la trazabilidad de las operaciones técnicas | [AP-267](https://resolum-emergentes.atlassian.net/browse/AP-267) | Web empresa - Mostrar línea de tiempo de operaciones técnicas | Consulta por periodo, ejecutor, hogar, orden o dispositivo, cronológica. | 3 | Farid Coronel | Finalizada |
|  |  | [AP-269](https://resolum-emergentes.atlassian.net/browse/AP-269) | Web empresa - Filtrar trazabilidad por hogar, orden, dispositivo y técnico | Línea de tiempo con filtros. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-270](https://resolum-emergentes.atlassian.net/browse/AP-270) | Web empresa - Mostrar reasignaciones y estado sin resultados | Filtros y mensaje cuando no hay resultados. | 3 | Farid Coronel | Finalizada |
| [US-37](https://resolum-emergentes.atlassian.net/browse/AP-49) | Registrar el resultado de una administración de medicamento | [AP-283](https://resolum-emergentes.atlassian.net/browse/AP-283) | Web cuidador - Registrar resultado de administración de medicamento | Registrar administración u omisión con motivo, evitando duplicados. | 4 | Matias D. | Finalizada |
|  |  | [AP-285](https://resolum-emergentes.atlassian.net/browse/AP-285) | Web cuidador - Consultar historial de administraciones | Generar alerta si vence sin confirmar y marcar registros tardíos. | 4 | Matias D. | Finalizada |
|  |  | [AP-287](https://resolum-emergentes.atlassian.net/browse/AP-287) | Android cuidador - Registrar administración atendida, omitida o tardía | Consulta del historial solo para usuarios autorizados. | 4 | Oscar Javier Armas Sanchez | To-Do |
|  |  | [AP-289](https://resolum-emergentes.atlassian.net/browse/AP-289) | iOS cuidador - Registrar administración atendida, omitida o tardía | Pantalla de registro y consulta. | 4 | Oscar Javier Armas Sanchez | To-Do |
|  |  | [AP-291](https://resolum-emergentes.atlassian.net/browse/AP-291) | Web y Mobile - Evitar confirmaciones duplicadas de medicamentos | Pantalla de confirmación u omisión. | 4 | Matias D. | To-Do |
|  |  | [AP-293](https://resolum-emergentes.atlassian.net/browse/AP-293) | Web y Mobile - Mostrar falta de permisos o administración vencida | Pantalla de confirmación u omisión. | 3 | Matias D. | To-Do |
| [US-38](https://resolum-emergentes.atlassian.net/browse/AP-50) | Gestionar las suscripciones asociadas con los hogares | [AP-295](https://resolum-emergentes.atlassian.net/browse/AP-295) | Web empresa - Mostrar listado y detalle de suscripciones | Consulta del plan, vigencia y pagos de cada hogar. | 3 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-297](https://resolum-emergentes.atlassian.net/browse/AP-297) | Web empresa - Gestionar solicitud de cambio de plan | Solicitar y aplicar cambio validando condiciones, conservando historial. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-299](https://resolum-emergentes.atlassian.net/browse/AP-299) | Web empresa - Suspender o reactivar una suscripción | Suspender o reactivar por causa autorizada y rechazar estados incompatibles. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-301](https://resolum-emergentes.atlassian.net/browse/AP-301) | Web empresa - Mostrar pagos y estado de facturación | Procesar webhooks de Stripe; PAST_DUE termina cancelada si se agotan los reintentos. | 3 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-303](https://resolum-emergentes.atlassian.net/browse/AP-303) | Web empresa - Consultar historial de cambios de suscripción | Pantalla de consulta y acciones. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-305](https://resolum-emergentes.atlassian.net/browse/AP-305) | Web empresa - Mostrar bloqueos por servicios pendientes o estado incompatible | Pantalla del historial. | 3 | Dayro Richard Rios Piñan | Finalizada |
| [US-39](https://resolum-emergentes.atlassian.net/browse/AP-51) | Consultar métricas de ventas | [AP-308](https://resolum-emergentes.atlassian.net/browse/AP-308) | Web empresa - Implementar dashboard gráfico de ventas | Consulta por periodo con distribución por plan, periodicidad y estado. | 6 | Renato Calvo Yalan | To-Do |
|  |  | [AP-310](https://resolum-emergentes.atlassian.net/browse/AP-310) | Web empresa - Filtrar y comparar periodos de ventas | Gráficos y filtros por periodo. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-312](https://resolum-emergentes.atlassian.net/browse/AP-312) | Web empresa - Mostrar desglose y estado sin resultados | Comparar dos periodos y mostrar estado vacío. | 3 | Renato Calvo Yalan | To-Do |
| [US-40](https://resolum-emergentes.atlassian.net/browse/AP-52) | Consultar métricas globales del negocio | [AP-314](https://resolum-emergentes.atlassian.net/browse/AP-314) | Web empresa - Implementar dashboard global del negocio | Resumen global con filtros por fecha, plan o estado y desglose. | 6 | Renato Calvo Yalan | To-Do |
|  |  | [AP-316](https://resolum-emergentes.atlassian.net/browse/AP-316) | Web empresa - Filtrar métricas y navegar hacia el detalle | Pantalla con indicadores, filtros y hora de última actualización. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-318](https://resolum-emergentes.atlassian.net/browse/AP-318) | Web empresa - Mostrar última actualización, acceso restringido y estado sin datos | Rechazar consultas sin rol de administrador. | 3 | Renato Calvo Yalan | To-Do |
| [US-41](https://resolum-emergentes.atlassian.net/browse/AP-53) | Consultar métricas de autonomía y acciones realizadas | [AP-320](https://resolum-emergentes.atlassian.net/browse/AP-320) | Web cuidador - Implementar dashboard gráfico de autonomía | Calcular resultados por dispositivo y periodo desde Tracking sin exponer audio. | 6 | Renato Calvo Yalan | To-Do |
|  |  | [AP-322](https://resolum-emergentes.atlassian.net/browse/AP-322) | Android cuidador - Mostrar métricas de autonomía | Deduplicar eventos sincronizados desde el Edge. | 3 | Sin asignar | To-Do |
|  |  | [AP-324](https://resolum-emergentes.atlassian.net/browse/AP-324) | iOS cuidador - Mostrar métricas de autonomía | Gráficos y filtros por dispositivo y periodo. | 3 | Sin asignar | To-Do |
|  |  | [AP-326](https://resolum-emergentes.atlassian.net/browse/AP-326) | Web y Mobile - Mostrar última sincronización y proteger la privacidad del audio | Resumen de acciones. | 3 | Matias D. | To-Do |
| [US-42](https://resolum-emergentes.atlassian.net/browse/AP-54) | Gestionar el perfil de la cuenta del hogar | [AP-328](https://resolum-emergentes.atlassian.net/browse/AP-328) | Web cuidador - Registrar datos del hogar y ubicación | Alias, teléfono, correo de contacto y ubicación, solo con permisos. | 4 | Farid Coronel | To-Do |
|  |  | [AP-330](https://resolum-emergentes.atlassian.net/browse/AP-330) | Web cuidador - Consultar y actualizar el perfil del hogar | Formulario con selección de ubicación en Google Maps. | 4 | Farid Coronel | To-Do |
|  |  | [AP-331](https://resolum-emergentes.atlassian.net/browse/AP-331) | Web cuidador - Gestionar ubicación inválida, permisos y órdenes afectadas | Rechazar ubicaciones no válidas o fuera de cobertura y controlar cambios con órdenes activas. | 4 | Farid Coronel | To-Do |
| [US-43](https://resolum-emergentes.atlassian.net/browse/AP-55) | Registrar y administrar empleados | [AP-332](https://resolum-emergentes.atlassian.net/browse/AP-332) | Web empresa - Mostrar listado y detalle de empleados | Alta con identificador único y estado activo, y actualización con trazabilidad. | 3 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-333](https://resolum-emergentes.atlassian.net/browse/AP-333) | Web empresa - Implementar registro de empleados | Rechazar documento o correo duplicado y conservar historial al desactivar. | 6 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-334](https://resolum-emergentes.atlassian.net/browse/AP-334) | Web empresa - Editar información laboral del empleado | Pantallas de listado y alta. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-335](https://resolum-emergentes.atlassian.net/browse/AP-335) | Web empresa - Gestionar duplicados, desactivación y órdenes pendientes | Pantalla de edición con aviso de órdenes futuras. | 4 | Dayro Richard Rios Piñan | Finalizada |
| [US-44](https://resolum-emergentes.atlassian.net/browse/AP-56) | Gestionar los contratos de los empleados | [AP-336](https://resolum-emergentes.atlassian.net/browse/AP-336) | Web empresa - Mostrar listado y detalle de contratos | Registrar contratos por horas o por servicio, renovar con historial y finalizar. | 3 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-337](https://resolum-emergentes.atlassian.net/browse/AP-337) | Web empresa - Registrar, editar, renovar o finalizar contratos | Alta, renovación y finalización. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-338](https://resolum-emergentes.atlassian.net/browse/AP-338) | Web empresa - Mostrar contratos incompatibles y servicios futuros afectados | Rechazar solapamientos y controlar finalización con servicios futuros. | 3 | Dayro Richard Rios Piñan | Finalizada |
| [US-45](https://resolum-emergentes.atlassian.net/browse/AP-57) | Configurar los horarios laborales de los empleados | [AP-339](https://resolum-emergentes.atlassian.net/browse/AP-339) | Web empresa - Implementar CRUD y calendario de horarios laborales | Crear horarios con bloques, limitados a vigencia y servicios del contrato. | 6 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-340](https://resolum-emergentes.atlassian.net/browse/AP-340) | Web empresa - Configurar días, bloques y vigencia del horario | Configuración y edición. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-341](https://resolum-emergentes.atlassian.net/browse/AP-341) | Web empresa - Mostrar superposiciones, límites contractuales y reservas afectadas | Rechazar superposiciones y reducciones con servicios reservados. | 3 | Dayro Richard Rios Piñan | Finalizada |
| [US-46](https://resolum-emergentes.atlassian.net/browse/AP-58) | Consultar la disponibilidad laboral de los empleados | [AP-342](https://resolum-emergentes.atlassian.net/browse/AP-342) | Web empresa - Mostrar disponibilidad semanal y mensual | Bloques disponibles, reservados y fuera de horario. | 3 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-343](https://resolum-emergentes.atlassian.net/browse/AP-343) | Web empresa - Filtrar empleados elegibles | Calendario con filtros. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-344](https://resolum-emergentes.atlassian.net/browse/AP-344) | Web empresa - Diferenciar disponibilidad, reservas y capacidad conjunta | Excluir inactivos, sin contrato o sin horario y sumar capacidad equivalente. | 4 | Dayro Richard Rios Piñan | Finalizada |
| [TS-01](https://resolum-emergentes.atlassian.net/browse/AP-59) | Registro de cuenta y verificación mediante enlace | [AP-345](https://resolum-emergentes.atlassian.net/browse/AP-345) | Backend IAM - Generar y validar enlace temporal de verificación | Sin descripción registrada en Jira. | 4 | Matias D. | Finalizada |
|  |  | [AP-347](https://resolum-emergentes.atlassian.net/browse/AP-347) | Backend IAM - Exponer endpoint de registro de cuenta | Sin descripción registrada en Jira. | 4 | Matias D. | Finalizada |
|  |  | [AP-348](https://resolum-emergentes.atlassian.net/browse/AP-348) | Backend IAM - Gestionar vencimiento e idempotencia de la verificación | Sin descripción registrada en Jira. | 4 | Matias D. | Finalizada |
| [TS-02](https://resolum-emergentes.atlassian.net/browse/AP-60) | Reenvío del enlace de verificación | [AP-346](https://resolum-emergentes.atlassian.net/browse/AP-346) | Backend IAM - Exponer endpoint de reenvío de verificación | Sin descripción registrada en Jira. | 4 | Matias D. | Finalizada |
|  |  | [AP-349](https://resolum-emergentes.atlassian.net/browse/AP-349) | Backend IAM - Limitar reenvíos sin revelar cuentas existentes | Sin descripción registrada en Jira. | 4 | Matias D. | Finalizada |
|  |  | [AP-352](https://resolum-emergentes.atlassian.net/browse/AP-352) | Backend IAM - Invalidar enlaces anteriores y emitir uno nuevo | Sin descripción registrada en Jira. | 4 | Matias D. | Finalizada |
| [TS-03](https://resolum-emergentes.atlassian.net/browse/AP-61) | Autenticación y emisión de token de acceso | [AP-350](https://resolum-emergentes.atlassian.net/browse/AP-350) | Backend IAM - Exponer endpoint de inicio de sesión | Sin descripción registrada en Jira. | 4 | Matias D. | Finalizada |
|  |  | [AP-351](https://resolum-emergentes.atlassian.net/browse/AP-351) | Backend IAM - Emitir token de acceso con capacidades autorizadas | Sin descripción registrada en Jira. | 4 | Matias D. | Finalizada |
|  |  | [AP-353](https://resolum-emergentes.atlassian.net/browse/AP-353) | Backend IAM - Gestionar rechazo de acceso y cierre de sesión | Sin descripción registrada en Jira. | 4 | Matias D. | Finalizada |
| [TS-04](https://resolum-emergentes.atlassian.net/browse/AP-62) | Gestión de hogares, perfiles y membresías de cuidado | [AP-354](https://resolum-emergentes.atlassian.net/browse/AP-354) | Backend Asistencia Médica - Exponer endpoints de personas asistidas y cuidadores | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | Finalizada |
|  |  | [AP-355](https://resolum-emergentes.atlassian.net/browse/AP-355) | Backend - Aplicar autorización por hogar y responsabilidad | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | Finalizada |
|  |  | [AP-356](https://resolum-emergentes.atlassian.net/browse/AP-356) | Backend Perfiles - Exponer endpoints de perfiles personales y hogares | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | Finalizada |
| [TS-05](https://resolum-emergentes.atlassian.net/browse/AP-63) | Consulta y administración de planes | [AP-357](https://resolum-emergentes.atlassian.net/browse/AP-357) | Backend Suscripciones - Exponer administración de planes y condiciones | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-358](https://resolum-emergentes.atlassian.net/browse/AP-358) | Backend Suscripciones - Retirar planes conservando contrataciones existentes | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-359](https://resolum-emergentes.atlassian.net/browse/AP-359) | Backend Suscripciones - Exponer consulta de planes vigentes | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
| [TS-06](https://resolum-emergentes.atlassian.net/browse/AP-64) | Preautorización de pago y contratación asociada con el hogar | [AP-360](https://resolum-emergentes.atlassian.net/browse/AP-360) | Backend Suscripciones - Crear preautorización asociada al hogar | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-361](https://resolum-emergentes.atlassian.net/browse/AP-361) | Backend Suscripciones - Consultar estado de preautorización y contratación | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-362](https://resolum-emergentes.atlassian.net/browse/AP-362) | Backend Suscripciones - Evitar activación antes de la evaluación técnica | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
| [TS-07](https://resolum-emergentes.atlassian.net/browse/AP-65) | Captura o liberación del importe | [AP-363](https://resolum-emergentes.atlassian.net/browse/AP-363) | Backend Suscripciones - Capturar o ajustar el importe autorizado | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-364](https://resolum-emergentes.atlassian.net/browse/AP-364) | Backend Suscripciones - Liberar el importe retenido | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-368](https://resolum-emergentes.atlassian.net/browse/AP-368) | Backend Suscripciones - Exponer el resultado económico de la contratación | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
| [TS-08](https://resolum-emergentes.atlassian.net/browse/AP-66) | Gestión de órdenes, disponibilidad y asignación técnica | [AP-365](https://resolum-emergentes.atlassian.net/browse/AP-365) | Backend Operaciones Técnicas - Asignar y reasignar técnicos elegibles | Sin descripción registrada en Jira. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-366](https://resolum-emergentes.atlassian.net/browse/AP-366) | Backend Operaciones Técnicas - Exponer disponibilidad y reserva de bloques | Sin descripción registrada en Jira. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-367](https://resolum-emergentes.atlassian.net/browse/AP-367) | Backend Operaciones Técnicas - Crear y gestionar órdenes técnicas | Sin descripción registrada en Jira. | 4 | Farid Coronel | Finalizada |
| [TS-09](https://resolum-emergentes.atlassian.net/browse/AP-67) | Registro y finalización de instalación | [AP-369](https://resolum-emergentes.atlassian.net/browse/AP-369) | Backend Operaciones Técnicas - Registrar inicio y avance de instalación | Sin descripción registrada en Jira. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-370](https://resolum-emergentes.atlassian.net/browse/AP-370) | Backend Operaciones Técnicas - Registrar conformidad y finalizar instalación | Sin descripción registrada en Jira. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-372](https://resolum-emergentes.atlassian.net/browse/AP-372) | Backend Activos - Registrar dispositivos y comprobaciones instaladas | Sin descripción registrada en Jira. | 4 | Farid Coronel | Finalizada |
| [TS-10](https://resolum-emergentes.atlassian.net/browse/AP-68) | Gestión y asignación de dispositivos | [AP-371](https://resolum-emergentes.atlassian.net/browse/AP-371) | Backend Activos - Registrar dispositivos mediante alias y MAC | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | Finalizada |
|  |  | [AP-373](https://resolum-emergentes.atlassian.net/browse/AP-373) | Backend Activos - Desasignar dispositivos conservando trazabilidad | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | Finalizada |
|  |  | [AP-376](https://resolum-emergentes.atlassian.net/browse/AP-376) | Backend Activos - Clasificar y asignar dispositivos al hogar | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | Finalizada |
| [TS-11](https://resolum-emergentes.atlassian.net/browse/AP-69) | Consulta del estado de dispositivos | [AP-374](https://resolum-emergentes.atlassian.net/browse/AP-374) | Backend Seguimiento - Exponer historial de dispositivos | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-375](https://resolum-emergentes.atlassian.net/browse/AP-375) | Backend Seguimiento - Exponer estado actual y último estado conocido | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-378](https://resolum-emergentes.atlassian.net/browse/AP-378) | Backend Seguimiento - Informar desconexión y fecha de actualización | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [TS-14](https://resolum-emergentes.atlassian.net/browse/AP-72) | Gestión de agenda, rutinas y tareas | [AP-383](https://resolum-emergentes.atlassian.net/browse/AP-383) | Backend Asistencia Médica - Exponer CRUD de actividades de cuidado | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-385](https://resolum-emergentes.atlassian.net/browse/AP-385) | Backend Asistencia Médica - Asignar responsables y consultar agenda | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-386](https://resolum-emergentes.atlassian.net/browse/AP-386) | Backend Asistencia Médica - Registrar resultados y actividades vencidas | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [TS-15](https://resolum-emergentes.atlassian.net/browse/AP-73) | Gestión de medicamentos y recordatorios | [AP-387](https://resolum-emergentes.atlassian.net/browse/AP-387) | Backend Asistencia Médica - Exponer programación de medicamentos | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-388](https://resolum-emergentes.atlassian.net/browse/AP-388) | Backend Asistencia Médica - Actualizar o suspender programaciones | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-389](https://resolum-emergentes.atlassian.net/browse/AP-389) | Backend Asistencia Médica - Generar recordatorios y registrar administración | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [TS-16](https://resolum-emergentes.atlassian.net/browse/AP-74) | Gestión de turnos y relevos | [AP-390](https://resolum-emergentes.atlassian.net/browse/AP-390) | Backend Asistencia Médica - Exponer gestión de turnos | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-391](https://resolum-emergentes.atlassian.net/browse/AP-391) | Backend Asistencia Médica - Validar superposiciones y responsable activo | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-392](https://resolum-emergentes.atlassian.net/browse/AP-392) | Backend Asistencia Médica - Gestionar relevos y sustituciones | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [TS-17](https://resolum-emergentes.atlassian.net/browse/AP-75) | Notas y resumen de continuidad | [AP-393](https://resolum-emergentes.atlassian.net/browse/AP-393) | Backend Asistencia Médica - Registrar notas de continuidad | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-394](https://resolum-emergentes.atlassian.net/browse/AP-394) | Backend Asistencia Médica - Autorizar consulta del resumen por hogar | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-396](https://resolum-emergentes.atlassian.net/browse/AP-396) | Backend Asistencia Médica - Generar resumen de atendidos y pendientes | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [TS-18](https://resolum-emergentes.atlassian.net/browse/AP-76) | Gestión de incidencias, mantenimiento y programación de visitas | [AP-395](https://resolum-emergentes.atlassian.net/browse/AP-395) | Backend Soporte Técnico - Registrar incidencias y evidencias | Sin descripción registrada en Jira. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-397](https://resolum-emergentes.atlassian.net/browse/AP-397) | Backend Soporte Técnico - Evitar incidencias duplicadas y programar visitas | Sin descripción registrada en Jira. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-398](https://resolum-emergentes.atlassian.net/browse/AP-398) | Backend Soporte Técnico - Registrar diagnóstico, mantenimiento y resolución | Sin descripción registrada en Jira. | 4 | Farid Coronel | Finalizada |
| [TS-19](https://resolum-emergentes.atlassian.net/browse/AP-77) | Registro seguro del medio de pago en la aplicación web | [AP-399](https://resolum-emergentes.atlassian.net/browse/AP-399) | Backend Suscripciones - Exponer parámetros para Stripe Elements | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-400](https://resolum-emergentes.atlassian.net/browse/AP-400) | Backend Suscripciones - Preparar autorización segura de pago | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-401](https://resolum-emergentes.atlassian.net/browse/AP-401) | Backend Suscripciones - Evitar almacenamiento de datos sensibles de tarjeta | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
| [TS-20](https://resolum-emergentes.atlassian.net/browse/AP-78) | Orquestación backend de pagos con Stripe | [AP-402](https://resolum-emergentes.atlassian.net/browse/AP-402) | Backend Suscripciones - Crear preautorizaciones mediante Stripe | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-403](https://resolum-emergentes.atlassian.net/browse/AP-403) | Backend Suscripciones - Capturar, ajustar o liberar importes | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-405](https://resolum-emergentes.atlassian.net/browse/AP-405) | Backend Suscripciones - Consultar y registrar operaciones de pago | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
| [TS-21](https://resolum-emergentes.atlassian.net/browse/AP-79) | Procesamiento de webhooks de Stripe | [AP-404](https://resolum-emergentes.atlassian.net/browse/AP-404) | Backend Suscripciones - Exponer webhook seguro de Stripe | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-406](https://resolum-emergentes.atlassian.net/browse/AP-406) | Backend Suscripciones - Validar firma y procesar eventos idempotentemente | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-407](https://resolum-emergentes.atlassian.net/browse/AP-407) | Backend Suscripciones - Sincronizar estados de pagos y suscripciones | Sin descripción registrada en Jira. | 6 | Dayro Richard Rios Piñan | Finalizada |
| [TS-22](https://resolum-emergentes.atlassian.net/browse/AP-80) | Integración web con Google Maps para el perfil del hogar | [AP-408](https://resolum-emergentes.atlassian.net/browse/AP-408) | Backend Perfiles - Entregar datos normalizados para servicios técnicos | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-409](https://resolum-emergentes.atlassian.net/browse/AP-409) | Backend Perfiles - Exponer búsqueda y selección de ubicación verificable | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-410](https://resolum-emergentes.atlassian.net/browse/AP-410) | Backend Perfiles - Exponer configuración de ubicación para la Web | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
| [TS-23](https://resolum-emergentes.atlassian.net/browse/AP-81) | Validación backend de ubicaciones del hogar con Google Maps | [AP-411](https://resolum-emergentes.atlassian.net/browse/AP-411) | Backend Perfiles - Normalizar dirección, distrito y referencia | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-412](https://resolum-emergentes.atlassian.net/browse/AP-412) | Backend Perfiles - Validar placeId y coordenadas con Google Maps | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-413](https://resolum-emergentes.atlassian.net/browse/AP-413) | Backend Perfiles - Verificar cobertura y registrar cambios de ubicación | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
| [TS-27](https://resolum-emergentes.atlassian.net/browse/AP-85) | Integración cliente con Cloudinary | [AP-423](https://resolum-emergentes.atlassian.net/browse/AP-423) | Backend Recursos - Exponer autorización firmada de carga | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | Finalizada |
|  |  | [AP-424](https://resolum-emergentes.atlassian.net/browse/AP-424) | Backend Recursos - Registrar referencia de fotografía cargada | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | Finalizada |
|  |  | [AP-425](https://resolum-emergentes.atlassian.net/browse/AP-425) | Backend Recursos - Validar tipo, tamaño y propietario del recurso | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | Finalizada |
| [TS-28](https://resolum-emergentes.atlassian.net/browse/AP-86) | Consulta de agenda y recordatorios | [AP-426](https://resolum-emergentes.atlassian.net/browse/AP-426) | Backend Asistencia Médica - Exponer agenda por cuidador y periodo | Sin descripción registrada en Jira. | 4 | Matias D. | Finalizada |
|  |  | [AP-427](https://resolum-emergentes.atlassian.net/browse/AP-427) | Backend Asistencia Médica - Filtrar agenda por persona, estado y prioridad | Sin descripción registrada en Jira. | 4 | Matias D. | Finalizada |
|  |  | [AP-429](https://resolum-emergentes.atlassian.net/browse/AP-429) | Backend Asistencia Médica - Exponer recordatorios vigentes | Sin descripción registrada en Jira. | 4 | Matias D. | Finalizada |
| [TS-29](https://resolum-emergentes.atlassian.net/browse/AP-87) | Registro del resultado de una administración de medicamento | [AP-428](https://resolum-emergentes.atlassian.net/browse/AP-428) | Backend Asistencia Médica - Registrar resultado atendido u omitido | Sin descripción registrada en Jira. | 4 | Matias D. | Finalizada |
|  |  | [AP-430](https://resolum-emergentes.atlassian.net/browse/AP-430) | Backend Asistencia Médica - Consultar administración programada | Sin descripción registrada en Jira. | 4 | Matias D. | Finalizada |
|  |  | [AP-434](https://resolum-emergentes.atlassian.net/browse/AP-434) | Backend Asistencia Médica - Evitar duplicados e identificar registro tardío | Sin descripción registrada en Jira. | 4 | Matias D. | Finalizada |
| [TS-30](https://resolum-emergentes.atlassian.net/browse/AP-88) | Consulta y gestión de suscripciones asociadas con hogares | [AP-431](https://resolum-emergentes.atlassian.net/browse/AP-431) | Backend Suscripciones - Exponer detalle y estado de suscripción | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-432](https://resolum-emergentes.atlassian.net/browse/AP-432) | Backend Suscripciones - Gestionar cambio, suspensión y reactivación | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-433](https://resolum-emergentes.atlassian.net/browse/AP-433) | Backend Suscripciones - Exponer pagos e historial de cambios | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
| [TS-31](https://resolum-emergentes.atlassian.net/browse/AP-89) | Consulta de métricas de ventas | [AP-435](https://resolum-emergentes.atlassian.net/browse/AP-435) | Backend Analíticas - Comparar periodos y devolver estado sin resultados | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-436](https://resolum-emergentes.atlassian.net/browse/AP-436) | Backend Analíticas - Desglosar ventas por plan y periodicidad | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-438](https://resolum-emergentes.atlassian.net/browse/AP-438) | Backend Analíticas - Exponer métricas de ventas por periodo | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
| [TS-32](https://resolum-emergentes.atlassian.net/browse/AP-90) | Consulta de métricas globales del negocio | [AP-437](https://resolum-emergentes.atlassian.net/browse/AP-437) | Backend Analíticas - Exponer resumen global del negocio | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-440](https://resolum-emergentes.atlassian.net/browse/AP-440) | Backend Analíticas - Aplicar filtros y desglose de indicadores | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-441](https://resolum-emergentes.atlassian.net/browse/AP-441) | Backend Analíticas - Restringir consulta al administrador autorizado | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
| [TS-33](https://resolum-emergentes.atlassian.net/browse/AP-91) | Consulta de métricas de autonomía y acciones | [AP-439](https://resolum-emergentes.atlassian.net/browse/AP-439) | Backend Analíticas - Exponer métricas de autonomía por dispositivo | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-442](https://resolum-emergentes.atlassian.net/browse/AP-442) | Backend Analíticas - Incorporar eventos offline de forma idempotente | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-443](https://resolum-emergentes.atlassian.net/browse/AP-443) | Backend Analíticas - Proteger audio y mostrar última sincronización | Sin descripción registrada en Jira. | 3 | Renato Calvo Yalan | To-Do |
| [TS-34](https://resolum-emergentes.atlassian.net/browse/AP-92) | Implementar la gestión de empleados | [AP-444](https://resolum-emergentes.atlassian.net/browse/AP-444) | Backend Capital Humano - Exponer CRUD de empleados | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-445](https://resolum-emergentes.atlassian.net/browse/AP-445) | Backend Capital Humano - Validar documento y correo duplicados | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-446](https://resolum-emergentes.atlassian.net/browse/AP-446) | Backend Capital Humano - Gestionar desactivación y órdenes futuras | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
| [TS-35](https://resolum-emergentes.atlassian.net/browse/AP-93) | Implementar la gestión de contratos laborales | [AP-447](https://resolum-emergentes.atlassian.net/browse/AP-447) | Backend Capital Humano - Validar vigencia y contratos incompatibles | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-448](https://resolum-emergentes.atlassian.net/browse/AP-448) | Backend Capital Humano - Exponer CRUD de contratos laborales | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-450](https://resolum-emergentes.atlassian.net/browse/AP-450) | Backend Capital Humano - Gestionar renovación, finalización e historial | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
| [TS-36](https://resolum-emergentes.atlassian.net/browse/AP-94) | Implementar horarios y disponibilidad laboral | [AP-449](https://resolum-emergentes.atlassian.net/browse/AP-449) | Backend Capital Humano - Exponer CRUD de horarios laborales | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-451](https://resolum-emergentes.atlassian.net/browse/AP-451) | Backend Capital Humano - Calcular disponibilidad descontando reservas | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
|  |  | [AP-452](https://resolum-emergentes.atlassian.net/browse/AP-452) | Backend Capital Humano - Generar bloques y validar superposiciones | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | Finalizada |
| [TS-37](https://resolum-emergentes.atlassian.net/browse/AP-95) | Desarrollo móvil nativo para Android e iOS | [AP-453](https://resolum-emergentes.atlassian.net/browse/AP-453) | iOS - Configurar arquitectura nativa con Swift | Sin descripción registrada en Jira. | 4 | Farid Coronel | Finalizada |
|  |  | [AP-454](https://resolum-emergentes.atlassian.net/browse/AP-454) | Mobile - Incorporar accesibilidad y notificaciones nativas | Sin descripción registrada en Jira. | 4 | Oscar Javier Armas Sanchez | Finalizada |
|  |  | [AP-456](https://resolum-emergentes.atlassian.net/browse/AP-456) | Android - Configurar arquitectura nativa con Kotlin | Sin descripción registrada en Jira. | 4 | Oscar Javier Armas Sanchez | Finalizada |
| [TS-38](https://resolum-emergentes.atlassian.net/browse/AP-96) | Integración cliente con Cloudinary | [AP-455](https://resolum-emergentes.atlassian.net/browse/AP-455) | Web y Mobile - Implementar carga firmada hacia Cloudinary | Sin descripción registrada en Jira. | 6 | Renato Calvo Yalan | To-Do |
|  |  | [AP-457](https://resolum-emergentes.atlassian.net/browse/AP-457) | Web y Mobile - Gestionar progreso y errores de carga | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-458](https://resolum-emergentes.atlassian.net/browse/AP-458) | Web y Mobile - Registrar la referencia del recurso cargado | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
| [TS-39](https://resolum-emergentes.atlassian.net/browse/AP-97) | Administración backend de recursos en Cloudinary | [AP-459](https://resolum-emergentes.atlassian.net/browse/AP-459) | Backend Recursos - Eliminar recursos mediante storageKey | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-460](https://resolum-emergentes.atlassian.net/browse/AP-460) | Backend Recursos - Autorizar y registrar recursos de Cloudinary | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-462](https://resolum-emergentes.atlassian.net/browse/AP-462) | Backend Recursos - Validar propiedad y referencias activas | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
| [TS-40](https://resolum-emergentes.atlassian.net/browse/AP-98) | Adopción de Spring Boot como framework backend sin costo de licenciamiento | [AP-461](https://resolum-emergentes.atlassian.net/browse/AP-461) | Backend - Implementar OpenAPI y manejo global de errores | Sin descripción registrada en Jira. | 6 | Nicolás Juárez | Finalizada |
|  |  | [AP-463](https://resolum-emergentes.atlassian.net/browse/AP-463) | Backend - Configurar pruebas base y observabilidad | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | Finalizada |
|  |  | [AP-464](https://resolum-emergentes.atlassian.net/browse/AP-464) | Backend - Configurar módulos y perfiles de Spring Boot | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | Finalizada |
| [TS-41](https://resolum-emergentes.atlassian.net/browse/AP-99) | Despliegue de servicios y cargas de trabajo en Microsoft Azure | [AP-465](https://resolum-emergentes.atlassian.net/browse/AP-465) | DevOps - Desplegar API y configurar el acceso al servicio en Azure | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-466](https://resolum-emergentes.atlassian.net/browse/AP-466) | DevOps - Gestionar secretos, configuración y verificación del despliegue | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-468](https://resolum-emergentes.atlassian.net/browse/AP-468) | DevOps - Preparar infraestructura en Microsoft Azure | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
| [TS-42](https://resolum-emergentes.atlassian.net/browse/AP-100) | Ajuste arquitectural y cuotas de consumo ante recursos económicos limitados | [AP-467](https://resolum-emergentes.atlassian.net/browse/AP-467) | Arquitectura - Definir cuotas y límites de consumo | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | Finalizada |
|  |  | [AP-469](https://resolum-emergentes.atlassian.net/browse/AP-469) | DevOps - Configurar alertas de recursos y almacenamiento | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | Finalizada |
|  |  | [AP-472](https://resolum-emergentes.atlassian.net/browse/AP-472) | Arquitectura - Documentar estrategia de bajo costo y escalamiento | Sin descripción registrada en Jira. | 3 | Nicolás Juárez | Finalizada |
| [TS-43](https://resolum-emergentes.atlassian.net/browse/AP-101) | Operación offline y cobertura de conectividad Bluetooth para actuadores | [AP-470](https://resolum-emergentes.atlassian.net/browse/AP-470) | Edge - Implementar canal alternativo BLE para actuadores | Sin descripción registrada en Jira. | 6 | Renato Calvo Yalan | To-Do |
|  |  | [AP-471](https://resolum-emergentes.atlassian.net/browse/AP-471) | Edge - Gestionar conmutación y reconexión del canal local | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-473](https://resolum-emergentes.atlassian.net/browse/AP-473) | Edge - Validar alcance y cobertura de comunicación BLE | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
| [TS-44](https://resolum-emergentes.atlassian.net/browse/AP-102) | Alcance de hardware acotado a prototipo funcional de dispositivo IoT | [AP-474](https://resolum-emergentes.atlassian.net/browse/AP-474) | Hardware - Seleccionar placas y componentes del prototipo | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-475](https://resolum-emergentes.atlassian.net/browse/AP-475) | Hardware - Validar funciones y documentar exclusiones de producción | Sin descripción registrada en Jira. | 3 | Renato Calvo Yalan | To-Do |
|  |  | [AP-476](https://resolum-emergentes.atlassian.net/browse/AP-476) | Hardware - Ensamblar y documentar conexiones del prototipo | Sin descripción registrada en Jira. | 3 | Renato Calvo Yalan | To-Do |
| [TS-45](https://resolum-emergentes.atlassian.net/browse/AP-103) | Reconocimiento de voz calibrado para espacio acústicamente controlado | [AP-477](https://resolum-emergentes.atlassian.net/browse/AP-477) | Edge IA - Calibrar captura y umbrales de voz | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-478](https://resolum-emergentes.atlassian.net/browse/AP-478) | Edge IA - Definir condiciones acústicas de prueba | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-479](https://resolum-emergentes.atlassian.net/browse/AP-479) | Edge IA - Medir precisión y documentar limitaciones ambientales | Sin descripción registrada en Jira. | 3 | Renato Calvo Yalan | To-Do |
| [TS-46](https://resolum-emergentes.atlassian.net/browse/AP-104) | Persistencia transaccional y relacional de datos en PostgreSQL | [AP-480](https://resolum-emergentes.atlassian.net/browse/AP-480) | Backend - Configurar PostgreSQL y migraciones versionadas | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | Finalizada |
|  |  | [AP-482](https://resolum-emergentes.atlassian.net/browse/AP-482) | Backend - Definir constraints, índices y transacciones | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | Finalizada |
|  |  | [AP-483](https://resolum-emergentes.atlassian.net/browse/AP-483) | DevOps - Implementar respaldo y restauración de PostgreSQL | Sin descripción registrada en Jira. | 6 | Nicolás Juárez | Finalizada |
| [TS-47](https://resolum-emergentes.atlassian.net/browse/AP-105) | Persistencia de telemetría y datos no estructurados en MongoDB | [AP-481](https://resolum-emergentes.atlassian.net/browse/AP-481) | Backend Seguimiento - Definir colecciones e índices MongoDB | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-484](https://resolum-emergentes.atlassian.net/browse/AP-484) | Backend Seguimiento - Persistir telemetría y eventos IoT | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-485](https://resolum-emergentes.atlassian.net/browse/AP-485) | Backend Seguimiento - Consultar telemetría por dispositivo y periodo | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
| [TS-48](https://resolum-emergentes.atlassian.net/browse/AP-106) | Reconocimiento local de comandos de voz integrado en el Edge | [AP-486](https://resolum-emergentes.atlassian.net/browse/AP-486) | Edge IA - Validar latencia y consumo durante la inferencia | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-487](https://resolum-emergentes.atlassian.net/browse/AP-487) | Edge IA - Comprobar reconocimiento sin Internet ni servicio externo | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-488](https://resolum-emergentes.atlassian.net/browse/AP-488) | Edge IA - Integrar inferencia local en el Edge de voz | Sin descripción registrada en Jira. | 6 | Nicolás Juárez | To-Do |
| [TS-49](https://resolum-emergentes.atlassian.net/browse/AP-107) | Asociación de intenciones con acciones físicas | [AP-489](https://resolum-emergentes.atlassian.net/browse/AP-489) | Edge voz - Resolver dispositivo objetivo y validar disponibilidad | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-490](https://resolum-emergentes.atlassian.net/browse/AP-490) | Edge voz - Definir catálogo de intenciones y acciones soportadas | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-491](https://resolum-emergentes.atlassian.net/browse/AP-491) | Edge voz - Rechazar intenciones ambiguas o no autorizadas | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [TS-50](https://resolum-emergentes.atlassian.net/browse/AP-108) | Publicación de comandos en el broker MQTT local | [AP-492](https://resolum-emergentes.atlassian.net/browse/AP-492) | Edge voz - Definir payload MQTT con commandId | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-493](https://resolum-emergentes.atlassian.net/browse/AP-493) | Edge voz - Publicar comandos en topics locales autorizados | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-494](https://resolum-emergentes.atlassian.net/browse/AP-494) | Edge voz - Gestionar confirmación, timeout y error de publicación | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [TS-51](https://resolum-emergentes.atlassian.net/browse/AP-109) | Recepción de resultados y estados mediante el broker MQTT | [AP-495](https://resolum-emergentes.atlassian.net/browse/AP-495) | Edge voz - Suscribirse a resultados y estados MQTT | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-496](https://resolum-emergentes.atlassian.net/browse/AP-496) | Edge voz - Correlacionar resultados mediante commandId | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-498](https://resolum-emergentes.atlassian.net/browse/AP-498) | Edge voz - Actualizar estado e informar éxito o falla | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [TS-52](https://resolum-emergentes.atlassian.net/browse/AP-110) | Retroalimentación audible de las solicitudes de voz | [AP-497](https://resolum-emergentes.atlassian.net/browse/AP-497) | Edge voz - Definir mensajes audibles del sistema | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-499](https://resolum-emergentes.atlassian.net/browse/AP-499) | Edge voz - Reproducir confirmación después del resultado físico | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-500](https://resolum-emergentes.atlassian.net/browse/AP-500) | Edge voz - Comunicar fallas y solicitudes de repetición | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [TS-53](https://resolum-emergentes.atlassian.net/browse/AP-111) | Operación local y almacenamiento de eventos sin Internet | [AP-501](https://resolum-emergentes.atlassian.net/browse/AP-501) | Edge voz - Configurar persistencia local SQLite | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-502](https://resolum-emergentes.atlassian.net/browse/AP-502) | Edge voz - Aplicar límites y limpieza controlada del almacenamiento | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-504](https://resolum-emergentes.atlassian.net/browse/AP-504) | Edge voz - Mantener cola de eventos pendientes sin Internet | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [TS-54](https://resolum-emergentes.atlassian.net/browse/AP-112) | Sincronización de eventos pendientes con el backend | [AP-503](https://resolum-emergentes.atlassian.net/browse/AP-503) | Edge voz - Enviar eventos pendientes en lotes al backend | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-505](https://resolum-emergentes.atlassian.net/browse/AP-505) | Edge voz - Marcar eventos confirmados como sincronizados | Sin descripción registrada en Jira. | 6 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-508](https://resolum-emergentes.atlassian.net/browse/AP-508) | Edge voz - Gestionar idempotencia y reintentos de sincronización | Sin descripción registrada en Jira. | 6 | Dayro Richard Rios Piñan | To-Do |
| [TS-55](https://resolum-emergentes.atlassian.net/browse/AP-113) | Sincronización de estados y diagnósticos | [AP-506](https://resolum-emergentes.atlassian.net/browse/AP-506) | Edge voz - Generar heartbeat y reporte periódico | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-507](https://resolum-emergentes.atlassian.net/browse/AP-507) | Edge voz - Recopilar estados y diagnósticos locales | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-509](https://resolum-emergentes.atlassian.net/browse/AP-509) | Edge voz - Sincronizar batería, conectividad y fallas con backend | Sin descripción registrada en Jira. | 6 | Dayro Richard Rios Piñan | To-Do |
| [TS-56](https://resolum-emergentes.atlassian.net/browse/AP-114) | Gestión local de fallas y recuperación controlada | [AP-510](https://resolum-emergentes.atlassian.net/browse/AP-510) | Edge voz - Clasificar errores locales por componente | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-511](https://resolum-emergentes.atlassian.net/browse/AP-511) | Edge voz - Aislar fallas y ejecutar recuperación controlada | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-512](https://resolum-emergentes.atlassian.net/browse/AP-512) | Edge voz - Conservar diagnóstico trazable sin detener otras funciones | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [TS-57](https://resolum-emergentes.atlassian.net/browse/AP-115) | Recepción local de audio desde el dispositivo embebido | [AP-513](https://resolum-emergentes.atlassian.net/browse/AP-513) | Edge voz - Exponer POST /edge/v1/audio-captures | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-514](https://resolum-emergentes.atlassian.net/browse/AP-514) | Edge voz - Validar formato, tamaño y origen de la captura | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-515](https://resolum-emergentes.atlassian.net/browse/AP-515) | Edge voz - Entregar audio temporal al pipeline de inferencia | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [TS-58](https://resolum-emergentes.atlassian.net/browse/AP-116) | Integración local del modelo seleccionado en el Edge | [AP-516](https://resolum-emergentes.atlassian.net/browse/AP-516) | Edge IA - Cargar e integrar el artefacto del modelo | Sin descripción registrada en Jira. | 6 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-517](https://resolum-emergentes.atlassian.net/browse/AP-517) | Edge IA - Controlar consumo y fallas durante la inferencia | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-520](https://resolum-emergentes.atlassian.net/browse/AP-520) | Edge IA - Implementar inferencia local y mapear su salida | Sin descripción registrada en Jira. | 6 | Dayro Richard Rios Piñan | To-Do |
| [TS-59](https://resolum-emergentes.atlassian.net/browse/AP-117) | Captura y preprocesamiento local del audio | [AP-518](https://resolum-emergentes.atlassian.net/browse/AP-518) | Edge IA - Normalizar y convertir el formato de audio | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-519](https://resolum-emergentes.atlassian.net/browse/AP-519) | Edge IA - Eliminar silencios y reducir ruido | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-521](https://resolum-emergentes.atlassian.net/browse/AP-521) | Edge IA - Rechazar muestras incompatibles o de baja calidad | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [TS-60](https://resolum-emergentes.atlassian.net/browse/AP-118) | Validación segura de la predicción del modelo | [AP-522](https://resolum-emergentes.atlassian.net/browse/AP-522) | Edge IA - Bloquear predicciones ambiguas y solicitar repetición | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-523](https://resolum-emergentes.atlassian.net/browse/AP-523) | Edge IA - Definir umbral de confianza por intención | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-524](https://resolum-emergentes.atlassian.net/browse/AP-524) | Edge IA - Validar intención soportada y dispositivo objetivo | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [TS-61](https://resolum-emergentes.atlassian.net/browse/AP-119) | Instalación del modelo seleccionado en el Edge | [AP-525](https://resolum-emergentes.atlassian.net/browse/AP-525) | Edge IA - Empaquetar y versionar el modelo seleccionado | Sin descripción registrada en Jira. | 6 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-526](https://resolum-emergentes.atlassian.net/browse/AP-526) | Edge IA - Instalar y verificar checksum del modelo | Sin descripción registrada en Jira. | 6 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-527](https://resolum-emergentes.atlassian.net/browse/AP-527) | Edge IA - Implementar rollback ante instalación fallida | Sin descripción registrada en Jira. | 6 | Dayro Richard Rios Piñan | To-Do |
| [TS-62](https://resolum-emergentes.atlassian.net/browse/AP-120) | Validación del modelo seleccionado en el Edge | [AP-528](https://resolum-emergentes.atlassian.net/browse/AP-528) | Edge IA - Medir precisión global y por clase | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-529](https://resolum-emergentes.atlassian.net/browse/AP-529) | Edge IA - Documentar falsos positivos y criterios de aceptación | Sin descripción registrada en Jira. | 3 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-530](https://resolum-emergentes.atlassian.net/browse/AP-530) | Edge IA - Medir latencia y consumo en el Edge | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [TS-63](https://resolum-emergentes.atlassian.net/browse/AP-121) | Recepción y validación de comandos desde el broker MQTT local | [AP-531](https://resolum-emergentes.atlassian.net/browse/AP-531) | Edge actuadores - Suscribirse a topics de comandos | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-532](https://resolum-emergentes.atlassian.net/browse/AP-532) | Edge actuadores - Validar credenciales, payload y dispositivo | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-533](https://resolum-emergentes.atlassian.net/browse/AP-533) | Edge actuadores - Rechazar comandos inválidos o no autorizados | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
| [TS-64](https://resolum-emergentes.atlassian.net/browse/AP-122) | Ejecución segura de acciones físicas en actuadores | [AP-534](https://resolum-emergentes.atlassian.net/browse/AP-534) | Edge actuadores - Traducir comandos a instrucciones físicas | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-535](https://resolum-emergentes.atlassian.net/browse/AP-535) | Edge actuadores - Enviar instrucción al controlador embebido | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-536](https://resolum-emergentes.atlassian.net/browse/AP-536) | Edge actuadores - Aplicar timeout y mantener condición segura | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
| [TS-65](https://resolum-emergentes.atlassian.net/browse/AP-123) | Publicación del resultado de comandos físicos | [AP-537](https://resolum-emergentes.atlassian.net/browse/AP-537) | Edge actuadores - Construir resultado de ejecución | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-538](https://resolum-emergentes.atlassian.net/browse/AP-538) | Edge actuadores - Correlacionar resultado mediante commandId | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-539](https://resolum-emergentes.atlassian.net/browse/AP-539) | Edge actuadores - Publicar estado confirmado o diagnóstico de falla | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
| [TS-66](https://resolum-emergentes.atlassian.net/browse/AP-124) | Prevención de ejecuciones duplicadas | [AP-540](https://resolum-emergentes.atlassian.net/browse/AP-540) | Edge actuadores - Registrar commandId procesados | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-541](https://resolum-emergentes.atlassian.net/browse/AP-541) | Edge actuadores - Depurar registros de idempotencia vencidos | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-544](https://resolum-emergentes.atlassian.net/browse/AP-544) | Edge actuadores - Detectar reintentos y devolver resultado previo | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
| [TS-67](https://resolum-emergentes.atlassian.net/browse/AP-125) | Publicación local del estado y disponibilidad de actuadores | [AP-542](https://resolum-emergentes.atlassian.net/browse/AP-542) | Edge actuadores - Recopilar disponibilidad de controladores | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-543](https://resolum-emergentes.atlassian.net/browse/AP-543) | Edge actuadores - Publicar heartbeat y último estado confirmado | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-545](https://resolum-emergentes.atlassian.net/browse/AP-545) | Edge actuadores - Informar dispositivo desconocido o desconectado | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
| [TS-68](https://resolum-emergentes.atlassian.net/browse/AP-126) | Detección, aislamiento y recuperación de fallas de actuadores | [AP-546](https://resolum-emergentes.atlassian.net/browse/AP-546) | Edge actuadores - Aislar el actuador con falla | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-547](https://resolum-emergentes.atlassian.net/browse/AP-547) | Edge actuadores - Detectar timeout, desconexión y error físico | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-548](https://resolum-emergentes.atlassian.net/browse/AP-548) | Edge actuadores - Recuperar disponibles y publicar diagnóstico | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
| [TS-69](https://resolum-emergentes.atlassian.net/browse/AP-127) | Disponibilidad local del broker MQTT | [AP-549](https://resolum-emergentes.atlassian.net/browse/AP-549) | Broker - Configurar persistencia, inicio automático y healthcheck | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-550](https://resolum-emergentes.atlassian.net/browse/AP-550) | Broker - Instalar y configurar Mosquitto en la red local | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-551](https://resolum-emergentes.atlassian.net/browse/AP-551) | Broker - Validar funcionamiento local sin Internet | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
| [TS-70](https://resolum-emergentes.atlassian.net/browse/AP-128) | Enrutamiento local de comandos hacia el Edge de actuadores | [AP-552](https://resolum-emergentes.atlassian.net/browse/AP-552) | Broker - Definir jerarquía de topics para comandos | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-555](https://resolum-emergentes.atlassian.net/browse/AP-555) | Broker - Enrutar comandos del Edge de voz al Edge actuador | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-556](https://resolum-emergentes.atlassian.net/browse/AP-556) | Broker - Configurar QoS, retención y reglas de entrega | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
| [TS-71](https://resolum-emergentes.atlassian.net/browse/AP-129) | Enrutamiento de resultados y estados de actuadores | [AP-553](https://resolum-emergentes.atlassian.net/browse/AP-553) | Broker - Definir topics de resultados, estados y diagnósticos | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-554](https://resolum-emergentes.atlassian.net/browse/AP-554) | Broker - Configurar QoS y correlación de respuestas | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-558](https://resolum-emergentes.atlassian.net/browse/AP-558) | Broker - Enrutar respuestas sin comunicación directa entre Edges | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
| [TS-72](https://resolum-emergentes.atlassian.net/browse/AP-130) | Provisión segura de credenciales MQTT para los Edge | [AP-557](https://resolum-emergentes.atlassian.net/browse/AP-557) | Backend IAM - Exponer endpoint de aprovisionamiento MQTT | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-559](https://resolum-emergentes.atlassian.net/browse/AP-559) | Broker - Generar credenciales y ACL específicas por Edge | Sin descripción registrada en Jira. | 4 | Renato Calvo Yalan | To-Do |
|  |  | [AP-560](https://resolum-emergentes.atlassian.net/browse/AP-560) | Broker - Implementar rotación y revocación de credenciales | Sin descripción registrada en Jira. | 6 | Renato Calvo Yalan | To-Do |
| [DMS-01](https://resolum-emergentes.atlassian.net/browse/AP-131) | Inicialización y autodiagnóstico del módulo de interacción por voz | [AP-561](https://resolum-emergentes.atlassian.net/browse/AP-561) | Firmware voz - Inicializar microcontrolador y periféricos | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-562](https://resolum-emergentes.atlassian.net/browse/AP-562) | Firmware voz - Ejecutar autodiagnóstico de micrófono, altavoz y alimentación | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-563](https://resolum-emergentes.atlassian.net/browse/AP-563) | Firmware voz - Reportar fallas de arranque y conservar un estado seguro | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [DMS-02](https://resolum-emergentes.atlassian.net/browse/AP-132) | Captura de audio mediante micrófono | [AP-564](https://resolum-emergentes.atlassian.net/browse/AP-564) | Firmware voz - Configurar adquisición de audio del micrófono | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-565](https://resolum-emergentes.atlassian.net/browse/AP-565) | Firmware voz - Implementar muestreo y almacenamiento en búfer | Sin descripción registrada en Jira. | 6 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-566](https://resolum-emergentes.atlassian.net/browse/AP-566) | Firmware voz - Entregar capturas estables al Edge de interacción | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [DMS-03](https://resolum-emergentes.atlassian.net/browse/AP-133) | Reproducción de audio y comunicación de estados | [AP-567](https://resolum-emergentes.atlassian.net/browse/AP-567) | Firmware voz - Configurar salida de audio y amplificación | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-568](https://resolum-emergentes.atlassian.net/browse/AP-568) | Firmware voz - Reproducir confirmaciones y advertencias recibidas | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-569](https://resolum-emergentes.atlassian.net/browse/AP-569) | Firmware voz - Gestionar errores y estados de reproducción | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [DMS-04](https://resolum-emergentes.atlassian.net/browse/AP-134) | Comunicación del módulo de interacción con el componente Edge | [AP-570](https://resolum-emergentes.atlassian.net/browse/AP-570) | Firmware voz - Implementar interfaz local de comunicación con el Edge | Sin descripción registrada en Jira. | 6 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-571](https://resolum-emergentes.atlassian.net/browse/AP-571) | Firmware voz - Enviar capturas y eventos mediante el contrato definido | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-572](https://resolum-emergentes.atlassian.net/browse/AP-572) | Firmware voz - Recibir instrucciones y recuperar interrupciones de comunicación | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [DMS-05](https://resolum-emergentes.atlassian.net/browse/AP-135) | Supervisión de alimentación y batería de respaldo | [AP-573](https://resolum-emergentes.atlassian.net/browse/AP-573) | Firmware voz - Medir tensión y nivel de batería de respaldo | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-574](https://resolum-emergentes.atlassian.net/browse/AP-574) | Firmware voz - Reportar batería baja y estado de alimentación | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-575](https://resolum-emergentes.atlassian.net/browse/AP-575) | Firmware voz - Gestionar transición entre alimentación principal y batería | Sin descripción registrada en Jira. | 4 | Dayro Richard Rios Piñan | To-Do |
| [DMS-06](https://resolum-emergentes.atlassian.net/browse/AP-136) | Inicialización y comunicación del controlador de actuadores domésticos | [AP-576](https://resolum-emergentes.atlassian.net/browse/AP-576) | Firmware actuador - Inicializar GPIO, PWM, sensores y circuitos de potencia | Sin descripción registrada en Jira. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-577](https://resolum-emergentes.atlassian.net/browse/AP-577) | Firmware actuador - Recibir y validar instrucciones locales del Edge | Implementar en C++ la recepción de instrucciones del Edge de actuadores mediante el contrato HTTP local de DMS-06. Validar dispositivo y acción antes de dirigir la instrucción al controlador físico y devolver su resultado. Hecho cuando: una instrucción válida alcanza el actuador correspondiente; una acción o dispositivo no reconocido se rechaza con INVALID_DEVICE_COMMAND sin activar salidas. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-578](https://resolum-emergentes.atlassian.net/browse/AP-578) | Firmware actuador - Implementar watchdog y reinicio con salidas desactivadas | Implementar la supervisión del firmware C++ y la recuperación ante rutinas bloqueadas del controlador de actuadores. Hecho cuando: al vencer el watchdog se desactivan las salidas de potencia, se reinicia en condición segura y se registra WATCHDOG_RESET; el arranque conserva los actuadores desactivados y registra STARTUP_OK. | 6 | Nicolás Juárez | To-Do |
| [DMS-07](https://resolum-emergentes.atlassian.net/browse/AP-137) | Control eléctrico de la iluminación | [AP-579](https://resolum-emergentes.atlassian.net/browse/AP-579) | Firmware actuador - Implementar encendido y apagado de iluminación mediante GPIO | Implementar en C++ la conmutación del canal de iluminación mediante GPIO y el circuito de potencia definido para el prototipo. Hecho cuando: una instrucción de encendido activa la salida y una de apagado la desactiva, respetando la integridad eléctrica del ESP32. | 6 | Nicolás Juárez | To-Do |
|  |  | [AP-580](https://resolum-emergentes.atlassian.net/browse/AP-580) | Firmware actuador - Verificar y reportar el estado real de iluminación | Implementar la verificación del estado esperado del actuador de iluminación y su respuesta al Edge de actuadores. Hecho cuando: se reporta ACTION_COMPLETED únicamente al confirmar el estado; una instrucción que solicita el estado actual devuelve ese estado sin conmutar innecesariamente. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-581](https://resolum-emergentes.atlassian.net/browse/AP-581) | Firmware actuador - Detectar fallas de iluminación y aislar el canal | Implementar el temporizador de verificación y la gestión de discrepancias entre la salida GPIO y el estado esperado de iluminación. Hecho cuando: si vence el tiempo sin confirmación, se aísla el canal, se registra LIGHT_ACTUATOR_FAILURE y se informa al Edge sin confirmar falsamente la ejecución. | 4 | Nicolás Juárez | To-Do |
| [DMS-08](https://resolum-emergentes.atlassian.net/browse/AP-138) | Accionamiento seguro de la puerta | [AP-582](https://resolum-emergentes.atlassian.net/browse/AP-582) | Firmware actuador - Implementar apertura y cierre controlados de la puerta | Implementar en C++ el control del servo o actuador de la puerta y la supervisión de su posición durante el movimiento. Hecho cuando: con posición conocida y sensores operativos, una instrucción de apertura o cierre inicia el movimiento y lo detiene en el límite solicitado. | 6 | Nicolás Juárez | To-Do |
|  |  | [AP-583](https://resolum-emergentes.atlassian.net/browse/AP-583) | Firmware actuador - Gestionar finales de carrera y validar sensores de la puerta | Implementar la lectura de sensores y las interrupciones de final de carrera de la puerta. Hecho cuando: el final de carrera desactiva el servo y actualiza la posición confirmada; posiciones incompatibles bloquean acciones, conservan la condición segura y registran DOOR_POSITION_SENSOR_FAILURE. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-584](https://resolum-emergentes.atlassian.net/browse/AP-584) | Firmware actuador - Detectar atascos de la puerta y detener el movimiento | Implementar el temporizador de movimiento y la respuesta ante una puerta que no alcanza la posición solicitada. Hecho cuando: al vencer el tiempo configurado se detiene el actuador, se aplica la condición segura, se registra DOOR_OBSTRUCTION y se comunica el fallo al Edge de actuadores. | 4 | Nicolás Juárez | To-Do |
| [DMS-09](https://resolum-emergentes.atlassian.net/browse/AP-139) | Accionamiento seguro de la ventana | [AP-585](https://resolum-emergentes.atlassian.net/browse/AP-585) | Firmware actuador - Implementar apertura y cierre de la ventana con límites de posición | Implementar en C++ el movimiento del servo o actuador de la ventana y la supervisión de los sensores de límite. Hecho cuando: la ventana se desplaza hasta la posición solicitada; al activarse el límite se interrumpe la alimentación del actuador y se actualiza el estado confirmado. | 6 | Nicolás Juárez | To-Do |
|  |  | [AP-586](https://resolum-emergentes.atlassian.net/browse/AP-586) | Firmware actuador - Detectar bloqueo o sobrecarga de la ventana y cortar potencia | Implementar la supervisión del consumo y del cambio de posición de la ventana según los umbrales seguros definidos para el hardware. Hecho cuando: un consumo excesivo o la ausencia de cambio de posición interrumpe la potencia, registra WINDOW_OBSTRUCTION y comunica el fallo al Edge de actuadores. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-587](https://resolum-emergentes.atlassian.net/browse/AP-587) | Firmware actuador - Proteger la inversión de movimiento de la ventana | Implementar el cambio seguro de sentido cuando la ventana recibe una instrucción contraria mientras está en movimiento. Hecho cuando: primero se detiene el actuador, se aplica el intervalo de protección configurado y después se inicia el nuevo sentido, evitando alimentación continua o inversión inmediata. | 4 | Nicolás Juárez | To-Do |
| [DUS-01](https://resolum-emergentes.atlassian.net/browse/AP-140) | Emisión de comandos mediante la voz | [AP-588](https://resolum-emergentes.atlassian.net/browse/AP-588) | Integración voz - Conectar el comando hablado con la acción doméstica | Integrar el flujo existente de captura, reconocimiento local, envío entre Edge y ejecución en el controlador para comandos de luz, puerta y ventana. Reutilizar las implementaciones TS/DMS correspondientes. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-589](https://resolum-emergentes.atlassian.net/browse/AP-589) | Experiencia de voz - Solicitar repetición de comandos no comprendidos | Integrar las salidas de reconocimiento incierto o afectado por ruido con la respuesta audible del dispositivo. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-590](https://resolum-emergentes.atlassian.net/browse/AP-590) | Integración voz - Informar acciones no disponibles y dispositivos sin respuesta | Validar el flujo de voz cuando la acción no corresponde a un dispositivo instalado o el elemento solicitado no puede responder. | 4 | Dayro Richard Rios Piñan | To-Do |
| [DUS-02](https://resolum-emergentes.atlassian.net/browse/AP-141) | Confirmación perceptible de acciones solicitadas | [AP-591](https://resolum-emergentes.atlassian.net/browse/AP-591) | Experiencia de voz - Comunicar el avance y la finalización de acciones | Integrar los resultados del Edge de actuadores con las respuestas del Edge de voz y el altavoz, reutilizando las TS/DMS de ejecución y reproducción. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-592](https://resolum-emergentes.atlassian.net/browse/AP-592) | Experiencia de voz - Advertir la detención por resistencia u obstáculo | Integrar el resultado de detención segura de puerta o ventana con la advertencia perceptible del dispositivo. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-593](https://resolum-emergentes.atlassian.net/browse/AP-593) | Experiencia de voz - Avisar cuando una acción no pudo confirmarse | Integrar el vencimiento del tiempo previsto de respuesta con el mensaje de resultado no confirmado y validar el flujo completo. | 4 | Dayro Richard Rios Piñan | To-Do |
| [DUS-03](https://resolum-emergentes.atlassian.net/browse/AP-142) | Solicitud de auxilio mediante la voz | [AP-594](https://resolum-emergentes.atlassian.net/browse/AP-594) | Integración auxilio - Conectar la solicitud por voz con la alerta al cuidador | Integrar la intención de auxilio reconocida localmente con el flujo existente de alertas del backend y su respuesta al dispositivo. Reutilizar las TS y los canales de notificación existentes. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-595](https://resolum-emergentes.atlassian.net/browse/AP-595) | Integración auxilio - Comunicar la atención y comprobar la insistencia de alertas | Integrar el estado de atención confirmado por el cuidador con el aviso al dispositivo y validar las reglas existentes de insistencia. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-596](https://resolum-emergentes.atlassian.net/browse/AP-596) | Experiencia de auxilio - Mantener una señal local cuando falla el aviso remoto | Integrar el caso de falta de conexión con una advertencia audible de envío remoto fallido y una señal local de atención. | 4 | Dayro Richard Rios Piñan | To-Do |
| [DUS-04](https://resolum-emergentes.atlassian.net/browse/AP-143) | Percepción del estado del módulo de interacción | [AP-597](https://resolum-emergentes.atlassian.net/browse/AP-597) | Experiencia del dispositivo - Diferenciar las señales de disponibilidad y escucha | Integrar los estados de arranque correcto y captura de una instrucción con las señales perceptibles del módulo de interacción. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-598](https://resolum-emergentes.atlassian.net/browse/AP-598) | Integración de estado - Advertir batería baja a la persona y al cuidador | Conectar el evento de batería baja producido por el firmware con el aviso perceptible local y el flujo existente de notificación al cuidador principal. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-599](https://resolum-emergentes.atlassian.net/browse/AP-599) | Integración de estado - Comunicar fallas y desconexiones del módulo | Integrar la indisponibilidad de funciones necesarias para captar o responder con la señal de falla y el aviso al cuidador principal. Validar las señales ante las fallas previstas en las TS/DMS. | 4 | Dayro Richard Rios Piñan | To-Do |
| [DUS-05](https://resolum-emergentes.atlassian.net/browse/AP-144) | Continuidad durante un corte de energía | [AP-600](https://resolum-emergentes.atlassian.net/browse/AP-600) | Integración de energía - Comunicar la transición al respaldo durante un corte | Validar e integrar la conmutación existente a batería del módulo de interacción con el anuncio de continuidad de servicio. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-601](https://resolum-emergentes.atlassian.net/browse/AP-601) | Integración de energía - Verificar solicitudes esenciales durante el respaldo | Validar el recorrido de voz y respuesta de las funciones esenciales disponibles mientras el módulo funciona con respaldo, utilizando los componentes existentes. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-602](https://resolum-emergentes.atlassian.net/browse/AP-602) | Experiencia de energía - Advertir nivel crítico y apagado próximo | Integrar los estados de respaldo crítico y agotado con los avisos a la persona y al cuidador mediante los canales existentes. | 4 | Dayro Richard Rios Piñan | To-Do |
| [DUS-06](https://resolum-emergentes.atlassian.net/browse/AP-145) | Control accesible de la iluminación | [AP-603](https://resolum-emergentes.atlassian.net/browse/AP-603) | Integración de iluminación - Verificar encendido y apagado mediante voz | Integrar y validar el recorrido desde el comando hablado hasta el cambio físico de la luz y la respuesta audible, reutilizando las TS de ambos Edge y DMS-07. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-604](https://resolum-emergentes.atlassian.net/browse/AP-604) | Experiencia de iluminación - Informar el estado actual ante órdenes repetidas | Integrar el resultado de una orden que solicita el estado actual de iluminación con el mensaje audible correspondiente. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-605](https://resolum-emergentes.atlassian.net/browse/AP-605) | Integración de iluminación - Informar fallas y mantener los demás dispositivos | Validar el recorrido de fallo de iluminación desde el actuador hasta el aviso local y el canal existente de alerta al cuidador. | 4 | Nicolás Juárez | To-Do |
| [DUS-07](https://resolum-emergentes.atlassian.net/browse/AP-146) | Apertura y cierre seguro de la puerta | [AP-606](https://resolum-emergentes.atlassian.net/browse/AP-606) | Integración de puerta - Verificar apertura y cierre por voz con confirmación | Integrar y validar el comando hablado, el recorrido entre Edge, DMS-08 y la respuesta audible para apertura y cierre de la puerta. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-607](https://resolum-emergentes.atlassian.net/browse/AP-607) | Integración de puerta - Verificar detención y advertencia ante obstáculos | Validar que la protección de movimiento implementada en el controlador se refleje en el comportamiento completo de la puerta y en la advertencia a la persona. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-608](https://resolum-emergentes.atlassian.net/browse/AP-608) | Integración de puerta - Validar condición segura y aviso de asistencia ante atasco | Comprobar en el prototipo la respuesta ante atasco o ausencia de respuesta de la puerta, usando las protecciones existentes y el canal de alerta al cuidador principal. | 4 | Nicolás Juárez | To-Do |
| [DUS-08](https://resolum-emergentes.atlassian.net/browse/AP-147) | Apertura y cierre seguro de la ventana | [AP-609](https://resolum-emergentes.atlassian.net/browse/AP-609) | Integración de ventana - Verificar apertura y cierre mediante voz | Integrar y validar el recorrido del comando hablado hasta DMS-09 y el retorno del resultado al módulo de interacción. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-610](https://resolum-emergentes.atlassian.net/browse/AP-610) | Integración de ventana - Verificar detención y advertencia ante resistencia | Validar la respuesta conjunta del controlador y del módulo de interacción cuando la ventana encuentra un obstáculo. | 4 | Nicolás Juárez | To-Do |
|  |  | [AP-611](https://resolum-emergentes.atlassian.net/browse/AP-611) | Integración de ventana - Avisar falta de resultado y solicitar revisión al cuidador | Integrar la falta de resultado de una acción de ventana con el mensaje de indisponibilidad y la notificación existente al cuidador. | 4 | Nicolás Juárez | To-Do |
| [SP-01](https://resolum-emergentes.atlassian.net/browse/AP-148) | Evaluación y benchmarking de modelos open source para reconocimiento local de voz en Edge | [AP-612](https://resolum-emergentes.atlassian.net/browse/AP-612) | Spike voz - Comparar al menos tres modelos locales con un benchmark reproducible | Seleccionar un mínimo de tres modelos open source con español, licencia compatible y viabilidad en el hardware Edge. Preparar un conjunto reproducible e independiente con comandos de luz, puerta, ventana y auxilio, y ejecutar la comparación dentro del timebox total de SP-01. | 6 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-613](https://resolum-emergentes.atlassian.net/browse/AP-613) | Spike voz - Prototipar el mejor candidato sin Internet en el hardware Edge | Instalar y ejecutar el candidato con mejores resultados en el hardware Edge de voz, capturando y procesando comandos localmente como prueba de concepto de investigación. | 4 | Dayro Richard Rios Piñan | To-Do |
|  |  | [AP-614](https://resolum-emergentes.atlassian.net/browse/AP-614) | Spike voz - Entregar reporte reproducible y ADR de selección o descarte | Consolidar metodología, datos de evaluación, versiones, configuración, resultados, licencias, riesgos y límites del hardware. Redactar el ADR y las historias de integración, calibración, versionado y validación que se deriven de la investigación. | 4 | Dayro Richard Rios Piñan | To-Do |





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
