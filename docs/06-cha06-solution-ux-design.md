# Capítulo 6: Solution UX Design

## 6.1. Style Guidelines

En esta sección el equipo sienta las bases para contar con un repositorio central y organizado de uso común para todo el equipo, que incluye assets, fuentes tipográficas, íconos, componentes y demás recursos visuales de Alivia, con el fin de mantener una presentación consistente y enfocada en todas las plataformas del producto. Este repositorio, entendido como un conjunto de principios y criterios que orientan la creación de productos digitales de manera coherente, funcional y visualmente consistente, asegura que cada elemento de la interfaz mantenga uniformidad en la experiencia del usuario, facilitando la legibilidad, la accesibilidad y el reconocimiento de la identidad del producto. Se incluyen secciones para General Style Guidelines, Web Style Guidelines y Mobile Style Guidelines.

En el caso de Alivia, estas directrices adquieren una relevancia particular, ya que la plataforma está dirigida a un segmento de usuarios con discapacidad motora severa y, en muchos casos, con comorbilidades visuales asociadas, lo que exige que cada decisión de diseño priorice la claridad, el contraste y la reducción de la carga cognitiva por sobre consideraciones puramente estéticas.

### 6.1.1. General Style Guidelines

El equipo de diseño ha definido un sistema de Style Guidelines que fija las bases visuales y comunicacionales de Alivia en todas sus plataformas: landing page, aplicación web, aplicación móvil y las señales del dispositivo IoT instalado en el hogar. Estas directrices buscan que la experiencia se sienta igual de clara sin importar dónde la persona esté interactuando con el producto, y eso reduce el esfuerzo mental que le pide al usuario y refuerza su confianza en el sistema.

El diseño parte de principios de usabilidad, accesibilidad y diseño centrado en el usuario, algo que en Alivia no es un simple checklist sino una condición para que el producto funcione: buena parte de las personas que lo usan tienen discapacidad motora severa y, en varios casos, dificultades visuales asociadas. Contar con una guía de estilos ordenada permite que diseño y desarrollo trabajen bajo el mismo lenguaje visual, facilita que el producto crezca sin perder coherencia y asegura una experiencia profesional tanto para la persona asistida como para su cuidador. Como señala Zeldman (2024), una guía de estilos bien estructurada agiliza la evolución del producto y asegura una experiencia consistente en todos los entornos de uso.

El equipo tomó como referencia un Design System existente basado en principios de accesibilidad y diseño centrado en el usuario, sobre el cual realizó adaptaciones cromáticas, tipográficas y de tono propias de la identidad de marca de Alivia, en lugar de construir el sistema completo desde cero.

**Colors**

El color es uno de los recursos más poderosos que tiene una interfaz para comunicar sin usar palabras. No solo define la identidad visual de una marca, también guía la atención del usuario, comunica el estado del sistema y ordena la jerarquía de la información. La paleta de Alivia se construyó a partir del sistema visual del proyecto, que define cuatro familias de color: Primary (`#0F2A6B`), Secondary (`#2EC4B6`), Tertiary (`#E6F8F5`) y Neutral (`#3B4A6B`).

Como señalan Westland y Maggio (2023), las interfaces que trabajan con paletas cromáticas estructuradas y con un significado claro reducen los errores de navegación y ayudan a que el usuario retenga mejor la información. Bajo esa lógica, cada color de Alivia cumple un rol específico dentro del sistema.

**Color primario:**

<div style="display: flex; align-items: center;">
  <img src="https://imgur.com/ake294S.png" alt="primary-color">
</div>

El azul marino (`#0F2A6B`) es el color principal de la marca. Se eligió porque comunica confianza, estabilidad y seguridad, ideas que van directamente alineadas con lo que Alivia representa: una solución que acompaña a personas con discapacidad motora severa en su hogar. A nivel perceptivo, un azul oscuro y saturado transmite calma y seriedad, algo importante en un producto que está presente en momentos sensibles como el cuidado diario o una solicitud de auxilio.

| Nombre | Hex | Uso principal | Justificación |
|---|---|---|---|
| Azul Marino | `#0F2A6B` | Botones primarios, barra de navegación, encabezados, íconos de acción principal | Color de marca principal; contraste alto sobre fondos claros |
| Azul Profundo | `#081745` | Estados hover en elementos primarios, textos sobre fondo claro | Refuerza jerarquía tipográfica y da mayor contraste en textos |
| Azul Medio | `#2C4A8F` | Elementos interactivos secundarios, bordes activos, estados de foco | Señala interacción sin competir con el azul principal |
| Azul Claro | `#8DA3D9` | Fondos de sección destacada, estados seleccionados | Variante de baja saturación para contenedores secundarios |
| Azul Neblina | `#DCE5F7` | Fondos sutiles, separación visual entre bloques | Aporta descanso visual sin distraer de los elementos interactivos |

