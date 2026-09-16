# Capítulo 3: Requirements Specification

## 3.1. To-Be Scenario Mapping

El To-Be Scenario Map representa cómo cambiaría el día a día del usuario una vez que cuenta con Aliva. Se construye a partir del As-Is Scenario Map y sirve para identificar, fase por fase, qué cambia realmente con la solución propuesta.

Para armarlo, el equipo siguió un proceso en Miro. Primero se revisó el As-Is de cada segmento para tener frescos los puntos de dolor y las fases ya definidas. Luego cada integrante propuso, por su cuenta, posibles mejoras frente a cada pain point identificado. Después se hizo una revisión en grupo para descartar ideas que no aportaban y quedarnos con las más relevantes. Con eso ya definido, se armaron las columnas replicando la estructura del As-Is, pero adaptando el contenido de cada etapa al nuevo flujo con el sistema ya integrado. Las fases también se renombraron, dejando de describir el problema para reflejar la nueva experiencia del usuario. Por último, se comparó el resultado con el As-Is para dejar en claro qué cambia en cada fase, tanto en lo que la persona hace (Doing) como en lo que piensa (Thinking) y siente (Feeling).

**User Persona 1: Persona con discapacidad motora severa**

![To-Be Scenario Mapping - Persona con discapacidad motora severa](https://imgur.com/nrxVkf1.png)

Comparando ambos mapas se nota una mejora clara en la capacidad de la persona para controlar su entorno sin depender de que alguien más esté disponible. Cosas que antes implicaban esperar, alzar la voz o interrumpir al cuidador por algo tan simple como encender una luz o abrir la puerta, ahora se resuelven solo con un comando de voz. Esto no solo reduce las interrupciones hacia el cuidador, también cambia cómo se siente la persona: la culpa, la vergüenza y la impotencia del As-Is dan paso a una sensación mucho más fuerte de control, seguridad y autonomía sobre su propio espacio.

**User Persona 2: Familiar o cuidador de persona con discapacidad**

![To-Be Scenario Mapping - Familiar o cuidador](https://imgur.com/yQ1yJ56.png)

Comparando ambos mapas se nota una reducción importante en la carga mental y física del cuidador durante el día. Las interrupciones constantes por pedidos simples, que antes generaban agotamiento y frustración, bajan considerablemente al delegarlas al sistema. La ansiedad y la hipervigilancia que sentía al salir de casa también se reducen, gracias a poder monitorear en tiempo real cómo está su familiar, lo que le permite ocuparse de sus propias responsabilidades sin dejar de estar pendiente de su bienestar.

## 3.2. User Stories

<table>
    <tr>
        <th> Epic / User Story ID </th>
        <th> Título </th>
        <th> Descripción </th>
        <th> Criterios de Aceptación </th>
        <th> Relacionado con </th>
    </tr>
    <tr>
        <td> EP001 </td>
        <td> Si Va a Salir </td>
        <td> Si Va a Salir </td>
        <td> Si Va a Salir </td>
        <td> Si Va a Salir </td>
    </tr>
</table>

## 3.3. Impact Mapping

Para esta parte se desarrolló un Mapa de Impacto para Alivia en UXPressia teniendo en cuenta las cartas de la Persona del Usuario ya diseñadas para las dos personas, Sebastián Sánchez y Mariano Díaz. Se formularon dos Business Goals medibles aplicando el enfoque SMART: (1) Hacer posible que 500 personas con trastornos motores significativos puedan administrar de forma independiente la iluminación, las puertas y las ventanas de sus hogares usando Alivia dentro de los 12 meses desde el lanzamiento del producto y (2) Reducir en un 65% la necesidad de las intervenciones diarias de los cuidadores en las tareas del hogar durante los primeros seis meses de uso.

Para cada uno de estos Business Goals se especifica la lista de los Actors que van a contribuir a su realización (Sebastián y Mariano) y los Impacts o cambios de comportamiento esperados. Para Sebastián el Impact será que él adopte los comandos de voz como la herramienta principal para administrar los dispositivos del hogar y pueda manejar algunos problemas por sí mismo sin ayuda, contactando a su cuidador solo cuando sea necesario. Para Mariano el Impact será que él configure correctamente el perfil y la red de cuidado antes de dejar que Sebastián empiece a trabajar con el sistema por sí mismo, confirme el funcionamiento de la instalación y preste atención solo a las solicitudes más importantes evitando repeticiones.

Basándose en estos Impacts se pueden especificar los Deliverables, es decir el conjunto de cosas que el negocio puede construir para alcanzar este objetivo: comandos de voz con retroalimentación para luces, puertas y ventanas; procesamiento de datos local que permita el control activo de los dispositivos sin conexión a Internet; flujos de registro de usuario para el perfil y la red de cuidado; el procedimiento de instalación y de prueba de los dispositivos; notificaciones priorizadas y un panel de supervisión remota con el historial de eventos. Cada Deliverable se descompuso en User Stories con el formato "As a... I want... so that...".

![Impact Mapping de Alivia en UXPressia](https://imgur.com/xLq1mUr.png)

En esta captura se observa cómo, a partir de este primer Business Goal, el árbol crece de la misma forma en los dos actores del proyecto. Para Sebastián, los Impacts son adoptar el comando de voz como su principal forma de controlar la iluminación del hogar, y usar la voz para abrir o cerrar puertas y ventanas sin necesitar ayuda física; de esto se desprenden los Deliverables de reconocimiento de voz para luces, puertas y ventanas, junto con el módulo de procesamiento local. En el caso de Mariano, los Impacts son configurar el perfil de su familiar y la red de cuidado antes de que Sebastián use el sistema solo, y confirmar que los dispositivos estén bien instalados antes de dejarlo actuar de forma autónoma; estos llevan a los Deliverables de registro de perfil, registro de la red de cuidado, y el proceso de instalación y activación del servicio. Al igual que con el otro Business Goal, esta estructura muestra que cada funcionalidad del Backlog está directamente conectada con un cambio de comportamiento esperado en Sebastián o en Mariano.

![Impact Mapping de Alivia en UXPressia](https://imgur.com/au5sXlO.png)

En esta captura se observa cómo, a partir de este segundo Business Goal, el árbol se despliega en los dos actores del proyecto: Sebastián y Mariano. En el caso de Sebastián aparecen dos Impacts: resolver por su cuenta solicitudes que antes requerían la intervención de su cuidador, y pedir auxilio de forma inmediata solo cuando realmente hay una situación urgente. De ahí salen los Deliverables enfocados en la ejecución inmediata de comandos de voz y en la función de solicitud de auxilio, cada uno con sus User Stories. Para Mariano, los Impacts son dejar de recibir solicitudes básicas repetitivas y ser notificado solo cuando algo relevante ocurre, además de poder consultar el estado de su familiar sin tener que estar presente físicamente; esto se traduce en el sistema de alertas priorizadas y el panel de supervisión remota. Con esta estructura queda claro que ninguna funcionalidad del Backlog está aislada, sino que cada una responde a un comportamiento concreto que buscamos generar en Sebastián o Mariano dentro de este objetivo.

## 3.4. Product Backlog

<table>
    <tr>
        <th> # Orden </th>
        <th> User Story ID </th>
        <th> Título </th>
        <th> Descripción </th>
        <th> Story Points </th>
    </tr>
    <tr>
        <td> 1 </td>
        <td> Si Va a Salir </td>
        <td> Si Va a Salir </td>
        <td> Si Va a Salir </td>
        <td> Si Va a Salir </td>
    </tr>
</table>

<div style="page-break-after: always;"></div>
