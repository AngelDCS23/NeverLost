import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neverlost/constants.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neverlost/models/login.dart';
import 'package:neverlost/services/api_service.dart'; // Importa el servicio para enviar la solicitud de inicio de sesión
import 'package:shared_preferences/shared_preferences.dart';

class inicio extends StatefulWidget {
  @override
  _inicio createState() => _inicio();
}

class _inicio extends State<inicio> {
  String _email = '';
  String _contrasena = '';
  bool _log = false;

  Future<void> _loadLog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() async {
      _log = prefs.getBool('isLoggedIn') ?? false;
      if (_log) {
        _email = prefs.getString('email') ?? 'Sin mail';
        _contrasena = prefs.getString('password') ?? 'Sin contrasena';
        _login(); 
      }
    });
  }

  Future<void> _login() async {
    try {
      LoginRequest logUser = LoginRequest(
        email: _email,
        contrasena: _contrasena,
      );

      final response = await LoginUser(logUser);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        int idUsu = responseData['id'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', idUsu);
        //Almaceno la información del usuario en un Json.

        await prefs.setString('user_data', jsonEncode(responseData));
      } else {
        print('Error al iniciar sesión: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al iniciar sesión: $error');
    }
  }

  Future<void> eliminarCoordenadas() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('CoordenadasDestino');
  }

  @override
  void initState() {
    super.initState();
    eliminarCoordenadas();
    _loadLog();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushNamed(context, '/pantallaTutorial');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constantes.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'NeverLost',
              style: GoogleFonts.tenorSans(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}























// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:neverlost/constants.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:neverlost/models/login.dart';
// import 'package:neverlost/services/api_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class inicio extends StatefulWidget {
//   @override
//   _inicio createState() => _inicio();
// }

// class _inicio extends State<inicio> {
//   String _email = '';
//   String _contrasena = '';
//   bool _log = false;

//   Future<void> _loadLog() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _log = prefs.getBool('isLoggedIn') ?? false;
//       if (_log) {
//         _email = prefs.getString('email') ?? 'Sin mail';
//         _contrasena = prefs.getString('password') ?? 'Sin contrasena';
//         LoginRequest logUser = LoginRequest(
//           email: _email,
//           contrasena: _contrasena,
//         );
//         print(_email);
//         print(_contrasena);
//       }
      
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadLog(); // Cargar el valor de _log desde SharedPreferences
    
//     Future.delayed(Duration(seconds: 2), () {
//       Navigator.pushNamed(context, '/pantallaTutorial');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Constantes.backgroundColor,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'NeverLost',
//               style: GoogleFonts.tenorSans(
//                 color: Colors.white,
//                 fontSize: 25,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// // class _inicio extends State<inicio> {

// //   String _email = '';
// //   String _contrasena = '';
// //   bool _log = false;

// //   Future<void> _loadLog() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _log = prefs.getBool('isLoggedIn') ?? false;
// //     });
// //   }

// //   Future<void> _loadEmail() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _email = prefs.getString('email') ?? 'Sin mail';
// //     });
// //   }

// //   Future<void> _loadContrasena() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _contrasena = prefs.getString('contrasena') ?? 'Sin contrasena';
// //     });
// //   }


// //   @override
// //   void initState() {
// //     super.initState();
// //   _loadLog(); // Cargar el valor de _log desde SharedPreferences
// //     if(_log == true){
// //       LoginRequest logUser = LoginRequest(
// //                     email: _email,
// //                     contrasena: _contrasena,
// //                   );
// //                   print(_email);
// //     }
    
// //     Future.delayed(Duration(seconds: 2), () {
// //       Navigator.pushNamed(context, '/pantallaTutorial');

// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Constantes.backgroundColor,
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             Text('NeverLost',
// //             style: GoogleFonts.tenorSans(
// //               color: Colors.white,
// //               fontSize: 25,
// //               fontWeight: FontWeight.w600
// //             ),)
// //             // SizedBox(
// //             //   height: 200.0,
// //             //   width: 350.0,
// //             //   child: SvgPicture.asset(
// //             //     'assets/NeverLost.svg',
// //             //     width: 200, // ajusta el ancho según sea necesario
// //             //     height: 200, // ajusta la altura según sea necesario
// //             //   ),
// //             // ),
// //             // SizedBox(
// //             //   height: 20,
// //             // ), 
// //             // Text('NeverLost',
// //             //   style: GoogleFonts.montserrat(
// //             //     fontSize: 35,
// //             //     color: Colors.white,
// //             //     fontWeight: FontWeight.w600
// //             //   ),
// //             // ),
// //             // SizedBox(
// //             //   height: 30,
// //             // ),   
// //             // LoadingAnimationWidget.staggeredDotsWave(
// //             // color: Colors.white,
// //             // size: 40,
// //             // ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
