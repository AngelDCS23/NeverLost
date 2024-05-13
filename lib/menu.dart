import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neverlost/constants.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class menu extends StatefulWidget {
  @override
  _Menu createState() => _Menu();
}


class _Menu extends State<menu> {

  late Stream<Position> _positionStream;
  String _locationMessage = '';
  Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};

    @override
    void initState() {
      super.initState();
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
    // Coordenadas del cuadrado
    List<LatLng> squareCoordinates = [
      LatLng(37.576838, -4.583353), // Esquina superior izquierda
      LatLng(36.576726, -6.583389), // Esquina superior derecha
      LatLng(36.576743, -4.583522), // Esquina inferior derecha
      LatLng(36.576845, -4.583455), // Esquina inferior izquierda
    ];

    // Crear el polígono cuadrado
    Polygon squarePolygon = Polygon(
      polygonId: PolygonId('square'),
      points: squareCoordinates,
      strokeWidth: 2,
      strokeColor: Color.fromARGB(255, 253, 3, 3), // Color del borde del polígono
      fillColor: const Color.fromARGB(255, 160, 161, 162).withOpacity(1), // Color de relleno del polígono
    );

    // Añadir el polígono al conjunto de polígonos
    setState(() {
      _polygons.add(squarePolygon);
    });
  }
    
  final Completer<GoogleMapController> _controller =
        Completer<GoogleMapController>();

    static const CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(36.576752, -4.583733),
      zoom: 19.7,
    );

    // static const CameraPosition _kLake = CameraPosition( //ESTO SE TIENE QUE CAMBIAR EN CASO DE QUE QUIERA QUE EXISTA UNA UBICACIÓN A LA QUE IR
    //     bearing: 192.8334901395799,
    //     target: LatLng(37.43296265331129, -122.08832357078792),
    //     tilt: 59.440717697143555,
    //     zoom: 19.151926040649414
    // );

    Barcode? result;
    QRViewController? controller;
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
    String? ruta_Pantalla;

  final iconList = <IconData>[
    Icons.qr_code,
    Icons.map,
    Icons.card_membership,
    Icons.expand_circle_down_rounded, //Este último icono se tendría que cambiar por otro que representase la configuración.
  ];

  var _bottomNavIndex = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    // appBar: AppBar(
    //   title: Text('Prueba'),
    // ),
      backgroundColor: Constantes.blueSky,
   body: Container(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Visibility(
            visible: _bottomNavIndex == 0,
            child:
            Expanded(
                flex: 4,
                child: _buildQrView(context)), //Llamamos a la función del QR
          ),
          Visibility(
          visible: _bottomNavIndex == 1,
          child: Expanded(
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers,
              polygons: _polygons, 
            ),
          ),
        ),
        
          Visibility(
            visible: _bottomNavIndex == 2,
            child: 
              Center(
                child: 
                Stack(
                  children: [
                    Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        // color: Colors.amber,
                        height: 330,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                            child: Column(
                              children: [
                                Container(
                              height: 70,
                              child: Image.asset('assets/userNeverlost.png'),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 20),
                            child: Container(
                              width: 290,
                              child: Text('Hazte mienbro y disfruta de ventaja y descuentos',
                            textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Constantes.backgroundColor,
                          ),),
                            ),)  
                              ],
                            ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Constantes.blue2,
                        height: 400,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 200,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Ya tengo cuenta.',
                              style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),),
                          Text(' Iniciar Sesión',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Constantes.backgroundColor,
                          )),
                                ],
                              )
                              
                            ],
                          ),
                        ),
                      )
                    ],
                ),
                Positioned(
                  top: 240,
                  left: 25,
                  child: Container(       
                    height: 330,
                    width: 360,
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Constantes.backgroundColor,
                  ),
                  child: Padding(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Column(
                        children: [
                          ListTile(
                                leading: Icon(Icons.local_taxi,
                                color: Colors.white,
                                size: 25,),
                                title: Text('Descuentos en Taxis',
                                  style:  GoogleFonts.montserrat(
                                    color: Colors.white,
                                  ),),
                  ),
                        ListTile(
                          leading: Icon(Icons.shopping_bag_sharp,
                                color: Colors.white,
                                size: 25,),
                                title: Text('Promociones en tiendas y restaurantes',
                                  style:  GoogleFonts.montserrat(
                                    color: Colors.white,
                                  ),),
                        ),
                         ListTile(
                          leading: Icon(Icons.restaurant_rounded,
                                color: Colors.white,
                                size: 25,),
                                title: Text('Reserva mesa en diferentes establecimientos',
                                  style:  GoogleFonts.montserrat(
                                    color: Colors.white,
                                  ),),
                        ),
                        ListTile(
                          leading: Icon(Icons.airplanemode_active,
                                color: Colors.white,
                                size: 25,),
                                title: Text('Descuentos en futuros billetes',
                                  style:  GoogleFonts.montserrat(
                                    color: Colors.white,
                                  ),),
                        ),
                        ],
                      ),
                  )
                  
                ),
                ),
                Positioned(
                  top: 545,
                  left: 135,
                  child: ElevatedButton(onPressed: (){
                    Navigator.pushNamed(context, '/registro');
                  }, 
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Constantes.blueSky),
                  ),
                  child: Text('Registrate',
                  style: TextStyle(
                    color: Constantes.backgroundColor,
                    fontSize: 17
                  ),)
                  ))
                  ],
                )
              )
          ),


          Visibility(
            visible: _bottomNavIndex == 3,
            child: 
            Text('CONFIGURACIÓN')
          )
        ],
      ),
    ),
   ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            //TIENE QUE HACER ALGO.
          },
          backgroundColor: Constantes.backgroundColor,
          child: Icon(
            Icons.arrow_upward_rounded,
            color: Constantes.blueSky,
            ),
          elevation: 2,
          shape: CircleBorder(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: iconList,
          activeColor: Constantes.blue2,
          inactiveColor: Constantes.blueSky,
          height: 70,
          iconSize: 30,
          backgroundColor: Constantes.backgroundColor,
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.defaultEdge,
          onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        ruta_Pantalla = scanData.code;
        _deQr_aPantalla();
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p' as num);
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void _deQr_aPantalla() {
    if (ruta_Pantalla != null) {
      Navigator.pushNamed(context, '$ruta_Pantalla');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
