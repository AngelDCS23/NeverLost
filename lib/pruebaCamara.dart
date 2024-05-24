import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPreviewWidget extends StatefulWidget {
  @override
  _CameraPreviewWidgetState createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      _controller = CameraController(
        camera,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller.initialize();
      await _initializeControllerFuture; // Espera a que se inicialice el controlador
      setState(() {}); // Reconstruye el widget con la vista previa de la cámara
    } catch (e) {
      print('Error al inicializar la cámara: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Libera el controlador de la cámara
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vista previa de la cámara')),
      body: _controller != null && _controller.value.isInitialized
          ? CameraPreview(_controller) // Muestra la vista previa de la cámara si está inicializada
          : Center(child: CircularProgressIndicator()),
    );
  }
}
