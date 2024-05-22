import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'constants.dart';

class Ubicacion extends StatefulWidget {
  @override
  _UbicacionState createState() => _UbicacionState();
}

class _UbicacionState extends State<Ubicacion> {
bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    permisos();
  }

void permisos() async{
  var status = await Permission.location.status;
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
        title: Text('Permisos de ubicación',
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
              child: Text('Para utilizar nuestra aplicación necesitarás condecer permisos de ubicación',
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
                leading: Icon(Icons.arrow_circle_up),
                title: Text(
                  'Gracias a esos permisos podremos guiarte hacia tu destino',
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
                Text('Permitir acceso a la ubicación',
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
                  var status = await Permission.location.request();
                  if (status.isGranted) {
                    setState(() {
                      isSwitched = value;
                    });
                  } else {
                    // El usuario denegó el permiso de ubicación
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
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}