import 'package:sqflite/sqflite.dart';

import 'package:frontend/app/core/db/app_database.dart';
import 'package:frontend/app/core/db/db_constants.dart';
import 'package:frontend/app/core/sync/sync_status.dart';
import '../models/salida_model.dart';
import '../models/salida_update_request_model.dart';

class SalidaLocalDatasource {
  Future<void> saveSalida(
    SalidaModel salida, {
    required String syncStatus,
  }) async {
    final db = await AppDatabase.database;

    await db.insert(
      DBConstants.salidasTable,
      {
        'salida_id': salida.salidaId,
        'id_usuario': salida.idUsuario,
        'nombre_lugar': salida.nombreLugar,
        'fecha_inicio': salida.fechaInicio?.toIso8601String(),
        'fecha_fin': salida.fechaFin?.toIso8601String(),
        'observaciones': salida.observaciones,
        'estado': salida.estado,
        'sync_status': syncStatus,
        'is_deleted': 0,
        'updated_at_local': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SalidaModel>> getSalidas() async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.salidasTable,
      where: 'is_deleted = 0',
      orderBy: 'updated_at_local DESC',
    );

    return rows.map((json) {
      return SalidaModel.fromJson({
        'salida_id': json['salida_id'],
        'id_usuario': json['id_usuario'],
        'nombre_lugar': json['nombre_lugar'],
        'fecha_inicio': json['fecha_inicio'],
        'fecha_fin': json['fecha_fin'],
        'observaciones': json['observaciones'],
        'estado': json['estado'],
      });
    }).toList();
  }

  Future<SalidaModel?> getSalidaById(String salidaId) async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.salidasTable,
      where: 'salida_id = ? AND is_deleted = 0',
      whereArgs: [salidaId],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    final json = rows.first;

    return SalidaModel.fromJson({
      'salida_id': json['salida_id'],
      'id_usuario': json['id_usuario'],
      'nombre_lugar': json['nombre_lugar'],
      'fecha_inicio': json['fecha_inicio'],
      'fecha_fin': json['fecha_fin'],
      'observaciones': json['observaciones'],
      'estado': json['estado'],
    });
  }

  Future<void> markSalidaDeleted(String salidaId) async {
    final db = await AppDatabase.database;

    await db.update(
      DBConstants.salidasTable,
      {
        'is_deleted': 1,
        'sync_status': SyncStatus.pendingDelete,
        'updated_at_local': DateTime.now().toIso8601String(),
      },
      where: 'salida_id = ?',
      whereArgs: [salidaId],
    );
  }
  Future<List<SalidaModel>> getPendingCreateSalidas() async 
  {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.salidasTable,
      where: 'sync_status = ? AND is_deleted = 0',
      whereArgs: [SyncStatus.pendingCreate],
      orderBy: 'updated_at_local ASC',
    );

    return rows.map((json) {
      return SalidaModel.fromJson({
        'salida_id': json['salida_id'],
        'id_usuario': json['id_usuario'],
        'nombre_lugar': json['nombre_lugar'],
        'fecha_inicio': json['fecha_inicio'],
        'fecha_fin': json['fecha_fin'],
        'observaciones': json['observaciones'],
        'estado': json['estado'],
      });
    }).toList();
  }

  Future<List<SalidaModel>> getPendingUpdateSalidas() async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.salidasTable,
      where: 'sync_status = ? AND is_deleted = 0',
      whereArgs: [SyncStatus.pendingUpdate],
      orderBy: 'updated_at_local ASC',
    );

    return rows.map((json) {
      return SalidaModel.fromJson({
        'salida_id': json['salida_id'],
        'id_usuario': json['id_usuario'],
        'nombre_lugar': json['nombre_lugar'],
        'fecha_inicio': json['fecha_inicio'],
        'fecha_fin': json['fecha_fin'],
        'observaciones': json['observaciones'],
        'estado': json['estado'],
      });
    }).toList();
  }

  Future<List<String>> getPendingDeleteSalidaIds() async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.salidasTable,
      columns: ['salida_id'],
      where: 'sync_status = ?',
      whereArgs: [SyncStatus.pendingDelete],
      orderBy: 'updated_at_local ASC',
    );

    return rows.map((row) => row['salida_id'] as String).toList();
  }

  Future<void> markSalidaSynced(String salidaId) async {
    final db = await AppDatabase.database;

    await db.update(
      DBConstants.salidasTable,
      {
        'sync_status': SyncStatus.synced,
        'updated_at_local': DateTime.now().toIso8601String(),
        'is_deleted': 0,
      },
      where: 'salida_id = ?',
      whereArgs: [salidaId],
    );
  }

  Future<void> deleteSalidaLocal(String salidaId) async {
    final db = await AppDatabase.database;

    await db.delete(
      DBConstants.salidasTable,
      where: 'salida_id = ?',
      whereArgs: [salidaId],
    );
  }
}