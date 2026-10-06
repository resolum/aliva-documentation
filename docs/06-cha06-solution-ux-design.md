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

En esta sección se detallan los estándares visuales y de interacción específicos para las tres plataformas que conforman Alivia: la aplicación web (usada por cuidadores, técnicos y administradores), la aplicación móvil (canal principal del cuidador para supervisión remota) y el dispositivo IoT instalado en el hogar (la interfaz física con la que interactúa la persona con discapacidad motora severa). Cada plataforma hereda la base cromática, tipográfica y de tono definida en las General Style Guidelines, pero adapta su comportamiento a las particularidades técnicas, el contexto de uso y, sobre todo, a las necesidades de accesibilidad de cada segmento de usuario.

En los tres casos, la prioridad no es la sofisticación visual sino la reducción del esfuerzo cognitivo y físico requerido para operar el sistema, dado que Alivia atiende a personas con movilidad severamente limitada y, en varios casos, dificultades visuales asociadas, además de cuidadores que muchas veces consultan la plataforma en momentos de estrés o mientras realizan otra tarea.

**Web Style Guidelines**:

La aplicación web de Alivia está construida en React y sirve a dos tipos de usuario con necesidades distintas: el familiar o cuidador, que revisa el estado del hogar y gestiona la red de cuidado desde una computadora, y el personal operativo (técnicos, administradores del negocio, responsables de planes), que utiliza la plataforma para instalación, soporte y gestión comercial. Las decisiones de estilo priorizan la lectura rápida del estado de los dispositivos, la jerarquía clara entre información rutinaria y alertas, y una estructura que se sostenga tanto en pantallas de escritorio como en tablets usadas en campo por los técnicos.

##### Sistema de cuadrícula y espaciado

La cuadrícula web de Alivia se apoya en un contenedor de ancho máximo que evita que el contenido se disperse en monitores anchos, y en la escala de espaciado de 4 px (`spacing-1` a `spacing-8`) definida en las General Style Guidelines, implementada como variables CSS para mantener coherencia entre vistas.

La organización de columnas varía según el tamaño de pantalla:

- En **escritorio**, se usa una distribución de varias columnas que permite mostrar simultáneamente el panel lateral de navegación, el estado de los dispositivos del hogar y el historial de eventos. El gutter entre bloques es de 24 px y los márgenes laterales del contenedor principal son de 32 px.
- En **tablet**, el panel lateral se reduce a una versión compacta con solo íconos, y el contenido principal pasa a dos columnas. Los márgenes bajan a 24 px y el gutter a 16 px.
- En **móvil/pantallas angostas** (cuando la web se consulta desde un navegador móvil), el layout se reorganiza en una sola columna, el panel lateral se convierte en un menú desplegable y los márgenes se reducen a 16 px.

El padding interno de los componentes sigue la escala definida: los botones primarios usan 12 px vertical y 22 px horizontal; los inputs, 12 px vertical y 14 px horizontal; las tarjetas de alerta o de estado de dispositivo, 16 px de padding interno con 16 px de margen externo entre ellas. La separación entre secciones del panel de supervisión es de 24 px, y entre bloques mayores de contenido, de 32 px.

##### Responsividad y adaptabilidad

La estrategia responsiva de la web de Alivia prioriza que el estado de los dispositivos del hogar y las alertas del cuidador permanezcan legibles y accionables en cualquier tamaño de pantalla, ya que estas son las dos secciones que más se consultan durante el uso diario.

**Comportamiento de componentes clave según el dispositivo:**

- El **panel de supervisión del hogar**, que muestra el estado de luces, puertas y ventanas, presenta una cuadrícula de tarjetas en escritorio (una por dispositivo, con ícono, estado y última actualización). En tablet se reorganiza en dos columnas. En móvil se apilan verticalmente, manteniendo siempre visible en la parte superior cualquier dispositivo con falla o batería baja, antes que los que están operando con normalidad.
- El **historial de eventos y alertas** se presenta como una tabla completa en escritorio (persona, dispositivo, prioridad, hora, estado). En tablet se ocultan las columnas de menor relevancia operativa y se habilita scroll horizontal. En móvil se convierte en una lista de tarjetas, una por evento, priorizando persona, necesidad y prioridad por sobre el resto de metadatos.
- El **panel lateral de navegación** permanece expandido con etiquetas de texto en escritorio. En tablet se colapsa a solo íconos. En móvil se oculta tras un botón de menú en el encabezado, usando la librería de íconos outline definida en la guía general, en 24 px.
- Los **formularios** de registro (persona asistida, red de cuidado, evaluación técnica de vivienda) usan dos columnas en escritorio y una sola columna a ancho completo en tablet y móvil. Las etiquetas emplean Outfit Regular en 13–14 px sobre el gris azulado claro (`#8890A3`), y los inputs respetan el padding de la escala de espaciado.

##### Tipografía en la interfaz web

La interfaz web aplica **Outfit** en todos sus niveles, siguiendo la escala definida en las General Style Guidelines:

- Los **títulos de sección y encabezados de página** (Headline) usan Outfit Semibold 600 entre 28 y 36 px, con altura de línea de 1.25×, en Azul Profundo (`#081745`) o Gris Azulado Oscuro (`#252F45`), para marcar con claridad en qué parte de la plataforma se encuentra el cuidador o el técnico.
- El **cuerpo de texto**, usado en descripciones de eventos, notas de cuidado y contenido informativo, emplea Outfit Regular 400 entre 16 y 18 px con altura de línea de 1.5×, en Gris Azulado Oscuro (`#252F45`) sobre fondos claros, cuidando un contraste amplio.
- Las **etiquetas**, metadatos de tabla y textos de ayuda usan Outfit Regular o Medium en 13–14 px con altura de línea de 1.4×. Los placeholders y textos secundarios emplean Gris Azulado Claro (`#8890A3`).
- Los **valores de estado críticos**, como el nivel de batería de un dispositivo o la prioridad de una alerta, se destacan en Outfit Semibold en tamaños de 16 a 24 px según su jerarquía, de modo que una alerta crítica se distinga de inmediato dentro del panel de supervisión.

##### Accesibilidad en la interfaz web

Dado que buena parte de la información que circula por la web de Alivia puede ser consultada bajo presión (una alerta de auxilio, una falla de dispositivo), la plataforma cumple estrictamente los criterios WCAG 2.1 nivel AA/AAA en toda su paleta:

- En **contraste cromático**, todo el texto de cuerpo sobre fondos claros supera el ratio 4.5:1, los encabezados grandes superan 3:1, y los íconos funcionales y bordes de componentes cumplen al menos 3:1 frente a su fondo.
- En **navegación por teclado**, todos los controles interactivos (confirmar alerta, editar rutina, filtrar historial) son accesibles mediante Tab en un orden que sigue el flujo lógico de la pantalla, con un indicador de foco visible en Turquesa (`#2EC4B6`) de 3 px de grosor.
- En **etiquetado semántico**, los íconos de estado de dispositivo llevan `aria-label` descriptivo ("puerta principal cerrada", "batería baja en luz de dormitorio"); las tablas de historial usan `role="columnheader"`; las alertas críticas emplean `role="alert"` para que un lector de pantalla las anuncie sin que el cuidador tenga que buscarlas; los modales de confirmación usan `role="dialog"` con `aria-modal="true"`.

##### Patrón Z en la interfaz web

El patrón Z describe el recorrido natural de la mirada al escanear una interfaz: de la esquina superior izquierda a la superior derecha, en diagonal hacia la inferior izquierda, y de ahí a la inferior derecha. Este recorrido se aprovecha en pantallas con estructura horizontal como el panel de supervisión del hogar (Zeldman, 2024).

En la web de Alivia, el patrón Z se distribuye así:

| Zona     | Posición          | Contenido asignado                                                                 | Justificación                                                                                          |
| -------- | ------------------ | ------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------- |
| Punto 1  | Superior izquierda | Logo de Alivia y nombre de la persona asistida activa                              | Ancla la identidad de marca y confirma de inmediato de quién se está viendo el hogar                     |
| Punto 2  | Superior derecha   | Ícono de notificaciones, perfil del cuidador y acceso rápido a alertas pendientes | Concentra los controles de mayor uso durante la sesión                                                   |
| Diagonal | Centro             | Estado de dispositivos del hogar y últimos eventos registrados                    | Zona de mayor densidad informativa, aprovechando el tránsito visual natural entre los puntos superiores |
| Punto 3  | Inferior izquierda | Panel de navegación con accesos a Perfiles, Actividades, Dispositivos, Reportes    | Organiza la navegación secundaria en la zona de llegada del primer trazo diagonal                       |
| Punto 4  | Inferior derecha   | Acción principal (confirmar alerta, registrar actividad) o resumen de estado       | Ubica la acción esperada en el punto donde concluye el recorrido visual                                 |

**Principios de aplicación:**

- Los elementos de mayor jerarquía (logo, identidad de la persona asistida, alertas críticas) se ubican en los extremos del eje horizontal superior, que son los primeros puntos que fija la mirada al abrir la plataforma.
- El contenido de mayor densidad, como el estado de los dispositivos o el historial de eventos, ocupa la zona central de la diagonal, donde el ojo se desplaza sin esfuerzo adicional.
- Las acciones primarias (confirmar una alerta, por ejemplo) se ubican en la esquina inferior derecha, reduciendo la distancia entre leer la información y actuar sobre ella, algo especialmente relevante cuando la alerta involucra una solicitud de auxilio.
- En las tarjetas de dispositivo o de evento, el patrón se replica a nivel de componente: el nombre del dispositivo y su estado ocupan la parte superior, mientras que la acción disponible (ver detalle, marcar como atendido) se ubica en la esquina inferior derecha de la tarjeta.

**Mobile Style Guidelines**:

La aplicación móvil de Alivia, desarrollada de forma nativa en Kotlin (Android) y Swift (iOS), es el canal principal del cuidador para supervisar remotamente el hogar, recibir alertas y coordinar el cuidado desde cualquier lugar. Las decisiones de diseño priorizan la rapidez de comprensión de una alerta, muchas veces recibida mientras el cuidador está en la calle o en clases y la comodidad de uso con una sola mano.

##### Paleta cromática y tipografía en móvil

La aplicación móvil reutiliza sin modificaciones la paleta de las General Style Guidelines. El Azul Marino (`#0F2A6B`) identifica elementos de navegación activos y acciones principales; el Turquesa (`#2EC4B6`) marca confirmaciones y estados de éxito; los tonos de alerta (definidos a nivel de sistema semántico) distinguen las notificaciones críticas de las informativas. Los fondos emplean Blanco (`#FFFFFF`) y Menta Claro (`#E6F8F5`) para paneles y tarjetas de estado.

La tipografía **Outfit** se empaqueta como fuente propia en ambas aplicaciones nativas, respetando los mismos pesos y tamaños definidos en la guía general:

- Outfit Semibold para títulos de pantalla y etiquetas de navegación activa; Outfit Regular para cuerpo de texto y descripciones de eventos.
- El tamaño de fuente respeta la configuración de accesibilidad del sistema operativo (Dynamic Type en iOS, ajuste de escala de fuente en Android), de modo que un cuidador con baja visión pueda aumentar el tamaño de texto sin que la interfaz se rompa.

##### Navegación y jerarquía visual

La navegación principal usa una **barra inferior** con acceso directo a las secciones de mayor frecuencia: Inicio, Dispositivos, Alertas, Agenda de cuidado y Perfil. Esta ubicación responde a que el cuidador suele revisar la app con una sola mano mientras hace otra cosa, por lo que los accesos deben estar al alcance del pulgar.

El ícono activo se presenta en Azul Marino (`#0F2A6B`) con etiqueta en Outfit Semibold de 12 px; los inactivos usan Gris Azulado Claro (`#8890A3`) con etiqueta en Outfit Regular. Todos los íconos siguen el estilo outline definido en la guía general.

Los accesos secundarios de menor frecuencia (configuración de dispositivos avanzada, gestión de turnos adicionales, ajustes de cuenta) se agrupan en un **menú lateral deslizante**, con opciones en Outfit Regular de 14 px e íconos alineados a la izquierda sobre fondo blanco, separados por líneas en Gris Azulado Claro.

El **encabezado de pantalla** muestra el título de la sección en Outfit Semibold de 16–18 px en Azul Profundo, sobre fondo blanco, e incluye el acceso al centro de notificaciones con un badge en el color de alerta cuando existen avisos sin confirmar. Al hacer scroll en listas largas (como el historial de actividades), el encabezado se contrae para dejar más espacio al contenido.

A diferencia de una app orientada a la creación frecuente de contenido, Alivia no centra su interacción en un botón de acción flotante genérico: la acción más relevante en cada pantalla (confirmar una alerta, registrar una actividad de cuidado) se resuelve dentro de la propia tarjeta o notificación, evitando que el cuidador tenga que buscar un control adicional en un momento donde cada segundo cuenta.

##### Interacciones táctiles y gestos

Las interacciones de la app móvil responden a las acciones que el cuidador realiza con más frecuencia:

- El **tap** confirma una alerta, abre el detalle de un dispositivo o accede a la agenda de cuidado. La respuesta visual es un efecto de tinta en el color primario, confirmando que la pulsación fue registrada.
- El **deslizamiento vertical** hacia abajo en el historial de eventos o en la lista de dispositivos activa la actualización de datos (pull-to-refresh), con un indicador de carga en Turquesa mientras se consulta el estado más reciente del hogar.
- El **deslizamiento horizontal** sobre una alerta o una actividad pendiente revela acciones rápidas como confirmar, posponer o reasignar, reduciendo los pasos necesarios frente a una notificación urgente.
- La **pulsación prolongada** sobre un dispositivo o un turno de cuidado abre un menú contextual con opciones adicionales, reservado para acciones que requieren una confirmación explícita, como desvincular un cuidador o reasignar una responsabilidad.
- Las transiciones entre pantallas siguen las convenciones nativas de cada sistema operativo (deslizamiento horizontal), manteniendo tiempos breves que no generen sensación de demora frente a una alerta que puede ser crítica.

##### Componentes visuales en móvil

Las **tarjetas de dispositivo** son el componente central del módulo de supervisión del hogar. Muestran el nombre del dispositivo (por ejemplo, "Luz del dormitorio") en Outfit Medium de 14 px, su estado actual y un badge de color que distingue estado operativo, advertencia (batería baja) o falla, siguiendo la paleta semántica del sistema. El fondo de la tarjeta es blanco con borde sutil y esquinas redondeadas, coherente con la estética general de Outfit.

Las **notificaciones de alerta** en la bandeja del cuidador se presentan con un borde lateral de color según su prioridad, siguiendo el criterio definido en Communication Tone & Language: las alertas críticas (por ejemplo, una solicitud de auxilio) usan el color de mayor urgencia y aparecen ancladas en la parte superior, por encima de recordatorios y notificaciones informativas. El título de la alerta emplea Outfit Semibold de 14 px, identificando primero a la persona asistida y luego la necesidad detectada; la descripción usa Outfit Regular de 13 px en Gris Azulado Claro, junto con la hora del evento.

Los **modales de confirmación** por ejemplo, al confirmar que se atendió una alerta o al desvincular un cuidador, se presentan centrados sobre un fondo semitransparente. Usan fondo blanco, título en Outfit Semibold de 16 px, descripción en Outfit Regular de 14 px, y botones que distinguen visualmente confirmar (Turquesa) de cancelar (Gris Azulado Oscuro), evitando ambigüedad en una acción que puede tener consecuencias sobre el cuidado de la persona asistida.

**Devices Style Guidelines**:

El dispositivo IoT de Alivia (el cubo instalado en el hogar con micrófono, miniparlante e indicadores LED) es la única interfaz que usa directamente la persona con discapacidad motora severa, ya que su interacción es exclusivamente por voz. Aquí las "guías de estilo" no describen pantallas sino el lenguaje de señales sonoras y luminosas que el dispositivo usa para comunicarse, dado que no existe una interfaz gráfica que el usuario final pueda consultar.

##### Señalización luminosa (indicadores LED)

El cubo cuenta con indicadores LED que comunican su **estado operativo general** sin necesidad de que la persona asistida mire una pantalla, algo especialmente relevante considerando la comorbilidad visual frecuente en este segmento (ver Capítulo 1). Los LED no confirman el resultado de un comando de voz (eso corresponde al altavoz) sino que informan de forma continua en qué condición se encuentra el dispositivo. Los estados se codifican por color y patrón de parpadeo, nunca solo por color, para no depender de la percepción cromática:

| Estado del dispositivo   | Color del LED   | Patrón                      | Significado para la persona asistida                                  |
| ------------------------- | ---------------- | ----------------------------- | -------------------------------------------------------------------------- |
| Disponible / en espera    | Turquesa          | Fijo, brillo bajo             | El dispositivo está listo para recibir un comando de voz                  |
| Escuchando un comando     | Turquesa          | Pulso suave (fade in/out)     | El dispositivo detectó el inicio de una instrucción y la está procesando  |
| Batería de respaldo baja  | Ámbar/Amarillo    | Parpadeo lento y sostenido    | Advierte que la energía de respaldo se está agotando                       |
| Falla o desconexión       | Rojo              | Parpadeo rápido               | El dispositivo perdió una función esencial y ya alertó al cuidador         |

Este código de color y parpadeo se mantiene idéntico en todos los dispositivos instalados en una misma vivienda, para que la persona asistida no tenga que memorizar variaciones entre el cubo del dormitorio y el de la sala.

##### Señalización sonora (miniparlante)

El resultado de cada comando de voz (si la acción se ejecutó, si no pudo completarse o si el sistema no comprendió la instrucción) se comunica exclusivamente mediante el miniparlante, ya que es el único canal capaz de confirmar sin ambigüedad lo que ocurrió con la acción solicitada. Esta decisión sigue directamente los principios de Communication Tone & Language: respuestas breves, directas y sin alarmismo, incluso en escenarios de falla.

- Las **confirmaciones de acción exitosa** ("Listo, la puerta está abierta") se reproducen en un tono neutro y sereno, siguiendo el Body tone definido en la guía general, sin efectos sonoros adicionales que puedan confundirse con una alerta.
- El **comando no reconocido** se comunica con una frase corta y sin tono de reproche ("No entendí, ¿puedes repetirlo?"), reforzando el principio de respeto por la autonomía de la persona asistida.
- Las **fallas de ejecución** (por ejemplo, una puerta atascada) se informan de inmediato por voz, indicando que la acción no pudo completarse y que se avisó al cuidador, sin dejar a la persona asistida sin retroalimentación sobre lo ocurrido.
- Las **confirmaciones de auxilio** ("Se avisó a tu cuidador, ya viene en camino") priorizan la calma y la claridad sobre la urgencia, evitando cualquier sonido que pueda generar más ansiedad en un momento de necesidad real.
- El **volumen y la velocidad de habla** del dispositivo son configurables por el cuidador durante la instalación, considerando que las condiciones auditivas y el tamaño de la habitación varían de un hogar a otro.

##### Interacción por voz

El dispositivo no cuenta con botones físicos de uso primario ni pantalla; toda la interacción de la persona asistida ocurre mediante frases clave, siguiendo el patrón de Intent Mapping definido en el diseño arquitectónico (ver Capítulo 4):

- Las **frases de activación** son cortas, en lenguaje cotidiano y sin variantes técnicas, de modo que resulten fáciles de recordar y pronunciar incluso para personas con fatiga vocal.
- El dispositivo **nunca ejecuta una acción física sin antes confirmar por voz** que la completó, siguiendo la táctica de Confidence Threshold y Safe Default: ante duda o baja confianza en el reconocimiento, se abstiene de actuar y pide repetir la instrucción, en lugar de arriesgar una acción no solicitada.
- La **frase de auxilio** se trata de forma diferenciada del resto de comandos: cualquier expresión reconocida como solicitud de ayuda activa de inmediato el flujo de alerta crítica hacia el cuidador, sin esperar confirmaciones adicionales que puedan retrasar la asistencia.

##### Coherencia física del dispositivo

El diseño físico del cubo sigue la misma lógica de calidez y confianza que el resto de la marca: formas redondeadas (coherentes con la geometría de la tipografía Outfit), acabado mate que evite reflejos molestos para personas con baja visión, y un tamaño que permita ubicarlo cerca de la cama o el área de mayor permanencia de la persona asistida sin resultar intrusivo en la decoración del hogar. El logotipo de Alivia, en su versión reducida (solo el isotipo del corazón), se ubica de forma discreta en la base del dispositivo, manteniendo la identidad de marca sin competir visualmente con los indicadores LED, que son el elemento funcional prioritario.

## 6.2. Information Architecture

En esta sección el equipo de Alivia presenta las decisiones y fundamentos relacionados con la organización del contenido dentro de las experiencias web y móvil, incluyendo la Landing Page, las aplicaciones del sistema y las señales del dispositivo IoT instalado en el hogar. El objetivo es garantizar que los usuarios puedan interactuar de manera intuitiva con la plataforma, accediendo de forma rápida y sencilla a las funcionalidades, la información y los recursos que necesitan. Dado que Alivia atiende a personas con discapacidad motora severa, con posibles dificultades visuales asociadas, y a cuidadores que muchas veces consultan la plataforma bajo presión o mientras realizan otra tarea, cada decisión prioriza la claridad, la reducción de la carga cognitiva y la rapidez de comprensión por sobre consideraciones puramente estéticas. Asimismo, se detallan las decisiones tomadas respecto a los Organization Systems, Labeling Systems, Searching Systems, SEO Tags & Meta Tags y Navigation Systems, alineadas con el Ubiquitous Language y las User Stories definidas en los capítulos anteriores.

### 6.2.1. Organization Systems

Alivia utiliza un esquema de organización que combina tres tipos principales de ordenamiento: jerárquico, secuencial y categórico. Cada uno responde a una necesidad distinta del usuario y permite presentar la información de forma clara y alineada con los roles de las diferentes audiencias: el visitante, la persona asistida (que interactúa por voz con el dispositivo), el familiar o cuidador, el técnico y el administrador del negocio.

#### Organización visual jerárquica

En Alivia, la organización jerárquica prioriza visualmente la información crítica para la seguridad y la autonomía de la persona asistida: las solicitudes de auxilio, las alertas críticas pendientes de confirmación, las fallas de dispositivos y las advertencias de batería baja. Esta jerarquía garantiza que el cuidador identifique de inmediato qué requiere su atención antes de revisar información rutinaria como el historial de eventos o las métricas de autonomía, facilitando una toma de decisiones rápida, incluso cuando consulta la plataforma desde la calle o en clases.

Representación de la arquitectura jerárquica:

<p align="center">Organización en el landing page</p>
<div style="display: flex; align-items: center;">
  <img src="https://imgur.com/cQXpcIP.png" alt="landingpage_organization">
</div>

Esta estructura representa la jerarquía informativa orientada al usuario externo. Guía el recorrido desde la propuesta de valor, pasando por el equipo, la solución y los beneficios diferenciados para la persona asistida y el cuidador, hasta culminar en la conversión mediante la comparación de planes y el paso a la contratación en la aplicación web.

<p align="center">Organización de la app web/móvil de la vista del familiar o cuidador</p>
<div style="display: flex; align-items: center;">
  <img src="https://imgur.com/c2Cj63r.png" alt="front_organization">
</div>

Este esquema detalla la arquitectura interna de la aplicación del familiar o cuidador. La organización jerárquica parte de un Inicio que resume el estado general del hogar y ramifica el acceso hacia los módulos operativos clave: la gestión del hogar y la red de cuidado, los dispositivos, las alertas, la agenda de cuidado, el soporte técnico y las métricas de autonomía.

<p align="center">Organización de la app web/móvil de la vista del técnico</p>
<div style="display: flex; align-items: center;">
  <img src="https://imgur.com/NCJ06v9.png" alt="technical_organization">
</div>

Este esquema detalla la arquitectura interna de la aplicación del técnico o instalador, disponible tanto en web como en móvil para su uso en campo. La organización jerárquica parte de un punto de entrada que resume las órdenes asignadas (evaluaciones, instalaciones e incidencias) y ramifica el acceso hacia los módulos operativos: la evaluación de vivienda, la instalación de dispositivos y el mantenimiento.

<p align="center">Organización de la app web de la vista del administrador del negocio</p>
<div style="display: flex; align-items: center;">
  <img src="https://imgur.com/a3ncGmL.png" alt="business_organization">
</div>

Este esquema detalla la arquitectura interna de la aplicación web empresarial, utilizada por el administrador del negocio y el responsable de planes y suscripciones. La organización jerárquica parte de un Dashboard central con las métricas del negocio y ramifica el acceso hacia los módulos de planes y suscripciones, personal, operaciones técnicas, dispositivos, y roles y permisos.

Casos de aplicación:

- Pantalla de Inicio donde las alertas pendientes y el estado general del hogar aparecen en la parte superior, por encima de las próximas actividades.
- Vistas de dispositivos donde badges de color, íconos outline y tipografía Outfit Semibold jerarquizan el estado de cada dispositivo (operativo, batería baja o falla), mostrando primero los que requieren atención.
- Bandeja de alertas donde las solicitudes de auxilio y las alertas críticas se anclan en la parte superior, por encima de recordatorios y notificaciones informativas.
- Vista del técnico donde las órdenes asignadas (evaluaciones, instalaciones, incidencias) aparecen priorizadas por fecha y urgencia, antes que el historial de órdenes ya completadas.
- Dashboard del administrador donde las métricas críticas del negocio (suscripciones vencidas, incidencias abiertas) se muestran en la parte superior, por encima de las métricas de desempeño general.

#### Organización secuencial

Alivia también aplica una organización secuencial en procesos que requieren una progresión lógica y una guía paso a paso, especialmente en los flujos de contratación y en aquellos donde el orden de las acciones impacta en la seguridad o la trazabilidad del cuidado.

Casos de aplicación:

- **Contratación del servicio:** registro del responsable y creación de la cuenta del hogar, selección del plan y la periodicidad, autorización temporal del importe, selección del horario de evaluación técnica, resultado técnico (viable, parcialmente viable o no viable) e instalación y activación con conformidad del cliente (US05 a US11).
- **Onboarding del hogar:** completar el perfil del hogar con una ubicación validada, registrar a la persona asistida e invitar a los cuidadores de la red de cuidado, antes de que la persona asistida empiece a usar el sistema por sí misma (US42, US12, US13).
- **Gestión de una alerta crítica:** recepción de la alerta, confirmación por parte del cuidador, inicio de la atención y registro del resultado (resuelta), con repeticiones automáticas cada dos minutos hasta un máximo de tres si no hay confirmación (US24).
- **Transferencia de responsabilidad entre turnos:** finalización del turno, aceptación del relevo por el siguiente cuidador y entrega del resumen de actividades, medicamentos y alertas pendientes (US27).
- **Reporte de una falla:** descripción del problema, adjunto de evidencia fotográfica, selección de un horario técnico disponible y seguimiento hasta la resolución (US31).
- **Interacción por voz de la persona asistida:** emisión del comando, confirmación audible de la acción y notificación de falla al cuidador cuando el dispositivo no responde (US18 a US20).
- **Atención de una orden técnica:** recepción de la orden asignada, evaluación o instalación en sitio, registro de resultados y pruebas, y cierre con conformidad o incidencia registrada (US09, US11, US32).
- **Configuración de un empleado:** registro del empleado, asignación de su contrato, configuración de su horario laboral y habilitación para asignaciones según su disponibilidad calculada (US43 a US46).

Al agrupar estos casos bajo el concepto de organización secuencial, se refuerza la idea de que el sistema debe guiar al usuario sin saltos ni confusiones, con estados intermedios visibles en cada paso, sobre todo en momentos de alta sensibilidad como una solicitud de auxilio.

#### Esquemas de categorización de contenido

Para gestionar el volumen de información y facilitar el acceso rápido a los datos relevantes, Alivia implementa esquemas de categorización que combinan criterios cronológicos, temáticos y por audiencia.

- **Organización cronológica:** se utiliza para el historial de eventos de los dispositivos, el historial de alertas, la agenda de cuidado, los recordatorios y el historial de administración de medicamentos, presentando siempre los eventos más recientes o próximos en primer plano.
- **Organización por tópicos:** agrupa la información según su naturaleza: dispositivos del hogar (luz, puerta, ventana y dispositivo de interacción por voz), alertas (críticas, técnicas e informativas), actividades de cuidado (alimentación, higiene, movilización y medicación) y soporte técnico.
- **Organización por audiencia:** separa las vistas y funciones según los perfiles reales del sistema: visitante, familiar o cuidador, técnico, administrador del negocio y responsable de planes y suscripciones.

Esta categorización por audiencias permite que cada perfil vea únicamente la información relevante para su rol:

- **Visitante:** Landing Page con propuesta de valor, solución, beneficios, testimonios y planes.
- **Familiar o cuidador:** supervisión del hogar, alertas, agenda de cuidado, dispositivos, soporte y métricas de autonomía.
- **Técnico:** gestión de visitas de evaluación e instalación, registro de compatibilidad, dispositivos, pruebas y conformidad, y atención de incidencias.
- **Administrador del negocio y responsable de planes y suscripciones:** gestión de planes, suscripciones, empleados, contratos, horarios, dispositivos, órdenes técnicas, trazabilidad y métricas globales del negocio.

La persona con discapacidad motora severa no interactúa con estas vistas: su interfaz es exclusivamente el dispositivo de voz, organizado mediante frases clave asociadas a acciones (luz, puerta, ventana y auxilio) y respuestas sonoras.

#### Segmentación por roles y audiencias

Además de los criterios anteriores, Alivia distingue claramente entre los perfiles disponibles en la plataforma, aplicando los principios de autorización por responsabilidad (RBAC) definidos en la arquitectura. La segmentación refuerza que:

- los cuidadores visualizan herramientas de supervisión remota, alertas escritas, coordinación de turnos y actividades de cuidado, y métricas de autonomía;
- los técnicos acceden a las herramientas de evaluación, instalación y mantenimiento de dispositivos;
- los administradores acceden a la gestión operativa y comercial del servicio, incluyendo planes, suscripciones, capital humano y trazabilidad de operaciones.

Con este enfoque, cada perfil obtiene una experiencia ajustada a su rol y sus responsabilidades, reduciendo la complejidad, protegiendo la información de la persona asistida y mejorando la eficacia en la toma de decisiones.

### 6.2.2. Labeling Systems

En esta sección se presenta el sistema de etiquetado (labeling system) de la plataforma Alivia. Este sistema prioriza la claridad y la sencillez del lenguaje, utilizando términos familiares y alineados con el Ubiquitous Language del proyecto (persona asistida, cuidador, solicitud de asistencia, autonomía, alerta crítica), evitando anglicismos innecesarios y expresiones que puedan sonar ambiguas o condescendientes hacia la persona con discapacidad. Se mantiene el tono de comunicación definido en las Style Guidelines: claro, sereno, respetuoso y orientado a la acción, con la calidez suficiente para no sonar a manual técnico.

#### A. Landing Page

El etiquetado en el sitio público utiliza un lenguaje directo, cercano y coherente con la propuesta de valor de Alivia.

- **Secciones de navegación:**
    - **Inicio:** Sección de bienvenida con la propuesta de valor y el video del producto.
    - **Nosotros:** Misión, visión y equipo detrás de Alivia.
    - **Solución:** Explicación del control por voz, la operación sin Internet, las alertas al cuidador y los dispositivos incluidos.
    - **Beneficios:** Ventajas diferenciadas para la persona asistida y para el cuidador.
    - **Testimonios:** Experiencias de personas relacionadas con Alivia y respaldo del equipo.
    - **Planes:** Comparación de planes, precios, periodicidad y aplicaciones disponibles.
- **Botones de llamada a la acción (CTA):**
    - **"Conocer Alivia":** Dirige a la explicación de la solución y sus beneficios.
    - **"Ver planes":** Lleva a la comparación de planes disponibles.
    - **"Contratar":** Redirige a la aplicación web para iniciar la contratación (sin pagar en la landing).
    - **"Descargar la app":** Muestra la disponibilidad de la aplicación para Android e iOS.
    - **"Iniciar sesión":** Acceso a la plataforma para usuarios registrados.

#### B. Aplicación Web del Cuidador

La aplicación web del cuidador está dirigida al familiar o cuidador, que revisa el estado del hogar y gestiona la red de cuidado:

- **Inicio:** Resumen del estado del hogar, alertas pendientes y próximas actividades.
- **Mi hogar:** Perfil del hogar, persona asistida y red de cuidado.
- **Contratación:** Selección de plan, autorización del importe, horario de evaluación técnica y resultado técnico.
- **Dispositivos:** Estado de conexión, batería y funcionamiento, e historial de eventos.
- **Alertas:** Alertas escritas, confirmación y atención de alertas críticas, y solicitudes de auxilio.
- **Agenda de cuidado:** Turnos, transferencia de responsabilidad, actividades, medicamentos y recordatorios.
- **Soporte:** Reporte de fallas, evidencias y seguimiento de incidencias.
- **Autonomía:** Métricas de acciones solicitadas y realizadas por la persona asistida.
- **Perfil:** Datos personales, preferencias de comunicación, recuperación de acceso y cierre de sesión.

#### C. Aplicación Web del Negocio

La aplicación web del negocio está dirigida al personal de Alivia, y el etiquetado se adapta según el rol:

- **Administrador del negocio y responsable de planes y suscripciones:**
    - **Métricas:** Indicadores comerciales y operativos globales.
    - **Planes:** Gestión de planes, precios y condiciones comerciales.
    - **Suscripciones:** Consulta y gestión del ciclo de vida de las suscripciones de cada hogar.
    - **Empleados:** Registro de personal, contratos y horarios laborales.
    - **Órdenes técnicas:** Asignación de técnicos y reserva de dispositivos.
    - **Dispositivos:** Inventario y asignación de dispositivos a viviendas.
    - **Trazabilidad:** Historial de operaciones técnicas.
- **Técnico:**
    - **Visitas:** Agenda de evaluaciones e instalaciones asignadas.
    - **Evaluación:** Registro de compatibilidad de puertas, ventanas, iluminación y conectividad.
    - **Instalación:** Instalación, pruebas y conformidad del cliente.
    - **Incidencias:** Atención de fallas, mantenimiento y reemplazo de dispositivos.

*Nota de consistencia:* Las etiquetas compartidas entre las webs y la app móvil (**Inicio, Dispositivos, Alertas y Perfil**) mantienen el mismo nombre y significado en todas las vistas, para evitar que el usuario tenga que aprender términos distintos para una misma función.

#### D. Aplicación Móvil

Diseñada para la supervisión rápida y el uso con una sola mano, la aplicación móvil del cuidador usa etiquetas cortas y orientadas a la acción en su barra de navegación inferior:

- **Inicio:** Resumen del estado del hogar y alertas pendientes.
- **Dispositivos:** Estado de conexión, batería y funcionamiento de cada dispositivo.
- **Alertas:** Centro de notificaciones escritas, con prioridad y confirmación de alertas críticas.
- **Agenda:** Turnos, actividades, medicamentos y recordatorios del cuidado.
- **Perfil:** Datos personales, preferencias y ajustes de cuenta.

Los accesos de menor frecuencia (soporte, autonomía, gestión de la red de cuidado y ajustes avanzados) se agrupan en un menú lateral deslizante con etiquetas como **Soporte**, **Autonomía**, **Mi hogar** y **Configuración**.

#### E. Dispositivo IoT

El dispositivo no cuenta con pantalla ni indicadores luminosos, por lo que su "etiquetado" se compone exclusivamente de frases de voz. Se mantiene la coherencia con el tono definido: breve, sereno y sin alarmismo.

- **Frases de interacción (ejemplos):**
    - **"Enciende la luz" / "Apaga la luz":** Control de la iluminación.
    - **"Abre la puerta" / "Cierra la puerta":** Control de la puerta.
    - **"Abre la ventana" / "Cierra la ventana":** Control de la ventana.
    - **"Necesito ayuda" (o expresión de auxilio reconocida):** Genera de inmediato una alerta crítica al cuidador.
- **Respuestas del dispositivo (ejemplos):**
    - **"Listo, la luz de tu cuarto está encendida.":** Confirmación de acción exitosa.
    - **"No entendí, ¿puedes repetirlo?":** Comando no reconocido o con baja confianza.
    - **"La puerta no respondió. Avisamos a tu cuidador para revisarla.":** Falla de ejecución.
    - **"Se avisó a tu cuidador, ya viene en camino.":** Confirmación de solicitud de auxilio.
    - **"Estoy listo para escucharte." (al iniciar o tras completar una acción):** Confirma por voz que el dispositivo está disponible para recibir un nuevo comando.
    - **"Mi batería de respaldo está baja, avisamos a tu cuidador.":** Advertencia de batería baja, comunicada por voz en lugar de una señal visual.

#### F. Etiquetas en Formularios y Botones Operativos

Se definen etiquetas estándar para campos de entrada y acciones frecuentes, con la intención de reducir la carga cognitiva en todas las plataformas.

- **Campos de formulario:**
    - **"Nombre completo":** Identificación del usuario o de la persona asistida.
    - **"Correo electrónico":** Credencial de acceso o contacto.
    - **"Contraseña":** Campo seguro para el acceso del usuario.
    - **"Código de verificación":** Código de un solo uso enviado al correo para activar la cuenta o validar el ingreso.
    - **"Alias del hogar":** Nombre con el que se identifica la vivienda.
    - **"Dirección del hogar":** Ubicación validada mediante Google Maps.
    - **"Teléfono de contacto":** Número de contacto del hogar.
    - **"Nombre del medicamento":** Medicamento previamente indicado por un profesional de salud.
    - **"Horario":** Momento programado de una actividad o medicamento.
    - **"Descripción de la falla":** Texto libre para reportar un problema con un dispositivo.
