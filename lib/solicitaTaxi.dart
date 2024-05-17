import 'package:flutter/material.dart';
import 'package:neverlost/constants.dart';

class SolicitaTaxi extends StatefulWidget {
  const SolicitaTaxi({ Key? key }) : super(key: key);

  @override
  _SolicitaTaxi createState() => _SolicitaTaxi();
}

class _SolicitaTaxi extends State<SolicitaTaxi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Solicitar taxi',
      style: TextStyle(
        color: Colors.white
      ),),
      backgroundColor: Constantes.backgroundColor,
      iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text('ALGO TENDRÁN QUE HACER LOS TAXIS'),
      ),
    
    );
  }
}