- **Jerarquía visual:** el tono más oscuro sostiene la navegación y los elementos de marca, mientras que los tonos claros marcan niveles de interacción cada vez más ligeros, así el usuario distingue de un vistazo qué es fijo y qué responde a su toque.
- **Consistencia de marca:** todas las variantes del azul comparten la misma temperatura de color, para que no haya derivaciones raras que hagan dudar al usuario de que sigue dentro de Alivia (Wheeler y Meyerson, 2024).
- **Accesibilidad:** todos los contrastes deben validarse contra WCAG 2.1 para cumplir AA/AAA en texto y elementos interactivos, cuidando especialmente a usuarios con baja visión, una condición frecuente en el segmento al que atiende Alivia (World Wide Web Consortium, 2025).

**Color secundario:**

<div style="display: flex; align-items: center;">
  <img src="https://imgur.com/MYwlbYt.png" alt="secondary-color">
</div>

El turquesa (`#2EC4B6`) funciona como color de acento y de calidez dentro del sistema. Aporta una sensación de bienestar y cercanía humana que equilibra la seriedad del azul marino, y se usa para resaltar acciones positivas, confirmaciones y momentos en los que la persona asistida logra hacer algo por sí misma.

| Nombre | Hex | Uso principal | Justificación |
|---|---|---|---|
| Turquesa | `#2EC4B6` | Confirmaciones, indicadores de éxito, acentos de marca | Color de acento principal, con buen contraste sobre blanco y sobre el azul marino |
| Turquesa Oscuro | `#1E9184` | Estados hover en elementos secundarios | Mantiene contraste suficiente en estados activos |
| Turquesa Medio | `#5AD4C8` | Badges de estado, chips informativos | Refuerza señales positivas sin saturar la vista |
| Turquesa Claro | `#A3E8E0` | Fondos de tarjetas informativas, estados seleccionados | Variante suave para contenedores secundarios |
| Menta | `#DEF8F4` | Fondos sutiles, separación de secciones | Da respiro visual sin restarle protagonismo al color primario |

- **Jerarquía visual:** el turquesa se reserva para comunicar progreso, confirmación y bienestar; no se usa de forma decorativa, porque perdería su fuerza como señal.
- **Consistencia:** todas las variantes comparten la misma temperatura cromática, lo que crea una relación armónica con el azul marino primario.
- **Accesibilidad:** los contrastes deben validarse según WCAG 2.1, garantizando legibilidad tanto en texto como en elementos gráficos (World Wide Web Consortium, 2025).

**Color terciario:**

<div style="display: flex; align-items: center;">
  <img src="https://imgur.com/o8KUq3s.png" alt="tertiary-color">
</div>

El menta claro (`#E6F8F5`) cumple un rol de fondo y de soporte en secciones destacadas. Su baja saturación permite un contraste suave frente al primario y al secundario, sin competir con ellos, y esto pesa bastante en pantallas que se consultan por periodos largos, como el panel donde el cuidador supervisa el estado del hogar.

| Nombre | Hex | Uso principal | Justificación |
|---|---|---|---|
| Menta Claro | `#E6F8F5` | Fondos de sección, tarjetas informativas, paneles de estado | Fondo de baja saturación que resalta el contenido sin distraer |
| Menta Medio | `#C7EEE8` | Separadores sutiles, fondos de estado neutro | Aporta jerarquía visual sin sumar un color adicional al sistema |
| Menta Oscuro | `#9DDCD2` | Bordes suaves, líneas divisorias | Marca límites de componentes sin generar un contraste agresivo |

- **Jerarquía visual:** actúa como lienzo intermedio entre el fondo neutro general y los bloques de contenido, ayudando a agrupar información relacionada, por ejemplo el estado de los dispositivos del hogar.
- **Consistencia:** comparte familia cromática con el secundario, así que refuerza la cohesión del sistema en vez de sumar ruido.
- **Accesibilidad:** se usa únicamente como fondo de apoyo, nunca como color de texto, para no comprometer el contraste mínimo exigido por WCAG 2.1.

**Color neutral:**

<div style="display: flex; align-items: center;">
  <img src="https://imgur.com/Lw0XSSv.png" alt="neutral-color">
</div>

El azul grisáceo (`#3B4A6B`) y su familia de neutros son el soporte donde viven los textos, los bordes y los estados inactivos. Su función es dar orden y legibilidad sin robarle protagonismo a los colores funcionales, algo clave en pantallas con bastante información como el historial de eventos que revisa el cuidador.

