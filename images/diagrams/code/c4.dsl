workspace "Alivia" "Diagrama C4 del Sistema Alivia" {

 !identifiers hierarchical

 model {

  // ---------- Personas ----------
  visit = person "Visitante" "Interesado en la plataforma"
  disabled = person "Persona con discapacidad" "Persona con discapacidad motora"
  bussinessOwner = person "Administrador del negocio" "Gestiona todos los dispositivos, personal, suscripciones, etc."
  tec = person "Técnico de la empresa" "Personal encargado de la instalación de los dispositivos en la casa y de verificar que la casa cumple con los requisitos para la instalación"
  family = person "Familiar o cuidador" "Persona encargada del cuidado de la persona con discapacidad"

  // ---------- Sistema Alivia ----------
  ss = softwareSystem "Sistema Alivia" {

   landing = container "Landing Page" "Sitio web estático para mostrar la información de nuestro sistema" "Astro,typescript" "LandingPage"

   frontendPersonal = container "Pagina web para la empresa" "Página para el personal de la empresa y administrador" "Angular, TypeScript" "Web"

   frontendUsuarios = container "Pagina web para los usuarios" "Página web para los familiares o cuidadores" "React" "Web"

   api = container "alivia API" "API encargada de distribuir los endpoints a cada plataforma" "Java, Spring Boot" "backend"

   mongodb = container "MongoDB" "Base de datos NoSQL que almacena las peticiones enviadas por los devices hacia el backend" "Database" "Database"

postgress = container "PostgreSQL" "Base de datos relacional que almacena los datos del negocio: perfiles, devices, suscripciones, etc." "Database" "Database"

embebidoActuadores = container "Embebido de los actuadores" "Firmware que recibe la acción a ejecutar desde el edge y controla el hardware físico (abrir la puerta, encender la luz, etc.)" "C++"

   mobile = container "Nativo para Android y Ios" "Aplicación nativa para smartphone y iPhone" "Nativo iOS y Android" "Mobile"

nginx = container "nginx" "Balanceador de carga que distribuye las peticiones entrantes hacia la API" "balanceador"

  group "Fog Layer (Infraestructura Local / LAN)" {

       edgeActuadores = container "edge para el Actuador" "Procesa la información que le llega por medio del broker por el otro edge para ejecutar una acción como abrir la puerta,prender la luz,etc." "Python, Flask" "Edge"

       broker = container "message broker" "Recibe los comandos del edge de los dispositivos y los reenvía al edge del actuador para procesarlos sin conexión a internet" "Broker" "Broker"

       edgeMicrophone = container "Edge microphone" "Transcribe con el modelo de IA el sonido que capturo el sensor para mandarle por medio del broker al otro edge" "Python, Flask" "Edge"

   sqliteEdgeMicrophone = container "sqlite edge devices" "Almacenamiento de los devices permitidos para hacer el envío de datos" "Database" "Database"

   sqliteEdgeActuador = container "sqlite edge actuador" "Almacenamiento de las acciones realizadas y quiénes pueden realizarlas" "Database" "Database"

  }

webServer = container "Web Server" "Servidor web que entrega los recursos estáticos y las dependencias de la aplicación web de usuarios" "WebApplication" "WebApplication"

sqlite = container "SQLite" "Base de datos local para las aplicaciones móviles de Android e iOS" "Database" "Database"
embebidoMicrophone = container "Embebido del micrófono IoT" "Firmware que captura el audio desde el hardware del micrófono y lo envía al edge correspondiente" "C++"

   webServerEmpresa = container "Web Server de la plataforma de la empresa" "Carga dependencias y bibliotecas de la pagina de la empresa" "WebApplication" "WebApplication"


   // ---------- Edge / API ----------
   edgeActuadores -> sqliteEdgeActuador "Guarda acciones y permisos" "SQLite"
   edgeMicrophone -> sqliteEdgeMicrophone "Consulta los devices permitidos" "SQLite"

   // ---------- embebidos / edges ----------
   embebidoMicrophone -> edgeMicrophone "Envía el audio capturado por el micrófono"
edgeActuadores -> embebidoActuadores "Envía la acción a ejecutar al hardware del actuador"
   // ---------- Fog Layer: broker / edges ----------
   edgeMicrophone -> broker "Envía los comandos recibidos del microfono"
   broker -> edgeActuadores "Reenvía el comando para que el actuador lo procese sin conexión a internet"

   // ---------- Edge actuador / API ----------
   edgeActuadores -> api "Envía la acción realizada y su estado (correcta, con error, fallando,etc.)"
   edgeMicrophone -> api "Envía estado del devices(baja batería,cargado,fallando)"
   // ---------- API / datos / IA ----------
   api -> mongodb "Guarda las peticiones enviadas por los devices"
   api -> postgress "Lee y guarda los datos del negocio" "SQL"

   // ---------- Clientes / gateway ----------
   mobile -> nginx "Consume los endpoints" "HTTPS/JSON"
   nginx -> api "Redirige las peticiones" "HTTP"
   frontendPersonal -> nginx "Envía las peticiones" "HTTPS"
   frontendUsuarios -> nginx "Envía las peticiones" "HTTPS"

   landing -> webServer "Solicita los recursos estáticos" "HTTPS"
   webServer -> frontendUsuarios "Entrega la aplicación web" "HTTPS"
  webServerEmpresa -> frontendPersonal "Entrega la aplicación web para el personal" "HTTPS"

   // ---------- api/edges-------------------
    api -> edgeActuadores "Envía la tabla de actuadores y la tabla de edges autorizados para validar desde qué origen se pueden aceptar las peticiones"
    api -> edgeMicrophone "Envía la tabla de sensores y la tabla de edges autorizados para validar qué embebido puede enviar peticiones y a qué edge se le pueden reenviar los comandos"

   // ---------- Personas ----------
   visit -> landing "Conoce la plataforma"
   visit -> family "Se convierte en"
   family -> landing "Consulta los planes e información"
   family -> mobile "Monitorea los dispositivos desde el celular"
   tec -> webServerEmpresa "Gestiona las visitas de instalación"
   tec -> mobile "Registra la instalación de los dispositivos"
   bussinessOwner -> webServerEmpresa "Administra dispositivos, personal y suscripciones"

  }

  // ---------- Sistemas externos ----------
  firebase = softwareSystem "Firebase" "Encargado de las notificaciones push" "External"
  cloudinary = softwareSystem "Cloudinary" "Almacenamiento de fotos o videos" "External"
  microphoneDevice = softwareSystem "Microphone device" "Dispositivo IoT encargado de la recepción de sonido" "External"
  googleMaps = softwareSystem "Google maps" "servicio para saber la ubicación de la casa" "External"
  hardwareActuadores = softwareSystem "Hardware de los Actuadores" "Hardware para el manejo de los actuadores"
  stripe = softwareSystem "Stripe" "Pasarela de pago de las suscripciones" "External"
  sendgrid = softwareSystem "Sendgrid" "Servicio para envío de correos" "External"

  // ---------- Relaciones con sistemas externos ----------
  ss.api -> firebase "Envía notificaciones push (batería baja o dispositivo con falla)" "HTTPS"
  ss.api -> stripe "Procesa los pagos de las suscripciones" "HTTPS"
  ss.api -> cloudinary "Sube y consulta fotos o videos" "HTTPS"
  ss.api -> sendgrid "Envía correos de confirmación y verificación" "HTTPS"
  ss.api -> googleMaps ""

  ss.mobile -> ss.sqlite "Guarda datos locales" "SQLite"
  ss.embebidoActuadores -> hardwareActuadores "Controla el hardware"
  ss.embebidoMicrophone -> microphoneDevice "Recibe el audio del micrófono"
  disabled -> microphoneDevice "Da comandos de voz"

 }

 views {

  systemContext ss "Diagram1" {
   include *
   autoLayout lr
  }

  container ss "Diagram2" {
   include *
   autoLayout lr
  }

  styles {

   element "Element" {
    color #d9232b
    stroke #d9232b
    strokeWidth 7
    shape roundedbox
   }

   element "Person" {
    shape person
   }

   element "Database" {
    shape cylinder
    background #87ceeb
    color #000000
    stroke #4aa8d8
   }

   element "External" {
    background #6b7280
    color #ffffff
    stroke #6b7280
   }

   element "LandingPage" {
    shape Folder
    background #6d28d9
    color #ffffff
    stroke #4c1d95
   }

   element "Web" {
    shape webBrowser
    background #0f766e
    color #ffffff
    stroke #134e4a
   }

   element "WebApplication" {
    shape RoundedBox
    background #f8fafc
    color #334155
    stroke #334155
   }

   element "Group:Fog Layer (Infraestructura Local / LAN)" {
    color #ea580c
    stroke #ea580c
    strokeWidth 6
    background #fff7ed
    }
   element "backend" {
    shape RoundedBox
    background #fefce8
    color #334155
    stroke #334155
   }
   element "Mobile" {
    shape MobileDeviceLandscape
    background #fefce8
    color #92400e
    stroke #92400e
   }

   element "Broker" {
    shape Pipe
    background #ea580c
    color #ffffff
    stroke #9a3412
   }

   element "WebSocket" {
    shape RoundedBox
    background #db2777
    color #ffffff
    stroke #9d174d
   }

   element "Edge" {
    shape Hexagon
    background #db2777
    color #ffffff
    stroke #9d174d
   }
   element "AI" {
    shape Hexagon
    background "#f0fdf4"
    color "#0f766e"
    stroke "#0f766e"
   }

   element "Hardware" {
    background #666666
    color #ffffff
   }

   element "Boundary" {
    strokeWidth 5
   }

   relationship "Relationship" {
    thickness 4
   }
  }
 }

 configuration {
  scope softwaresystem
 }

}