- **Botones de acción:**
    - **"Crear cuenta":** Registra al responsable de la contratación.
    - **"Continuar":** Avanza al siguiente paso de un flujo secuencial.
    - **"Autorizar importe":** Confirma la retención temporal del importe, sin activar la suscripción.
    - **"Reservar horario":** Confirma el bloque para la evaluación técnica.
    - **"Invitar cuidador":** Envía una invitación para vincular a un cuidador al hogar.
    - **"Confirmar alerta":** Registra la recepción de una alerta y detiene sus repeticiones.
    - **"Iniciar atención":** Indica que el cuidador comienza a atender una alerta.
    - **"Marcar como resuelta":** Cierra la alerta y conserva el resultado de la intervención.
    - **"Registrar administración":** Deja constancia de que un medicamento fue administrado u omitido.
    - **"Aceptar relevo":** Confirma la transferencia de responsabilidad al finalizar un turno.
    - **"Reportar falla":** Crea una incidencia asociada con el dispositivo afectado.
    - **"Adjuntar foto":** Añade evidencia fotográfica a un reporte.
    - **"Guardar cambios":** Confirma la edición de un perfil o configuración.
    - **"Cerrar sesión":** Finaliza la sesión de forma segura.

### 6.2.3. Searching Systems

En Alivia, los sistemas de búsqueda se definen de acuerdo con las funcionalidades establecidas en las User Stories del Capítulo 3, especialmente en los flujos de supervisión de dispositivos, historial de eventos, alertas, agenda de cuidado, incidencias y administración del negocio. Por ello, la propuesta se centra en mecanismos de búsqueda simples y filtros operativos concretos, evitando funcionalidades avanzadas no contempladas en el alcance del producto.

El objetivo principal es que el usuario encuentre rápidamente registros existentes para ejecutar sus tareas (consultar, confirmar, atender, reprogramar o reportar) sin sentirse abrumado por el volumen de información, algo especialmente relevante para un cuidador que consulta la plataforma bajo presión o mientras realiza otra actividad.

#### 6.2.3.1. Medios de ayuda para la búsqueda

Para apoyar al usuario durante la consulta de datos, la interfaz incorpora ayudas directas:

- **Campo de búsqueda visible por módulo:** ubicado en la parte superior de listas o tablas, con textos guía como "Buscar dispositivo", "Buscar alerta" o "Buscar actividad".
- **Filtros básicos de contexto:** controles de selección por estado, prioridad, persona asistida, dispositivo o rango de fechas, según el módulo.
- **Indicador de resultados:** mensaje de apoyo como "Mostrando X resultados" para confirmar que la búsqueda fue aplicada.
- **Acción "Limpiar":** permite quitar el texto y los filtros seleccionados para volver al listado completo.
- **Estado sin resultados:** mensaje claro y sereno, como "No encontramos registros con esos criterios", invitando a cambiar el término ingresado o ajustar los filtros, sin alterar la información existente.
- **Prioridad visual en resultados:** las alertas críticas y los dispositivos con falla se muestran primero en los resultados, para que la urgencia se note incluso sin depender solo del color.

Estas ayudas siguen el tono de comunicación definido en Alivia: claro, directo, sereno y orientado a la acción.

#### 6.2.3.2. Opciones de búsqueda por aplicación

| Plataforma | Tipo de búsqueda | Alcance |
| --- | --- | --- |
| Landing Page | Navegación por secciones (anclas y menú) | Permite ubicar contenido informativo (solución, beneficios, testimonios, planes) sin un motor de búsqueda dedicado |
| Aplicación web | Búsqueda textual por módulo + filtros básicos | Permite localizar registros en listas y tablas según las tareas del cuidador, el técnico y el administrador |
| Aplicación móvil | Búsqueda textual por pantalla + filtros simplificados | Permite consultar los datos clave del hogar y las alertas con interacción táctil y uso con una sola mano |
| Dispositivo IoT | No aplica búsqueda textual | La persona asistida interactúa únicamente mediante frases de voz asociadas a acciones (Intent Mapping); el dispositivo comunica su estado exclusivamente por voz, sin flujo de búsqueda manual |

#### 6.2.3.3. Filtros definidos por módulo (alineados a User Stories)

| Módulo | Búsqueda textual | Filtros disponibles |
| --- | --- | --- |
| Dispositivos (US30, US22) | Nombre o ubicación del dispositivo | Estado (operativo, batería baja, falla, desconectado), tipo (luz, puerta, ventana, voz), rango de fechas del evento |
| Historial de eventos (US22) | Dispositivo o tipo de evento | Rango de fechas, severidad, resultado |
| Alertas (US23, US24, US25) | Persona asistida o necesidad | Prioridad (crítica, informativa), estado (pendiente, confirmada, en atención, resuelta, pendiente crítica), rango de fechas |
| Agenda de cuidado (US26, US28, US36) | Actividad o cuidador | Tipo (turno, alimentación, higiene, movilización), estado (programada, completada, pendiente, vencida), fecha |
| Medicamentos (US29, US37) | Nombre del medicamento | Estado de administración (administrada, omitida, pendiente, vencida), horario, responsable |
| Red de cuidado (US13) | Nombre o correo del cuidador | Estado (invitación pendiente, vinculado), rol |
| Soporte e incidencias (US31, US32) | Dispositivo o descripción de la falla | Estado (abierta, programada, resuelta), rango de fechas |
| Autonomía (US41) | No aplica búsqueda textual | Dispositivo, periodo, resultado (exitosa, fallida, rechazada por baja confianza, sin confirmación) |
| Planes y suscripciones (US33, US38) | Hogar, plan o responsable de pago | Estado de la suscripción, plan, periodicidad |
| Empleados y disponibilidad (US43 a US46) | Nombre o documento del empleado | Cargo, especialidad, zona, tipo de servicio, estado del contrato |
| Órdenes y trazabilidad técnica (US34, US35) | Hogar, orden o dispositivo | Tipo de servicio (evaluación, instalación, incidencia), estado, periodo, técnico asignado |
| Métricas de negocio (US39, US40) | No aplica búsqueda textual | Periodo, plan, estado de la contratación |

#### 6.2.3.4. Visualización de resultados después de la búsqueda

Después de aplicar búsqueda o filtros, los datos se muestran manteniendo el mismo formato base de cada módulo:

- **Web:** tablas o listas con columnas clave (persona asistida, dispositivo, prioridad, hora, estado), con desplazamiento horizontal en tablet cuando se ocultan columnas de menor relevancia.
- **Móvil:** tarjetas o listas resumidas que priorizan persona, necesidad y prioridad, con acceso al detalle y acciones rápidas por gesto (confirmar, posponer o reasignar).
- **Consistencia de estado:** siempre se muestra si la búsqueda devolvió resultados, si no hubo coincidencias o si se debe limpiar o ajustar los filtros.
- **Información desactualizada:** cuando la vivienda perdió la conexión, los resultados indican la fecha de la última actualización y advierten que pueden existir eventos pendientes de sincronización (US22).

Comportamientos esperados:

- **Con resultados:** se visualiza el subconjunto filtrado junto con el contador de coincidencias.
- **Sin resultados:** se muestra un estado vacío con mensaje orientativo, sin alterar la información registrada.
- **Al limpiar filtros:** se restaura el listado completo del módulo.

#### 6.2.3.5. Criterio de alcance funcional

El sistema de búsqueda propuesto no introduce funcionalidades complejas adicionales (por ejemplo, búsqueda semántica, recomendaciones inteligentes o consultas predictivas), ya que no forman parte de los requerimientos funcionales priorizados en el Capítulo 3. Tampoco se contempla la búsqueda por voz dentro de las aplicaciones, pues la interacción por voz está reservada a la persona asistida y al control de dispositivos. De esta manera, la sección se mantiene consistente con el backlog del producto y con los flujos de uso definidos para la versión actual de Alivia.

### 6.2.4. SEO Tags & Meta Tags

Con el objetivo de mejorar el posicionamiento orgánico de **Alivia** en los motores de búsqueda y facilitar que familiares, cuidadores y personas con discapacidad motora severa encuentren una solución que les devuelva autonomía en el hogar, se ha definido la siguiente estrategia de etiquetado HTML. El contenido está redactado en español, con un tono claro, sereno y respetuoso, coherente con las Style Guidelines, y se apoya en términos que el segmento objetivo realmente utiliza al buscar soluciones de asistencia.

**Landing Page**

- **Title:**
  `<title>Alivia | Autonomía en el hogar para personas con discapacidad motora</title>`

    - **Propósito:** Incluye el nombre de la marca y las palabras clave de mayor relevancia ("autonomía", "hogar", "discapacidad motora"), comunicando de inmediato a quién está dirigida la solución.
- **Meta Description:**
  `<meta name="description" content="Alivia permite a personas con discapacidad motora severa controlar luces, puertas y ventanas con su voz, incluso sin Internet. Los cuidadores reciben alertas escritas y supervisan el hogar desde su celular. Conoce nuestros planes.">`

    - **Propósito:** Explica el funcionamiento (control por voz), el diferencial (operación sin Internet) y el beneficio para el cuidador (alertas y supervisión remota), incitando al clic con una propuesta de valor clara.
- **Meta Keywords:**
  `<meta name="keywords" content="Alivia, discapacidad motora, autonomía en el hogar, control por voz, domótica accesible, casa inteligente accesible, cuidador, persona asistida, asistencia tecnológica, funciona sin internet, Perú">`

    - **Propósito:** Agrupa términos que los familiares y cuidadores utilizan para buscar soluciones de asistencia tecnológica y domótica accesible en el mercado peruano.
- **Meta Author:**
  `<meta name="author" content="Equipo Alivia – Tecnología accesible para la autonomía en el hogar">`

---

**Web Application – Panel del Familiar o Cuidador**

- **Title:**
  `<title>Panel de cuidado – Alivia | Supervisión del hogar y alertas en tiempo real</title>`

    - **Propósito:** Enfocado en la utilidad de la herramienta. "Supervisión del hogar" y "alertas" refuerzan que la aplicación web es una consola de seguimiento activa para el cuidador.
- **Meta Description:**
  `<meta name="description" content="Accede a tu panel de Alivia. Consulta el estado de los dispositivos del hogar, confirma alertas críticas, organiza turnos y actividades de cuidado, y revisa las métricas de autonomía de la persona asistida.">`

    - **Propósito:** Resume las funciones principales del panel (estado de dispositivos, alertas, agenda de cuidado y autonomía) para usuarios que ya conocen la plataforma.
- **Meta Keywords:**
  `<meta name="keywords" content="panel de cuidado, supervisión remota, alertas de auxilio, agenda de cuidado, estado de dispositivos, red de cuidado, métricas de autonomía, gestión de turnos de cuidado">`

    - **Propósito:** Palabras clave específicas del entorno de trabajo del cuidador, que ayudan a la indexación de las secciones públicas de la herramienta.
- **Meta Author:**
  `<meta name="author" content="Equipo de Desarrollo Alivia, 2026">`

---

**Web Application – Plataforma Empresarial (Administradores)**

- **Title:**
  `<title>Gestión operativa – Alivia | Evaluaciones, instalaciones y suscripciones</title>`

    - **Propósito:** Identifica el uso interno de la plataforma por parte del personal de Alivia y resume sus módulos principales.
- **Meta Description:**
  `<meta name="description" content="Plataforma empresarial de Alivia para administrar planes, suscripciones, empleados, órdenes técnicas, evaluaciones de vivienda, instalaciones y mantenimiento de dispositivos.">`

    - **Propósito:** Resume las funciones operativas y comerciales del entorno empresarial para el personal autorizado.
- **Meta Keywords:**
  `<meta name="keywords" content="gestión de suscripciones, órdenes técnicas, evaluación de vivienda, instalación de dispositivos, administración de empleados, trazabilidad operativa, métricas de negocio">`

    - **Propósito:** Términos asociados a la operación interna del servicio.
- **Meta Robots:**
  `<meta name="robots" content="noindex, nofollow">`

    - **Propósito:** Al tratarse de una plataforma de uso interno, se excluye de la indexación de los motores de búsqueda para proteger la información operativa y comercial.

---

**Mobile Application – Android (Vista de Monitoreo del Cuidador)**

- **Title:** `<title>Alivia para Android | Alertas y cuidado del hogar en tu bolsillo</title>`
    - **Propósito:** Resalta la portabilidad y la inmediatez, e identifica la plataforma Android para quien busca la app en ese ecosistema.
- **Meta Description:** `<meta name="description" content="Descarga Alivia para Android. Recibe alertas escritas de rápida lectura, confirma solicitudes de auxilio y consulta el estado de los dispositivos del hogar desde tu celular. Alivia te mantiene al tanto sin dejar tus responsabilidades.">`
    - **Propósito:** Se enfoca en las capacidades exclusivas del móvil: notificaciones push, alertas escritas y supervisión remota.
- **Meta Keywords:** `<meta name="keywords" content="app para cuidadores, app Android, Alivia Android, notificaciones de auxilio, alertas push, supervisión del hogar, monitoreo de dispositivos, agenda de cuidado, Alivia">`
    - **Propósito:** Atrae a usuarios de Android que buscan aplicaciones de apoyo al cuidado y monitoreo remoto.
- **Meta Author:** `<meta name="author" content="Equipo de Desarrollo Mobile – Alivia, 2026">`

**Mobile Application – iOS (Vista de Monitoreo del Cuidador)**

- **Title:** `<title>Alivia para iOS | Alertas y cuidado del hogar en tu bolsillo</title>`
- **Meta Description:** `<meta name="description" content="Descarga Alivia para iPhone. Recibe alertas escritas de rápida lectura, confirma solicitudes de auxilio y consulta el estado de los dispositivos del hogar desde tu celular. Alivia te mantiene al tanto sin dejar tus responsabilidades.">`
- **Meta Keywords:** `<meta name="keywords" content="app para cuidadores, app iOS, app iPhone, Alivia iOS, notificaciones de auxilio, alertas push, supervisión del hogar, monitoreo de dispositivos, agenda de cuidado, Alivia">`
- **Meta Author:** `<meta name="author" content="Equipo de Desarrollo Mobile – Alivia, 2026">`
    - **Propósito (compartido con Android):** Ambas versiones mantienen el mismo mensaje y difieren solo en la plataforma, para posicionar por separado las búsquedas de Android y de iOS.

**Etiquetas complementarias (Landing Page)**

Adicionalmente, se incluyen las etiquetas de idioma, adaptabilidad y redes sociales para asegurar una correcta visualización en dispositivos móviles y al compartir el enlace:

- `<html lang="es">`
    - **Propósito:** Declara el idioma del contenido para motores de búsqueda y tecnologías de asistencia como lectores de pantalla.
- `<meta name="viewport" content="width=device-width, initial-scale=1">`
    - **Propósito:** Garantiza una visualización adecuada en pantallas de distintos tamaños.
- `<meta property="og:title" content="Alivia | Autonomía en el hogar para personas con discapacidad motora">`
- `<meta property="og:description" content="Control por voz de luces, puertas y ventanas, incluso sin Internet, y alertas escritas para el cuidador.">`
- `<meta property="og:type" content="website">`
    - **Propósito:** Definen cómo se presenta el enlace de Alivia al compartirse en redes sociales y aplicaciones de mensajería, canal habitual de recomendación entre familiares y cuidadores.

### 6.2.5. Navigation Systems

En esta sección se describen las acciones y técnicas que guiarán a los usuarios a través de la Landing Page y de las aplicaciones (web, móvil e IoT), permitiéndoles cumplir sus metas e interactuar de forma satisfactoria con el producto. Se incluyen los recorridos principales, los patrones de interacción y las tácticas UX que facilitan la navegación y la conversión hacia tareas de valor, considerando que buena parte de los usuarios consulta la plataforma bajo presión, con una sola mano o mientras realiza otra actividad, y que la persona asistida interactúa exclusivamente por voz.

El sistema de navegación de Alivia se estructura en tres niveles complementarios:

- **Navegación global:** permite desplazarse entre las secciones principales de la Landing Page y entre los módulos de las aplicaciones web y móvil. En la Landing Page se implementa mediante el menú superior (Inicio, Nosotros, Solución, Beneficios, Testimonios y Planes) y los CTA principales; en la aplicación web, mediante un panel lateral persistente que conduce a Inicio, Mi hogar, Contratación, Dispositivos, Alertas, Agenda de cuidado, Soporte, Autonomía y Perfil; y en la aplicación móvil, mediante una barra de navegación inferior con acceso directo a Inicio, Dispositivos, Alertas, Agenda y Perfil, complementada con un menú lateral deslizante para los accesos de menor frecuencia.
- **Navegación local:** facilita el acceso a subniveles dentro de una sección o pantalla. Incluye tabs internos, filtros y acciones contextuales para pasar de una vista general a otra más específica, por ejemplo, abrir el detalle de un dispositivo desde su tarjeta, entrar al detalle de una alerta desde la bandeja, cambiar entre turnos, actividades y medicamentos dentro de la Agenda de cuidado, o alternar entre estado actual e historial de eventos en Dispositivos.
- **Sistemas de orientación:** ayudan al usuario a entender dónde está y cómo volver. Se aplican botones de retorno, breadcrumbs en la aplicación web cuando el flujo lo requiere (por ejemplo, Contratación > Selección de plan > Autorización del importe), indicadores de progreso en los flujos secuenciales, resaltado del ítem activo en el panel lateral y en la barra inferior, y patrones de cierre o retorno en móvil. En la aplicación web y móvil se implementan rutas de regreso claras desde pantallas de detalle, modales y formularios; en la Landing Page no se prioriza un botón de retorno interno porque la navegación se resuelve por scroll, anclas y acceso directo a secciones.

#### Navegación en la Landing Page

La Landing Page sigue una estructura de scroll lineal con anclas, en la que cada sección del menú superior corresponde a un bloque de contenido. El recorrido busca generar confianza antes de la conversión: primero se presenta la propuesta de valor, luego el equipo y la solución, después los beneficios y testimonios, y finalmente los planes y el paso a la contratación.

- El **hero** presenta la propuesta de valor con un CTA principal ("Ver planes") visible above-the-fold, junto con un acceso secundario a "Conocer Alivia".
- El **menú superior** se mantiene fijo durante el scroll y resalta la sección activa; en móvil se convierte en un menú desplegable.
- El CTA **"Contratar"** redirige a la aplicación web para iniciar la contratación, dado que el pago no se realiza en la Landing Page (US04).
- Los enlaces de **descarga de la aplicación** muestran la disponibilidad para Android e iOS.
- El contenido audiovisual ofrece una alternativa textual equivalente cuando no puede reproducirse (US02).

#### Navegación en la Aplicación Web del Cuidador

- **Navegación global:** el panel lateral persistente concentra la navegación e incluye Inicio, Mi hogar, Contratación, Dispositivos, Alertas, Agenda de cuidado, Soporte, Autonomía y Perfil. En escritorio se muestra expandido con etiquetas de texto; en tablet se colapsa a solo íconos outline; en pantallas angostas se oculta tras un botón de menú en el encabezado.
- **Encabezado superior:** incluye el logo, el nombre de la persona asistida activa, el acceso a notificaciones y el perfil del cuidador, siguiendo el patrón Z definido en las Web Style Guidelines.
- **Navegación local:** se concentra en tabs, tarjetas y accesos directos que reducen la profundidad de clics; por ejemplo, desde una tarjeta de dispositivo con falla se accede directamente a "Reportar falla".
- **Botones de retorno y cierre:** se reservan para flujos de detalle, edición y confirmación, sin duplicar controles innecesarios.

#### Navegación en la Aplicación Web del Negocio

- **Navegación global:** la plataforma empresarial mantiene una estructura similar de panel lateral, con módulos ajustados al rol y autorización por rol (RBAC), de modo que cada perfil solo vea las funciones que le corresponden.
    - **Administrador y responsable de planes y suscripciones:** Métricas, Planes, Suscripciones, Empleados, Órdenes técnicas, Dispositivos y Trazabilidad.
    - **Técnico:** Visitas, Evaluación, Instalación e Incidencias.
- **Navegación local:** tabs, filtros y accesos directos entre módulos relacionados; por ejemplo, desde el detalle de una suscripción se accede a las órdenes técnicas del hogar, y desde una orden se accede a la asignación de técnico y a la reserva de dispositivos.
- **Botones de retorno y cierre:** se reservan para flujos de detalle, edición y confirmación, con breadcrumbs cuando el flujo lo requiere (por ejemplo, Órdenes técnicas > Detalle de la orden > Asignación de técnico).
- **Encabezado superior:** incluye el logo, el rol activo y el perfil del usuario, sin el selector de persona asistida, que solo aplica a la web del cuidador.

#### Navegación en la Aplicación Móvil

- La **barra inferior** (Inicio, Dispositivos, Alertas, Agenda y Perfil) permite acceder a las secciones de mayor frecuencia con una sola mano, con el ícono activo en Azul Marino y los inactivos en Gris Azulado Claro.
- El **menú lateral deslizante** agrupa accesos secundarios como Mi hogar, Soporte, Autonomía y Configuración.
- Las **alertas críticas** se resuelven dentro de la propia tarjeta o notificación (confirmar, iniciar atención, marcar como resuelta), evitando que el cuidador deba buscar un control adicional cuando cada segundo cuenta. Al tocar una notificación push, la aplicación abre directamente el detalle de la alerta.
- Los **gestos** complementan la navegación: deslizamiento vertical para actualizar (pull-to-refresh), deslizamiento horizontal sobre una alerta o actividad para revelar acciones rápidas (confirmar, posponer o reasignar) y pulsación prolongada para menús contextuales que requieren confirmación explícita.
- Las **transiciones** entre pantallas siguen las convenciones nativas de Android (Kotlin) e iOS (Swift), con tiempos breves para no generar sensación de demora ante una alerta crítica.

#### Navegación en el Dispositivo IoT

El dispositivo no cuenta con pantalla, botones de uso primario ni indicadores luminosos, por lo que su "navegación" se resuelve exclusivamente mediante interacción por voz:

- **Activación por frases clave:** la persona asistida solicita acciones mediante frases cortas y cotidianas asociadas a luz, puerta, ventana y auxilio (Intent Mapping).
- **Retroalimentación inmediata:** cada comando se confirma por voz con el resultado real de la acción; ante baja confianza (menos de 75 %) el dispositivo se abstiene de actuar y solicita repetir la instrucción.
- **Estado comunicado por voz:** el dispositivo informa verbalmente su condición operativa cuando es relevante para la persona asistida (por ejemplo, al iniciar, al detectar batería de respaldo baja o al perder una función esencial), sin depender de ninguna señal visual.
- **Ruta de auxilio directa:** la expresión de auxilio reconocida activa de inmediato una alerta crítica al cuidador, sin pasos intermedios ni confirmaciones adicionales que retrasen la asistencia.

#### Principios y técnicas clave

- **Camino claro hacia la acción:** la Landing Page presenta un hero con un CTA principal visible above-the-fold para reducir la fricción y dirigir al visitante hacia los planes y la contratación.
- **Estructura de anclas y scroll lineal:** el contenido de la Landing Page se organiza en secciones con anclas (Nosotros, Solución, Beneficios, Testimonios y Planes) para permitir navegación rápida y enlaces profundos.
- **Prioridad a lo urgente:** en la aplicación web y móvil, las alertas críticas y los dispositivos con falla se muestran antes que la información rutinaria, tanto en el Inicio como en las listas.
- **Acción cerca de la información:** las acciones principales (confirmar una alerta, registrar una actividad) se ubican en la esquina inferior derecha de la tarjeta o pantalla, reduciendo la distancia entre leer y actuar.
- **Onboarding guiado y checklist:** tras el registro, un asistente guía los pasos esenciales (crear la cuenta del hogar, registrar la ubicación validada, registrar a la persona asistida, invitar cuidadores, seleccionar el plan y reservar la evaluación técnica) para que el hogar llegue cuanto antes a tener el servicio activo.
- **Accesibilidad en la navegación:** todos los controles son accesibles por teclado en un orden lógico, con indicador de foco visible en Turquesa, íconos con etiqueta descriptiva (`aria-label`), alertas con `role="alert"` y áreas táctiles amplias para personas con movilidad reducida en manos o dedos.
- **Observabilidad y optimización:** los eventos de navegación y conversión se registran para medir los recorridos críticos y ajustar su orden con base en datos.

#### Ejemplos de recorridos de usuario

- **Visitante → Hero CTA "Ver planes" → Solución y Beneficios → Testimonios → Planes → "Contratar" → Aplicación web (registro).**
- **Cuidador (contratación) → Registro → Mi hogar (perfil y persona asistida) → Selección de plan → Autorización del importe → Horario de evaluación técnica → Resultado técnico → Servicio activo.**
- **Cuidador (alerta crítica) → Notificación push → Detalle de la alerta → Confirmar alerta → Iniciar atención → Marcar como resuelta.**
- **Cuidador (supervisión) → Inicio → Dispositivos → Tarjeta de dispositivo con falla → Reportar falla → Adjuntar foto → Reservar horario técnico → Seguimiento de incidencias.**
- **Cuidador (relevo de turno) → Agenda → Turnos y disponibilidad → Transferencia de responsabilidad → Resumen de pendientes → Aceptar relevo.**
- **Persona asistida → Frase de voz ("Enciende la luz") → Confirmación audible → Luz encendida; o expresión de auxilio → Alerta crítica al cuidador → Confirmación de recepción.**
- **Administrador → Inicio de sesión → Métricas → Suscripciones → Detalle del hogar → Órdenes técnicas → Asignación de técnico y reserva de dispositivos.**

Con estas decisiones de navegación, Alivia orienta a cada usuario paso a paso, desde el primer contacto en la Landing Page hasta las tareas de cuidado y supervisión diarias, reduciendo el esfuerzo cognitivo y físico, protegiendo la seguridad de la persona asistida y fortaleciendo la confianza del cuidador en la solución.

## 6.3. Landing Page UI Design

En esta sección se detalla el diseño de la interfaz de usuario para la Landing Page del proyecto Alivia. El objetivo de este diseño es establecer una primera interacción efectiva con los potenciales clientes (personas con discapacidad motora severa y sus familiares o cuidadores), comunicando de manera clara la propuesta de valor de la plataforma y facilitando la conversión mediante una arquitectura orientada al usuario, con un tono sereno, respetuoso y accesible.

### 6.3.1. Landing Page Wireframe

Se presentan los esquemas de baja fidelidad que definen la estructura base de la Landing Page. Estos wireframes se centran en la disposición de los bloques de contenido, la jerarquía de la información y la ubicación de los llamados a la acción (CTA), asegurando que la navegación sea intuitiva antes de integrar elementos estéticos definitivos.

**Barra de Navegación y Sección Principal (Hero)**

<div align="center">
  <img src="https://imgur.com/WMR4mM8.png" alt="Encabezado fijo con menú de anclas y sección hero de dos columnas con propuesta de valor, CTA y contenedor gráfico principal." height="400">
</div>

**Descripción:** Encabezado fijo con el logotipo de Alivia, un menú de anclas hacia cada sección (¿Qué es?, Cómo funciona, Dispositivos, Audiovisual, Testimonios, Equipo, Planes, FAQ) y un acceso de usuario. Debajo, la sección hero presenta una distribución de dos columnas: a la izquierda, una etiqueta de categoría, el titular de la propuesta de valor, un párrafo descriptivo, dos botones de llamada a la acción y una fila de cuatro indicadores rápidos (tiempo de respuesta, procesamiento local, fonética peruana y batería); a la derecha, un contenedor gráfico principal con una tarjeta flotante inferior que simula un comando de voz detectado en vivo.

**Dos Vidas Transformadas en Paralelo**

<div align="center">
  <img src="https://imgur.com/PbskBjN.png" alt="Sección con pestañas alternables entre persona asistida y cuidador, tres tarjetas de beneficio y un contenedor gráfico con cita testimonial." height="400">
</div>

**Descripción:** Sección con un encabezado centrado y un control de pestañas ("Para la Persona Asistida" / "Para el Cuidador Familiar") que alterna el contenido mostrado debajo. El layout combina una columna izquierda con tres tarjetas de beneficio numeradas (ícono, título y descripción breve) y una columna derecha con un contenedor gráfico principal acompañado de una cita testimonial superpuesta en la parte inferior.

**Ecosistema de Dispositivos**

<div align="center">
  <img src="https://imgur.com/wR2g7Vp.png" alt="Disposición asimétrica con una tarjeta destacada para el hub central y una cuadrícula de tarjetas secundarias para los demás dispositivos." height="400">
</div>

**Descripción:** Disposición asimétrica que presenta primero una tarjeta destacada de mayor tamaño para el componente central del sistema (Hub Alivia Core), seguida de una cuadrícula de tarjetas secundarias más pequeñas para los demás dispositivos (micrófono, iluminación y actuador de puerta), cada una con espacio para ícono, título, descripción y una etiqueta técnica inferior.

**Testimonios**

<div align="center">
  <img src="https://imgur.com/tLrAkPU.png" alt="Grilla de seis tarjetas de testimonios junto a un bloque destacado con encabezado, CTA y aviso de cumplimiento legal." height="400">
</div>

**Descripción:** Grilla de dos columnas con seis tarjetas de testimonios de usuarios y familiares, cada una con un avatar circular, una cita y los datos de la persona (nombre, ciudad y rol). Una de las tarjetas incorpora una etiqueta adicional para el caso de una identidad reservada. A la derecha, un bloque destacado de mayor contraste concentra el encabezado de la sección, un párrafo introductorio, un botón de llamada a la acción y un aviso de cumplimiento legal.

**Equipo**

<div align="center">
  <img src="https://imgur.com/td3WcjV.png" alt="Cuadrícula de seis tarjetas de equipo con avatar, nombre, especialidad y descripción breve." height="400">
</div>

**Descripción:** Sección con encabezado centrado y una cuadrícula de seis tarjetas uniformes, cada una con un avatar circular con iniciales, el nombre completo, la especialidad en una etiqueta corta y una descripción breve de la responsabilidad de cada integrante dentro del proyecto.

**Contenido Audiovisual**

<div align="center">
  <img src="https://imgur.com/3PqOWJ2.png" alt="Bloque de video independiente con controles de accesibilidad y enlace a transcripción completa." height="400">
</div>

**Descripción:** Bloque independiente centrado para el reproductor de video, con un encabezado y subtítulo propios, un área de reproducción con botón de play central y la duración del video, y una fila inferior de controles de accesibilidad (subtítulos, lengua de señas, audio descriptivo) junto con un enlace a la transcripción completa como alternativa textual.

**Planes**

<div align="center">
  <img src="https://imgur.com/ntM0tJU.png" alt="Estructura comparativa de dos planes de suscripción con interruptor de facturación y selectores de personalización." height="400">
</div>

**Descripción:** Estructura comparativa de dos columnas para los planes de suscripción, con un interruptor superior para alternar entre facturación mensual y anual. Cada columna contiene el nombre del plan, una etiqueta de categoría, el precio, una lista de características incluidas con marcadores de verificación y un botón de continuar; la columna del plan personalizado incorpora además selectores desplegables para configurar habitaciones y dispositivos adicionales.

**Descarga de la Aplicación**

<div align="center">
  <img src="https://imgur.com/82RL5Du.png" alt="Banner oscuro de ancho completo con descripción de la app y botones de descarga para Google Play y App Store." height="400">
</div>

**Descripción:** Banner de ancho completo con fondo oscuro y disposición de una sola columna, que agrupa una etiqueta de categoría, el titular de descarga, un párrafo descriptivo de las funciones de la app de cuidadores y dos botones de tienda de aplicaciones (Google Play y App Store).

**Preguntas Frecuentes**

<div align="center">
  <img src="https://imgur.com/OagTJmu.png" alt="Acordeón de preguntas frecuentes y bloque de contacto adicional para consultas específicas." height="400">
</div>

**Descripción:** Sección con encabezado centrado y un componente de tipo acordeón que agrupa las consultas técnicas más comunes sobre el funcionamiento sin Internet, la compatibilidad con puertas, los cortes eléctricos y el reconocimiento de voz. Debajo, un bloque de contacto adicional invita a comunicarse directamente con el equipo para consultas específicas sobre la vivienda.

**Cita del Manifiesto**

<div align="center">
  <img src="https://imgur.com/buZUvkV.png" alt="Bloque de transición oscuro con una cita centrada del manifiesto de diseño inclusivo." height="400">
</div>

**Descripción:** Bloque de transición de ancho completo con fondo oscuro y disposición centrada, utilizado como pausa visual entre secciones. Contiene únicamente una cita destacada en tipografía de mayor tamaño y la atribución al manifiesto de diseño inclusivo de Alivia.

**Pie de Página**

<div align="center">
  <img src="https://imgur.com/NmUmGlX.png" alt="Pie de página de cuatro columnas con enlaces agrupados por categoría y franja legal inferior." height="400">
</div>

**Descripción:** Layout de cuatro columnas para el pie de página: la primera con el logotipo, una descripción breve de la plataforma y un sello de cumplimiento; las siguientes tres con enlaces agrupados por categoría (Plataforma; Compañía y Equipo; Urgencias y Contacto), esta última incluyendo una línea asistencial y la dirección de la sede. Una franja inferior cierra con el aviso de derechos reservados y los enlaces legales (Aviso Legal, Política de Privacidad, Política de Cookies, Declaración de Accesibilidad).

### 6.3.2. Landing Page Mockups

Esta sección muestra el diseño de alta fidelidad de la Landing Page, donde se aplica la identidad visual de Alivia. En este nivel de diseño se integran la paleta de colores corporativa (azul marino, turquesa y menta), la tipografía Outfit y los recursos gráficos detallados, proporcionando la representación visual exacta de la interfaz tal como será percibida por el visitante, la persona asistida y el cuidador.

**Barra de Navegación y Sección Principal (Hero)**

<div align="center">
  <img src="https://imgur.com/iHcpzXH.png" alt="Interfaz de alta fidelidad con la paleta corporativa de Alivia, encabezado fijo con menú de anclas y sección hero con fotografía real y botones de llamada a la acción en turquesa." height="400">
</div>

**Descripción:** Interfaz de alta fidelidad con la paleta corporativa de Alivia (azul marino, turquesa y blanco), un encabezado fijo con el menú de anclas y un badge de accesibilidad AA, y una sección hero de fondo oscuro con fotografía real de una persona en silla de ruedas, tarjetas de estadísticas translúcidas y botones de llamada a la acción en turquesa.

**Dos Vidas Transformadas en Paralelo - Persona Asistida**

<div align="center">
  <img src="https://imgur.com/n5vXyi9.png" alt="Pestaña activa para la persona asistida con tres tarjetas de beneficio, fotografía real de una usuaria en silla de ruedas y cita testimonial superpuesta." height="400">
</div>

**Descripción:** Diseño final de la pestaña activa "Para la Persona Asistida", con tres tarjetas de beneficio en fondo blanco con íconos circulares en menta y una fotografía real de una usuaria en silla de ruedas junto a una cita testimonial superpuesta en la esquina inferior.

**Dos Vidas Transformadas en Paralelo - Cuidador Familiar**

<div align="center">
  <img src="https://imgur.com/B32QslE.png" alt="Pestaña activa para el cuidador familiar con cuadrícula de fotografías del hogar, tarjeta de estado en vivo y cita testimonial de una cuidadora." height="400">
</div>

**Descripción:** Diseño final de la pestaña alternativa "Para el Cuidador Familiar", que reemplaza la fotografía por una cuadrícula de cuatro imágenes reales del entorno del hogar y agrega una tarjeta de estado en vivo del hogar (dormitorio, acceso principal, batería y último comando) junto con una cita testimonial de una cuidadora.

**Ecosistema de Dispositivos**

<div align="center">
  <img src="https://imgur.com/6aoyP4l.png" alt="Composición visual con fotografía real del micrófono Far-Field y cuadrícula de cuatro tarjetas descriptivas del ecosistema de dispositivos." height="400">
</div>

**Descripción:** Composición visual que integra una fotografía real del micrófono Far-Field de Alivia junto a una cuadrícula de cuatro tarjetas descriptivas de los dispositivos del ecosistema (hub, micrófono, iluminación y actuador), cada una con ícono circular en menta y una etiqueta técnica inferior.

**Testimonios**

<div align="center">
  <img src="https://imgur.com/czFF8X4.png" alt="Grilla de seis tarjetas de testimonios con avatares de colores, badge de identidad reservada y bloque destacado con CTA y aviso legal." height="400">
</div>

**Descripción:** Grilla final de seis tarjetas de testimonios con avatares circulares de colores y datos del usuario (nombre, ciudad y rol), incluyendo el badge de "Identidad Reservada" en el testimonio correspondiente, junto a un bloque destacado con el encabezado de la sección, un botón de conversión en azul marino y el aviso de cumplimiento legal.

**Equipo**

<div align="center">
  <img src="https://imgur.com/JBeqYI3.png" alt="Cuadrícula de seis tarjetas del equipo con íconos temáticos, nombre, especialidad y descripción de su rol en el proyecto." height="400">
</div>

**Descripción:** Sección final "Detrás de Alivia" con una cuadrícula de seis tarjetas de integrantes, cada una con un ícono circular temático (código, robot, análisis, entre otros), el nombre completo, la especialidad y el ciclo académico, y una descripción breve de su rol en el proyecto.

**Contenido Audiovisual**

<div align="center">
  <img src="https://imgur.com/GR7oisw.png" alt="Reproductor de video con fondo degradado azul marino, botón de reproducción turquesa y controles de accesibilidad." height="400">
</div>

**Descripción:** Reproductor de video de alta fidelidad con fondo degradado en azul marino, un botón de reproducción circular en turquesa, la duración del video y controles de accesibilidad (subtítulos en español, lengua de señas y audio descriptivo) junto con el enlace a la transcripción completa.

**Planes**

<div align="center">
  <img src="https://imgur.com/XB8zgAM.png" alt="Dos tarjetas de planes con interruptor de facturación, listas de características con marcadores en turquesa y selectores de personalización." height="400">
