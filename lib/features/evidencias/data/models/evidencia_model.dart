class EvidenciaModel {
  final String idFoto;
  final String idOcurrencia;
  final String? ruta;
  final String? observaciones;

  EvidenciaModel({
    required this.idFoto,
    required this.idOcurrencia,
    this.ruta,
    this.observaciones,
  });

  factory EvidenciaModel.fromJson(Map<String, dynamic> json) {
    return EvidenciaModel(
      idFoto: json['id_foto'],
      idOcurrencia: json['id_ocurrencia'],
      ruta: json['ruta'],
      observaciones: json['observaciones'],
    );
  }
}