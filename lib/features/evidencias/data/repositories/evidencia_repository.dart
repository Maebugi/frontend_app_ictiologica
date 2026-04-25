import 'dart:io';
import 'package:uuid/uuid.dart';
import '../datasource/evidencia_remote_datasource.dart';
import '../models/evidencia_model.dart';
import '../models/evidencia_update_request_model.dart';
import 'package:frontend/app/core/network/connectivity_service.dart';
import 'package:frontend/app/core/sync/sync_status.dart';
import '../datasource/evidencia_local_datasource.dart';

class EvidenciaRepository {
  final EvidenciaRemoteDatasource remoteDatasource;
  final EvidenciaLocalDatasource localDatasource;
  final ConnectivityService connectivityService;

  EvidenciaRepository({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.connectivityService,
  });

  Future<List<EvidenciaModel>> getEvidenciasByOcurrencia(String ocurrenciaId) async {
    final local = await localDatasource.getEvidenciasByOcurrencia(ocurrenciaId);

    try {
      final remote = await remoteDatasource.getEvidenciasByOcurrencia(ocurrenciaId);

      for (final item in remote) {
        await localDatasource.saveEvidencia(
          item,
          syncStatus: SyncStatus.synced,
        );
      }

      return remote;
    } catch (_) {
      return local;
    }
  }

  Future<EvidenciaModel> uploadEvidencia({
    required String ocurrenciaId,
    required File file,
    String? observaciones,
  }) async {
    final hasConnection = await connectivityService.hasConnection();

    final localEvidencia = EvidenciaModel(
      idFoto: const Uuid().v4(),
      idOcurrencia: ocurrenciaId,
      ruta: file.path,
      observaciones: observaciones,
    );

    if (!hasConnection) {
      await localDatasource.saveEvidencia(
        localEvidencia,
        syncStatus: SyncStatus.pendingCreate,
      );
      return localEvidencia;
    }

    final remote = await remoteDatasource.uploadEvidencia(
      ocurrenciaId: ocurrenciaId,
      file: file,
      observaciones: observaciones,
    );

    await localDatasource.saveEvidencia(
      remote,
      syncStatus: SyncStatus.synced,
    );

    return remote;
  }

  Future<EvidenciaModel> updateEvidencia(
    String evidenciaId,
    EvidenciaUpdateRequestModel request,
  ) async {
    final hasConnection = await connectivityService.hasConnection();

    if (!hasConnection) {
      final current = await localDatasource.getEvidenciaById(evidenciaId);
      if (current == null) {
        throw Exception('No se encontró la evidencia local para editar');
      }

      final updated = EvidenciaModel(
        idFoto: current.idFoto,
        idOcurrencia: current.idOcurrencia,
        ruta: current.ruta,
        observaciones: request.observaciones ?? current.observaciones,
      );

      await localDatasource.saveEvidencia(
        updated,
        syncStatus: SyncStatus.pendingUpdate,
      );

      return updated;
    }

    final remote = await remoteDatasource.updateEvidencia(evidenciaId, request);

    await localDatasource.saveEvidencia(
      remote,
      syncStatus: SyncStatus.synced,
    );

    return remote;
  }

  Future<void> deleteEvidencia(String evidenciaId) async {
    final hasConnection = await connectivityService.hasConnection();

    if (!hasConnection) {
      await localDatasource.markEvidenciaDeleted(evidenciaId);
      return;
    }

    await remoteDatasource.deleteEvidencia(evidenciaId);
    await localDatasource.markEvidenciaDeleted(evidenciaId);
  }

  Future<void> syncPendingEvidencias() async {
    final hasConnection = await connectivityService.hasConnection();
    if (!hasConnection) return;

    final pendingCreates = await localDatasource.getPendingCreateEvidencias();
    final pendingUpdates = await localDatasource.getPendingUpdateEvidencias();
    final pendingDeletes = await localDatasource.getPendingDeleteEvidenciaIds();

    for (final evidencia in pendingCreates) {
      try {
        if (evidencia.ruta == null || evidencia.ruta!.isEmpty) {
          continue;
        }

        final file = File(evidencia.ruta!);
        if (!file.existsSync()) {
          continue;
        }

        await remoteDatasource.uploadEvidencia(
          ocurrenciaId: evidencia.idOcurrencia,
          file: file,
          observaciones: evidencia.observaciones,
        );

        await localDatasource.markEvidenciaSynced(evidencia.idFoto);
      } catch (_) {}
    }

    for (final evidencia in pendingUpdates) {
      try {
        final request = EvidenciaUpdateRequestModel(
          observaciones: evidencia.observaciones,
        );

        await remoteDatasource.updateEvidencia(
          evidencia.idFoto,
          request,
        );

        await localDatasource.markEvidenciaSynced(evidencia.idFoto);
      } catch (_) {}
    }

    for (final evidenciaId in pendingDeletes) {
      try {
        await remoteDatasource.deleteEvidencia(evidenciaId);
        await localDatasource.deleteEvidenciaLocal(evidenciaId);
      } catch (_) {}
    }
  }
}