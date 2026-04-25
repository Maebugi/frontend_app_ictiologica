class LoginRequestModel {
  final String correo;
  final String contrasena;

  LoginRequestModel({
    required this.correo,
    required this.contrasena,
  });

  Map<String, dynamic> toJson() {
    return {
      'correo': correo,
      'contrasena': contrasena,
    };
  }
}