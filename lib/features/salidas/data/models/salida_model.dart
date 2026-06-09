class SalidaModel {
  final String salidaId;
  final String idUsuario;
  final String? nombreLugar;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final String? observaciones;
  final String estado;
  final String? nombreProyecto;

  SalidaModel({
    required this.salidaId,
    required this.idUsuario,
    this.nombreLugar,
    this.fechaInicio,
    this.fechaFin,
    this.observaciones,
    this.nombreProyecto,
    required this.estado,
  });

  factory SalidaModel.fromJson(Map<String, dynamic> json) {
    return SalidaModel(
      salidaId: json['salida_id'],
      idUsuario: json['id_usuario'],
      nombreLugar: json['nombre_lugar'],
      nombreProyecto: json['nombre_proyecto'],
      fechaInicio: json['fecha_inicio'] != null
          ? DateTime.parse(json['fecha_inicio'])
          : null,
      fechaFin: json['fecha_fin'] != null
          ? DateTime.parse(json['fecha_fin'])
          : null,
      observaciones: json['observaciones'],
      estado: json['estado'] ?? 'abierta',
    );
  }
}