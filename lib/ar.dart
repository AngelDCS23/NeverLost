import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:neverlost/constants.dart';
import 'package:o3d/o3d.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late LatLng targetPosition;
  double currentBearing = 0.0;
  double compassHeading = 0.0;
  O3DController o3dController = O3DController();
  late CameraController _cameraController;
  late Future<void> _initializeCameraControllerFuture;
  String? intermedio;
  LatLng destino = LatLng(36.7128390, -4.4330591);
  bool _isCameraInitialized = false;
  StreamSubscription<CompassEvent>? _compassSubscription;

  Future<void> obtenerCoordenadasShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    intermedio = prefs.getString('CoordenadasDestino');
    if (intermedio != null) {
      final coords = intermedio!.split(',');
      double lat = double.parse(coords[0]);
      double lon = double.parse(coords[1]);
      destino = LatLng(lat, lon);
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    obtenerCoordenadasShared().then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          targetPosition = destino;
        });
        _listenLocation();
        _listenCompass();
      });
    });
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
      await _initializeCameraControllerFuture;
      setState(() {
        _isCameraInitialized = true;
      });
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
        double bearing = calculateBearing(currentPosition, destino);
        setState(() {
          currentBearing = bearing;
        });
        _updateModelOrientation();
      }
    });
  }

  void _listenCompass() {
    _compassSubscription = FlutterCompass.events!.listen((CompassEvent event) {
      if (mounted) {
        setState(() {
          compassHeading = event.heading!;
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

    return (bearing + 360) % 360;
  }

  void _updateModelOrientation() {
    double adjustedHeading = (currentBearing - compassHeading + 360 -90) % 360; //Compensación de la "ruta"
    if (adjustedHeading > 180) {
      adjustedHeading -= 360;
    }
    print('currentBearing: $currentBearing');
    print('compassHeading: $compassHeading');
    print('adjustedHeading: $adjustedHeading');
    o3dController.cameraOrbit(adjustedHeading, 90, 0);
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('AR', style: GoogleFonts.montserrat(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Constantes.backgroundColor,
      ),
      body: !_isCameraInitialized
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: AspectRatio(
                    aspectRatio: _cameraController.value.aspectRatio,
                    child: CameraPreview(_cameraController),
                  ),
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
                // Align(
                //   alignment: Alignment.topCenter,
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 50.0),
                //     child: Text('Esperando datos de la brújula...'),
                //   ),
                // ),
              ],
            ),
    );
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);

  @override
  String toString() {
    return 'LatLng(latitude: $latitude, longitude: $longitude)';
  }
}
