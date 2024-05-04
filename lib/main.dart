import 'package:flutter/material.dart';
import 'package:neverlost/inicio.dart';
import 'package:neverlost/tutorial.dart';
import 'package:neverlost/menu.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/primeraPantalla', //ruta principal
    routes: {
      '/primeraPantalla': (context) => inicio(),
      '/pantallaTutorial': (context) => tutorial(),
      '/menu': (conext) => menu(),
    },
  ));
}