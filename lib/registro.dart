import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neverlost/constants.dart';

class Registro extends StatefulWidget {
  @override
  _Registro createState() => _Registro();
}

class _Registro extends State<Registro> {
  // ignore: unused_field
  String _valor = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // shadowColor: Colors.amber,
        // elevation: 20,
        title: Text('Registro NeverLost User',
        style: GoogleFonts.montserrat(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        )),
        backgroundColor: Constantes.backgroundColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child:Container(
            child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.symmetric(vertical: 20),
              child: Container(
                width: 350,
              // color: Colors.amber,
              height: 70,
              child: Column(
                children: <Widget>[
                  Text('Crear una nueva cuenta',
                  style: GoogleFonts.montserrat(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('Todos los campos son obligatorios'),)
                ],
              )
              ),
            ),
            Container(
              // color: Colors.grey,
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
                labelText: 'Nombre *', // Etiqueta del campo de texto
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
              decoration: InputDecoration(
                labelText: 'Apellidos *', // Etiqueta del campo de texto
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
              decoration: InputDecoration(
                labelText: 'Correo electrónico *', // Etiqueta del campo de texto
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
                labelText: 'Contraseña *', // Etiqueta del campo de texto
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
                labelText: 'Confirmar contraseña *', // Etiqueta del campo de texto
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
              decoration: InputDecoration(
                labelText: 'Teléfono móvil *', // Etiqueta del campo de texto
                border: UnderlineInputBorder(), // Estilo del borde
                labelStyle: TextStyle(
                  fontSize: 15
                ),
                contentPadding: EdgeInsets.only(bottom: 0),
              ),
            ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 70),
            child: ElevatedButton(onPressed: (){
                Navigator.pushNamed(context, '/registrado');
              },
              style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Constantes.blueSky),
                  ),
               child: Text('Crear Cuenta',
               style: TextStyle(
                    color: Constantes.backgroundColor,
                    fontSize: 15
                  ))),
            ),
            
            Container(
              color: Colors.deepOrange,
              
            ),
            ],
          ),
          )
          ),
      )
      
    );
  }
}