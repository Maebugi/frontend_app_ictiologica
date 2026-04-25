import 'package:frontend/app/core/network/connectivity_service.dart';
import 'package:frontend/app/core/sync/sync_status.dart';
import '../datasources/salida_local_datasource.dart';
import '../datasources/salida_remote_datasource.dart';
import '../models/salida_create_request_model.dart';
import '../models/salida_finalize_request_model.dart';
import '../models/salida_model.dart';
import '../models/salida_update_request_model.dart';
import 'package:dio/dio.dart';

class SalidaRepository {
  final SalidaRemoteDatasource remoteDatasource;
  final SalidaLocalDatasource localDatasource;
  final ConnectivityService connectivityService;

  static const String _offlineUserId = 'offline-local-user';

  SalidaRepository({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.connectivityService,
  });
  bool _isNotFoundError(Object e) 
  {
    if (e is DioException) {
      return e.response?.statusCode == 404;
    }
    return false;
  }

  Future<List<SalidaModel>> getSalidas() async {
    final local = await localDatasource.getSalidas();
    final hasConnection = await connectivityService.hasConnection();

    if (!hasConnection) {
      return local;
    }

    try {
      final remote = await remoteDatasource.getSalidas();

      for (final item in remote) {
        await localDatasource.saveSalida(
          item,
          syncStatus: SyncStatus.synced,
        );
      }

      return remote;
    } catch (_) {
      return local;
    }
  }

  Future<SalidaModel> getSalidaDetail(String salidaId) async {
    final local = await localDatasource.getSalidaById(salidaId);
    final hasConnection = await connectivityService.hasConnection();

    if (!hasConnection) {
      if (local != null) return local;
      throw Exception('Salida no encontrada en almacenamiento local');
    }

    try {
      final remote = await remoteDatasource.getSalidaDetail(salidaId);
      await localDatasource.saveSalida(
        remote,
        syncStatus: SyncStatus.synced,
      );
      return remote;
    } catch (_) {
      if (local != null) return local;
      rethrow;
    }
  }

  Future<SalidaModel> createSalida(SalidaCreateRequestModel request) async {
    final hasConnection = await connectivityService.hasConnection();

    if (!hasConnection) {
      final localSalida = SalidaModel(
        salidaId: request.salidaId,
        idUsuario: _offlineUserId,
        nombreLugar: request.nombreLugar,
        fechaInicio: request.fechaInicio,
        fechaFin: null,
        observaciones: request.observaciones,
        estado: 'abierta',
      );

      await localDatasource.saveSalida(
        localSalida,
        syncStatus: SyncStatus.pendingCreate,
      );

      return localSalida;
    }

    final remote = await remoteDatasource.createSalida(request);
    await localDatasource.saveSalida(
      remote,
      syncStatus: SyncStatus.synced,
    );
    return remote;
  }

  Future<SalidaModel> updateSalida(
    String salidaId,
    SalidaUpdateRequestModel request,
  ) async {
    final hasConnection = await connectivityService.hasConnection();

    if (!hasConnection) {
      final current = await localDatasource.getSalidaById(salidaId);
      if (current == null) {
        throw Exception('No se encontró la salida local para editar');
      }

      final updated = SalidaModel(
        salidaId: current.salidaId,
        idUsuario: current.idUsuario,
        nombreLugar: request.nombreLugar ?? current.nombreLugar,
        fechaInicio: request.fechaInicio ?? current.fechaInicio,
        fechaFin: request.fechaFin ?? current.fechaFin,
        observaciones: request.observaciones ?? current.observaciones,
        estado: request.estado ?? current.estado,
      );

      await localDatasource.saveSalida(
        updated,
        syncStatus: SyncStatus.pendingUpdate,
      );

      return updated;
    }

    final remote = await remoteDatasource.updateSalida(salidaId, request);
    await localDatasource.saveSalida(
      remote,
      syncStatus: SyncStatus.synced,
    );
    return remote;
  }