| Nombre | Hex | Uso principal | Justificación |
|---|---|---|---|
| Gris Azulado | `#3B4A6B` | Textos secundarios, íconos inactivos, bordes de componentes | Tono intermedio que marca límites sin saturar la interfaz |
| Gris Azulado Oscuro | `#252F45` | Textos principales, encabezados sobre fondo claro | Mayor contraste para dar jerarquía tipográfica |
| Gris Azulado Claro | `#8890A3` | Placeholders, metadatos, textos de ayuda | Legibilidad cómoda para información de menor peso |
| Blanco | `#FFFFFF` | Fondo general de la aplicación, tarjetas, modales | Lienzo principal de la interfaz |

- **Jerarquía visual:** la escala neutral marca los niveles de importancia del contenido sin necesidad de recurrir a color saturado, dejando que el sistema semántico (primario, secundario) conserve todo su peso.
- **Consistencia:** comparte la misma temperatura fría del color primario, lo que arma un conjunto visualmente cohesivo.
- **Accesibilidad:** cada tono debe validarse para garantizar contraste suficiente en texto y componentes, conforme a WCAG 2.1 (World Wide Web Consortium, 2025), pensando en usuarios con baja visión.

**Typography**

La tipografía comunica tanto como el contenido mismo. La elección tipográfica genera una respuesta casi inmediata en el usuario, influyendo en cómo percibe la confiabilidad de un producto incluso antes de leer lo que dice (Jay y Lupton, 2024). En Alivia, esa elección responde a dos necesidades a la vez: legibilidad real para personas con dificultades visuales y una identidad que se sienta cercana y confiable, no fría ni puramente técnica.

A partir del sistema visual del proyecto, el equipo confirma el uso de **Outfit** como tipografía principal, aplicada en los niveles de Headline, Body y Label de la interfaz.

<div style="display: flex; align-items: center;">
  <img src="https://imgur.com/v2wRisT.png" alt="typographie">
</div>

*Modelo tipográfico Outfit Headline, Body y Label para Alivia*

Las tipografías sans-serif geométricas como Outfit se renderizan de forma limpia en pantallas de distinta resolución (González-Rodríguez et al., 2024). Sus formas amplias y abiertas ayudan a que un texto corto (una confirmación, una alerta) se lea rápido, y eso es justamente lo que Alivia necesita: que tanto la persona asistida como el cuidador entiendan un mensaje en segundos, sin tener que releerlo.

*Escala tipográfica y usos de la familia Outfit en la interfaz de Alivia*

| Rol | Familia | Peso | Tamaño | Altura de línea | Uso principal |
|---|---|---|---|---|---|
| Headline | Outfit | 600 (Semibold) | 28–36 px | 1.25× | Títulos de sección, encabezados de página, nombre de la persona asistida en alertas |
| Body | Outfit | 400 (Regular) | 16–18 px | 1.5× | Cuerpo de texto, descripciones, historial de eventos e información general |
| Label | Outfit | 400–500 | 13–14 px | 1.4× | Etiquetas de componentes, metadatos, campos de formulario, estados de dispositivos |

La elección de Outfit responde a cuatro criterios concretos:

**1. Lectura rápida en momentos que importan**

La geometría amplia y redondeada de Outfit favorece que una palabra clave dentro de una alerta se reconozca de inmediato, algo crítico cuando el cuidador tiene que identificar en segundos qué tan urgente es una solicitud de asistencia.

**2. Una tipografía que no se ve fría**

Su estructura sans-serif de proporciones abiertas evita confusiones entre caracteres parecidos y, al mismo tiempo, aporta una sensación de cercanía poco común en tipografías puramente técnicas, algo que encaja con lo que Alivia quiere transmitir.

**3. Compatible con toda la plataforma**

Outfit está disponible en Google Fonts, carga bien desde CDN y funciona sin perder consistencia visual tanto en React (aplicación web) como en las aplicaciones móviles nativas (Bhanarkar et al., 2023).

**4. Coherencia con lo que Alivia quiere transmitir**

Su estética moderna y redondeada acompaña valores como autonomía, cuidado y confianza. A diferencia de una tipografía más rígida, Outfit refuerza la idea de un producto humano y cercano, sin dejar de sentirse serio y profesional.

**Principios de aplicación tipográfica:**

