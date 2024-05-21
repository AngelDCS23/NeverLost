import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neverlost/constants.dart';

class CambiarContrasena extends StatefulWidget {
  const CambiarContrasena({ Key? key }) : super(key: key);

  @override
  _CambiarContrasena createState() => _CambiarContrasena();
}

class _CambiarContrasena extends State<CambiarContrasena> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Cambiar Contraseña',
          style: GoogleFonts.montserrat(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Constantes.backgroundColor,
      ),
      backgroundColor: Constantes.blueSky,
      body: Center(
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 50,
              width: 350,
              child: TextField(
                // controller: _emailController,
                // onChanged: (value) {
                //   setState(() {
                //     _valor = value;
                //   });
                // },
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  border: UnderlineInputBorder(),
                  labelStyle: TextStyle(fontSize: 15),
                  contentPadding: EdgeInsets.only(bottom: 0),
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: 50,
              width: 350,
              child: TextField(
                // controller: _contrasenaController,
                // onChanged: (value) {
                //   setState(() {
                //     _valor = value;
                //   });
                // },
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: UnderlineInputBorder(),
                  labelStyle: TextStyle(fontSize: 15),
                  contentPadding: EdgeInsets.only(bottom: 0),
                ),
              ),
            ),
          ]
        ),)
        
      ),
    );
  }
}