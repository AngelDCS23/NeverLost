import 'dart:math';

import 'package:flutter/material.dart';
import 'package:neverlost/constants.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class menu extends StatefulWidget { 
  @override
  _Menu createState() => _Menu();
}

class _Menu extends State<menu> {

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? ruta_Pantalla;

  final iconList = <IconData>[
    Icons.qr_code,
    Icons.map,
    Icons.person,
    Icons.expand_circle_down_rounded, //Este último icono se tendría que cambiar por otro que representase la configuración.
  ];

  var _bottomNavIndex = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constantes.backgroundColor,
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
            child: 
            Text('MAPA')
          ),
          Visibility(
            visible: _bottomNavIndex == 2,
            child: 
            Text('PERFIL')
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
          backgroundColor: Colors.white,
          child: Icon(Icons.arrow_upward_rounded),
          elevation: 2,
          shape: CircleBorder(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: iconList,
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.defaultEdge,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
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