</div>

**Descripción:** Diseño final de dos tarjetas de planes sobre fondo menta claro, con el interruptor de facturación mensual y anual en la parte superior, listas de características con marcadores de verificación en turquesa, y selectores desplegables en el plan personalizado para configurar habitaciones y puertas.

**Descarga de la Aplicación**

<div align="center">
  <img src="https://imgur.com/ppYsn4T.png" alt="Banner azul marino con esquinas redondeadas, descripción de la app y botones de descarga para Google Play y App Store." height="400">
</div>

**Descripción:** Banner de ancho completo en azul marino con esquinas redondeadas, que presenta el titular de descarga en blanco, un párrafo descriptivo de las funciones de la app y dos botones de tienda con íconos de Android e iOS sobre fondo blanco.

**Preguntas Frecuentes**

<div align="center">
  <img src="https://imgur.com/Afnllzd.png" alt="Acordeón de preguntas frecuentes con tarjetas blancas redondeadas e íconos de chevron para expandir cada respuesta." height="400">
</div>

**Descripción:** Componente de acordeón de alta fidelidad sobre fondo menta claro, con tarjetas blancas de esquinas redondeadas para cada pregunta y un ícono de chevron indicando la posibilidad de expandir cada respuesta.

**Cita del Manifiesto**

<div align="center">
  <img src="https://imgur.com/hpWOddx.png" alt="Bloque de transición azul marino con cita destacada en blanco, comillas en turquesa y separador decorativo." height="400">
</div>

**Descripción:** Bloque de transición final en azul marino con esquinas muy redondeadas, que centra una cita destacada en tipografía grande color blanco con las comillas en turquesa y un separador decorativo debajo del texto.

**Pie de Página**

<div align="center">
  <img src="https://imgur.com/lVajgR7.png" alt="Pie de página de cuatro columnas con logotipo, sello de cumplimiento, enlaces agrupados por categoría y franja legal inferior." height="400">
</div>

**Descripción:** Diseño final del pie de página en cuatro columnas, con el logotipo de Alivia y su sello de cumplimiento en la primera columna, y los enlaces agrupados por categoría (Plataforma; Compañía y Equipo; Urgencias y Contacto) en las columnas siguientes, cerrando con una franja inferior de derechos reservados y enlaces legales.

## 6.4. Applications UX/UI Design

Esta sección detalla el diseño de las interfaces operativas de la plataforma Alivia, abarcando la aplicación web del negocio, utilizada por el equipo de operaciones, los técnicos y los responsables de suscripciones, y la aplicación móvil del cuidador. El diseño UX/UI se ha centrado en la claridad, la seguridad del acceso y la reducción de la carga cognitiva, de modo que cada usuario pueda completar sus tareas sin fricciones, incluso bajo presión. Se aplican las Style Guidelines definidas en la sección 6.1: paleta azul marino, turquesa y menta, tipografía Outfit, íconos outline y un tono de comunicación claro, sereno y respetuoso.

### 6.4.1. Applications Wireframes

Se presentan los esquemas estructurales de las aplicaciones, los cuales definen la lógica de navegación y la distribución de los componentes funcionales. Estos wireframes validan la usabilidad de los flujos de acceso y recuperación de credenciales del portal, organizando los campos de autenticación, los mensajes de validación y las acciones principales de manera coherente, antes de proceder con la implementación de estilos visuales definitivos.

### Web Application - Administrador

En esta sección se presentan los wireframes de la aplicación web del negocio, los cuales definen la arquitectura de la información y la disposición estructural de los elementos clave del flujo de autenticación. Estos diagramas establecen la jerarquía visual y el flujo de navegación sin elementos distractores de diseño, y sirven como base técnica para el desarrollo posterior de los mockups de alta fidelidad.

**Vista estándar de inicio de sesión**

<div align="center">
  <img src="https://imgur.com/uHtbv8H.png" alt="Esquema de la pantalla de inicio de sesión del portal de negocio con formulario a la izquierda y panel ilustrativo a la derecha" height="400">
</div>

**Descripción:** Esquema de la pantalla de acceso al portal de negocio, dividida en dos columnas. A la izquierda se ubican el logotipo, el mensaje de bienvenida, los campos de correo institucional y contraseña con opción de mostrar u ocultar, la casilla "Recordarme en este equipo", el enlace de recuperación de contraseña, el botón "Iniciar sesión" y un aviso de acceso restringido para colaboradores autorizados. A la derecha, un panel oscuro con una ilustración isométrica del hogar e indicadores de estado (red operativa, control por voz local, monitoreo activo y nodo central IoT) refuerza la propuesta de valor del producto.

**Creación de nueva contraseña**

<div align="center">
  <img src="https://imgur.com/Z34BckY.png" alt="Esquema del formulario de creación de nueva contraseña con lista de requisitos de seguridad y campo de confirmación" height="400">
</div>

**Descripción:** Esquema del formulario para establecer nuevas credenciales de acceso, centrado en una tarjeta con el campo "Nueva contraseña", un bloque de requisitos de seguridad (mínimo de caracteres, mayúscula, minúscula, número y carácter especial), el campo "Confirmar contraseña" y el botón "Cambiar contraseña". Define la estructura de la validación doble de seguridad.

**Estado de error en inicio de sesión**

<div align="center">
  <img src="https://imgur.com/YdYUIPh.png" alt="Esquema de la pantalla de inicio de sesión con mensajes de validación en los campos de correo y contraseña" height="400">
</div>

**Descripción:** Esquema de la pantalla de autenticación que representa los elementos de validación negativa. Los campos de correo y contraseña se resaltan con un borde de énfasis e incorporan mensajes de ayuda debajo de cada uno ("Ingresa un correo institucional válido" y "La contraseña debe tener al menos 8 caracteres"), de modo que el usuario identifique y corrija el dato erróneo sin perder el contexto del formulario.

**Solicitud de recuperación de contraseña**

<div align="center">
  <img src="https://imgur.com/3VPZYWY.png" alt="Esquema del módulo de recuperación de contraseña con campo de correo institucional y botón para enviar código" height="400">
</div>

**Descripción:** Esquema del módulo de recuperación de acceso, con una tarjeta centrada que contiene el campo de correo institucional, el botón "Enviar código" y el enlace secundario "Volver a iniciar sesión". Define la estructura del flujo de envío del código de verificación al correo asociado a la cuenta administrativa.

**Estado de error en la creación de contraseña**

<div align="center">
  <img src="https://imgur.com/hc8aa2N.png" alt="Esquema del formulario de nueva contraseña con requisitos parcialmente cumplidos y mensajes de error de validación" height="400">
</div>

**Descripción:** Esquema del formulario de nueva contraseña que representa la validación en tiempo real. Los requisitos cumplidos se marcan con un indicador activo y los pendientes (letra mayúscula y carácter especial) permanecen atenuados. Se muestran además los mensajes "La contraseña no cumple con los requisitos de seguridad" y "Las contraseñas no coinciden" debajo de cada campo, indicando con claridad qué debe corregirse.

**Confirmación de contraseña actualizada**

<div align="center">
  <img src="https://imgur.com/xRLNmC2.png" alt="Esquema de la pantalla de confirmación de contraseña actualizada con ícono de éxito y botón para volver al inicio de sesión" height="400">
</div>

**Descripción:** Esquema de la pantalla de cierre del flujo de recuperación, con una tarjeta centrada que presenta un ícono de confirmación, el título "Contraseña actualizada", un mensaje breve que informa que ya es posible iniciar sesión con las nuevas credenciales y el botón "Ir a iniciar sesión" como acción principal.

**Listado de empleados**

<div align="center">
  <img src="https://imgur.com/DJWdjWp.png" alt="Esquema del listado de empleados con tarjetas de indicadores, buscador, filtros y tabla paginada" height="400">
</div>

**Descripción:** Esquema de la vista principal del módulo de Capital humano, compuesta por el panel lateral de navegación, el encabezado con migas de pan, sede activa, notificaciones y perfil de la administradora, y el área de contenido. En la parte superior se ubican el título "Empleados", el botón secundario "Exportar listado" y el botón principal "Registrar empleado". Debajo se disponen cuatro tarjetas de indicadores (total de empleados, técnicos activos, gestores activos y configuración pendiente), una barra de búsqueda con pestañas por rol, filtros y acción "Limpiar", y una tabla con las columnas empleado, rol, contrato, horario, disponibilidad y acciones, cerrada por un paginador.

**Registro de empleado - Paso 1: Información personal**

<div align="center">
  <img src="https://imgur.com/IApzzkw.png" alt="Esquema del paso de información personal del registro de empleado con formulario de datos de identificación" height="400">
</div>

**Descripción:** Esquema del primer paso del asistente de registro. Incluye un indicador de progreso de cuatro pasos (información personal, información laboral, acceso a la plataforma y revisión) y un formulario con tipo y número de documento, nombres completos, apellidos paterno y materno, teléfono celular y correo personal. Un aviso informativo indica la validación automática del documento contra servicios oficiales. La parte inferior agrupa las acciones "Guardar borrador", "Cancelar" y "Continuar".

**Registro de empleado - Paso 2: Información laboral**

<div align="center">
  <img src="https://imgur.com/se8AdSY.png" alt="Esquema del paso de información laboral con selección de rol, contrato, horario y observaciones" height="400">
</div>

**Descripción:** Esquema del segundo paso del asistente, con el primer paso marcado como completado. Define la selección del rol operativo mediante dos opciones excluyentes (técnico de campo y gestor de suscripciones), los selectores de contrato asignado y de horario laboral, el campo de fecha de inicio del horario y un área de observaciones operativas opcional con límite de caracteres. Se añaden los botones "Anterior" y "Continuar".

**Registro de empleado - Paso 3: Acceso a la plataforma**

<div align="center">
  <img src="https://imgur.com/Emdv2yn.png" alt="Esquema del paso de acceso a la plataforma con correo institucional y vista previa del correo de bienvenida" height="400">
</div>

**Descripción:** Esquema del tercer paso, donde se configura la cuenta institucional del colaborador. Contiene los campos de correo institucional y su confirmación con indicadores de disponibilidad y coincidencia, un bloque que informa el envío automático y obligatorio de la invitación con su protocolo de seguridad, y una vista previa en tiempo real del correo de bienvenida con remitente, destinatario, asunto y botón de activación de cuenta.

**Registro de empleado - Paso 4: Confirmación**

<div align="center">
  <img src="https://imgur.com/4qyZc1h.png" alt="Esquema del resumen y confirmación del registro de empleado con bloques editables por paso" height="400">
</div>

**Descripción:** Esquema del paso final, con los tres pasos previos completados. Presenta un resumen organizado en tres bloques (información personal, información laboral y acceso a la plataforma), cada uno con su acción "Editar paso" para corregir datos sin reiniciar el flujo. Incluye una casilla de confirmación de veracidad de la información y los botones "Guardar borrador", "Anterior" y "Registrar empleado".

**Listado de contratos**

<div align="center">
  <img src="https://imgur.com/aoRHZU5.png" alt="Esquema del listado de contratos con indicadores, aviso de vencimientos, filtros y tabla" height="400">
</div>

**Descripción:** Esquema de la vista de gestión de contratos laborales. Reúne el título, los botones "Exportar listado" y "Registrar contrato", cuatro tarjetas de indicadores (total, vigentes, próximos a vencer y vencidos), un aviso informativo sobre contratos por vencer, una barra de búsqueda con filtros por estado y modalidad, y una tabla con las columnas contrato y código, posición, modalidad y horas, vigencia, estado y acciones.

**Registro de contrato**

<div align="center">
  <img src="https://imgur.com/FwuEVMC.png" alt="Esquema del formulario de registro de contrato con condiciones contractuales, fechas y estado inicial" height="400">
</div>

**Descripción:** Esquema del formulario de alta de contrato, con el encabezado que indica el régimen laboral de marco y el sello de cumplimiento normativo. El formulario incluye el código autogenerado, el cargo contractual, la modalidad, las horas por semana, las fechas de inicio y término con la duración calculada, la elección del estado inicial (pendiente de activación o vigente inmediatamente) y un campo de observaciones o cláusulas particulares. Cierra con las acciones "Guardar borrador", "Cancelar" y "Registrar contrato".

**Detalle de contrato**

<div align="center">
  <img src="https://imgur.com/XnDfx7J.png" alt="Esquema del detalle de contrato con condiciones, trazabilidad y tarjetas de empleados asignados" height="400">
</div>

**Descripción:** Esquema de la vista de consulta de un contrato, con el código y el estado en el encabezado y las acciones "Editar" y de menú adicional. Muestra un bloque de condiciones del contrato (código, cargo, sede, modalidad, horas semanales, fechas de inicio y término, estado legal y cláusula de confidencialidad), el registro de creación y última modificación, y una sección de empleados asignados con tarjetas que indican nombre, código, cargo y estado.

**Listado de horarios laborales**

<div align="center">
  <img src="https://imgur.com/5BT6qcW.png" alt="Esquema del listado de horarios laborales con indicadores, filtros y tabla con días configurados" height="400">
</div>

**Descripción:** Esquema de la vista de administración de jornadas. Incluye cinco tarjetas de indicadores (total, vigentes, programados, con observaciones y finalizados), una barra de búsqueda por código o turno con filtros de estado y vigencia, y una tabla con las columnas horario y código, fecha de inicio, fecha de término, días configurados representados con chips de la semana, horas semanales y acción "Ver detalle". Los horarios finalizados se muestran atenuados.

**Registro de horario laboral**

<div align="center">
  <img src="https://imgur.com/D1BT0X4.png" alt="Esquema del registro de horario laboral con parámetros de vigencia, bloques diarios y resumen de jornada" height="400">
</div>

**Descripción:** Esquema del formulario de alta de horario, organizado en dos columnas. En la principal se ubican la sección de vigencia y parámetros temporales (nombre, fechas de inicio y término con opción "Indefinido" y estado de aplicación) y la sección de configuración de bloques diarios por día de la semana, con interruptor de día laborable, subtotal y acción "Agregar bloque". En la columna lateral se muestra el resumen de jornada en tiempo real (horas contratadas frente a configuradas y balance) y un recuadro de ayuda para turnos atípicos.

**Edición de horario laboral**

<div align="center">
  <img src="https://imgur.com/Ie3UTld.png" alt="Esquema del formulario de edición de horario laboral con parámetros de vigencia, jornada semanal por bloques y resumen de jornada en tiempo real" height="400">
</div>

**Descripción:** Esquema del formulario de edición de un horario existente, con el encabezado que indica el modo de edición, el código del horario y su estado vigente, junto con el selector de contexto (Registro / Edición) y el enlace "Volver a horarios laborales". Se organiza en dos columnas. En la principal se ubican la sección de vigencia y parámetros temporales (nombre del horario, fechas de inicio y término con opción "Indefinido" y estado de aplicación) y la sección de jornada semanal detallada, con la acción "Copiar Lunes a Viernes", un aviso sobre bloques múltiples para pausas o turnos divididos y, por cada día, un interruptor de día laborable, subtotal diario, acción "Agregar bloque" y bloques con hora de inicio, hora de fin, horas totales y opción de eliminar. En la columna lateral se muestra el resumen de jornada en tiempo real (horas contratadas frente a configuradas, balance, días laborables, vigencia configurada y registro de la última modificación) y un recuadro de ayuda para turnos atípicos.

**Listado de órdenes técnicas (vista de tabla)**

<div align="center">
  <img src="https://imgur.com/pFnumET.png" alt="Esquema del listado de órdenes técnicas en vista de tabla con indicadores, filtros, prioridades y paginador" height="400">
</div>

**Descripción:** Esquema del panel de administración general de órdenes técnicas, organizado con navegación lateral persistente agrupada por Principal, Capital Humano, Operaciones Técnicas, Clientes y Servicio, Gestión Comercial, Analítica y Configuración. En la cabecera se ubican indicadores agregados (total de órdenes y órdenes en curso hoy) junto a sus variaciones. Debajo se presenta una barra de filtros por periodo (hoy, esta semana, este mes), tipo de orden (revisiones, instalaciones), búsqueda por código, hogar o distrito, técnico asignado y distrito, con acción de limpieza de filtros. El cuerpo principal muestra una tabla con el código de orden, tipo de servicio, hogar y persona asistida, distrito, fecha y hora programada, técnico asignado y prioridad (crítica, alta, media, normal), con paginación y exportación del listado en la parte superior.

**Detalle de una orden técnica**

<div align="center">
  <img src="https://imgur.com/CCp2a09.png" alt="Detalle de orden técnica con resumen de la solicitud, ubicación del hogar y asignación de técnico" height="400">
</div>

**Descripción:** Esquema de la vista de detalle de una orden técnica individual, estructurado en dos columnas. En la columna principal se ubican el resumen de la solicitud (tipo de orden, fecha solicitada, bloque horario y prioridad), la descripción del servicio en texto libre, la sección de hogar con la dirección registrada, una referencia de ubicación y un mapa de apoyo, y la sección de técnico con el estado de asignación (no asignado) y la acción para asignar un técnico disponible dentro de la franja horaria solicitada. En la columna lateral se muestra la tarjeta de contacto con el cuidador principal, la persona asistida y sus datos de contacto (teléfono y correo). La cabecera incluye el código de la orden, su tipo y estado (pendiente de asignación), con la acción principal "Asignar técnico" visible en la esquina superior derecha.

**Inventario de dispositivos**

<div align="center">
  <img src="https://imgur.com/pPn2bNj.png" alt="Vista de inventario de dispositivos con resumen de estados, filtros y tarjetas de nodos Edge y micrófonos" height="400">
</div>

**Descripción:** Esquema de la vista principal del inventario de dispositivos del panel de administración general, con el filtro "Nodos Edge" activo. En la parte superior se muestra el título "Dispositivos" con la acción principal "Registrar dispositivo" y un resumen numérico del inventario (148 en total, 42 disponibles, 16 reservados y 78 asignados). Debajo se ubica la barra de búsqueda y filtrado por tipo (Todos, Nodos Edge y Dispositivos), estado, ubicación y la opción "Más filtros". La sección "Nodos Edge" presenta dos tarjetas, una para el nodo de control por voz y otra para el nodo de actuadores, cada una con su estado de asignación, alias, código, dirección MAC, hogar asociado, cantidad de periféricos vinculados (3 micrófonos y 8 actuadores, respectivamente) y el enlace "Ver detalle". La sección "Micrófonos" muestra una vista previa de los dispositivos registrados (modelo, código y estado Asignado o Disponible) con un acceso para ver el listado completo. La navegación lateral organiza los módulos por categorías: capital humano, operaciones técnicas, clientes y servicio, gestión comercial, analítica y configuración.

**Listado de micrófonos**

<div align="center">
  <img src="https://imgur.com/MnjaKHv.png" alt="Listado de micrófonos en cuadrícula con resumen por estado, filtros y paginación" height="400">
</div>

**Descripción:** Esquema de la vista de listado de micrófonos dentro del inventario de dispositivos, con una ruta de navegación (Dispositivos / Micrófonos) y las acciones "Volver al inventario" y "Registrar dispositivo" en la cabecera. Se presenta un resumen de los 12 dispositivos registrados por estado: 5 disponibles en almacén, 2 reservados para instalación, 4 asignados en hogares y 1 en mantenimiento. Debajo se encuentra la barra de búsqueda por código, serie, MAC o modelo, junto con los filtros de estado, ubicación y "Más filtros". Los dispositivos se muestran en una cuadrícula de tarjetas de tres columnas; cada tarjeta indica el modelo, el código, la dirección MAC, la ubicación actual (hogar y espacio, o almacén y estante), una etiqueta de estado y el enlace "Ver detalle". En la parte inferior se incluye la paginación, con el conteo de registros mostrados, el selector de cantidad por página y los controles para navegar entre páginas.

**Modal de registro de dispositivo**

<div align="center">
  <img src="https://imgur.com/vbTPrwD.png" alt="Modal para registrar un dispositivo con campos de alias y dirección MAC sobre la gestión de dispositivos" height="400">
</div>

**Descripción:** Esquema del modal "Registrar dispositivo", que se superpone a la vista de gestión de dispositivos y permite agregar un nuevo equipo al inventario. El formulario contiene dos campos obligatorios: el alias del dispositivo (texto libre, con un ejemplo como referencia) y la dirección MAC en formato hexadecimal, con un patrón de ejemplo que guía el ingreso. En la parte inferior se ubican las acciones "Cancelar" y "Registrar dispositivo", esta última deshabilitada hasta que el formulario esté completo. En el fondo atenuado se aprecia la vista de gestión de dispositivos, con las tarjetas de resumen (148 equipos, 42 disponibles, 16 reservados y 78 asignados), las pestañas por categoría (Todos, Pasarelas IoT, Sensores, Pulsadores SOS y Micrófonos & Audio), el filtro por MAC o alias, la sección de dispositivos recientes y el catálogo general en formato de tabla. En la parte inferior de la pantalla se muestra una barra de simulación para alternar los estados del modal: limpio, con errores, listo para guardar y registro exitoso.

**Listado de hogares**

<div align="center">
  <img src="https://imgur.com/zakJUcY.png" alt="Esquema del listado de hogares con indicadores, filtros y tabla paginada de responsables, planes y suscripciones" height="400">
</div>

**Descripción:** Esquema de la vista principal del módulo de Clientes y servicio dedicada a los hogares registrados. Incluye el título "Hogares", el botón "Exportar listado" y cinco tarjetas de indicadores (total de hogares, suscripción activa, pendientes de evaluación, pendientes de instalación e incidencias activas). Debajo se ubica una barra con buscador por hogar, responsable o dirección, filtros de distrito y estado, contador de filtros activos y acción "Limpiar". La tabla presenta las columnas alias del hogar, responsable principal, dirección, distrito, teléfono, plan, suscripción y acciones, cerrada por un paginador con selector de filas por página.

**Detalle de hogar - Pestaña 1: Información**

<div align="center">
  <img src="https://imgur.com/f5CNcpq.png" alt="Esquema de la pestaña de información del detalle de hogar con datos generales y panel de ubicación y cobertura" height="400">
</div>

**Descripción:** Esquema de la ficha de un hogar con el encabezado que muestra el nombre, el estado de la suscripción, el código, la dirección y la fecha de registro, junto con las acciones "Volver a hogares", "Modo consulta" y un menú adicional. Una barra de cuatro pestañas (información, suscripción, dispositivos y órdenes técnicas) organiza el contenido. En esta pestaña, la columna principal agrupa los datos generales (alias, código único, responsable principal, teléfono, correo, tipo y estado del servicio, fecha de registro y canales de comunicación preferidos) y la columna lateral presenta la ubicación y cobertura con un mapa, dirección normalizada, distrito, código postal, coordenadas y referencia proporcionada.

**Detalle de hogar - Pestaña 2: Suscripción**

<div align="center">
  <img src="https://imgur.com/SkwKbIu.png" alt="Esquema de la pestaña de suscripción del detalle de hogar con plan contratado, tarifa y datos de facturación" height="400">
</div>

**Descripción:** Esquema de la segunda pestaña del detalle de hogar. La columna principal muestra el detalle de la suscripción con su código y estado, el plan contratado, la tarifa mensual, el estado de pago, las fechas de inicio de contrato y próxima facturación, el método de pago registrado, el titular de facturación y el documento de facturación. La columna lateral mantiene el panel de ubicación y cobertura con el mapa y los datos de la dirección.

**Detalle de hogar - Pestaña 3: Dispositivos**

<div align="center">
  <img src="https://imgur.com/pzFqZV2.png" alt="Esquema de la pestaña de dispositivos del detalle de hogar con lista de equipos instalados y métricas de batería y señal" height="400">
</div>

**Descripción:** Esquema de la tercera pestaña del detalle de hogar. Presenta el bloque de dispositivos instalados con el estado del gateway, la última sincronización y la cantidad de equipos, seguido de una lista de dispositivos con nombre, número de serie, ubicación dentro del hogar y estado operativo. Al pie se incluyen dos tarjetas de resumen (batería promedio y red o señal). La columna lateral conserva el panel de ubicación y cobertura.

**Detalle de hogar - Pestaña 4: Órdenes técnicas**

<div align="center">
  <img src="https://imgur.com/lwQwtkS.png" alt="Esquema de la pestaña de órdenes técnicas del detalle de hogar con historial cronológico y resumen de atención" height="400">
</div>

**Descripción:** Esquema de la cuarta pestaña del detalle de hogar, con el registro cronológico de las órdenes técnicas asociadas a la vivienda. Cada orden se representa con su código, estado (en curso o completada), descripción, fecha y enlace "Ver orden". Debajo se ubican dos tarjetas de resumen (órdenes atendidas y orden activa) y una nota sobre el protocolo de SLA técnico. La columna lateral mantiene el panel de ubicación y cobertura.

**Planes**

<div align="center">
  <img src="https://imgur.com/uHVLA5P.png" alt="Esquema de la vista de planes con tarjetas comparativas del plan Esencial y el plan Personalizado" height="400">
</div>

**Descripción:** Esquema de la vista de gestión comercial de planes, con el título, una descripción del módulo y dos tarjetas comparativas lado a lado. La primera corresponde al plan Esencial, con etiqueta de categoría, precio mensual, lista de equipamiento y cobertura incluida (incluyendo elementos no contemplados), cantidad de suscripciones activas y el botón "Ver detalle del plan". La segunda corresponde al plan Personalizado, con precio a cotizar, parámetros configurables (habitaciones y puertas con motorización), características incluidas, aviso de evaluación técnica presencial previa, suscripciones activas y el mismo botón de acción.

**Contrataciones**

<div align="center">
  <img src="https://imgur.com/cdxbFUL.png" alt="Esquema del tablero de contrataciones con indicadores, filtros y columnas por etapa del flujo de activación" height="400">
</div>

**Descripción:** Esquema de la vista de supervisión de contrataciones organizada como tablero por etapas. En la parte superior se ubican tres tarjetas de indicadores (nuevas solicitudes, requieren decisión y pendientes de instalación), una barra de búsqueda con filtros de etapa y atención, el acceso a más filtros, los filtros activos como chips removibles y el botón "Ver Finalizadas". El tablero muestra cuatro columnas secuenciales (solicitud y pago, evaluación técnica, decisión del cliente e instalación), cada una con un contador y tarjetas que indican código, plan, hogar, distrito, descripción, estado y fecha. La columna que requiere atención se resalta visualmente.

**Suscripciones**

<div align="center">
  <img src="https://imgur.com/uyA3xL6.png" alt="Esquema del listado de suscripciones con indicadores, pestañas por estado y tabla de clientes, planes y próximas acciones" height="400">
</div>

**Descripción:** Esquema de la vista de administración de suscripciones. Incluye el título, tres tarjetas de indicadores (activas, requieren atención y próximas a renovar), pestañas de filtrado por estado (todas, activas, atención requerida, suspendidas, próximas a renovar y cancelación programada), un buscador por código, cliente u hogar, un selector de estado y el acceso a más filtros. La tabla muestra las columnas suscripción, cliente y hogar, plan, estado, próxima acción y acciones ("Ver detalle" y menú adicional), cerrada por un paginador.

**Mi perfil**

<div align="center">
  <img src="https://imgur.com/7qaSIoR.png" alt="Esquema de la vista Mi perfil con tarjeta de identidad, formularios de información personal y contacto y preferencias del sistema" height="400">
</div>

**Descripción:** Esquema de la vista de perfil personal del administrador, ubicada en el módulo de Configuración. En el encabezado se muestran el título "Mi perfil", el identificador del colaborador y el rol asignado. La columna izquierda agrupa una tarjeta con la fotografía de perfil y la acción "Cambiar fotografía", el nombre, las etiquetas de rol y estado de cuenta, el correo institucional, la sede asignada, el estado de la seguridad en dos pasos, una nota sobre los cambios gestionados por Administración Central y la acción "Cambiar contraseña". La columna derecha contiene tres bloques de formulario: información personal (nombres, apellidos, tipo y número de documento y teléfono móvil), información de contacto (correo institucional de solo lectura y correo personal de respaldo) y preferencias del sistema (canales de notificación, zona horaria y formato de fecha). Una barra inferior fija recuerda la edición activa y ofrece las acciones "Descartar cambios" y "Guardar cambios".

**Perfil del negocio - Pestaña 1: Identidad del negocio**

<div align="center">
  <img src="https://imgur.com/gw6IuCZ.png" alt="Esquema de la pestaña de identidad del negocio con logotipo, razón social, RUC y descripción institucional" height="400">
</div>

**Descripción:** Esquema de la primera pestaña del perfil del negocio, que incluye el título, la descripción del módulo, el botón "Editar perfil" y una barra de cuatro pestañas (identidad del negocio, información de contacto, ubicación corporativa e información para clientes). El contenido muestra la insignia de estado validado, un bloque con el logotipo institucional y la acción "Cambiar logotipo", y los campos de nombre comercial, razón social institucional, RUC con indicador de dato protegido, actividad económica principal y descripción institucional y propósito. Al pie se indica que solo el administrador general puede modificar la razón social y el RUC, junto con el botón "Editar perfil".

**Perfil del negocio - Pestaña 2: Información de contacto**

<div align="center">
  <img src="https://imgur.com/CLJkTep.png" alt="Esquema de la pestaña de información de contacto con tarjetas de correo, teléfonos y sitio web corporativo" height="400">
</div>

**Descripción:** Esquema de la segunda pestaña del perfil del negocio. Presenta cuatro tarjetas con los canales oficiales de la organización: correo de contacto institucional, teléfono principal corporativo, teléfono móvil institucional o de guardia y sitio web corporativo, cada una con su ícono, valor y metadatos de estado u horario. Debajo se incluye un recuadro informativo sobre la disponibilidad de la mesa de partes virtual y el soporte regulatorio. El pie mantiene la nota de permisos y el botón "Editar perfil".

**Perfil del negocio - Pestaña 3: Ubicación corporativa**

<div align="center">
  <img src="https://imgur.com/tQvGwD3.png" alt="Esquema de la pestaña de ubicación corporativa con dirección, referencia y mapa de la sede central" height="400">
</div>

**Descripción:** Esquema de la tercera pestaña del perfil del negocio, dedicada a la sede central administrativa. A la izquierda se muestran la dirección principal, el distrito, la provincia, el departamento y la referencia de ubicación con una nota de accesibilidad. A la derecha se presenta un mapa con el marcador de la sede, el acceso "Ver en Google Maps", las coordenadas y la zona postal. El pie mantiene la nota de permisos y el botón "Editar perfil".

**Perfil del negocio - Pestaña 4: Información para clientes**

<div align="center">
  <img src="https://imgur.com/iu3hMgz.png" alt="Esquema de la pestaña de información para clientes con horarios, soporte, emergencias y protocolo de SLA" height="400">
</div>

**Descripción:** Esquema de la cuarta pestaña del perfil del negocio, que reúne los datos usados en las comunicaciones hacia los clientes. Incluye tarjetas con el horario de atención institucional, el correo de mesa de ayuda y soporte técnico, la central de emergencias familiares y el WhatsApp oficial, y el lema o firma oficial en comunicaciones. Cierra con un recuadro de protocolo de SLA y reglas de escalamiento, la nota de permisos y el botón "Editar perfil".

**Panel de notificaciones**

<div align="center">
  <img src="https://imgur.com/aqNtiqn.png" alt="Esquema del panel desplegable de notificaciones con eventos agrupados por día, prioridad y módulo de origen" height="400">
</div>

**Descripción:** Esquema del panel desplegable de notificaciones que se superpone a la vista actual desde el ícono de campana del encabezado. Muestra el contador de notificaciones nuevas, la acción "Marcar leídas" y pestañas de filtrado (todas y no leídas). Las notificaciones se agrupan por día y cada una presenta un ícono, título, descripción, tiempo transcurrido y etiquetas de prioridad y módulo de origen (por ejemplo, incidencia crítica en órdenes técnicas, adaptación aceptada en contrataciones y pago en revisión en suscripciones). Al pie se ubica el enlace "Ver historial completo de eventos".

**Inicio**

<div align="center">
  <img src="https://imgur.com/p5zMILC.png" alt="Esquema de la pantalla de inicio con indicadores, órdenes técnicas del día y resúmenes por módulo" height="400">
</div>

**Descripción:** Esquema de la pantalla de inicio del administrador, con un saludo, la fecha y hora actuales y la sede activa. Presenta cuatro tarjetas de indicadores (órdenes técnicas activas, contrataciones en proceso, suscripciones en atención y configuraciones de personal), cada una con su acceso "Ver detalle". Debajo se incluye la tabla "Órdenes técnicas de hoy" con código y tipo, hogar y distrito, horario, técnico y estado o acción (incluyendo "Asignar" para órdenes sin técnico), junto con los accesos "Ver todas las órdenes" y "Abrir calendario". Cierra con tres tarjetas de resumen (Gestión comercial, Capital humano y Dispositivos IoT) con sus métricas clave y enlaces de acceso.

**Métricas - Resumen general**

<div align="center">
  <img src="https://imgur.com/SDAY51E.png" alt="Esquema del panel de métricas con indicadores, gráficos de operación técnica, estado del servicio y capacidad técnica" height="400">
</div>

**Descripción:** Esquema del panel analítico del negocio, con el título, el selector de periodo (Hoy, Esta semana, Últimos 30 días, Trimestre) y el botón "Exportar". Incluye cuatro tarjetas de indicadores con tendencia (hogares activos, órdenes pendientes, suscripciones activas e incidencias críticas, esta última destacada). En la franja central se ubican tres bloques analíticos: operación técnica con barras de avance por tipo de orden, estado del servicio con un gráfico circular de dispositivos conectados y evolución comercial con un gráfico de líneas de renovaciones, altas y bajas. Al pie se presenta la capacidad técnica con barras de ocupación semanal por técnico y el acceso "Ver horarios de cuadrilla".

**Contrataciones (tablero por etapas, vista alternativa)**

<div align="center">
  <img src="https://imgur.com/iXunS7t.png" alt="Esquema del tablero de contrataciones con indicadores, filtros activos y columnas por etapa del flujo de activación" height="400">
</div>

**Descripción:** Esquema de la vista de supervisión de contrataciones, desde la selección del plan hasta la activación del servicio, organizada como tablero por etapas. En la parte superior se ubican tres tarjetas de indicadores (nuevas solicitudes, requieren decisión y pendientes de instalación), cada una con un ícono y una descripción breve de su alcance. Debajo se dispone una barra de filtros con buscador por código, cliente, hogar o correo, selectores de etapa y de atención requerida, y el acceso a "Más filtros" con su contador. Los filtros aplicados se muestran como chips removibles (por ejemplo, "Requieren atención" y "Distrito: Lima Metropolitana") junto con la acción "Limpiar todos". El encabezado "Flujo activo previo a activación" acompaña al botón "Ver Finalizadas". El tablero presenta cuatro columnas secuenciales (solicitud y pago, evaluación técnica, decisión del cliente e instalación), cada una con un contador. Las tarjetas indican código de contratación, etiqueta de plan (Esencial, Personalizado o Adaptación), hogar, distrito, descripción breve, estado y fecha o plazo. La columna de decisión del cliente se resalta para señalar que concentra las contrataciones que requieren atención.

### Vista del técnico

**Mis órdenes (vista de tarjetas)**

<div align="center">
  <img src="https://imgur.com/u9ZRWUT.png" alt="Esquema de la vista Mis órdenes del técnico con indicadores, filtros y tarjetas de órdenes técnicas" height="400">
</div>

**Descripción:** Esquema de la vista principal del técnico de campo, con el menú lateral propio del perfil (Mi jornada, Mis órdenes técnicas, Mi agenda, Equipos y bodega móvil, Mi rendimiento, Mi perfil y Cerrar sesión). En el encabezado se muestran el estado de servicio con GPS activo, el turno asignado y los datos del técnico. El contenido incluye el título "Mis órdenes" con el contador de pendientes, un selector de vista (Tarjetas / Calendario), un buscador por código o alias y filtros por tipo, estado y fecha. Debajo se ubican tres tarjetas de indicadores (órdenes de hoy, en proceso y atrasadas) y una lista de órdenes en tarjetas con código, etiqueta de tipo, horario, estado, hogar, distrito y el botón "Ver orden". La orden en ruta se resalta como acción principal y las completadas se atenúan.

**Detalle de orden técnica en ruta (panel lateral)**

<div align="center">
  <img src="https://imgur.com/ztcp0hE.png" alt="Esquema del panel lateral de detalle de una orden en ruta con mapa, contacto autorizado y botón para confirmar llegada" height="400">
</div>

**Descripción:** Esquema del panel lateral deslizante que se superpone al listado de órdenes, mientras el fondo se atenúa. En el encabezado se muestran el código de la orden, su tipo, el estado "En ruta hacia el domicilio" y el botón de cierre. El contenido incluye una tarjeta del hogar con el tiempo estimado de llegada, la dirección y el horario, un mapa con la ruta estimada, su duración y distancia, un aviso de tráfico con acceso a una aplicación de navegación externa, y una tarjeta de contacto autorizado con nombre, teléfono y botón de llamada. El pie agrupa la acción principal "Confirmar llegada" y el enlace "Ver expediente completo".

**Calendario semanal del técnico**

<div align="center">
  <img src="https://imgur.com/CRyQU5U.png" alt="Esquema del calendario semanal del técnico con bloques de órdenes por tipo, almuerzos, espacios disponibles y resumen de ocupación" height="400">
</div>

**Descripción:** Esquema de la vista de calendario del técnico, con el título, el mes visible, el selector Día / Semana / Mes, los controles de navegación temporal (Hoy, anterior, siguiente) y el rango de la semana. Una franja de resumen muestra las horas reservadas con su porcentaje de ocupación, las órdenes programadas y los espacios disponibles, acompañada de la leyenda de tipos (instalación, incidencia, mantenimiento y evaluación). La cuadrícula presenta los días de lunes a sábado con franjas horarias, donde cada orden se representa como un bloque con código, ícono de tipo, hogar y horario. Se incluyen bloques de almuerzo, espacios disponibles con borde punteado, una línea de hora actual sobre el día en curso y un estado de descanso para el día sin turnos programados.

