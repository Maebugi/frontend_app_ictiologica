import 'package:sqflite/sqflite.dart';

import 'package:frontend/app/core/db/app_database.dart';
import 'package:frontend/app/core/db/db_constants.dart';
import 'package:frontend/app/core/sync/sync_status.dart';
import '../models/medicion_model.dart';

class MedicionLocalDatasource {
  Future<void> saveMedicion(
    MedicionModel medicion, {
    required String syncStatus,
  }) async {
    final db = await AppDatabase.database;

    await db.insert(
      DBConstants.medicionesTable,
      {
        'medicion_id': medicion.medicionId,
        'ocurrencia_id': medicion.ocurrenciaId,
        'oxigeno_disuelto_mg_l': medicion.oxigenoDisueltoMgL,
        'ph': medicion.ph,
        'turbidez_ntu': medicion.turbidezNtu,
        'conductividad_us_cm': medicion.conductividadUsCm,
        'tds_mg_l': medicion.tdsMgL,
        'temperatura_c': medicion.temperaturaC,
        'transparencia_secchi_cm': medicion.transparenciaSecchiCm,
        'nivel_estado_agua': medicion.nivelEstadoAgua,
        'orp_mv': medicion.orpMv,
        'alcalinidad_mg_l': medicion.alcalinidadMgL,
        'dureza_mg_l': medicion.durezaMgL,
        'salinidad': medicion.salinidad,
        'amonio_mg_l': medicion.amonioMgL,
        'fosforo_metales_mg_l': medicion.fosforoMetalesMgL,
        'nitratos_mg_l': medicion.nitratosMgL,
        'nitritos_mg_l': medicion.nitritosMgL,
        'fosfatos_mg_l': medicion.fosfatosMgL,
        'clorofila_a_ug_l': medicion.clorofilaAUgL,
        'sst_mg_l': medicion.sstMgL,
        'coliformes_fecales_ufc': medicion.coliformesFecalesUfc,
        'observaciones': medicion.observaciones,
        'sync_status': syncStatus,
        'is_deleted': 0,
        'updated_at_local': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<MedicionModel?> getMedicionByOcurrencia(String ocurrenciaId) async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.medicionesTable,
      where: 'ocurrencia_id = ? AND is_deleted = 0',
      whereArgs: [ocurrenciaId],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    final json = rows.first;

    return MedicionModel(
      medicionId: json['medicion_id'] as String,
      ocurrenciaId: json['ocurrencia_id'] as String,
      oxigenoDisueltoMgL: (json['oxigeno_disuelto_mg_l'] as num?)?.toDouble(),
      ph: (json['ph'] as num?)?.toDouble(),
      turbidezNtu: (json['turbidez_ntu'] as num?)?.toDouble(),
      conductividadUsCm: (json['conductividad_us_cm'] as num?)?.toDouble(),
      tdsMgL: (json['tds_mg_l'] as num?)?.toDouble(),
      temperaturaC: (json['temperatura_c'] as num?)?.toDouble(),
      transparenciaSecchiCm: (json['transparencia_secchi_cm'] as num?)?.toDouble(),
      nivelEstadoAgua: json['nivel_estado_agua'] as String?,
      orpMv: (json['orp_mv'] as num?)?.toDouble(),
      alcalinidadMgL: (json['alcalinidad_mg_l'] as num?)?.toDouble(),
      durezaMgL: (json['dureza_mg_l'] as num?)?.toDouble(),
      salinidad: (json['salinidad'] as num?)?.toDouble(),
      amonioMgL: (json['amonio_mg_l'] as num?)?.toDouble(),
      fosforoMetalesMgL: (json['fosforo_metales_mg_l'] as num?)?.toDouble(),
      nitratosMgL: (json['nitratos_mg_l'] as num?)?.toDouble(),
      nitritosMgL: (json['nitritos_mg_l'] as num?)?.toDouble(),
      fosfatosMgL: (json['fosfatos_mg_l'] as num?)?.toDouble(),
      clorofilaAUgL: (json['clorofila_a_ug_l'] as num?)?.toDouble(),
      sstMgL: (json['sst_mg_l'] as num?)?.toDouble(),
      coliformesFecalesUfc: json['coliformes_fecales_ufc'] as int?,
      observaciones: json['observaciones'] as String?,
    );
  }

  Future<void> markMedicionDeleted(String ocurrenciaId) async {
    final db = await AppDatabase.database;

    await db.update(
      DBConstants.medicionesTable,
      {
        'is_deleted': 1,
        'sync_status': SyncStatus.pendingDelete,
        'updated_at_local': DateTime.now().toIso8601String(),
      },
      where: 'ocurrencia_id = ?',
      whereArgs: [ocurrenciaId],
    );
  }
  Future<List<MedicionModel>> getPendingCreateMediciones() async {
    final db = await AppDatabase.database;

    final rows = await db.query(
        DBConstants.medicionesTable,
        where: 'sync_status = ? AND is_deleted = 0',
        whereArgs: [SyncStatus.pendingCreate],
        orderBy: 'updated_at_local ASC',
    );

    return rows.map((json) {
        return MedicionModel(
        medicionId: json['medicion_id'] as String,
        ocurrenciaId: json['ocurrencia_id'] as String,
        oxigenoDisueltoMgL: (json['oxigeno_disuelto_mg_l'] as num?)?.toDouble(),
        ph: (json['ph'] as num?)?.toDouble(),
        turbidezNtu: (json['turbidez_ntu'] as num?)?.toDouble(),
        conductividadUsCm: (json['conductividad_us_cm'] as num?)?.toDouble(),
        tdsMgL: (json['tds_mg_l'] as num?)?.toDouble(),
        temperaturaC: (json['temperatura_c'] as num?)?.toDouble(),
        transparenciaSecchiCm: (json['transparencia_secchi_cm'] as num?)?.toDouble(),
        nivelEstadoAgua: json['nivel_estado_agua'] as String?,
        orpMv: (json['orp_mv'] as num?)?.toDouble(),
        alcalinidadMgL: (json['alcalinidad_mg_l'] as num?)?.toDouble(),
        durezaMgL: (json['dureza_mg_l'] as num?)?.toDouble(),
        salinidad: (json['salinidad'] as num?)?.toDouble(),
        amonioMgL: (json['amonio_mg_l'] as num?)?.toDouble(),
        fosforoMetalesMgL: (json['fosforo_metales_mg_l'] as num?)?.toDouble(),
        nitratosMgL: (json['nitratos_mg_l'] as num?)?.toDouble(),
        nitritosMgL: (json['nitritos_mg_l'] as num?)?.toDouble(),
        fosfatosMgL: (json['fosfatos_mg_l'] as num?)?.toDouble(),
        clorofilaAUgL: (json['clorofila_a_ug_l'] as num?)?.toDouble(),
        sstMgL: (json['sst_mg_l'] as num?)?.toDouble(),
        coliformesFecalesUfc: json['coliformes_fecales_ufc'] as int?,
        observaciones: json['observaciones'] as String?,
        );
    }).toList();
    }

    Future<List<MedicionModel>> getPendingUpdateMediciones() async {
    final db = await AppDatabase.database;

    final rows = await db.query(
        DBConstants.medicionesTable,
        where: 'sync_status = ? AND is_deleted = 0',
        whereArgs: [SyncStatus.pendingUpdate],
        orderBy: 'updated_at_local ASC',
    );

    return rows.map((json) {
        return MedicionModel(
        medicionId: json['medicion_id'] as String,
        ocurrenciaId: json['ocurrencia_id'] as String,
        oxigenoDisueltoMgL: (json['oxigeno_disuelto_mg_l'] as num?)?.toDouble(),
        ph: (json['ph'] as num?)?.toDouble(),
        turbidezNtu: (json['turbidez_ntu'] as num?)?.toDouble(),
        conductividadUsCm: (json['conductividad_us_cm'] as num?)?.toDouble(),
        tdsMgL: (json['tds_mg_l'] as num?)?.toDouble(),
        temperaturaC: (json['temperatura_c'] as num?)?.toDouble(),
        transparenciaSecchiCm: (json['transparencia_secchi_cm'] as num?)?.toDouble(),
        nivelEstadoAgua: json['nivel_estado_agua'] as String?,
        orpMv: (json['orp_mv'] as num?)?.toDouble(),
        alcalinidadMgL: (json['alcalinidad_mg_l'] as num?)?.toDouble(),
        durezaMgL: (json['dureza_mg_l'] as num?)?.toDouble(),
        salinidad: (json['salinidad'] as num?)?.toDouble(),
        amonioMgL: (json['amonio_mg_l'] as num?)?.toDouble(),
        fosforoMetalesMgL: (json['fosforo_metales_mg_l'] as num?)?.toDouble(),
        nitratosMgL: (json['nitratos_mg_l'] as num?)?.toDouble(),
        nitritosMgL: (json['nitritos_mg_l'] as num?)?.toDouble(),
        fosfatosMgL: (json['fosfatos_mg_l'] as num?)?.toDouble(),
        clorofilaAUgL: (json['clorofila_a_ug_l'] as num?)?.toDouble(),
        sstMgL: (json['sst_mg_l'] as num?)?.toDouble(),
        coliformesFecalesUfc: json['coliformes_fecales_ufc'] as int?,
        observaciones: json['observaciones'] as String?,
        );
    }).toList();
    }

    Future<void> markMedicionSynced(String ocurrenciaId) async {
    final db = await AppDatabase.database;

    await db.update(
        DBConstants.medicionesTable,
        {
        'sync_status': SyncStatus.synced,
        'updated_at_local': DateTime.now().toIso8601String(),
        'is_deleted': 0,
        },
        where: 'ocurrencia_id = ?',
        whereArgs: [ocurrenciaId],
    );
    }
}