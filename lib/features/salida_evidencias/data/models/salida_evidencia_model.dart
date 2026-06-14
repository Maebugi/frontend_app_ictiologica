class SalidaEvidenciaModel {
  final String idFoto;
  final String salidaId;
  final String? ruta;
  final String? tipoArchivo;
  final String? observaciones;

  SalidaEvidenciaModel({
    required this.idFoto,
    required this.salidaId,
    this.ruta,
    this.tipoArchivo,
    this.observaciones,
  });

  factory SalidaEvidenciaModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SalidaEvidenciaModel(
      idFoto: json['id_foto'],
      salidaId: json['salida_id'],
      ruta: json['ruta'],
      tipoArchivo: json['tipo_archivo'],
      observaciones: json['observaciones'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_foto': idFoto,
      'salida_id': salidaId,
      'ruta': ruta,
      'tipo_archivo': tipoArchivo,
      'observaciones': observaciones,
    };
  }
}