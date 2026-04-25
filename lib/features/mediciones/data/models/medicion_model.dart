class MedicionModel {
  final String medicionId;
  final String ocurrenciaId;
  final double? oxigenoDisueltoMgL;
  final double? ph;
  final double? turbidezNtu;
  final double? conductividadUsCm;
  final double? tdsMgL;
  final double? temperaturaC;
  final double? transparenciaSecchiCm;
  final String? nivelEstadoAgua;
  final double? orpMv;
  final double? alcalinidadMgL;
  final double? durezaMgL;
  final double? salinidad;
  final double? amonioMgL;
  final double? fosforoMetalesMgL;
  final double? nitratosMgL;
  final double? nitritosMgL;
  final double? fosfatosMgL;
  final double? clorofilaAUgL;
  final double? sstMgL;
  final int? coliformesFecalesUfc;
  final String? observaciones;

  // ✅ ESTE CONSTRUCTOR NO LO BORRES
  MedicionModel({
    required this.medicionId,
    required this.ocurrenciaId,
    this.oxigenoDisueltoMgL,
    this.ph,
    this.turbidezNtu,
    this.conductividadUsCm,
    this.tdsMgL,
    this.temperaturaC,
    this.transparenciaSecchiCm,
    this.nivelEstadoAgua,
    this.orpMv,
    this.alcalinidadMgL,
    this.durezaMgL,
    this.salinidad,
    this.amonioMgL,
    this.fosforoMetalesMgL,
    this.nitratosMgL,
    this.nitritosMgL,
    this.fosfatosMgL,
    this.clorofilaAUgL,
    this.sstMgL,
    this.coliformesFecalesUfc,
    this.observaciones,
  });

  // ✅ FUNCIONES DENTRO DE LA CLASE
  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  // ✅ FROM JSON CORREGIDO
  factory MedicionModel.fromJson(Map<String, dynamic> json) {
    return MedicionModel(
      medicionId: json['medicion_id'],
      ocurrenciaId: json['ocurrencia_id'],
      oxigenoDisueltoMgL: _toDouble(json['oxigeno_disuelto_mg_l']),
      ph: _toDouble(json['ph']),
      turbidezNtu: _toDouble(json['turbidez_ntu']),
      conductividadUsCm: _toDouble(json['conductividad_us_cm']),
      tdsMgL: _toDouble(json['tds_mg_l']),
      temperaturaC: _toDouble(json['temperatura_c']),
      transparenciaSecchiCm: _toDouble(json['transparencia_secchi_cm']),
      nivelEstadoAgua: json['nivel_estado_agua'],
      orpMv: _toDouble(json['orp_mv']),
      alcalinidadMgL: _toDouble(json['alcalinidad_mg_l']),
      durezaMgL: _toDouble(json['dureza_mg_l']),
      salinidad: _toDouble(json['salinidad']),
      amonioMgL: _toDouble(json['amonio_mg_l']),
      fosforoMetalesMgL: _toDouble(json['fosforo_metales_mg_l']),
      nitratosMgL: _toDouble(json['nitratos_mg_l']),
      nitritosMgL: _toDouble(json['nitritos_mg_l']),
      fosfatosMgL: _toDouble(json['fosfatos_mg_l']),
      clorofilaAUgL: _toDouble(json['clorofila_a_ug_l']),
      sstMgL: _toDouble(json['sst_mg_l']),
      coliformesFecalesUfc: _toInt(json['coliformes_fecales_ufc']),
      observaciones: json['observaciones'],
    );
  }
}