- **Contraste de peso:** se usan solo dos pesos (Regular y Semibold) para marcar jerarquía sin recargar visualmente la interfaz.
- **Escala jerárquica:** los Headline captan la atención en momentos clave, como una alerta crítica o el nombre de la persona asistida; los Body garantizan una lectura cómoda del historial y las descripciones; los Label ordenan la información secundaria sin competir con el contenido principal.
- **Tamaño mínimo pensado para el usuario:** dado que parte de los usuarios presenta baja visión asociada a su condición, se privilegian tamaños de fuente mayores a los estándares habituales en las pantallas dirigidas a la persona asistida.
- **Longitud de línea:** se prioriza texto corto y directo por sobre bloques densos, sobre todo en las confirmaciones de voz transcritas visualmente y en las alertas que recibe el cuidador.

**Spacing**

El espaciado es lo que hace que una interfaz se sienta ordenada y no abrumadora. El sistema de espaciado de Alivia se basa en una unidad base y sus múltiplos, siguiendo la lógica de los sistemas de diseño modulares, con el fin de mantener una misma sensación entre la landing page, la aplicación web y la aplicación móvil del cuidador.

Este enfoque tiene ventajas concretas: evita valores arbitrarios, se implementa fácilmente con design tokens o variables CSS, escala de forma predecible entre breakpoints y, sobre todo, reduce la carga cognitiva del usuario al mantener un ritmo visual coherente (Wang et al., 2025).

*Escala de espaciado del sistema de diseño de Alivia*

| Token | Valor | Uso principal |
|---|---|---|
| spacing-1 | 4 px | Separación mínima entre íconos y etiquetas, padding interno de badges de estado |
| spacing-2 | 8 px | Separación entre elementos relacionados, padding de botones pequeños |
| spacing-3 | 12 px | Padding vertical de inputs, separación entre campos de formulario |
| spacing-4 | 16 px | Padding interno de tarjetas de alertas y actividades, separación entre ítems de lista |
| spacing-6 | 24 px | Separación entre secciones de una vista, márgenes de paneles de supervisión |
| spacing-8 | 32 px | Separación entre bloques de contenido independientes, márgenes de página |

*Directrices de espaciado para elementos de texto en Alivia*

| Elemento | Tamaño | Altura de línea | Margen inferior |
|---|---|---|---|
| Headline H1 | 36 px | 44 px (1.22×) | 32 px |
| Headline H2 | 28 px | 36 px (1.28×) | 24 px |
| Body | 16 px | 24 px (1.5×) | 16 px |
| Body small | 14 px | 20 px (1.43×) | 12 px |
| Label | 13–14 px | 18 px (1.4×) | 8 px |

*Directrices de padding y margen para los componentes principales de Alivia*

| Componente | Padding interno | Margen externo | Gutter |
|---|---|---|---|
| Botón primario | 12 px (vertical) × 22 px (horizontal) | 8 px | — |
| Input / Campo de formulario | 12 px (vertical) × 14 px (horizontal) | 12 px | — |
| Tarjeta de alerta / actividad | 16 px | 16 px | 16 px |
| Navbar / Sidebar | 20 px | — | — |
| Grid de contenido | — | — | 16 px |

**Principios de agrupamiento y alineación:**

- **Agrupamiento semántico:** los elementos que están relacionados entre sí (el ícono de un dispositivo con su estado, una alerta con su nivel de prioridad) se agrupan con márgenes reducidos; las secciones independientes se separan con márgenes amplios, aplicando el principio de proximidad de la Gestalt para no sobrecargar al usuario (Zeldman, 2024).
- **Alineación consistente:** todos los elementos siguen una cuadrícula modular en ambos ejes, para que la distribución sea pareja tanto en la web como en el móvil.
- **Prioridad visual en alertas:** los componentes vinculados a alertas críticas o solicitudes de auxilio reciben más espacio y jerarquía que los elementos informativos rutinarios, para que su urgencia se note incluso sin depender solo del color.
- **Escalado responsivo:** en móvil se mantienen los espaciados más chicos de la escala; en tablet y escritorio se incorporan los múltiplos mayores para aprovechar el espacio adicional sin que la distribución se vea desbalanceada.

**Icons**

Los íconos cumplen un rol que va más allá de lo decorativo en Alivia: muchas veces son la forma más rápida que tiene el usuario de entender qué está pasando con un dispositivo del hogar, sin depender de leer un texto completo. Eso importa especialmente acá, porque tanto la persona asistida como el cuidador necesitan captar de un vistazo si una luz está encendida, si una puerta quedó abierta o si la batería de un sensor está por agotarse.

El sistema adopta un estilo **outline**, con trazos limpios y de grosor uniforme, evitando rellenos sólidos que puedan generar ruido visual o confundirse entre sí a tamaños pequeños. Esta elección responde a que los íconos outline se leen mejor en pantallas de distinta densidad y mantienen su claridad incluso cuando se reducen para caber en una notificación o en un chip de estado.

