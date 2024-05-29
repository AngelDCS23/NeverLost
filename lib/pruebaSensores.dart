import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;

class PolylineToPolygonExample extends StatefulWidget {
  @override
  _PolylineToPolygonExampleState createState() => _PolylineToPolygonExampleState();
}

class _PolylineToPolygonExampleState extends State<PolylineToPolygonExample> {
  String _locationMessage = "";

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // El servicio de ubicación no está habilitado. No podemos continuar.
      setState(() {
        _locationMessage = "El servicio de ubicación está deshabilitado.";
      });
      return;
    }

    // Verifica el permiso de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Los permisos están denegados. No podemos continuar.
        setState(() {
          _locationMessage = "Permiso de ubicación denegado.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Los permisos están denegados permanentemente. No podemos continuar.
      setState(() {
        _locationMessage = "Permiso de ubicación denegado permanentemente.";
      });
      return;
    }

    // Obtiene la ubicación actual
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _locationMessage = "Ubicación: Latitud: ${position.latitude}, Longitud: ${position.longitude}";
    });
  }

  GoogleMapController? _controller;
  Set<Polyline> _polylines = {};
  Set<Polygon> _polygons = {};
  LatLng _currentLocation = LatLng(36.7130864, -4.4333294);

  List<mp.LatLng> _pasillo = [
    mp.LatLng(36.7132634, -4.4334704),
    mp.LatLng(36.7132413, -4.4335148),
    mp.LatLng(36.7132804, -4.4335440),
    mp.LatLng(36.7132864, -4.4335308),
    mp.LatLng(36.7133060, -4.4335459),
    mp.LatLng(36.7132991, -4.4335601),
    mp.LatLng(36.7133191, -4.4335753),
    mp.LatLng(36.7133107, -4.4335928),
    mp.LatLng(36.7132911, -4.4335775),
    mp.LatLng(36.7132830, -4.4335944),
    mp.LatLng(36.7132782, -4.4335915),
    mp.LatLng(36.7131954, -4.4337634),
    mp.LatLng(36.7131845, -4.4337556),
    mp.LatLng(36.7132671, -4.4335839),
    mp.LatLng(36.7132030, -4.4335342),
    mp.LatLng(36.7132324, -4.4334753),
    mp.LatLng(36.7127942, -4.4331492),
    mp.LatLng(36.7128051, -4.4331270),
    mp.LatLng(36.7130593, -4.4333177),
    mp.LatLng(36.7130726, -4.4332910),
    mp.LatLng(36.7130885, -4.4333031),
    mp.LatLng(36.7130995, -4.4332814),
    mp.LatLng(36.7131250, -4.4333008),
    mp.LatLng(36.7131007, -4.4333481),
    mp.LatLng(36.7132478, -4.4334589),
    mp.LatLng(36.7132543, -4.4334469),
    mp.LatLng(36.7132896, -4.4334732),
    mp.LatLng(36.7132840, -4.4334852),
  ];

  @override
  void initState() {
    super.initState();
    _setPolygon();
    _generateRoute();
  }

  void _setPolygon() {
    _polygons.add(
      Polygon(
        polygonId: PolygonId('Pasillo'),
        points: _pasillo.map((point) => LatLng(point.latitude, point.longitude)).toList(),
        strokeWidth: 1,
        strokeColor: Color.fromARGB(255, 18, 71, 25),
        fillColor: Color.fromARGB(255, 21, 116, 43).withOpacity(0.5),
      ),
    );
  }

  void _generateRoute() {
    // Definir un punto de inicio y de destino dentro del polígono
    mp.LatLng start = mp.LatLng(36.7130864, -4.4333294);
    mp.LatLng end = mp.LatLng(36.7131926, -4.4337439);

    print("Generando ruta desde $start hasta $end");

    // Obtener la ruta utilizando el algoritmo A*
    List<mp.LatLng> route = _aStarAlgorithm(start, end, _pasillo);

    // Agregar la ruta como una polyline si es válida
    if (route.isNotEmpty) {
      print("Ruta generada con éxito: ${route.length} puntos");
      setState(() {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('polyline_1'),
            points: route.map((point) => LatLng(point.latitude, point.longitude)).toList(),
            width: 5,
            color: Colors.blue,
          ),
        );
      });
    } else {
      print("No se pudo generar una ruta válida dentro del polígono.");
    }
  }

  List<mp.LatLng> _getAdjacentNodes(mp.LatLng node) {
    double lat = node.latitude;
    double lng = node.longitude;
    double step = 0.000002; // Reducir aún más la distancia

    return [
      mp.LatLng(lat + step, lng), // Arriba
      mp.LatLng(lat - step, lng), // Abajo
      mp.LatLng(lat, lng + step), // Derecha
      mp.LatLng(lat, lng - step), // Izquierda
    ];
  }

  double _calculateDistance(mp.LatLng point1, mp.LatLng point2) {
    double dx = point1.latitude - point2.latitude;
    double dy = point1.longitude - point2.longitude;
    return math.sqrt(dx * dx + dy * dy);
  }

  List<mp.LatLng> _aStarAlgorithm(mp.LatLng start, mp.LatLng end, List<mp.LatLng> polygonPoints) {
    List<Node> openList = [];
    List<Node> closedList = [];

    openList.add(Node(start, null, 0, _calculateDistance(start, end)));

    while (openList.isNotEmpty) {
      openList.sort((a, b) => a.f.compareTo(b.f));

      Node currentNode = openList.first;
      print("Nodo actual: ${currentNode.point}");

      // Verificar si el nodo actual está lo suficientemente cerca del nodo de destino
      if (_calculateDistance(currentNode.point, end) < 0.0001) {
        print("Nodo destino alcanzado");
        return _buildRoute(currentNode);
      }

      openList.remove(currentNode);
      closedList.add(currentNode);

      List<mp.LatLng> neighbors = _getAdjacentNodes(currentNode.point);

      for (mp.LatLng neighbor in neighbors) {
        bool isInside = mp.PolygonUtil.containsLocation(neighbor, polygonPoints, true);
        print("Verificando vecino $neighbor, está dentro: $isInside");

        if (isInside) {
          if (!closedList.any((node) => node.point == neighbor)) {
            double g = currentNode.g + _calculateDistance(currentNode.point, neighbor);

            Node neighborNode = openList.firstWhere((node) => node.point == neighbor, orElse: () => Node(neighbor, null, 0, 0));
            if (!openList.any((node) => node.point == neighbor) || g < neighborNode.g) {
              double h = _calculateDistance(neighbor, end);
              double f = g + h;

              neighborNode.g = g;
              neighborNode.f = f;
              neighborNode.parent = currentNode;

              if (!openList.contains(neighborNode)) {
                openList.add(neighborNode);
              }
            }
          }
        } else {
          print("El vecino $neighbor está fuera del polígono");
        }
      }
    }

    return [];
  }

  List<mp.LatLng> _buildRoute(Node endNode) {
    List<mp.LatLng> route = [];
    Node? currentNode = endNode;

    while (currentNode != null) {
      route.add(currentNode.point);
      currentNode = currentNode.parent;
    }

    return route.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polyline to Polygon Example'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _currentLocation,
          zoom: 18.0,
        ),
        polylines: _polylines,
        polygons: _polygons,
      ),
    );
  }
}

class Node {
  final mp.LatLng point;
  Node? parent;
  double g; // Costo desde el punto inicial hasta este nodo
  double f; // Costo total estimado desde el punto inicial hasta el nodo final a través de este nodo

  Node(this.point, this.parent, this.g, this.f);
}

void main() {
  runApp(MaterialApp(
    home: PolylineToPolygonExample(),
  ));
}
