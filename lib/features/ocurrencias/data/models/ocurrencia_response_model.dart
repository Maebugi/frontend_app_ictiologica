class OcurrenciaResponseModel {
  final String idOcurrencia;
  final String idEspecie;
  final String salidaId;

  OcurrenciaResponseModel({
    required this.idOcurrencia,
    required this.idEspecie,
    required this.salidaId,
  });

  factory OcurrenciaResponseModel.fromJson(Map<String, dynamic> json) {
    return OcurrenciaResponseModel(
      idOcurrencia: json['id_ocurrencia'],
      idEspecie: json['id_especie'],
      salidaId: json['salida_id'],
    );
  }
}