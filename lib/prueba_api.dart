// lib/main.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/api_service.dart'; // Importa las funciones de API
import 'models/usuarios.dart'; // Importa el modelo User

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<User> futureUser;
  late int _idUsu = 0;
  bool _isIdLoaded = false;

  Future<void> _ObtenerIdUsu() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUsu = prefs.getInt('user_id') ?? 0;
      _isIdLoaded = true;
      futureUser = fetchUser(_idUsu); // Llama a la función para obtener el usuario con ID que obtine de la sharedPreference
    });
  }

  @override
  void initState() {
    super.initState();
    _ObtenerIdUsu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prueba Json'),
      ),
      body: Center(
        child: _isIdLoaded
            ? FutureBuilder<User>(
                future: futureUser,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Text('Nombre: ${snapshot.data!.nombre}');
                  } else {
                    return Text('No se encontró el usuario');
                  }
                },
              )
            : CircularProgressIndicator(), // Mostrar indicador mientras se carga el ID
      ),
    );
  }
}
void main() {
  runApp(MaterialApp(
    home: UserPage(),
  ));
}
