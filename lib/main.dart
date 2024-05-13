import 'package:flutter/material.dart';
import 'package:neverlost/inicio.dart';
import 'package:neverlost/inicioSesion.dart';
import 'package:neverlost/olvidoContra.dart';
import 'package:neverlost/tutorial2.dart';
import 'package:neverlost/menu.dart';
import 'package:neverlost/registro.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/primeraPantalla', //ruta principal
    routes: {
      '/primeraPantalla': (context) => inicio(),
      '/pantallaTutorial': (context) => tutorial2(),
      '/menu': (conext) => menu(),
      '/registro':(context) => Registro(),
      '/inicioSesion':(context) => InicioSesion(),
      '/olvidoContra':(context) => OlvidoContra(),
    },
  ));
}
