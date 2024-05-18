import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neverlost/models/usuarios.dart';
import 'package:neverlost/models/login.dart';

Future<User> fetchUser(int id) async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/usuarios/$id'));

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load user');
  }
}

Future<http.Response> LoginUser(LoginRequest LogUser) async{
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8080/api/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(LogUser.toJson()),
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Failed to Login user');
  }
}

Future<http.Response> createUser(User user) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8080/api/usuarios'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(user.toJson()),
  );

  if (response.statusCode == 201) {
    return response;
  } else {
    throw Exception('Failed to create user');
  }
}
