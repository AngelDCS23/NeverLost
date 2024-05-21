import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'constants.dart';

class Notificaciones extends StatefulWidget {
  @override
  _Notificaciones createState() => _Notificaciones();
}

class _Notificaciones extends State<Notificaciones> {
bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    permisos();
  }

void permisos() async{
  var status = await Permission.notification.status;
  if(status.isGranted){
    setState(() {
      isSwitched = true;
    });
  }else{
    setState(() {
      isSwitched = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Constantes.backgroundColor,
        title: Text('Notificaciones',
        style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.symmetric(vertical: 30),
            child: Container(
              width: 350,
              child: Text('Desde aquí podrás activar o desactivar las diferentes notificaciones de la aplicación',
              style: GoogleFonts.montserrat(
                fontSize: 15,
              ),
              textAlign: TextAlign.center,),
            )
             ),
             Container(
              width: 400,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey), // Línea superior
                  bottom: BorderSide(color: Colors.grey), // Línea inferior
                ),
              ),
              child: ListTile(
                leading: Icon(Icons.notification_important),
                title: Text(
                  'Existen diferentes tipos de notificaciones que podremos enviarte',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.montserrat(),
                ),
              ),
             ),
             Padding(padding: EdgeInsets.symmetric(vertical: 40),
             child: Container(
              width: 400,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Notificaciones de publicidad',
                style: GoogleFonts.montserrat(
                  fontSize: 15
                ),),
                SizedBox(
                  width: 20,
                ),
                Switch(value: isSwitched
                , 
                onChanged: (value) async {
                if (value) {
                  var status = await Permission.notification.request();
                  if (status.isGranted) {
                    setState(() {
                      isSwitched = value;
                    });
                  } else {
                    setState(() {
                      isSwitched = !value;
                    });
                  }
                } else {
                  setState(() {
                    isSwitched = value;
                  });
                }
              },
                activeColor: Constantes.backgroundColor, // Color del botón cuando está activo
                inactiveTrackColor: Colors.grey, // Color de la pista cuando está inactivo
                activeTrackColor: Constantes.blue2, // Color de la pista cuando está activo
                inactiveThumbColor: Constantes.backgroundColor, // Color del botón cuando está inactivo
                ),
              ],
             ),
             ),),
             Padding(padding: EdgeInsets.symmetric(vertical: 10),
             child: Container(
              width: 400,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Notificaciones de aplicación *',
                style: GoogleFonts.montserrat(
                  fontSize: 15
                ),),
                SizedBox(
                  width: 20,
                ),
                Switch(value: isSwitched
                , 
                onChanged: (value) async {
                if (value) {
                  var status = await Permission.notification.request();
                  if (status.isGranted) {
                    setState(() {
                      isSwitched = value;
                    });
                  } else {
                    setState(() {
                      isSwitched = !value;
                    });
                  }
                } else {
                  setState(() {
                    isSwitched = value;
                  });
                }
              },
                activeColor: Constantes.backgroundColor, // Color del botón cuando está activo
                inactiveTrackColor: Colors.grey, // Color de la pista cuando está inactivo
                activeTrackColor: Constantes.blue2, // Color de la pista cuando está activo
                inactiveThumbColor: Constantes.backgroundColor, // Color del botón cuando está inactivo
                ),
              ],
             ),
             ),),
             Padding(padding: EdgeInsets.symmetric(vertical: 40),
             child: Container(
              width: 350,
             child: Text('** Estas notificaciones te avisarán en caso de que a tu vuelo le quede poco tiempo para llegar/partir',
             textAlign: TextAlign.center,
             style: GoogleFonts.montserrat(
             ),),),)
          ],
        ),
      ),
      // backgroundColor: Constantes.blueSky,
    );
  }
}