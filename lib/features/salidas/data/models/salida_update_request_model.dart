class SalidaUpdateRequestModel {
  final String? nombreLugar;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final String? observaciones;
  final String? estado;

  SalidaUpdateRequestModel({
    this.nombreLugar,
    this.fechaInicio,
    this.fechaFin,
    this.observaciones,
    this.estado,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre_lugar': nombreLugar,
      'fecha_inicio': fechaInicio?.toIso8601String(),
      'fecha_fin': fechaFin?.toIso8601String(),
      'observaciones': observaciones,
      'estado': estado,
    };
  }
}