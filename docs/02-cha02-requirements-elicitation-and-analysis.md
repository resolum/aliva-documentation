# Capítulo 2: Requirements Elicitation & Analysis

## 2.1. Competidores

- **Fundación ONCE** (competidor indirecto): Proyecto desarrollado que presenta un modelo de hogar domotizado adaptado a las necesidades de personas con discapacidad. Está orientado a personas con discapacidad motora y visual que buscan mayor autonomía en el hogar. Su principal fortaleza es el respaldo técnico y la trayectoria de una organización consolidada en el sector, aunque funciona más como referente institucional que como producto comercial escalable y no tiene presencia en el mercado peruano.

- **Somfy** (competidor indirecto): Fabricante europeo de kits de domótica que permiten controlar luces, persianas, temperatura y seguridad desde una app o por comandos de voz. Se orienta a hogares en general, incluyendo personas con movilidad reducida. Su principal ventaja es el respaldo de marca y la disponibilidad inmediata de hardware accesible en costo, aunque su oferta es genérica y no está pensada específicamente para discapacidad severa ni para operar sin conexión a Internet.

- **My Sweet Smart Home** (competidor directo): Proyecto europeo desarrollado bajo el programa Erasmus+ que ofrece un entorno inteligente adaptado a personas con discapacidad, combinando automatización del hogar, control por voz y señales sonoras. Está orientado a personas con discapacidad motora y visual dentro del contexto europeo. Destaca por su especialización real en el segmento de discapacidad, aunque su alcance se limita a Europa y no resuelve el requerimiento de funcionamiento con baja o nula conectividad.

- **Amazon Alexa** (competidor directo): Ecosistema de asistente de voz e integraciones smart home que permite controlar luces, enchufes y cerraduras mediante comandos verbales. Es ampliamente adoptado por personas con discapacidad motora como solución de accesibilidad general. Su principal fortaleza es la enorme base de usuarios y la madurez del reconocimiento de voz, aunque depende de conexión constante a Internet y no ofrece reconocimiento de gestos como canal alternativo de comando.

### 2.1.1. Análisis competitivo

