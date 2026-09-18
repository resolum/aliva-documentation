workspace "Alivia Platform - System Landscape" "Mapa de alto nivel del ecosistema de Alivia para la automatización del hogar por voz y la asistencia a personas con discapacidad motora severa." {







 model {







 !impliedRelationships false







 visitor  = person "Visitor"  "Usuario anónimo que explora la plataforma e inicia el registro." "Visitor"



 familyMember = person "Family Member" "Familiar o cuidador que supervisa la actividad de automatización del hogar del residente, el nivel de batería y el estado (fallas/alertas) de los dispositivos, configura reglas de asistencia y recibe alertas de forma remota." "Relative"



 disabled = person " Disable person" "Persona con discpacidad motora " "Disable"



 group "Resolum" {







  support    = person "Support"      "Se encarga del soporte técnico interno y la asistencia operativa."     "Support"



  subscriptionManager = person "Subscription Services Manager" "Gestiona los planes de suscripción, los ciclos de facturación y las cuentas de los clientes." "SubscriptionManager"



  administrator  = person "Business Administrator"  "Gestiona las operaciones del negocio, las cuentas de los clientes y las suscripciones." "Admin"





controllerHardware = person "Controller Hardware" "Controlador de los actuadores colocadas en la casa" "External,Hardware"

  microphoneSensor = softwareSystem "Microphone Hardware" "Dispositivo IoT portátil (wearable) que capta en tiempo real los comandos de voz del residente." "External, Hardware"



  aliviaPlatform = softwareSystem "Alivia Platform" "Plataforma basada en IoT que permite a personas con discapacidad motora severa controlar dispositivos del hogar (puertas, luces, ventanas) mediante comandos de voz, funcionando de forma autónoma incluso sin acceso a Internet. Permite a los cuidadores ver el registro de actividad del residente, el nivel de batería y el estado/fallas de los dispositivos, y recibir alertas." "Internal"







 }







 stripe  = softwareSystem "Stripe"  "Procesa los pagos de la suscripción."                          "External"



 googleMaps = softwareSystem "Google Maps" "Resuelve y valida la dirección del hogar que el familiar completa al suscribirse, para programar la visita de instalación." "External"



 sendgrid = softwareSystem "Sendgrid" "Envía correos transaccionales: confirmación de compra/suscripción, códigos de verificación en dos pasos y otros correos de la cuenta." "External"



 firebase = softwareSystem "Firebase" "Envía notificaciones push en tiempo real al familiar cuando la batería de un dispositivo está baja o cuando un dispositivo está fallando." "External"

 cloudinary = softwareSystem " Cloudinary" "Manejo de fotos de los perfiles" "External"





 // --- Relaciones: Personas → Alivia Platform ---



 visitor    -> aliviaPlatform "Explora las funciones de la plataforma e inicia el registro"         "HTTPS"



 administrator  -> aliviaPlatform "Administra cuentas de clientes, residentes y suscripciones"          "HTTPS"



 familyMember  -> aliviaPlatform "Configura reglas de asistencia, supervisa la actividad, la batería y el estado de los dispositivos del residente, y recibe alertas" "HTTPS"



 support    -> aliviaPlatform "Brinda soporte técnico y gestiona incidencias operativas"          "HTTPS"



 subscriptionManager -> aliviaPlatform "Gestiona los planes de suscripción y la facturación de las cuentas de los clientes"    "HTTPS"



disabled -> microphoneSensor "Manejo del dispositivo por voz para pedir una accion"



 // --- Relaciones: Alivia Platform → Sistemas Externos ---



 aliviaPlatform -> stripe   "Procesa las transacciones de pago de la suscripción"       "REST API / HTTPS"



 aliviaPlatform -> googleMaps  "Resuelve la dirección de instalación ingresada durante el registro a la suscripción" "REST API / HTTPS"



 aliviaPlatform -> sendgrid   "Envía correos de confirmación de compra y de verificación en dos pasos"  "REST API / HTTPS"



 aliviaPlatform -> microphoneSensor "Recibe en tiempo real los eventos de voz desde el micrófono portátil"  "Edge / MQTT"



  aliviaPlatform -> controllerHardware " Recibe en tiempo real los comandos para ejuctar una accion dentro de la habitacion " "Edge / MQTT"



 aliviaPlatform -> firebase   "Envía notificaciones push por batería baja o falla de un dispositivo"   "REST API / HTTPS"



 aliviaPlatform -> cloudinary "Almacenamiento de las fotos de los perfiles " "REST API / HTTPS"





 }







 views {







 systemLandscape "SystemLandscape" "Alivia Platform — Mapa del Sistema" {



  include *



  autoLayout lr



 }







 styles {



  element "Person" {



  shape  Person



  background "#ffffff"



  color  "#0f766e"



  stroke  "#0f766e"



  fontSize 20



  }



  element "Internal" {



  shape  RoundedBox



  background "#f0fdf4"



  color  "#065f46"



  stroke  "#065f46"



  fontSize 20



  }



  element "External" {



  shape  RoundedBox



  background "#6b7280"



  color  "#ffffff"



  stroke  "#6b7280"



  fontSize 20



  }



  element "Hardware" {



  shape  RoundedBox



  background "#4b5563"



  color  "#ffffff"



  stroke  "#4b5563"



  fontSize 20



  }



  element "Visitor" {



  background "#9ca3af"



  stroke  "#9ca3af"



  color  "#ffffff"



  }



  element "Admin" {



  background "#7c3aed"



  stroke  "#7c3aed"



  color  "#ffffff"



  }



  element "Relative" {



  background "#f59e0b"



  stroke  "#f59e0b"



  color  "#ffffff"



  }



  element "Support" {



  background "#0ea5e9"



  stroke  "#0ea5e9"



  color  "#ffffff"



  }



  element "SubscriptionManager" {



  background "#e11d48"



  stroke  "#e11d48"



  color  "#ffffff"



  }



 }workspace "Alivia Platform - System Landscape" "Mapa de alto nivel del ecosistema de Alivia para la automatización del hogar por voz y la asistencia a personas con discapacidad motora severa." {







   model {







   !impliedRelationships false







   visitor  = person "Visitor"  "Usuario anónimo que explora la plataforma e inicia el registro." "Visitor"



   familyMember = person "Family Member" "Familiar o cuidador que supervisa la actividad de automatización del hogar del residente, el nivel de batería y el estado (fallas/alertas) de los dispositivos, configura reglas de asistencia y recibe alertas de forma remota." "Relative"



   disabled = person " Disable person" "Persona con discpacidad motora " "Disable"



   group "Resolum" {







    support    = person "Support"      "Se encarga del soporte técnico interno y la asistencia operativa."     "Support"



    subscriptionManager = person "Subscription Services Manager" "Gestiona los planes de suscripción, los ciclos de facturación y las cuentas de los clientes." "SubscriptionManager"



    administrator  = person "Business Administrator"  "Gestiona las operaciones del negocio, las cuentas de los clientes y las suscripciones." "Admin"





  controllerHardware = person "Controller Hardware" "Controlador de los actuadores colocadas en la casa" "External,Hardware"

    microphoneSensor = softwareSystem "Microphone Hardware" "Dispositivo IoT portátil (wearable) que capta en tiempo real los comandos de voz del residente." "External, Hardware"



    aliviaPlatform = softwareSystem "Alivia Platform" "Plataforma basada en IoT que permite a personas con discapacidad motora severa controlar dispositivos del hogar (puertas, luces, ventanas) mediante comandos de voz, funcionando de forma autónoma incluso sin acceso a Internet. Permite a los cuidadores ver el registro de actividad del residente, el nivel de batería y el estado/fallas de los dispositivos, y recibir alertas." "Internal"







   }







   stripe  = softwareSystem "Stripe"  "Procesa los pagos de la suscripción."                          "External"



   googleMaps = softwareSystem "Google Maps" "Resuelve y valida la dirección del hogar que el familiar completa al suscribirse, para programar la visita de instalación." "External"



   sendgrid = softwareSystem "Sendgrid" "Envía correos transaccionales: confirmación de compra/suscripción, códigos de verificación en dos pasos y otros correos de la cuenta." "External"



   firebase = softwareSystem "Firebase" "Envía notificaciones push en tiempo real al familiar cuando la batería de un dispositivo está baja o cuando un dispositivo está fallando." "External"

   cloudinary = softwareSystem " Cloudinary" "Manejo de fotos de los perfiles" "External"





   // --- Relaciones: Personas → Alivia Platform ---



   visitor    -> aliviaPlatform "Explora las funciones de la plataforma e inicia el registro"         "HTTPS"



   administrator  -> aliviaPlatform "Administra cuentas de clientes, residentes y suscripciones"          "HTTPS"



   familyMember  -> aliviaPlatform "Configura reglas de asistencia, supervisa la actividad, la batería y el estado de los dispositivos del residente, y recibe alertas" "HTTPS"



   support    -> aliviaPlatform "Brinda soporte técnico y gestiona incidencias operativas"          "HTTPS"



   subscriptionManager -> aliviaPlatform "Gestiona los planes de suscripción y la facturación de las cuentas de los clientes"    "HTTPS"



  disabled -> microphoneSensor "Manejo del dispositivo por voz para pedir una accion"



   // --- Relaciones: Alivia Platform → Sistemas Externos ---



   aliviaPlatform -> stripe   "Procesa las transacciones de pago de la suscripción"       "REST API / HTTPS"



   aliviaPlatform -> googleMaps  "Resuelve la dirección de instalación ingresada durante el registro a la suscripción" "REST API / HTTPS"



   aliviaPlatform -> sendgrid   "Envía correos de confirmación de compra y de verificación en dos pasos"  "REST API / HTTPS"



   aliviaPlatform -> microphoneSensor "Recibe en tiempo real los eventos de voz desde el micrófono portátil"  "Edge / MQTT"



    aliviaPlatform -> controllerHardware " Recibe en tiempo real los comandos para ejuctar una accion dentro de la habitacion " "Edge / MQTT"



   aliviaPlatform -> firebase   "Envía notificaciones push por batería baja o falla de un dispositivo"   "REST API / HTTPS"



   aliviaPlatform -> cloudinary "Almacenamiento de las fotos de los perfiles " "REST API / HTTPS"





   }







   views {







   systemLandscape "SystemLandscape" "Alivia Platform — Mapa del Sistema" {



    include *



    autoLayout lr



   }







   styles {



    element "Person" {



    shape  Person



    background "#ffffff"



    color  "#0f766e"



    stroke  "#0f766e"



    fontSize 20



    }



    element "Internal" {



    shape  RoundedBox



    background "#f0fdf4"



    color  "#065f46"



    stroke  "#065f46"



    fontSize 20



    }



    element "External" {



    shape  RoundedBox



    background "#6b7280"



    color  "#ffffff"



    stroke  "#6b7280"



    fontSize 20



    }



    element "Hardware" {



    shape  RoundedBox



    background "#4b5563"



    color  "#ffffff"



    stroke  "#4b5563"



    fontSize 20



    }



    element "Visitor" {



    background "#9ca3af"



    stroke  "#9ca3af"



    color  "#ffffff"



    }



    element "Admin" {



    background "#7c3aed"



    stroke  "#7c3aed"



    color  "#ffffff"



    }



    element "Relative" {



    background "#f59e0b"



    stroke  "#f59e0b"



    color  "#ffffff"



    }



    element "Support" {



    background "#0ea5e9"



    stroke  "#0ea5e9"



    color  "#ffffff"



    }



    element "SubscriptionManager" {



    background "#e11d48"



    stroke  "#e11d48"



    color  "#ffffff"



    }



   }







   }







  }







 }







}