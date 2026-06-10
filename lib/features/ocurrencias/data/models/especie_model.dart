class EspecieModel {
  final String especieId;
  final String? nombreCientifico;
  final String? nombreComun;
  final String? orden;
  final String? familia;
  final String? estadoConservacion;

  EspecieModel({
    required this.especieId,
    this.nombreCientifico,
    this.nombreComun,
    this.orden,
    this.familia,
    this.estadoConservacion,
  });

  factory EspecieModel.fromJson(Map<String, dynamic> json) {
    return EspecieModel(
      especieId: json['especie_id'],
      nombreCientifico: json['nombre_cientifico'],
      nombreComun: json['nombre_comun'],
      orden: json['orden'],
      familia: json['familia'],
      estadoConservacion: json['estado_conservacion'],
    );
  }

  String get displayName {
    if (nombreCientifico != null &&
        nombreCientifico!.trim().isNotEmpty) {
      return nombreCientifico!;
    }

    return nombreComun ?? 'Especie sin nombre';
  }
}