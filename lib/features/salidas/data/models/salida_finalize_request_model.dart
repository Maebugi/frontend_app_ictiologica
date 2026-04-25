class SalidaFinalizeRequestModel {
  final DateTime? fechaFin;
  final String? observaciones;

  SalidaFinalizeRequestModel({
    this.fechaFin,
    this.observaciones,
  });

  Map<String, dynamic> toJson() {
    return {
      'fecha_fin': fechaFin?.toIso8601String(),
      'observaciones': observaciones,
    };
  }
}