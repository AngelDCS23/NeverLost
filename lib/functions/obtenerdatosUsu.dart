import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class obtenerdatosUsu{
    String nombre = '';
    String apellidos = '';
    String email = '';
    String telefono = '';
    String userDataString = '';

  Future<void> AsignarInfo() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userDataString = prefs.getString('user_data')!;
    
    if (userDataString.isNotEmpty) {
    Map<String, dynamic> userData = jsonDecode(userDataString);
    print('Llega aquí');
    
    nombre = userData['nombre'];
    apellidos = userData['apellidos'];
    email = userData['email'];
    telefono = userData['telefono'];

  } else {
    print('No se encontraron datos de usuario');
  }
  }
}