<table>
    <tr>
        <td colspan="7"><b>Competitive Analysis Landscape</b></td>
    </tr>
    <tr>
        <td colspan="2">¿Por qué llevar a cabo este análisis?</td>
        <td colspan="5">Conocer qué tan cubierta está la necesidad de autonomía en el hogar de personas con discapacidad motora y visual, y validar si el enfoque offline de Alivia representa una ventaja real frente al resto del mercado.</td>
    </tr>
    <tr>
        <th colspan="2"></th>
        <th>Alivia <br><img src="https://imgur.com/Usux8Tf.jpg" width="80"/></th>
        <th>Fundación ONCE <br><img src="https://imgur.com/yResSp2.jpg" width="80"/></th>
        <th>Amazon Alexa <br><img src="https://imgur.com/6Pb0RIE.jpg" width="80"/></th>
        <th>Somfy <br><img src="https://imgur.com/z9HCKlW.jpg" width="80"/></th>
        <th>My Sweet Smart Home <br><img src="https://imgur.com/F0gWQ35.jpg" width="80"/></th>
    </tr>
    <tr>
        <td rowspan="2" style="writing-mode: vertical-lr; transform: rotate(180deg); text-align: center">Perfil</td>
        <td>Overview</td>
        <td>Personas con discapacidad motora y visual que buscan mayor autonomía en el hogar mediante comandos de voz y gestos.</td>
        <td>Modelo de casa domotizada adaptada a personas con discapacidad.</td>
        <td>Asistente de voz e integraciones smart home.</td>
        <td>Kits de domótica para movilidad reducida.</td>
        <td>Entorno inteligente adaptado a discapacidad.</td>
    </tr>
    <tr>
        <td>Ventaja competitiva</td>
        <td>Solución especializada en la autonomía y supervisión de personas con discapacidad motora y visual.</td>
        <td>Trayectoria y respaldo institucional en el sector.</td>
        <td>Adopción masiva y voz muy madura.</td>
        <td>Marca reconocida y hardware disponible.</td>
        <td>Especialización real en discapacidad.</td>
    </tr>
    <tr>
        <td rowspan="2" style="writing-mode: vertical-lr; transform: rotate(180deg); text-align: center">Perfil de Marketing</td>
        <td>Mercado objetivo</td>
        <td>Hogares con algún miembro con discapacidad motora o visual, junto a sus cuidadores.</td>
        <td>Sector de la edificación, diseño y accesibilidad en España.</td>
        <td>Usuarios de smart home en general.</td>
        <td>Hogares en general.</td>
        <td>Personas con discapacidad </td>
    </tr>
    <tr>
        <td>Estrategias de marketing</td>
        <td>Alianzas con asociaciones y apoyo de CONADIS.</td>
        <td>Exposiciones itinerantes como referente institucional.</td>
        <td>Posicionamiento masivo como hogar inteligente.</td>
        <td>Marca premium de confort y automatización.</td>
        <td>Difusión vía fondos de innovación social.</td>
    </tr>
    <tr>
        <td rowspan="3" style="writing-mode: vertical-lr; transform: rotate(180deg); text-align: center">Perfil de Producto</td>
        <td>Productos & Servicios</td>
        <td>IoT + decisión local + configuración para cuidadores.</td>
        <td>Vivienda modelo, sin producto propio.</td>
        <td>Altavoces + integraciones con luces y cerraduras.</td>
        <td>Persianas, luces, temperatura y seguridad.</td>
        <td>Automatización + señales sonoras.</td>
    </tr>
    <tr>
        <td>Precios & Costos</td>
        <td>Bajo costo</td>
        <td>No aplica, no es comercial.</td>
        <td>Bajo costo por dispositivo.</td>
        <td>Costo medio-alto por kit.</td>
        <td>Financiado con fondos públicos.</td>
    </tr>
    <tr>
        <td>Canales de distribución (Web y/o Móvil)</td>
        <td>Web y Móvil</td>
        <td>Web</td>
        <td>Web</td>
        <td>Web y Móvil</td>
        <td>Web</td>
    </tr>
    <tr>
        <td rowspan="4" style="writing-mode: vertical-lr; transform: rotate(180deg); text-align: center">Análisis SWOT</td>
        <td>Fortalezas</td>
        <td>Funcionamiento offline y doble canal de comando.</td>
        <td>Credibilidad y experiencia en discapacidad.</td>
        <td>Base de usuarios enorme.</td>
        <td>Hardware confiable.</td>
        <td>Enfoque real en discapacidad.</td>
    </tr>
    <tr>
        <td>Debilidades</td>
        <td>Marca nueva, sin reconocimiento.</td>
        <td>No escalable, sin presencia en Perú.</td>
        <td>Depende de Internet.</td>
        <td>No especializado en discapacidad.</td>
        <td>Sin alcance fuera de Europa.</td>
    </tr>
    <tr>
        <td>Oportunidades</td>
        <td>Baja competencia especializada en Perú.</td>
        <td>Replicarse en Latinoamérica.</td>
        <td>Sumar funciones de accesibilidad.</td>
        <td>Entrar al nicho de discapacidad.</td>
        <td>Expandirse fuera de Europa.</td>
    </tr>
    <tr>
        <td>Amenazas</td>
        <td>Entrada de Alexa o Google Home al nicho.</td>
        <td>Perder relevancia frente a soluciones ágiles.</td>
        <td>Soluciones más especializadas.</td>
        <td>Startups locales más enfocadas.</td>
        <td>Depender de fondos públicos.</td>
    </tr>
</table>

### 2.1.2. Estrategias y tácticas frente a competidores

#### Enfoque Estratégico
Alivia se posicionará como una solución de automatización del hogar especializada en discapacidad motora y visual, combinando comandos por voz y gestos con procesamiento local que no dependerá de una conexión constante a Internet. A diferencia de la competencia, que ofrece soluciones genéricas o limitadas a un solo canal de comando, buscamos convertirnos en la alternativa más confiable para este segmento en el mercado peruano.

---

#### 1. Frente a Fundación ONCE
- Ofreceremos un producto comercial y escalable, no solo un modelo de referencia institucional sin fines comerciales
- Buscaremos tener presencia real en el mercado peruano mediante alianzas con asociaciones locales y el apoyo de CONADIS
- Pensaremos nuestra configuración para el uso diario en el hogar, no para exhibición o fines educativos
- Brindaremos soporte continuo y actualizaciones, en lugar de un modelo estático de vivienda demostrativa

---