**Inicio del portal técnico**

<div align="center">
  <img src="https://imgur.com/QG1eMU8.png" alt="Esquema del inicio del portal técnico con indicadores, próxima visita, agenda de hoy y órdenes que requieren atención" height="400">
</div>

**Descripción:** Esquema de la pantalla de inicio del portal del técnico, con un saludo, la fecha actual, el turno y la zona de trabajo. Presenta cuatro tarjetas de indicadores (órdenes para hoy, en atención, urgentes y pendientes de actualizar). Debajo se destaca el bloque "Próxima visita asignada" con el código de la orden, tipo, estado de desplazamiento, hogar, dirección, equipos en revisión, contacto operativo, ventana de servicio y las acciones "Ver orden técnica" y "Abrir en Google Maps". La parte inferior combina la agenda de hoy, con las órdenes ordenadas por horario y su estado, un panel "Requieren atención" con acciones rápidas (resolver, actualizar y ver cambio) y un minicalendario semanal con el conteo de órdenes por día.

**Mi jornada**

<div align="center">
  <img src="https://imgur.com/awtcfNT.png" alt="Esquema del tablero Mi jornada con indicadores, orden en ruta, agenda semanal, estado semanal y rendimiento" height="400">
</div>

**Descripción:** Esquema del tablero de seguimiento de la jornada del técnico, con el título, el estado activo, la fecha, el selector de semana y el acceso "Ver agenda". Incluye cuatro tarjetas de indicadores con minigráficos de tendencia (órdenes de hoy, pendientes, completadas y tiempo promedio frente a la meta). Debajo se destaca la orden en curso con su estado "En ruta a domicilio", código, tipo, prioridad, horario, tiempo restante, destino, equipamiento asignado y las acciones "Ver ruta en mapa", "Ver orden de trabajo" y "Llamar cuidador", junto con un mapa de la ruta y su distancia. La franja inferior reúne tres bloques: agenda semanal con las órdenes por día y leyenda de tipos, estado semanal con un gráfico circular de órdenes completadas, pendientes, en proceso y reprogramadas, y rendimiento semanal con barras de avance por día y la efectividad global.

**Inventario de dispositivos (vista del técnico)**

<div align="center">
  <img src="https://imgur.com/pPn2bNj.png" alt="Vista de inventario de dispositivos con resumen de estados, filtros y tarjetas de nodos Edge y micrófonos" height="400">
</div>

**Descripción:** Esquema de la vista principal del inventario de dispositivos del panel de administración general, con el filtro "Nodos Edge" activo. En la parte superior se muestra el título "Dispositivos" con la acción principal "Registrar dispositivo" y un resumen numérico del inventario (148 en total, 42 disponibles, 16 reservados y 78 asignados). Debajo se ubica la barra de búsqueda y filtrado por tipo (Todos, Nodos Edge y Dispositivos), estado, ubicación y la opción "Más filtros". La sección "Nodos Edge" presenta dos tarjetas, una para el nodo de control por voz y otra para el nodo de actuadores, cada una con su estado de asignación, alias, código, dirección MAC, hogar asociado, cantidad de periféricos vinculados (3 micrófonos y 8 actuadores, respectivamente) y el enlace "Ver detalle". La sección "Micrófonos" muestra una vista previa de los dispositivos registrados (modelo, código y estado Asignado o Disponible) con un acceso para ver el listado completo. La navegación lateral organiza los módulos por categorías: capital humano, operaciones técnicas, clientes y servicio, gestión comercial, analítica y configuración.

**Listado de micrófonos (vista del técnico)**

<div align="center">
  <img src="https://imgur.com/MnjaKHv.png" alt="Listado de micrófonos en cuadrícula con resumen por estado, filtros y paginación" height="400">
</div>

**Descripción:** Esquema de la vista de listado de micrófonos dentro del inventario de dispositivos, con una ruta de navegación (Dispositivos / Micrófonos) y las acciones "Volver al inventario" y "Registrar dispositivo" en la cabecera. Se presenta un resumen de los 12 dispositivos registrados por estado: 5 disponibles en almacén, 2 reservados para instalación, 4 asignados en hogares y 1 en mantenimiento. Debajo se encuentra la barra de búsqueda por código, serie, MAC o modelo, junto con los filtros de estado, ubicación y "Más filtros". Los dispositivos se muestran en una cuadrícula de tarjetas de tres columnas; cada tarjeta indica el modelo, el código, la dirección MAC, la ubicación actual (hogar y espacio, o almacén y estante), una etiqueta de estado y el enlace "Ver detalle". En la parte inferior se incluye la paginación, con el conteo de registros mostrados, el selector de cantidad por página y los controles para navegar entre páginas.

**Modal de registro de dispositivo (vista del técnico)**

<div align="center">
  <img src="https://imgur.com/vbTPrwD.png" alt="Modal para registrar un dispositivo con campos de alias y dirección MAC sobre la gestión de dispositivos" height="400">
</div>

**Descripción:** Esquema del modal "Registrar dispositivo", que se superpone a la vista de gestión de dispositivos y permite agregar un nuevo equipo al inventario. El formulario contiene dos campos obligatorios: el alias del dispositivo (texto libre, con un ejemplo como referencia) y la dirección MAC en formato hexadecimal, con un patrón de ejemplo que guía el ingreso. En la parte inferior se ubican las acciones "Cancelar" y "Registrar dispositivo", esta última deshabilitada hasta que el formulario esté completo. En el fondo atenuado se aprecia la vista de gestión de dispositivos, con las tarjetas de resumen (148 equipos, 42 disponibles, 16 reservados y 78 asignados), las pestañas por categoría (Todos, Pasarelas IoT, Sensores, Pulsadores SOS y Micrófonos & Audio), el filtro por MAC o alias, la sección de dispositivos recientes y el catálogo general en formato de tabla. En la parte inferior de la pantalla se muestra una barra de simulación para alternar los estados del modal: limpio, con errores, listo para guardar y registro exitoso.

**Mi perfil (vista del técnico)**

<div align="center">
  <img src="https://imgur.com/9xtgKwT.png" alt="Esquema de la vista Mi perfil del técnico con tarjeta de identidad, formularios de datos personales y contacto y preferencias" height="400">
</div>

**Descripción:** Esquema de la vista de perfil personal del técnico, ubicada en el módulo de Configuración. En el encabezado se muestran el título "Mi perfil", el identificador del colaborador y el rol asignado. La columna izquierda agrupa la fotografía de perfil con la acción "Cambiar fotografía", el nombre, las etiquetas de rol y estado de cuenta, el correo institucional, la sede asignada, el estado de la seguridad en dos pasos, una nota que indica que los cambios de rol, contrato y jornada se gestionan desde Administración Central, y la acción "Cambiar contraseña". La columna derecha contiene los bloques de información personal, información de contacto (correo institucional de solo lectura y correo personal de respaldo) y preferencias del sistema (canales de notificación, zona horaria y formato de fecha). Una barra inferior fija ofrece "Descartar cambios" y "Guardar cambios".

**Listado de hogares (vista del técnico)**

<div align="center">
  <img src="https://imgur.com/zakJUcY.png" alt="Esquema del listado de hogares con indicadores, filtros y tabla paginada de responsables, planes y suscripciones" height="400">
</div>

**Descripción:** Esquema de la vista principal del módulo de Clientes y servicio dedicada a los hogares registrados. Incluye el título "Hogares", el botón "Exportar listado" y cinco tarjetas de indicadores (total de hogares, suscripción activa, pendientes de evaluación, pendientes de instalación e incidencias activas). Debajo se ubica una barra con buscador por hogar, responsable o dirección, filtros de distrito y estado, contador de filtros activos y acción "Limpiar". La tabla presenta las columnas alias del hogar, responsable principal, dirección, distrito, teléfono, plan, suscripción y acciones, cerrada por un paginador con selector de filas por página.

**Detalle de hogar - Pestaña 1: Información (vista del técnico)**

<div align="center">
  <img src="https://imgur.com/f5CNcpq.png" alt="Esquema de la pestaña de información del detalle de hogar con datos generales y panel de ubicación y cobertura" height="400">
</div>

**Descripción:** Esquema de la ficha de un hogar con el encabezado que muestra el nombre, el estado de la suscripción, el código, la dirección y la fecha de registro, junto con las acciones "Volver a hogares", "Modo consulta" y un menú adicional. Una barra de cuatro pestañas (información, suscripción, dispositivos y órdenes técnicas) organiza el contenido. En esta pestaña, la columna principal agrupa los datos generales (alias, código único, responsable principal, teléfono, correo, tipo y estado del servicio, fecha de registro y canales de comunicación preferidos) y la columna lateral presenta la ubicación y cobertura con un mapa, dirección normalizada, distrito, código postal, coordenadas y referencia proporcionada.

**Detalle de hogar - Pestaña 2: Suscripción (vista del técnico)**

<div align="center">
  <img src="https://imgur.com/SkwKbIu.png" alt="Esquema de la pestaña de suscripción del detalle de hogar con plan contratado, tarifa y datos de facturación" height="400">
</div>

**Descripción:** Esquema de la segunda pestaña del detalle de hogar. La columna principal muestra el detalle de la suscripción con su código y estado, el plan contratado, la tarifa mensual, el estado de pago, las fechas de inicio de contrato y próxima facturación, el método de pago registrado, el titular de facturación y el documento de facturación. La columna lateral mantiene el panel de ubicación y cobertura con el mapa y los datos de la dirección.

**Detalle de hogar - Pestaña 3: Dispositivos (vista del técnico)**

<div align="center">
  <img src="https://imgur.com/pzFqZV2.png" alt="Esquema de la pestaña de dispositivos del detalle de hogar con lista de equipos instalados y métricas de batería y señal" height="400">
</div>

**Descripción:** Esquema de la tercera pestaña del detalle de hogar. Presenta el bloque de dispositivos instalados con el estado del gateway, la última sincronización y la cantidad de equipos, seguido de una lista de dispositivos con nombre, número de serie, ubicación dentro del hogar y estado operativo. Al pie se incluyen dos tarjetas de resumen (batería promedio y red o señal). La columna lateral conserva el panel de ubicación y cobertura.

**Detalle de hogar - Pestaña 4: Órdenes técnicas (vista del técnico)**

<div align="center">
  <img src="https://imgur.com/lwQwtkS.png" alt="Esquema de la pestaña de órdenes técnicas del detalle de hogar con historial cronológico y resumen de atención" height="400">
</div>

**Descripción:** Esquema de la cuarta pestaña del detalle de hogar, con el registro cronológico de las órdenes técnicas asociadas a la vivienda. Cada orden se representa con su código, estado (en curso o completada), descripción, fecha y enlace "Ver orden". Debajo se ubican dos tarjetas de resumen (órdenes atendidas y orden activa) y una nota sobre el protocolo de SLA técnico. La columna lateral mantiene el panel de ubicación y cobertura.

### Web Application - Vista del cuidador

**Inicio del cuidador**

<div align="center">
  <img src="https://imgur.com/glCgObh.png" alt="Esquema del inicio del cuidador con alerta de dispositivos, persona asistida, actividades de hoy y próximo evento" height="400">
</div>

**Descripción:** Esquema de la pantalla de inicio de la web del cuidador, con el menú lateral propio del perfil (Inicio, Persona asistida, Red de cuidado, Actividades, Mi hogar, Dispositivos, Suscripción, Incidencias, Métricas, Mi perfil y Cerrar sesión). Presenta un saludo con la fecha actual y las acciones "Reportar incidencia" y "Nueva actividad". Debajo se ubica una franja de alerta con la situación prioritaria de dispositivos (por ejemplo, batería baja de un sensor) y el acceso "Ver dispositivo". El contenido se organiza en dos columnas: a la izquierda, una tarjeta de la persona asistida con acceso a su perfil y el bloque "Hoy" con la línea de tiempo de actividades programadas, su responsable y su estado (completada, pendiente o programada); a la derecha, la tarjeta "Próximo evento" con el horario de la visita técnica, el técnico asignado y el botón "Ver seguimiento".

**Persona asistida**

<div align="center">
  <img src="https://imgur.com/KvZ3M4y.png" alt="Esquema de la vista de persona asistida con información personal y asociada" height="400">
</div>

**Descripción:** Esquema de la vista de consulta de la persona a cargo. Muestra el encabezado con avatar, nombre, estado de perfil completo, edad y hogar, junto con el botón "Editar información". El contenido se divide en dos bloques: información personal (nombres, apellidos, tipo y número de documento con indicador de validación, fecha de nacimiento y parentesco) e información asociada (hogar relacionado, cuidador principal con su relación y teléfono de contacto).

**Red de cuidado**

<div align="center">
  <img src="https://imgur.com/bCQ9vqH.png" alt="Esquema de la red de cuidado con cuidador principal y cuidadores adicionales en distintos estados" height="400">
</div>

**Descripción:** Esquema del listado de personas autorizadas a apoyar el cuidado del hogar, con el botón "Invitar cuidador". Se divide en el bloque del cuidador principal (titular del servicio), con avatar, relación, datos de contacto y acceso "Ver responsabilidades", y la lista de cuidadores adicionales con su contador. Cada cuidador muestra su estado (activo, invitación pendiente o invitación vencida) y las acciones correspondientes: "Ver responsabilidades", "Reenviar" y un menú adicional.

**Invitar cuidador (panel lateral)**

<div align="center">
  <img src="https://imgur.com/Wsb9lJj.png" alt="Esquema del panel lateral para invitar a un cuidador con correo, relación y responsabilidades" height="400">
</div>

**Descripción:** Esquema del panel lateral deslizante que se superpone a la red de cuidado, mientras el fondo se atenúa. Incluye el campo de correo electrónico, el selector de relación con la persona asistida y una lista de casillas de responsabilidades asignadas (consultar actividades, gestionar actividades, recibir notificaciones, consultar dispositivos y recibir alertas de dispositivos). El pie agrupa las acciones "Cancelar" y "Enviar invitación".

**Aceptación de invitación a la red de cuidado**

<div align="center">
  <img src="https://imgur.com/tq62Bj2.png" alt="Esquema de la pantalla de invitación a una red de cuidado con responsabilidades e inicio de sesión" height="400">
</div>

**Descripción:** Esquema de la pantalla pública que recibe el cuidador invitado. En una tarjeta centrada se muestran el título, la información del hogar con la etiqueta "Invitación activa", la persona asistida, quién invita y las responsabilidades asignadas en forma de chips. Debajo se ubican el correo electrónico precargado y de solo lectura, el campo de contraseña con enlace de recuperación, el botón "Iniciar sesión y aceptar" y la acción secundaria "Rechazar invitación". El pie incluye los enlaces legales.

**Actividades (vista semanal)**

<div align="center">
  <img src="https://imgur.com/rm7GI8Y.png" alt="Esquema del calendario semanal de actividades con bloques por estado y aviso de superposición de horario" height="400">
</div>

**Descripción:** Esquema del calendario semanal de actividades de cuidado. Incluye el título, el selector de vista (Hoy, Semana, Lista), el botón "Nueva actividad", los controles de navegación temporal, el rango de la semana y los filtros por responsable, tipo y estado. La cuadrícula muestra los días con franjas horarias, donde cada actividad se representa como un bloque con hora, nombre, ícono de tipo, responsable y estado (completada, programada, pendiente o vencida). Se resaltan el día actual con una línea de hora en curso, la actividad vencida con borde punteado y las superposiciones de horario agrupadas en un mismo bloque.

**Nueva actividad (panel lateral)**

<div align="center">
  <img src="https://imgur.com/qi9N42D.png" alt="Esquema del panel lateral de nueva actividad con campos de programación, responsable y recordatorio" height="400">
</div>

**Descripción:** Esquema del panel lateral para programar una tarea o recordatorio de cuidado. Contiene los campos nombre de la actividad, tipo de actividad, persona asistida (solo lectura), fecha y hora, duración opcional, repetición, cuidador responsable, recordatorio e indicaciones opcionales con contador de caracteres. El pie incluye "Cancelar" y "Guardar actividad".

**Actividades (vista diaria)**

<div align="center">
  <img src="https://imgur.com/lFz8WY0.png" alt="Esquema de la vista diaria de actividades agrupadas por mañana, tarde y noche con acciones por estado" height="400">
</div>

**Descripción:** Esquema de la vista "Hoy" de actividades, con el selector Hoy / Semana / Lista, la navegación por fecha, el acceso "Ir a hoy", el botón "Filtros" y la acción "Nueva actividad". Las actividades se agrupan por franja del día (mañana, tarde y noche), cada una con su contador. Cada fila muestra hora, ícono, nombre, responsable, duración o nota, etiqueta de estado y la acción contextual: "Ver detalle" para completadas o canceladas, "Completar" para pendientes y "Reprogramar" para vencidas. Las actividades canceladas se muestran atenuadas y tachadas, y la actividad de medicamento incluye la etiqueta "Previamente indicado".

**Detalle de actividad (panel lateral)**

<div align="center">
  <img src="https://imgur.com/X073pWY.png" alt="Esquema del panel lateral de detalle de actividad con datos de programación e indicaciones" height="400">
</div>

**Descripción:** Esquema del panel lateral con el detalle de una actividad, que se superpone al cronograma del turno. En el encabezado se muestran las etiquetas de tipo y estado, el título y una descripción breve. El contenido lista persona asistida, horario, frecuencia, cuidador asignado y recordatorio, además de un recuadro con las indicaciones. El pie ofrece la acción principal "Marcar como completada", las acciones secundarias "Reprogramar" y "Editar" y el enlace "Cancelar actividad".

**Dispositivos del hogar**

<div align="center">
  <img src="https://imgur.com/IFxjVQ0.png" alt="Esquema de dispositivos del hogar agrupados por habitación con estado y nivel de batería" height="400">
</div>

**Descripción:** Esquema de la vista de consulta de dispositivos instalados, con el título, la hora de la última actualización y el botón "Reportar un problema". Una fila de chips resume el estado global (operativos, requieren atención y sin conexión). Los dispositivos se agrupan por habitación y se presentan como tarjetas con ícono, nombre, descripción, etiqueta de estado, tipo de alimentación o nivel de batería con barra de progreso, estado actual, tiempo desde la última actualización y el botón "Ver detalle". La tarjeta que requiere atención se resalta y ofrece "Ver detalle y recambio".

**Incidencias (listado)**

<div align="center">
  <img src="https://imgur.com/IrK6XIJ.png" alt="Esquema del listado de incidencias con pestañas por estado, buscador y tarjetas de seguimiento" height="400">
</div>

**Descripción:** Esquema del listado de incidencias del hogar, con el botón "Reportar incidencia". Incluye pestañas "En curso" y "Resueltas" con contadores, un buscador por código o dispositivo y filtros por estado y dispositivo. Cada incidencia se muestra como una tarjeta con ícono del dispositivo, código, etiqueta de estado (visita programada, en atención o en evaluación), nombre del dispositivo y ubicación, fecha de registro, información de visita o diagnóstico y el enlace "Ver detalle".

**Reportar incidencia (panel lateral)**

<div align="center">
  <img src="https://imgur.com/odqQhsK.png" alt="Esquema del panel lateral para reportar una incidencia con dispositivo, descripción, evidencias y ubicación" height="400">
</div>

**Descripción:** Esquema del panel lateral para registrar un problema, con la etiqueta de soporte de equipamiento y el título. Contiene los campos dispositivo afectado, tipo de problema, descripción con contador de caracteres, fecha y hora del incidente y un área para adjuntar hasta tres fotografías como evidencia opcional. Un recuadro muestra la dirección registrada del hogar donde se realizará la atención e indica que puede modificarse desde "Mi hogar". El pie incluye "Cancelar" y "Enviar incidencia".

**Confirmación de incidencia registrada**

<div align="center">
  <img src="https://imgur.com/eUGs5Dj.png" alt="Esquema de la confirmación de incidencia registrada con código de ticket y resumen del reporte" height="400">
</div>

**Descripción:** Esquema de la pantalla de cierre del reporte, con un ícono de confirmación, el título "Incidencia registrada" y un mensaje que informa la revisión por soporte técnico. Una tarjeta resume el código de ticket con su estado, el dispositivo afectado, el tipo de problema, la fecha y hora reportadas y la ubicación del servicio, junto con un aviso de notificaciones por el portal y el teléfono registrado. Las acciones son "Ver seguimiento" y "Volver a incidencias", y el pie ofrece la línea de asistencia para casos críticos.

**Detalle de incidencia - Visita programada**

<div align="center">
  <img src="https://imgur.com/mX0fw71.png" alt="Esquema del detalle de incidencia con visita programada, línea de progreso y evidencias" height="400">
</div>

**Descripción:** Esquema del seguimiento de una incidencia en estado "Visita programada", con el código, el dispositivo, la ubicación y la acción "Descargar ficha". Una línea de progreso de cinco pasos (registrada, en evaluación, visita programada, en atención y resuelta) indica los pasos completados con su fecha. Un bloque destaca la visita técnica en domicilio con fecha, horario, técnico asignado y el botón "Reprogramar visita". Debajo se presentan el detalle del reporte (tipo de problema, fecha y descripción) y las evidencias y entorno (fotografía adjunta y ubicación de la atención). El pie muestra el protocolo de seguridad con el enlace "Ver normas de visita".

**Detalle de incidencia - En atención**

<div align="center">
  <img src="https://imgur.com/aPfcHyd.png" alt="Esquema del detalle de incidencia en atención con técnico asignado y nota de la intervención" height="400">
</div>

**Descripción:** Esquema del seguimiento de la incidencia cuando el técnico ya inició la intervención, con el acceso "Ver dispositivo". La línea de progreso marca la cuarta etapa como activa. Un bloque destacado indica "Atención técnica en curso" con el técnico asignado y la hora de inicio. Debajo se ubican dos tarjetas: el detalle del reporte (dispositivo, tipo de problema, fecha, descripción y evidencias con opción "Ampliar") y la atención en curso (técnico, inicio, estado actual, nota de la intervención y ubicación del servicio).

**Detalle de incidencia - Resuelta**

<div align="center">
  <img src="https://imgur.com/adRPVIQ.png" alt="Esquema del detalle de incidencia resuelta con detalle de resolución y registro fotográfico" height="400">
</div>

**Descripción:** Esquema del seguimiento de una incidencia resuelta, con la acción "Descargar reporte". Todos los pasos de la línea de progreso aparecen completados con su fecha. Un bloque resume el estado del caso con fecha y hora de cierre, técnico asignado y estado general del dispositivo. Dos tarjetas presentan la incidencia reportada (dispositivo, tipo, descripción y ubicación) y el detalle de resolución (trabajo realizado, fecha y hora de finalización, técnico responsable y registro fotográfico del servicio con las imágenes de reporte y resolución). El pie ofrece "Ver dispositivo", "Reportar nuevamente" y "Volver a incidencias".

**Actualizar fotografía de perfil (modal)**

<div align="center">
  <img src="https://imgur.com/3QlAAJY.png" alt="Esquema del modal para actualizar la fotografía de perfil con vista previa y área de carga" height="400">
</div>

**Descripción:** Esquema del modal que se superpone a la vista "Mi perfil" mientras el fondo se atenúa. Presenta el título, una vista previa circular de la imagen, un área de carga con arrastrar y soltar o selección de archivo (JPG o PNG de hasta 5 MB) y las acciones "Reemplazar" y "Eliminar foto actual". El pie incluye "Cancelar" y "Guardar foto".

**Mi perfil del cuidador**

<div align="center">
  <img src="https://imgur.com/SJP1HTr.png" alt="Esquema de Mi perfil del cuidador con datos personales editables y correo verificado de solo lectura" height="400">
</div>

**Descripción:** Esquema de la vista de perfil personal del cuidador, con el título "Mi perfil", la descripción del módulo y la insignia "Modo edición activo". Una tarjeta superior muestra el avatar con acceso a cámara, el nombre, las etiquetas de rol (cuidador principal) y de correo verificado, y el botón "Cambiar foto". El bloque "Datos personales" contiene los campos nombres, apellidos, tipo y número de documento, teléfono de contacto y correo electrónico, este último bloqueado como verificado y no editable, con la indicación de contactar a soporte para modificarlo. El pie del formulario incluye "Cancelar" y "Guardar cambios".

**Contratación guiada - Paso 1: Elige tu plan**

<div align="center">
  <img src="https://imgur.com/iQpIbJ2.png" alt="Esquema de la selección de plan con tarjetas comparativas del Plan Base y el Plan Personalizado" height="400">
</div>

**Descripción:** Esquema del primer paso del flujo público de contratación, con un indicador de progreso de cinco pasos (plan, cuenta, hogar, configuración y evaluación). Presenta el título, un interruptor de facturación mensual o anual con el ahorro indicado y dos tarjetas comparativas: Plan Base, con precio fijo, características incluidas y el botón "Elegir Plan Base", y Plan Personalizado, destacado como máxima flexibilidad, con precio desde, características modulares y el botón "Personalizar plan". Debajo se incluye un bloque de garantía de adaptación y privacidad, y un enlace de ayuda con el horario de atención.

**Contratación guiada - Paso 2: Crea tu cuenta**

<div align="center">
  <img src="https://imgur.com/DmyNsw9.png" alt="Esquema del formulario de creación de cuenta dentro del flujo de contratación" height="400">
</div>

**Descripción:** Esquema del segundo paso, con un resumen del plan elegido y la opción "Cambiar plan", y un selector de estados simulados del formulario. La tarjeta central contiene los campos nombres, apellidos, documento de identidad con tipo y número, teléfono celular, correo electrónico y contraseña con requisitos mínimos, una casilla de aceptación de términos y privacidad conforme a la Ley N.º 29733 y el botón "Crear cuenta".

**Contratación guiada - Paso 3: Hogar (persona asistida)**

<div align="center">
  <img src="https://imgur.com/Z2WGWmW.png" alt="Esquema del registro de la persona asistida con perfil de accesibilidad y contacto de emergencia" height="400">
</div>

**Descripción:** Esquema de la segunda sección del paso Hogar, titulada "¿Quién utilizará Alivia?". Incluye los campos nombres, apellidos, fecha de nacimiento, documento de identidad opcional, relación con el cuidador principal y teléfono directo opcional. Un bloque de perfil de accesibilidad rápida permite elegir el nivel de movilidad y el tipo de comunicación por voz mediante opciones excluyentes. Se añaden el contacto secundario de emergencia opcional, la casilla de confirmación de autorización y las acciones "Volver a ubicación" y "Guardar y continuar".

**Contratación guiada - Paso 3: Hogar (ubicación)**

<div align="center">
  <img src="https://imgur.com/Ve8Fklz.png" alt="Esquema del registro de ubicación del hogar con mapa, dirección normalizada y referencia" height="400">
</div>

**Descripción:** Esquema de la primera sección del paso Hogar, titulada "¿Dónde instalaremos Alivia?". Contiene el alias del hogar con sugerencias rápidas, teléfono y correo de contacto, el campo de dirección con Google Maps y la acción "Usar mi ubicación", un mapa con pin ajustable, un recuadro de dirección normalizada detectada y un campo opcional de referencia para la llegada. Cierra con "Atrás" y "Confirmar ubicación".

**Contratación guiada - Paso 4: Configuración Base**

<div align="center">
  <img src="https://imgur.com/rzSj6ZH.png" alt="Esquema de la configuración del Plan Base con habitación y dispositivos incluidos" height="400">
</div>

**Descripción:** Esquema de la configuración para el Plan Base, con el resumen del plan, el subpaso "Revisa tu plan" y una tarjeta de asignación inicial. Muestra indicadores de importe, espacio, equipos y modalidad, y el detalle de la habitación incluida con sus dispositivos (iluminación adaptativa, puerta motorizada y micrófono asistencial con altavoz) y su cantidad. Ofrece el enlace "Ver qué incluye cada dispositivo", la opción "Cambiar a Personalizado" y las acciones "Atrás" y "Continuar".

**Contratación guiada - Paso 4: Configuración Personalizada (habitaciones)**

<div align="center">
  <img src="https://imgur.com/B5a9yq9.png" alt="Esquema de la selección de habitaciones del Plan Personalizado con acciones de edición" height="400">
</div>

**Descripción:** Esquema del primer subpaso de configuración del Plan Personalizado. Presenta la lista de habitaciones configuradas con nombre, descripción, etiqueta de primer espacio y acciones de editar y eliminar, la acción "Agregar otra habitación" y una barra de resumen con el número de habitaciones, el precio base estimado y el guardado automático. Cierra con "Atrás" y "Elegir dispositivos".

**Contratación guiada - Paso 4: Configuración Personalizada (dispositivos)**

<div align="center">
  <img src="https://imgur.com/bD6YzJx.png" alt="Esquema de la configuración de dispositivos por habitación con cantidades y cuota mensual" height="400">
</div>

**Descripción:** Esquema del segundo subpaso, "Configura cada habitación". Incluye pestañas por habitación con contador de selecciones y tarjetas de control para iluminación, puerta, ventana y micrófono con altavoz asistencial, cada una con su estado (activo o desactivado) y selector de cantidad, salvo el micrófono, que es fijo por habitación. Se muestran un aviso de validación técnica incluida, una barra de resumen con equipos, total de dispositivos y cuota mensual, y las acciones "Volver a habitaciones" y "Revisar configuración".

**Contratación guiada - Paso 4: Revisión de la configuración**

<div align="center">
  <img src="https://imgur.com/oVFpdte.png" alt="Esquema del resumen final de configuración con distribución por ambiente y compromiso de cobro" height="400">
</div>

**Descripción:** Esquema del tercer subpaso, "Revisa tu configuración". Resume el plan, la facturación, el importe estimado, el hogar, el número de habitaciones y de dispositivos, seguido de la distribución por ambiente en bloques desplegables con acción "Editar" y la posibilidad de agregar dispositivos. Un recuadro de compromiso de cobro transparente indica que el importe final se confirma tras la evaluación. Cierra con "Modificar dispositivos", "Continuar a Evaluación" y garantías de protocolo, soporte y cancelación gratuita.

**Contratación guiada - Medio de pago**

<div align="center">
  <img src="https://imgur.com/cZCpxkl.png" alt="Esquema del registro del medio de pago con autorización temporal y resumen del plan" height="400">
</div>

**Descripción:** Esquema del registro del medio de pago mediante autorización temporal. En la columna principal se ubican nombre del titular, correo de facturación y el formulario seguro de tarjeta, con una casilla de aceptación de términos y las acciones "Autorizar y continuar" y "Volver al resumen". La columna lateral muestra el resumen del plan (ambientes, equipamiento y cuota estimada) y el bloque de autorización temporal con cobro de hoy en S/ 0.00.

**Contratación guiada - Paso 5: Programa la evaluación**

<div align="center">
  <img src="https://imgur.com/7zsGY8N.png" alt="Esquema de la programación de la evaluación con calendario, bloques horarios y destino de inspección" height="400">
</div>

**Descripción:** Esquema del primer subpaso de evaluación. Combina un calendario mensual con los días con disponibilidad marcados y una lista de bloques horarios del día elegido (disponible, último cupo o no disponible). Debajo se presenta el destino de inspección con dirección, modalidad y duración, y la acción "Editar ubicación". Cierra con "Volver a configuración" y "Revisar evaluación".

**Contratación guiada - Paso 5: Confirma tu visita**

<div align="center">
  <img src="https://imgur.com/0B4p9UI.png" alt="Esquema de la confirmación de la visita de evaluación con cita, hogar, servicio y receptor" height="400">
</div>

**Descripción:** Esquema del último paso. Muestra cuatro tarjetas con la cita reservada y la acción "Cambiar horario", el hogar con dirección y mapa, el tipo de servicio con duración e importe preautorizado, y el receptor de la visita con teléfono y recordatorio por SMS. Incluye un campo opcional de indicaciones para llegar, la casilla de confirmación de una persona adulta disponible y las acciones "Cambiar horario" y "Confirmar evaluación".

**Seguimiento de contratación - Evaluación**

<div align="center">
  <img src="https://imgur.com/VwQm4Dp.png" alt="Esquema del seguimiento de contratación en etapa de evaluación con visita técnica programada" height="400">
</div>

**Descripción:** Esquema de la pantalla de seguimiento con el código de contratación y una línea de progreso de cuatro etapas (evaluación, confirmación, instalación y activación), con la primera en proceso. Un bloque de evaluación técnica presencial muestra la fecha programada, la ventana de llegada y el lugar de inspección, con la acción "Reprogramar visita", el enlace "Ver requerimientos previos" y un contacto de ayuda.

**Seguimiento de contratación - Confirmación**

<div align="center">
  <img src="https://imgur.com/mpgpWpg.png" alt="Esquema del seguimiento en etapa de confirmación con resultado de evaluación y plan resultante" height="400">
</div>

**Descripción:** Esquema de la segunda etapa del seguimiento, que requiere acción del cliente. Presenta el mensaje "Configuración lista para confirmar", una imagen de la inspección con su identificador, el resultado de la evaluación (viable con adaptación técnica y la adaptación validada) y el plan resultante con su cuota mensual. Incluye el enlace "Solicitar ayuda" y el botón "Revisar y confirmar".

**Seguimiento de contratación - Instalación**

<div align="center">
  <img src="https://imgur.com/Pjg1VRH.png" alt="Esquema del seguimiento en etapa de instalación con fecha, técnico asignado y credencial" height="400">
</div>

**Descripción:** Esquema de la tercera etapa, con las dos primeras completadas. Muestra la instalación programada con fecha, rango horario, dirección de asistencia y una tarjeta del técnico con credencial activa, además de un aviso sobre la presencia de un adulto responsable. Ofrece "Reprogramar visita" y "Ver detalles de instalación", y un enlace de asistencia.

**Seguimiento de contratación - Activación**

<div align="center">
  <img src="https://imgur.com/uLpfSWo.png" alt="Esquema del seguimiento en etapa de activación con sincronización de dispositivos en curso" height="400">
</div>

**Descripción:** Esquema de la cuarta etapa, con las tres primeras completadas y la activación en proceso. Un bloque "Activando el servicio" muestra un indicador de carga de la sincronización de telemetría y sensores, un aviso de confirmación por correo y SMS y el acceso a soporte solo en caso de demora. Tres tarjetas inferiores resumen la activación en la nube, el aviso simultáneo y la instalación certificada.

**Seguimiento de contratación - Servicio activo**

<div align="center">
  <img src="https://imgur.com/4GzR3Zk.png" alt="Esquema de la confirmación de servicio activo con resumen de activación y accesos al hogar y dispositivos" height="400">
</div>

**Descripción:** Esquema de cierre del proceso, con las cuatro etapas completadas. Muestra el mensaje "Tu servicio está activo", un resumen con fecha de activación, plan activo y hogar conectado, una vista previa con el indicador de sensores enlazados y las acciones "Ir a mi hogar" y "Ver dispositivos", junto con la línea de soporte disponible.

**Mi hogar**

<div align="center">
  <img src="https://imgur.com/xmbVRsZ.png" alt="Esquema de Mi hogar con datos generales, ubicación y mapa" height="400">
</div>

**Descripción:** Esquema de la vista de consulta del hogar del cuidador, con el botón "Editar información". Una tarjeta resume el alias, el estado de ubicación validada, el cuidador principal y la persona asistida. Se presentan los bloques de datos generales (alias, teléfono y correo asociados) y de ubicación (dirección normalizada, distrito y referencia), acompañados de un mapa con el marcador del hogar y el acceso "Ver en Google Maps".

**Editar información del hogar (panel lateral)**

<div align="center">
  <img src="https://imgur.com/VI20AG4.png" alt="Esquema del panel lateral para editar los datos de contacto del hogar" height="400">
</div>

**Descripción:** Esquema del panel lateral que se superpone a Mi hogar. Incluye los campos alias del hogar con contador de caracteres, teléfono asociado y correo asociado, y un recuadro de ubicación actual validada que indica que la dirección se gestiona en un flujo independiente, con el enlace "Actualizar ubicación". El pie ofrece "Cancelar" y "Guardar cambios".

**Suscripción**

<div align="center">
  <img src="https://imgur.com/k9JArTp.png" alt="Esquema de la suscripción con plan contratado, cobertura, medio de pago y último pago" height="400">
</div>

**Descripción:** Esquema de la vista de suscripción del cuidador, con el estado activo y la fecha y monto del próximo cobro. La tarjeta "Tu plan" muestra el plan, su precio, las fechas de inicio y renovación, la cobertura incluida y las acciones "Cambiar plan", "Ver detalles del plan", "Suspender suscripción" y "Cancelar suscripción". La tarjeta "Facturación y medio de pago" presenta la tarjeta registrada con cobro automático, la acción "Actualizar medio de pago" y el último pago con monto, fecha, método y la acción "Descargar comprobante".

**Resumen de autonomía (Métricas)**

<div align="center">
  <img src="https://imgur.com/LFa91st.png" alt="Esquema del resumen de autonomía con gráfico semanal, nivel de autonomía y uso por dispositivo" height="400">
</div>

**Descripción:** Esquema de la vista de métricas del cuidador, con el título "Resumen de autonomía", una insignia que indica cuántos dispositivos requieren atención, la hora de la última actualización y un selector de periodo (Hoy, 7 días, 30 días). El bloque "Autonomía semanal" muestra un gráfico de barras apiladas por día de la semana que distingue las acciones autónomas de las realizadas con asistencia, con el día actual resaltado. A su derecha, la tarjeta "Nivel de autonomía" presenta un gráfico circular con el porcentaje global y el desglose entre acciones autónomas y con asistencia. En la parte inferior, el bloque "Uso por dispositivo" lista cada dispositivo (luz del dormitorio, micrófono asistencial, puerta principal, ventana del dormitorio y luz del pasillo) con una barra de proporción y su indicador de uso (tiempo, comandos, aperturas o acciones).

