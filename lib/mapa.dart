import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:neverlost/constants.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:neverlost/pruebaSensores.dart';


class Mapa extends StatefulWidget {
  const Mapa({ Key? key }) : super(key: key);

  @override
  _Mapa createState() => _Mapa();
}

class _Mapa extends State<Mapa> {
  late Stream<Position> _positionStream;
  // ignore: unused_field
  String _locationMessage = '';
  Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};
  Set<Polyline> _polylines = {};
  // LatLng _currentLocation;
  mp.LatLng _currentLocation = mp.LatLng(36.7130864, -4.4333294);

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

  Future<void> _determinePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = mp.LatLng(position.latitude, position.longitude);
      print('*********************************************$_currentLocation**********************************************');
    });
  }
  
    @override
    void initState() {
      super.initState();
      _determinePosition();
      // alerta();
      _positionStream = Geolocator.getPositionStream(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 2, // distancia mínima en metros para que se actualice la ubicación
        ),
      );
      _positionStream.listen((Position position) {
        setState(() {
          _locationMessage =
              'Latitud: ${position.latitude}, Longitud: ${position.longitude}';
              _markers.clear();
              _markers.add(
                Marker(
                  markerId: MarkerId('current_position'),
                  position: LatLng(position.latitude, position.longitude),
                  infoWindow: InfoWindow(
                    title: 'Mi posición',
                    snippet:
                  'Latitud: ${position.latitude}, Longitud: ${position.longitude}',
                  ),
                ),
              );
        });
      });
      _createSquarePolygon();
       _generateRoute();
    }

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

    void _createSquarePolygon() {

    List<LatLng> PlantaCentro = [
      LatLng(36.7128390, -4.4330591),
      LatLng(36.7133971, -4.4334737),
      LatLng(36.7131991, -4.4338780),
      
      LatLng(36.7131456, -4.4338330),

      LatLng(36.7132671, -4.4335839),

      LatLng(36.7132030, -4.4335342),
      LatLng(36.7132324, -4.4334753),
      

      LatLng(36.7128371, -4.4331821),
      LatLng(36.7128093, -4.4332356),
      
      LatLng(36.7126627, -4.4331360),
      LatLng(36.7126782, -4.4331028),
      LatLng(36.7127810, -4.4331744),
    ];

    Polygon Planta = Polygon(
      polygonId: PolygonId('Planta'),
      points: PlantaCentro,
      strokeWidth: 3,
      strokeColor: Constantes.backgroundColor, // Color del borde del polígono
      fillColor: Color.fromARGB(255, 51, 161, 240).withOpacity(0.5), // Color de relleno del polígono
    );

    List<mp.LatLng> _pasillo = [
      
      mp.LatLng(36.7132634, -4.4334704), //Creo que esta es la esquina (izquierda abajo) de las escaleras
      mp.LatLng(36.7132413, -4.4335148),//Aqui está el punto de las escaleras (izquierda arriba)
      mp.LatLng(36.7132804, -4.4335440), //Aqui está el punto de las escaleras (derecha arriba)
      mp.LatLng(36.7132864, -4.4335308), //Ascensor (derecha arriba)
      mp.LatLng(36.7133060, -4.4335459), //Ascensor (isquierda arriba)
      mp.LatLng(36.7132991, -4.4335601), //Aseo Hombres
      mp.LatLng(36.7133191, -4.4335753), //Aseso Adaptados (izquierda abajo)
      mp.LatLng(36.7133107, -4.4335928), //Sala limpieza (derecha abajo)
      mp.LatLng(36.7132911, -4.4335775), //Sala Limpieza (izquierda abajo)
      mp.LatLng(36.7132830, -4.4335944), //Sala Limpieza (izquierda arriba)
      mp.LatLng(36.7132782, -4.4335915), //Aula5 (izquierda abajo)
      mp.LatLng(36.7131954, -4.4337634), //"biblioteca" (izquierda arriba)
      mp.LatLng(36.7131845, -4.4337556), //Aula4 (izquierda abajo)
      mp.LatLng(36.7132671, -4.4335839), //Planta centro, (esquina de pasillo dirección sala profesores)
      mp.LatLng(36.7132030, -4.4335342), //Planta Centro (esquina directa a poligono escaleras)
      mp.LatLng(36.7132324, -4.4334753), //Planra centro, (esquina pasillo dirección recepción)

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

    Polygon PoligonoPasillo = Polygon(
      polygonId: PolygonId('Pasillo'),
      points: _pasillo.map((point) => LatLng(point.latitude, point.longitude)).toList(),
      strokeWidth: 1,
      strokeColor: Color.fromARGB(255, 18, 71, 25), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 21, 116, 43).withOpacity(0.5),
    );

    List<LatLng> Aula6 =[
      LatLng(36.7128051, -4.4331270),
      LatLng(36.7128390, -4.4330591),
      LatLng(36.7129055, -4.4331066),
      LatLng(36.7128727, -4.4331776),
    ];

    Polygon PoligonoAula6 = Polygon(
      polygonId: PolygonId('Aula6'),
      points: Aula6,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );

    List<LatLng> Aula10 =[
      LatLng(36.7128727, -4.4331776),
      LatLng(36.7129055, -4.4331066),
      LatLng(36.7129523, -4.4331416),
      LatLng(36.7129192, -4.4332124),
    ];

    Polygon PoligonoAula10 = Polygon(
      polygonId: PolygonId('Aula10'),
      points: Aula10,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );

    List<LatLng> Aula12 =[
      LatLng(36.7129523, -4.4331416),
      LatLng(36.7129192, -4.4332124),
      LatLng(36.7129650, -4.4332467),
      LatLng(36.7129993, -4.4331769),
    ];

    Polygon PoligonoAula12 = Polygon(
      polygonId: PolygonId('Aula12'),
      points: Aula12,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );

    List<LatLng> Aula7 =[
      LatLng(36.7129650, -4.4332467),
      LatLng(36.7129993, -4.4331769),
      LatLng(36.7130731, -4.4332318),
      LatLng(36.7130615, -4.4332531),
      LatLng(36.7130830, -4.4332688),
      LatLng(36.7130589, -4.4333166),
    ];

    Polygon PoligonoAula7 = Polygon(
      polygonId: PolygonId('Aula7'),
      points: Aula7,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );

    List<LatLng> Servidores =[
      LatLng(36.7131156, -4.4332633),
      LatLng(36.7131045, -4.4332848),
      LatLng(36.7131256, -4.4333008),
      LatLng(36.7131366, -4.4332791),
    ];

    Polygon PoligonoServidores = Polygon(
      polygonId: PolygonId('Servidores'),
      points: Servidores,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );

    List<LatLng> Recepcion =[
      LatLng(36.7131366, -4.4332791),
      LatLng(36.7131018, -4.4333492),
      LatLng(36.7131353, -4.4333745),
      LatLng(36.7131702, -4.4333041),
    ];

    Polygon PoligonoRecepcion = Polygon(
      polygonId: PolygonId('Servidores'),
      points: Recepcion,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );

    List<LatLng> Aula8 =[
      LatLng(36.7131702, -4.4333041),
      LatLng(36.7131353, -4.4333745),
      LatLng(36.7132031, -4.4334239),
      LatLng(36.7132378, -4.4333545),
    ];

    Polygon PoligonoAula8 = Polygon(
      polygonId: PolygonId('Aula8'),
      points: Aula8,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );

    List<LatLng> Aula9 =[
      LatLng(36.7132378, -4.4333545),
      LatLng(36.7132031, -4.4334239),
      LatLng(36.7132480, -4.4334589),
      LatLng(36.7132540, -4.4334463),

      LatLng(36.7132898, -4.4334730),
      LatLng(36.7133172, -4.4334140),
    ];

    Polygon PoligonoAula9 = Polygon(
      polygonId: PolygonId('Aula9'),
      points: Aula9,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );

    List<LatLng> Aula11 =[
      LatLng(36.7133172, -4.4334140),
      LatLng(36.7132840, -4.4334852),

      LatLng(36.7133023, -4.4334990),

      LatLng(36.7132982, -4.4335067),
      LatLng(36.7133586, -4.4335529),
      LatLng(36.7133966, -4.4334734),
    ];

    Polygon PoligonoAula11 = Polygon(
      polygonId: PolygonId('Aula11'),
      points: Aula11,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );
    
    List<LatLng> Aula4 =[
      LatLng(36.7132398, -4.4337982),
      LatLng(36.7131845, -4.4337556),
      LatLng(36.7131456, -4.4338330),
      LatLng(36.7132010, -4.4338765),
    ];

    Polygon PoligonoAula4 = Polygon(
      polygonId: PolygonId('Aula4'),
      points: Aula4,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );

    List<LatLng> Biblioteca =[
      LatLng(36.7132398, -4.4337982),
      LatLng(36.7132573, -4.4337612),
      LatLng(36.7132132, -4.4337269),
      LatLng(36.7131954, -4.4337634),
    ];

    Polygon PoligonoBiblioteca = Polygon(
      polygonId: PolygonId('Biblioteca'),
      points: Biblioteca,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );

    List<LatLng> SalaProfesores =[  
      LatLng(36.7132754, -4.4337239),
      LatLng(36.7132310, -4.4336908),
      LatLng(36.7132132, -4.4337269),
      LatLng(36.7132573, -4.4337612),
    ];

    Polygon PoligonoSalaProfesores = Polygon(
      polygonId: PolygonId('SalaProfesores'),
      points: SalaProfesores,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );

    List<LatLng> Aula5 =[  
      LatLng(36.7133230, -4.4336240),

      LatLng(36.7132782, -4.4335915),
      LatLng(36.7132310, -4.4336908),
      LatLng(36.7132754, -4.4337239),
    ];

    Polygon PoligonoAula5 = Polygon(
      polygonId: PolygonId('Aula5'),
      points: Aula5,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );
    
    List<LatLng> AseoAdaptado =[  
      LatLng(36.7133241, -4.4336240),
      LatLng(36.7133032, -4.4336085),
      LatLng(36.7133191, -4.4335753),
      LatLng(36.7133401, -4.4335919),
    ];

    Polygon PoligonoAseoAdaptado = Polygon(
      polygonId: PolygonId('AseoAdaptado'),
      points: AseoAdaptado,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );

    List<LatLng> AseoMujeres =[  
      LatLng(36.7133401, -4.4335919),
      LatLng(36.7133239, -4.4335790),
      LatLng(36.7133424, -4.4335411),
      LatLng(36.7133586, -4.4335529),
    ];

    Polygon PoligonoAseoMujeres = Polygon(
      polygonId: PolygonId('AseoMujeres'),
      points: AseoMujeres,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );

    List<LatLng> AseoProfesores =[  
      LatLng(36.7133424, -4.4335411),
      LatLng(36.7133299, -4.4335317),
      LatLng(36.7133119, -4.4335697),
      LatLng(36.7133239, -4.4335790),
    ];

    Polygon PoligonoAseoProfesores = Polygon(
      polygonId: PolygonId('AseoProfesores'),
      points: AseoProfesores,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );

    List<LatLng> AseoHombres =[  
      LatLng(36.7133178, -4.4335223),
      LatLng(36.7133299, -4.4335317),
      LatLng(36.7133119, -4.4335697),
      LatLng(36.7132991, -4.4335601),
    ];

    Polygon PoligonoAseoHombres = Polygon(
      polygonId: PolygonId('AseoHombres'),
      points: AseoHombres,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );

    List<LatLng> CuartoInstalaciones =[  
      LatLng(36.7133032, -4.4336085),
      LatLng(36.7132830, -4.4335944),
      LatLng(36.7132911, -4.4335775),
      LatLng(36.7133107, -4.4335928),
    ];

    Polygon PoligonoCuartoInstalaciones = Polygon(
      polygonId: PolygonId('CuartoInstalaciones'),
      points: CuartoInstalaciones,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );

    List<LatLng> Ascensor =[  
      LatLng(36.7133178, -4.4335223),
      LatLng(36.7132982, -4.4335067),
      LatLng(36.7132864, -4.4335308),
      LatLng(36.7133060, -4.4335459),
    ];

    Polygon PoligonoAscensor = Polygon(
      polygonId: PolygonId('Ascensor'),
      points: Ascensor,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );

    List<LatLng> Escaleras =[  
      LatLng(36.7133024, -4.4334996),
      LatLng(36.7132804, -4.4335440),
      LatLng(36.7132413, -4.4335148),
      LatLng(36.7132634, -4.4334704),

    ];

    // LatLng(36.7133023, -4.4334990),

    Polygon PoligonoEscaleras = Polygon(
      polygonId: PolygonId('Escaleras'),
      points: Escaleras,
      strokeWidth: 3,
      strokeColor: Color.fromARGB(255, 9, 9, 9), // Color del borde del polígono
      fillColor: Color.fromARGB(255, 164, 164, 162).withOpacity(0.5),
    );

    // Añadir el polígono al conjunto de polígonos
    setState(() {
      _polygons.add(Planta);
      _polygons.add(PoligonoPasillo);
      _polygons.add(PoligonoAula6);
      _polygons.add(PoligonoAula10);
      _polygons.add(PoligonoAula12);
      _polygons.add(PoligonoAula7);
      _polygons.add(PoligonoServidores);
      _polygons.add(PoligonoRecepcion);
      _polygons.add(PoligonoAula8);
      _polygons.add(PoligonoAula9);
      _polygons.add(PoligonoAula11);
      _polygons.add(PoligonoAula4);
      _polygons.add(PoligonoBiblioteca);
      _polygons.add(PoligonoSalaProfesores);
      _polygons.add(PoligonoAula5);
      _polygons.add(PoligonoAseoAdaptado);
      _polygons.add(PoligonoAseoMujeres);
      _polygons.add(PoligonoAseoProfesores);
      _polygons.add(PoligonoAseoHombres);
      _polygons.add(PoligonoCuartoInstalaciones);
      _polygons.add(PoligonoAscensor);
      _polygons.add(PoligonoEscaleras);
      
    });
  }

  void _generateRoute() {
    // Definir un punto de inicio y de destino dentro del polígono
    mp.LatLng start = _currentLocation;
    mp.LatLng end = mp.LatLng(36.7131926, -4.4337439);

    print("Generando ruta desde $start hasta $end");

    // Obtener la ruta utilizando el algoritmo A*
    List<mp.LatLng> route = _aStarAlgorithm(start, end, _pasillo);
    
    // AgregaColor.fromARGB(255, 116, 87, 87)s válida
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
    
  final Completer<GoogleMapController> _controller =
        Completer<GoogleMapController>();

    static const CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(36.71301067498141, -4.43336209024246),
      zoom: 19.7,
      tilt: 0,
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Mapa',
      style: TextStyle(
        color: Colors.white
      ),),
      backgroundColor: Constantes.backgroundColor,
      iconTheme: IconThemeData(color: Colors.white),),
      body: _currentLocation == null
            ? Center(child: CircularProgressIndicator(),)
            : GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers,
              polygons: _polygons,
              polylines: _polylines, 
              // buildingsEnabled: false,
              // zoomControlsEnabled: false,
              // zoomGesturesEnabled: false,
              // trafficEnabled: false, 
              //Tendria que hacer que pudiera guardar las coodenadas del marcador que el usuario pinche para luego poder generar la flecha en esa dirección y la ruta
            ),
          
    );
  }
}