class MedicionCreateRequestModel {
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

  MedicionCreateRequestModel({
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

  Map<String, dynamic> toJson() {
    return {
      'medicion_id': medicionId,
      'ocurrencia_id': ocurrenciaId,
      'oxigeno_disuelto_mg_l': oxigenoDisueltoMgL,
      'ph': ph,
      'turbidez_ntu': turbidezNtu,
      'conductividad_us_cm': conductividadUsCm,
      'tds_mg_l': tdsMgL,
      'temperatura_c': temperaturaC,
      'transparencia_secchi_cm': transparenciaSecchiCm,
      'nivel_estado_agua': nivelEstadoAgua,
      'orp_mv': orpMv,
      'alcalinidad_mg_l': alcalinidadMgL,
      'dureza_mg_l': durezaMgL,
      'salinidad': salinidad,
      'amonio_mg_l': amonioMgL,
      'fosforo_metales_mg_l': fosforoMetalesMgL,
      'nitratos_mg_l': nitratosMgL,
      'nitritos_mg_l': nitritosMgL,
      'fosfatos_mg_l': fosfatosMgL,
      'clorofila_a_ug_l': clorofilaAUgL,
      'sst_mg_l': sstMgL,
      'coliformes_fecales_ufc': coliformesFecalesUfc,
      'observaciones': observaciones,
    };
  }
}