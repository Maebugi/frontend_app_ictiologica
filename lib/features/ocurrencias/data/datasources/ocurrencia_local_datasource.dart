import 'package:sqflite/sqflite.dart';

import 'package:frontend/app/core/db/app_database.dart';
import 'package:frontend/app/core/db/db_constants.dart';
import 'package:frontend/app/core/sync/sync_status.dart';
import '../models/ocurrencia_detail_model.dart';
import '../models/ocurrencia_list_item_model.dart';

class OcurrenciaLocalDatasource {
  Future<void> saveOcurrencia(
    OcurrenciaDetailModel ocurrencia, {
    required String syncStatus,
  }) async {
    final db = await AppDatabase.database;

    await db.insert(
      DBConstants.ocurrenciasTable,
      {
        'id_ocurrencia': ocurrencia.idOcurrencia,
        'salida_id': ocurrencia.salidaId,
        'id_especie': ocurrencia.idEspecie,
        'fecha_hora': ocurrencia.fechaHora?.toIso8601String(),
        'coordenadas': ocurrencia.coordenadas,
        'altitud': ocurrencia.altitud,
        'esfuerzo': ocurrencia.esfuerzo,
        'cpue': ocurrencia.cpue,
        'longitud_pez': ocurrencia.longitudPez,
        'peso': ocurrencia.peso,
        'sexo': ocurrencia.sexo,
        'estado_ontogenetico': ocurrencia.estadoOntogenetico,
        'estadio_vida': ocurrencia.estadioVida,
        'condicion_reproductiva': ocurrencia.condicionReproductiva,
        'comportamiento': ocurrencia.comportamiento,
        'anomalias': ocurrencia.anomalias,
        'mortalidad': ocurrencia.mortalidad,
        'vouchers': ocurrencia.vouchers,
        'nivel_certeza': ocurrencia.nivelCerteza,
        'ancho_cauce': ocurrencia.anchoCauce,
        'profundidad_media': ocurrencia.profundidadMedia,
        'profundidad_maxima': ocurrencia.profundidadMaxima,
        'caudal_velocidad': ocurrencia.caudalVelocidad,
        'tipo_habitat': ocurrencia.tipoHabitat,
        'dinamica_agua' : ocurrencia.dinamicaAgua,
        'microhabitat': ocurrencia.microhabitat,
        'cobertura_dosel': ocurrencia.coberturaDosel,
        'uso_suelo_ribereno': ocurrencia.usoSueloRibereno,
        'estabilidad_orillas': ocurrencia.estabilidadOrillas,
        'sustrato': ocurrencia.sustrato,
        'clima': ocurrencia.clima,
        'metodo_captura': ocurrencia.metodoCaptura,
        'arte_pesca': ocurrencia.artePesca,
        'codigo_muestreo': ocurrencia.codigoMuestreo,
        'datum': ocurrencia.datum,
        'observaciones': ocurrencia.observaciones,
        'nombre_comun': ocurrencia.nombreComun,
        'nombre_cientifico': ocurrencia.nombreCientifico,
        'familia': ocurrencia.familia,
        'sync_status': syncStatus,
        'is_deleted': 0,
        'updated_at_local': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<OcurrenciaListItemModel>> getOcurrenciasBySalida(String salidaId) async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.ocurrenciasTable,
      where: 'salida_id = ? AND is_deleted = 0',
      whereArgs: [salidaId],
      orderBy: 'updated_at_local DESC',
    );

    return rows.map((json) {
      return OcurrenciaListItemModel(
        idOcurrencia: json['id_ocurrencia'] as String,
        idEspecie: json['id_especie'] as String,
        fechaHora: json['fecha_hora'] != null
            ? DateTime.parse(json['fecha_hora'] as String)
            : null,
        sexo: json['sexo'] as String?,
        longitudPez: (json['longitud_pez'] as num?)?.toDouble(),
        peso: (json['peso'] as num?)?.toDouble(),
        observaciones: json['observaciones'] as String?,
        nombreComun: json['nombre_comun'] as String?,
        nombreCientifico: json['nombre_cientifico'] as String?,
        familia: json['familia'] as String?,
      );
    }).toList();
  }

  Future<OcurrenciaDetailModel?> getOcurrenciaById(String ocurrenciaId) async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.ocurrenciasTable,
      where: 'id_ocurrencia = ? AND is_deleted = 0',
      whereArgs: [ocurrenciaId],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    final json = rows.first;

    return OcurrenciaDetailModel(
      idOcurrencia: json['id_ocurrencia'] as String,
      idEspecie: json['id_especie'] as String,
      salidaId: json['salida_id'] as String,
      fechaHora: json['fecha_hora'] != null
          ? DateTime.parse(json['fecha_hora'] as String)
          : null,
      coordenadas: json['coordenadas'] as String?,
      altitud: (json['altitud'] as num?)?.toDouble(),
      esfuerzo: (json['esfuerzo'] as num?)?.toDouble(),
      cpue: (json['cpue'] as num?)?.toDouble(),
      longitudPez: (json['longitud_pez'] as num?)?.toDouble(),
      peso: (json['peso'] as num?)?.toDouble(),
      sexo: json['sexo'] as String?,
      estadoOntogenetico: json['estado_ontogenetico'] as String?,
      estadioVida: json['estadio_vida'] as String?,
      condicionReproductiva: json['condicion_reproductiva'] as String?,
      comportamiento: json['comportamiento'] as String?,
      anomalias: json['anomalias'] as String?,
      mortalidad: json['mortalidad'] as String?,
      vouchers: json['vouchers'] as String?,
      nivelCerteza: json['nivel_certeza'] as int?,
      anchoCauce: (json['ancho_cauce'] as num?)?.toDouble(),
      profundidadMedia: (json['profundidad_media'] as num?)?.toDouble(),
      profundidadMaxima: (json['profundidad_maxima'] as num?)?.toDouble(),
      caudalVelocidad: (json['caudal_velocidad'] as num?)?.toDouble(),
      tipoHabitat: json['tipo_habitat'] as String?,
      dinamicaAgua: json['dinamica_agua'] as String?,
      microhabitat: json['microhabitat'] as String?,
      coberturaDosel: (json['cobertura_dosel'] as num?)?.toDouble(),
      usoSueloRibereno: json['uso_suelo_ribereno'] as String?,
      estabilidadOrillas: json['estabilidad_orillas'] as String?,
      sustrato: json['sustrato'] as String?,
      clima: json['clima'] as String?,
      metodoCaptura: json['metodo_captura'] as String?,
      artePesca: json['arte_pesca'] as String?,
      codigoMuestreo: json['codigo_muestreo'] as String?,
      datum: json['datum'] as String?,
      observaciones: json['observaciones'] as String?,
      nombreComun: json['nombre_comun'] as String?,
      nombreCientifico: json['nombre_cientifico'] as String?,
      familia: json['familia'] as String?,
    );
  }

