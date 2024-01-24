<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.


configuracion de github
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/Edwards2kx/analytics_package.git
git push -u origin main

crear el servicio basico del paquete el cual se debe poder configurar el authority para facilidad
y un key

crear el singleton que devuelve la instacia y permite configurar el servicio

hacer un llamado manual del servicio


Crear la clase en singleton de AnalyticService, devolver la instancia.
al inicializar recibe el path de donde enviar los datos, un booleano de si está o no activo
los elementos que se desean escanear del movil, por defecto todos en true, 
pensar en agregar algunas excepciones personalizadas, como la falta de permisos,
o la falta de agregar elementos en el info.plist


devolver como resultado la entidad infoAnalytics para ser usada dentro de la app
en caso de requerir.

#definir que se va a realizar con el listado de apps que llega desde el servidor
almacenar en una preferencia local en modo lista?


construir la respuesta de configuracion desde el servidor
construir el modelo de la respuesta, donde llegan las aplicaciones a buscar en adnrodi


agregar los permisos de android y de iOS
documentar que se requeren dichos permisos para ciertas funcionalidades


tener un metodo que se llamé inicializar o configurar y otro de obtener la instancia


para importarlo dentro de un proyecto agregar lo siguiente dentro del archivo pubspec.yaml
reemplazar el usuario y repositorio dentro de la url por los que correspondan al repositorio
donde se encuentra alojado en package.

dependencies:
  mi_paquete_personal:
    git:
      url: https://github.com/tu-usuario/mi_paquete_personal
      ref: main

ejemplo: 
  analytics:
    git:
      url: https://github.com/Edwards2kx/analytics_package.git
      ref: main


la versión minima para android debe ser la 21, para cambiarla ir al directorio
root/android/app/build.gradle:
en donde se encuentra la versión minima "minSDKVersion flutter.minSdkVersion", establecer 21 o superior.                                                                                       │
│ android {                                                                                     │
│   defaultConfig {                                                                             │
│     minSdkVersion 21                                                                          │
│   }                                                                                           │
│ }     
commodo_flutterflow@yopmail.com
aliado@yopmail.com