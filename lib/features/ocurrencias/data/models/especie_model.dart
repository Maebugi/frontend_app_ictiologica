class EspecieModel {
  final String especieId;
  final String? nombreCientifico;
  final String? nombreComun;
  final String? orden;
  final String? familia;
  final double? longitudEstandar;
  final double? tallaMaxima;
  final double? pesoMaximo;
  final int? longevidad;
  final String? habitoAlimenticio;
  final String? reproductivo;
  final String? periodoReproductivo;
  final String? estadoConservacion;
  final String? descripcion;

  EspecieModel({
    required this.especieId,
    this.nombreCientifico,
    this.nombreComun,
    this.orden,
    this.familia,
    this.longitudEstandar,
    this.tallaMaxima,
    this.pesoMaximo,
    this.longevidad,
    this.habitoAlimenticio,
    this.reproductivo,
    this.periodoReproductivo,
    this.estadoConservacion,
    this.descripcion,
  });

  factory EspecieModel.fromJson(Map<String, dynamic> json) {
    return EspecieModel(
      especieId: json['especie_id']?.toString() ?? '',
      nombreCientifico: json['nombre_cientifico'],
      nombreComun: json['nombre_comun'],
      orden: json['orden'],
      familia: json['familia'],

      longitudEstandar:
          (json['longitud_estandar'] as num?)?.toDouble(),

      tallaMaxima:
          (json['talla_maxima'] as num?)?.toDouble(),

      pesoMaximo:
          (json['peso_maximo'] as num?)?.toDouble(),

      longevidad:
          (json['longevidad'] as num?)?.toInt(),

      habitoAlimenticio:
          json['habito_alimenticio'],

      reproductivo:
          json['reproductivo'],

      periodoReproductivo:
          json['periodo_reproductivo'],

      estadoConservacion:
          json['estado_conservacion'],

      descripcion:
          json['descripcion'],
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