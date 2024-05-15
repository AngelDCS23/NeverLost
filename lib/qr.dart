import 'dart:math';

import 'package:flutter/material.dart';
import 'package:neverlost/constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Qr extends StatefulWidget {
  @override
  _QrState createState() => _QrState();
}

Barcode? result;
    

class _QrState extends State<Qr> {
  QRViewController? controller;
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
    String? ruta_Pantalla;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('QR',
      style: TextStyle(
        color: Colors.white
      ),),
      backgroundColor: Constantes.backgroundColor,
      iconTheme: IconThemeData(color: Colors.white),),
      body: Expanded(
                flex: 4,
                child: _buildQrView(context)),
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
