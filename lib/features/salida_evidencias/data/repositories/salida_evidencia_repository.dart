import 'dart:io';

import 'package:uuid/uuid.dart';

import 'package:frontend/app/core/network/connectivity_service.dart';
import 'package:frontend/app/core/sync/sync_status.dart';

import '../datasource/salida_evidencia_local_datasource.dart';
import '../datasource/salida_evidencia_remote_datasource.dart';

import '../models/salida_evidencia_model.dart';
import '../models/salida_evidencia_update_request_model.dart';

class SalidaEvidenciaRepository {
  final SalidaEvidenciaRemoteDatasource remoteDatasource;
  final SalidaEvidenciaLocalDatasource localDatasource;
  final ConnectivityService connectivityService;

  SalidaEvidenciaRepository({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.connectivityService,
  });

  Future<List<SalidaEvidenciaModel>>
      getEvidenciasBySalida(
    String salidaId,
  ) async {
    final local =
        await localDatasource.getEvidenciasBySalida(
      salidaId,
    );

    try {
      final remote =
          await remoteDatasource.getEvidenciasBySalida(
        salidaId,
      );

      for (final item in remote) {
        await localDatasource.saveSalidaEvidencia(
          item,
          syncStatus: SyncStatus.synced,
        );
      }

      return remote;
    } catch (_) {
      return local;
    }
  }

  Future<SalidaEvidenciaModel> uploadEvidencia({
    required String salidaId,
    required File file,
    String? observaciones,
  }) async {
    final hasConnection =
        await connectivityService.hasConnection();

    final localEvidencia = SalidaEvidenciaModel(
      idFoto: const Uuid().v4(),
      salidaId: salidaId,
      ruta: file.path,
      tipoArchivo: _getTipoArchivo(file.path),
      observaciones: observaciones,
    );

    if (!hasConnection) {
      await localDatasource.saveSalidaEvidencia(
        localEvidencia,
        syncStatus: SyncStatus.pendingCreate,
      );

      return localEvidencia;
    }

    final remote =
        await remoteDatasource.uploadEvidencia(
      salidaId: salidaId,
      file: file,
      observaciones: observaciones,
    );

    await localDatasource.saveSalidaEvidencia(
      remote,
      syncStatus: SyncStatus.synced,
    );

    return remote;
  }

  Future<SalidaEvidenciaModel> updateEvidencia(
    String evidenciaId,
    SalidaEvidenciaUpdateRequestModel request,
  ) async {
    final hasConnection =
        await connectivityService.hasConnection();

    if (!hasConnection) {
      final current =
          await localDatasource.getEvidenciaById(
        evidenciaId,
      );

      if (current == null) {
        throw Exception(
          'No se encontró la evidencia local para editar',
        );
      }

      final updated = SalidaEvidenciaModel(
        idFoto: current.idFoto,
        salidaId: current.salidaId,
        ruta: current.ruta,
        tipoArchivo: current.tipoArchivo,
        observaciones:
            request.observaciones ??
            current.observaciones,
      );

      await localDatasource.saveSalidaEvidencia(
        updated,
        syncStatus: SyncStatus.pendingUpdate,
      );

      return updated;
    }

    final remote =
        await remoteDatasource.updateEvidencia(
      evidenciaId,
      request,
    );

    await localDatasource.saveSalidaEvidencia(
      remote,
      syncStatus: SyncStatus.synced,
    );

    return remote;
  }

  Future<void> deleteEvidencia(
    String evidenciaId,
  ) async {
    final hasConnection =
        await connectivityService.hasConnection();

    if (!hasConnection) {
      await localDatasource.markEvidenciaDeleted(
        evidenciaId,
      );

      return;
    }

    await remoteDatasource.deleteEvidencia(
      evidenciaId,
    );

    await localDatasource.markEvidenciaDeleted(
      evidenciaId,
    );
  }

  Future<void> syncPendingEvidencias() async {
    final hasConnection =
        await connectivityService.hasConnection();

    print('=== INICIANDO SYNC EVIDENCIAS SALIDA ===');


    if (!hasConnection) return;

    final pendingCreates =
        await localDatasource
            .getPendingCreateEvidencias();

    final pendingUpdates =
        await localDatasource
            .getPendingUpdateEvidencias();

    final pendingDeletes =
        await localDatasource
            .getPendingDeleteEvidenciaIds();

    print('PENDING CREATES: ${pendingCreates.length}');
      print('PENDING UPDATES: ${pendingUpdates.length}');
      print('PENDING DELETES: ${pendingDeletes.length}');

    for (final evidencia in pendingCreates) {
      try {
        print('SUBIENDO: ${evidencia.idFoto}');
        print('RUTA BD: ${evidencia.ruta}');

        if (evidencia.ruta == null ||
            evidencia.ruta!.isEmpty) {
          continue;

        }

        final file = File(evidencia.ruta!);

        print('ARCHIVO EXISTE: ${file.existsSync()}');

        if (!file.existsSync()) {
          print('ARCHIVO NO EXISTE');
          continue;
        }

        final remote =

        await remoteDatasource.uploadEvidencia(
          salidaId: evidencia.salidaId,
          file: file,
          observaciones:
              evidencia.observaciones,
        );

        await localDatasource.markEvidenciaSynced(
          evidencia.idFoto,
        );
      } catch (e) {print('ERROR SUBIENDO EVIDENCIA: $e');}
    }

    for (final evidencia in pendingUpdates) {
      try {
        final request =
            SalidaEvidenciaUpdateRequestModel(
          observaciones:
              evidencia.observaciones,
        );

        await remoteDatasource.updateEvidencia(
          evidencia.idFoto,
          request,
        );

        await localDatasource.markEvidenciaSynced(
          evidencia.idFoto,
        );
      } catch (_) {}
    }

    for (final evidenciaId in pendingDeletes) {
      try {
        await remoteDatasource.deleteEvidencia(
          evidenciaId,
        );

        await localDatasource.deleteEvidenciaLocal(
          evidenciaId,
        );
      } catch (_) {}
    }
  }

  String _getTipoArchivo(String path) {
    final lower = path.toLowerCase();

    if (lower.endsWith('.mp4') ||
        lower.endsWith('.mov')) {
      return 'video';
    }

    return 'foto';
  }
}