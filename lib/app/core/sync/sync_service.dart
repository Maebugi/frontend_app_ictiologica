import 'package:frontend/app/core/network/connectivity_service.dart';
import 'package:frontend/features/salidas/data/datasources/salida_local_datasource.dart';
import 'package:frontend/features/salidas/data/datasources/salida_remote_datasource.dart';
import 'package:frontend/features/salidas/data/repositories/salida_repository.dart';

import 'package:frontend/features/ocurrencias/data/datasources/ocurrencia_local_datasource.dart';
import 'package:frontend/features/ocurrencias/data/datasources/ocurrencia_remote_datasource.dart';
import 'package:frontend/features/ocurrencias/data/datasources/species_local_datasource.dart';
import 'package:frontend/features/ocurrencias/data/repositories/ocurrencia_repository.dart';

import 'package:frontend/features/mediciones/data/datasources/medicion_local_datasource.dart';
import 'package:frontend/features/mediciones/data/datasources/medicion_remote_datasource.dart';
import 'package:frontend/features/mediciones/data/repositories/medicion_repository.dart';

import 'package:frontend/features/evidencias/data/datasource/evidencia_remote_datasource.dart';
import 'package:frontend/features/evidencias/data/datasources/evidencia_local_datasource.dart';
import 'package:frontend/features/evidencias/data/repositories/evidencia_repository.dart';

class SyncService {
  Future<void> syncAll() async {
    final connectivity = ConnectivityService();
    final hasConnection = await connectivity.hasConnection();

    if (!hasConnection) {
      throw Exception('No hay conexión a internet');
    }

    final salidaRepository = SalidaRepository(
      remoteDatasource: SalidaRemoteDatasource(),
      localDatasource: SalidaLocalDatasource(),
      connectivityService: connectivity,
    );

    final ocurrenciaRepository = OcurrenciaRepository(
      remoteDatasource: OcurrenciaRemoteDatasource(),
      localSpeciesDatasource: SpeciesLocalDatasource(),
      localOcurrenciaDatasource: OcurrenciaLocalDatasource(),
      connectivityService: connectivity,
    );

    final medicionRepository = MedicionRepository(
      remoteDatasource: MedicionRemoteDatasource(),
      localDatasource: MedicionLocalDatasource(),
      connectivityService: connectivity,
    );

    final evidenciaRepository = EvidenciaRepository(
      remoteDatasource: EvidenciaRemoteDatasource(),
      localDatasource: EvidenciaLocalDatasource(),
      connectivityService: connectivity,
    );

    await salidaRepository.syncPendingSalidas();
    await ocurrenciaRepository.syncPendingOcurrencias();
    await medicionRepository.syncPendingMediciones();
    await evidenciaRepository.syncPendingEvidencias();
  }
}