**Panel de notificaciones del cuidador**

<div align="center">
  <img src="https://imgur.com/Lt5AbX0.png" alt="Esquema del panel de notificaciones del cuidador con solicitud de asistencia, batería baja y actividad próxima" height="400">
</div>

**Descripción:** Esquema del panel desplegable de notificaciones que se superpone a la vista de resumen del hogar, accesible desde el ícono de campana del encabezado. En la vista de fondo se observan la tarjeta del plan activo con la persona asistida vinculada, los indicadores de dispositivos activos y de estado del adulto, y la bitácora de eventos recientes en tiempo real con hora de cada evento. El panel muestra el contador de notificaciones nuevas, las acciones "Ver vacío", "Marcar todas como leídas" y cerrar, y pestañas de filtrado (Todas y Sin leer). Las notificaciones del día se presentan como tarjetas con ícono, título, tiempo transcurrido y descripción: la solicitud de asistencia, destacada con el botón "Ver solicitud", la batería baja con el enlace "Ver dispositivo" y la actividad próxima con el enlace "Ver actividad". Al pie se ubica la sección "Anteriores" con las notificaciones leídas.

### Web Application - Usuarios - Cuidador (Invitados)

**Inicio del cuidador invitado**

<div align="center">
  <img src="https://imgur.com/2KJIPEy.png" alt="Esquema de la pantalla de inicio del cuidador invitado con saludo de bienvenida y tarjeta de próxima actividad" height="400">
</div>

**Descripción:** Esquema de la pantalla de inicio del cuidador invitado. La barra lateral muestra la marca Alivia con el rol de cuidador y la insignia "Invitado", e incluye los accesos a Inicio, Persona asistida, Actividades y Mi perfil, además de la opción de cerrar sesión. En el encabezado se ubican el selector de hogar y persona asistida con la etiqueta "Cuidador de apoyo", el ícono de campana de notificaciones y los datos del usuario. En el contenido principal se observan la fecha actual, el saludo de bienvenida y una etiqueta con la persona a cargo. Debajo se presenta la tarjeta de "Próxima actividad" con su estado "En curso", la hora, el nombre de la actividad, la persona asistida y una breve indicación de apoyo, junto con el botón "Ver actividad" y el enlace "Ver mis actividades".

**Mis actividades - Vista de horarios**

<div align="center">
  <img src="https://imgur.com/EtrkPAC.png" alt="Esquema de la vista semanal de horarios de actividades del cuidador invitado" height="400">
</div>

**Descripción:** Esquema de la vista de calendario semanal de las actividades asignadas al cuidador invitado. En la parte superior se encuentra el selector que alterna entre las vistas "Lista" y "Horarios", los controles de navegación entre semanas con el botón "Hoy", el rango de fechas de la semana, el filtro por estado y la persona asistida. La cuadrícula muestra los días de lunes a domingo con el día actual resaltado, las franjas horarias y una línea que indica la hora actual. Las actividades aparecen como bloques con su hora, nombre y persona asistida, y se distinguen por estado: completada, pendiente (resaltada), vencida con ícono de alerta, programada y cancelada con texto tachado. Al pie de la barra lateral se muestra el indicador de conexión.

**Mis actividades - Vista de lista**

<div align="center">
  <img src="https://imgur.com/YV0D215.png" alt="Esquema de la vista de lista de actividades del cuidador invitado agrupadas por día" height="400">
</div>

**Descripción:** Esquema de la vista de lista de las actividades asignadas al cuidador invitado, accesible desde el selector "Lista". Incluye una barra de filtros por periodo ("Esta semana") y por estado ("Todos los estados"), junto con la persona asistida. Las actividades se agrupan en secciones por día (Hoy, Mañana y Próximas) con el contador de actividades de cada grupo. Cada fila muestra la hora, el nombre de la actividad, un ícono de recurrencia, la persona asistida y una etiqueta de estado (Completada, Pendiente, Vencida, Programada o Cancelada), además de una flecha para abrir el detalle. Las actividades canceladas se presentan con un tono atenuado.

**Detalle de actividad en modo solo lectura**

<div align="center">
  <img src="https://imgur.com/q6hH0Ii.png" alt="Esquema de la ventana de consulta de una actividad en modo solo lectura" height="400">
</div>

**Descripción:** Esquema de la ventana modal de consulta de una actividad, que se abre al seleccionar una fila de la lista de actividades. Muestra el título de la actividad y la persona asistida a la que está asignada, junto con un cuadro de estado (por ejemplo, "Completada"). Debajo se detallan el horario programado, la categoría, la frecuencia y las indicaciones registradas para la actividad. Al final se incluye un aviso de "Modo solo lectura", que indica que la actividad es gestionada por la cuidadora titular y que cualquier reprogramación o consulta clínica debe coordinarse directamente con ella. La ventana se cierra con el botón "Cerrar" o con el ícono de la esquina superior.

**Persona asistida**

<div align="center">
  <img src="https://imgur.com/YKtbbED.png" alt="Esquema de la pantalla de consulta de la persona asistida con su información personal y asociada" height="400">
</div>

**Descripción:** Esquema de la pantalla de consulta de la información registrada de la persona asistida. La barra lateral organiza la navegación en las secciones Principal, Cuidado (Persona asistida, Red de cuidado y Actividades), Hogar (Mi hogar y Dispositivos) y Servicio (Contratación, Suscripción e Incidencias), con los accesos a Mi perfil y Cerrar sesión al pie. En el encabezado se observan la ruta de navegación, el ícono de campana y los datos del usuario con su rol. El contenido principal presenta una tarjeta con la foto, el nombre completo, la etiqueta "Perfil completo", la edad y el hogar de la persona asistida, junto con el botón "Editar información". Debajo se detallan dos bloques: la información personal (nombres, apellidos, tipo y número de documento con la etiqueta "Documento validado", fecha de nacimiento y parentesco) y la información asociada (hogar relacionado con su alias, cuidador principal con su parentesco y teléfono de contacto).

**Mi perfil - Modo edición**

<div align="center">
  <img src="https://imgur.com/VPnvpKL.png" alt="Esquema del formulario de edición de datos personales del cuidador" height="400">
</div>

**Descripción:** Esquema de la pantalla "Mi perfil" con el indicador "Modo edición activo". En la parte superior se muestra una tarjeta con la foto de perfil, el nombre completo, las etiquetas "Cuidador principal" y "Correo verificado" y el botón "Cambiar foto". Debajo, el bloque "Datos personales" con la marca "Edición requerida" contiene el formulario con los campos de nombres, apellidos, tipo de documento (selector), número de documento, teléfono de contacto y correo electrónico. Cada campo incluye un texto de ayuda, y los obligatorios se marcan con asterisco. El correo aparece bloqueado con la etiqueta "Verificado (no editable)" e indica que, para modificarlo, se debe contactar con soporte. El formulario cierra con los botones "Cancelar" y "Guardar cambios".

**Actualizar fotografía**

<div align="center">
  <img src="https://imgur.com/AkbRPRd.png" alt="Esquema de la ventana modal para actualizar la fotografía de perfil" height="400">
</div>

**Descripción:** Esquema de la ventana modal "Actualizar fotografía", que se superpone a la pantalla "Mi perfil" y se abre desde el botón "Cambiar foto". La ventana muestra una vista previa circular de la imagen seleccionada y una zona para arrastrar o seleccionar un archivo, con la indicación de formatos JPG o PNG y un tamaño máximo de 5 MB. Debajo se ubican las acciones "Reemplazar" y "Eliminar foto actual", y al pie los botones "Cancelar" y "Guardar foto". La ventana se puede cerrar con el ícono de la esquina superior, mientras que el fondo de la pantalla se muestra atenuado.

**Panel de notificaciones del cuidador**

<div align="center">
  <img src="https://imgur.com/Lt5AbX0.png" alt="Esquema del panel de notificaciones del cuidador con solicitud de asistencia, batería baja y actividad próxima" height="400">
</div>

**Descripción:** Esquema del panel desplegable de notificaciones que se superpone a la vista de resumen del hogar, accesible desde el ícono de campana del encabezado. En la vista de fondo se observan la tarjeta del plan activo con la persona asistida vinculada, los indicadores de dispositivos activos y de estado del adulto, y la bitácora de eventos recientes en tiempo real con hora de cada evento. El panel muestra el contador de notificaciones nuevas, las acciones "Ver vacío", "Marcar todas como leídas" y cerrar, y pestañas de filtrado (Todas y Sin leer). Las notificaciones del día se presentan como tarjetas con ícono, título, tiempo transcurrido y descripción: la solicitud de asistencia, destacada con el botón "Ver solicitud", la batería baja con el enlace "Ver dispositivo" y la actividad próxima con el enlace "Ver actividad". Al pie se ubica la sección "Anteriores" con las notificaciones leídas.

### Mobile Application

En esta sección se presentan los esquemas de media fidelidad diseñados para la aplicación móvil de Alivia. El enfoque principal de estos wireframes es el acceso seguro a la cuenta y la recepción oportuna de notificaciones, de modo que técnicos y cuidadores puedan reaccionar con rapidez ante solicitudes de auxilio, fallas de dispositivos y cambios en sus actividades. La arquitectura de información busca reducir los pasos en cada flujo y mostrar solo lo necesario en pantallas pequeñas, cuidando además la privacidad de los datos de la persona asistida cuando el teléfono está bloqueado.

**Pantalla de carga inicial**

<div align="center">
  <img src="https://imgur.com/t5e63GV.png" alt="Esquema de la pantalla de carga inicial con el logotipo de Alivia y el mensaje Iniciando sistema" height="600">
</div>

**Descripción:** Esquema de la pantalla de carga que se muestra al abrir la aplicación. Presenta el logotipo de Alivia centrado, un indicador de progreso circular en la parte inferior y el mensaje "Iniciando sistema...", mientras la aplicación se prepara para mostrar la pantalla de acceso.

**Inicio de Sesión**

<div align="center">
  <img src="https://imgur.com/0ABAfzB.png" alt="Esquema de la pantalla de inicio de sesión con campos de correo electrónico y contraseña" height="600">
</div>

**Descripción:** Esquema de la pantalla de inicio de sesión con el mensaje de bienvenida y dos campos de acceso: correo electrónico, con un texto de ayuda que indica que se puede usar el correo institucional o de cuidador, y contraseña, con ícono para mostrar u ocultar el texto. Incluye el enlace "¿Olvidaste tu contraseña?" y el botón principal "Ingresar".

**Recuperar contraseña**

<div align="center">
  <img src="https://imgur.com/Vqig3Lh.png" alt="Esquema de la pantalla de recuperación de contraseña con campo de correo y mensaje de código enviado" height="600">
</div>

**Descripción:** Esquema de la pantalla para iniciar la recuperación de la cuenta. Contiene una indicación de que se enviará un código de verificación de 6 dígitos al correo asociado, el campo de correo electrónico, el botón "Enviar código" y el enlace "Volver al inicio de sesión". Tras el envío, se muestra un mensaje emergente en la parte inferior con el texto "Código enviado a tu correo" y la acción "Cerrar". La flecha superior permite regresar a la pantalla anterior.

**Verificación de correo**

<div align="center">
  <img src="https://imgur.com/oPF7HqJ.png" alt="Esquema de la pantalla de verificación con seis casillas para el código y temporizador de reenvío" height="600">
</div>

**Descripción:** Esquema de la pantalla de verificación del código enviado al correo del usuario, que se muestra parcialmente oculto por privacidad. Presenta seis casillas individuales para ingresar el código, con la casilla activa resaltada, y una nota sobre la compatibilidad con el autocompletado desde SMS o correo. Debajo se ubica un temporizador para reenviar el código junto al enlace "Reenviar código", que permanece deshabilitado hasta que termina la cuenta regresiva, y el botón "Verificar".

**Nueva contraseña**

<div align="center">
  <img src="https://imgur.com/Pc0LvlG.png" alt="Esquema de la pantalla de nueva contraseña con requisitos de seguridad" height="600">
</div>

**Descripción:** Esquema de la pantalla para crear una nueva contraseña durante la recuperación de la cuenta. Incluye los campos "Nueva contraseña" y "Confirmar contraseña", ambos con ícono para mostrar u ocultar el texto, y un bloque de requisitos de seguridad (mínimo de 8 caracteres, al menos una letra mayúscula y al menos un número) con indicadores de cumplimiento. Finaliza con el botón "Cambiar contraseña".

**Contraseña actualizada**

<div align="center">
  <img src="https://imgur.com/jpaTUSN.png" alt="Esquema de la pantalla de confirmación de contraseña actualizada" height="600">
</div>

**Descripción:** Esquema de la pantalla de confirmación que se muestra al completar el cambio de contraseña. Presenta un ícono de verificación centrado, el título "Contraseña actualizada", un mensaje que indica que ya se puede ingresar con las nuevas credenciales y el botón "Volver a iniciar sesión".

**Establecer contraseña**

<div align="center">
  <img src="https://imgur.com/GIGAjAl.png" alt="Esquema de la pantalla para establecer contraseña con mensaje de confirmación" height="600">
</div>

**Descripción:** Esquema de la pantalla para definir la contraseña de la cuenta, con la indicación de ingresar una clave segura para protegerla. Contiene los campos "Nueva contraseña" y "Confirmar contraseña" con ícono para mostrar u ocultar el texto, una lista con los requisitos mínimos (8 caracteres, una mayúscula y un número) y el botón "Actualizar contraseña". Al guardar, aparece un mensaje emergente en la parte inferior con el texto "Contraseña actualizada correctamente".

**Notificaciones dentro de la aplicación**

<div align="center">
  <img src="https://imgur.com/AQ6V5gl.png" alt="Esquema de la pantalla de notificaciones con filtros y avisos agrupados por día" height="600">
</div>

**Descripción:** Esquema de la pantalla de notificaciones dentro de la aplicación. En el encabezado se ubican la flecha de retroceso, el título y la acción "Marcar todas". Debajo se encuentran las pestañas de filtrado "Todas", "No leídas" y "Críticas", cada una con su contador. Las notificaciones se agrupan por día (Hoy y Ayer) y se presentan como filas con ícono según el tipo de aviso, título, hora, descripción y un indicador de no leída. Se muestran ejemplos de una falla de actuador en una puerta, una nueva evaluación técnica asignada y un mantenimiento de firmware ya leído.

**Notificaciones push en Android**

<div align="center">
  <img src="https://imgur.com/iPDLQxx.png" alt="Esquema de las notificaciones push de Alivia en Android con alertas, acciones y agrupación por hogar" height="600">
</div>

**Descripción:** Esquema del panel de notificaciones del sistema en Android, entregadas mediante FCM, con la acción "Borrar todo". La primera tarjeta corresponde a una alerta de prioridad alta por una solicitud de auxilio, con las acciones "Atenderé" y "Ver alerta". Le siguen las tarjetas de actividad próxima (con "Ver actividad") y de nueva actividad asignada (con "Ver detalle"). Los avisos de dispositivo sin conexión y batería baja se agrupan por hogar en un bloque expandible, cada uno con la acción "Ver dispositivo". También se incluye el aviso de horario actualizado con la acción "Ver cambio". Al pie, una nota describe el Modo Bloqueo Seguro: con el teléfono bloqueado solo se muestra un mensaje genérico, sin datos de la persona ni del hogar.

**Notificaciones push en iOS**

<div align="center">
  <img src="https://imgur.com/KnwFL21.png" alt="Esquema de las notificaciones push de Alivia en iOS con banner, alerta crítica, pila agrupada y protección de datos" height="600">
</div>

**Descripción:** Esquema de los tipos de notificación push de Alivia en iOS, organizado en cuatro casos siguiendo las pautas de Apple. El primero es el banner superior que aparece con el teléfono desbloqueado, con un aviso de actividad próxima. El segundo es la alerta crítica expandida, marcada como urgente, con las acciones "Atenderé" y "Ver alerta". El tercero es la pila agrupada por hogar en el Centro de notificaciones, con la opción de tocar para desplegar más avisos. El cuarto muestra las notificaciones de dispositivo sin conexión, batería baja y horario actualizado. Al pie, un recuadro de protección de datos sensibles indica que, antes de autenticarse con Face ID, solo se muestra un mensaje genérico de nueva alerta.

#### Usuarios - Cuidador o Familiar (Principal)

**Inicio**

<div align="center">
  <img src="https://imgur.com/C21rxmx.png" alt="Esquema de la pantalla de inicio del cuidador principal con resumen de actividad, red de cuidado y persona asistida" height="600">
</div>

**Descripción:** Esquema de la pantalla de inicio del cuidador principal, con un saludo personalizado, un mensaje de bienvenida y el ícono de notificaciones con indicador. Presenta tres tarjetas de resumen: la próxima actividad, con su estado, fecha, hora, persona a cargo y el enlace "Ver actividades"; la red de cuidado, con el número de vinculados, sus avatares, el cuidador principal y el enlace "Ver red de cuidado"; y la persona asistida, con su edad, la etiqueta "Sin alertas" y el enlace "Ver perfil". La barra inferior da acceso a Inicio, Actividades, Dispositivos, Historial y Perfil.

**Red de cuidado**

<div align="center">
  <img src="https://imgur.com/7CesmI9.png" alt="Esquema de la pantalla de red de cuidado con cuidador principal y cuidadores de apoyo" height="600">
</div>

**Descripción:** Esquema de la pantalla que muestra a los cuidadores vinculados a la persona asistida. En la parte superior se identifican la persona y su hogar, junto con un contador de cuidadores vinculados. El listado se divide en "Cuidador principal" y "Otros cuidadores"; cada fila incluye avatar o iniciales, nombre, rol o parentesco, estado de vinculación y una flecha de detalle. Al pie, un aviso informa que la gestión de cuidadores se realiza desde la plataforma web y ofrece el enlace "Ir a la web".

**Perfil de la persona asistida**

<div align="center">
  <img src="https://imgur.com/JKjQRC0.png" alt="Esquema de la pantalla de perfil de la persona asistida con información personal y asociada" height="600">
</div>

**Descripción:** Esquema de la pantalla de consulta del perfil de la persona asistida, accesible desde el enlace "Ver perfil" del inicio. En la parte superior se muestran la foto con indicador de verificación, el nombre completo, la etiqueta "Perfil completo", la edad y el hogar. Debajo se organizan dos bloques de solo consulta: información personal (nombres, apellidos, documento con la etiqueta "Validado", fecha de nacimiento y parentesco) e información asociada (hogar relacionado, cuidador principal, relación y teléfono de contacto).

**Actividades - Vista de lista**

<div align="center">
  <img src="https://imgur.com/BhJ3ckz.png" alt="Esquema de la pantalla de actividades en lista agrupadas por día y estado" height="600">
</div>

**Descripción:** Esquema de la pantalla de actividades en formato de lista. En la parte superior se encuentran el título, el ícono de notificaciones, el acceso al perfil y una tarjeta con el paciente asignado y la etiqueta "Turno Activo". Debajo se ubican el selector entre las vistas "Lista" y "Calendario", el botón de filtros y el botón para crear una actividad. Las tareas se agrupan en las secciones Hoy, Mañana, Próximas y Anteriores, con un contador por grupo. Cada fila muestra la hora, un ícono según el tipo de actividad, el nombre, el responsable y una etiqueta de estado (Completada, Pendiente u Omitida), junto con una flecha para abrir el detalle.

**Actividades - Vista de calendario**

<div align="center">
  <img src="https://imgur.com/yd3A8jz.png" alt="Esquema de la pantalla de actividades en calendario con listado del día seleccionado" height="600">
</div>

**Descripción:** Esquema de la pantalla de actividades en formato de calendario. Incluye la tarjeta de la persona asistida con su hogar y habitación, un botón para cambiar de persona, el selector Lista/Calendario y el botón "Nueva". El calendario mensual muestra el número de semana, el botón "Hoy", las flechas de navegación, puntos en los días con actividades y el día seleccionado resaltado. Debajo se listan las actividades del día elegido con un contador, y cada una muestra hora, ícono, nombre, responsable y estado. La actividad pendiente más próxima aparece resaltada con el tiempo restante y el botón "Marcar" para registrarla.

**Nueva programación - Paso 1: Actividad**

<div align="center">
  <img src="https://imgur.com/uTwWDCL.png" alt="Esquema del primer paso para programar una actividad con tipo de actividad y detalle" height="600">
</div>

**Descripción:** Esquema del primer paso del flujo para programar una actividad. En el encabezado se muestran la flecha de retroceso, el título, el indicador "Paso 1 de 2" y el acceso al perfil, seguidos de un selector de pasos (Actividad y Programación). El formulario presenta la persona asistida con su hogar, los tipos de actividad como chips desplazables (Rutina, Medicamento y Alimentación, entre otros) y un bloque de detalle con el nombre de la actividad y el medicamento por seleccionar. Una nota indica que el medicamento se elige del catálogo autorizado para la persona. El flujo continúa con el botón "Continuar".

**Nueva programación - Paso 2: Programación (propuesta A)**

<div align="center">
  <img src="https://imgur.com/AfIAEqh.png" alt="Esquema del segundo paso de programación con fecha, hora, periodicidad y responsable" height="600">
</div>

**Descripción:** Esquema del segundo paso del flujo de programación, con el paso 1 marcado como completado. Muestra una tarjeta resumen del medicamento y la persona asistida, los selectores de fecha y hora de toma, la periodicidad ("No se repite") y el responsable en turno, con la opción "Delegar". Incluye un campo opcional para la instrucción del momento de la toma, con contador de 140 caracteres, y un aviso sobre la alerta sonora de alta prioridad que se envía 15 minutos antes al móvil del cuidador en turno. Al pie se ubican los botones "Atrás" y "Confirmar Programación".

**Nueva programación - Paso 2: Programación (propuesta B)**

<div align="center">
  <img src="https://imgur.com/wvrHJBc.png" alt="Variante del segundo paso de programación con secciones de fecha, frecuencia, repetición y responsable" height="600">
</div>

**Descripción:** Variante del segundo paso del flujo de programación, con una barra de progreso segmentada y un enlace para volver al paso anterior. La pantalla organiza la información en secciones: la tarjeta de la actividad con la persona asistida y su hogar; fecha y hora fijadas; frecuencia registrada ("Pauta registrada"); repetición; y responsable. Incluye un campo opcional de instrucción, con límite de 120 caracteres y la nota "Visible para el relevo de turno", y un aviso que indica que la actividad generará una notificación prioritaria en el panel diario. Finaliza con los botones "Atrás" y "Confirmar Programación".

**Detalle de actividad**

<div align="center">
  <img src="https://imgur.com/7Veo4PF.png" alt="Esquema de la pantalla de detalle de una actividad con responsable, frecuencia e instrucción" height="600">
</div>

**Descripción:** Esquema de la pantalla de detalle de una actividad. Un banner superior indica el modo de permisos del cuidador y la etiqueta "Turno Activo". La tarjeta principal muestra las etiquetas de tipo y estado (con el tiempo restante), el nombre de la actividad y su programación. Debajo se presentan las secciones de persona asistida, fecha y horario, tipo de actividad con la pauta registrada, responsable del turno, frecuencia y ciclo, e instrucción clínica breve. El botón "Registrar resultado" se ubica al pie, con una nota que indica que solo está disponible para tareas pendientes durante el turno asignado.

**Dispositivos**

<div align="center">
  <img src="https://imgur.com/nTGvhBM.png" alt="Esquema de la pantalla de dispositivos agrupados por habitación con indicadores de incidencia y batería" height="600">
</div>

**Descripción:** Esquema de la pantalla de supervisión de dispositivos del hogar. En la parte superior se muestra el estado de sincronización en tiempo real y el hogar, seguidos de tres indicadores de resumen: dispositivos vinculados, dispositivos con incidencia y dispositivos con batería baja. Debajo, bajo el título "Prioridad de supervisión", los equipos se agrupan por habitación con un contador. Cada tarjeta muestra el nombre del dispositivo, su estado (en línea, conectado, desconectado, abierta o cerrada), una descripción breve, el protocolo de conexión y la fuente de energía o nivel de batería. Los dispositivos con problemas aparecen primero.

**Detalle del dispositivo - Operativo**

<div align="center">
  <img src="https://imgur.com/dKLouHW.png" alt="Esquema del detalle de un dispositivo operativo con conectividad y batería normales" height="600">
</div>

**Descripción:** Esquema de la pantalla de detalle de un dispositivo que funciona con normalidad. Presenta el ícono, el nombre, el tipo y la ubicación del dispositivo, junto con la etiqueta "Operativo". Una tarjeta de estado confirma el correcto funcionamiento y el tiempo de la última actualización. El bloque "Información esencial" detalla el estado actual, la conectividad, el nivel de batería y la última actualización. Al final se ubica el acceso "Ver historial del dispositivo", y en el encabezado, el menú de opciones.

**Detalle del dispositivo - Desconectado**

<div align="center">
  <img src="https://imgur.com/28ljJ8u.png" alt="Esquema del detalle de un dispositivo desconectado con último estado conocido y problema detectado" height="600">
</div>

**Descripción:** Esquema de la pantalla de detalle de un dispositivo sin conexión. La tarjeta destacada informa "Conexión interrumpida" y la hora de la última señal recibida. Debajo se muestran el estado actual, la conectividad, el nivel de batería bajo y la última actualización. El bloque "Último estado conocido" indica la última posición registrada del dispositivo y advierte que pudo haber cambiado durante la desconexión. Se incluye además un resumen del problema detectado y el acceso "Ver historial del dispositivo".

**Historial**

<div align="center">
  <img src="https://imgur.com/Ry4mbm7.png" alt="Esquema de la pantalla de historial con eventos agrupados por día" height="600">
</div>

**Descripción:** Esquema de la pantalla de historial de eventos de la persona asistida. En el encabezado se ubican el título, el ícono de notificaciones y el acceso al perfil, seguidos de un selector de persona con su hogar y los filtros "Todos" y "Filtrar". Los eventos se agrupan en Hoy, Ayer y Anteriores, y se presentan como filas con ícono, descripción, detalle, hora y una flecha para abrir el registro. Entre ellos se incluyen comandos de voz, actividades completadas, aperturas de puertas, ajustes de ventanas y solicitudes de auxilio atendidas. Al final aparece un indicador de carga de eventos anteriores.

**Mi suscripción - Plan Base**

<div align="center">
  <img src="https://imgur.com/WEChBgr.png" alt="Esquema de la pantalla de suscripción con Plan Base, facturación y configuración incluida" height="600">
</div>

**Descripción:** Esquema de la pantalla de consulta de la suscripción para un hogar con Plan Base. La tarjeta superior muestra el nombre del plan, la etiqueta "Activa", la indicación de configuración fija y el hogar asociado. Debajo se resalta la próxima facturación con su monto, periodicidad y fecha. Luego se detalla la información del servicio (estado, fecha de inicio, periodicidad, próxima facturación, monto de renovación y hogar asociado) y la configuración incluida con el total de dispositivos: habitaciones, cubo de voz, luces, puertas y ventanas. Al pie se ubica el botón "Gestionar en la web", acompañado de una nota que indica que los cambios de cobertura o facturación se realizan en la plataforma web.

**Mi suscripción - Plan Personalizado**

<div align="center">
  <img src="https://imgur.com/t8Q1UyE.png" alt="Esquema de la pantalla de suscripción con Plan Personalizado y configuración actual" height="600">
</div>

**Descripción:** Esquema de la pantalla de consulta de la suscripción para un hogar con Plan Personalizado. La tarjeta superior muestra el nombre del plan, la etiqueta "Activa", el hogar y la fecha de próxima renovación. El bloque de información del servicio detalla el estado de sincronización, la fecha de inicio, la renovación, la periodicidad y el hogar asociado. La configuración actual lista las habitaciones configuradas con sus nombres, el total de dispositivos y la cantidad de cada tipo (cubo de voz, luces, puertas y ventanas). La pantalla cierra con el botón "Gestionar en la web" y la nota sobre modificaciones en la plataforma web.

**Perfil del usuario**

<div align="center">
  <img src="https://imgur.com/7kLJQY6.png" alt="Esquema de la pantalla de perfil del usuario con información personal y acceso a la suscripción" height="600">
</div>

**Descripción:** Esquema de la pantalla de perfil del usuario de la aplicación. Muestra la foto con el botón de cámara, el nombre completo y el rol, junto con el bloque de información personal (nombres, apellidos, documento de identidad, teléfono móvil y correo electrónico) y el botón "Editar". Debajo se ubica la tarjeta "Mi suscripción", que da acceso a los detalles y la cobertura del plan, y al final, la opción "Cerrar sesión". La barra inferior marca la sección Perfil como activa.

#### Usuarios - Técnico

**Inicio**

<div align="center">
  <img src="https://imgur.com/gPijL82.png" alt="Esquema de la pantalla de inicio del técnico con jornada activa, estado vacío y últimas órdenes" height="600">
</div>

**Descripción:** Esquema de la pantalla de inicio del técnico en campo, con el saludo, la fecha y el ícono de notificaciones. Una barra de estado muestra la jornada activa, el horario laboral y el número de órdenes del día. Cuando no hay asignaciones, se presenta un estado vacío con un mensaje informativo y el botón "Ver mi horario". Debajo se ubica la sección "Últimas órdenes", con los servicios finalizados recientemente; cada tarjeta indica el código de orden, la fecha, el estado "Completada", el tipo de servicio y el hogar. La barra inferior da acceso a Inicio, Órdenes, Horario y Perfil.

**Órdenes - Vista de lista**

<div align="center">
  <img src="https://imgur.com/MyVCOgn.png" alt="Esquema de la pantalla de órdenes en lista agrupadas por día con filtros por tipo de servicio" height="600">
</div>

**Descripción:** Esquema de la pantalla de órdenes en formato de lista. En el encabezado se muestran el título, el resumen de órdenes por día, el ícono de notificaciones y el acceso al perfil. Debajo se ubican el selector entre las vistas "Lista" y "Calendario" y los filtros por tipo de servicio (Todas, Revisiones, Instalaciones e Incidencias). Las órdenes se agrupan en Hoy, Mañana y Próximas, con un contador por grupo. Cada tarjeta muestra el hogar, el tipo de servicio con su horario, el distrito y una etiqueta de estado (En proceso, Programada, Pendiente o Completada); la orden que sigue en la jornada se destaca con la marca "Siguiente".

**Órdenes - Vista de calendario**

<div align="center">
  <img src="https://imgur.com/LsgD7Bu.png" alt="Esquema de la pantalla de órdenes en calendario semanal con leyenda por tipo de servicio" height="600">
</div>

**Descripción:** Esquema de la pantalla de órdenes en formato de calendario semanal. Incluye el mes, el número de semana, las flechas de navegación y los días de la semana con el día actual resaltado y puntos que indican la cantidad y el tipo de órdenes. Una leyenda diferencia incidencias, instalaciones y revisiones, y los filtros por tipo se mantienen debajo. Las órdenes del día seleccionado se listan con un contador y, en cada tarjeta, se muestran el hogar, el tipo de servicio, el horario, la dirección, el estado y un dato complementario como el equipo asociado, la prioridad o el kit asignado. La orden en curso aparece marcada como "Siguiente" y las demás indican el tiempo restante o el motivo del servicio.

**Mi horario**

<div align="center">
  <img src="https://imgur.com/Q7gVKye.png" alt="Esquema de la pantalla de horario diario con línea de tiempo de visitas y espacios disponibles" height="600">
</div>

**Descripción:** Esquema de la pantalla de horario diario del técnico. En la parte superior se muestran el rango de la semana, las flechas de navegación, el botón "Hoy" y la tira de días con el día actual resaltado. Un resumen indica la jornada laboral, el número de órdenes y las horas libres. Debajo se presenta una línea de tiempo vertical que parte del inicio de jornada y termina en el fin de jornada, con tarjetas por cada visita (tipo de servicio, hogar y distrito) y los espacios "Disponible" entre ellas, con su duración. Al pie se indica que el horario es administrado por Alivia, por lo que el técnico solo lo consulta.

**Detalle de orden (propuesta A)**

<div align="center">
  <img src="https://imgur.com/vsLUFuo.png" alt="Esquema del detalle de una orden de servicio con datos de la visita y solicitud" height="600">
</div>

**Descripción:** Esquema de la pantalla de detalle de una orden de servicio. En el encabezado se muestran la flecha de retroceso, el título y el código de la orden, seguidos de las etiquetas de tipo y estado, el hogar, el distrito y el horario programado. El bloque "Visita" reúne al responsable en el domicilio con el botón "Llamar", la dirección con el enlace "Abrir en Maps" y la referencia de acceso con el enlace "Ver indicaciones completas". El bloque "Solicitud" presenta el dispositivo, su ubicación, el problema reportado con su descripción y la fotografía adjunta con opción de ampliarla. Al pie se ubica el botón "Iniciar atención", con una nota que indica que se pedirá confirmación antes de cambiar la orden a "En proceso".

**Detalle de orden (propuesta B)**

<div align="center">
  <img src="https://imgur.com/WMzf4l7.png" alt="Variante del detalle de orden con indicaciones desplegables y fotografía adjunta" height="600">
</div>

**Descripción:** Variante de la pantalla de detalle de orden con la misma estructura de visita y solicitud. En esta versión, el botón "Llamar" se destaca con color sólido y la referencia de acceso se muestra resumida, con un control para desplegar las indicaciones completas. El bloque de problema reportado resalta su título y la fotografía adjunta se abre al tocar la fila completa. El botón "Iniciar atención" se mantiene fijo al pie de la pantalla, acompañado de una nota sobre la confirmación previa.

**Confirmación de inicio de atención**

<div align="center">
  <img src="https://imgur.com/X5RsL40.png" alt="Esquema de la hoja de confirmación para iniciar la atención de una orden" height="600">
</div>

**Descripción:** Esquema de la hoja inferior de confirmación que aparece al pulsar "Iniciar atención", superpuesta a la pantalla de detalle, que se muestra atenuada. Presenta un ícono de herramienta, el título "¿Iniciar atención?" y una breve instrucción. Un resumen muestra el código de orden, el tipo de servicio, el hogar beneficiario y el horario programado. Una nota informa que la orden pasará al estado "En proceso" y que se registrará la hora exacta de inicio para efectos de trazabilidad. Las acciones disponibles son "Iniciar atención" y "Cancelar".

**Registro de dispositivo**

<div align="center">
  <img src="https://imgur.com/05jVb9M.png" alt="Esquema del registro de dispositivo con alias, dirección MAC y validaciones" height="600">
</div>

**Descripción:** Esquema de la pantalla de registro de dispositivos durante una instalación. El encabezado muestra el título, el paso del flujo y las acciones de cerrar y acceso a la cuenta. Una tarjeta de progreso indica el paso actual (Dispositivos), el código de la orden y el porcentaje completado. Debajo se presenta el hogar asignado con la etiqueta "Verificado", su dirección y la opción "Cambiar". El formulario incluye el alias del dispositivo, como identificador único con un texto de ayuda, y la dirección MAC, con la opción "Escanear QR", mensajes de validación de formato y de verificación de duplicados. Una nota recuerda que los campos con asterisco son obligatorios. Al pie se ubican los botones "Registrar dispositivo" y "Cancelar".

**Incidencia - Paso 1: Diagnóstico**

<div align="center">
  <img src="https://imgur.com/Y8VMi0Q.png" alt="Esquema del paso de diagnóstico técnico de una incidencia con verificaciones en sitio" height="600">
</div>

**Descripción:** Esquema del primer paso del flujo de atención de una incidencia, con la etiqueta "En proceso" y un indicador de tres pasos (Diagnóstico, Evidencias y Resultado). Una tarjeta resume el dispositivo con su estado de conexión, tipo, dirección MAC, ubicación, dirección y hora de inicio, junto con el problema reportado y la foto adjunta por el cuidador. El formulario incluye el diagnóstico técnico, obligatorio y con contador de caracteres, y la acción correctiva realizada, opcional y con atajos de texto. Se muestra un aviso de avance guardado automáticamente y una lista de verificaciones rápidas en sitio. Al pie se ubica el botón "Continuar a evidencias".

**Incidencia - Paso 2: Evidencias**

<div align="center">
  <img src="https://imgur.com/6xDGmBz.png" alt="Esquema del paso de evidencias fotográficas con imágenes cargadas y opción de agregar más" height="600">
</div>

**Descripción:** Esquema del segundo paso del flujo de atención, con el paso 1 marcado como completado. Indica que se deben adjuntar fotografías del dispositivo reparado, pruebas de enlace o estado físico final, y ofrece los botones "Cámara" y "Galería". La sección "Evidencias cargadas" muestra un contador con el máximo de fotos permitido y una tarjeta por cada imagen, con su vista previa, nombre de archivo, tamaño, descripción, indicador de validez y opción para eliminarla. Un recuadro punteado permite agregar otra foto mientras no se alcance el límite. Se incluye una nota sobre el guardado automático y el almacenamiento seguro de las imágenes. Al pie se ubican el botón de retroceso y "Continuar a resultado".

**Incidencia - Paso 3: Resultado**

<div align="center">
  <img src="https://imgur.com/llUhkiX.png" alt="Esquema del paso de determinación de resultado con opciones resuelta y no resuelta" height="600">
</div>

**Descripción:** Esquema del tercer y último paso del flujo de atención, con los pasos anteriores completados y el progreso general al 100 %. Una tarjeta muestra el dispositivo atendido y la hora de su último ping. El campo obligatorio "Resultado de la atención" ofrece dos opciones excluyentes: "Resuelta", marcada como recomendada, y "No resuelta", cada una con su descripción. Debajo se incluye un campo opcional de observaciones finales, con contador de caracteres y la nota de que serán visibles para el equipo de supervisión, y una tarjeta con el cuidador responsable presente en el sitio. Al pie se muestra el aviso de guardado automático y el botón "Revisar y finalizar".