| Categoría | Uso principal | Ejemplo de aplicación |
|---|---|---|
| Dispositivos del hogar | Representar luces, puertas y ventanas dentro del panel de control y supervisión | Ícono de bombilla para luz, ícono de puerta para accesos, ícono de persiana para ventanas |
| Estado y conectividad | Comunicar el estado operativo de un dispositivo | Ícono de señal para conectividad, ícono de batería para nivel de carga |
| Alertas y notificaciones | Diferenciar visualmente el nivel de urgencia de un aviso | Ícono de campana para notificaciones generales, ícono de exclamación para alertas críticas |
| Navegación | Guiar al usuario entre las secciones principales de la aplicación | Ícono de casa para inicio, ícono de perfil para cuenta, ícono de historial para actividad reciente |
| Acciones del cuidador | Representar acciones de gestión y respuesta | Ícono de check para confirmar una alerta, ícono de reloj para turnos y horarios |

- **Consistencia con la marca:** la geometría de los íconos acompaña la redondez de la tipografía Outfit y se apoya en la paleta cromática del sistema, usando el azul marino y el turquesa para reforzar significado (por ejemplo, un ícono en turquesa comunica una acción completada con éxito).
- **Tamaño mínimo accesible:** los íconos interactivos mantienen un área táctil suficiente para no dificultar su uso a personas con movilidad reducida en manos o dedos, evitando elementos demasiado pequeños o muy próximos entre sí.
- **Nunca solos:** en las acciones críticas (como confirmar una alerta o accionar un dispositivo) el ícono siempre va acompañado de una etiqueta de texto, para no depender únicamente de la interpretación visual y reducir el riesgo de una acción equivocada.
- **Reconocimiento inmediato:** se priorizan formas ya familiares para el usuario (una bombilla, una puerta, una campana) por sobre íconos abstractos o de interpretación ambigua, dado que el tiempo de reconocimiento debe ser mínimo, sobre todo en el flujo de la persona asistida.

**Branding**

El branding de Alivia busca transmitir cercanía, confianza y accesibilidad, sin dejar de lado la seriedad que exige un producto de asistencia tecnológica. El logotipo combina un corazón con la silueta de una persona, comunicando de un vistazo el propósito de cuidado y acompañamiento detrás de la plataforma. El isotipo, trazado en turquesa, acompaña al nombre "Alivia" escrito en azul marino, equilibrando la calidez del vínculo entre la persona asistida y su cuidador con la seriedad institucional que también necesita un producto de este tipo.

El logotipo debe usarse siempre con suficiente espacio de protección a su alrededor, evitando distorsionarlo, rotarlo o combinarlo con colores fuera de la paleta oficial. En espacios reducidos o de baja resolución, como una notificación push o el favicon, se prioriza el isotipo del corazón solo, ya que se mantiene reconocible incluso sin el nombre completo de la marca.

Los íconos de la plataforma siguen un estilo outline, con trazos limpios y uniformes que ayudan a comunicar de inmediato el estado de un dispositivo del hogar (una luz, una puerta, una ventana, el nivel de batería, la conectividad) sin depender únicamente del texto. Su geometría acompaña a la tipografía Outfit y a la paleta cromática del sistema, reforzando la coherencia visual en todos los puntos de contacto: la landing page, la aplicación web, la aplicación móvil y las señales visuales del propio dispositivo IoT.

<div style="display: flex; align-items: center;">
  <img src="https://imgur.com/0juuJdp.png" alt="alivia-logo">
</div>

**Communication Tone & Language**

Como señalan Smith y Zook (2024), el tono de comunicación no es un detalle menor en el diseño de una interfaz: moldea cómo se siente el usuario al interactuar con el producto y ayuda a construir una identidad de marca que se recuerda. En Alivia esto pesa más de lo habitual, porque el producto está presente en momentos de vulnerabilidad real: la dependencia diaria de otra persona, la frustración de no poder hacer algo tan simple como abrir una puerta, o el miedo de un cuidador cuando sale de casa. El tono tiene que acompañar eso, no ignorarlo.

El tono de Alivia se define en las siguientes dimensiones:

*Dimensiones del tono de comunicación de Alivia*

