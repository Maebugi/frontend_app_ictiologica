import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../data/datasources/medicion_remote_datasource.dart';
import '../../data/models/medicion_create_request_model.dart';
import '../../data/repositories/medicion_repository.dart';
import '../../data/models/medicion_model.dart';
import '../../data/models/medicion_update_request_model.dart';
import 'package:frontend/app/core/network/connectivity_service.dart';
import '../../data/datasources/medicion_local_datasource.dart';

class MedicionProvider extends ChangeNotifier {
  final MedicionRepository _repository = MedicionRepository(
    remoteDatasource: MedicionRemoteDatasource(),
    localDatasource: MedicionLocalDatasource(),
    connectivityService: ConnectivityService(),
  );
  MedicionProvider() {
    print('PROVIDER INSTANCE: $hashCode');
  }
  final Uuid _uuid = const Uuid();

  bool isSaving = false;
  bool isLoading = false;
  String? errorMessage;
  MedicionModel? selectedMedicion;
  Future<bool> createMedicion({
    required String ocurrenciaId,
    double? oxigenoDisueltoMgL,
    double? ph,
    double? turbidezNtu,
    double? conductividadUsCm,
    double? tdsMgL,
    double? temperaturaC,
    double? transparenciaSecchiCm,
    String? nivelEstadoAgua,
    double? orpMv,
    double? alcalinidadMgL,
    double? durezaMgL,
    double? salinidad,
    double? amonioMgL,
    double? fosforoMetalesMgL,
    double? nitratosMgL,
    double? nitritosMgL,
    double? fosfatosMgL,
    double? clorofilaAUgL,
    double? sstMgL,
    int? coliformesFecalesUfc,
    String? observaciones,
  }) async {
    print('CREATE -> $hashCode');
    try {
      isSaving = true;
      errorMessage = null;
      notifyListeners();

      final request = MedicionCreateRequestModel(
        medicionId: _uuid.v4(),
        ocurrenciaId: ocurrenciaId,
        oxigenoDisueltoMgL: oxigenoDisueltoMgL,
        ph: ph,
        turbidezNtu: turbidezNtu,
        conductividadUsCm: conductividadUsCm,
        tdsMgL: tdsMgL,
        temperaturaC: temperaturaC,
        transparenciaSecchiCm: transparenciaSecchiCm,
        nivelEstadoAgua: nivelEstadoAgua,
        orpMv: orpMv,
        alcalinidadMgL: alcalinidadMgL,
        durezaMgL: durezaMgL,
        salinidad: salinidad,
        amonioMgL: amonioMgL,
        fosforoMetalesMgL: fosforoMetalesMgL,
        nitratosMgL: nitratosMgL,
        nitritosMgL: nitritosMgL,
        fosfatosMgL: fosfatosMgL,
        clorofilaAUgL: clorofilaAUgL,
        sstMgL: sstMgL,
        coliformesFecalesUfc: coliformesFecalesUfc,
        observaciones: observaciones,
      );

      await _repository.createMedicion(request);

      return true;
    } on DioException catch (e) {
      errorMessage = e.response?.data.toString() ?? 'Error al crear medición 2';
      return false;
    } catch (_) {
      errorMessage = 'Error al crear medición 1 ';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
  Future<void> loadMedicion(String ocurrenciaId) async {
    print('LOAD -> $hashCode');

    try {
      isLoading = true;
      errorMessage = null;

      // 🔥 LIMPIAR estado SIEMPRE
      selectedMedicion = null;

      notifyListeners();

      final medicion = await _repository.getMedicionByOcurrencia(ocurrenciaId);

      selectedMedicion = medicion;

      print('MEDICION CARGADA: $selectedMedicion');

    } on DioException catch (e) {
      print('🔥 STATUS CODE: ${e.response?.statusCode}');
      print('🔥 DATA: ${e.response?.data}');

      if (e.response?.statusCode == 404) {
        selectedMedicion = null;
      } else {
        errorMessage = e.response?.data.toString() ?? 'Error al cargar medición';
      }

    } catch (e) {
      errorMessage = e.toString();
      selectedMedicion = null;

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateMedicion({
    required String ocurrenciaId,
    double? oxigenoDisueltoMgL,
    double? ph,
    double? turbidezNtu,
    double? conductividadUsCm,
    double? tdsMgL,
    double? temperaturaC,
    double? transparenciaSecchiCm,
    String? nivelEstadoAgua,
    double? orpMv,
    double? alcalinidadMgL,
    double? durezaMgL,
    double? salinidad,
    double? amonioMgL,
    double? fosforoMetalesMgL,
    double? nitratosMgL,
    double? nitritosMgL,
    double? fosfatosMgL,
    double? clorofilaAUgL,
    double? sstMgL,
    int? coliformesFecalesUfc,
    String? observaciones,
  }) async {
    try {
      isSaving = true;
      errorMessage = null;
      notifyListeners();

      final request = MedicionUpdateRequestModel(
        oxigenoDisueltoMgL: oxigenoDisueltoMgL,
        ph: ph,
        turbidezNtu: turbidezNtu,
        conductividadUsCm: conductividadUsCm,
        tdsMgL: tdsMgL,
        temperaturaC: temperaturaC,
        transparenciaSecchiCm: transparenciaSecchiCm,
        nivelEstadoAgua: nivelEstadoAgua,
        orpMv: orpMv,
        alcalinidadMgL: alcalinidadMgL,
        durezaMgL: durezaMgL,
        salinidad: salinidad,
        amonioMgL: amonioMgL,
        fosforoMetalesMgL: fosforoMetalesMgL,
        nitratosMgL: nitratosMgL,
        nitritosMgL: nitritosMgL,
        fosfatosMgL: fosfatosMgL,
        clorofilaAUgL: clorofilaAUgL,
        sstMgL: sstMgL,
        coliformesFecalesUfc: coliformesFecalesUfc,
        observaciones: observaciones,
      );

      final updated = await _repository.updateMedicionByOcurrencia(
        ocurrenciaId,
        request,
      );

      selectedMedicion = updated;
      return true;
    } on DioException catch (e) {
      errorMessage = e.response?.data.toString() ?? 'Error al actualizar medición';
      return false;
    } catch (_) {
      errorMessage = 'Error al actualizar medición';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
  Future<void> syncPendingMediciones() async {
    try {
      await _repository.syncPendingMediciones();
    } catch (e) {
      print('ERROR SYNC MEDICIONES: $e');
    }
  }
}