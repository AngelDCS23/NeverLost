import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neverlost/constants.dart';
import 'package:neverlost/models/usuarios.dart';
import 'package:neverlost/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neverlost/functions/obtenerdatosUsu.dart';

class Perfil extends StatefulWidget {
  const Perfil({ Key? key }) : super(key: key);

  @override
  _Perfil createState() => _Perfil();
}

class _Perfil extends State<Perfil> {

  late Future<User> futureUser;
  late int _idUsu = 0;
  bool _isIdLoaded = false;
  obtenerdatosUsu obtener = new obtenerdatosUsu();

  Future<void> _ObtenerIdUsu() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUsu = prefs.getInt('user_id') ?? 0;
      _isIdLoaded = true;
      futureUser = fetchUser(_idUsu); // Llama a la función para obtener el usuario con ID que obtine de la sharedPreference
    });
  }

//Con esto me aseguro de que los datos se muestran en cuanto entras en la pantalla.
  @override
  void initState() {
    super.initState();
    obtener.AsignarInfo().then((_) {
      setState(() {
        _isIdLoaded = false;
      });
    });
  }

  
  bool _log = false;

  Future<void> _Log() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _log = prefs.getBool('isLoggedIn') ?? false;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Mi Perfil',
          style: GoogleFonts.montserrat(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Constantes.backgroundColor,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child:Container(
            child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child:Text('Desde aquí podrás modificar tus datos personales',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),),),
              Container(
                    color: Constantes.backgroundColor,
                    width: MediaQuery.of(context).size.width,
                    child: Text('Nombre',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                Container(
              // color: Colors.lightGreenAccent,
              height: 50,
              width: 350,
              child: TextField(
                // controller: _apellidosController,
                 onChanged: (value) {
                // Actualizar el valor cuando cambia el texto
                // setState(() {
                //   _valor = value;
                // });
              },
              decoration: InputDecoration(
                labelText: obtener.nombre, // Etiqueta del campo de texto
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
                    color: Constantes.backgroundColor,
                    width: MediaQuery.of(context).size.width,
                    child: Text('Apellidos',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
              
            Container(
              // color: Colors.lightGreenAccent,
              height: 50,
              width: 350,
              child: TextField(
                // controller: _apellidosController,
                 onChanged: (value) {
                // Actualizar el valor cuando cambia el texto
                // setState(() {
                //   _valor = value;
                // });
              },
              decoration: InputDecoration(
                labelText: obtener.apellidos, // Etiqueta del campo de texto
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
                    color: Constantes.backgroundColor,
                    width: MediaQuery.of(context).size.width,
                    child: Text('Correo electrónico',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
            Container(
              // color: Colors.lightGreenAccent,
              height:50,
              width: 350,
              child: TextField(
                // controller: _emailController,
                 onChanged: (value) {
                // Actualizar el valor cuando cambia el texto
                // setState(() {
                //   _valor = value;
                // });
              },
              decoration: InputDecoration(
                labelText: obtener.email, // Etiqueta del campo de texto
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
                    color: Constantes.backgroundColor,
                    width: MediaQuery.of(context).size.width,
                    child: Text('Numero de teléfono',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
            Container(
              // color: Colors.lightGreenAccent,
              height: 50,
              width: 350,
              child: TextField(
                // controller: _telefonoController,
                 onChanged: (value) {
                // Actualizar el valor cuando cambia el texto
                // setState(() {
                //   _valor = value;
                // });
              },
              decoration: InputDecoration(
                labelText: obtener.telefono, // Etiqueta del campo de texto
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
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/cambiarContraseña');
                },
                child: Text('Cambiar contraseña',
                style: GoogleFonts.montserrat(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                )),
              )
            ),
            // SizedBox(
            //     height: 30,
            //   ),
            Container(
              // color: Colors.lightGreenAccent,
              height: 50,
              width: 350,
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/borrarCuenta');
                },
                child: Text('BorrarCuenta',
                style: GoogleFonts.montserrat(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                )),
              )
              
            ),

            Padding(padding: EdgeInsets.only(top: 40),
            child: ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, '/menu');
            }, child: Text('Guardar',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
            style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Constantes.backgroundColor),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Cambia el radio del borde aquí
                  ),
                  ),),)),
            
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