| Dimensión | Posición | Justificación |
|---|---|---|
| Divertido / Serio | Inclinado hacia serio, pero sin ser frío | Alivia acompaña situaciones sensibles como el cuidado diario y las solicitudes de auxilio; un tono divertido no tiene lugar ahí. Aun así, se evita sonar a manual técnico buscando calidez en la redacción |
| Formal / Casual | Punto intermedio, levemente formal | Tiene que sonar confiable frente al cliente y al cuidador, sin volverse un lenguaje distante que le complique la comprensión a la persona asistida |
| Respetuoso / Irreverente | Marcadamente respetuoso | El lenguaje dirigido a la persona con discapacidad motora severa nunca asume lástima ni sobreprotección; siempre reconoce que ella sigue teniendo el control de su vida y de su hogar |
| Entusiasta / Sereno | Predominantemente sereno | Las confirmaciones de voz y las alertas priorizan la calma por sobre la efusividad, sobre todo en un escenario de auxilio, donde un tono exaltado puede poner más nervioso a alguien que ya está pasando un mal momento |

**Principios de comunicación aplicados:**

- **Claro antes que nada:** cada mensaje se entiende a la primera lectura o escucha, sin dejar dudas sobre qué acción se ejecutó o cuál es el estado actual del sistema.
- **Respeto por la autonomía:** el lenguaje dirigido a la persona asistida nunca suena a lástima ni a sobreprotección; refuerza en todo momento que ella sigue teniendo el control sobre su entorno.
- **Calma en momentos críticos:** las alertas de auxilio y las notificaciones de falla se redactan con firmeza pero sin alarmismo, priorizando qué hacer por sobre describir lo grave de la situación.
- **El mismo tono en todos lados:** la landing page, la aplicación web, la aplicación móvil y las confirmaciones por voz del dispositivo hablan igual, para que Alivia se sienta como una sola voz sin importar el canal.

*Patrones de tono aplicados según el contexto de interacción en Alivia*

| Contexto | Tono | Ejemplo |
|---|---|---|
| Confirmación de comando de voz | Afirmativo y directo | "Listo, la luz de tu cuarto está encendida." |
| Solicitud de auxilio | Sereno y firme | "Se envió tu solicitud de ayuda a Mariano. Está en camino." |
| Alerta al cuidador | Claro y orientado a la acción | "Sebastián necesita ayuda para movilizarse. Prioridad alta." |
| Falla de un dispositivo | Sobrio y sin alarmismo | "La puerta no respondió. Avisamos a tu cuidador para revisarla." |
| Mensaje de bienvenida | Cercano y profesional | "Bienvenido a Alivia. Empecemos configurando tu primer dispositivo." |

**Vocabulario preferido:**

El vocabulario de la interfaz se alinea con el Ubiquitous Language definido en el modelo de dominio del sistema (ver Capítulo 2), para que los términos que usa el usuario sean los mismos que maneja el negocio. Palabras como "persona asistida", "cuidador", "solicitud de asistencia", "autonomía" y "alerta crítica" se usan de forma consistente en todos los mensajes, etiquetas y notificaciones de la plataforma.

Se evita el uso de anglicismos innecesarios, jerga técnica sin explicar y expresiones que puedan sonar ambiguas o, peor, condescendientes hacia la persona con discapacidad. Cuando se introduce un término más técnico, como el estado de conexión de un dispositivo, se acompaña de una explicación breve la primera vez que aparece, para que tanto la persona asistida como el cuidador puedan usar la plataforma sin fricción, sin importar su nivel de experiencia con la tecnología.

### 6.1.2. Web, Mobile & Devices Style Guidelines

**Web Style Guidelines**

**Mobile Style Guidelines**

**Devices Style Guidelines**

## 6.2. Information Architecture

### 6.2.1. Organization Systems

### 6.2.2. Labeling Systems

### 6.2.3. Searching Systems

### 6.2.4. SEO Tags & Meta Tags

### 6.2.5. Navigation Systems

## 6.3. Landing Page UI Design

### 6.3.1. Landing Page Wireframe

### 6.3.2. Landing Page Mockups

## 6.4. Applications UX/UI Design

### 6.4.1. Applications Wireframes

### 6.4.2. Applications Wire-flow Diagrams

### 6.4.3. Applications Mockups

### 6.4.4. Applications User-flow Diagrams

## 6.5. IoT Device Design

**12 Pasos para el diseño de dispositivos IoT**

<div align="center">
  <img src="https://i.imgur.com/KIXRbiB.png" alt="Flujo del diseño de dispositivos iot en 12 pasos"/>
</div>

***Paso 1: Definición de los requisitos del sistema***

