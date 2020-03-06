# Mika GPS conductor!
Aplicación móvil  multiplataforma que accede al GPS de los teléfonos para obtener y emitir la ubicación en tiempo real a un servidor *Traccar* mediante el protocolo *OsmAnd* . 

## Obtención de los datos del GPS
Para acceder al dispositivo GPS de los teléfonos, la aplicación utiliza el paquete [geolocator](https://pub.dev/packages/geolocator),  que es un complemento de geolocalización de Flutter que proporciona un fácil acceso a los servicios de ubicación específicos de la plataforma ( FusedLocationProviderClient o, si no está disponible, el LocationManager en Android y CLLocationManager en iOS).

### Implementación:
El siguiente código se encuentra en el archivo ***main.dart***  y se utiliza  para la obtención de la ubicación de los dispositivos.

    import  'package:geolocator/geolocator.dart';
    
	StreamSubscription<Position> positionStream;
	
	var geolocator = Geolocator();
	var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: frecuencia);
	
	positionStream = geolocator.getPositionStream(locationOptions)
		.listen((Position position) async {}
dónde:
  
 - `LocationOptions` - Clase del paquete Geolocator que permite setear la configuración del nivel de precisión y la frecuencia con los que se obtienen los datos del GPS.
 -   `getPositionStream` - Método de la clase Geolocator() que permite suscribirse y escuchar los cambios de la ubicación que emite el GPS para proceder con las respectivas actualización de ubicación al servidor de Traccar. 
 - 
### Permisos:
 - **Android**:
 En Android, deberá agregar el permiso  `ACCESS_FINE_LOCATION`  a su Android Manifest. Para hacerlo, debe abrir el archivo AndroidManifest.xml (ubicado en android/app/src/main) y agregar la siguiente línea de código como elementos secundarios directos de la `<manifest>`etiqueta:
	 ```xml
	<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
	```
 
 
 -  **iOS** : 
En iOS,  para acceder a la ubicación del dispositivo, deberá agregar `NSLocationWhenInUseUsageDescription` , `NSLocationAlwaysUsageDescription` y `NSLocationAlwaysAndWhenInUseUsageDescription`  a su archivo Info.plist (ubicado en ios/Runner/Base.lproj). Simplemente abra su archivo Info.plist y agregue lo siguiente:
	```xml
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>This app needs access to location when open.</string>
	<key>NSLocationAlwaysUsageDescription</key>
	<string>This app needs access to location when in the background.</string>
	<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
	<string>This app needs access to location when open and in the background.</string>
	```

## Conexión con Traccar
Para comunicarse con *Traccar*, la aplicación utiliza el paquete [http](https://pub.dev/packages/http), que es una biblioteca que se basa en promesas para realizar solicitudes HTTP.

El formato de dirección web que admite el protocolo OsmAnd en Traccar es el siguiente:
>http://demo.traccar.org:5055/?id=123456&lat={0}&lon={1}×tamp={2}&hdop={3}&altitude={4}&speed={5}

dónde:
-   `demo.traccar.org` - Dirección del servidor o nombre de dominio (por ejemplo, puede ser la dirección IP pública de su servidor)
-   `123456` - Identificador único de su dispositivo asignado en Traccar.

Para enviar la ubicación al servidor la aplicación utiliza las siguientes lineas de código que se encuentran en el archivo ***main.dart***:

    import  'package:http/http.dart'  as http;
    
    final http.Client httpClient = http.Client();
    
    var response = await httpClient
    .post(finalUrl, body: {'id': id, 'lat': lat, 'lon': lon});



