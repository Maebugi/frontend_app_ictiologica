class OcurrenciaListItemModel {
  final String idOcurrencia;
  final String idEspecie;
  final DateTime? fechaHora;
  final String? sexo;
  final double? longitudPez;
  final double? peso;
  final String? observaciones;
  final String? nombreComun;
  final String? nombreCientifico;
  final String? familia;

  OcurrenciaListItemModel({
    required this.idOcurrencia,
    required this.idEspecie,
    this.fechaHora,
    this.sexo,
    this.longitudPez,
    this.peso,
    this.observaciones,
    this.nombreComun,
    this.nombreCientifico,
    this.familia,
  });

  factory OcurrenciaListItemModel.fromJson(Map<String, dynamic> json) {
    return OcurrenciaListItemModel(
      idOcurrencia: json['id_ocurrencia'],
      idEspecie: json['id_especie'],
      fechaHora: json['fecha_hora'] != null
          ? DateTime.parse(json['fecha_hora'])
          : null,
      sexo: json['sexo'],
      longitudPez: (json['longitud_pez'] as num?)?.toDouble(),
      peso: (json['peso'] as num?)?.toDouble(),
      observaciones: json['observaciones'],
      nombreComun: json['nombre_comun'],
      nombreCientifico: json['nombre_cientifico'],
      familia: json['familia'],
    );
  }
}