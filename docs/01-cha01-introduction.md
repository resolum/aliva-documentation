# Capítulo 1: Introducción

## 1.1. Startup Profile

### 1.1.1. Descripción de la Startup

<table>
    <tr>
        <th> Elemento </th>
        <th> Descripción </th>
    </tr>
    <tr>
        <td> Misión </td>
        <td> 02/04/26 </td>
    </tr>
    <tr>
        <td> Visión </td>
        <td> 02/04/26 </td>
    </tr>
</table>


### 1.1.2. Perfiles de Integrantes del equipo

<table>
    <tr>
        <th> Integrante </th>
        <th> Imagen del integrante </th>
        <th> Descripción y conocimientos </th>
    </tr>
    <tr>
        <td> Calvo Yalan, Renato Guillermo (u202217053) </td>
        <td> 02/04/26 </td>
        <td> 02/04/26 </td>
    </tr>
    <tr>
        <td> Coronel Espinoza, Farid Sebastian (u202312508) </td>
        <td> 02/04/26 </td>
        <td> 02/04/26 </td>
    </tr>
    <tr>
        <td> Diaz Quispe, Matias Sebastian (u202311938) </td>
        <td> 02/04/26 </td>
        <td> 02/04/26 </td>
    </tr>
    <tr>
        <td> Juarez Leon, Nicolas Emilio Walter (u202317483) </td>
        <td> 02/04/26 </td>
        <td> 02/04/26 </td>
    </tr>
    <tr>
        <td> Rios Piñan, Dayro Richard (u202315283) </td>
        <td> 02/04/26 </td>
        <td> 02/04/26 </td>
    </tr>
</table>

## 1.2. Solution Profile

### 1.2.1. Antecedentes y problemática

**What (¿Qué ocurre?)**

La problemática que se presenta es la dependencia de terceros que tienen las personas con discapacidad para realizar actividades básicas del hogar, al no contar con los medios para ejecutarlas de forma autónoma. En Perú, más de 3.2 millones de personas presentan alguna discapacidad permanente (INEI, Censo 2017).

**When (¿Cuándo y con qué frecuencia?)**

El problema ocurre de forma diaria y constante, ya que cada vez que la persona con discapacidad necesita realizar una actividad básica del hogar, depende de la disponibilidad de un tercero para poder efectuarla.

**Where (¿Dónde sucede?)**

El problema surge en el interior de la casa de la persona con discapacidad, con mayor frecuencia en espacios cotidianos como el dormitorio .

**Who (¿Quiénes se ven afectados?)**

Los principales afectados son las personas con discapacidad, que al no contar con los medios para realizar actividades básicas del hogar de forma autónoma, dependen de terceros para ejecutarlas. Esta dependencia también impacta a los familiares que asumen el rol de cuidadores de forma no remunerada, quienes deben reorganizar su tiempo y disponibilidad para poder asistirlos. En los casos donde se contrata a un cuidador profesional, la dependencia se traduce en un costo económico sostenido para la familia.

**Why (¿Por qué es un problema?)**

Es un problema debido a que la dependencia constante de terceros para realizar las actividades diarias dentro del hogar hace que las personas con discapacidad se sientan frustradas y limitadas en su autonomía, afectando tanto su bienestar emocional como su calidad de vida. Según la Organización Mundial de la Salud, la esencia misma de la dependencia radica precisamente en no poder vivir de forma autónoma y necesitar de manera sostenida la ayuda de otros para las actividades cotidianas, lo que confirma que la autonomía es un componente central del bienestar de esta población.


**How (¿Cómo se manifiesta?)**

El problema se manifiesta a través de la necesidad constante de solicitar ayuda para tareas simples ( abrir una puerta, prender la luz) y la interrupción de las actividades de la persona que lo esta cuidando cada vez que se requiere asistencia.

**How Much (¿Cuál es el impacto cuantitativo?)**

A nivel nacional, más de 3,2 millones de personas presentan alguna discapacidad permanente (INEI, Censo 2017), de las cuales la dificultad para ver (48,3%) y para moverse o caminar (15,1%) son las más prevalentes entre quienes tienen una sola discapacidad, sumando en conjunto más del 63% de este grupo. Asimismo, el 65,7% de la población con discapacidad no usa Internet (INEI, 2022), lo que evidencia una brecha significativa en el acceso a soluciones tecnológicas de apoyo.

### 1.2.2. Lean UX Process

#### 1.2.2.1. Lean UX Problem Statement

#### 1.2.2.2. Lean UX Assumptions

**Business Assumptions**

