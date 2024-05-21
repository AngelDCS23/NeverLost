import 'package:flutter/material.dart';
import 'package:neverlost/ar.dart';
import 'package:neverlost/borrarCuenta.dart';
import 'package:neverlost/cambiarContrase%C3%B1a.dart';
import 'package:neverlost/inicio.dart';
import 'package:neverlost/inicioSesion.dart';
import 'package:neverlost/mapa.dart';
import 'package:neverlost/notificaciones.dart';
import 'package:neverlost/olvidoContra.dart';
import 'package:neverlost/perfil.dart';
import 'package:neverlost/prueba_api.dart';
import 'package:neverlost/qr.dart';
import 'package:neverlost/solicitaTaxi.dart';
import 'package:neverlost/tutorial2.dart';
import 'package:neverlost/menu.dart';
import 'package:neverlost/registro.dart';
import 'package:neverlost/ubicacion.dart';

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
      '/ubicacion':(context) => Ubicacion(),
      '/notificaciones':(context) => Notificaciones(),
      '/qr':(context) => Qr(),
      '/mapa':(context) => Mapa(),
      '/taxi':(context) => SolicitaTaxi(),
      '/prueba':(context) => UserPage(),
      '/miPerfil':(context) => Perfil(),
      '/borrarCuenta':(context) => BorrarCuenta(),
      '/cambiarContraseña':(context) => CambiarContrasena(),
      '/ar': (context) => Ar(),
    },
  ));
}
