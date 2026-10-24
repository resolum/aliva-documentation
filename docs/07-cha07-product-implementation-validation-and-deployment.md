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