  Future<void> markOcurrenciaDeleted(String ocurrenciaId) async {
    final db = await AppDatabase.database;

    await db.update(
      DBConstants.ocurrenciasTable,
      {
        'is_deleted': 1,
        'sync_status': SyncStatus.pendingDelete,
        'updated_at_local': DateTime.now().toIso8601String(),
      },
      where: 'id_ocurrencia = ?',
      whereArgs: [ocurrenciaId],
    );
  }
  Future<List<OcurrenciaDetailModel>> getPendingCreateOcurrencias() async {
    final db = await AppDatabase.database;

    final rows = await db.query(
        DBConstants.ocurrenciasTable,
        where: 'sync_status = ? AND is_deleted = 0',
        whereArgs: [SyncStatus.pendingCreate],
        orderBy: 'updated_at_local ASC',
    );

    return rows.map((json) {
        return OcurrenciaDetailModel(
        idOcurrencia: json['id_ocurrencia'] as String,
        idEspecie: json['id_especie'] as String,
        salidaId: json['salida_id'] as String,
        fechaHora: json['fecha_hora'] != null
            ? DateTime.parse(json['fecha_hora'] as String)
            : null,
        coordenadas: json['coordenadas'] as String?,
        altitud: (json['altitud'] as num?)?.toDouble(),
        esfuerzo: (json['esfuerzo'] as num?)?.toDouble(),
        cpue: (json['cpue'] as num?)?.toDouble(),
        longitudPez: (json['longitud_pez'] as num?)?.toDouble(),
        peso: (json['peso'] as num?)?.toDouble(),
        sexo: json['sexo'] as String?,
        estadoOntogenetico: json['estado_ontogenetico'] as String?,
        estadioVida: json['estadio_vida'] as String?,
        condicionReproductiva: json['condicion_reproductiva'] as String?,
        comportamiento: json['comportamiento'] as String?,
        anomalias: json['anomalias'] as String?,
        mortalidad: json['mortalidad'] as String?,
        vouchers: json['vouchers'] as String?,
        nivelCerteza: json['nivel_certeza'] as int?,
        anchoCauce: (json['ancho_cauce'] as num?)?.toDouble(),
        profundidadMedia: (json['profundidad_media'] as num?)?.toDouble(),
        profundidadMaxima: (json['profundidad_maxima'] as num?)?.toDouble(),
        caudalVelocidad: (json['caudal_velocidad'] as num?)?.toDouble(),
        tipoHabitat: json['tipo_habitat'] as String?,
        dinamicaAgua: json['dinamica_agua'] as String?,
        microhabitat: json['microhabitat'] as String?,
        coberturaDosel: (json['cobertura_dosel'] as num?)?.toDouble(),
        usoSueloRibereno: json['uso_suelo_ribereno'] as String?,
        estabilidadOrillas: json['estabilidad_orillas'] as String?,
        sustrato: json['sustrato'] as String?,
        clima: json['clima'] as String?,
        metodoCaptura: json['metodo_captura'] as String?,
        artePesca: json['arte_pesca'] as String?,
        codigoMuestreo: json['codigo_muestreo'] as String?,
        datum: json['datum'] as String?,
        observaciones: json['observaciones'] as String?,
        nombreComun: json['nombre_comun'] as String?,
        nombreCientifico: json['nombre_cientifico'] as String?,
        familia: json['familia'] as String?,
        );
    }).toList();
    }

