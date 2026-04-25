import 'package:sqflite/sqflite.dart';

import 'package:frontend/app/core/db/app_database.dart';
import 'package:frontend/app/core/db/db_constants.dart';
import 'package:frontend/app/core/sync/sync_status.dart';
import '../models/evidencia_model.dart';

class EvidenciaLocalDatasource {
  Future<void> saveEvidencia(
    EvidenciaModel evidencia, {
    required String syncStatus,
  }) async {
    final db = await AppDatabase.database;

    await db.insert(
      DBConstants.evidenciasTable,
      {
        'id_foto': evidencia.idFoto,
        'id_ocurrencia': evidencia.idOcurrencia,
        'ruta': evidencia.ruta,
        'observaciones': evidencia.observaciones,
        'sync_status': syncStatus,
        'is_deleted': 0,
        'updated_at_local': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<EvidenciaModel>> getEvidenciasByOcurrencia(String ocurrenciaId) async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.evidenciasTable,
      where: 'id_ocurrencia = ? AND is_deleted = 0',
      whereArgs: [ocurrenciaId],
      orderBy: 'updated_at_local DESC',
    );

    return rows.map((json) {
      return EvidenciaModel(
        idFoto: json['id_foto'] as String,
        idOcurrencia: json['id_ocurrencia'] as String,
        ruta: json['ruta'] as String?,
        observaciones: json['observaciones'] as String?,
      );
    }).toList();
  }

  Future<EvidenciaModel?> getEvidenciaById(String evidenciaId) async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.evidenciasTable,
      where: 'id_foto = ? AND is_deleted = 0',
      whereArgs: [evidenciaId],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    final json = rows.first;

    return EvidenciaModel(
      idFoto: json['id_foto'] as String,
      idOcurrencia: json['id_ocurrencia'] as String,
      ruta: json['ruta'] as String?,
      observaciones: json['observaciones'] as String?,
    );
  }

  Future<void> markEvidenciaDeleted(String evidenciaId) async {
    final db = await AppDatabase.database;

    await db.update(
      DBConstants.evidenciasTable,
      {
        'is_deleted': 1,
        'sync_status': SyncStatus.pendingDelete,
        'updated_at_local': DateTime.now().toIso8601String(),
      },
      where: 'id_foto = ?',
      whereArgs: [evidenciaId],
    );
  }

  Future<List<EvidenciaModel>> getPendingCreateEvidencias() async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.evidenciasTable,
      where: 'sync_status = ? AND is_deleted = 0',
      whereArgs: [SyncStatus.pendingCreate],
      orderBy: 'updated_at_local ASC',
    );

    return rows.map((json) {
      return EvidenciaModel(
        idFoto: json['id_foto'] as String,
        idOcurrencia: json['id_ocurrencia'] as String,
        ruta: json['ruta'] as String?,
        observaciones: json['observaciones'] as String?,
      );
    }).toList();
  }

  Future<List<EvidenciaModel>> getPendingUpdateEvidencias() async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.evidenciasTable,
      where: 'sync_status = ? AND is_deleted = 0',
      whereArgs: [SyncStatus.pendingUpdate],
      orderBy: 'updated_at_local ASC',
    );

    return rows.map((json) {
      return EvidenciaModel(
        idFoto: json['id_foto'] as String,
        idOcurrencia: json['id_ocurrencia'] as String,
        ruta: json['ruta'] as String?,
        observaciones: json['observaciones'] as String?,
      );
    }).toList();
  }

  Future<List<String>> getPendingDeleteEvidenciaIds() async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.evidenciasTable,
      columns: ['id_foto'],
      where: 'sync_status = ?',
      whereArgs: [SyncStatus.pendingDelete],
      orderBy: 'updated_at_local ASC',
    );

    return rows.map((row) => row['id_foto'] as String).toList();
  }

  Future<void> markEvidenciaSynced(String evidenciaId) async {
    final db = await AppDatabase.database;

    await db.update(
      DBConstants.evidenciasTable,
      {
        'sync_status': SyncStatus.synced,
        'updated_at_local': DateTime.now().toIso8601String(),
      },
      where: 'id_foto = ?',
      whereArgs: [evidenciaId],
    );
  }

  Future<void> deleteEvidenciaLocal(String evidenciaId) async {
    final db = await AppDatabase.database;

    await db.delete(
      DBConstants.evidenciasTable,
      where: 'id_foto = ?',
      whereArgs: [evidenciaId],
    );
  }
}