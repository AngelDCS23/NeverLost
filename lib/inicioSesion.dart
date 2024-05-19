import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neverlost/constants.dart';
import 'package:neverlost/models/login.dart';
import 'package:neverlost/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InicioSesion extends StatefulWidget {
  @override
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contrasenaController = TextEditingController();


  // ignore: unused_field
  String _valor = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Login NeverLost User',
          style: GoogleFonts.montserrat(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Text(
                'Iniciar Sesión',
                style: GoogleFonts.montserrat(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Constantes.backgroundColor,
                ),
              ),
            ),
            Container(
              width: 270,
              child: Text(
                'Si ya eres usuario de NeverLost introduce tus credenciales para iniciar sesión',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: 50,
              width: 350,
              child: TextField(
                controller: _emailController,
                onChanged: (value) {
                  setState(() {
                    _valor = value;
                  });
                },
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
                controller: _contrasenaController,
                onChanged: (value) {
                  setState(() {
                    _valor = value;
                  });
                },
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: UnderlineInputBorder(),
                  labelStyle: TextStyle(fontSize: 15),
                  contentPadding: EdgeInsets.only(bottom: 0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/olvidoContra');
                },
                child: Text(
                  ' ¿Has olvidado la contraseña?',
                  style: GoogleFonts.montserrat(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: ElevatedButton(
                onPressed: () {
                  LoginRequest logUser = LoginRequest(
                    email: _emailController.text,
                    contrasena: _contrasenaController.text,
                  );

                  LoginUser(logUser).then((response) async {
                    if (response.statusCode == 200 || response.statusCode == 201) {
                      print('Log correcto');

                      SharedPreferences _login = await SharedPreferences.getInstance();

                      await _login.setBool('isLoggedIn', true);
                      await _login.setString('email', _emailController.text);
                      final String? email = _login.getString('email');
                      print(email);

                      await _login.setString('password', _contrasenaController.text);

                      Navigator.pushNamed(context, '/menu');
                    } else {
                      print('no ha obtenido respuesta');
                    }
                  }).catchError((error) {
                    print('error?');
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Constantes.blueSky),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      color: Constantes.backgroundColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '¿No tienes cuenta?',
                  style: GoogleFonts.montserrat(),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/registro');
                  },
                  child: Text(
                    ' Regístrate',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Constantes.backgroundColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
