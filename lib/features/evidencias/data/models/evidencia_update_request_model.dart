class EvidenciaUpdateRequestModel {
  final String? observaciones;

  EvidenciaUpdateRequestModel({
    this.observaciones,
  });

  Map<String, dynamic> toJson() {
    return {
      'observaciones': observaciones,
    };
  }
}