<table>
    <tr>
        <th> Criterios </th>
        <th> Especificación Técnica </th>
    </tr>
    <tr>
        <td rowspan="3"> <strong> Capacidades de Suministro de Energía </strong> </td>
        <td> <strong> Entorno de Operación: </strong></td>
    </tr>
    <tr>
        <td> <strong> Entrada de Alimentación: </strong></td>
    </tr>
    <tr>
        <td> <strong> Restricciones: </strong></td>
    </tr>
    <tr>
        <td rowspan="4"> <strong> Restricciones de Latencia (Time-Delay) </strong> </td>
        <td> <strong> Modelo Basado en Eventos: </strong>El sistema se implementa bajo un paradigma reactivo (event-driven). Los dispositivos entran en modo de espera activa y solo transmiten datos ante variaciones significativas para optimizar el ancho de banda. </td>
    </tr>
</table>

***Paso 2: Elección de la tipología de sistema IoT***

<table>
    <tr>
        <th> Parámetro de Clasificación </th>
        <th> Estructura Definida </th>
        <th> Justificación Técnica </th>
    </tr>
    <tr>
        <td> <strong> Suministro de Energía </strong> </td>
        <td>  </td>
        <td>  </td>
    </tr>
    <tr>
        <td> <strong> Restricción de Retardo (Time-Delay) </strong> </td>
        <td>  </td>
        <td>  </td>
    </tr>
    <tr>
        <td> <strong> Tipología Final </strong> </td>
        <td>  </td>
        <td>  </td>
    </tr>
</table>

***Paso 3: Definición de requisitos para la capa física***

<table>
    <tr>
        <th> Parámetro </th>
        <th> Definición y Requisitos Técnicos </th>
    </tr>
    <tr>
        <td> <strong> Configuración de Elementos </strong> </td>
        <td>  
        </td>
    </tr>
    <tr>
        <td> <strong> Incertidumbre Objetivo (Target Uncertainty) </strong> </td>
        <td> 
        </td>
    </tr>
    <tr>
        <td> <strong> Precisión del Actuador Visual </strong> </td>
        <td> </td>
    </tr>
    <tr>
        <td> <strong> Capacidad de Procesamiento Local </strong> </td>
        <td>  
        </td>
    </tr>
</table>

***Paso 4: Definición de requisitos para la capa de intercambio de datos***

<table>
    <tr>
        <th> Parámetro </th>
        <th> Definición Técnica </th>
    </tr>
    <tr>
        <td> <strong> Latencia de Transporte Local </strong> </td>
    </tr>
    <tr>
        <td> <strong> Medio Físico de Transmisión </strong> </td>
    </tr>
    <tr>
        <td> <strong> Topología de Red </strong> </td>
    </tr>
    <tr>
        <td> <strong> Rango Operativo </strong> </td>
    </tr>
    <tr>
        <td> <strong> Consumo Máximo de Potencia de Radio </strong> </td>
    </tr>
    <tr>
        <td> <strong> Criptografía y Seguridad </strong> </td>
    </tr>
</table>

***Paso 5: Definición de requisitos para la capa de información***

<table>
    <tr>
        <th> Criterios </th>
        <th> Especificación de Capa </th>
    </tr>
    <tr>
        <td rowspan="2"> <strong> Perfiles de Usuario </strong> </td>
        <td> <strong> Operador de Mantenimiento: </strong></td>
    </tr>
    <tr>
        <td> <strong> Administrador del Negocio: </strong></td>
    </tr>
    <tr>
        <td rowspan="2"> <strong> Distribución de Servicios </strong> </td>
        <td> <strong> Mantenimiento: </strong></td>
    </tr>
    <tr>
        <td> <strong> Operativo: </strong></td>
    </tr>
    <tr>
        <td rowspan="3"> <strong> Arquitectura de Procesamiento y Cómputo </strong> </td>
        <td> <strong> En el Nodo Sensor (ESP32): </strong></td>
    </tr>
    <tr>
        <td> <strong> En el Gateway (Edge): </strong></td>
    </tr>
    <tr>
        <td> <strong> En el Middleware (Cloud): </strong></td>
    </tr>
</table>

***Paso 6: Definición de requisitos para la capa de servicios de aplicación***

<table>
    <tr>
        <th> Servicio </th>
        <th> Especificación de la Interfaz </th>
        <th> Complejidad del Cliente </th>
    </tr>
    <tr>
        <td> <strong> Nombre Servicio </strong> </td>
        <td> Descripción (interfaz web, móvil, iot) </td>
        <td> </td>
    </tr>
</table>

***Paso 7: Elección de la arquitectura de las capas de intercambio de datos y de información***