- El usuario discapacitado necesita realizar acciones cotidianas como encender interruptores, abrir puertas, etc. de forma autónoma sin requerir la presencia del familiar responsable o cuidador asignado.
- La solución a este problema será dada mediante un entorno de Internet de las Cosas e Inteligencia Artificial que recibirá comandos por parte del usuario discapacitado ya sea por voz o por movimientos residuales del cuerpo para realizar las acciones cotidianas.
- Nuestros clientes iniciales son personas con discapacidad motora o visual y sus cuidadores (o familiares responsables) que buscan sentirse con mayor autonomía y reducir la carga de asistencia rutinaria para orientar ese tiempo en labores que requieran mayor atención, respectivamente.
- El principal valor que nuestros clientes buscan de la solución es poder realizar actividades básicas en el hogar de forma autónoma mediante tecnologías de asistencia.
- Además, nuestros clientes pueden obtener otros beneficios como reducción del tiempo promedio en realizar actividades básicas y sentir una mayor seguridad en las actividades que se realizan.
- Creemos que obtendremos nuestra base de clientes mediante recomendaciones de usuarios que utilicen la solución, relaciones comerciales con casas de reposo y asociaciones dado la Hoja de Ruta de Tecnología de Apoyo 2024–2030 mediante el CONADIS.
- Generaremos ingresos ofreciendo un modelo de venta de licencias y mediante la venta de hardware con los dispositivos IoT.
- Nuestra competencia principal en el mercado se centra en los dispositivos Smart Home tradicionales como Alexa o Google Home.
- Nuestro mayor riesgo se centra en el mal desarrollo del sistema ya que puede que el sistema interprete incorrectamente un comando o no ejecute una acción crítica, provocando que la persona pierda confianza en la solución y vuelva a depender del familiar o cuidador.
- **¿Cuáles son las suposiciones que, si se demuestran falsas, harán que el proyecto fracase?**
    - Las personas con discapacidad motora pueden realizar movimientos residuales suficientemente consistentes para que el sistema pueda diferenciarlos y asociarlos con acciones específicas.
    - La Inteligencia Artificial puede interpretar los gestos o comandos de voz con suficiente precisión para evitar acciones incorrectas.
    - El sistema puede ejecutar las acciones solicitadas de manera suficientemente confiable mediante los dispositivos IoT.
    - Los usuarios perciben valor en poder controlar elementos básicos del hogar de forma autónoma y están dispuestos a incorporar el sistema en su vida cotidiana.

**Business Outcomes**

- Incrementar en 70% la proporción de actividades básicas del hogar que pueda realizar el usuario discapacitado sin requerir asistencia de terceros.
- Reducir en un 65% el número de intervenciones de familiares o cuidadores requeridas para que el usuario realice actividades básicas del hogar.
- Reducir en 60% el tiempo promedio requerido para que el usuario pueda completar una actividad básica del hogar.
- Alcanzar una tasa de 95% de ejecución exitosa de las funciones críticas del sistema ante escenarios sin conexión a Internet.
- Incrementar en 60% el nivel de autonomía percibida por los usuarios después de utilizar el sistema para realizar actividades básicas del hogar.
- Reducir en 75% la cantidad de tareas rutinarias que familiares o cuidadores deben realizar directamente en representación del usuario.

**User Assumptions**

- **¿Quién es el usuario?** Personas con discapacidad visual y motora que buscan elevar su nivel de autonomía frente a actividades básicas como encender luces y abrir puertas de los distintos ambientes del hogar, y los cuidadores o familiares responsables que se encargan de velar por el cuidado y la seguridad de las personas con discapacidad.
- **¿Dónde encajaría nuestro producto en la vida (o trabajo) del usuario?**
    - Para las personas con discapacidad: encajaría en su vida cotidiana, pues, mediante el sistema el usuario puede realizar actividades básicas de su día a día con comandos dados por sí mismo.
    - Para los cuidadores o familiares responsables: encajaría, también, en su día a día, pues, con el sistema, podrán configurarlo de acuerdo a las necesidades de las personas a cargo y saber las actividades que realizan.
- **¿Qué problemas resuelve el producto para el usuario**
    - Frustración percibida por la persona discapacitada ante la dificultad o imposibilidad de realizar actividades básicas en su hogar.
    - La dependencia frente a terceros (cuidadores o familiares) que depende de la disponibilidad de tiempo y presencia de los mismos.
    - Alta carga de asistencia rutinaria que puede resultar en labores o asistencia mal dada que perjudica a la persona discapacitada.
