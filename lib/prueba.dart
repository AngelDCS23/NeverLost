import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Asumiendo que estás utilizando el paquete geolocator para obtener la posición

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Position Stream Example'),
        ),
        body: Center(
          child: PositionStreamWidget(), // Widget que muestra la posición en un Text
        ),
      ),
    );
  }
}

class PositionStreamWidget extends StatefulWidget {
  @override
  _PositionStreamWidgetState createState() => _PositionStreamWidgetState();
}

class _PositionStreamWidgetState extends State<PositionStreamWidget> {
  late Stream<Position> _positionStream;

  @override
  void initState() {
    super.initState();
    // Inicializar el flujo de posición
    _positionStream = Geolocator.getPositionStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Position>(
      stream: _positionStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final position = snapshot.data!;
          // Mostrar la información de posición en un Text
          return Text(
            'Latitud: ${position.latitude}, Longitud: ${position.longitude}',
            style: TextStyle(fontSize: 18.0),
          );
        } else if (snapshot.hasError) {
          // Si hay un error en el flujo, mostrar el mensaje de error
          return Text('Error obteniendo la posición: ${snapshot.error}');
        } else {
          // Mientras no haya datos disponibles, mostrar un indicador de carga
          return CircularProgressIndicator();
        }
      },
    );
  }
}
