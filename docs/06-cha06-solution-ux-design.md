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

<p align="center">Organización de la aplicación</p>
<div style="display: flex; align-items: center;">
  <img src="https://imgur.com/c2Cj63r.png" alt="front_organization">
</div>

Este esquema detalla la arquitectura interna de la aplicación del familiar o cuidador. La organización jerárquica parte de un Inicio que resume el estado general del hogar y ramifica el acceso hacia los módulos operativos clave: la gestión del hogar y la red de cuidado, los dispositivos, las alertas, la agenda de cuidado, el soporte técnico y las métricas de autonomía.

Casos de aplicación:

- Pantalla de Inicio donde las alertas pendientes y el estado general del hogar aparecen en la parte superior, por encima de las próximas actividades.
- Vistas de dispositivos donde badges de color, íconos outline y tipografía Outfit Semibold jerarquizan el estado de cada dispositivo (operativo, batería baja o falla), mostrando primero los que requieren atención.
- Bandeja de alertas donde las solicitudes de auxilio y las alertas críticas se anclan en la parte superior, por encima de recordatorios y notificaciones informativas.

#### Organización secuencial

Alivia también aplica una organización secuencial en procesos que requieren una progresión lógica y una guía paso a paso, especialmente en los flujos de contratación y en aquellos donde el orden de las acciones impacta en la seguridad o la trazabilidad del cuidado.

Casos de aplicación:

- **Contratación del servicio:** registro del responsable y creación de la cuenta del hogar, selección del plan y la periodicidad, autorización temporal del importe, selección del horario de evaluación técnica, resultado técnico (viable, parcialmente viable o no viable) e instalación y activación con conformidad del cliente (US05 a US11).
- **Onboarding del hogar:** completar el perfil del hogar con una ubicación validada, registrar a la persona asistida e invitar a los cuidadores de la red de cuidado, antes de que la persona asistida empiece a usar el sistema por sí misma (US42, US12, US13).
- **Gestión de una alerta crítica:** recepción de la alerta, confirmación por parte del cuidador, inicio de la atención y registro del resultado (resuelta), con repeticiones automáticas cada dos minutos hasta un máximo de tres si no hay confirmación (US24).
- **Transferencia de responsabilidad entre turnos:** finalización del turno, aceptación del relevo por el siguiente cuidador y entrega del resumen de actividades, medicamentos y alertas pendientes (US27).
- **Reporte de una falla:** descripción del problema, adjunto de evidencia fotográfica, selección de un horario técnico disponible y seguimiento hasta la resolución (US31).
- **Interacción por voz de la persona asistida:** emisión del comando, confirmación audible de la acción y notificación de falla al cuidador cuando el dispositivo no responde (US18 a US20).

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

La persona con discapacidad motora severa no interactúa con estas vistas: su interfaz es exclusivamente el dispositivo de voz, organizado mediante frases clave asociadas a acciones (luz, puerta, ventana y auxilio) y señales sonoras y luminosas.

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

El dispositivo no cuenta con pantalla, por lo que su "etiquetado" se compone de frases de voz y señales luminosas. Se mantiene la coherencia con el tono definido: breve, sereno y sin alarmismo.

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
- **Señales luminosas (LED):**
    - **Turquesa fijo:** Disponible y en espera.
    - **Turquesa con pulso suave:** Escuchando un comando.
    - **Ámbar con parpadeo lento:** Batería de respaldo baja.
    - **Rojo con parpadeo rápido:** Falla o desconexión.

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
| Dispositivo IoT | No aplica búsqueda textual | La persona asistida interactúa únicamente mediante frases de voz asociadas a acciones (Intent Mapping); el dispositivo comunica su estado mediante LED y miniparlante, sin flujo de búsqueda manual |

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

El dispositivo no cuenta con pantalla ni botones de uso primario, por lo que su "navegación" se resuelve mediante interacción por voz y señales:

- **Activación por frases clave:** la persona asistida solicita acciones mediante frases cortas y cotidianas asociadas a luz, puerta, ventana y auxilio (Intent Mapping).
- **Retroalimentación inmediata:** cada comando se confirma por voz con el resultado real de la acción; ante baja confianza (menos de 75 %) el dispositivo se abstiene de actuar y solicita repetir la instrucción.
- **Estado permanente:** los indicadores LED comunican el estado operativo (disponible, escuchando, batería baja o falla) mediante color y patrón de parpadeo, sin depender solo del color.
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
