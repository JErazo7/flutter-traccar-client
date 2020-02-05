import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:traccar_client/alertDialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traccar Client',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Traccar Client'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position position1;
  StreamSubscription<Position> positionStream;
  final http.Client httpClient = http.Client();

  var onOff = false;
  var baseUrl = 'http://demo4.traccar.org';
  var id = '1a2s3d';
  var estadoServicio = 'Detenido';
  var campo = [
    'Identificador de dispositivo',
    'URL del servidor',
    'Frecuencia de rastreo'
  ];
  var frecuencia = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: ListView(
            padding: const EdgeInsets.only(left: 30.0, top: 8.0),
            children: <Widget>[
              Container(
                height: 70,
                child: SwitchListTile(
                  title: const Text('Estado de servicio'),
                  isThreeLine: true,
                  value: onOff,
                  onChanged: (_) {
                    if (onOff) {
                      _cancelStream();
                    } else {
                      _getPosition();
                    }
                  },
                  subtitle: Text(estadoServicio),
                ),
              ),
              Container(
                  height: 70,
                  child: ListTile(
                      title: Text(campo[0]),
                      subtitle: Text(id),
                      onTap: () async {
                        var data =
                            await _showDialog(title: campo[0], value: id);
                        setState(() {
                          id = data;
                        });
                      })),
              Container(
                  height: 70,
                  child: ListTile(
                      title: Text("URL del servidor"),
                      subtitle: Text(baseUrl),
                      onTap: () async {
                        var data =
                            await _showDialog(title: campo[1], value: baseUrl);
                        setState(() {
                          baseUrl = data;
                        });
                      })),
              Container(
                  height: 70,
                  child: ListTile(
                      title: Text("Frecuencia de rastreo"),
                      subtitle: Text("Intervalo para reportes en metros"),
                      onTap: () => {
                            _showDialog(
                                title: campo[2], value: frecuencia.toString()),
                          })),
            ],
          ),
        ));
  }

  void _cancelStream() {
    positionStream.cancel();
    setState(() {
      onOff = false;
      estadoServicio = 'Detenido';
    });
  }

  void _getPosition() async {
    setState(() {
      onOff = true;
      estadoServicio = 'En ejecución';
    });
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
        accuracy: LocationAccuracy.high, distanceFilter: frecuencia);

    positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) async {
      if (position != null) {
        var lat = position.latitude.toString();
        var lon = position.longitude.toString();
        var finalUrl = baseUrl + ':5055';
        var response = await httpClient
            .post(finalUrl, body: {'id': id, 'lat': lat, 'lon': lon});
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        print(lat + ', ' + lon);
      } else {
        print('Unknown');
      }
    });
  }

  Future<String> _showDialog({title, value}) async {
    return await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialogInput(title: title, value: value);
        });
  }
}
