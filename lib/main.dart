import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
  var onOff = false;

  void _cancelStream() {
    positionStream.cancel();
    setState(() {
      onOff = false;
    });
  }

  void _getPosition() async {
    setState(() {
      onOff = true;
    });

    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);

    positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      position1 = position;
      print(position == null
          ? 'Unknown'
          : position.latitude.toString() +
              ', ' +
              position.longitude.toString());
    });
  }

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
                subtitle: const Text('Servicio detenido'),
              ),
            ),
            Container(
                height: 70,
                child: ListTile(
                  title: Text("Identificador de dispositivo"),
                  subtitle: Text("371455"),
                )),
            Container(
                height: 70,
                child: ListTile(
                  title: Text("URl del servidor"),
                  subtitle: Text("URL del servidor de seguimiento"),
                )),
            Container(
                height: 70,
                child: ListTile(
                  title: Text("Precisión"),
                  subtitle: Text("Precisión deseada"),
                )),
            Container(
                height: 70,
                child: ListTile(
                  title: Text("Frecuencia de rastreo"),
                  subtitle: Text("Intervalo para reportes en minutos"),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getPosition,
        tooltip: 'Posición',
        child: Icon(Icons.map),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
