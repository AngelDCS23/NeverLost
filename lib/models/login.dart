class LoginRequest {
  final String email;
  final String contrasena;

  LoginRequest({required this.email, required this.contrasena});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'contrasena': contrasena,
    };
  }
}
