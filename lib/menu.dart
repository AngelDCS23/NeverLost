// import 'dart:async';
// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neverlost/constants.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:http/http.dart';
import 'package:neverlost/models/usuarios.dart';
import 'package:neverlost/services/api_service.dart';
import 'package:qr_bar_code/code/code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:animations/animations.dart';

class menu extends StatefulWidget {
  @override
  _Menu createState() => _Menu();
}

class _Menu extends State<menu> {
  String textoparaQr = '';
  late Future<User> futureUser;
  late int _idUsu = 0;
  bool _isIdLoaded = false;
  bool pruebaAlerta = false;
  String? coordenadasDestino;

  Future<void> _ObtenerIdUsu() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUsu = prefs.getInt('user_id') ?? 0;
      _isIdLoaded = true;
      futureUser = fetchUser(_idUsu); // Llama a la función para obtener el usuario con ID que obtine de la sharedPreference
    });
  }
  
  bool _log = false;

  Future<void> _Log() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _log = prefs.getBool('isLoggedIn') ?? false;
  }
  
  String titulo(_bottomNavIndex){

    if(_bottomNavIndex == 0){
      return 'Home';
    }else if(_bottomNavIndex == 1){
      return 'Mapa';
    }else if(_bottomNavIndex == 2){
      return 'NeverLost User';
    }else if(_bottomNavIndex == 3){
      return 'Ajustes';
    }
    return 'NeverLost';
  }

  void initState(){
    super.initState();
    ObtenerCoordenadas();
    _ObtenerIdUsu();
    obtenerDatosQr();
    _Log();
  }

  // late Stream<Position> _positionStream;
  // // ignore: unused_field
  // String _locationMessage = '';
  // Set<Marker> _markers = {};
  // Set<Polygon> _polygons = {};

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

    // Barcode? result;
    // QRViewController? controller;
    // final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
    // String? ruta_Pantalla;

  final iconList = <IconData>[
    Icons.home,
    Icons.map,
    Icons.card_membership,
    Icons.settings, 
  ];

  var _bottomNavIndex = 0; 

  // Función para eliminar las credenciales almacenadas en SharedPreferences
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('email');
    await prefs.remove('contrasena');
    setState(() {
      _log = false; // Actualiza la variable _log para reflejar el cierre de sesión
    });
    // Puedes realizar otras acciones aquí, como navegar a la pantalla de inicio de sesión
  }

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
    backgroundColor: Colors.white,
   body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Visibility(
            visible: _bottomNavIndex == 0,
              child: Stack(
                alignment: Alignment.topCenter,
                  children: [
                    Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            child: Column(
                              children: [
                                Container(
                              child: Text('Bienvenido a NeverLost',
                              textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Constantes.backgroundColor,
                          ),),
                            ),
                            Padding(padding: EdgeInsets.only(top: 20),
                            child: Container(
                              width: 350,
                              child: Text('Desde aquí, podrás acceder a todas las ventajas que ofrece la aplicación',
                            textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                           fontSize: 16,
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
                        height: 500,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 260,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                ),
                Positioned(
                  top: 200,
                  left: 25,
                  child: Container(       
                    height: 460,
                    width: 360,
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Constantes.backgroundColor,
                  ),
                  child: Padding(padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Container(
                            height: 30,
                            child: GestureDetector(
                            onTap: (){
                                Navigator.pushNamed(context, '/qr');
                              },
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.airplane_ticket,
                            size: 30,
                            color: Colors.white,),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('Escanear un nuevo billete',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                         Padding(padding: EdgeInsets.symmetric(vertical: 20),
                         child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                          onTap: () {
                            if (coordenadasDestino != null) {
                              Navigator.pushNamed(context, '/mapa');
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Advertencia', 
                                    style: GoogleFonts.montserrat(),
                                    ),
                                    content: Text('Escanea el billete antes de ver el mapa',
                                    style: GoogleFonts.montserrat(),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK',
                                        style: GoogleFonts.montserrat(
                                          color: Constantes.backgroundColor
                                        ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
          child: Container(
            height: 116,
            width: 360,
            color: Constantes.blue2, // Cambia esto por Constantes.blue2
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Container(
                          width: 240,
                          child: Text(
                            'Mapa del aeropuerto',
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Container(
                          width: 240,
                          child: Text(
                            'Encuentra los puntos clave del aeropuerto con el mapa interactivo',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 90,
                    child: Image.asset(
                      'assets/herramienta.png',
                      scale: 1.9,
                    ),
                  ),
                ],
              ),
            ),
          ),
  
    ),
                          ],
                         ),),
                         Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                         child: GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, '/taxi');
                                },
                                child: 
                         Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top: 40),
                            child: Container(
                              width: 320,
                              height: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Constantes.blueSky,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 60,
                                  ),
                                  Text('Solicita un Taxi',
                              style: GoogleFonts.montserrat(
                                color: Constantes.backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 19
                              ),),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                              child: Text('Desde aquí podrás llamar para solicitar un taxi que te esté esperando',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                              ),),)         
                                ],
                              ),
                              ),                       
                            ),
                          ],
                         ),
                         ),
                         ),
                        ],
                      ),
                  )
                ),
                ),
                Positioned(
                  top: 410,
                  left: (MediaQuery.of(context).size.width - 100) / 2,
                  child: Container(
                     width: 100, 
                      height: 100, 
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Constantes.blueSky, 
                      ),
                      child: Image.asset('assets/taxi.png',
                      scale: 1.7,)
                  )
                  ),
                  ],
                )
          ),
          Visibility(
          visible: _bottomNavIndex == 1,
          child: ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, '/prueba');
          }, child: Text('Prueba')),
        ),
        Visibility(
          visible: _bottomNavIndex == 2,
          child:  Center(
            child: Column(
              children: [
                Visibility(
                  visible: _log == false,
                  child:Center(
                child: 
                Stack(
                  children: [
                    Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 300,
                        child: Column(
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
                    backgroundColor: WidgetStateProperty.all<Color>(Constantes.blueSky),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Cambia el radio del borde aquí
                  ),
                  ),
                  ),
                  
                  child: Text('Registrate',
                  style: TextStyle(
                    color: Constantes.backgroundColor,
                    fontSize: 17
                  ),)
                  ))
                  ],
                )
              ) ),
              Visibility(
                visible: _log == true,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Constantes.blue2,
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top:  60),
                            child:Column(
                              children: <Widget>[
                                Container(
                              width: 150,
                              height: 150,
                              child: Code(data: "http://$textoparaQr", codeType: CodeType.qrCode(),
                              color: Colors.white),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _isIdLoaded
                            ? FutureBuilder<User>(
                                future: futureUser,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('${snapshot.error}');
                                  } else if (snapshot.hasData) {
                                    return Text('${snapshot.data!.nombre}',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),);
                                  } else {
                                    return Text('No se encontró el usuario',
                                    style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),);
                                  }
                                },
                              )
                            : CircularProgressIndicator(
                            ),
                              ],
                            )
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10),
                      child: Container(
                        color: Constantes.backgroundColor,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.airplane_ticket,
                              color: Colors.white,
                              size: 30,),
                              title: Text('Mis Billetes',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 20,
                            ),),
                            onTap: () {
                            Navigator.pushNamed(context, '/misBilletes');
                            }
                            ),
                          ],
                        ),
                      ),),
                      Container(
                        color: Constantes.backgroundColor,
                        child: Column(
                          children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.account_circle,
                          color: Colors.white,
                          size: 30,),
                          title: Text('Mi Perfil',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 20,
                              ),),
                              onTap: (){
                                Navigator.pushNamed(context, '/miPerfil');
                              },
                      ),
                      ListTile(
                          leading: Icon(Icons.login_outlined,
                          color: Colors.white,
                          size: 30,),
                          title: Text('Desconectar',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 20,
                              ),),
                              onTap: (){
                                _logout();
                                Navigator.pushNamed(context, '/menu');
                              },
                      ),

                          ],
                        )
                        
                      ),
                      
                    ],
                  ),
                ))
              ],
            ),
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
                                  onTap: (){
                                    Navigator.pushNamed(context, '/notificaciones');
                                  },
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
                                  onTap: (){
                                    Navigator.pushNamed(context, '/camaraPrueba');
                                  },
                        ),
                        ListTile(
                          leading: Icon(Icons.list,
                                color: Constantes.backgroundColor,
                                size: 25,),
                                title: Text('Políticas de privacidad y condiciones de uso',
                                  style:  GoogleFonts.montserrat(
                                    color: Constantes.backgroundColor,
                                  ),),
                                  onTap: () => launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html')

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
      floatingActionButton: FloatingActionButton(
          onPressed: () {
                            if (coordenadasDestino != null) {
                              Navigator.pushNamed(context, '/ar');
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Advertencia', 
                                    style: GoogleFonts.montserrat(),
                                    ),
                                    content: Text('Escanea el billete antes poder utilizar la realidad aumentada',
                                    style: GoogleFonts.montserrat(),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK',
                                        style: GoogleFonts.montserrat(
                                          color: Constantes.backgroundColor
                                        ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                          }
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

  void ObtenerCoordenadas() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    coordenadasDestino =  prefs.getString('CoordenadasDestino')!;
    print('assssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss$coordenadasDestino');
  }

      Future<void> obtenerDatosQr() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user_data = prefs.getString('user_data') ?? ''; 
      setState(() {
      textoparaQr = user_data; 
    });
    }

//   Widget _buildQrView(BuildContext context) {
//     // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
//     var scanArea = (MediaQuery.of(context).size.width < 400 ||
//             MediaQuery.of(context).size.height < 400)
//         ? 150.0
//         : 300.0;
//     // To ensure the Scanner view is properly sizes after rotation
//     // we need to listen for Flutter SizeChanged notification and update controller
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//           borderColor: Colors.white,
//           borderRadius: 10,
//           borderLength: 30,
//           borderWidth: 10,
//           cutOutSize: scanArea),
//       onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//         ruta_Pantalla = scanData.code;
//         _deQr_aPantalla();
//       });
//     });
//   }

//   void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
//     log('${DateTime.now().toIso8601String()}_onPermissionSet $p' as num);
//     if (!p) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('no Permission')),
//       );
//     }
//   }

//   void _deQr_aPantalla() {
//     if (ruta_Pantalla != null) {
//       Navigator.pushNamed(context, '$ruta_Pantalla');
//     }
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
}