**Orden completada**

<div align="center">
  <img src="https://imgur.com/4ph3YC9.png" alt="Esquema de la pantalla de confirmación de orden completada con resumen de la atención" height="600">
</div>

**Descripción:** Esquema de la pantalla de confirmación que se muestra al cerrar una orden. Presenta un ícono de verificación centrado, el título "Orden completada" y un mensaje que indica que la información se registró correctamente. Un resumen muestra el código de la orden, el tipo de orden, el resultado final y la fecha y hora de finalización. Una nota informa que la orden se sincronizó y estará disponible en el historial. Las acciones disponibles son "Volver a órdenes" y "Ver resumen".

**Perfil del técnico**

<div align="center">
  <img src="https://imgur.com/FnW45w6.png" alt="Esquema de la pantalla de perfil del técnico con información personal y cierre de sesión" height="600">
</div>

**Descripción:** Esquema de la pantalla de perfil del técnico. Muestra la foto con el botón de cámara, el nombre completo y el rol, junto con el bloque de información personal (nombres, apellidos, documento de identidad, teléfono móvil y correo electrónico) y el botón "Editar". Al pie se ubica la opción "Cerrar sesión". La barra inferior marca la sección Perfil como activa.

### 6.4.2. Applications Wire-flow Diagrams

Un wireflow o flujo de pantallas es un diagrama que permite representar de manera visual la navegación entre las diferentes interfaces de una aplicación para alcanzar un objetivo específico del usuario. En el caso de Alivia, estos diagramas permiten visualizar la secuencia de pantallas y las posibles rutas de interacción que siguen los usuarios en las aplicaciones web y móvil, considerando las necesidades de los diferentes roles que participan en el servicio. De esta manera, los wireflows permiten comprender cómo se conectan las funcionalidades de Alivia y cómo los usuarios pueden completar tareas como iniciar sesión, gestionar actividades, consultar dispositivos, atender órdenes o realizar el seguimiento de los servicios.

#### Aplicación Web de Negocio

**Task Flow 1: Iniciar sesión**

<div align="center">
  <img src="https://imgur.com/gSm6uVd.png" alt="Task Flow 1: Iniciar sesión en la aplicación web de negocio"/>
</div>

**Pasos del Task Flow 1:**
1. El usuario abre la pantalla de inicio de sesión.
2. El usuario ingresa su correo y contraseña.
3. El usuario llega al inicio de su rol.

**User Goal 1:** Como usuario del negocio (administrador, técnico o gestor de suscripciones), quiero iniciar sesión con mi correo y contraseña, para acceder a las funciones de mi rol.

<div align="center">
  <img src="https://imgur.com/QibWOOs.png" alt="Wire-flow 1: Iniciar sesión en la aplicación web de negocio"/>
</div>

El usuario del negocio abre la pantalla de inicio de sesión, ingresa su correo y contraseña y accede al inicio correspondiente a su rol. Si los datos no son válidos, la pantalla de inicio de sesión muestra los errores y el usuario corrige la información para volver a intentarlo.

**Task Flow 2: Recuperar contraseña**

<div align="center">
  <img src="https://imgur.com/eZs2Gq5.png" alt="Task Flow 2: Recuperar contraseña en la aplicación web de negocio"/>
</div>

**Pasos del Task Flow 2:**
1. El usuario elige recuperar su contraseña desde el inicio de sesión.
2. El usuario ingresa su correo para solicitar el código.
3. El usuario define y confirma su nueva contraseña.
4. El usuario ve la confirmación de contraseña actualizada.
5. El usuario vuelve al inicio de sesión.

**User Goal 2:** Como usuario del negocio (administrador, técnico o gestor de suscripciones), quiero recuperar mi contraseña cuando la olvido, para volver a entrar a mi cuenta.

<div align="center">
  <img src="https://imgur.com/7vHKUvd.png" alt="Wire-flow 2: Recuperar contraseña en la aplicación web de negocio"/>
</div>

Desde el inicio de sesión, el usuario solicita el código con su correo, crea y confirma una nueva contraseña, ve la confirmación y regresa al inicio de sesión. Si el correo no es válido o la nueva clave no cumple los requisitos, la pantalla correspondiente muestra el error y el usuario corrige el dato para reintentar.

**Task Flow 3: Registrar un empleado**

<div align="center">
  <img src="https://imgur.com/EAcWVfX.png" alt="Task Flow 3: Registrar un empleado"/>
</div>

**Pasos del Task Flow 3:**
1. El administrador abre la gestión de empleados.
2. El administrador elige registrar un empleado.
3. El administrador completa la información personal.
4. El administrador completa la información laboral.
5. El administrador define el acceso a la plataforma.
6. El administrador revisa los datos y confirma.
7. El administrador regresa a la gestión de empleados.

**User Goal 3:** Como administrador, quiero registrar un empleado con sus datos personales, laborales y de acceso, para que pueda operar en la plataforma.

<div align="center">
  <img src="https://imgur.com/HOtZdsh.png" alt="Wire-flow 3: Registrar un empleado"/>
</div>

El administrador parte del listado de empleados y recorre las cuatro pantallas del registro: información personal, información laboral, acceso a la plataforma y confirmación. Al confirmar, regresa al listado. Si avanza con datos incompletos en el primer o el segundo paso, se muestra ese paso con los errores señalados y el administrador corrige el dato para continuar.

**Task Flow 4: Registrar un contrato y su horario laboral**

<div align="center">
  <img src="https://imgur.com/WT4nBMm.png" alt="Task Flow 4: Registrar un contrato y su horario laboral"/>
</div>

**Pasos del Task Flow 4:**
1. El administrador abre la lista de contratos.
2. El administrador elige registrar un contrato.
3. El administrador completa los datos y guarda.
4. El administrador revisa el detalle del contrato.
5. El administrador va a los horarios laborales.
6. El administrador elige registrar un horario.
7. El administrador completa los datos y guarda.
8. El administrador revisa el detalle del horario.

**User Goal 4:** Como administrador, quiero registrar el contrato y el horario laboral de un empleado, para definir cuándo y bajo qué condiciones trabaja.

<div align="center">
  <img src="https://imgur.com/gmVfBRZ.png" alt="Wire-flow 4: Registrar un contrato y su horario laboral"/>
</div>

Desde el listado de contratos, el administrador registra un contrato y revisa su detalle; luego pasa a los horarios laborales, registra uno y consulta su detalle. Si guarda el contrato o el horario con datos incompletos, el formulario aparece con errores y el administrador corrige el dato. También puede editar un horario ya registrado desde su detalle y guardar los cambios.

**Task Flow 5: Atender una orden técnica**

<div align="center">
  <img src="https://imgur.com/cdRgof8.png" alt="Task Flow 5: Atender una orden técnica"/>
</div>

**Pasos del Task Flow 5:**
1. El administrador abre las órdenes técnicas.
2. El administrador selecciona una orden pendiente.
3. El administrador revisa el detalle de la orden.
4. El administrador elige asignar un técnico.
5. El administrador escoge al técnico y confirma.
6. El administrador regresa a la lista de órdenes.

**User Goal 5:** Como administrador, quiero asignar un técnico a una orden pendiente, para que el servicio se atienda a tiempo.

<div align="center">
  <img src="https://imgur.com/jcGXBG7.png" alt="Wire-flow 5: Atender una orden técnica"/>
</div>

El administrador selecciona una orden desde el listado de órdenes técnicas, abre su detalle y elige asignar un técnico. En la ventana de asignación escoge al empleado, confirma y regresa al listado con la orden actualizada. Si no hay técnicos disponibles en ese horario, la ventana muestra el aviso y el administrador elige otro técnico u otro horario.

**Task Flow 6: Configurar el perfil del negocio**

<div align="center">
  <img src="https://imgur.com/jQZz4L6.png" alt="Task Flow 6: Configurar el perfil del negocio"/>
</div>

**Pasos del Task Flow 6:**
1. El administrador abre el perfil del negocio.
2. El administrador completa la identidad del negocio.
3. El administrador completa la información de contacto.
4. El administrador completa la información para clientes.
5. El administrador completa la ubicación corporativa.

**User Goal 6:** Como administrador, quiero configurar la información del negocio, para que clientes y equipo vean datos correctos.

<div align="center">
  <img src="https://imgur.com/35xk3iy.png" alt="Wire-flow 6: Configurar el perfil del negocio"/>
</div>

El administrador abre el perfil del negocio y navega por sus pestañas: identidad, información de contacto, información para clientes y ubicación corporativa, completando los datos de cada una. Si guarda un dato no válido (correo, teléfono o RUC), aparece un error junto al campo y el administrador lo corrige.

**Task Flow 7: Atender una orden desde la web**

<div align="center">
  <img src="https://imgur.com/VjBlJ7I.png" alt="Task Flow 7: Atender una orden desde la web"/>
</div>

**Pasos del Task Flow 7:**
1. El técnico abre su inicio.
2. El técnico entra a Mis órdenes.
3. El técnico selecciona una orden y revisa su detalle.
4. El técnico abre el calendario desde el menú.

**User Goal 7:** Como técnico, quiero consultar mis órdenes asignadas y su detalle, para llegar preparado a cada visita.

<div align="center">
  <img src="https://imgur.com/x8iyt3H.png" alt="Wire-flow 7: Atender una orden desde la web"/>
</div>

Desde su inicio, el técnico abre el listado de sus órdenes, selecciona una para ver su detalle y luego consulta el calendario semanal. Si no tiene órdenes asignadas, el listado muestra el estado de lista vacía.

**Task Flow 8: Consultar inventario y registrar un dispositivo**

<div align="center">
  <img src="https://imgur.com/OH8H54B.png" alt="Task Flow 8: Consultar inventario y registrar un dispositivo"/>
</div>

**Pasos del Task Flow 8:**
1. El técnico abre el inventario de dispositivos por categorías.
2. El técnico entra a la categoría de micrófonos.
3. El técnico elige registrar un dispositivo.
4. El técnico completa los datos y guarda.
5. El técnico ve el inventario actualizado.

**User Goal 8:** Como técnico, quiero consultar el inventario y registrar un dispositivo, para dejar el servicio instalado y documentado.

<div align="center">
  <img src="https://imgur.com/fKm15pz.png" alt="Wire-flow 8: Consultar inventario y registrar un dispositivo"/>
</div>

El técnico recorre el inventario por categorías, abre el listado de micrófonos y registra un dispositivo desde la ventana de registro. Al guardar, vuelve al inventario con el nuevo dispositivo incluido. Si el código está repetido o los datos están incompletos, la ventana muestra los errores y el técnico los corrige. También se contemplan el inventario que no carga, la categoría sin registros y el filtro sin coincidencias.

#### Aplicación Web de Cuidadores

**Task Flow 1: Contratar el plan Base**

<div align="center">
  <img src="https://imgur.com/5QKF2RL.png" alt="Task Flow 1: Contratar el plan Base"/>
</div>

**Pasos del Task Flow 1:**
1. El familiar elige el plan Base.
2. El familiar crea su cuenta.
3. El familiar registra su hogar.
4. El familiar revisa la configuración del plan.
5. El familiar elige el día y la hora de la evaluación.
6. El familiar confirma la visita.
7. El familiar realiza el pago.

**User Goal 1:** Como cuidador o familiar, quiero contratar el plan Base para mi hogar, para recibir asistencia domiciliaria.

**User Persona:** Mariano Diaz (familiar o cuidador de persona con discapacidad).

<div align="center">
  <img src="https://imgur.com/dt6SN2j.png" alt="Wire-flow 1: Contratar el plan Base"/>
</div>

El familiar elige el plan Base y avanza por la contratación guiada: crea su cuenta, registra el hogar, revisa la configuración, programa la evaluación, confirma la visita y paga. Si envía datos no válidos al crear la cuenta, si la dirección no tiene cobertura técnica o si la tarjeta es rechazada, se muestra la pantalla de error correspondiente y corrige los datos, cambia la dirección o usa otro medio de pago. También se contemplan un error al cargar la configuración y un horario no disponible.

**Task Flow 2: Contratar el plan Personalizado**

<div align="center">
  <img src="https://imgur.com/CAppBjP.png" alt="Task Flow 2: Contratar el plan Personalizado"/>
</div>

**Pasos del Task Flow 2:**
1. El familiar elige el plan Personalizado.
2. El familiar selecciona las habitaciones.
3. El familiar selecciona los dispositivos.
4. El familiar revisa el resumen de la configuración.
5. El familiar elige el día y la hora de la evaluación.
6. El familiar confirma la evaluación.

**User Goal 2:** Como cuidador o familiar, quiero armar un plan personalizado por habitaciones y dispositivos, para adaptar el servicio a mi hogar.

**User Persona:** Mariano Diaz (familiar o cuidador de persona con discapacidad).

<div align="center">
  <img src="https://imgur.com/noqOTCk.png" alt="Wire-flow 2: Contratar el plan Personalizado"/>
</div>

El familiar elige el plan Personalizado, selecciona las habitaciones y los dispositivos que necesita, revisa el resumen, programa la evaluación y confirma la visita. Si continúa sin elegir ninguna habitación o ningún dispositivo, o si elige un horario ocupado, aparece un aviso en la pantalla y corrige su elección.

**Task Flow 3: Seguir el servicio contratado**

<div align="center">
  <img src="https://imgur.com/11Ox050.png" alt="Task Flow 3: Seguir el servicio contratado"/>
</div>

**Pasos del Task Flow 3:**
1. El familiar consulta la confirmación del servicio.
2. El familiar consulta la etapa de evaluación.
3. El familiar consulta la etapa de instalación.
4. El familiar consulta la etapa de activación.
5. El familiar ve el servicio activo.

**User Goal 3:** Como cuidador o familiar, quiero seguir el avance de mi servicio, para saber cuándo quedará activo en mi hogar.

**User Persona:** Mariano Diaz (familiar o cuidador de persona con discapacidad).

<div align="center">
  <img src="https://imgur.com/KGTsdmj.png" alt="Wire-flow 3: Seguir el servicio contratado"/>
</div>

El familiar consulta el seguimiento de su contratación etapa por etapa (confirmación, evaluación, instalación y activación) hasta ver el servicio activo en su hogar. Si la visita debe reprogramarse, la instalación no puede completarse o el estado no carga, el seguimiento muestra un aviso y el familiar elige otro horario, coordina una nueva visita o reintenta.

**Task Flow 4: Gestionar actividades**

<div align="center">
  <img src="https://imgur.com/gxmgQvS.png" alt="Task Flow 4: Gestionar actividades en la web"/>
</div>

**Pasos del Task Flow 4:**
1. El cuidador abre el inicio.
2. El cuidador abre la lista de actividades.
3. El cuidador elige crear una nueva actividad.
4. El cuidador completa los datos y guarda.
5. El cuidador revisa el detalle de la actividad.
6. El cuidador consulta el calendario.

**User Goal 4:** Como cuidador o familiar, quiero programar y revisar las actividades diarias, para organizar el cuidado en el hogar.

**User Persona:** Mariano Diaz (familiar o cuidador de persona con discapacidad).

<div align="center">
  <img src="https://imgur.com/7mVy4q6.png" alt="Wire-flow 4: Gestionar actividades en la web"/>
</div>

Desde el inicio, el cuidador abre la lista de actividades, crea una nueva desde el panel lateral, la guarda, revisa su detalle y consulta la vista semanal. Si programa una actividad en un horario ocupado, el formulario muestra el conflicto y el cuidador cambia la hora. También se contemplan la lista y el calendario sin actividades.

**Task Flow 5: Invitar a la red de cuidado**

<div align="center">
  <img src="https://imgur.com/zmRnP5r.png" alt="Task Flow 5: Invitar a la red de cuidado"/>
</div>

**Pasos del Task Flow 5:**
1. El cuidador abre la red de cuidado.
2. El cuidador elige invitar a un cuidador.
3. El cuidador envía la invitación.
4. El cuidador revisa el detalle de la red.
5. El invitado abre su enlace y acepta la invitación.

**User Goal 5:** Como cuidador o familiar, quiero invitar a otros cuidadores a la red de cuidado, para compartir el cuidado de la persona asistida.

**User Persona:** Mariano Diaz (familiar o cuidador de persona con discapacidad).

<div align="center">
  <img src="https://imgur.com/2J6S4H6.png" alt="Wire-flow 5: Invitar a la red de cuidado"/>
</div>

El cuidador abre la red de cuidado, invita a otra persona desde el panel lateral y envía la invitación; luego revisa el detalle de la red. El invitado abre su enlace y acepta la invitación. Si envía datos no válidos, el formulario muestra errores y los corrige. También se contemplan la red sin cuidadores y la invitación vencida, en la que se solicita una nueva.

**Task Flow 6: Consultar y revisar dispositivos**

<div align="center">
  <img src="https://imgur.com/xoyhG3Z.png" alt="Task Flow 6: Consultar y revisar dispositivos en la web"/>
</div>

**Pasos del Task Flow 6:**
1. El cuidador abre el inicio.
2. El cuidador abre la lista de dispositivos.
3. El cuidador selecciona un dispositivo y revisa su detalle.

**User Goal 6:** Como cuidador o familiar, quiero consultar los dispositivos instalados, para saber que todo funciona en mi hogar.

**User Persona:** Mariano Diaz (familiar o cuidador de persona con discapacidad).

<div align="center">
  <img src="https://imgur.com/gLfzSO9.png" alt="Wire-flow 6: Consultar y revisar dispositivos en la web"/>
</div>

Desde el inicio, el cuidador abre los dispositivos del hogar, agrupados por habitación, y selecciona uno para ver su detalle. Si el hub está desconectado, la lista aparece con ese aviso y el cuidador restablece la conexión. También se contempla un error al cargar el detalle del dispositivo.

**Task Flow 7: Reportar una incidencia**

<div align="center">
  <img src="https://imgur.com/piUQt21.png" alt="Task Flow 7: Reportar una incidencia"/>
</div>

**Pasos del Task Flow 7:**
1. El cuidador abre la lista de incidencias.
2. El cuidador elige reportar una incidencia.
3. El cuidador completa los datos y envía.
4. El cuidador revisa la incidencia registrada.
5. El cuidador sigue la incidencia mientras está en atención.
6. El cuidador ve la incidencia resuelta.

**User Goal 7:** Como cuidador o familiar, quiero reportar una incidencia y seguir su atención, para recibir ayuda cuando algo falla.

**User Persona:** Mariano Diaz (familiar o cuidador de persona con discapacidad).

<div align="center">
  <img src="https://imgur.com/t7SJklA.png" alt="Wire-flow 7: Reportar una incidencia"/>
</div>

El cuidador abre el listado de incidencias, reporta una desde el panel lateral y recibe la confirmación de registro. Después sigue su estado desde el detalle, primero en atención y luego resuelta. Si aún no tiene reportes, la lista aparece vacía. También se contemplan el envío del formulario sin completar y un error al enviar la incidencia.

**Task Flow 8: Consultar actividades (cuidador de apoyo)**

<div align="center">
  <img src="https://imgur.com/S7geNmc.png" alt="Task Flow 8: Consultar actividades como cuidador de apoyo"/>
</div>

**Pasos del Task Flow 8:**
1. El cuidador de apoyo abre el inicio.
2. El cuidador de apoyo abre la lista de actividades.
3. El cuidador de apoyo selecciona una actividad y revisa su detalle.
4. El cuidador de apoyo consulta el calendario.

**User Goal 8:** Como cuidador de apoyo, quiero consultar las actividades asignadas, para cumplir mis tareas de cuidado.

**User Persona:** Cuidador de apoyo (basado en Mariano Diaz, familiar o cuidador de persona con discapacidad).

<div align="center">
  <img src="https://imgur.com/gRC84Zi.png" alt="Wire-flow 8: Consultar actividades como cuidador de apoyo"/>
</div>

Desde su inicio, el cuidador de apoyo abre la lista de actividades asignadas, selecciona una para ver su detalle en modo solo lectura y luego consulta la vista de horarios. Si no tiene actividades asignadas o el calendario está vacío, se muestra un mensaje de lista vacía. También se contempla un error al cargar el detalle.

#### Aplicación Móvil

**Task Flow 1: Iniciar sesión**

<div align="center">
  <img src="https://imgur.com/6wZpC9b.png" alt="Task Flow 1: Iniciar sesión en la aplicación móvil"/>
</div>

**Pasos del Task Flow 1:**
1. El usuario abre la app y ve la pantalla de carga.
2. El usuario pasa al inicio de sesión.
3. El usuario ingresa su correo y contraseña.
4. El usuario llega al inicio de su rol.

**User Goal 1:** Como usuario de la app móvil (cuidador o técnico), quiero iniciar sesión con mi correo y contraseña, para acceder a las funciones de mi rol.

<div align="center">
  <img src="https://imgur.com/vWoFcTC.png" alt="Wire-flow 1: Iniciar sesión en la aplicación móvil"/>
</div>

Al abrir la app aparece la pantalla de carga y luego el inicio de sesión, donde el usuario ingresa sus datos y llega al inicio de su rol. Si los datos no son válidos, la pantalla muestra el mensaje de error y el usuario los corrige para volver a intentar.

**Task Flow 2: Recuperar contraseña**

<div align="center">
  <img src="https://imgur.com/Yt12r3u.png" alt="Task Flow 2: Recuperar contraseña en la aplicación móvil"/>
</div>

**Pasos del Task Flow 2:**
1. El usuario elige recuperar su contraseña desde el inicio de sesión.
2. El usuario ingresa el código de verificación.
3. El usuario crea su nueva contraseña.
4. El usuario ve la confirmación de contraseña actualizada.

**User Goal 2:** Como usuario de la app móvil (cuidador o técnico), quiero recuperar mi contraseña cuando la olvido, para volver a entrar a mi cuenta.

<div align="center">
  <img src="https://imgur.com/5Vw8BhK.png" alt="Wire-flow 2: Recuperar contraseña en la aplicación móvil"/>
</div>

Desde el inicio de sesión, el usuario verifica el código enviado a su correo, crea y confirma la nueva contraseña y ve la pantalla de contraseña actualizada. Si el código es incorrecto, la pantalla de verificación muestra el error y el usuario lo corrige.

**Task Flow 3: Gestionar actividades (cuidador o familiar)**

<div align="center">
  <img src="https://imgur.com/G0sM2yJ.png" alt="Task Flow 3: Gestionar actividades en la aplicación móvil"/>
</div>

**Pasos del Task Flow 3:**
1. El usuario abre el inicio.
2. El usuario abre la lista de actividades.
3. El usuario elige registrar una actividad.
4. El usuario define la actividad.
5. El usuario completa la programación y guarda.
6. El usuario revisa el detalle de la actividad.
7. El usuario abre el calendario.

**User Goal 3:** Como cuidador o familiar, quiero programar y revisar las actividades diarias, para organizar el cuidado en el hogar.

**User Persona:** Mariano Diaz (familiar o cuidador de persona con discapacidad).

<div align="center">
  <img src="https://imgur.com/ZnytIDs.png" alt="Wire-flow 3: Gestionar actividades en la aplicación móvil"/>
</div>

Desde el inicio, el usuario abre la lista de actividades y registra una nueva en dos pasos: actividad y programación. Luego consulta el detalle de la actividad y revisa el calendario. Si no hay actividades, se muestra el estado vacío; si el usuario descarta el registro, confirma la salida y vuelve a la lista sin guardar cambios.

**Task Flow 4: Revisar dispositivos (cuidador o familiar)**

<div align="center">
  <img src="https://imgur.com/UdzzibC.png" alt="Task Flow 4: Revisar dispositivos en la aplicación móvil"/>
</div>

**Pasos del Task Flow 4:**
1. El usuario abre el inicio.
2. El usuario abre la lista de dispositivos.
3. El usuario selecciona un dispositivo y revisa su estado.

**User Goal 4:** Como cuidador o familiar, quiero consultar el estado de los dispositivos del hogar, para saber que funcionan correctamente.

**User Persona:** Mariano Diaz (familiar o cuidador de persona con discapacidad).

<div align="center">
  <img src="https://imgur.com/rDICO6u.png" alt="Wire-flow 4: Revisar dispositivos en la aplicación móvil"/>
</div>

Desde el inicio, el usuario abre la lista de dispositivos del hogar, agrupados por habitación, y entra al detalle de uno para ver su estado, conectividad y batería. Si ocurre un error al cargar los dispositivos, se muestra el aviso y el usuario puede reintentar.

**Task Flow 5: Atender una orden técnica**

<div align="center">
  <img src="https://imgur.com/DfWmfGH.png" alt="Task Flow 5: Atender una orden técnica en la aplicación móvil"/>
</div>

**Pasos del Task Flow 5:**
1. El técnico abre el inicio.
2. El técnico abre la lista o el calendario de órdenes.
3. El técnico revisa el detalle de una orden.
4. El técnico confirma el inicio de la atención.
5. El técnico ve la orden completada.

**User Goal 5:** Como técnico, quiero consultar y atender mis órdenes técnicas, para cumplir las visitas asignadas.

<div align="center">
  <img src="https://imgur.com/FG7lFn8.png" alt="Wire-flow 5: Atender una orden técnica en la aplicación móvil"/>
</div>

Desde el inicio, el técnico consulta sus órdenes en lista o calendario, abre el detalle de una, confirma el inicio de la atención y, al finalizar, ve la pantalla de orden completada. Si no hay órdenes se muestra el estado vacío; si el detalle falla, aparece el error; y si confirma sin disponibilidad, el sistema lo informa.

**Task Flow 6: Instalación**

<div align="center">
  <img src="https://imgur.com/CAiXG8R.png" alt="Task Flow 6: Instalación en la aplicación móvil"/>
</div>

**Pasos del Task Flow 6:**
1. El técnico abre el detalle de la orden.
2. El técnico registra el diagnóstico.
3. El técnico adjunta las evidencias.
4. El técnico define el resultado de la atención.
5. El técnico consulta las instalaciones.
6. El técnico registra el dispositivo en el hogar.

**User Goal 6:** Como técnico, quiero registrar el diagnóstico y las evidencias de la incidencia y registrar el dispositivo en el hogar, para dejar el servicio instalado y documentado.

<div align="center">
  <img src="https://imgur.com/mqMNXFu.png" alt="Wire-flow 6: Instalación en la aplicación móvil"/>
</div>

Desde el detalle de la orden, el técnico registra el diagnóstico, adjunta las evidencias fotográficas y define el resultado; luego consulta las instalaciones y registra el dispositivo del hogar, dejando el servicio instalado y documentado. Si descarta los cambios en las evidencias, vuelve sin guardar; y si registra el dispositivo con datos incorrectos, el sistema pide corregirlos.

### 6.4.3. Applications Mockups

#### Aplicación web de negocio - Pantallas compartidas por todos los roles

Inicio de sesión

Pantalla de acceso a la aplicación web de negocio, común a todos los roles (administrador, técnico, gestor de suscripciones y cuidador). Muestra el logo de Alivia, los campos de correo y contraseña, el botón para iniciar sesión y el enlace para recuperar la contraseña.