<table>
    <tr>
        <th> Origen </th>
        <th> Destino </th>
        <th> Protocolo / Canal </th>
        <th> Latencia Estimada (ms) </th>
        <th> Acción Operativa </th>
    </tr>
    <tr>
        <td> Colocar los casos de intercambio de datos existente (Cloud - Edge - Node) </td>
        <td>  </td>
        <td>  </td>
        <td>  </td>
        <td> si </td>
    </tr>
    <tr>
        <td colspan="3"> <strong> Latencia Total Acumulada (End-to-End) </strong> </td>
        <td> <strong> 1110 ms (1.11 s) </strong> </td>
        <td> </td>
    </tr>
</table>

***Paso 8: Elección de sensores y actuadores***

<table>
    <tr>
        <th> Parámetro Físico </th>
        <th> Modelo de Componente </th>
        <th> Justificación e Integración Técnica </th>
    </tr>
    <tr>
        <td> <strong> Medición de Masa/Peso </strong> </td>
        <td> Celda de Carga WSS-5KG + Convertidor HX711 </td>
        <td> 
        </td>
    </tr>
</table>

***Paso 9: Elección del microcontrolador y transceptores de radio del dispositivo***

<table>
    <tr>
        <th> Rol en la Red </th>
        <th> Modelo de Hardware </th>
        <th> Transceptor Integrado </th>
        <th> Justificación Metodológica </th>
    </tr>
    <tr>
        <td> <strong> Nodo Sensor </strong> </td>
        <td> ESP32 DevKitV1 </td>
        <td> Wi-Fi 2.4 GHz (802.11 b/g/n) </td>
        <td> 
    Se selecciona este SoC de 32 bits de doble núcleo por sus periféricos integrados de comunicación inalámbrica y su potencia de procesamiento. Ofrece soporte nativo para buses I2C (para la pantalla LCD) y pines digitales rápidos para comunicarse con el módulo HX711 y el sensor DHT22. Además, su memoria interna (520 KB de SRAM y 4 MB de Flash) permite ejecutar de forma concurrente el stack Wi-Fi WPA2, la encriptación local y la lógica de muestreo de peso y ambiente.
        </td>
    </tr>
    <tr>
        <td> <strong> Concentrador (Edge Gateway) </strong> </td>
        <td> Raspberry Pi 4 Model B </td>
        <td> Wi-Fi Dual Band + Ethernet </td>
        <td> 
    Esta computadora de placa única (SBC) de 1.5 GHz con arquitectura ARM Cortex-A72 proporciona la capacidad de cómputo necesaria para ejecutar el broker local de mensajería (Mosquitto), la base de datos SQLite y el servicio local de borde (Edge Service). Soporta la ingesta y procesamiento de múltiples balanzas en paralelo sin pérdidas de información, encripta los datos y los sincroniza de manera segura con el Cloud Service.
        </td>
    </tr>
</table>

***Paso 10: Definición de los algoritmos de procesamiento de datos***

<table>
    <tr>
        <th> Nombre del Algoritmo </th>
        <th> Responsabilidad y Lógica Matemática </th>
        <th> Nivel de Ubicación </th>
    </tr>
    <tr>
        <td> <strong> Colocar los algoritmos necesarios (Cloud, Edge o Nodo) </strong> </td>
        <td> </td>
        <td> Nodo Sensor (ESP32) </td>
    </tr>
</table>

***Paso 11: Análisis del esfuerzo computacional de los algoritmos***

<table>
    <tr>
        <th> Algoritmo </th>
        <th> Complejidad Temporal (Big O) </th>
        <th> Complejidad Espacial </th>
        <th> Tiempo Estimado de Ejecución </th>
        <th> Ubicación </th>
    </tr>
    <tr>
        <td> Colocar para cada algoritmo identificado </td>
        <td> $O(N)$ </td>
        <td> $O(1)$ (Bajo, $< 1\text{ KB}$) </td>
        <td> 100 ms </td>
        <td> Nodo Sensor (ESP32) </td>
    </tr>
</table>

***Paso 12: Definición de la interfaz de usuario gráfica***

<table>
    <tr>
        <th> Módulo de Interfaz </th>
        <th> Plataformas de Visualización </th>
        <th> Elementos Clave de la UI </th>
        <th> Justificación Funcional </th>
    </tr>
    <tr>
        <td> <strong> Monitoreo de Salud de Dispositivos </strong> </td>
        <td> Aplicación Web / Historial local (Health Log) </td>
        <td> Indicadores de conectividad, temperatura de CPU, voltaje y RAM libre. </td>
        <td> Permite a los operadores realizar autodiagnósticos de hardware y prever desconexiones o fallos eléctricos en tiempo real. </td>
    </tr>
</table>

**Diseño físico y de circuito del dispositivo IoT**

## 6.6. Applications Prototyping

<div style="page-break-after: always;"></div>
