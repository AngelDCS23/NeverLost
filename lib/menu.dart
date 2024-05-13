import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neverlost/constants.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:animations/animations.dart';

class menu extends StatefulWidget {
  @override
  _Menu createState() => _Menu();
}


class _Menu extends State<menu> {

  String titulo(_bottomNavIndex){

    if(_bottomNavIndex == 0){
      return 'QR';
    }else if(_bottomNavIndex == 1){
      return 'Mapa';
    }else if(_bottomNavIndex == 2){
      return 'NeverLost User';
    }else if(_bottomNavIndex == 3){
      return 'Ajustes';
    }
    return 'NeverLost';
  }

  late Stream<Position> _positionStream;
  // ignore: unused_field
  String _locationMessage = '';
  Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};

// En teoria esto tendría que nmotificar si tiene los permisos o no. Pero no hace nada jajajaja
//   Future<AlertDialog> alerta() async{
//     var status = await Permission.location.status;
//   if(status.isDenied){
//     return AlertDialog(
//       actions: [
//         TextButton(
//           onPressed: (){
//           Navigator.of(context).pop();
//         },
//         child: Text('Cerrar'),
//         )
//       ],
//       title: Text('Error en permisos'),
//       contentPadding: EdgeInsets.all(20),
//       content: Text('No tienes los permisos de ubicación activados, si quiere utilizar el mapa tendrá que activarlo desde los ajustes de la aplicación'),
//     );
//   }
//   return AlertDialog(
//       actions: [
//         TextButton(
//           onPressed: (){
//           Navigator.of(context).pop();
//         },
//         child: Text('Cerrar'),
//         )
//       ],
//       title: Text('Todo Bien'),
//       contentPadding: EdgeInsets.all(20),
//       content: Text('asdasdas'),
//     );
//   }

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
      LatLng(36.713376, -4.433481), //Este punto no se arregla. Es el que está desplazado hacia fuera varios metros, no se que hacer con el.
      
    ];

    // Crear el polígono cuadrado
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
    Icons.settings, 
  ];

  var _bottomNavIndex = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text(titulo(_bottomNavIndex),
      style: TextStyle(
        color: Colors.white
      ),),
      backgroundColor: Constantes.backgroundColor,
      iconTheme: IconThemeData(color: Colors.white),
    ),
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
              mapType: MapType.none,
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
                        height: 300,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
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
                        height: 330,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 260,
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
                          GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, '/inicioSesion');
                            },
                            child: Text(' Iniciar Sesión',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Constantes.backgroundColor,
                          )),
                          )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                ),
                Positioned(
                  top: 220,
                  left: 25,
                  child: Container(       
                    height: 310,
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
                  top: 505,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 ListTile(
                                leading: Icon(Icons.notification_important,
                                color: Constantes.backgroundColor,
                                size: 25,),
                                title: Text('Notificaciones',
                                  style:  GoogleFonts.montserrat(
                                    color: Constantes.backgroundColor,
                                  ),),
                  ),
                        ListTile(
                          leading: Icon(Icons.room,
                                color: Constantes.backgroundColor,
                                size: 25,),
                                title: Text('Ubicación',
                                  style:  GoogleFonts.montserrat(
                                    color: Constantes.backgroundColor,
                                  ),),
                                  onTap: (){
                                    Navigator.pushNamed(context, '/ubicacion');
                                  },
                        ),
                         ListTile(
                          leading: Icon(Icons.turned_in,
                                color: Constantes.backgroundColor,
                                size: 25,),
                                title: Text('Idioma',
                                  style:  GoogleFonts.montserrat(
                                    color: Constantes.backgroundColor,
                                  ),),
                        ),
                        ListTile(
                          leading: Icon(Icons.star_rate,
                                color: Constantes.backgroundColor,
                                size: 25,),
                                title: Text('Valora la aplicación',
                                  style:  GoogleFonts.montserrat(
                                    color: Constantes.backgroundColor,
                                  ),),
                        ),
                        ListTile(
                          leading: Icon(Icons.list,
                                color: Constantes.backgroundColor,
                                size: 25,),
                                title: Text('Políticas de privacidad y condiciones de uso',
                                  style:  GoogleFonts.montserrat(
                                    color: Constantes.backgroundColor,
                                  ),),
                        ),
                        Container(
                          height: 400,
                        )
              ],
            )
            
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
          activeColor: Constantes.blueSky,
          inactiveColor: Constantes.blue2,
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
