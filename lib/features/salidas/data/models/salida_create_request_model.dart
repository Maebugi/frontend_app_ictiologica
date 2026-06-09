class SalidaCreateRequestModel {
  final String salidaId;
  final String? nombreLugar;
  final String? nombreProyecto;
  final DateTime? fechaInicio;
  final String? observaciones;

  SalidaCreateRequestModel({
    required this.salidaId,
    this.nombreLugar,
    this.nombreProyecto,
    this.fechaInicio,
    this.observaciones,
  });

  Map<String, dynamic> toJson() {
    return {
      'salida_id': salidaId,
      'nombre_lugar': nombreLugar,
      'nombre_proyecto': nombreProyecto,
      'fecha_inicio': fechaInicio?.toIso8601String(),
      'observaciones': observaciones,
    };
  }
}