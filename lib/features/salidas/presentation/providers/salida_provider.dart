import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../data/datasources/salida_remote_datasource.dart';
import '../../data/models/salida_create_request_model.dart';
import '../../data/models/salida_finalize_request_model.dart';
import '../../data/models/salida_model.dart';
import '../../data/repositories/salida_repository.dart';
import '../../data/models/salida_update_request_model.dart';
import 'package:frontend/app/core/network/connectivity_service.dart';
import '../../data/datasources/salida_local_datasource.dart';


class SalidaProvider extends ChangeNotifier {
  final SalidaRepository _repository = SalidaRepository(
    remoteDatasource: SalidaRemoteDatasource(),
    localDatasource: SalidaLocalDatasource(),
    connectivityService: ConnectivityService(),
  );

  final Uuid _uuid = const Uuid();

  bool isLoading = false;
  String? errorMessage;

  List<SalidaModel> salidas = [];
  SalidaModel? selectedSalida;

  Future<void> loadSalidas() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      salidas = await _repository.getSalidas();
    } on DioException catch (e) {
      errorMessage = e.response?.data.toString() ?? 'Error al cargar eventos';
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSalidaDetail(String salidaId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      selectedSalida = await _repository.getSalidaDetail(salidaId);
    } on DioException catch (e) {
      errorMessage = e.response?.data.toString() ?? 'Error al cargar evento';
      selectedSalida = null;
    } catch (e) {
      errorMessage = e.toString();
      selectedSalida = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createSalida({
    String? nombreLugar,
    DateTime? fechaInicio,
    String? observaciones,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final request = SalidaCreateRequestModel(
        salidaId: _uuid.v4(),
        nombreLugar: nombreLugar,
        fechaInicio: fechaInicio,
        observaciones: observaciones,
      );

      final created = await _repository.createSalida(request);

      salidas.insert(0, created);
      selectedSalida = created;

      return true;
    } on DioException catch (e) {
      errorMessage = e.response?.data.toString() ?? 'Error al crear evento';
      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateSalida({
    required String salidaId,
    String? nombreLugar,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? observaciones,
    String? estado,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final request = SalidaUpdateRequestModel(
        nombreLugar: nombreLugar,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        observaciones: observaciones,
        estado: estado,
      );

      final updated = await _repository.updateSalida(salidaId, request);

      selectedSalida = updated;

      final index = salidas.indexWhere((item) => item.salidaId == salidaId);
      if (index != -1) {
        salidas[index] = updated;
      }

      return true;
    } on DioException catch (e) {
      errorMessage = e.response?.data.toString() ?? 'Error al actualizar evento';
      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> finalizeSalida({
    required String salidaId,
    DateTime? fechaFin,
    String? observaciones,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final request = SalidaFinalizeRequestModel(
        fechaFin: fechaFin,
        observaciones: observaciones,
      );

      final updated = await _repository.finalizeSalida(salidaId, request);

      selectedSalida = updated;

      final index = salidas.indexWhere((item) => item.salidaId == salidaId);
      if (index != -1) {
        salidas[index] = updated;
      }

      return true;
    } on DioException catch (e) {
      errorMessage = e.response?.data.toString() ?? 'Error al finalizar evento';
      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteSalida(String salidaId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _repository.deleteSalida(salidaId);

      salidas.removeWhere((item) => item.salidaId == salidaId);

      if (selectedSalida?.salidaId == salidaId) {
        selectedSalida = null;
      }

      return true;
    } on DioException catch (e) {
      errorMessage = e.response?.data.toString() ?? 'Error al eliminar evento';
      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  //Borrar solo pruebas hpta
  Future<void> syncPendingSalidas() async {
  try {
    isLoading = true;
    notifyListeners();

    await _repository.syncPendingSalidas();

  } catch (e) {
    errorMessage = e.toString();
  } finally {
    isLoading = false;
    notifyListeners();
  }
}
}