# Capítulo 6: Solution UX Design

## 6.1. Style Guidelines

### 6.1.1. General Style Guidelines

**Colors**

**Typography**

**Spacing**

**Icons**

**Branding**

**Communication Tone & Language**

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