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


para obtener información de la ubicación se debe solicitar el permiso de ubicación....
se recomienda el uso del paquete:

para android

agregar al android_manifest.xml lo siguiente por fuera de la etiqueta <aplication>



<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />

<uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />

probar el package https://pub.dev/packages/simpleblue 


para bluetooth agregar los siguientes permisos al android manifest





commodo_flutterflow@yopmail.com
aliado@yopmail.com

para los permisos de ubicación en iOS agregar lo siguiente al info.plist

	<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
	<string>Based location promotions</string>
	<key>NSLocationAlwaysUsageDescription</key>
	<string>Based location promotions</string>
	<key>NSLocationUsageDescription</key>
	<string>Based location promotions</string>
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>Based location promotions</string>


para verificar las apps en iOS agregar lo siguiente al info.plist

<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>bbvamovil</string>
		<string>capacitor</string>
		<string>etsy</string>
		<string>com.kraken.invest.app.payments</string>
		<string>hardwaresimulator</string>
		<string>indriver</string>
		<string>transferwise</string>
		<string>paypal</string>
		<string>daviviendacol</string>
		<string>pio-ABEs2Y42TTUxJ9vUI6bIaxiuo</string>
		<string>fb243775639854014</string>
		<string>fb236176206921235</string>
		<string>gbrappi</string>
		<string>com.rappi.partner</string>
		<string>com.mcdonalds.mobileapp</string>
		<string>com.eapps.kfc</string>
		<string>tasty</string>
		<string>sodexo-colombia</string>
		<string>myedenredglobal</string>
		<string>ikea</string>
		<string>com.coinbase.consumer</string>
		<string>coinmarketcap</string>
		<string>fb178247028857093</string>
		<string>linio</string>
		<string>niqui</string>
		<string>fb</string>
		<string>instagram</string>
		<string>roblox</string>
		<string>linkedin</string>
		<string>tiktok</string>
		<string>vnd.youtube.kids</string>
		<string>com.investing.app</string>
		<string>duolingo</string>
		<string>fb279924378802210</string>
		<string>Binance</string>
		<string>nflx</string>
		<string>skype</string>
		<string>aliexpress</string>
		<string>com.amazon.mobile.shopping</string>
		<string>skyscanner.payments</string>
		<string>uber</string>
		<string>nflx</string>
		<string>starbucks</string>
		<string>tinder</string>
		<string>bumble</string>
		<string>niketrainingclub</string>
		<string>twitter</string>
		<string>pinterest</string>
		<string>zarahome</string>
		<string>com.zomato.zomato</string>
	</array>