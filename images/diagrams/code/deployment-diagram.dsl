workspace "Alivia - Despliegue" "Diagrama de despliegue del Sistema Alivia" {

 !identifiers hierarchical

 model {

  ss = softwareSystem "Sistema Alivia" {

   landing = container "Landing Page" "Sitio web estático para mostrar la información de nuestro sistema" "Astro, TypeScript" "LandingPage"
   frontendPersonal = container "Pagina web para la empresa" "Página para el personal de la empresa y administrador" "Angular, TypeScript" "Web"
   frontendUsuarios = container "Pagina web para los usuarios" "Página web para los familiares o cuidadores" "React" "Web"
   api = container "alivia API" "API encargada de distribuir los endpoints a cada plataforma" "Java, Spring Boot" "backend"
   mongodb = container "MongoDB" "Base de datos NoSQL que almacena las peticiones enviadas por los devices hacia el backend" "Database" "Database"
   postgress = container "PostgreSQL" "Base de datos relacional que almacena los datos del negocio: perfiles, devices, suscripciones, etc." "Database" "Database"
   embebidoActuadores = container "Embebido de los actuadores" "Firmware que recibe la acción a ejecutar desde el edge y controla el hardware físico (abrir la puerta, encender la luz, etc.)" "C++"
   mobile = container "Nativo para Android y Ios" "Aplicación nativa para smartphone y iPhone" "Nativo iOS y Android" "Mobile"
   nginx = container "nginx" "Balanceador de carga que distribuye las peticiones entrantes hacia la API" "Nginx"
   edgeActuadores = container "edge para el Actuador" "Procesa la información que le llega por medio del broker por el otro edge para ejecutar una acción como abrir la puerta,prender la luz,etc." "Python, Flask" "Edge"
   broker = container "message broker" "Recibe los comandos del edge de los dispositivos y los reenvía al edge del actuador para procesarlos sin conexión a internet" "Broker" "Broker"
   edgeMicrophone = container "Edge microphone" "Transcribe con el modelo de IA el sonido que capturó el sensor para mandarlo por medio del broker al otro edge" "Python, Flask" "Edge"
   sqliteEdgeMicrophone = container "sqlite edge devices" "Almacenamiento de los devices permitidos para hacer el envío de datos" "Database" "Database"
   sqliteEdgeActuador = container "sqlite edge actuador" "Almacenamiento de las acciones realizadas y quiénes pueden realizarlas" "Database" "Database"
   webServer = container "Web Server" "Servidor web que entrega los recursos estáticos y las dependencias de la aplicación web de usuarios" "WebApplication" "WebApplication"
   sqlite = container "SQLite" "Base de datos local para las aplicaciones móviles de Android e iOS" "Database" "Database"
   embebidoMicrophone = container "Embebido del micrófono IoT" "Firmware que captura el audio desde el hardware del micrófono y lo envía al edge correspondiente" "C++"
   webServerEmpresa = container "Web Server de la plataforma de la empresa" "Carga dependencias y bibliotecas de la página de la empresa" "WebApplication" "WebApplication"

   edgeActuadores -> sqliteEdgeActuador "Guarda acciones y permisos" "SQLite"
   edgeMicrophone -> sqliteEdgeMicrophone "Consulta los devices permitidos" "SQLite"
   embebidoMicrophone -> edgeMicrophone "Envía el audio capturado por el micrófono"
   edgeActuadores -> embebidoActuadores "Envía la acción a ejecutar al hardware del actuador"
   edgeMicrophone -> broker "Envía los comandos recibidos del microfono"
   broker -> edgeActuadores "Reenvía el comando para que el actuador lo procese sin conexión a internet"
   edgeActuadores -> api "Envía la acción realizada y su estado (correcta, con error, fallando, etc.)"
   edgeMicrophone -> api "Envía el estado de los devices (batería baja, cargado, fallando)"
   api -> mongodb "Guarda las peticiones enviadas por los devices"
   api -> postgress "Lee y guarda los datos del negocio" "SQL"
   mobile -> nginx "Consume los endpoints" "HTTPS/JSON"
   nginx -> api "Redirige las peticiones" "HTTP"
   frontendPersonal -> nginx "Envía las peticiones" "HTTPS"
   frontendUsuarios -> nginx "Envía las peticiones" "HTTPS"
   landing -> webServer "Solicita los recursos estáticos" "HTTPS"
   webServer -> frontendUsuarios "Entrega la aplicación web" "HTTPS"
   webServerEmpresa -> frontendPersonal "Entrega la aplicación web para el personal" "HTTPS"
   mobile -> sqlite "Guarda datos locales" "SQLite"
  }

  deploymentEnvironment "Production" {

   deploymentNode "Alivia Production Infrastructure" "" "Multi-Cloud y On-Premises" {
    tags "Wrapper"

    deploymentNode "Cloudflare" "" "CDN / Edge Network" {
     tags "Cloudflare"
     deploymentNode "Cloudflare Pages - Landing" "" "Static Hosting" {
      containerInstance ss.landing
     }
     deploymentNode "Cloudflare Pages - Web Usuarios" "" "Static Hosting" {
      containerInstance ss.webServer
     }
     deploymentNode "Cloudflare Pages - Web Empresa" "" "Static Hosting" {
      containerInstance ss.webServerEmpresa
     }
    }

    deploymentNode "Oracle Cloud" "" "Cloud Provider" {
     tags "Oracle"
     deploymentNode "Oracle Cloud Infrastructure - Compute" "" "PaaS - Auto-scaling Compute" {
      deploymentNode "API Instance" "" "Oracle OCI Compute" {
       containerInstance ss.api
      }
      deploymentNode "Nginx Instance" "" "Oracle OCI Compute" {
       containerInstance ss.nginx
      }
     }
     deploymentNode "Oracle Autonomous Database" "" "Managed Relational Database" {
      containerInstance ss.postgress
     }
    }

    deploymentNode "MongoDB Atlas" "" "Managed NoSQL Cloud Service" {
     tags "MongoDBAtlas"
     containerInstance ss.mongodb
    }

    deploymentNode "Hogar del usuario" "" "Infraestructura Local (LAN)" {
     tags "OnPremises"
     deploymentNode "Computadora Local (Fog Layer)" "" "Despliegue local en la misma computadora" {
      deploymentNode "Edge Server - Actuador" "" "Proceso local" {
       containerInstance ss.edgeActuadores
       containerInstance ss.sqliteEdgeActuador
      }
      deploymentNode "Edge Server - Micrófono" "" "Proceso local" {
       containerInstance ss.edgeMicrophone
       containerInstance ss.sqliteEdgeMicrophone
      }
      deploymentNode "Broker Server" "" "Proceso local" {
       containerInstance ss.broker
      }
     }
     deploymentNode "Microphone IoT Device" "" "Embedded Hardware" {
      containerInstance ss.embebidoMicrophone
     }
     deploymentNode "Actuator Hardware Device" "" "Embedded Hardware" {
      containerInstance ss.embebidoActuadores
     }
    }

    deploymentNode "User Device" "" "Smartphone (iOS / Android)" {
     tags "UserDevice"
     deploymentNode "Mobile OS" "" "iOS / Android Runtime" {
      containerInstance ss.mobile
      containerInstance ss.sqlite
     }
     deploymentNode "Web Browser" "" "Chrome, Firefox, Safari, Edge" {
      containerInstance ss.frontendUsuarios
      containerInstance ss.frontendPersonal
     }
    }

   }
  }

 }

 views {

  deployment ss "Production" "Diagrama-Despliegue" {
   include *
   autoLayout lr
   title "Alivia - Despliegue en Producción"
   description "C4 Model - Deployment View - Production Environment"
  }

  styles {

   element "Element" {
    color #d9232b
    stroke #d9232b
    strokeWidth 7
    shape roundedbox
   }

   element "Database" {
    shape cylinder
    background #87ceeb
    color #000000
    stroke #4aa8d8
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

   element "Edge" {
    shape Hexagon
    background #db2777
    color #ffffff
    stroke #9d174d
   }

   relationship "Relationship" {
    thickness 4
   }

   element "Infrastructure Node" {
    shape RoundedBox
    background #85bbf0
    color #000000
    border solid
   }

   element "Deployment Node" {
    background #ffffff
    color #000000
    stroke #999999
    border dashed
   }

   element "Wrapper" {
    background #f8f8f8
    color #333333
    stroke #333333
    border dashed
   }

   element "Cloudflare" {
    background #fff7ed
    stroke #f97316
    color #7c2d12
    border dashed
   }

   element "Oracle" {
    background #fee2e2
    stroke #dc2626
    color #7f1d1d
    border dashed
   }

   element "MongoDBAtlas" {
    background #dcfce7
    stroke #16a34a
    color #14532d
    border dashed
   }

   element "OnPremises" {
    background #f0fdf4
    stroke #16a34a
    color #14532d
    border dashed
   }

   element "UserDevice" {
    background #faf5ff
    stroke #9333ea
    color #4c1d95
    border dashed
   }

  }
 }

 configuration {
  scope softwaresystem
 }

}