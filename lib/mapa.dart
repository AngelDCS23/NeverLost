import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:neverlost/constants.dart';


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
  
    @override
    void initState() {
      super.initState();
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
    }

    void _createSquarePolygon() {

    List<LatLng> PlantaCentro = [
      LatLng(36.712803, -4.433091),
      LatLng(36.712747, -4.433204),
      LatLng(36.712660, -4.433138),
      LatLng(36.712612, -4.433229),
      LatLng(36.713016, -4.433524),
      LatLng(36.712957, -4.433644),
      LatLng(36.713186, -4.433818),
      LatLng(36.71335, -4.43349), //Este punto no se arregla. Es el que está desplazado hacia fuera varios metros, no se que hacer con el.
    ];

    Polygon squarePolygon = Polygon(
      polygonId: PolygonId('square'),
      points: PlantaCentro,
      strokeWidth: 5,
      strokeColor: Constantes.backgroundColor, // Color del borde del polígono
      fillColor: Colors.red.withOpacity(1), // Color de relleno del polígono
    );

    // Añadir el polígono al conjunto de polígonos
    setState(() {
      _polygons.add(squarePolygon);
    });
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
      body: Expanded(
            child: GoogleMap(
              mapType: MapType.terrain,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers,
              polygons: _polygons, 
              
            ),
          ),
    );
  }
}