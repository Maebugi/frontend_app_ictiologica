class RegisterRequestModel {
  final String nombre;
  final String correo;
  final String contrasena;
  final String? institucion;

  RegisterRequestModel({
    required this.nombre,
    required this.correo,
    required this.contrasena,
    this.institucion,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'correo': correo,
      'contrasena': contrasena,
      'institucion': institucion,
    };
  }
}