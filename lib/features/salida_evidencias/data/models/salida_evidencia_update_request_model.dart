class SalidaEvidenciaUpdateRequestModel {
  final String? observaciones;

  SalidaEvidenciaUpdateRequestModel({
    this.observaciones,
  });

  Map<String, dynamic> toJson() {
    return {
      'observaciones': observaciones,
    };
  }
}