- **¿En qué contexto utiliza el usuario el producto?**
    - Las personas con discapacidad lo usan de forma constante y diaria para desarrollar actividades básicas en el hogar.
    - Sus cuidadores lo usan cuando necesitan cambiar algún parámetro para ajustar el ecosistema a la necesidad de la persona asignada y para saber qué están haciendo en tiempo real.
- **¿Cómo debería verse y comportarse el producto?**
    - El ecosistema IoT debe comportarse de forma efectiva en entornos con baja o nula conexión a internet. A su vez, debe reaccionar a los comandos de forma inmediata y confirmar los comandos con el usuario.
    - Por otro lado, las aplicaciones cliente deben describir claramente las configuraciones del sistema y de las acciones de las personas con discapacidad.

**User Outcomes & Benefits**

- La persona discapacitada realizará por sí misma acciones básicas del hogar que anteriormente requerían asistencia.
- La persona discapacitada podrá solicitar y ejecutar acciones del hogar sin tener que llamar o esperar a que un familiar o cuidador intervenga.
- La persona discapacitada podrá realizar acciones cotidianas de manera más rápida, sin tener que esperar la disponibilidad de un familiar o cuidador.
- La persona discapacitada podrá seguir realizando acciones básicas del hogar mediante el sistema incluso cuando no exista conexión a Internet, sintiendo mayor seguridad y confiabilidad en su uso.
- La persona discapacitada sentirá mayor independencia y control sobre su entorno al poder realizar por sí misma acciones que anteriormente dependían de otra persona.
- El familiar o cuidador podrá dedicar menos tiempo a realizar acciones rutinarias por la persona y concentrarse en actividades de asistencia que realmente requieran su intervención.

**Features Assumptions**

1. **Sistema de comandos por voz**

- **Suposición:** Permitir al usuario discapacitado delegar comandos mediante el uso de la voz le permitirá tomar mayor control de las actividades básicas del hogar que antes realizaba con dificultad o asistencia.
- **Riesgo:** Si el sistema no detecta con precisión la voz del usuario, ejecutará comandos que el usuario no requiera, lo que provocará que la solución pierda al usuario.

2. **Sistema de detección de gestos**

- **Suposición:** Permitir al usuario discapacitado delegar comandos usando gestos con el cuerpo le permitirá realizar actividades sin necesidad de asistencia reduciendo las intervenciones de sus cuidadores en actividades que se realicen mediante comandos.
- **Riesgo:** Si el sistema no se estructura correctamente para que detecte gestos, el usuario no sentirá que la solución le está brindando la respuesta que necesita a sus problemas.

3. **Persistencia de datos local y offline**

- **Suposición:** Habilitar la persistencia local en el borde de las decisiones y comandos dados usando el sistema permitirá la independencia del uso de conexión a red y una mayor velocidad de entrega gracias a no usar conexión a Wi-Fi.
- **Riesgo:** Si la arquitectura del sistema en el borde no se define correctamente tomando en cuenta la velocidad deseada y las restricciones definidas, el usuario perderá confianza por posibles retrasos de los comandos.

4. **Módulo de toma de decisiones**

- **Suposición:** El sistema analizará los comandos recibidos por el usuario para determinar cuál es la acción que está deseando e iniciar el flujo de activación de la actividad con los dispositivos requeridos.
- **Riesgo:** Si el sistema demora en determinar la actividad requerida, puede ocasionar apilamiento de acciones que puede confundir en gran medida al discapacitado.

5. **Configuración adaptativa del sistema**

- **Suposición:** Permitir al familiar o cuidador de la persona discapacitada configurar el sistema dependiendo de las necesidades del discapacitado le ayudará a sentirse con mayor capacidad y seguridad de realizar actividades básicas en su hogar sin asistencia de terceros.
- **Riesgo:** Si la solución no cuenta con configuración suficiente o instrucciones que guíen al familiar, este se sentirá abrumado y perderá confianza en la solución por su complejidad.

6. **Registro de acciones del familiar discapacitado**

- **Suposición:** El sistema proveerá automáticamente de un registro con las actividades que está realizando y ha concluido la persona discapacitada de forma que le comunica al familiar las acciones del discapacitado.
- **Riesgo:** La persona discapacitada podría percibir el registro de sus acciones como vigilancia o invasión de su privacidad, reduciendo su confianza y disposición a utilizar el sistema.

#### 1.2.2.3. Lean UX Hypothesis Statements

#### 1.2.2.4. Lean UX Canvas

## 1.3. Segmentos objetivos

<div style="page-break-after: always;"></div>
