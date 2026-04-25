class UserModel {
  final String usuarioId;
  final String? nombre;
  final String? correo;

  UserModel({
    required this.usuarioId,
    this.nombre,
    this.correo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      usuarioId: json['usuario_id'],
      nombre: json['nombre'],
      correo: json['correo'],
    );
  }
}