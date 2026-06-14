import 'package:sqflite/sqflite.dart';

import 'package:frontend/app/core/db/app_database.dart';
import 'package:frontend/app/core/db/db_constants.dart';
import 'package:frontend/app/core/sync/sync_status.dart';

import '../models/salida_evidencia_model.dart';

class SalidaEvidenciaLocalDatasource {
  Future<void> saveSalidaEvidencia(
    SalidaEvidenciaModel evidencia, {
    required String syncStatus,
  }) async {
    final db = await AppDatabase.database;

    await db.insert(
      DBConstants.salidaEvidenciasTable,
      {
        'id_foto': evidencia.idFoto,
        'salida_id': evidencia.salidaId,
        'ruta': evidencia.ruta,
        'tipo_archivo': evidencia.tipoArchivo,
        'observaciones': evidencia.observaciones,
        'sync_status': syncStatus,
        'is_deleted': 0,
        'updated_at_local': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SalidaEvidenciaModel>> getEvidenciasBySalida(
    String salidaId,
  ) async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.salidaEvidenciasTable,
      where: 'salida_id = ? AND is_deleted = 0',
      whereArgs: [salidaId],
      orderBy: 'updated_at_local DESC',
    );

    return rows.map((json) {
      return SalidaEvidenciaModel(
        idFoto: json['id_foto'] as String,
        salidaId: json['salida_id'] as String,
        ruta: json['ruta'] as String?,
        tipoArchivo: json['tipo_archivo'] as String?,
        observaciones: json['observaciones'] as String?,
      );
    }).toList();
  }

  Future<SalidaEvidenciaModel?> getEvidenciaById(
    String evidenciaId,
  ) async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.salidaEvidenciasTable,
      where: 'id_foto = ? AND is_deleted = 0',
      whereArgs: [evidenciaId],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    final json = rows.first;

    return SalidaEvidenciaModel(
      idFoto: json['id_foto'] as String,
      salidaId: json['salida_id'] as String,
      ruta: json['ruta'] as String?,
      tipoArchivo: json['tipo_archivo'] as String?,
      observaciones: json['observaciones'] as String?,
    );
  }

  Future<void> markEvidenciaDeleted(
    String evidenciaId,
  ) async {
    final db = await AppDatabase.database;

    await db.update(
      DBConstants.salidaEvidenciasTable,
      {
        'is_deleted': 1,
        'sync_status': SyncStatus.pendingDelete,
        'updated_at_local':
            DateTime.now().toIso8601String(),
      },
      where: 'id_foto = ?',
      whereArgs: [evidenciaId],
    );
  }

  Future<List<SalidaEvidenciaModel>>
      getPendingCreateEvidencias() async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.salidaEvidenciasTable,
      where: 'sync_status = ? AND is_deleted = 0',
      whereArgs: [SyncStatus.pendingCreate],
      orderBy: 'updated_at_local ASC',
    );

    return rows.map((json) {
      return SalidaEvidenciaModel(
        idFoto: json['id_foto'] as String,
        salidaId: json['salida_id'] as String,
        ruta: json['ruta'] as String?,
        tipoArchivo: json['tipo_archivo'] as String?,
        observaciones: json['observaciones'] as String?,
      );
    }).toList();
  }

  Future<List<SalidaEvidenciaModel>>
      getPendingUpdateEvidencias() async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.salidaEvidenciasTable,
      where: 'sync_status = ? AND is_deleted = 0',
      whereArgs: [SyncStatus.pendingUpdate],
      orderBy: 'updated_at_local ASC',
    );

    return rows.map((json) {
      return SalidaEvidenciaModel(
        idFoto: json['id_foto'] as String,
        salidaId: json['salida_id'] as String,
        ruta: json['ruta'] as String?,
        tipoArchivo: json['tipo_archivo'] as String?,
        observaciones: json['observaciones'] as String?,
      );
    }).toList();
  }

  Future<List<String>>
      getPendingDeleteEvidenciaIds() async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.salidaEvidenciasTable,
      columns: ['id_foto'],
      where: 'sync_status = ?',
      whereArgs: [SyncStatus.pendingDelete],
      orderBy: 'updated_at_local ASC',
    );

    return rows
        .map((row) => row['id_foto'] as String)
        .toList();
  }

  Future<void> markEvidenciaSynced(
    String evidenciaId,
  ) async {
    final db = await AppDatabase.database;

    await db.update(
      DBConstants.salidaEvidenciasTable,
      {
        'sync_status': SyncStatus.synced,
        'updated_at_local':
            DateTime.now().toIso8601String(),
      },
      where: 'id_foto = ?',
      whereArgs: [evidenciaId],
    );
  }

  Future<void> deleteEvidenciaLocal(
    String evidenciaId,
  ) async {
    final db = await AppDatabase.database;

    await db.delete(
      DBConstants.salidaEvidenciasTable,
      where: 'id_foto = ?',
      whereArgs: [evidenciaId],
    );
  }
}