    Future<List<OcurrenciaDetailModel>> getPendingUpdateOcurrencias() async {
    final db = await AppDatabase.database;

    final rows = await db.query(
        DBConstants.ocurrenciasTable,
        where: 'sync_status = ? AND is_deleted = 0',
        whereArgs: [SyncStatus.pendingUpdate],
        orderBy: 'updated_at_local ASC',
    );

    return rows.map((json) {
        return OcurrenciaDetailModel(
        idOcurrencia: json['id_ocurrencia'] as String,
        idEspecie: json['id_especie'] as String,
        salidaId: json['salida_id'] as String,
        fechaHora: json['fecha_hora'] != null
            ? DateTime.parse(json['fecha_hora'] as String)
            : null,
        coordenadas: json['coordenadas'] as String?,
        altitud: (json['altitud'] as num?)?.toDouble(),
        esfuerzo: (json['esfuerzo'] as num?)?.toDouble(),
        cpue: (json['cpue'] as num?)?.toDouble(),
        longitudPez: (json['longitud_pez'] as num?)?.toDouble(),
        peso: (json['peso'] as num?)?.toDouble(),
        sexo: json['sexo'] as String?,
        estadoOntogenetico: json['estado_ontogenetico'] as String?,
        estadioVida: json['estadio_vida'] as String?,
        condicionReproductiva: json['condicion_reproductiva'] as String?,
        comportamiento: json['comportamiento'] as String?,
        anomalias: json['anomalias'] as String?,
        mortalidad: json['mortalidad'] as String?,
        vouchers: json['vouchers'] as String?,
        nivelCerteza: json['nivel_certeza'] as int?,
        anchoCauce: (json['ancho_cauce'] as num?)?.toDouble(),
        profundidadMedia: (json['profundidad_media'] as num?)?.toDouble(),
        profundidadMaxima: (json['profundidad_maxima'] as num?)?.toDouble(),
        caudalVelocidad: (json['caudal_velocidad'] as num?)?.toDouble(),
        tipoHabitat: json['tipo_habitat'] as String?,
        dinamicaAgua: json['dinamica_agua'] as String?,
        microhabitat: json['microhabitat'] as String?,
        coberturaDosel: (json['cobertura_dosel'] as num?)?.toDouble(),
        usoSueloRibereno: json['uso_suelo_ribereno'] as String?,
        estabilidadOrillas: json['estabilidad_orillas'] as String?,
        sustrato: json['sustrato'] as String?,
        clima: json['clima'] as String?,
        metodoCaptura: json['metodo_captura'] as String?,
        artePesca: json['arte_pesca'] as String?,
        codigoMuestreo: json['codigo_muestreo'] as String?,
        datum: json['datum'] as String?,
        observaciones: json['observaciones'] as String?,
        nombreComun: json['nombre_comun'] as String?,
        nombreCientifico: json['nombre_cientifico'] as String?,
        familia: json['familia'] as String?,
        );
    }).toList();
    }

    Future<List<String>> getPendingDeleteOcurrenciaIds() async {
    final db = await AppDatabase.database;

    final rows = await db.query(
        DBConstants.ocurrenciasTable,
        columns: ['id_ocurrencia'],
        where: 'sync_status = ?',
        whereArgs: [SyncStatus.pendingDelete],
        orderBy: 'updated_at_local ASC',
    );

    return rows.map((row) => row['id_ocurrencia'] as String).toList();
    }

    Future<void> markOcurrenciaSynced(String ocurrenciaId) async {
    final db = await AppDatabase.database;

    await db.update(
        DBConstants.ocurrenciasTable,
        {
        'sync_status': SyncStatus.synced,
        'updated_at_local': DateTime.now().toIso8601String(),
        'is_deleted': 0,
        },
        where: 'id_ocurrencia = ?',
        whereArgs: [ocurrenciaId],
    );
    }

    Future<void> deleteOcurrenciaLocal(String ocurrenciaId) async {
    final db = await AppDatabase.database;

    await db.delete(
        DBConstants.ocurrenciasTable,
        where: 'id_ocurrencia = ?',
        whereArgs: [ocurrenciaId],
    );
    }
}