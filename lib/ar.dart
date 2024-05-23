import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:location/location.dart';
import 'package:o3d/o3d.dart';
import 'package:vector_math/vector_math.dart' as vector;
import 'dart:math';

class Ar extends StatefulWidget {
  const Ar({Key? key}) : super(key: key);

  @override
  _ArState createState() => _ArState();
}

class _ArState extends State<Ar> {
  final Location _location = Location();
  late LatLng targetPosition; // Posición del punto objetivo
  double currentBearing = 0.0; // Bearing calculado basado en la ubicación
  double compassHeading = 0.0; // Dirección de la brújula
  O3DController o3dController = O3DController();

  @override
  void initState() {
    super.initState();
    targetPosition = LatLng(36.687416, -4.470552); // Define la posición objetivo
    _listenLocation();
  }

  void _listenLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _location.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        LatLng currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        double bearing = calculateBearing(currentPosition, targetPosition);
        setState(() {
          currentBearing = bearing;
        });
        _updateModelOrientation();
      }
    });
  }

  double calculateBearing(LatLng from, LatLng to) {
    double lat1 = vector.radians(from.latitude);
    double lon1 = vector.radians(from.longitude);
    double lat2 = vector.radians(to.latitude);
    double lon2 = vector.radians(to.longitude);

    double dLon = lon2 - lon1;

    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double bearing = vector.degrees(atan2(y, x));

    return (bearing + 360) % 360; // Asegurarse de que el ángulo esté entre 0 y 360
  }

  void _updateModelOrientation() {
    double adjustedHeading = (currentBearing - compassHeading + 360 - 75) % 360; // Ajusta la orientación del modelo
    print("****************************************************************$adjustedHeading valor que le llega a la función$currentBearing");
    if (adjustedHeading > 180) {
      adjustedHeading -= 360; // Limita a rango [-180, 180]
    }
    print("Actualización de orientación del modelo: currentBearing=$currentBearing, compassHeading=$compassHeading, adjustedHeading=$adjustedHeading");
    o3dController.cameraOrbit(adjustedHeading, 90, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          O3D(
            src: 'assets/direction_arrow.glb',
            controller: o3dController,
            ar: false,
            autoPlay: true,
            autoRotate: false,
            cameraControls: false,
            cameraTarget: CameraTarget(-0.8, 2, 0.1),
            cameraOrbit: CameraOrbit(180, 180, 0),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: StreamBuilder<CompassEvent>(
                stream: FlutterCompass.events,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    double heading = snapshot.data!.heading!;
                    compassHeading = heading; // Actualiza la dirección de la brújula
                    _updateModelOrientation(); // Actualiza la orientación del modelo 3D
                    return Text('Brújula: ${heading.toStringAsFixed(2)}°');
                  } else {
                    return const Text('Esperando datos de la brújula...');
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}
