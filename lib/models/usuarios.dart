class User {
  final String nombre;
  final String apellidos;
  final String email;
  final String contrasena;
  final String telefono;

  User({required this.nombre, required this.apellidos, required this.email, required this.contrasena, required this.telefono});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      email: json['email'],
      contrasena: json['contrasena'],
      telefono: json['telefono'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellidos': apellidos,
      'email': email,
      'contrasena': contrasena,
      'telefono': telefono,
    };
  }
}