#### 2. Frente a Amazon Alexa
- No dependeremos de una conexión constante a Internet, gracias a un módulo de toma de decisiones que procesará los comandos de forma local
- Contaremos con doble canal de comando (voz y gestos), ampliando el acceso a personas con discapacidad motora que no pueden depender solo del habla
- Diseñaremos el sistema desde el inicio para discapacidad severa, en lugar de adaptar después una solución de smart home genérico
- Ofreceremos confirmación auditiva pensada específicamente para personas con discapacidad visual, y no solo respuestas genéricas de asistente virtual

---

#### 3. Frente a Somfy
- Nos enfocaremos específicamente en discapacidad motora y visual, en lugar de dirigirnos a hogares en general
- Buscaremos ofrecer un costo más accesible para este segmento, priorizando componentes de bajo costo y un modelo de licencias frente al hardware premium de Somfy
- Adaptaremos la configuración a las necesidades reales del usuario, no una solución genérica de domótica
- Priorizaremos la confiabilidad ante fallas de conexión, un aspecto que Somfy no resuelve directamente

---

#### 4. Frente a My Sweet Smart Home
- Buscaremos tener presencia y alcance en el mercado peruano, partiendo de un contexto local en lugar de replicar un modelo europeo
- Plantearemos un modelo sostenible mediante venta de licencias y hardware, en lugar de depender de fondos de innovación social
- Apuntaremos a una expansión progresiva dentro de Latinoamérica, partiendo de una base sólida en Perú

## 2.2. Entrevistas

### 2.2.1. Diseño de entrevistas


#### Segmento objetivo 1: Personas con discapacidad motora o visual

##### Preguntas personales:

* ¿Cuál es su nombre?

* ¿Cuál es su edad?

* ¿En qué lugar vive actualmente ?

* ¿Con quién vive actualmente?

* ¿Qué tipo de discapacidad presenta (motora, visual, o ambas) y desde cuándo la tiene?

##### Preguntas específicas:

* ¿Qué actividades básicas del hogar le resultan más difíciles de realizar por su cuenta (por ejemplo: abrir puertas, encender luces, ajustar la temperatura)?

* ¿Con qué frecuencia necesita pedir ayuda a otra persona para realizar este tipo de actividades en un día normal?

* ¿Quién le brinda esa ayuda habitualmente (familiar, cuidador contratado, ambos)?

* ¿Qué hace cuando necesita realizar una de estas actividades y no hay nadie disponible para ayudarlo/a en ese momento?

* ¿Ha utilizado alguna vez algún dispositivo o sistema de asistencia tecnológica en su hogar (asistentes de voz, sensores, automatización)? ¿Cuál fue su experiencia?

* Si tuviera un sistema que le permitiera controlar luces, puertas u otros dispositivos del hogar usando solo su voz o movimientos de su cuerpo, ¿qué tan útil cree que sería para usted?

#### Segmento objetivo 2: Familiar o cuidador de persona con discapacidad

##### Preguntas personales:

* ¿Cuál es su nombre?

* ¿Cuál es su edad?

* ¿En qué lugar vive actualmente ?

* ¿Qué relación tiene con la persona a la que cuida ?

* ¿Vive en el mismo hogar que la persona con discapacidad?

* ¿Es usted el único cuidador de esta persona, o comparte esa responsabilidad con alguien más?

##### Preguntas específicas:

* ¿Cuáles son las actividades basicas en la que apoya a la persona?

* ¿Qué pasa cuando usted no está disponible y la persona necesita ayuda con una de estas tareas?

* ¿Ha utilizado o considerado usar algún sistema para apoyar a la persona a su cargo?

* ¿Qué tan dispuesto/a estaría a dejar que la persona realice estas actividades con el sistema, sin su intervención directa?

* ¿Qué tan importante es para usted poder monitorear qué actividades realiza la persona a su cargo mediante el sistema?

### 2.2.2. Registro de entrevistas

**Segmento 1: Personas con discapacidad motora**

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
        <td>62 años</td>
    </tr>
    <tr>
        <td><strong>Rol</strong></td>
        <td>Persona con discapacidad motora</td>
    </tr>
    <tr>
        <td><strong>Evidencia</strong></td>
        <td>
        <div align="center">
            <img 
                src="https://imgur.com/R5DGVTS.png" 
                style="width:100%; max-width:720px; height:500px; object-fit:cover; object-position:center; display:block; margin:0 auto;"
                alt="">
        </div>
        </td>
    </tr>
    <tr>
        <td><strong>Link</strong></td>
        <td><a href="">Enlace a la grabación</a></td>
    </tr>
    <tr>
        <td><strong>Timing donde inicia la entrevista</strong></td>
        <td>00:00 min</td>
    </tr>
    <tr>
        <td><strong>Duración de la entrevista</strong></td>
        <td>00:00 min</td>
    </tr>
    <tr>
        <td><strong>Resumen</strong></td>
        <td>

