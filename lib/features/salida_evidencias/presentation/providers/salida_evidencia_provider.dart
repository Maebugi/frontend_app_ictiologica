import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../data/models/salida_evidencia_model.dart';
import '../../data/models/salida_evidencia_update_request_model.dart';

import '../../data/repositories/salida_evidencia_repository.dart';

import '../../data/datasource/salida_evidencia_remote_datasource.dart';
import '../../data/datasource/salida_evidencia_local_datasource.dart';

import 'package:frontend/app/core/network/connectivity_service.dart';

class SalidaEvidenciaProvider extends ChangeNotifier {
  final SalidaEvidenciaRepository _repository =
      SalidaEvidenciaRepository(
    remoteDatasource:
        SalidaEvidenciaRemoteDatasource(),
    localDatasource:
        SalidaEvidenciaLocalDatasource(),
    connectivityService:
        ConnectivityService(),
  );

  bool isLoading = false;
  bool isSaving = false;

  String? errorMessage;

  List<SalidaEvidenciaModel> evidencias = [];

  Future<void> loadEvidencias(
    String salidaId,
  ) async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      evidencias =
          await _repository.getEvidenciasBySalida(
        salidaId,
      );
    } on DioException catch (e) {
      errorMessage =
          e.response?.data.toString() ??
          'Error al cargar evidencias';
    } catch (_) {
      errorMessage =
          'Error al cargar evidencias';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> uploadEvidencia({
    required String salidaId,
    required File file,
    String? observaciones,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      final created =
          await _repository.uploadEvidencia(
        salidaId: salidaId,
        file: file,
        observaciones: observaciones,
      );

      evidencias.insert(0, created);

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateEvidencia({
    required String evidenciaId,
    String? observaciones,
  }) async {
    try {
      isSaving = true;
      errorMessage = null;

      notifyListeners();

      final request =
          SalidaEvidenciaUpdateRequestModel(
        observaciones: observaciones,
      );

      final updated =
          await _repository.updateEvidencia(
        evidenciaId,
        request,
      );

      final index = evidencias.indexWhere(
        (item) =>
            item.idFoto == evidenciaId,
      );

      if (index != -1) {
        evidencias[index] = updated;
      }

      return true;
    } on DioException catch (e) {
      errorMessage =
          e.response?.data.toString() ??
          'Error al actualizar evidencia';

      return false;
    } catch (_) {
      errorMessage =
          'Error al actualizar evidencia';

      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> deleteEvidencia(
    String evidenciaId,
  ) async {
    try {
      isSaving = true;
      errorMessage = null;

      notifyListeners();

      await _repository.deleteEvidencia(
        evidenciaId,
      );

      evidencias.removeWhere(
        (item) =>
            item.idFoto == evidenciaId,
      );

      return true;
    } on DioException catch (e) {
      errorMessage =
          e.response?.data.toString() ??
          'Error al eliminar evidencia';

      return false;
    } catch (_) {
      errorMessage =
          'Error al eliminar evidencia';

      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
  Future<void> syncPendingEvidencias() async {
      try {
        await _repository.syncPendingEvidencias();
      } catch (_) {}
    }
}