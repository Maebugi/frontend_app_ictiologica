import 'package:sqflite/sqflite.dart';

import 'package:frontend/app/core/db/app_database.dart';
import 'package:frontend/app/core/db/db_constants.dart';
import '../models/especie_model.dart';

class SpeciesLocalDatasource {
  Future<void> saveSpecies(List<EspecieModel> species) async {
    final db = await AppDatabase.database;
    final batch = db.batch();

    for (final item in species) {
      batch.insert(
        DBConstants.speciesTable,
        {
          'especie_id': item.especieId,
          'nombre_cientifico': item.nombreCientifico,
          'nombre_comun': item.nombreComun,
          'orden_taxonomico': item.orden,
          'familia': item.familia,
          'estado_conservacion': item.estadoConservacion,
          'synced_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<EspecieModel>> getSpecies() async {
    final db = await AppDatabase.database;
    final rows = await db.query(DBConstants.speciesTable);

    return rows.map((json) {
      return EspecieModel(
        especieId: json['especie_id'] as String,
        nombreCientifico: json['nombre_cientifico'] as String?,
        nombreComun: json['nombre_comun'] as String?,
        orden: json['orden_taxonomico'] as String?,
        familia: json['familia'] as String?,
        estadoConservacion: json['estado_conservacion'] as String?,
      );
    }).toList();
  }

  Future<List<EspecieModel>> searchSpecies(String query) async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      DBConstants.speciesTable,
      where: 'LOWER(nombre_comun) LIKE ? OR LOWER(nombre_cientifico) LIKE ?',
      whereArgs: ['%${query.toLowerCase()}%', '%${query.toLowerCase()}%'],
    );

    return rows.map((json) {
      return EspecieModel(
        especieId: json['especie_id'] as String,
        nombreCientifico: json['nombre_cientifico'] as String?,
        nombreComun: json['nombre_comun'] as String?,
        orden: json['orden_taxonomico'] as String?,
        familia: json['familia'] as String?,
        estadoConservacion: json['estado_conservacion'] as String?,
      );
    }).toList();
  }
}