### **1. Características Objetivas**
* **Origen de la Discapacidad:** Presenta una discapacidad física por **parálisis cerebral**. Esta fue consecuencia de un error clínico al nacer, ya que debió nacer por cesárea y la falta de esta vía cortó el flujo de oxígeno a su cerebro.
* **Evolución Médica y Física:**
    * Desde los 9 años utilizó muletas de madera y anteriormente se desplazaba en triciclo.
    * En el año **2017**, desarrolló un problema crónico en las rodillas que le impidió volver a usarlas, viéndose obligado a depender por completo de una **silla de ruedas**.
    * Presenta limitaciones de movilidad en el tren superior: solo puede manipular con normalidad la **mano izquierda**, mientras que la derecha solo la mueve con mucho esfuerzo.
    * No puede permanecer de pie más de media hora debido a que el dolor en las rodillas se vuelve insoportable.
* **Red de Apoyo Familiar y Asistencia:** Su **papá** es quien le brinda asistencia habitual para incorporarse y sentarse. El resto de su familia lo moviliza y carga para subir escaleras o trasladarse. Adicionalmente, recibe terapia física de la madre del entrevistador, a quien le tiene un profundo agradecimiento por restaurar la conductividad eléctrica de sus músculos.

---

### **2. Comportamiento, Dolores y Aspectos Subjetivos**
* **Personalidad y Actitud:** Gerardo se muestra como un hombre altamente **independiente, disciplinado, culto, autodidacta y sumamente reflexivo**. Posee un orgullo muy firme por su autonomía, señalando que le molesta depender del apoyo físico de otros porque desde niño aprendió a no necesitar de nadie.
* **Filosofía de Vida:** Se rige bajo una estricta filosofía de autosuperación aprendida en su colegio especial de La Molina, el cual era dirigido por una maestra alemana. Su principio fundamental es que **la discapacidad es únicamente física, no intelectual**, por lo que es un deber hacer trabajar la inteligencia y formarse. Bajo esta mentalidad de adaptación, aprendió de joven de manera indirecta inglés, francés e italiano para comunicarse respetuosamente con los médicos y religiosos extranjeros que lo rodeaban.
* **Puntos de Dolor y Frustración:**
    * **Pérdida de libertad de tránsito:** El confinamiento en la silla de ruedas en 2017 le afectó sentimental y emocionalmente ("el mundo se me cayó"), ya que siempre le había gustado explorar y pasear. Siente que depender de un tercero le ha cerrado el mundo.
    * **Sincronización metabólica forzada:** Ante la falta de cuidadores disponibles en ciertos momentos, Gerardo debe realizar una planificación bioquímica de su cuerpo. Controla rigurosamente su alimentación y restringe la toma de líquidos para sincronizar su metabolismo y aguantar sin ir al baño de 2 a 3 horas y media. Si prevé que no habrá nadie para ayudarle, se ve obligado a quedarse en cama y miccionar en un recipiente adaptado.
    * **Deficiencia en el sistema científico local:** Siente frustración ante el bajo desarrollo e inversión científica en el país para la atención de personas con discapacidad.

---

### **3. Tecnología, Dispositivos y Canales de Interacción**
* **Dispositivos en Uso:** Cuenta con una **computadora adaptada**, un **televisor adaptado** en su habitación y mantiene siempre su **teléfono celular** a su lado para llamar en caso de emergencias.
* **Comportamiento Tecnológico y Canales:**
    * **Consumo de contenidos:** Descarga películas mediante "páginas hacker" y las acomoda en su pantalla para no depender de que alguien lo lleve al cine.
    * **Uso de Inteligencia Artificial:** Utiliza activamente **ChatGPT** para resolver sus dudas técnicas sobre ensamblaje de computadoras, destacando la perfección de sus respuestas.
    * **Conocimientos de Programación:** Cuenta con experiencia previa en programación, habiendo trabajado en el control y modificación de señales de cámaras de seguridad. En el pasado (alrededor de 1989, bajo la alcaldía de Federico en San Martín de Porres), programó sistemas de control por voz orientados a la seguridad (con comandos de voz como "control rojo" y "control azul").
