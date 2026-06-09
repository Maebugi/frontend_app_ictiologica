import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_constants.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DBConstants.dbName);

    return openDatabase(
      path,
      version: DBConstants.dbVersion,
      onCreate: (db, version) async {
        await _createTables(db);
      },
    );
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE ${DBConstants.speciesTable} (
        especie_id TEXT PRIMARY KEY,
        nombre_cientifico TEXT,
        nombre_comun TEXT,
        orden_taxonomico TEXT,
        familia TEXT,
        estado_conservacion TEXT,
        synced_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DBConstants.salidasTable} (
        salida_id TEXT PRIMARY KEY,
        id_usuario TEXT NOT NULL,
        nombre_lugar TEXT,
        nombre_proyecto TEXT,
        fecha_inicio TEXT,
        fecha_fin TEXT,
        observaciones TEXT,
        estado TEXT,
        sync_status TEXT NOT NULL,
        is_deleted INTEGER NOT NULL DEFAULT 0,
        updated_at_local TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DBConstants.ocurrenciasTable} (
        id_ocurrencia TEXT PRIMARY KEY,
        salida_id TEXT NOT NULL,
        id_especie TEXT NOT NULL,
        fecha_hora TEXT,
        coordenadas TEXT,
        altitud REAL,
        esfuerzo REAL,
        cpue REAL,
        longitud_pez REAL,
        peso REAL,
        sexo TEXT,
        estado_ontogenetico TEXT,
        estadio_vida TEXT,
        condicion_reproductiva TEXT,
        comportamiento TEXT,
        anomalias TEXT,
        mortalidad TEXT,
        vouchers TEXT,
        nivel_certeza INTEGER,
        ancho_cauce REAL,
        profundidad_media REAL,
        profundidad_maxima REAL,
        caudal_velocidad REAL,
        tipo_habitat TEXT,
        microhabitat TEXT,
        cobertura_dosel REAL,
        uso_suelo_ribereno TEXT,
        estabilidad_orillas TEXT,
        sustrato TEXT,
        clima TEXT,
        metodo_captura TEXT,
        arte_pesca TEXT,
        codigo_muestreo TEXT,
        datum TEXT,
        observaciones TEXT,
        nombre_comun TEXT,
        nombre_cientifico TEXT,
        familia TEXT,
        sync_status TEXT NOT NULL,
        is_deleted INTEGER NOT NULL DEFAULT 0,
        updated_at_local TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DBConstants.medicionesTable} (
        medicion_id TEXT PRIMARY KEY,
        ocurrencia_id TEXT NOT NULL UNIQUE,
        oxigeno_disuelto_mg_l REAL,
        ph REAL,
        turbidez_ntu REAL,
        conductividad_us_cm REAL,
        tds_mg_l REAL,
        temperatura_c REAL,
        transparencia_secchi_cm REAL,
        nivel_estado_agua TEXT,
        orp_mv REAL,
        alcalinidad_mg_l REAL,
        dureza_mg_l REAL,
        salinidad REAL,
        amonio_mg_l REAL,
        fosforo_metales_mg_l REAL,
        nitratos_mg_l REAL,
        nitritos_mg_l REAL,
        fosfatos_mg_l REAL,
        clorofila_a_ug_l REAL,
        sst_mg_l REAL,
        coliformes_fecales_ufc INTEGER,
        observaciones TEXT,
        sync_status TEXT NOT NULL,
        is_deleted INTEGER NOT NULL DEFAULT 0,
        updated_at_local TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DBConstants.evidenciasTable} (
        id_foto TEXT PRIMARY KEY,
        id_ocurrencia TEXT NOT NULL,
        ruta TEXT,
        observaciones TEXT,
        sync_status TEXT NOT NULL,
        is_deleted INTEGER NOT NULL DEFAULT 0,
        updated_at_local TEXT
      )
    ''');
  }
  
}

