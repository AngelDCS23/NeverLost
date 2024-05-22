import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:o3d/o3d.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vector_math/vector_math.dart' as vector;
import 'dart:math';

class Ar extends StatefulWidget {
  const Ar({Key? key}) : super(key: key);

  @override
  _Ar createState() => _Ar();
}

class _Ar extends State<Ar> {
  static const Duration _ignoreDuration = Duration(milliseconds: 20);
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Duration sensorInterval = SensorInterval.normalInterval;
  GyroscopeEvent? _gyroscopeEvent;
  DateTime? _gyroscopeUpdateTime;
  int? _gyroscopeLastInterval;

  O3DController o3dController = O3DController();
  Location location = Location();

  LatLng targetPosition = LatLng(36.712803, -4.433091); // Posición del punto objetivo
  double currentHeading = 0.0;
  LatLng? _lastLocation;

  double yaw = 0.0; // Solo nos interesa la rotación en el eje Y

  double scaleFactor = 20; // Factor de escala para hacer los cambios más evidentes

  void _listenLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      if (_lastLocation == null ||
          _lastLocation!.latitude != currentLocation.latitude ||
          _lastLocation!.longitude != currentLocation.longitude) {
        _lastLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        double bearing = calculateBearing(
            LatLng(currentLocation.latitude!, currentLocation.longitude!),
            targetPosition);
        _updateModelOrientation(bearing);
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

    print("Cálculo de bearing: lat1=$lat1, lon1=$lon1, lat2=$lat2, lon2=$lon2, dLon=$dLon, y=$y, x=$x, bearing=$bearing");

    return (bearing + 360) % 360; // Asegurarse de que el ángulo esté entre 0 y 360
  }

  void _updateModelOrientation(double bearing) {
    double heading = (bearing - currentHeading + 360) % 360;
    print("Actualización de orientación del modelo: bearing=$bearing, currentHeading=$currentHeading, heading=$heading");
    setState(() {
      currentHeading = heading;
    });
    o3dController.cameraOrbit(heading, 90, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: O3D(
        src: 'assets/direction_arrow.glb',
        controller: o3dController,
        ar: false,
        autoPlay: true,
        autoRotate: false,
        cameraControls: false,
        cameraTarget: CameraTarget(-0.8, 2, 0.1),
        cameraOrbit: CameraOrbit(180, 180, 0),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _listenLocation();
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          final now = DateTime.now();
          if (_gyroscopeUpdateTime != null) {
            final interval = now.difference(_gyroscopeUpdateTime!);
            if (interval > _ignoreDuration) {
              setState(() {
                _gyroscopeEvent = event;
                _gyroscopeLastInterval = interval.inMilliseconds;

                // Imprimir los valores del giroscopio
                print("Giroscopio: x=${event.x}, y=${event.y}, z=${event.z}");

                // Actualizar la orientación del modelo usando solo el eje y (yaw)
                yaw += event.y * scaleFactor;

                // Imprimir la orientación actual
                print("Orientación: yaw=$yaw");

                // Actualizar la orientación del modelo 3D
                o3dController.cameraOrbit(yaw, 90, 0);
              });
              _gyroscopeUpdateTime = now;
            }
          } else {
            _gyroscopeUpdateTime = now;
          }
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                    "It seems that your device doesn't support Gyroscope Sensor"),
              );
            },
          );
        },
        cancelOnError: true,
      ),
    );
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}
