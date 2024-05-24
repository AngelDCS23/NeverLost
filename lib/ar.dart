import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:location/location.dart';
import 'package:o3d/o3d.dart';
import 'package:vector_math/vector_math.dart' as vector;
import 'dart:math';
import 'package:camera/camera.dart';

class ArWithCamera extends StatefulWidget {
  const ArWithCamera({Key? key}) : super(key: key);

  @override
  _ArWithCameraState createState() => _ArWithCameraState();
}

class _ArWithCameraState extends State<ArWithCamera> {
  final Location _location = Location();
  late LatLng targetPosition; // Posición del punto objetivo
  double currentBearing = 0.0; // Bearing calculado basado en la ubicación
  double compassHeading = 0.0; // Dirección de la brújula
  O3DController o3dController = O3DController();
  late CameraController _cameraController;
  late Future<void> _initializeCameraControllerFuture;

  @override
  void initState() {
    super.initState();
    targetPosition = LatLng(36.692799, -4.482717); // Define la posición objetivo
    _initializeCamera();
    _listenLocation();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      _cameraController = CameraController(
        camera,
        ResolutionPreset.max,
      );
      _initializeCameraControllerFuture = _cameraController.initialize();
      await _initializeCameraControllerFuture; // Espera a que se inicialice el controlador
      setState(() {}); // Reconstruye el widget con la vista previa de la cámara
    } catch (e) {
      print('Error al inicializar la cámara: $e');
    }
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
    if (adjustedHeading > 180) {
      adjustedHeading -= 360; // Limita a rango [-180, 180]
    }
    o3dController.cameraOrbit(adjustedHeading, 90, 0);
  }

  @override
  void dispose() {
    _cameraController.dispose(); // Libera el controlador de la cámara
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _cameraController != null && _cameraController.value.isInitialized
          ? Stack(
              children: [
                Positioned.fill(
                  child: CameraPreview(_cameraController),
                ),
                Align(
                  alignment: Alignment.center,
                  child: O3D(
                    src: 'assets/direction_arrow.glb',
                    controller: o3dController,
                    ar: false,
                    autoPlay: true,
                    autoRotate: false,
                    cameraControls: false,
                    cameraTarget: CameraTarget(-0.8, 2, 0.1),
                    cameraOrbit: CameraOrbit(180, 180, 0),
                  ),
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
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}