  Future<SalidaModel> finalizeSalida(
    String salidaId,
    SalidaFinalizeRequestModel request,
  ) async {
    final hasConnection = await connectivityService.hasConnection();

    if (!hasConnection) {
      final current = await localDatasource.getSalidaById(salidaId);
      if (current == null) {
        throw Exception('No se encontró la salida local para finalizar');
      }

      final updated = SalidaModel(
        salidaId: current.salidaId,
        idUsuario: current.idUsuario,
        nombreLugar: current.nombreLugar,
        fechaInicio: current.fechaInicio,
        fechaFin: request.fechaFin ?? current.fechaFin,
        observaciones: request.observaciones ?? current.observaciones,
        estado: 'cerrada',
      );

      await localDatasource.saveSalida(
        updated,
        syncStatus: SyncStatus.pendingUpdate,
      );

      return updated;
    }

    final remote = await remoteDatasource.finalizeSalida(salidaId, request);
    await localDatasource.saveSalida(
      remote,
      syncStatus: SyncStatus.synced,
    );
    return remote;
  }

  Future<void> deleteSalida(String salidaId) async {
    final hasConnection = await connectivityService.hasConnection();

    if (!hasConnection) {
      await localDatasource.markSalidaDeleted(salidaId);
      return;
    }

    await remoteDatasource.deleteSalida(salidaId);
    await localDatasource.markSalidaDeleted(salidaId);
  }

  Future<void> syncPendingSalidas() async {
    final hasConnection = await connectivityService.hasConnection();
    if (!hasConnection) return;

    final pendingCreates = await localDatasource.getPendingCreateSalidas();
    final pendingUpdates = await localDatasource.getPendingUpdateSalidas();
    final pendingDeletes = await localDatasource.getPendingDeleteSalidaIds();

    // 1. Crear salidas pendientes
    for (final salida in pendingCreates) {
      try {
        final request = SalidaCreateRequestModel(
          salidaId: salida.salidaId,
          nombreLugar: salida.nombreLugar,
          fechaInicio: salida.fechaInicio,
          observaciones: salida.observaciones,
        );

        final remote = await remoteDatasource.createSalida(request);

        await localDatasource.saveSalida(
          remote,
          syncStatus: SyncStatus.synced,
        );
      } catch (_) {
        // Si falla, la dejamos pendiente para el siguiente intento
      }
    }

    // 2. Actualizar o finalizar salidas pendientes
    for (final salida in pendingUpdates) {
      try {
        if (salida.estado.toLowerCase() == 'cerrada' && salida.fechaFin != null) {
          final request = SalidaFinalizeRequestModel(
            fechaFin: salida.fechaFin,
            observaciones: salida.observaciones,
          );

          final remote = await remoteDatasource.finalizeSalida(
            salida.salidaId,
            request,
          );

          await localDatasource.saveSalida(
            remote,
            syncStatus: SyncStatus.synced,
          );
        } else {
          final request = SalidaUpdateRequestModel(
            nombreLugar: salida.nombreLugar,
            fechaInicio: salida.fechaInicio,
            fechaFin: salida.fechaFin,
            observaciones: salida.observaciones,
            estado: salida.estado,
          );

          final remote = await remoteDatasource.updateSalida(
            salida.salidaId,
            request,
          );

          await localDatasource.saveSalida(
            remote,
            syncStatus: SyncStatus.synced,
          );
        }
      } catch (_) {
        // Si falla, la dejamos pendiente para el siguiente intento
      }
    }

    // 3. Eliminar salidas pendientes
    for (final salidaId in pendingDeletes) {
      try {
        await remoteDatasource.deleteSalida(salidaId);
        await localDatasource.deleteSalidaLocal(salidaId);
      } catch (e) {
        // Si no existe en remoto, igual la borramos localmente
        if (_isNotFoundError(e)) {
          await localDatasource.deleteSalidaLocal(salidaId);
        }
      }
    }
  }
}