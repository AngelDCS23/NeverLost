import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neverlost/constants.dart';


class InicioSesion extends StatefulWidget {
  @override
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
    // ignore: unused_field
  String _valor = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // shadowColor: Colors.amber,
        // elevation: 20,
        title: Text('Login NeverLost User',
        style: GoogleFonts.montserrat(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        )),
        backgroundColor: Constantes.backgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 70,
              child: Image.asset('assets/userNeverlost.png'),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 25),
            child: Text('Iniciar Sesión', 
            style: GoogleFonts.montserrat(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Constantes.backgroundColor,
            ),),
            ),
           Container(
            // color: Colors.amber,
            width: 270,
            child: Text('Si ya eres usuario de NeverLost introduce tus credenciales para iniciar sesión',
            textAlign: TextAlign.center,
            style: TextStyle(
            fontSize: 10,
          ),),
           ),
            SizedBox(
                height: 30,
              ),
            Container(
              // color: Colors.lightGreenAccent,
              height: 50,
              width: 350,
              child: TextField(
                 onChanged: (value) {
                // Actualizar el valor cuando cambia el texto
                setState(() {
                  _valor = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Correo electrónico', // Etiqueta del campo de texto
                border: UnderlineInputBorder(), // Estilo del borde
                labelStyle: TextStyle(
                  fontSize: 15
                ),
                contentPadding: EdgeInsets.only(bottom: 0),
              ),
            ),
            ),
            SizedBox(
                height: 30,
              ),
            Container(
              // color: Colors.lightGreenAccent,
              height: 50,
              width: 350,
              child: TextField(
                 onChanged: (value) {
                // Actualizar el valor cuando cambia el texto
                setState(() {
                  _valor = value;
                });
              },
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña', // Etiqueta del campo de texto
                border: UnderlineInputBorder(), // Estilo del borde
                labelStyle: TextStyle(
                  fontSize: 15
                ),
                contentPadding: EdgeInsets.only(bottom: 0),
              ),
            ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 25),
            child:GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, '/olvidoContra');
                  },
                  child: Text(' ¿Has olvidado la contraseña?',
                style: GoogleFonts.montserrat(

                )),
                )),
          Padding(padding: EdgeInsets.symmetric(vertical: 50),
            child: ElevatedButton(onPressed: (){
                Navigator.pushNamed(context, '/registrado');
              },
              style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Constantes.blueSky),
                  ),
               child: Padding(padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
               child: Text('Iniciar Sesión',
               style: TextStyle(
                    color: Constantes.backgroundColor,
                    fontSize: 15
                  ))) 
               ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Text('¿No tienes cuenta?',
                style: GoogleFonts.montserrat(

                ),),
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, '/registro');
                  },
                  child: Text(' Regístrate',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Constantes.backgroundColor,
                )),
                )
                ],
              ),

          

          ],
        ),
      ),
    );
  }
}