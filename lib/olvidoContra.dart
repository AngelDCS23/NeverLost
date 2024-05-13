import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neverlost/constants.dart';


class OlvidoContra extends StatefulWidget {
  @override
  _OlvidoContra createState() => _OlvidoContra();
}

class _OlvidoContra extends State<OlvidoContra> {
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
            child: Container(
              width: 300,
              child: Text('Te enviaremos un email para que recuperes tu contraseña', 
              textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Constantes.backgroundColor,
            ),),
            ) 
            
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
          Padding(padding: EdgeInsets.symmetric(vertical: 50),
            child: ElevatedButton(onPressed: (){
                Navigator.pushNamed(context, '/envioMail');
              },
              style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Constantes.blueSky),
                  ),
               child: Padding(padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
               child: Text('Enviar Email',
               style: TextStyle(
                    color: Constantes.backgroundColor,
                    fontSize: 15
                  ))) 
               ),
            ),
            Container(
              height: 250,
            )
          ],
        ),
      ),
    );
  }
}