* **Interacción y Canales de Preferencia:**
    * **Preferencia por el control de voz:** Aboga fuertemente por que los dispositivos de asistencia funcionen mediante **comandos de voz** en lugar del movimiento físico o el uso de los dedos, considerándolo el método más inclusivo y adaptable para personas con movilidad nula en sus extremidades.
    * **Domótica rústica:** Abre las puertas y ventanas empujándolas mecánicamente con sus muletas. Aunque conoce el potencial de la domótica para encender luces mediante el celular, no lo ha implementado por limitaciones económicas y por haber creído inicialmente que él mismo debía diseñar y soldar todo el circuito, enterándose tarde de que ya existían soluciones comerciales.
* **Marcas e Influencias de Diseño:**
    * Gerardo tiene una gran influencia de la **tecnología alemana**, la cual considera de estándar superior. Admira la marca de tecnología de movilidad alemana **Albert Efix**, destacando que sus sillas de ruedas electrónicas están programadas con la calidad de un automóvil e incorporan lectores para medir con exactitud el nivel de batería.
    * En contraste, rechaza los productos de procedencia **china** por considerarlos "primitivos" y carentes de medidores de energía, lo que limita la verdadera independencia de traslado.
 </td>
    </tr>
</table>

<br>

<table>
    <tr>
        <th colspan="2" style="text-align:center;">Entrevista #2</th>
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
        <td>Persona con discapacidad motora severa (postrada)</td>
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
        <td><a href="">Enlace a la grabación</a></td>
    </tr>
    <tr>
        <td><strong>Timing donde inicia la entrevista</strong></td>
        <td>00:00 min</td>
    </tr>
    <tr>
        <td><strong>Duración de la entrevista</strong></td>
        <td>00:00 min</td>
    </tr>
    <tr>
        <td><strong>Resumen</strong></td>
        <td>
        Resumen de la entrevista
        </td>
    </tr>
</table>

<br>

<table>
    <tr>
        <th colspan="2" style="text-align:center;">Entrevista #3</th>
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
        <td>Persona con discapacidad motora severa (postrada)</td>
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
        <td><a href="">Enlace a la grabación</a></td>
    </tr>
    <tr>
        <td><strong>Timing donde inicia la entrevista</strong></td>
        <td>00:00 min</td>
    </tr>
    <tr>
        <td><strong>Duración de la entrevista</strong></td>
        <td>00:00 min</td>
    </tr>
    <tr>
        <td><strong>Resumen</strong></td>
        <td>
        Resumen de la entrevista
        </td>
    </tr>
</table>

**Segmento 2: Nombre del segmento 2**

<table>
    <tr>
        <th colspan="2" style="text-align:center;">Entrevista #1</th>
    </tr>
    <tr>
        <td><strong>Nombre</strong></td>
        <td>Manuel Alejandroo</td>
    </tr>
    <tr>
        <td><strong>Apellidos</strong></td>
        <td>Molina Vázquez</td>
    </tr>
    <tr>
        <td><strong>Edad</strong></td>
        <td>23 años</td>
    </tr>
    <tr>
        <td><strong>Rol</strong></td>
        <td>Familiar o cuidador de persona con discapacidad</td>
    </tr>
    <tr>
        <td><strong>Evidencia</strong></td>
        <td>
        <div align="center">
            <img 
                src="https://imgur.com/lZd0SaE.png" 
                style="width:100%; max-width:720px; height:500px; object-fit:cover; object-position:center; display:block; margin:0 auto;"
                alt="Imagen de la entrevista">
        </div>
        </td>
    </tr>
    <tr>
        <td><strong>Link</strong></td>
        <td><a href="">Enlace a la grabación</a></td>
    </tr>
    <tr>
        <td><strong>Timing donde inicia la entrevista</strong></td>
        <td>00:00 min</td>
    </tr>
    <tr>
        <td><strong>Duración de la entrevista</strong></td>
        <td>00:00 min</td>
    </tr>
    <tr>
        <td><strong>Resumen</strong></td>
        <td>

