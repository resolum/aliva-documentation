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

### 2.2.3. Análisis de entrevistas

## 2.3. Needfinding

### 2.3.1. User Persona

### 2.3.2. User Task Matrix

### 2.3.3. User Journey Mapping

### 2.3.4. Empathy Mapping

### 2.3.5. As-Is Scenario Mapping

El As-Is Scenario Mapping es una herramienta que permite visualizar el estado actual de un proceso o experiencia desde la perspectiva del usuario. En este caso, se ha utilizado para mapear la experiencia de personas con discapacidad motora o visual en su interacción con el hogar y los dispositivos de domótica existentes y familiares o cuidadores que los asisten.

**Segmento Objetivo 1: Persona con discapacidad motora o visual**: El As-Is Scenario Mapping revela que estas personas enfrentan dificultades significativas al intentar que los cuidadores o familiares comprendan sus necesidades y preferencias en el hogar. La falta de comunicación efectiva y la dependencia de otros para realizar tareas básicas genera frustración y limita su autonomía.

![as-is scenario mapping](https://i.imgur.com/NXIfnxm.png)

**Segmento Objetivo 2: Familiar o cuidador de persona con discapacidad**: El As-Is Scenario Mapping muestra que los cuidadores y familiares a menudo carecen de información clara sobre cómo satisfacer las necesidades de las personas con discapacidad. Esto puede llevar a malentendidos, errores en la asistencia y una experiencia general insatisfactoria y frustrante para ambas partes.

![as-is scenario mapping](https://i.imgur.com/4vIXJwo.png)

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
