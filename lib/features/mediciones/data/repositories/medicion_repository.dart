import '../datasources/medicion_remote_datasource.dart';
import '../models/medicion_create_request_model.dart';
import '../models/medicion_model.dart';
import '../models/medicion_update_request_model.dart';
import 'package:frontend/app/core/network/connectivity_service.dart';
import 'package:frontend/app/core/sync/sync_status.dart';
import '../datasources/medicion_local_datasource.dart';


class MedicionRepository {
  final MedicionRemoteDatasource remoteDatasource;
  final MedicionLocalDatasource localDatasource;
  final ConnectivityService connectivityService;

  MedicionRepository({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.connectivityService,
  });

  Future<MedicionModel> getMedicionByOcurrencia(String ocurrenciaId) async {
    final local = await localDatasource.getMedicionByOcurrencia(ocurrenciaId);

    try {
      final remote = await remoteDatasource.getMedicionByOcurrencia(ocurrenciaId);

      if (remote != null) {
        await localDatasource.saveMedicion(
          remote,
          syncStatus: SyncStatus.synced,
        );
        return remote;
      }

      if (local != null) {
        return local;
      }

      throw Exception('No se encontró medición');
    } catch (_) {
      if (local != null) return local;
      rethrow;
    }
  }

  Future<bool> createMedicion(MedicionCreateRequestModel request) async {
    final hasConnection = await connectivityService.hasConnection();

    if (!hasConnection) {
      final localMedicion = MedicionModel(
        medicionId: request.medicionId,
        ocurrenciaId: request.ocurrenciaId,
        oxigenoDisueltoMgL: request.oxigenoDisueltoMgL,
        ph: request.ph,
        turbidezNtu: request.turbidezNtu,
        conductividadUsCm: request.conductividadUsCm,
        tdsMgL: request.tdsMgL,
        temperaturaC: request.temperaturaC,
        transparenciaSecchiCm: request.transparenciaSecchiCm,
        nivelEstadoAgua: request.nivelEstadoAgua,
        orpMv: request.orpMv,
        alcalinidadMgL: request.alcalinidadMgL,
        durezaMgL: request.durezaMgL,
        salinidad: request.salinidad,
        amonioMgL: request.amonioMgL,
        fosforoMetalesMgL: request.fosforoMetalesMgL,
        nitratosMgL: request.nitratosMgL,
        nitritosMgL: request.nitritosMgL,
        fosfatosMgL: request.fosfatosMgL,
        clorofilaAUgL: request.clorofilaAUgL,
        sstMgL: request.sstMgL,
        coliformesFecalesUfc: request.coliformesFecalesUfc,
        observaciones: request.observaciones,
      );

      await localDatasource.saveMedicion(
        localMedicion,
        syncStatus: SyncStatus.pendingCreate,
      );

      return true;
    }

    await remoteDatasource.createMedicion(request);

    final created = MedicionModel(
      medicionId: request.medicionId,
      ocurrenciaId: request.ocurrenciaId,
      oxigenoDisueltoMgL: request.oxigenoDisueltoMgL,
      ph: request.ph,
      turbidezNtu: request.turbidezNtu,
      conductividadUsCm: request.conductividadUsCm,
      tdsMgL: request.tdsMgL,
      temperaturaC: request.temperaturaC,
      transparenciaSecchiCm: request.transparenciaSecchiCm,
      nivelEstadoAgua: request.nivelEstadoAgua,
      orpMv: request.orpMv,
      alcalinidadMgL: request.alcalinidadMgL,
      durezaMgL: request.durezaMgL,
      salinidad: request.salinidad,
      amonioMgL: request.amonioMgL,
      fosforoMetalesMgL: request.fosforoMetalesMgL,
      nitratosMgL: request.nitratosMgL,
      nitritosMgL: request.nitritosMgL,
      fosfatosMgL: request.fosfatosMgL,
      clorofilaAUgL: request.clorofilaAUgL,
      sstMgL: request.sstMgL,
      coliformesFecalesUfc: request.coliformesFecalesUfc,
      observaciones: request.observaciones,
    );

    await localDatasource.saveMedicion(
      created,
      syncStatus: SyncStatus.synced,
    );

    return true;
  }

