class OcurrenciaCreateRequestModel {
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
  final String? dinamicaAgua;
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

  //local
  final String? nombreComun;
  final String? nombreCientifico;
  final String? familia;


  OcurrenciaCreateRequestModel({
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
    this.dinamicaAgua,
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

    //local
    this.nombreComun,
    this.nombreCientifico,
    this.familia,

  });

  Map<String, dynamic> toJson() {
    return {
      'id_ocurrencia': idOcurrencia,
      'id_especie': idEspecie,
      'salida_id': salidaId,
      'fecha_hora': fechaHora?.toIso8601String(),
      'coordenadas': coordenadas,
      'altitud': altitud,
      'esfuerzo': esfuerzo,
      'cpue': cpue,
      'longitud_pez': longitudPez,
      'peso': peso,
      'sexo': sexo,
      'estado_ontogenetico': estadoOntogenetico,
      'estadio_vida': estadioVida,
      'condicion_reproductiva': condicionReproductiva,
      'comportamiento': comportamiento,
      'anomalias': anomalias,
      'mortalidad': mortalidad,
      'vouchers': vouchers,
      'nivel_certeza': nivelCerteza,
      'ancho_cauce': anchoCauce,
      'profundidad_media': profundidadMedia,
      'profundidad_maxima': profundidadMaxima,
      'caudal_velocidad': caudalVelocidad,
      'tipo_habitat': tipoHabitat,
      'dinamica_agua': dinamicaAgua,
      'microhabitat': microhabitat,
      'cobertura_dosel': coberturaDosel,
      'uso_suelo_ribereno': usoSueloRibereno,
      'estabilidad_orillas': estabilidadOrillas,
      'sustrato': sustrato,
      'clima': clima,
      'metodo_captura'  : metodoCaptura,
      'arte_pesca': artePesca,
      'codigo_muestreo': codigoMuestreo,
      'datum': datum,
      'observaciones': observaciones,
    };
  }
}