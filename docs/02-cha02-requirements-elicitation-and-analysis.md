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
        <td>Automatización del hogar para discapacidad motora y visual, con voz y gestos.</td>
        <td>Modelo de casa domotizada adaptada a personas con discapacidad.</td>
        <td>Asistente de voz e integraciones smart home.</td>
        <td>Kits de domótica para movilidad reducida.</td>
        <td>Entorno inteligente adaptado a discapacidad.</td>
    </tr>
    <tr>
        <td>Ventaja competitiva</td>
        <td>Funciona sin Internet, con voz y gestos como doble canal de comando.</td>
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
        <td>Alianzas con casas de reposo y asociaciones, apoyo de CONADIS.</td>
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

## 2.2. Entrevistas

### 2.2.1. Diseño de entrevistas

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