  Future<MedicionModel> updateMedicionByOcurrencia(
    String ocurrenciaId,
    MedicionUpdateRequestModel request,
  ) async {
    final hasConnection = await connectivityService.hasConnection();

    if (!hasConnection) {
      final current = await localDatasource.getMedicionByOcurrencia(ocurrenciaId);
      if (current == null) {
        throw Exception('No se encontró la medición local para editar');
      }

      final updated = MedicionModel(
        medicionId: current.medicionId,
        ocurrenciaId: current.ocurrenciaId,
        oxigenoDisueltoMgL: request.oxigenoDisueltoMgL ?? current.oxigenoDisueltoMgL,
        ph: request.ph ?? current.ph,
        turbidezNtu: request.turbidezNtu ?? current.turbidezNtu,
        conductividadUsCm: request.conductividadUsCm ?? current.conductividadUsCm,
        tdsMgL: request.tdsMgL ?? current.tdsMgL,
        temperaturaC: request.temperaturaC ?? current.temperaturaC,
        transparenciaSecchiCm:
            request.transparenciaSecchiCm ?? current.transparenciaSecchiCm,
        nivelEstadoAgua: request.nivelEstadoAgua ?? current.nivelEstadoAgua,
        orpMv: request.orpMv ?? current.orpMv,
        alcalinidadMgL: request.alcalinidadMgL ?? current.alcalinidadMgL,
        durezaMgL: request.durezaMgL ?? current.durezaMgL,
        salinidad: request.salinidad ?? current.salinidad,
        amonioMgL: request.amonioMgL ?? current.amonioMgL,
        fosforoMetalesMgL: request.fosforoMetalesMgL ?? current.fosforoMetalesMgL,
        nitratosMgL: request.nitratosMgL ?? current.nitratosMgL,
        nitritosMgL: request.nitritosMgL ?? current.nitritosMgL,
        fosfatosMgL: request.fosfatosMgL ?? current.fosfatosMgL,
        clorofilaAUgL: request.clorofilaAUgL ?? current.clorofilaAUgL,
        sstMgL: request.sstMgL ?? current.sstMgL,
        coliformesFecalesUfc:
            request.coliformesFecalesUfc ?? current.coliformesFecalesUfc,
        observaciones: request.observaciones ?? current.observaciones,
      );

      await localDatasource.saveMedicion(
        updated,
        syncStatus: SyncStatus.pendingUpdate,
      );

      return updated;
    }

    final remote = await remoteDatasource.updateMedicionByOcurrencia(
      ocurrenciaId,
      request,
    );

    await localDatasource.saveMedicion(
      remote,
      syncStatus: SyncStatus.synced,
    );

    return remote;
  }
  Future<void> syncPendingMediciones() async {
    final hasConnection = await connectivityService.hasConnection();
    if (!hasConnection) return;

    final pendingCreates = await localDatasource.getPendingCreateMediciones();
    final pendingUpdates = await localDatasource.getPendingUpdateMediciones();

    // 1. Crear mediciones pendientes
    for (final medicion in pendingCreates) {
      try {
        final request = MedicionCreateRequestModel(
          medicionId: medicion.medicionId,
          ocurrenciaId: medicion.ocurrenciaId,
          oxigenoDisueltoMgL: medicion.oxigenoDisueltoMgL,
          ph: medicion.ph,
          turbidezNtu: medicion.turbidezNtu,
          conductividadUsCm: medicion.conductividadUsCm,
          tdsMgL: medicion.tdsMgL,
          temperaturaC: medicion.temperaturaC,
          transparenciaSecchiCm: medicion.transparenciaSecchiCm,
          nivelEstadoAgua: medicion.nivelEstadoAgua,
          orpMv: medicion.orpMv,
          alcalinidadMgL: medicion.alcalinidadMgL,
          durezaMgL: medicion.durezaMgL,
          salinidad: medicion.salinidad,
          amonioMgL: medicion.amonioMgL,
          fosforoMetalesMgL: medicion.fosforoMetalesMgL,
          nitratosMgL: medicion.nitratosMgL,
          nitritosMgL: medicion.nitritosMgL,
          fosfatosMgL: medicion.fosfatosMgL,
          clorofilaAUgL: medicion.clorofilaAUgL,
          sstMgL: medicion.sstMgL,
          coliformesFecalesUfc: medicion.coliformesFecalesUfc,
          observaciones: medicion.observaciones,
        );

        await remoteDatasource.createMedicion(request);
        await localDatasource.markMedicionSynced(medicion.ocurrenciaId);
      } catch (_) {
        // si falla, queda pendiente para siguiente intento
      }
    }

    // 2. Actualizar mediciones pendientes
    for (final medicion in pendingUpdates) {
      try {
        final request = MedicionUpdateRequestModel(
          oxigenoDisueltoMgL: medicion.oxigenoDisueltoMgL,
          ph: medicion.ph,
          turbidezNtu: medicion.turbidezNtu,
          conductividadUsCm: medicion.conductividadUsCm,
          tdsMgL: medicion.tdsMgL,
          temperaturaC: medicion.temperaturaC,
          transparenciaSecchiCm: medicion.transparenciaSecchiCm,
          nivelEstadoAgua: medicion.nivelEstadoAgua,
          orpMv: medicion.orpMv,
          alcalinidadMgL: medicion.alcalinidadMgL,
          durezaMgL: medicion.durezaMgL,
          salinidad: medicion.salinidad,
          amonioMgL: medicion.amonioMgL,
          fosforoMetalesMgL: medicion.fosforoMetalesMgL,
          nitratosMgL: medicion.nitratosMgL,
          nitritosMgL: medicion.nitritosMgL,
          fosfatosMgL: medicion.fosfatosMgL,
          clorofilaAUgL: medicion.clorofilaAUgL,
          sstMgL: medicion.sstMgL,
          coliformesFecalesUfc: medicion.coliformesFecalesUfc,
          observaciones: medicion.observaciones,
        );

        await remoteDatasource.updateMedicionByOcurrencia(
          medicion.ocurrenciaId,
          request,
        );

        await localDatasource.markMedicionSynced(medicion.ocurrenciaId);
      } catch (_) {
        // si falla, queda pendiente
      }
    }
  }
}