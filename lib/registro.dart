import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:neverlost/constants.dart';
import 'package:neverlost/models/usuarios.dart';
import 'package:neverlost/services/api_service.dart';

class Registro extends StatefulWidget {
  @override
  _Registro createState() => _Registro();
}

class _Registro extends State<Registro> {
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidosController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contrasenaController = TextEditingController();
  TextEditingController _repContraController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  // ignore: unused_field
  String _valor = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
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
              height: 50,
              width: 350,
              child: TextField(
                controller: _nombreController,
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
                controller: _apellidosController,
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
                controller: _emailController,
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
                controller: _contrasenaController,
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
              controller: _repContraController,
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
                controller: _telefonoController,
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
            child: ElevatedButton(
              onPressed: (){
                if(_repContraController.text == _contrasenaController.text){
                  User user = User(
                  nombre: _nombreController.text,
                  apellidos: _apellidosController.text,
                  email: _emailController.text,
                  contrasena: _contrasenaController.text,
                  telefono: _telefonoController.text
                );

                createUser(user).then((response) {
                  // Maneja la respuesta según el código de estado
                  if (response.statusCode == 201) {
                    // Éxito: usuario creado correctamente
                    
                  } else {
                    // Error: no se pudo crear el usuario
                    // Muestra un mensaje de error o toma la acción adecuada
                  }
                }).catchError((error) {
                  // Maneja cualquier error que pueda ocurrir durante la solicitud
                  // Muestra un mensaje de error o toma la acción adecuada
                });
                Navigator.pushNamed(context, '/pantallaTutorial');
                }else{
                  print('No Coinciden');
                }
                
              },
              
              style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Constantes.blueSky),
                  ),
               child:  Padding(padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
               child: Text('Crear cuenta',
               style: TextStyle(
                    color: Constantes.backgroundColor,
                    fontSize: 15
                  ))) 
               ),
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