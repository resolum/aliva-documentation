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

El cubo cuenta con indicadores LED que comunican su estado sin necesidad de que la persona asistida mire una pantalla, algo especialmente relevante considerando la comorbilidad visual frecuente en este segmento (ver Capítulo 1). Los estados se codifican por color y patrón de parpadeo, nunca solo por color, para no depender de la percepción cromática:

| Estado del dispositivo       | Color del LED | Patrón                     | Significado para la persona asistida                              |
| ----------------------------- | -------------- | --------------------------- | -------------------------------------------------------------------- |
| Disponible / en espera       | Turquesa       | Fijo, brillo bajo           | El dispositivo está listo para recibir un comando de voz            |
| Escuchando un comando        | Turquesa       | Pulso suave (fade in/out)   | El dispositivo detectó el inicio de una instrucción y está procesándola |
| Acción ejecutada con éxito   | Turquesa       | Parpadeo corto único       | La acción solicitada (encender luz, abrir puerta) se completó       |
| Comando no reconocido        | Azul Marino    | Parpadeo doble             | El sistema no comprendió la instrucción y solicitará repetirla      |
| Batería de respaldo baja     | Ámbar/Amarillo | Parpadeo lento y sostenido | Advierte que la energía de respaldo se está agotando                 |
| Falla o desconexión          | Rojo           | Parpadeo rápido            | El dispositivo perdió una función esencial y ya alertó al cuidador   |

Este código de color y parpadeo se mantiene idéntico en todos los dispositivos instalados en una misma vivienda, para que la persona asistida no tenga que memorizar variaciones entre el cubo del dormitorio y el de la sala.

##### Señalización sonora (miniparlante)

Dado que la interacción es enteramente por voz, el diseño sonoro del dispositivo sigue directamente los principios de Communication Tone & Language: respuestas breves, directas y sin alarmismo, incluso en escenarios de falla.

- Las **confirmaciones de acción** ("Listo, la puerta está abierta") se reproducen en un tono neutro y sereno, siguiendo el Body tone definido en la guía general, evitando cualquier efecto sonoro adicional que pueda distraer o confundirse con una alerta.
- Las **solicitudes de repetición** ante un comando no reconocido usan una frase corta y sin tono de reproche ("No entendí, ¿puedes repetirlo?"), reforzando el principio de respeto por la autonomía de la persona asistida.
- Las **confirmaciones de auxilio** ("Se avisó a tu cuidador, ya viene en camino") priorizan la calma y la claridad sobre la urgencia, evitando cualquier sonido que pueda generar más ansiedad en un momento de necesidad real.
- El **volumen y la velocidad de habla** del dispositivo son configurables por el cuidador durante la instalación, considerando que las condiciones auditivas y el tamaño de la habitación varían de un hogar a otro.

##### Interacción por voz

El dispositivo no cuenta con botones físicos de uso primario ni pantalla; toda la interacción de la persona asistida ocurre mediante frases clave, siguiendo el patrón de Intent Mapping definido en el diseño arquitectónico (ver Capítulo 4):

- Las **frases de activación** son cortas, en lenguaje cotidiano y sin variantes técnicas, de modo que resulten fáciles de recordar y pronunciar incluso para personas con fatiga vocal.
- El dispositivo **nunca ejecuta una acción física sin antes confirmar mediante LED y sonido** que recibió la instrucción, siguiendo la táctica de Confidence Threshold y Safe Default: ante duda, se abstiene y pide repetir, en lugar de arriesgar una acción no solicitada.
- La **frase de auxilio** se trata de forma diferenciada del resto de comandos: cualquier expresión reconocida como solicitud de ayuda activa de inmediato el flujo de alerta crítica hacia el cuidador, sin esperar confirmaciones adicionales que puedan retrasar la asistencia.

##### Coherencia física del dispositivo

El diseño físico del cubo sigue la misma lógica de calidez y confianza que el resto de la marca: formas redondeadas (coherentes con la geometría de la tipografía Outfit), acabado mate que evite reflejos molestos para personas con baja visión, y un tamaño que permita ubicarlo cerca de la cama o el área de mayor permanencia de la persona asistida sin resultar intrusivo en la decoración del hogar. El logotipo de Alivia, en su versión reducida (solo el isotipo del corazón), se ubica de forma discreta en la base del dispositivo, manteniendo la identidad de marca sin competir visualmente con los indicadores LED, que son el elemento funcional prioritario.

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
