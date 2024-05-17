// lib/main.dart

import 'package:flutter/material.dart';
import 'services/api_service.dart'; // Importa las funciones de API
import 'models/usuarios.dart'; // Importa el modelo User

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser(1); // Llama a la función para obtener el usuario con ID 1
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prueba Json'),
      ),
      body: Center(
        child: FutureBuilder<User>(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('Nombre: ${snapshot.data!.nombre}');
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            //Mientras recibe los datos aparecerá el icono de carga
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserPage(),
  ));
}
