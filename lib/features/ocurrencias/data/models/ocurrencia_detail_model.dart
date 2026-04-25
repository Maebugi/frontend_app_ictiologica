class OcurrenciaDetailModel {
  final String idOcurrencia;
  final String idEspecie;
  final String salidaId;
  final DateTime? fechaHora;
  final String? coordenadas;
  final double? altitud;
  final double? esfuerzo;
  final double? cpue;
  final double? longitudPez;
  final double? peso;
  final String? sexo;
  final String? estadoOntogenetico;
  final String? estadioVida;
  final String? condicionReproductiva;
  final String? comportamiento;
  final String? anomalias;
  final String? mortalidad;
  final String? vouchers;
  final int? nivelCerteza;
  final double? anchoCauce;
  final double? profundidadMedia;
  final double? profundidadMaxima;
  final double? caudalVelocidad;
  final String? tipoHabitat;
  final String? microhabitat;
  final double? coberturaDosel;
  final String? usoSueloRibereno;
  final String? estabilidadOrillas;
  final String? sustrato;
  final String? clima;
  final String? metodoCaptura;
  final String? artePesca;
  final String? codigoMuestreo;
  final String? datum;
  final String? observaciones;
  final String? nombreComun;
  final String? nombreCientifico;
  final String? familia;

  OcurrenciaDetailModel({
    required this.idOcurrencia,
    required this.idEspecie,
    required this.salidaId,
    this.fechaHora,
    this.coordenadas,
    this.altitud,
    this.esfuerzo,
    this.cpue,
    this.longitudPez,
    this.peso,
    this.sexo,
    this.estadoOntogenetico,
    this.estadioVida,
    this.condicionReproductiva,
    this.comportamiento,
    this.anomalias,
    this.mortalidad,
    this.vouchers,
    this.nivelCerteza,
    this.anchoCauce,
    this.profundidadMedia,
    this.profundidadMaxima,
    this.caudalVelocidad,
    this.tipoHabitat,
    this.microhabitat,
    this.coberturaDosel,
    this.usoSueloRibereno,
    this.estabilidadOrillas,
    this.sustrato,
    this.clima,
    this.metodoCaptura,
    this.artePesca,
    this.codigoMuestreo,
    this.datum,
    this.observaciones,
    this.nombreComun,
    this.nombreCientifico,
    this.familia,
  });

  factory OcurrenciaDetailModel.fromJson(Map<String, dynamic> json) {
    return OcurrenciaDetailModel(
      idOcurrencia: json['id_ocurrencia'],
      idEspecie: json['id_especie'],
      salidaId: json['salida_id'],
      fechaHora: json['fecha_hora'] != null
          ? DateTime.parse(json['fecha_hora'])
          : null,
      coordenadas: json['coordenadas'],
      altitud: (json['altitud'] as num?)?.toDouble(),
      esfuerzo: (json['esfuerzo'] as num?)?.toDouble(),
      cpue: (json['cpue'] as num?)?.toDouble(),
      longitudPez: (json['longitud_pez'] as num?)?.toDouble(),
      peso: (json['peso'] as num?)?.toDouble(),
      sexo: json['sexo'],
      estadoOntogenetico: json['estado_ontogenetico'],
      estadioVida: json['estadio_vida'],
      condicionReproductiva: json['condicion_reproductiva'],
      comportamiento: json['comportamiento'],
      anomalias: json['anomalias'],
      mortalidad: json['mortalidad'],
      vouchers: json['vouchers'],
      nivelCerteza: json['nivel_certeza'],
      anchoCauce: (json['ancho_cauce'] as num?)?.toDouble(),
      profundidadMedia: (json['profundidad_media'] as num?)?.toDouble(),
      profundidadMaxima: (json['profundidad_maxima'] as num?)?.toDouble(),
      caudalVelocidad: (json['caudal_velocidad'] as num?)?.toDouble(),
      tipoHabitat: json['tipo_habitat'],
      microhabitat: json['microhabitat'],
      coberturaDosel: (json['cobertura_dosel'] as num?)?.toDouble(),
      usoSueloRibereno: json['uso_suelo_ribereno'],
      estabilidadOrillas: json['estabilidad_orillas'],
      sustrato: json['sustrato'],
      clima: json['clima'],
      metodoCaptura: json['metodo_captura'],
      artePesca: json['arte_pesca'],
      codigoMuestreo: json['codigo_muestreo'],
      datum: json['datum'],
      observaciones: json['observaciones'],
      nombreComun: json['nombre_comun'],
      nombreCientifico: json['nombre_cientifico'],
      familia: json['familia'],
    );
  }
}