### **Comportamiento, Desgaste y Dolores**
* **Desgaste Físico Extremo:** Manuel experimenta un **desgaste físico en todas las actividades diarias** debido a la necesidad constante de cargarlo, movilizarlo y empujar su **silla de ruedas**.
* **Preocupación por la Desatención:** Uno de sus mayores temores y puntos de dolor es que, en su ausencia, su tío tenga necesidades fisiológicas y **no haya nadie cerca para asistirle o darle de comer**.
* **Personalidad y Actitud:** Se muestra como un joven **responsable, protector y cauteloso**. Valora enormemente la integridad de su familiar, declarando firmemente que **no confiaría el cuidado de su tío a "cualquier cosa o a cualquier persona"**, exigiendo un nivel de seguridad absoluto en cualquier alternativa de soporte.

---

### **Tecnología, Dispositivos y Canales de Interacción**
* **Dispositivos y Canales Actuales:** Manuel utiliza un **teléfono inteligente (smartphone)** como herramienta principal de comunicación. El único canal tecnológico de interacción mencionado en la entrevista es **WhatsApp**, el cual es el medio por el que su tío suele enviarle **mensajes de audio**.
* **Uso del Celular en Exteriores:** Manuel **siempre lleva consigo el celular cuando sale a la calle**, lo que consolida al smartphone como su canal de interacción omnipresente en el día a día.
* **Limitaciones Tecnológicas Detectadas:** La comunicación actual mediante WhatsApp es ineficaz cuando Manuel está fuera de casa, ya que a menudo **no se percata de las llamadas o de las notificaciones de urgencia**.
* **Hábitos e Influencia del Entorno:** Al ser un estudiante que asiste activamente a la **universidad** o transita por la **calle**, el ruido ambiental o las normas de las aulas le impiden escuchar los audios que le envía su tío.
---

### **Expectativas y Requerimientos para el Sistema de Asistencia**
* **Disposición al Cambio:** Manuel muestra una **excelente disposición** a adoptar un sistema automatizado. Califica como **"demasiado factible" y "práctico"** delegar tareas a un sistema tecnológico, ya que esto le liberaría tiempo para concentrarse en sus responsabilidades personales y académicas una vez cumplidos los deberes críticos de la mañana.
* **Requisitos del Sistema para el Arquetipo:**
    1. **Monitoreo en tiempo real:** Es sumamente importante para él saber qué le pasa a su tío en todo momento.
    2. **Notificaciones de Texto Tipo Pop-Up:** El sistema debe notificar los incidentes o necesidades en **tiempo real utilizando texto escrito en pantalla en lugar de audio**, facilitando una lectura rápida, discreta y eficiente mientras él se encuentra en clases o en la vía pública.

       </td>
    </tr>
</table>

<br>

<table>
    <tr>
        <th colspan="2" style="text-align:center;">Entrevista #2</th>
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
        <td>Familiar o cuidador de persona con discapacidad</td>
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
        <td><a href="">Enlace a la grabación</a></td>
    </tr>
    <tr>
        <td><strong>Timing donde inicia la entrevista</strong></td>
        <td>00:00 min</td>
    </tr>
    <tr>
        <td><strong>Duración de la entrevista</strong></td>
        <td>00:00 min</td>
    </tr>
    <tr>
        <td><strong>Resumen</strong></td>
        <td>
        Resumen de la entrevista
        </td>
    </tr>
</table>

<br>

<table>
    <tr>
        <th colspan="2" style="text-align:center;">Entrevista #3</th>
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
        <td>Familiar o cuidador de persona con discapacidad</td>
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
        <td><a href="">Enlace a la grabación</a></td>
    </tr>
    <tr>
        <td><strong>Timing donde inicia la entrevista</strong></td>
        <td>00:00 min</td>
    </tr>
    <tr>
        <td><strong>Duración de la entrevista</strong></td>
        <td>00:00 min</td>
    </tr>
    <tr>
        <td><strong>Resumen</strong></td>
        <td>
        Resumen de la entrevista
        </td>
    </tr>
</table>

### 2.2.3. Análisis de entrevistas

## 2.3. Needfinding

### 2.3.1. User Persona

### 2.3.2. User Task Matrix

### 2.3.3. User Journey Mapping

### 2.3.4. Empathy Mapping

### 2.3.5. As-Is Scenario Mapping

## 2.4. Big Picture Eventstorming

## 2.5. Ubiquitous Language

<table>
    <tr>
        <th> Término </th>
        <th> Definición </th>
    </tr>
    <tr>
        <td> Version </td>
        <td> 02/04/26 </td>
    </tr>
</table>

<div style="page-break-after: always;"></div>