![Inicio de sesión](https://i.imgur.com/eAgkRD3.png)

Inicio de sesión - Con errores de validación

Estado del inicio de sesión cuando los datos ingresados no son válidos. Resalta los campos con error y muestra mensajes que indican qué debe corregir la persona antes de volver a intentarlo.

![Inicio de sesión - Con errores de validación](https://i.imgur.com/QX0CGrx.png)

Recuperar contraseña - 1. Solicitar código

Primer paso para recuperar el acceso. La persona ingresa su correo y solicita un código de verificación, que se le envía para continuar el proceso.

![Recuperar contraseña - 1. Solicitar código](https://i.imgur.com/asEOx4E.png)

Recuperar contraseña - 2. Crear nueva contraseña

Segundo paso: tras verificar el código, la persona define una nueva contraseña y la confirma. La pantalla lista los requisitos de seguridad (mínimo de caracteres, mayúscula, minúscula, número y carácter especial).

![Recuperar contraseña - 2. Crear nueva contraseña](https://i.imgur.com/DvhOsig.png)

Recuperar contraseña - 2. Crear nueva contraseña - Con errores de validación

Estado del segundo paso cuando la contraseña no cumple los requisitos o las dos contraseñas no coinciden. Marca qué requisitos faltan y muestra los mensajes de error bajo cada campo.

![Recuperar contraseña - 2. Crear nueva contraseña - Con errores de validación](https://i.imgur.com/ZexDQAz.png)

Recuperar contraseña - 3. Contraseña actualizada

Pantalla de éxito que confirma que la contraseña se cambió correctamente y permite volver a iniciar sesión.

![Recuperar contraseña - 3. Contraseña actualizada](https://i.imgur.com/AEWcaKo.png)

#### Aplicación web de negocio - Vista del administrador

Navegación

Barra lateral de navegación de la aplicación web del administrador general. Agrupa los módulos en Principal (Inicio), Capital humano (Empleados, Contratos y Horarios laborales), Operaciones técnicas (Órdenes técnicas), Clientes y servicio (Hogares y Dispositivos), Gestión comercial (Planes, Contrataciones y Suscripciones), Analítica (Métricas) y Configuración (Perfil del negocio). Resalta la opción activa y, al pie, muestra al usuario con sesión iniciada y su rol.

<div align="center">
  <img src="https://i.imgur.com/afSKp5r.png" alt="Navegación"/>
</div>

Inicio

Pantalla de inicio del administrador con saludo, sede, fecha y hora. Presenta cuatro tarjetas resumen (órdenes técnicas activas, contrataciones en proceso, suscripciones en atención y configuraciones de personal pendientes), la lista de órdenes técnicas del día con la opción de asignar técnico a las que aún no lo tienen, y tres resúmenes por área: gestión comercial, capital humano y dispositivos IoT.

![Inicio](https://i.imgur.com/ckuNhqp.png)

Gestión de empleados

Listado de empleados técnicos y gestores de la sede. Muestra indicadores (total de empleados, técnicos activos, gestores activos y configuraciones pendientes), un buscador, filtros por rol y una tabla con el empleado y su código, rol, estado del contrato, horario y disponibilidad. Incluye las acciones Exportar listado y Registrar empleado, además de paginación.

![Gestión de empleados](https://i.imgur.com/Ojxjpgq.png)

Registrar empleado - Paso 1: Información personal

Primer paso (de 4) del asistente para registrar un empleado: información personal. El formulario pide tipo y número de documento (con validación automática de DNI), nombres, apellidos, teléfono celular y correo personal. Ofrece las acciones Guardar borrador, Cancelar y Continuar.

![Registrar empleado - Paso 1: Información personal](https://i.imgur.com/GfT2qgL.png)

Registrar empleado - Paso 2: Información laboral

Segundo paso (de 4) del asistente de registro: información laboral. Permite elegir el rol operativo (Técnico de campo o Gestor de suscripciones), el contrato asignado, el horario laboral con su fecha de inicio y observaciones operativas opcionales.

![Registrar empleado - Paso 2: Información laboral](https://i.imgur.com/TMVjTJw.png)

Registrar empleado - Paso 3: Acceso a la plataforma

Tercer paso (de 4): acceso a la plataforma. Se define el correo institucional del colaborador (con confirmación y validación de disponibilidad) y se informa del envío automático de la invitación para crear su contraseña, con un enlace de vigencia limitada. Incluye una vista previa del correo de bienvenida que recibirá el empleado.

![Registrar empleado - Paso 3: Acceso a la plataforma](https://i.imgur.com/G4V1qP4.png)

Registrar empleado - Paso 4: Revisión y confirmación

Cuarto y último paso: resumen y confirmación del registro. Muestra los datos de información personal, información laboral y acceso a la plataforma, cada bloque con la opción de editar su paso. Al final, el administrador marca la casilla de confirmación y presiona Registrar empleado.

![Registrar empleado - Paso 4: Revisión y confirmación](https://i.imgur.com/Hn4Skde.png)

Contratos

Listado de contratos laborales de Alivia. Muestra indicadores (total, vigentes, próximos a vencer y vencidos), un aviso de contratos por vencer, buscador y filtros por estado y modalidad, y una tabla con contrato y código, posición, modalidad y horas, vigencia, estado y acciones. Permite exportar el listado y registrar un contrato.

![Contratos](https://i.imgur.com/OYB7okD.png)

Registrar contrato

Formulario para registrar un contrato laboral. Incluye código autogenerado, cargo o rol contractual, modalidad contractual, horas contratadas por semana, fecha de inicio y de término (con la duración calculada), estado inicial del contrato y observaciones o cláusulas particulares. Ofrece las acciones Guardar borrador, Cancelar y Registrar contrato.

![Registrar contrato](https://i.imgur.com/iZR3JXJ.png)

Detalle del contrato

Vista de detalle de un contrato. Muestra las condiciones del contrato (código, cargo, sede, modalidad, horas semanales, fechas, estado legal, creación y última modificación) y la lista de empleados asignados a ese contrato. Permite volver al listado y editar el contrato.

<div align="center">
  <img src="https://i.imgur.com/1KUuX3w.png" alt="Detalle del contrato"/>
</div>

Horarios laborales

Listado de horarios laborales de los empleados. Presenta indicadores (horarios configurados, personal con turno y promedio semanal de horas), buscador, filtros por rol y vigencia, y una tabla con empleado, horario y código, vigencia, días laborales, horas y acciones. Resalta con una alerta los horarios que exceden la jornada permitida y permite registrar un nuevo horario.

![Horarios laborales](https://i.imgur.com/uaEDjSy.png)

Registrar horario laboral

Formulario para registrar un horario laboral. Se define el nombre del horario, su vigencia y estado de aplicación, y luego la jornada semanal día por día con uno o varios bloques de trabajo. Un resumen en tiempo real compara las horas contratadas con las configuradas. Ofrece las acciones Guardar borrador, Cancelar y Registrar horario laboral.

![Registrar horario laboral](https://i.imgur.com/D2jxYuH.png)

Editar horario laboral

Formulario para modificar un horario laboral existente. Permite ajustar el nombre, la vigencia y la jornada semanal por bloques, y muestra el resumen de jornada y la última modificación. Además de guardar los cambios, ofrece Guardar como borrador, Descartar cambios, Dar de baja horario y Guardar como nueva versión.

![Editar horario laboral](https://i.imgur.com/stJE3Ft.png)

Detalle del horario

Panel lateral con el detalle de un horario. Muestra al empleado, el total semanal de horas, la vigencia operativa, los bloques horarios configurados por día, el contrato asociado con su estado de cumplimiento, las órdenes técnicas del día y la disponibilidad calculada. Incluye los botones Cerrar y Editar horario.

<div align="center">
  <img src="https://i.imgur.com/wyQ0Xix.png" alt="Detalle del horario"/>
</div>

Órdenes técnicas

Listado de solicitudes de evaluación, instalación e incidencias. Muestra contadores por estado, pestañas (Todas, Pendientes, Asignadas, En proceso y Completadas), filtros por tipo y una tabla agrupada por día con orden, tipo, hogar, horario, técnico, estado y acción (Asignar o Ver). Incluye buscador y paginación.

![Órdenes técnicas](https://i.imgur.com/wA9qXFF.png)

Detalle de la orden técnica

Detalle de una orden técnica pendiente de asignación. Presenta el resumen de la solicitud (tipo, fecha, bloque horario, prioridad y descripción), los datos de contacto del cuidador principal y de la persona asistida, el hogar con su dirección, referencia y mapa, y la sección del técnico sin asignar con el botón Asignar técnico.

<div align="center">
  <img src="https://i.imgur.com/peJYaMD.png" alt="Detalle de la orden técnica"/>
</div>

Asignar empleado

Ventana modal para asignar un técnico a una orden. Muestra la fecha y el bloque horario solicitados (no modificables), la lista de técnicos elegibles con su disponibilidad, horario y órdenes previas, y un resumen de la asignación. Se confirma con Confirmar asignación o se descarta con Cancelar.

<div align="center">
  <img src="https://i.imgur.com/EGlL1mm.png" alt="Asignar empleado"/>
</div>

Hogares

Listado de hogares registrados. Presenta indicadores (total de hogares, suscripción activa, pendientes de evaluación, pendientes de instalación e incidencias activas), buscador, filtros por distrito y estado, y una tabla con alias del hogar, responsable principal, dirección, distrito, teléfono, plan y estado de la suscripción. Permite exportar el listado.

![Hogares](https://i.imgur.com/QamKnLv.png)

Detalle del hogar - Información

Detalle de un hogar, pestaña 1 (Información). Muestra los datos generales del hogar (identificación y contacto, servicio y cobertura, canales de comunicación preferidos) junto con la ubicación y cobertura: mapa, dirección normalizada, distrito, código postal, coordenadas y referencia. Las pestañas permiten pasar a Suscripción, Dispositivos y Órdenes técnicas.

<div align="center">
  <img src="https://i.imgur.com/jYSbY0Q.png" alt="Detalle del hogar - Información"/>
</div>

Detalle del hogar - Suscripción

Detalle de un hogar, pestaña 2 (Suscripción). Muestra el plan contratado, la tarifa mensual, el estado de pago, las fechas de inicio y de próxima facturación, el método de pago registrado, el titular de facturación y los datos de facturación, junto con la ubicación y cobertura del hogar.

<div align="center">
  <img src="https://i.imgur.com/hVpP0Ii.png" alt="Detalle del hogar - Suscripción"/>
</div>

Detalle del hogar - Dispositivos

Detalle de un hogar, pestaña 3 (Dispositivos). Lista los dispositivos instalados (gateway, sensores y botón de auxilio) con su estado, y muestra la batería promedio y la señal de red. A la derecha mantiene la ubicación y cobertura del hogar.

<div align="center">
  <img src="https://i.imgur.com/P39K9fu.png" alt="Detalle del hogar - Dispositivos"/>
</div>

Detalle del hogar - Órdenes técnicas

Detalle de un hogar, pestaña 4 (Órdenes técnicas). Lista las órdenes del hogar con su estado (en curso o completada) y el acceso Ver orden, y resume las órdenes atendidas y la orden activa. A la derecha mantiene la ubicación y cobertura del hogar.

<div align="center">
  <img src="https://i.imgur.com/W1NvlpW.png" alt="Detalle del hogar - Órdenes técnicas"/>
</div>

Dispositivos

Inventario general de dispositivos. Muestra los totales (total, disponibles, reservados y asignados), buscador y filtros, y los dispositivos agrupados por categoría: Nodos Edge, Micrófonos, Luces, Puertas y Ventanas. Cada categoría muestra tarjetas de dispositivos (alias, código, MAC, estado y ubicación) con acceso a Ver detalle. Incluye el botón Registrar dispositivo.

![Dispositivos](https://i.imgur.com/4bZ8F7R.png)

Micrófonos

Vista del inventario de dispositivos filtrada por la categoría Micrófonos, que se gestiona como un tipo de dispositivo más. Presenta los totales por estado (disponibles, reservados, asignados y en mantenimiento), buscador por código, serie, MAC o modelo, filtros y tarjetas por dispositivo con su ubicación y acceso a Ver detalle. Incluye paginación y los botones Volver al inventario y Registrar dispositivo.

![Micrófonos](https://i.imgur.com/lP02aHj.png)

Registrar dispositivo

Ventana modal para registrar un dispositivo (por ejemplo, un micrófono, un sensor de puerta o de ventana) en el inventario. Solicita el alias del dispositivo y su dirección MAC (en hexadecimal). Se confirma con Registrar dispositivo o se descarta con Cancelar.

![Registrar dispositivo](https://i.imgur.com/VUKPuaW.png)

Planes

Catálogo de planes de Alivia. Muestra el plan Esencial (precio mensual, equipamiento y cobertura incluidos) y el plan Personalizado (a cotizar, con parámetros configurables como habitaciones y puertas y evaluación técnica previa). Cada plan indica sus suscripciones activas y tiene el botón Ver detalle del plan.

![Planes](https://i.imgur.com/6eWc73u.png)

Contrataciones

Tablero de seguimiento de contrataciones, desde la selección del plan hasta la activación del servicio. Muestra indicadores (nuevas solicitudes, requieren decisión y pendientes de instalación), buscador, filtros y columnas por etapa: Solicitud y pago, Evaluación técnica, Decisión del cliente e Instalación. Cada tarjeta indica el código, el plan, el hogar y su estado.

![Contrataciones](https://i.imgur.com/ibqE6Xr.png)

Suscripciones

Listado de suscripciones activas de los hogares. Muestra indicadores (activas, requieren atención y próximas a renovar), pestañas por estado, buscador y una tabla con suscripción, cliente y hogar, plan, estado, próxima acción y acciones (Ver detalle). Incluye paginación.

![Suscripciones](https://i.imgur.com/MGxpQHK.png)

Métricas

Resumen general de métricas con selector de periodo (hoy, semana, 30 días y trimestre) y opción de exportar. Presenta tarjetas clave (hogares activos, órdenes pendientes, suscripciones activas e incidencias críticas) y los paneles Operación técnica, Estado del servicio, Evolución comercial y Capacidad técnica por técnico.

![Métricas](https://i.imgur.com/HUOJhdg.png)

Perfil del negocio - Identidad del negocio

Perfil del negocio, pestaña Identidad del negocio. Muestra el logotipo institucional, el nombre comercial, la razón social, el RUC, la actividad económica y la descripción institucional, con su estado de validación. Incluye el botón Editar perfil y la nota de permisos del administrador general.

![Perfil del negocio - Identidad del negocio](https://i.imgur.com/CyQXGY8.png)

Perfil del negocio - Información de contacto

Perfil del negocio, pestaña Información de contacto. Muestra el correo de contacto institucional, el teléfono principal corporativo, el teléfono móvil o de guardia y el sitio web corporativo, con el indicador de canales activos. Incluye el botón Editar perfil.

![Perfil del negocio - Información de contacto](https://i.imgur.com/On8hmY8.png)

Perfil del negocio - Información para clientes

Perfil del negocio, pestaña Información para clientes. Muestra el horario de atención al público, el correo de la mesa de ayuda y soporte técnico, la central de emergencias con WhatsApp oficial y el lema usado en las comunicaciones. Incluye el botón Editar perfil.

![Perfil del negocio - Información para clientes](https://i.imgur.com/097pBOz.png)

Perfil del negocio - Ubicación corporativa

Perfil del negocio, pestaña Ubicación corporativa. Muestra la dirección principal de la sede, el distrito, la provincia, el departamento y la referencia de ubicación, junto con un mapa y las coordenadas. Incluye el botón Editar perfil.

![Perfil del negocio - Ubicación corporativa](https://i.imgur.com/jmXHiWi.png)

Mi perfil

Perfil personal del administrador. Muestra su foto, rol, estado de cuenta, información personal (nombres, apellidos, documento y teléfono), información de contacto, preferencias del sistema (canales de notificación, zona horaria y formato de fecha) y el acceso a Cambiar contraseña. Se guardan los cambios con Guardar cambios o se descartan.

![Mi perfil](https://i.imgur.com/328ZapD.png)

Bandeja de notificaciones

Panel desplegable de notificaciones, mostrado sobre la pantalla Perfil del negocio. Permite alternar entre Todas y No leídas, marcar como leídas y revisar las notificaciones del día con su prioridad y módulo de origen (por ejemplo, una incidencia crítica, la aceptación de una adaptación por un cliente o un pago que requiere revisión).

![Bandeja de notificaciones](https://i.imgur.com/fKuFwfb.png)

#### Aplicación web de negocio - Vista del técnico

Inicio

Pantalla de inicio del técnico de campo con saludo, turno y zona de trabajo. Presenta tarjetas resumen (órdenes para hoy, en atención, urgentes y pendientes de actualizar), la próxima visita asignada con hogar, dirección, equipos en revisión, contacto operativo y ventana de servicio, y accesos a Ver orden técnica y Abrir en Google Maps. Incluye la agenda de hoy, las órdenes que requieren atención y un resumen de la semana.

![Inicio](https://i.imgur.com/81rWnIV.png)

Mis órdenes

Listado de las órdenes técnicas asignadas al técnico, en tarjetas. Muestra contadores (programadas hoy, en proceso y atrasadas), buscador y filtros por tipo, estado y fecha. Cada orden indica su código, tipo, horario, estado, hogar y distrito, con el botón Ver orden. Permite alternar entre la vista de tarjetas y la de calendario.

![Mis órdenes](https://i.imgur.com/igXMges.png)

Detalle de la orden técnica

Panel lateral con el detalle de una orden técnica, mostrado sobre el listado Mis órdenes. Presenta el código y tipo de la orden (por ejemplo, instalación) y su estado (en ruta hacia el domicilio), el hogar con su dirección, distancia y horario, la ruta estimada en mapa con acceso a Waze, y el contacto autorizado con botón de llamada. Incluye el botón Confirmar llegada y el enlace Ver expediente completo.

<div align="center">
  <img src="https://i.imgur.com/UWdH61n.png" alt="Detalle de la orden técnica"/>
</div>

Calendario

Calendario semanal del técnico (con vistas Día, Semana y Mes y filtros). Muestra las órdenes por día y hora, diferenciadas por tipo (evaluación, instalación, incidencia y mantenimiento), con hogar, horario y prioridad, además de la hora actual, el almuerzo y los espacios disponibles. Al seleccionar una orden se abre un detalle emergente con la opción Ver orden.

![Calendario](https://i.imgur.com/koGo7as.png)

Métricas

Panel Mi jornada del técnico. Muestra el estado de servicio con GPS y el turno, indicadores del día (órdenes de hoy, pendientes, completadas y tiempo promedio) y la orden en ruta con su destino, equipamiento asignado y mapa, con los botones Ver ruta en mapa, Ver orden de trabajo y Llamar cuidador. Incluye la agenda semanal, el estado semanal de las órdenes y el rendimiento por día.

![Métricas](https://i.imgur.com/Sgu6mJE.png)

Hogares

Listado de hogares registrados. Presenta indicadores (total de hogares, suscripción activa, pendientes de evaluación, pendientes de instalación e incidencias activas), buscador, filtros por distrito y estado, y una tabla con alias del hogar, responsable principal, dirección, distrito, teléfono, plan y estado de la suscripción. Permite exportar el listado.

![Hogares](https://i.imgur.com/4z2jlBW.png)

Detalle del hogar - Información

Detalle de un hogar, pestaña 1 (Información). Muestra los datos generales del hogar (identificación y contacto, servicio y cobertura, canales de comunicación preferidos) junto con la ubicación y cobertura: mapa, dirección normalizada, distrito, código postal, coordenadas y referencia. Las pestañas permiten pasar a Suscripción, Dispositivos y Órdenes técnicas.

<div align="center">
  <img src="https://i.imgur.com/ehedQhO.png" alt="Detalle del hogar - Información"/>
</div>

Detalle del hogar - Suscripción

Detalle de un hogar, pestaña 2 (Suscripción). Muestra el plan contratado, la tarifa mensual, el estado de pago, las fechas de inicio y de próxima facturación, el método de pago registrado, el titular de facturación y los datos de facturación, junto con la ubicación y cobertura del hogar.

<div align="center">
  <img src="https://i.imgur.com/oY7OCM2.png" alt="Detalle del hogar - Suscripción"/>
</div>

Detalle del hogar - Dispositivos

Detalle de un hogar, pestaña 3 (Dispositivos). Lista los dispositivos instalados (gateway, sensores y botón de auxilio) con su estado, y muestra la batería promedio y la señal de red. A la derecha mantiene la ubicación y cobertura del hogar.

<div align="center">
  <img src="https://i.imgur.com/ENWDRaO.png" alt="Detalle del hogar - Dispositivos"/>
</div>

Detalle del hogar - Órdenes técnicas

Detalle de un hogar, pestaña 4 (Órdenes técnicas). Lista las órdenes del hogar con su estado (en curso o completada) y el acceso Ver orden, y resume las órdenes atendidas y la orden activa. A la derecha mantiene la ubicación y cobertura del hogar.

<div align="center">
  <img src="https://i.imgur.com/bAeRzvH.png" alt="Detalle del hogar - Órdenes técnicas"/>
</div>

Dispositivos

Inventario general de dispositivos. Muestra los totales (total, disponibles, reservados y asignados), buscador y filtros, y los dispositivos agrupados por categoría: Nodos Edge, Micrófonos, Luces, Puertas y Ventanas. Cada categoría muestra tarjetas de dispositivos (alias, código, MAC, estado y ubicación) con acceso a Ver detalle. Incluye el botón Registrar dispositivo.

![Dispositivos](https://i.imgur.com/YC7qXVH.png)

Micrófonos

Vista del inventario de dispositivos filtrada por la categoría Micrófonos, que se gestiona como un tipo de dispositivo más. Presenta los totales por estado (disponibles, reservados, asignados y en mantenimiento), buscador por código, serie, MAC o modelo, filtros y tarjetas por dispositivo con su ubicación y acceso a Ver detalle. Incluye paginación y los botones Volver al inventario y Registrar dispositivo.

![Micrófonos](https://i.imgur.com/5feRtAv.png)

Registrar dispositivo

Ventana modal para registrar un dispositivo (por ejemplo, un micrófono, un sensor de puerta o de ventana) en el inventario. Solicita el alias del dispositivo y su dirección MAC (en hexadecimal). Se confirma con Registrar dispositivo o se descarta con Cancelar.

![Registrar dispositivo](https://i.imgur.com/Z6Gg1aD.png)

Mi perfil

Perfil personal del administrador. Muestra su foto, rol, estado de cuenta, información personal (nombres, apellidos, documento y teléfono), información de contacto, preferencias del sistema (canales de notificación, zona horaria y formato de fecha) y el acceso a Cambiar contraseña. Se guardan los cambios con Guardar cambios o se descartan.

![Mi perfil](https://i.imgur.com/pWLBals.png)

#### Aplicación web de negocio - Vista del gestor de suscripciones

Inicio

Pantalla de inicio del portal comercial del gestor de suscripciones, con saludo y turno. Presenta tarjetas resumen (nuevas contrataciones, requieren decisión, suscripciones con atención y próximas renovaciones), el listado de contrataciones prioritarias con pestañas por etapa y el botón Ver contratación, las próximas renovaciones y los planes comerciales activos.

![Inicio](https://i.imgur.com/G91hsrz.png)

Planes

Catálogo de planes de Alivia. Muestra el plan Esencial (precio mensual, equipamiento y cobertura incluidos) y el plan Personalizado (a cotizar, con parámetros configurables como habitaciones y puertas y evaluación técnica previa). Cada plan indica sus suscripciones activas y tiene el botón Ver detalle del plan.

![Planes](https://i.imgur.com/6eWc73u.png)

Contrataciones

Tablero de seguimiento de contrataciones, desde la selección del plan hasta la activación del servicio. Muestra indicadores (nuevas solicitudes, requieren decisión y pendientes de instalación), buscador, filtros y columnas por etapa: Solicitud y pago, Evaluación técnica, Decisión del cliente e Instalación. Cada tarjeta indica el código, el plan, el hogar y su estado.

![Contrataciones](https://i.imgur.com/ibqE6Xr.png)

Suscripciones

Listado de suscripciones activas de los hogares. Muestra indicadores (activas, requieren atención y próximas a renovar), pestañas por estado, buscador y una tabla con suscripción, cliente y hogar, plan, estado, próxima acción y acciones (Ver detalle). Incluye paginación.

![Suscripciones](https://i.imgur.com/MGxpQHK.png)

Analíticas

Panel Resumen comercial con selector de periodo (7 días, 30 días, trimestre y personalizado) y opción de exportar. Presenta tarjetas clave (contrataciones en proceso, suscripciones activas, renovaciones próximas y pagos pendientes), el embudo de contratación por etapas, la distribución por plan con el ratio de adopción adaptada y la evolución de suscripciones (nuevas, renovadas y bajas).

![Analíticas](https://i.imgur.com/G11kdDi.png)

Perfil

Perfil personal del administrador. Muestra su foto, rol, estado de cuenta, información personal (nombres, apellidos, documento y teléfono), información de contacto, preferencias del sistema (canales de notificación, zona horaria y formato de fecha) y el acceso a Cambiar contraseña. Se guardan los cambios con Guardar cambios o se descartan.

![Perfil](https://i.imgur.com/328ZapD.png)

#### Aplicación web del cuidador - Pantallas compartidas por el cuidador principal y los cuidadores invitados

Inicio de sesión

Pantalla de acceso al Portal del cuidador, común al cuidador principal y a los cuidadores invitados. A la izquierda muestra el mensaje de bienvenida, los campos de correo electrónico y contraseña (con opción de mostrarla), la casilla Recordarme en este dispositivo, el enlace ¿Olvidaste tu contraseña?, el botón Iniciar sesión y el acceso Conoce nuestros planes para quienes aún no tienen cuenta. A la derecha presenta una ilustración del hogar con dispositivos conectados y el lema "Más autonomía. Más tranquilidad."

![Inicio de sesión](https://i.imgur.com/SZL6bDl.png)

Recuperar contraseña - Solicitar código

Primer paso para recuperar el acceso. La persona ingresa su correo y solicita un código de verificación, que se le envía para continuar el proceso.

![Recuperar contraseña - Solicitar código](https://i.imgur.com/nFGtGWO.png)

Recuperar contraseña - Crear nueva contraseña

Segundo paso: tras verificar el código, la persona define una nueva contraseña y la confirma. La pantalla lista los requisitos de seguridad (mínimo de caracteres, mayúscula, minúscula, número y carácter especial).

![Recuperar contraseña - Crear nueva contraseña](https://i.imgur.com/Tvyalm2.png)

Recuperar contraseña - Contraseña actualizada

Pantalla de éxito que confirma que la contraseña se cambió correctamente y permite volver a iniciar sesión.

![Recuperar contraseña - Contraseña actualizada](https://i.imgur.com/s0rqONn.png)

#### Aplicación web del cuidador - Vista del cuidador principal

Aceptar invitación a red de cuidado

Pantalla de invitación a una red de cuidado, en una tarjeta centrada. Muestra los datos del hogar (estado "Invitación activa", persona asistida, quién invita y las responsabilidades asignadas como chips: consultar, gestionar actividades y recibir notificaciones). Incluye el correo bloqueado, el campo de contraseña con enlace "¿Olvidaste tu contraseña?", el botón "Iniciar sesión y aceptar" y la opción "Rechazar invitación".

![Aceptar invitación a red de cuidado](https://i.imgur.com/W9XfyC0.png)

Calendario semanal de actividades

Vista semanal de actividades de cuidado en forma de calendario, con pestañas Hoy / Semana / Lista, botón "Nueva actividad", navegación por semana y filtros por responsable, tipo y estado. Las actividades aparecen como bloques de colores por hora y día, según su estado (completada, pendiente, programada, vencida), con una línea de hora actual y un aviso de superposición de horario. El menú lateral tiene la sección Actividades resaltada.

![Calendario semanal de actividades](https://i.imgur.com/S8JMJRv.png)

Lista de actividades del día

Listado de las actividades del día agrupadas por franjas (Mañana, Tarde, Noche), cada una con su contador de actividades. Cada fila muestra hora, ícono, nombre, responsable y detalle, junto con su estado (completada, pendiente, vencida, cancelada) y una acción como Ver detalle, Completar o Reprogramar. Arriba hay pestañas Hoy / Semana / Lista, navegación de fecha, botón Filtros, "Ver estado vacío" y "Nueva actividad".

![Lista de actividades del día](https://i.imgur.com/gz1SUNY.png)

Cambiar foto de perfil

Ventana modal "Actualizar fotografía" sobre la pantalla Mi perfil desenfocada. Muestra la vista previa circular de la imagen, una zona para arrastrar o seleccionar archivo (JPG o PNG, máximo 5MB) y las acciones Reemplazar y Eliminar foto actual. Termina con los botones Cancelar y Guardar foto.

![Cambiar foto de perfil](https://i.imgur.com/X6EQdnH.png)

Configuración base del plan (flujo de contratación)

Paso 4 de 5 del flujo de contratación, con barra de progreso y resumen del plan elegido (Plan Base Asistivo, S/ 99 al mes) con opción "Cambiar plan". Muestra un resumen de importe, espacio, equipos y modalidad, y el detalle del dormitorio incluido con tres dispositivos de una unidad cada uno (iluminación, puerta motorizada, micrófono). Incluye el enlace "Ver qué incluye cada dispositivo" y los botones Atrás, Cambiar a Personalizado y Continuar.

![Configuración base del plan (flujo de contratación)](https://i.imgur.com/ldaZ2zo.png)

Confirmar visita de evaluación (flujo de contratación)

Último paso del flujo de contratación, "Confirma tu visita", con barra de progreso. Muestra en tarjetas la cita reservada (fecha y horario, con opción de cambiar), la dirección del hogar con mapa, el tipo de servicio (evaluación técnica presencial, duración, importe preautorizado) y quién recibe la visita con su teléfono. Incluye un campo opcional de indicaciones para llegar, una casilla de confirmación de que habrá un adulto presente y los botones Cambiar horario y Confirmar evaluación.

![Confirmar visita de evaluación (flujo de contratación)](https://i.imgur.com/3CtGxMf.png)

Crear cuenta

Formulario de registro, paso 2 del flujo de contratación, con barra de progreso y resumen del plan elegido. Tiene campos de nombres, apellidos, documento de identidad (tipo y número), teléfono celular, correo y contraseña con requisitos, además de la casilla de términos y política de privacidad y el botón "Crear cuenta". Arriba hay un selector para simular estados (Inicial, Completado, Duplicado, Cargando, Éxito OTP).

![Crear cuenta](https://i.imgur.com/UaV4xvz.png)

Detalle de actividad

Panel lateral con el detalle de una actividad de cuidado sobre la lista del día desenfocada. Muestra la categoría y el estado (Alimentación, Pendiente), el título, la persona asistida, el horario, la frecuencia, el cuidador asignado, el recordatorio y las indicaciones. Al pie tiene las acciones Marcar como completada, Reprogramar, Editar y Cancelar actividad.

<div align="center">
  <img src="https://i.imgur.com/0QWTp2d.png" alt="Detalle de actividad"/>
</div>

Detalle de incidencia en atención

Detalle de una incidencia en estado "En atención", con enlaces para volver y ver el dispositivo. Muestra una línea de tiempo de 5 etapas con la cuarta activa, un resumen de la atención técnica en curso con técnico e inicio, y dos paneles: el detalle del reporte (dispositivo, tipo de problema, fecha, descripción y foto ampliable) y la atención en curso (técnico, hora de inicio, estado actual, nota de la intervención y ubicación del servicio).

<div align="center">
  <img src="https://i.imgur.com/G4o8fZP.png" alt="Detalle de incidencia en atención"/>
</div>

Detalle de incidencia resuelta

Detalle de una incidencia en estado "Resuelta", con botón "Descargar reporte" y línea de tiempo completa con las cinco etapas marcadas. Muestra un resumen del caso (fecha y hora de cierre, técnico, estado del dispositivo operativo) y dos paneles: la incidencia reportada (dispositivo, tipo, descripción y ubicación) y el detalle de resolución (trabajo realizado, fecha de finalización, técnico y fotos del reporte y de la resolución). Al pie hay Ver dispositivo, Reportar nuevamente y Volver a incidencias.

<div align="center">
  <img src="https://i.imgur.com/1fayMj8.png" alt="Detalle de incidencia resuelta"/>
</div>

Detalle de incidencia con visita programada

Detalle de una incidencia en estado "Visita programada", con botón "Descargar ficha" y línea de tiempo donde la tercera etapa está activa y las dos últimas pendientes. Destaca un bloque con la visita técnica (fecha, horario y técnico asignado) y el botón "Reprogramar visita". Debajo muestra el detalle del reporte (tipo de problema, fecha y descripción) y las evidencias (foto adjunta y ubicación), con un aviso del protocolo de seguridad y el enlace "Ver normas de visita".

<div align="center">
  <img src="https://i.imgur.com/uxmWVfY.png" alt="Detalle de incidencia con visita programada"/>
</div>

Detalle de red de cuidado

Panel lateral con el detalle de un cuidador de la red: avatar con iniciales, nombre, parentesco (hija de la persona asistida) y etiqueta de cuidador principal. Muestra datos de contacto (correo, teléfono móvil, estado de vinculación Activo y fecha de registro) y la lista de responsabilidades asignadas con check. Incluye los botones Cerrar y Editar responsabilidades.

<div align="center">
  <img src="https://i.imgur.com/GmT4R8r.png" alt="Detalle de red de cuidado"/>
</div>

Detalle de dispositivo

Panel de detalle de un sensor de ventana de un dormitorio, con alerta amarilla de batería baja (18%) que recomienda recambio sin costo adicional. Muestra estado y especificaciones (estado actual, nivel de batería, conectividad, última sincronización), la instalación (habitación y técnico asignado) y un historial reciente de eventos con indicadores de color. Ofrece los botones Solicitar recambio de batería, Reportar problema y Cerrar.

<div align="center">
  <img src="https://i.imgur.com/FJPtSX4.png" alt="Detalle de dispositivo"/>
</div>

Configuración de dispositivos por habitación

Paso de configuración del flujo de contratación de un plan personalizado, con barra de progreso por pasos y resumen del plan con costo estimado mensual. Presenta pestañas de habitaciones y tarjetas por tipo de dispositivo (iluminación, puerta, ventana, micrófono y altavoz asistencial) con estado Activo/Desactivado y contadores con botones más y menos. Incluye un aviso de validación técnica, la cuota mensual con total de dispositivos y los botones Volver a habitaciones y Revisar configuración.

![Configuración de dispositivos por habitación](https://i.imgur.com/fbPilcG.png)

Listado de dispositivos

Listado de los dispositivos del hogar agrupados por habitación, en tarjetas, con menú lateral de navegación y botón Reportar un problema. Muestra contadores por estado (operativos, requieren atención, sin conexión) y, en cada tarjeta, nombre, tipo, alimentación o nivel de batería, estado actual, última actualización y botón Ver detalle. Una tarjeta se resalta en amarillo por batería baja con la acción Ver detalle y recambio.

![Listado de dispositivos](https://i.imgur.com/nt8a053.png)

Editar información del hogar

Panel lateral de edición sobre la pantalla Mi hogar desenfocada al fondo. Contiene un formulario con alias del hogar (con contador de caracteres), teléfono asociado con prefijo +51 y correo asociado, cada uno con texto de ayuda. Muestra una tarjeta de ubicación actual validada, con enlace para actualizarla, y los botones Cancelar y Guardar cambios.

![Editar información del hogar](https://i.imgur.com/9mKSu9Q.png)

Elección de plan

Primer paso de la contratación guiada, con barra de progreso de cinco pasos y selector de facturación mensual o anual. Compara dos tarjetas de plan, Plan Base y Plan Personalizado, con precio, lista de características y botón de elección. Debajo incluye un bloque de garantía de adaptación con imagen, un enlace de ayuda y el pie de página.

![Elección de plan](https://i.imgur.com/F2OH9fN.png)

Fecha y horario de evaluación

Quinto paso de la contratación para programar la visita técnica presencial al hogar, con barra de progreso. Muestra un calendario mensual con días disponibles marcados y un día seleccionado, junto a los bloques horarios de ese día con estados Disponible, Último cupo y No disponible. Incluye la tarjeta de destino de inspección con dirección, modalidad y duración, y los botones Volver a configuración y Revisar evaluación.

![Fecha y horario de evaluación](https://i.imgur.com/erOpnRL.png)

Selección de habitaciones

Paso de configuración del plan personalizado donde se eligen los espacios a adaptar, con barra de progreso y resumen del plan. Lista las habitaciones configuradas, cada una con icono, descripción y botones de editar y quitar, además del botón Agregar otra habitación. Muestra el resumen con cantidad de habitaciones y precio base estimado, indicador de guardado automático y los botones Atrás y Elegir dispositivos.

![Selección de habitaciones](https://i.imgur.com/nBzjCMV.png)

Confirmación de incidencia registrada

Pantalla de confirmación tras reportar una incidencia, con ícono de éxito y mensaje de que el equipo técnico revisará el reporte. Muestra una tarjeta con código de ticket, estado Registrada, dispositivo afectado, tipo de problema, fecha y hora reportadas, ubicación del servicio y un aviso de notificaciones. Incluye los botones Ver seguimiento y Volver a incidencias, y un texto con la línea de asistencia para casos críticos.

![Confirmación de incidencia registrada](https://i.imgur.com/x3DyUcu.png)

Listado de incidencias

Listado de las incidencias del hogar en tarjetas, con pestañas En curso y Resueltas con contadores, buscador y filtros por estado y por dispositivo. Cada tarjeta muestra código, estado, dispositivo y habitación, fecha de reporte y un dato de seguimiento (visita programada con técnico, diagnóstico remoto o sin visita), con enlace Ver detalle. Incluye el botón Reportar incidencia.

![Listado de incidencias](https://i.imgur.com/HoHzrix.png)

Inicio

Pantalla de inicio con saludo, fecha y botones Reportar incidencia y Nueva actividad. Muestra una alerta de dispositivo con batería baja con enlace Ver dispositivo, la tarjeta de la persona asistida con la agenda de hoy (actividades con hora, responsable y estado: completada, pendiente, programada) y el enlace Ver agenda completa. A la derecha, una tarjeta de próximo evento con visita técnica, técnico asignado y botón Ver seguimiento.

![Inicio](https://i.imgur.com/ZFUy4wU.png)

Invitar cuidador

Panel lateral modal sobre la pantalla Red de cuidado (desenfocada al fondo, con contadores de cuidadores activos e invitaciones pendientes). Contiene el formulario con correo electrónico, selector de relación con la persona asistida (Familiar) y casillas de responsabilidades asignadas: consultar y gestionar actividades y recibir notificaciones marcadas, consultar dispositivos y recibir alertas de dispositivos sin marcar. Incluye los botones Cancelar y Enviar invitación.

![Invitar cuidador](https://i.imgur.com/mYGAGmU.png)

Métricas de autonomía

Panel de analítica titulado Resumen de autonomía, con una alerta de que 1 dispositivo requiere atención y un selector de periodo (Hoy, 7 días, 30 días). Muestra un gráfico de barras semanal de acciones autónomas vs. con asistencia, un indicador circular con 78 % autónoma (22 % con asistencia) y un listado de uso por dispositivo con barras de progreso (luces, micrófono asistencial, puerta, ventana) y su consumo en minutos, comandos, aperturas o acciones.

![Métricas de autonomía](https://i.imgur.com/dTjTVpW.png)

Mi hogar

Ficha de consulta del hogar, con el botón Editar información. Muestra la tarjeta Hogar Don Alberto con la etiqueta Ubicación validada, el cuidador principal y la persona asistida, una sección de Datos generales (alias, teléfono y correo asociados) y otra de Ubicación (dirección normalizada, distrito y referencia). Al final incluye un mapa con el marcador del hogar y el enlace Ver en Google Maps.

![Mi hogar](https://i.imgur.com/JxG5cpL.png)

Mi perfil

Pantalla de perfil del cuidador en modo de edición activo, con la foto de perfil y el botón Cambiar foto, y las etiquetas Cuidador principal y Correo verificado. El formulario de Datos personales incluye nombres, apellidos, tipo y número de documento y teléfono de contacto, todos editables, y el correo electrónico verificado en solo lectura con una nota para contactar a soporte. Cierra con los botones Cancelar y Guardar cambios.

![Mi perfil](https://i.imgur.com/WF7vKwC.png)

Notificaciones

Panel desplegable de notificaciones sobre la pantalla de Suscripción (desenfocada al fondo), con el contador de 3 nuevas, las pestañas Todas y Sin leer, y las opciones Marcar todas como leídas y Ver vacío. Lista las alertas de hoy con hora relativa: solicitud de asistencia por pulsador SOS (botón Ver solicitud), batería baja del sensor de ventana (Ver dispositivo) y actividad próxima de medicamento (Ver actividad). Al final aparece la sección Anteriores como leídas.

![Notificaciones](https://i.imgur.com/qLeGqFV.png)

Nueva actividad

Panel lateral modal para programar una tarea o recordatorio de cuidado, sobre la vista de Actividades del día (desenfocada al fondo). El formulario incluye nombre y tipo de actividad, persona asistida, fecha, hora, duración opcional, repetición, cuidador responsable, recordatorio e indicaciones opcionales con contador de caracteres. Incluye los botones Cancelar y Guardar actividad.

![Nueva actividad](https://i.imgur.com/yDiKkc3.png)

Registro de medio de pago

Paso 4 Configuración del proceso de registro, con barra de progreso de cinco pasos y subpasos (Configurar plan, Revisar resumen, Medio de pago). El formulario pide titular, correo de facturación y datos de tarjeta (número, vencimiento, código, país) procesados por Stripe, con casilla de aceptación de términos y botones Autorizar y continuar y Volver al resumen. Un resumen lateral del Plan Personalizado muestra ambientes, equipamiento, cuota mensual estimada y el cobro de hoy de S/ 0.00 como autorización temporal.

![Registro de medio de pago](https://i.imgur.com/oaDZl1m.png)

Persona asistida

Ficha de consulta de la persona a cargo, con foto, nombre, etiqueta Perfil completo, edad, hogar y el botón Editar información. Presenta la Información personal (nombres, apellidos, tipo y número de documento validado, fecha de nacimiento, parentesco) y la Información asociada (hogar relacionado, cuidador principal y teléfono de contacto).

![Persona asistida](https://i.imgur.com/2RLYpZQ.png)

Red de cuidado

Listado de las personas autorizadas para apoyar el cuidado en el hogar, con el botón Invitar cuidador. Muestra la tarjeta del cuidador principal (titular del servicio) con el botón Ver responsabilidades y una sección de cuidadores adicionales (3) con su relación y correo. Cada uno tiene un estado: Activo, Invitación pendiente o Invitación vencida, esta última con el botón Reenviar, además de un menú de opciones por fila.

![Red de cuidado](https://i.imgur.com/5etFp1w.png)

Registro de hogar

Paso 3 Hogar (1 de 2, Ubicación) del proceso de registro, con barra de progreso y un banner del plan elegido con opción Cambiar plan. El formulario pide alias del hogar con sugerencias, teléfono y correo de contacto y dirección con Google Maps (botón Usar mi ubicación), con un mapa de pin arrastrable y la dirección normalizada detectada. Incluye una referencia opcional de llegada y los botones Atrás y Confirmar ubicación.

![Registro de hogar](https://i.imgur.com/pGFBSYo.png)

Registro de persona asistida

Paso 3 Hogar (2 de 2, Persona asistida) del proceso de registro, con barra de progreso y un banner del plan elegido. El formulario recoge nombres, apellidos, fecha de nacimiento, documento y teléfono opcionales y relación con el cuidador principal, además de un perfil de accesibilidad rápida con selección de nivel de movilidad y de comunicación por voz. Incluye un contacto secundario de emergencia opcional, una casilla de confirmación de autorización y los botones Volver a ubicación y Guardar y continuar.

![Registro de persona asistida](https://i.imgur.com/1kFvLHI.png)

Reportar incidencia

Panel lateral de formulario superpuesto sobre la pantalla de gestión de incidencias del hogar, con etiqueta "Soporte de Equipamiento" y botón para cerrar. Incluye selector de dispositivo afectado, selector de tipo de problema, descripción con contador de 0/500, fecha y hora del incidente, y carga opcional de hasta 3 fotos (JPG o PNG hasta 5MB). Muestra una tarjeta con el hogar principal y su dirección, donde se realizará la atención, y los botones Cancelar y Enviar incidencia.

![Reportar incidencia](https://i.imgur.com/J8jTyS4.png)

Resumen de configuración

Último paso del flujo de contratación (paso 4 de 5, Configuración) con barra de progreso y sub-pasos Habitaciones, Dispositivos y Resumen final. Muestra una tarjeta con el plan personalizado, facturación mensual, importe estimado en soles por mes, el hogar y los totales de habitaciones y dispositivos. Detalla la distribución por ambiente en secciones desplegables con botón Editar y de agregar dispositivo, un aviso de cobro transparente, y los botones Modificar dispositivos y Continuar a Evaluación.

![Resumen de configuración](https://i.imgur.com/0KxQFAb.png)

Seguimiento de contratación: Activación

Pantalla de seguimiento de contratación con el código del contrato y una línea de progreso de cuatro pasos (Evaluación, Confirmación e Instalación completadas; Activación en proceso). Muestra la tarjeta "Activando el servicio" con indicador de validación en curso, la sincronización de telemetría y sensores como proceso automático, y un aviso de que se enviará confirmación por correo y SMS. Incluye un enlace para contactar soporte en caso de demora y tres tarjetas informativas inferiores.

![Seguimiento de contratación: Activación](https://i.imgur.com/nyEUlm3.png)

Seguimiento de contratación: Confirmación

Pantalla de seguimiento con el código del contrato y una línea de progreso donde la Evaluación está realizada y la Confirmación requiere revisión. Muestra la tarjeta "Configuración lista para confirmar" con etiquetas de evaluación completada y acción requerida, una imagen del domicilio con ubicación e ID de inspección, el resultado de la evaluación (viable con adaptación técnica) y el plan resultante con la inversión mensual. Incluye el enlace para solicitar ayuda y el botón Revisar y confirmar.

![Seguimiento de contratación: Confirmación](https://i.imgur.com/aKx2I84.png)

Seguimiento de contratación: Evaluación

Pantalla de seguimiento con el código del contrato y una línea de progreso de cuatro pasos donde la Evaluación está en proceso. Muestra la tarjeta "Evaluación técnica presencial" con estado pendiente de visita técnica, fecha programada, ventana de llegada y lugar de inspección. Incluye el enlace Ver requerimientos previos, el botón Reprogramar visita y una línea de contacto telefónico con su horario de atención.

![Seguimiento de contratación: Evaluación](https://i.imgur.com/pLvjbOv.png)

Seguimiento de contratación: Instalación

Pantalla de seguimiento con el código del contrato y una línea de progreso donde Evaluación y Confirmación están completadas e Instalación está programada. Muestra la tarjeta "Instalación programada" con fecha, rango horario y dirección de asistencia, además de la ficha del técnico de campo asignado con credencial activa. Incluye un aviso para que una persona adulta esté presente, los botones Reprogramar visita y Ver detalles de instalación, y un enlace para hablar con asistencia.

![Seguimiento de contratación: Instalación](https://i.imgur.com/mb49Zoa.png)

Seguimiento de contratación: Servicio activo

Pantalla de seguimiento con proceso finalizado, el código del contrato y los cuatro pasos de la línea de progreso completados. Muestra un mensaje de confirmación de que el servicio está activo, con fecha de activación, plan activo y hogar conectado, junto a una imagen del hogar con la nota de sensores y panel central enlazados. Incluye los botones Ir a mi hogar y Ver dispositivos, y una nota sobre la línea de soporte clínico 24/7.

![Seguimiento de contratación: Servicio activo](https://i.imgur.com/QAwhdRT.png)

Suscripción

Pantalla de suscripción del panel del cuidador, con migas de pan, estado Activa y la fecha y monto del próximo cobro. Muestra una tarjeta del plan con su precio mensual, fechas de inicio y renovación, cobertura incluida (habitaciones y dispositivos), los botones Cambiar plan y Ver detalles, y los enlaces Suspender y Cancelar suscripción. A la derecha presenta la facturación y medio de pago con tarjeta y cobro automático, y el último pago con monto, fecha, método y enlace para descargar el comprobante.

![Suscripción](https://i.imgur.com/sZkKZ0J.png)

#### Aplicación web del cuidador - Vista de los cuidadores invitados

Calendario de actividades

Vista semanal de las actividades asignadas al cuidador, con la pestaña Horarios activa (alterna con Lista). Incluye navegación por semana con el botón Hoy, filtro por estado y la persona asistida. Muestra las actividades por día y hora, diferenciadas por estado (completada, pendiente, vencida, programada y cancelada), con una línea que marca la hora actual.

![Calendario de actividades](https://i.imgur.com/5PDXgSU.png)

Lista de actividades

Vista en lista de las actividades asignadas, con filtros por periodo y estado. Las agrupa por Hoy, Mañana y Próximas, indicando la cantidad de actividades de cada grupo. Cada fila muestra la hora, el nombre de la actividad, si es recurrente, la persona asistida y su estado (completada, pendiente, vencida, programada o cancelada).

![Lista de actividades](https://i.imgur.com/GRezp1q.png)

Cambiar foto de perfil

Ventana emergente Actualizar fotografía sobre la pantalla Mi perfil. Muestra la vista previa de la imagen actual, una zona para arrastrar o seleccionar una imagen (JPG o PNG, máximo 5 MB), las opciones Reemplazar y Eliminar foto actual, y los botones Cancelar y Guardar foto.

![Cambiar foto de perfil](https://i.imgur.com/HsN3kS8.png)

Detalle de actividad

Panel lateral de consulta de una actividad. Muestra su nombre, la persona asignada, el estado, el horario programado, la categoría, la frecuencia y las indicaciones registradas. Funciona en modo solo lectura: avisa que la actividad la gestiona el cuidador principal y que cualquier cambio debe coordinarse con él. Incluye el botón Cerrar.

<div align="center">
  <img src="https://i.imgur.com/O9Y5jDL.png" alt="Detalle de actividad"/>
</div>

Inicio

Pantalla de inicio del cuidador invitado, con la etiqueta Invitado, el hogar y la persona asistida que cuida. Muestra un saludo de bienvenida y la tarjeta Próxima actividad (hora, nombre, persona asistida, descripción y estado) con los accesos Ver actividad y Ver mis actividades. El menú lateral incluye Inicio, Persona asistida, Actividades y Mi perfil.

![Inicio](https://i.imgur.com/OJOXv97.png)

Mi perfil

Perfil personal del cuidador, con foto, nombre, rol y estado de correo verificado, y el botón Cambiar foto. En Datos personales se editan nombres, apellidos, tipo y número de documento y teléfono de contacto; el correo electrónico aparece verificado y no editable. Incluye los botones Cancelar y Guardar cambios.

![Mi perfil](https://i.imgur.com/BK6uxhJ.png)

Notificaciones

Panel desplegable de notificaciones sobre la pantalla de suscripción. Permite alternar entre Todas y Sin leer, marcar todas como leídas y revisar las alertas del día: solicitud de asistencia desde el pulsador SOS, batería baja de un sensor y actividad próxima, cada una con su acceso (Ver solicitud, Ver dispositivo, Ver actividad). Al final separa las notificaciones anteriores ya leídas.

![Notificaciones](https://i.imgur.com/jP9wlXk.png)

Persona asistida

Ficha de solo consulta de la persona a cargo, con foto, nombre, estado del perfil, edad y hogar. Presenta la información personal (nombres, apellidos, tipo y número de documento validado, fecha de nacimiento y parentesco) y la información asociada (hogar relacionado, cuidador principal y teléfono de contacto). Incluye el botón Editar información.

![Persona asistida](https://i.imgur.com/XsFJ5UM.png)


#### Aplicación mobile - Pantallas compartidas por todos los roles

Inicio de sesión

Pantalla de acceso a la aplicación móvil, común a todos los roles. Muestra el logo de Alivia, el mensaje de bienvenida, los campos de correo electrónico y contraseña (con opción de mostrarla), el enlace ¿Olvidaste tu contraseña? y el botón Ingresar.

<div align="center">
  <img src="https://i.imgur.com/PjnEQAH.png" alt="Inicio de sesión"/>
</div>

Verificar código

Pantalla de verificación del correo. Informa a qué correo se envió el código (parcialmente oculto) y presenta seis casillas para ingresar el código de 6 dígitos, compatible con el autocompletado por SMS o correo. Muestra un contador para volver a pedir el código, con la opción Reenviar código, y el botón Verificar.

<div align="center">
  <img src="https://i.imgur.com/KghwLmz.png" alt="Verificar código"/>
</div>

Establecer contraseña

Pantalla para definir una clave segura que protege la cuenta. Tiene los campos Nueva contraseña y Confirmar contraseña, un recuadro con los requisitos mínimos (8 caracteres, una mayúscula y un número) y el botón Actualizar contraseña. Un aviso inferior confirma que la contraseña se actualizó correctamente.

<div align="center">
  <img src="https://i.imgur.com/2hwkpA8.png" alt="Establecer contraseña"/>
</div>

Nueva contraseña

Pantalla para crear una nueva contraseña, con los campos Nueva contraseña y Confirmar contraseña. Muestra los requisitos de seguridad (mínimo de caracteres, una mayúscula y un número) con indicadores de cumplimiento y el botón Cambiar contraseña.

<div align="center">
  <img src="https://i.imgur.com/zifds1z.png" alt="Nueva contraseña"/>
</div>

Contraseña actualizada

Pantalla de éxito que confirma que la contraseña se restableció correctamente. Indica que la persona ya puede ingresar con sus nuevas credenciales y ofrece el botón Volver a iniciar sesión.

<div align="center">
  <img src="https://i.imgur.com/ONPx6AU.png" alt="Contraseña actualizada"/>
</div>

Centro de notificaciones

Listado de notificaciones de la aplicación, con filtros Todas, No leídas y Críticas y la acción Marcar todas. Agrupa las alertas por Hoy y Ayer; cada una muestra un ícono según su tipo, el título, un resumen, la hora y un indicador de estado (por ejemplo, falla de un actuador de puerta, nueva evaluación técnica asignada y mantenimiento de firmware).

<div align="center">
  <img src="https://i.imgur.com/nqhrERr.png" alt="Centro de notificaciones"/>
</div>

Notificaciones push - Android

Notificaciones push nativas en Android (FCM). Muestra la alerta de prioridad alta de solicitud de auxilio con las acciones Atenderé y Ver alerta, la actividad próxima, la nueva actividad asignada, las alertas agrupadas por hogar (dispositivo sin conexión y batería baja) y el horario actualizado. Al final explica el modo de bloqueo seguro, que oculta datos de la persona o del hogar con el teléfono bloqueado.

<div align="center">
  <img src="https://i.imgur.com/xpc5Yhs.png" alt="Notificaciones push - Android"/>
</div>

Notificaciones push - iOS

Notificaciones push nativas en iOS (Apple HIG, FCM). Presenta el banner superior para una actividad próxima, la alerta crítica expandida con las acciones Atenderé y Ver alerta, la pila de notificaciones agrupada por hogar, y las alertas de dispositivo sin conexión, batería baja y horario actualizado. Al final indica la protección de datos sensibles con el teléfono bloqueado.

<div align="center">
  <img src="https://i.imgur.com/3TsMhV1.png" alt="Notificaciones push - iOS"/>
</div>

#### Aplicación mobile - Vista del cuidador

Calendario de actividades

Vista de calendario de las actividades de la paciente asignada, con selector de paciente, alternancia Lista/Calendario y botón Nueva. Muestra el mes con la semana actual, indicadores de días con actividades y el día seleccionado. Debajo lista las actividades del día en tarjetas con hora, responsable y estado (completada, pendiente), con un botón Marcar en la próxima, y barra de navegación inferior.

<div align="center">
  <img src="https://i.imgur.com/p9NBPMi.png" alt="Calendario de actividades"/>
</div>

Lista de actividades

Listado de actividades del paciente asignado, agrupadas en Hoy, Mañana, Próximas y Anteriores, con contador de tareas por grupo. Cada tarjeta muestra hora, ícono, nombre de la actividad, responsable y estado (Completada, Pendiente u Omitida con motivo). Incluye indicador de turno activo, alternancia Lista/Calendario, botón de filtros y botón para agregar.

<div align="center">
  <img src="https://i.imgur.com/muutgF0.png" alt="Lista de actividades"/>
</div>

Detalle de actividad

Detalle de una actividad programada (medicación matutina) con etiquetas de tipo y estado pendiente, y un aviso de modo cuidador con permisos activos. Muestra secciones de persona asistida, fecha y horario, tipo de actividad, responsable del turno, frecuencia y ciclo, e instrucción clínica breve. Al pie tiene el botón Registrar resultado, con una nota de que solo está disponible para tareas pendientes durante el turno.

<div align="center">
  <img src="https://i.imgur.com/oZFTb58.png" alt="Detalle de actividad"/>
</div>

Detalle del dispositivo - Operativo

Detalle de un dispositivo de ventana en estado Operativo, con ícono, nombre, ubicación y etiqueta de estado. Muestra una tarjeta de estado correcto con la hora de última actualización y una sección de información esencial con estado, conectividad, batería y última actualización. Incluye un acceso a Ver historial del dispositivo.

<div align="center">
  <img src="https://i.imgur.com/4MOUXnK.png" alt="Detalle del dispositivo - Operativo"/>
</div>

Detalle del dispositivo - Desconectado

Detalle de un dispositivo de ventana en estado Desconectado, con una alerta de conexión interrumpida y la última señal recibida. Muestra estado actual, conectividad, batería baja y última actualización, además del último estado conocido (ventana abierta) con una advertencia de que pudo haber cambiado. Incluye el problema detectado y un acceso a Ver historial del dispositivo.

<div align="center">
  <img src="https://i.imgur.com/eu3Rt7n.png" alt="Detalle del dispositivo - Desconectado"/>
</div>

Dispositivos

Listado de dispositivos del hogar con resumen de estado: vinculados, con incidencia y batería baja, e indicador de sincronización en tiempo real. Los equipos se agrupan por dormitorio bajo Prioridad de supervisión, en tarjetas con nombre, estado (falla, batería, en línea, desconectado, abierta o cerrada), descripción, protocolo y nivel de batería o alimentación. Termina con un aviso de monitoreo continuo y la barra de navegación inferior.

<div align="center">
  <img src="https://i.imgur.com/AowlHo0.png" alt="Dispositivos"/>
</div>

Historial

Historial de eventos de la paciente seleccionada, agrupado en Hoy, Ayer y Anteriores. Cada registro muestra ícono, título, detalle y hora o fecha, como comandos de voz, actividades completadas, aperturas de puertas y solicitudes de auxilio atendidas. Incluye filtros Todos y Filtrar, y un indicador de carga de eventos anteriores.

<div align="center">
  <img src="https://i.imgur.com/fE0F39H.png" alt="Historial"/>
</div>

Inicio

Pantalla de inicio con saludo y resumen del estado del hogar para hoy. Muestra tarjetas de la próxima actividad programada con responsable y enlace Ver actividades, la red de cuidado con sus vinculados y enlace Ver red de cuidado, y la paciente con edad, estado Sin alertas y enlace Ver perfil. Incluye ícono de notificaciones y barra de navegación inferior.

<div align="center">
  <img src="https://i.imgur.com/x6IylHC.png" alt="Inicio"/>
</div>

Perfil

Perfil del usuario de la app con foto (botón de cámara para cambiarla), nombre completo y rol de técnico, y campana de notificaciones con indicador. Muestra la sección Información personal con botón Editar y los datos nombres, apellidos, DNI, teléfono móvil y correo electrónico. Incluye una tarjeta de acceso a Mi suscripción, el botón Cerrar sesión y la barra inferior con Inicio, Agenda, Órdenes, Historial y Perfil (activa).

<div align="center">
  <img src="https://i.imgur.com/znu76rO.png" alt="Perfil"/>
</div>

Mi suscripción - Plan base

Detalle de la suscripción en Plan Base, con etiqueta Activa, tipo de configuración fija y hogar asociado. Muestra un recuadro de próxima facturación (monto mensual y fecha), la información del servicio (estado, fecha de inicio, periodicidad, próxima facturación, monto de renovación y hogar) y la configuración incluida con 5 dispositivos: habitaciones, cubo de voz, luces, puertas y ventanas. Cierra con una nota de que la configuración la define el plan y el botón Gestionar en la web para cambios de cobertura o facturación.

<div align="center">
  <img src="https://i.imgur.com/FLTpV8Y.png" alt="Mi suscripción - Plan base"/>
</div>

Mi suscripción - Plan personalizado

Detalle de la suscripción en Plan Personalizado, con etiqueta Activa, hogar asociado y fecha de próxima renovación. Muestra la información del servicio (estado activo y sincronizado, fecha de inicio, próxima renovación, periodicidad anual y hogar) y la configuración actual con las habitaciones configuradas (nombradas), el total de 8 dispositivos y el desglose en cubo de voz, luces, puertas y ventanas. Termina con el botón Gestionar en la web y un texto que indica que las modificaciones se hacen en la plataforma web.

<div align="center">
  <img src="https://i.imgur.com/lGto2KQ.png" alt="Mi suscripción - Plan personalizado"/>
</div>

Perfil de persona asistida

Perfil de la persona asistida con foto, nombre completo, insignia de Perfil completo, edad y hogar. Muestra la sección Información personal (nombres, apellidos, documento con sello Validado, fecha de nacimiento y parentesco) y la sección Información asociada (hogar relacionado, cuidador principal, relación y teléfono de contacto). Incluye flecha de regreso y campana de notificaciones en la cabecera.

<div align="center">
  <img src="https://i.imgur.com/8aiqYTc.png" alt="Perfil de persona asistida"/>
</div>

Red de cuidado

Listado de los cuidadores vinculados a la persona asistida, con su foto, hogar y un contador de 3 cuidadores vinculados. Se divide en Cuidador principal (con etiqueta Principal y su relación) y Otros cuidadores, cada uno con su rol, estado Vinculada y flecha de detalle; uno de ellos usa iniciales en lugar de foto. Al pie, un aviso informa que la gestión de cuidadores se hace desde la plataforma web, con el enlace Ir a la web.

<div align="center">
  <img src="https://i.imgur.com/zfByGk5.png" alt="Red de cuidado"/>
</div>

Registrar actividad - Programación

Segundo paso del registro de una actividad, con indicador de progreso (1. Actividad completada, 2. Programación en curso) y enlace para volver a Actividad. Muestra la tarjeta de la actividad (medicación de la mañana, persona asistida y hogar), la fecha y la hora fijada editables, la frecuencia registrada (cada 12 horas), la opción de repetición (no se repite) y el responsable asignado. Incluye un campo de instrucción opcional con contador de 120 caracteres, un aviso de notificación prioritaria en el panel diario y los botones Atrás y Confirmar Programación.

<div align="center">
  <img src="https://i.imgur.com/hFFUGwl.png" alt="Registrar actividad - Programación"/>
</div>

Registrar actividad - Programación resumida

Segundo paso del registro de una actividad, con pestañas de pasos (1. Actividad y 2. Programación activa) y una tarjeta que identifica el medicamento, su dosis, la actividad, la vía y la persona asistida. Permite elegir la fecha y la hora de toma, la periodicidad (no se repite) y el cuidador responsable en turno con opción Delegar. Incluye un campo opcional de instrucción para el momento de la toma con contador de 140 caracteres, un aviso de alerta sonora de alta prioridad y los botones Atrás y Confirmar Programación.

<div align="center">
  <img src="https://i.imgur.com/GY9T5Mw.png" alt="Registrar actividad - Programación resumida"/>
</div>

Registrar actividad

Primer paso del registro de una actividad, con pestañas de pasos (1 Actividad activa y 2 Programación) y un indicador de paso 1 de 2 en la cabecera. Muestra la persona asistida seleccionada con su hogar, el selector de tipo de actividad en chips (Rutina, Medicamento seleccionado, Alimentación y más opciones desplazables) y el detalle con el nombre de la actividad y el medicamento elegido. Incluye una nota de que el medicamento se selecciona del catálogo autorizado y el botón Continuar.

<div align="center">
  <img src="https://i.imgur.com/5CvA7Vg.png" alt="Registrar actividad"/>
</div>

#### Aplicación mobile - Vista del técnico

Confirmar inicio de atención

Hoja inferior modal sobre el detalle de la orden que pide confirmar el inicio de la visita técnica presencial. Resume el código de orden, el tipo de servicio (incidencia técnica), el hogar beneficiario y el horario programado de hoy. Incluye un aviso de que la orden pasará a En proceso y se registrará la hora exacta de inicio, con los botones Iniciar atención y Cancelar.

<div align="center">
  <img src="https://i.imgur.com/IZ3Vjmp.png" alt="Confirmar inicio de atención"/>
</div>

Detalle de orden - Compacto

Detalle de una orden técnica asignada, con etiquetas de tipo y estado (Incidencia, Programada), nombre del hogar, distrito y fecha con horario. Tiene la sección Visita, con responsable y botón Llamar, dirección con enlace Abrir en Maps y referencia de acceso con opción Ver indicaciones. La sección Solicitud muestra el dispositivo y su ubicación, el problema reportado con su descripción y una miniatura de la fotografía adjunta. Termina con el botón fijo Iniciar atención y una nota de que abre una confirmación previa.

<div align="center">
  <img src="https://i.imgur.com/4bS2WBc.png" alt="Detalle de orden - Compacto"/>
</div>

Detalle de orden - Completo

Detalle de una orden técnica con las mismas secciones Visita y Solicitud, pero con etiquetas con ícono, el problema reportado resaltado en rojo y la referencia de acceso con enlace Ver indicaciones completas. La fotografía adjunta aparece como una fila con nombre del archivo (Reporte inicial, JPG) y un ícono para ampliarla. El botón inferior Iniciar atención indica que se confirmará el inicio antes de cambiar a En proceso.

<div align="center">
  <img src="https://i.imgur.com/Bdm5PYJ.png" alt="Detalle de orden - Completo"/>
</div>

Horario del técnico

Agenda del técnico con selector de semana, tira de días de lunes a domingo con el día actual resaltado y botón Hoy. Muestra un resumen de la jornada (horario, cantidad de órdenes y horas libres) y una línea de tiempo con inicio y fin de jornada, tarjetas de órdenes con franja horaria, tipo (Instalación, Revisión, Incidencia), hogar y distrito, y los tiempos disponibles entre ellas. Incluye campana de notificaciones y barra inferior con Inicio, Órdenes, Horario y Perfil.

<div align="center">
  <img src="https://i.imgur.com/02nd969.png" alt="Horario del técnico"/>
</div>

Incidencia - Diagnóstico

Primer paso del flujo de atención de una incidencia en estado En proceso, con indicador de progreso de tres pasos (Diagnóstico, Evidencias, Resultado). Muestra la ficha del dispositivo (nombre, tipo, MAC, estado Online, ubicación y hora), el problema reportado y la foto adjunta por el cuidador con botón Ver. El formulario tiene el campo obligatorio Diagnóstico técnico con contador, Acción correctiva opcional con atajos, aviso de guardado automático y verificaciones rápidas en sitio con casillas. Cierra con el botón Continuar a evidencias.

<div align="center">
  <img src="https://i.imgur.com/aA59udm.png" alt="Incidencia - Diagnóstico"/>
</div>

Incidencia - Evidencias

Segundo paso del flujo de la incidencia, dedicado a evidencias fotográficas, con el progreso mostrando el diagnóstico completado. Ofrece los botones Cámara y Galería y la lista Evidencias cargadas (2 de 4 máx.), con tarjetas de imagen que muestran nombre de archivo, tamaño, descripción, estado Válida, ícono de nube y botón para eliminar. Incluye un recuadro para agregar otra foto y una nota de guardado automático y almacenamiento seguro, con los botones de volver y Continuar a resultado.

<div align="center">
  <img src="https://i.imgur.com/tCHnYEJ.png" alt="Incidencia - Evidencias"/>
</div>

Incidencia - Resultado

Tercer y último paso del flujo de la incidencia, con progreso al 100 por ciento y el dispositivo atendido (sensor con último ping recibido). Pide elegir de forma obligatoria el resultado de la atención entre Resuelta (marcada como recomendada y seleccionada) y No resuelta, cada una con su descripción. Incluye un campo opcional de observaciones finales con contador, la tarjeta de la cuidadora responsable presente en sitio, aviso de guardado automático y el botón Revisar y finalizar.

<div align="center">
  <img src="https://i.imgur.com/YX6ueSW.png" alt="Incidencia - Resultado"/>
</div>

Inicio

Pantalla principal del técnico de campo con saludo, fecha y una franja de jornada que indica el estado "Jornada activa", el horario (8:00 a. m. – 5:00 p. m.) y un contador de órdenes del día. Cuando no hay órdenes asignadas muestra un estado vacío con mensaje informativo y el botón "Ver mi horario". Debajo incluye la sección "Últimas órdenes" con tarjetas de servicios completados (código, fecha, tipo de servicio, lugar y estado) y un enlace "Ver historial"; la barra inferior permite ir a Inicio, Órdenes, Horario y Perfil.

<div align="center">
  <img src="https://i.imgur.com/SwKIwqe.png" alt="Inicio"/>
</div>

Registro de dispositivo

Formulario del paso 2 de 4 (Dispositivos) del flujo de instalación de una orden, con barra de progreso al 50 % y código de orden. Muestra el hogar asignado con su dirección, marcado como verificado y con opción de cambiarlo, y los campos obligatorios: alias del dispositivo, dirección MAC (con opción de escanear QR, validación de formato y verificación de duplicados) y tipo de dispositivo en un desplegable. Cierra con los botones "Registrar dispositivo" y "Cancelar".

<div align="center">
  <img src="https://i.imgur.com/Z9uknyS.png" alt="Registro de dispositivo"/>
</div>

Orden completada

Pantalla de confirmación tras finalizar una orden, con ícono de éxito y el mensaje de que la información se registró correctamente. Resume el código de la orden, el tipo (incidencia técnica), el resultado final (resuelta) y la fecha y hora de finalización, junto con un aviso de que la orden se sincronizó y estará disponible en el Historial. Ofrece el botón "Volver a órdenes" y el enlace "Ver resumen".

<div align="center">
  <img src="https://i.imgur.com/C5BK8nu.png" alt="Orden completada"/>
</div>

Órdenes - Calendario

Vista de calendario de las órdenes del técnico, con selector Lista/Calendario, contadores en el encabezado (hoy, mañana, próxima) y una semana de octubre con el día actual resaltado y puntos de color por tipo (incidencias, instalación, revisión). Incluye filtros por tipo y, bajo el día seleccionado, tarjetas de las órdenes con hogar, tipo, horario, ubicación, estado (en proceso, programada, pendiente), un equipo o kit asociado y datos como prioridad o checklist. La tarjeta más próxima aparece marcada como "Siguiente".

<div align="center">
  <img src="https://i.imgur.com/n6WPdAR.png" alt="Órdenes - Calendario"/>
</div>

Órdenes - Lista

Listado de las órdenes técnicas asignadas al técnico, en tarjetas agrupadas por día (hoy, mañana, próximas) con el número de órdenes de cada grupo. Muestra contadores en el encabezado, selector Lista/Calendario y filtros por tipo (todas, revisiones, instalaciones, incidencias). Cada tarjeta indica hogar, tipo de orden, horario, distrito y estado (en proceso, programada, pendiente, completada), con una franja de color por tipo y la etiqueta "Siguiente" en la orden más inmediata.

<div align="center">
  <img src="https://i.imgur.com/t5iDVOE.png" alt="Órdenes - Lista"/>
</div>

Perfil personal

Perfil del técnico con foto de avatar (con botón de cámara), nombre completo y cargo, además de un ícono de notificaciones. Presenta la sección "Información personal" con un botón "Editar" y los datos de nombres, apellidos, documento de identidad (DNI), teléfono móvil y correo electrónico. Al final tiene la opción "Cerrar sesión" y una barra inferior con Inicio, Agenda, Órdenes, Historial y Perfil.

<div align="center">
  <img src="https://i.imgur.com/8m31AeP.png" alt="Perfil personal"/>
</div>


### 6.4.4. Applications User-flow Diagrams

#### Aplicación Web de Negocio

**User Flow 1:** Iniciar sesión

**User Goal:** Como usuario del negocio (administrador, técnico o gestor de suscripciones), quiero iniciar sesión con mi correo y contraseña, para acceder a las funciones de mi rol.

<div align="center">
  <img src="https://i.imgur.com/Nfn35op.png" alt="Iniciar sesión"/>
</div>

El usuario abre la pantalla de inicio de sesión, ingresa su correo y contraseña y llega al inicio de su rol. En el camino alterno, si ingresa datos no válidos, el sistema muestra la pantalla de inicio de sesión con errores de validación y el usuario corrige los datos para volver a intentar.

**User Flow 2:** Recuperar contraseña

**User Goal:** Como usuario del negocio (administrador, técnico o gestor de suscripciones), quiero recuperar mi contraseña cuando la olvido, para volver a entrar a mi cuenta.

<div align="center">
  <img src="https://i.imgur.com/A1q3Aq2.png" alt="Recuperar contraseña"/>
</div>

Desde el inicio de sesión, el usuario elige recuperar su contraseña, ingresa su correo para solicitar el código, define y confirma la nueva contraseña, ve la confirmación de contraseña actualizada y regresa al inicio de sesión. En el camino alterno, si el correo no es válido o la nueva clave no cumple los requisitos, el sistema muestra la pantalla correspondiente con errores y el usuario corrige el dato para reintentar.

**User Flow 3:** Registrar un empleado

**User Goal:** Como administrador, quiero registrar un empleado con sus datos personales, laborales y de acceso, para que pueda operar en la plataforma.

<div align="center">
  <img src="https://i.imgur.com/J70fHXT.png" alt="Registrar un empleado"/>
</div>

Desde la gestión de empleados, el administrador elige registrar un empleado y completa la información personal, la información laboral y el acceso a la plataforma. Luego revisa los datos, confirma y regresa a la gestión de empleados. En el camino alterno, si avanza con datos incompletos en el primer o el segundo paso, el sistema muestra el paso con errores y el administrador corrige el dato para continuar.

**User Flow 4:** Registrar un contrato y su horario laboral

**User Goal:** Como administrador, quiero registrar el contrato y el horario laboral de un empleado, para definir cuándo y bajo qué condiciones trabaja.

<div align="center">
  <img src="https://i.imgur.com/GaUiMkQ.png" alt="Registrar un contrato y su horario laboral"/>
</div>

Desde la lista de contratos, el administrador registra un contrato, lo guarda y revisa su detalle. Después va a los horarios laborales, registra un horario, lo guarda y revisa su detalle. En el camino alterno, si guarda el contrato o el horario con datos incompletos, el sistema muestra el formulario con errores y el administrador corrige el dato. También puede editar un horario ya registrado desde su detalle y guardar los cambios.

**User Flow 5:** Atender una orden técnica

**User Goal:** Como administrador, quiero asignar un técnico a una orden pendiente, para que el servicio se atienda a tiempo.

<div align="center">
  <img src="https://i.imgur.com/BX9jPMu.png" alt="Atender una orden técnica"/>
</div>

Desde las órdenes técnicas, el administrador selecciona una orden, abre su detalle, elige asignar un técnico, escoge al empleado, confirma y regresa a la lista de órdenes. En el camino alterno, si no hay ningún técnico disponible en ese horario, aparece un aviso en la ventana y el administrador elige otro técnico u otro horario.

**User Flow 6:** Configurar el perfil del negocio

**User Goal:** Como administrador, quiero configurar la información del negocio, para que clientes y equipo vean datos correctos.

<div align="center">
  <img src="https://i.imgur.com/Q8RZLlC.png" alt="Configurar el perfil del negocio"/>
</div>

El administrador abre el perfil del negocio y recorre las secciones de identidad, información de contacto, información para clientes y ubicación corporativa, completando los datos de cada una. En el camino alterno, si guarda un dato no válido (correo, teléfono o RUC), aparece un error junto al campo y el administrador corrige el dato.

**User Flow 7:** Atender una orden desde la web

**User Goal:** Como técnico, quiero consultar mis órdenes asignadas y su detalle, para llegar preparado a cada visita.

<div align="center">
  <img src="https://i.imgur.com/nwTOkh9.png" alt="Atender una orden desde la web"/>
</div>

Desde el inicio, el técnico entra a sus órdenes, selecciona una orden para ver su detalle y consulta el calendario desde el menú. En el camino alterno, si no tiene órdenes asignadas, la lista muestra un mensaje de lista vacía.

**User Flow 8:** Consultar inventario y registrar un dispositivo

**User Goal:** Como técnico, quiero consultar el inventario y registrar un dispositivo, para dejar el servicio instalado y documentado.

<div align="center">
  <img src="https://i.imgur.com/9HH2V6G.png" alt="Consultar inventario y registrar un dispositivo"/>
</div>

El técnico abre el inventario de dispositivos por categorías, entra a la categoría de micrófonos, elige registrar un dispositivo, completa los datos, guarda y vuelve al inventario actualizado. En el camino alterno, si el código está repetido o los datos están incompletos, el sistema muestra el formulario con errores y el técnico corrige los datos. También se contemplan los casos en que el inventario no carga, la categoría no tiene registros o un filtro no encuentra coincidencias.

#### Aplicación Web de Cuidadores

**User Flow 1:** Contratar el plan Base

**User Goal:** Como cuidador o familiar, quiero contratar el plan Base para mi hogar, para recibir asistencia domiciliaria.

<div align="center">
  <img src="https://i.imgur.com/4Gv7HHP.png" alt="Contratar el plan Base"/>
</div>

La persona elige el plan Base, crea su cuenta, registra su hogar, revisa la configuración del plan, elige día y hora de la evaluación, confirma la visita y realiza el pago. En el camino alterno, si envía datos no válidos al crear la cuenta, si la dirección no tiene cobertura técnica o si la tarjeta es rechazada, el sistema muestra la pantalla de error correspondiente y la persona corrige los datos, cambia la dirección o usa otro medio de pago. También se contemplan un error al cargar la configuración y un horario no disponible.

**User Flow 2:** Contratar el plan Personalizado

**User Goal:** Como cuidador o familiar, quiero armar un plan personalizado por habitaciones y dispositivos, para adaptar el servicio a mi hogar.

<div align="center">
  <img src="https://i.imgur.com/iVSvAPJ.png" alt="Contratar el plan Personalizado"/>
</div>

La persona elige el plan Personalizado, selecciona las habitaciones y los dispositivos que necesita, revisa el resumen de la configuración, elige día y hora de la evaluación y confirma. En el camino alterno, si continúa sin elegir ninguna habitación o ningún dispositivo, o si elige un horario ocupado, aparece un aviso en la pantalla y la persona corrige su elección.

**User Flow 3:** Seguir el servicio contratado

**User Goal:** Como cuidador o familiar, quiero seguir el avance de mi servicio, para saber cuándo quedará activo en mi hogar.

<div align="center">
  <img src="https://i.imgur.com/if7al1P.png" alt="Seguir el servicio contratado"/>
</div>

La persona consulta el seguimiento de su servicio en cada etapa: confirmación, evaluación, instalación y activación, hasta ver el servicio activo. En el camino alterno, si la visita debe reprogramarse, la instalación no puede completarse o el estado no carga, el seguimiento muestra un aviso y la persona elige otro horario, coordina una nueva visita o reintenta.

**User Flow 4:** Gestionar actividades

**User Goal:** Como cuidador o familiar, quiero programar y revisar las actividades diarias, para organizar el cuidado en el hogar.

<div align="center">
  <img src="https://i.imgur.com/7G2UQbi.png" alt="Gestionar actividades"/>
</div>

Desde el inicio, la persona abre la lista de actividades, crea una nueva actividad, completa los datos y guarda, revisa el detalle de la actividad y consulta el calendario. En el camino alterno, si programa una actividad en un horario ocupado, el sistema muestra el conflicto de horario y la persona cambia el horario. También se contemplan los casos de lista o calendario sin actividades.

**User Flow 5:** Invitar a la red de cuidado

**User Goal:** Como cuidador o familiar, quiero invitar a otros cuidadores a la red de cuidado, para compartir el cuidado de la persona asistida.

<div align="center">
  <img src="https://i.imgur.com/0F8WJJU.png" alt="Invitar a la red de cuidado"/>
</div>

La persona abre la red de cuidado, elige invitar a un cuidador, envía la invitación y revisa el detalle de la red. El invitado abre su enlace para aceptar la invitación. En el camino alterno, si envía datos no válidos, el sistema muestra el formulario con errores y la persona los corrige. También se contemplan una red sin cuidadores y una invitación vencida, en la que se solicita una nueva.

**User Flow 6:** Consultar y revisar dispositivos

**User Goal:** Como cuidador o familiar, quiero consultar los dispositivos instalados, para saber que todo funciona en mi hogar.

<div align="center">
  <img src="https://i.imgur.com/Hevc6GM.png" alt="Consultar y revisar dispositivos"/>
</div>

Desde el inicio, la persona abre la lista de dispositivos y selecciona uno para ver su detalle. En el camino alterno, si el hub está desconectado, el sistema muestra los dispositivos con ese aviso y la persona restablece la conexión. También se contempla un error al cargar el detalle del dispositivo.

**User Flow 7:** Reportar una incidencia

**User Goal:** Como cuidador o familiar, quiero reportar una incidencia y seguir su atención, para recibir ayuda cuando algo falla.

<div align="center">
  <img src="https://i.imgur.com/bP9eK3v.png" alt="Reportar una incidencia"/>
</div>

La persona abre la lista de incidencias, elige reportar una, completa los datos y envía. Luego revisa el detalle de la incidencia registrada, la sigue mientras está en atención y ve cuándo queda resuelta. En el camino alterno, si aún no tiene reportes, la lista aparece vacía. También se contemplan el envío del formulario sin completar y un error al enviar la incidencia.

**User Flow 8:** Consultar actividades (cuidador de apoyo)

**User Goal:** Como cuidador de apoyo, quiero consultar las actividades asignadas, para cumplir mis tareas de cuidado.

<div align="center">
  <img src="https://i.imgur.com/EKUBvqj.png" alt="Consultar actividades (cuidador de apoyo)"/>
</div>

Desde el inicio, el cuidador de apoyo abre la lista de actividades, selecciona una para ver su detalle y consulta el calendario. En el camino alterno, si no tiene actividades asignadas o el calendario está vacío, se muestra un mensaje de lista vacía. También se contempla un error al cargar el detalle de la actividad.

#### Aplicación Móvil

**User Flow 1:** Iniciar sesión

**User Goal:** Como usuario de la app móvil (cuidador o técnico), quiero iniciar sesión con mi correo y contraseña, para acceder a las funciones de mi rol.

<div align="center">
  <img src="https://i.imgur.com/1AhHeRP.png" alt="Iniciar sesión"/>
</div>
Al abrir la app aparece la pantalla de inicio; el usuario pasa al inicio de sesión, ingresa sus datos y llega al inicio de su rol. En el camino alterno, si ingresa datos no válidos, el sistema muestra la pantalla de inicio de sesión con errores y el usuario corrige los datos para volver a intentar.

**User Flow 2:** Recuperar contraseña

**User Goal:** Como usuario de la app móvil (cuidador o técnico), quiero recuperar mi contraseña cuando la olvido, para volver a entrar a mi cuenta.

<div align="center">
  <img src="https://i.imgur.com/PFeCCQn.png" alt="Recuperar contraseña"/>
</div>
Desde el inicio de sesión, el usuario elige recuperar su contraseña, ingresa el código de verificación, crea su nueva contraseña y ve la confirmación de contraseña actualizada. En el camino alterno, si el código es incorrecto, el sistema muestra la pantalla con el error y el usuario corrige el código.

**User Flow 3:** Gestionar actividades (cuidador o familiar)

**User Goal:** Como cuidador o familiar, quiero programar y revisar las actividades diarias, para organizar el cuidado en el hogar.

<div align="center">
  <img src="https://i.imgur.com/OtakbEj.png" alt="Gestionar actividades"/>
</div>
Desde el inicio, el usuario abre la lista o el calendario de actividades, consulta el detalle de una actividad y registra una nueva con su programación. En el camino alterno, si no hay actividades, el sistema muestra el estado vacío; si el usuario descarta el registro, vuelve a la lista sin guardar cambios.

**User Flow 4:** Revisar dispositivos (cuidador o familiar)

**User Goal:** Como cuidador o familiar, quiero consultar el estado de los dispositivos del hogar, para saber que funcionan correctamente.

<div align="center">
  <img src="https://i.imgur.com/ilb0tnL.png" alt="Revisar dispositivos"/>
</div>
Desde el inicio, el usuario abre la lista de dispositivos y entra al detalle de uno para ver su estado. En el camino alterno, si ocurre un error al cargar los dispositivos, el sistema muestra el error y el usuario puede reintentar.

**User Flow 5:** Atender una orden técnica

**User Goal:** Como técnico, quiero consultar y atender mis órdenes técnicas, para cumplir las visitas asignadas.

<div align="center">
  <img src="https://i.imgur.com/056XpP7.png" alt="Atender una orden técnica"/>
</div>
Desde el inicio, el técnico abre la lista o el calendario de órdenes, revisa el detalle de una orden, la confirma y ve la pantalla de orden completada. En el camino alterno, si no hay órdenes se muestra el estado vacío; si el detalle falla, aparece el error; y si confirma sin disponibilidad, el sistema lo informa.

**User Flow 6:** Instalación

**User Goal:** Como técnico, quiero registrar el diagnóstico y las evidencias de la incidencia y registrar el dispositivo en el hogar, para dejar el servicio instalado y documentado.

<div align="center">
  <img src="https://i.imgur.com/Mng9f5y.png" alt="Instalación"/>
</div>
Desde el detalle de la orden, el técnico registra el diagnóstico, adjunta las evidencias y ve el resultado; luego consulta las instalaciones y registra el dispositivo para el hogar, dejando el servicio instalado. En el camino alterno, si descarta los cambios en las evidencias vuelve sin guardar, y si registra el dispositivo con datos incorrectos, el sistema pide corregirlos.

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
