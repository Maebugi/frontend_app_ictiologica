import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../data/datasources/ocurrencia_remote_datasource.dart';
import '../../data/datasources/ocurrencia_local_datasource.dart';
import '../../data/models/especie_model.dart';
import '../../data/models/ocurrencia_create_request_model.dart';
import '../../data/models/ocurrencia_list_item_model.dart';
import '../../data/repositories/ocurrencia_repository.dart';
import '../../data/models/ocurrencia_detail_model.dart';
import '../../data/models/ocurrencia_update_request_model.dart';
import 'package:frontend/app/core/network/connectivity_service.dart';
import '../../data/datasources/species_local_datasource.dart';

class OcurrenciaProvider extends ChangeNotifier {
  final OcurrenciaRepository _repository = OcurrenciaRepository
  (
  remoteDatasource: OcurrenciaRemoteDatasource(),
  localSpeciesDatasource: SpeciesLocalDatasource(),
  localOcurrenciaDatasource: OcurrenciaLocalDatasource(),
  connectivityService: ConnectivityService(),
  );

  final Uuid _uuid = const Uuid();

  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  List<EspecieModel> species = [];
  List<OcurrenciaListItemModel> ocurrencias = [];
  OcurrenciaDetailModel? selectedOcurrencia;

  Future<void> loadSpecies() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      species = await _repository.getSpecies();
    } on DioException catch (e) {
      errorMessage = e.response?.data.toString() ?? 'Error al cargar especies';
    } catch (_) {
      errorMessage = 'Error al cargar especies';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<EspecieModel>> searchSpecies(String query) async {
    try {
      return await _repository.searchSpecies(query);
    } catch (_) {
      return [];
    }
  }

  Future<void> loadOcurrenciasBySalida(String salidaId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      ocurrencias = await _repository.getOcurrenciasBySalida(salidaId);
    } on DioException catch (e) {
      errorMessage = e.response?.data.toString() ?? 'Error al cargar ocurrencias';
    } catch (_) {
      errorMessage = 'Error al cargar ocurrencias';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> createOcurrencia({
  required String salidaId,
  required String idEspecie,
  DateTime? fechaHora,
  String? coordenadas,
  double? altitud,
  double? esfuerzo,
  double? cpue,
  double? longitudPez,
  double? peso,
  String? sexo,
  String? estadoOntogenetico,
  String? estadioVida,
  String? condicionReproductiva,
  String? comportamiento,
  String? anomalias,
  String? mortalidad,
  String? vouchers,
  int? nivelCerteza,
  double? anchoCauce,
  double? profundidadMedia,
  double? profundidadMaxima,
  double? caudalVelocidad,
  String? tipoHabitat,
  String? microhabitat,
  double? coberturaDosel,
  String? usoSueloRibereno,
  String? estabilidadOrillas,
  String? sustrato,
  String? clima,
  String? metodoCaptura,
  String? artePesca,
  String? codigoMuestreo,
  String? datum,
  String? observaciones,

  //local
  String? nombreComun,
  String? nombreCientifico,
  String? familia,
}) async {
  try {
    isSaving = true;
    errorMessage = null;
    notifyListeners();

    final request = OcurrenciaCreateRequestModel(
      idOcurrencia: _uuid.v4(),
      idEspecie: idEspecie,
      salidaId: salidaId,
      fechaHora: fechaHora,
      coordenadas: coordenadas,
      altitud: altitud,
      esfuerzo: esfuerzo,
      cpue: cpue,
      longitudPez: longitudPez,
      peso: peso,
      sexo: sexo,
      estadoOntogenetico: estadoOntogenetico,
      estadioVida: estadioVida,
      condicionReproductiva: condicionReproductiva,
      comportamiento: comportamiento,
      anomalias: anomalias,
      mortalidad: mortalidad,
      vouchers: vouchers,
      nivelCerteza: nivelCerteza,
      anchoCauce: anchoCauce,
      profundidadMedia: profundidadMedia,
      profundidadMaxima: profundidadMaxima,
      caudalVelocidad: caudalVelocidad,
      tipoHabitat: tipoHabitat,
      microhabitat: microhabitat,
      coberturaDosel: coberturaDosel,
      usoSueloRibereno: usoSueloRibereno,
      estabilidadOrillas: estabilidadOrillas,
      sustrato: sustrato,
      clima: clima,
      metodoCaptura: metodoCaptura,
      artePesca: artePesca,
      codigoMuestreo: codigoMuestreo,
      datum: datum,
      observaciones: observaciones,

      nombreComun: nombreComun,
      nombreCientifico: nombreCientifico,
      familia: familia,
    );

    final created = await _repository.createOcurrencia(request);
    return created.idOcurrencia;
  } on DioException catch (e) {
    errorMessage = e.response?.data.toString() ?? 'Error al crear ocurrencia';
    return null;
  } catch (_) {
    errorMessage = 'Error al crear ocurrencia';
    return null;
  } finally {
    isSaving = false;
    notifyListeners();
  }
  }
  Future<void> loadOcurrenciaDetail(String ocurrenciaId) async 
  {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      selectedOcurrencia = await _repository.getOcurrenciaDetail(ocurrenciaId);
    } on DioException catch (e) {
      errorMessage = e.response?.data.toString() ?? 'Error al cargar ocurrencia';
    } catch (_) {
      errorMessage = 'Error al cargar ocurrencia';
    } finally {
      isLoading = false;
      notifyListeners();
    }
}

  Future<bool> deleteOcurrencia(String ocurrenciaId) async {
    try {
      isSaving = true;
      errorMessage = null;
      notifyListeners();

      await _repository.deleteOcurrencia(ocurrenciaId);
      ocurrencias.removeWhere((item) => item.idOcurrencia == ocurrenciaId);

      if (selectedOcurrencia?.idOcurrencia == ocurrenciaId) {
        selectedOcurrencia = null;
      }

      return true;
    } on DioException catch (e) {
      errorMessage = e.response?.data.toString() ?? 'Error al eliminar ocurrencia';
      return false;
    } catch (_) {
      errorMessage = 'Error al eliminar ocurrencia';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
  Future<bool> updateOcurrencia({
    required String ocurrenciaId,
    String? idEspecie,
    DateTime? fechaHora,
    String? coordenadas,
    double? altitud,
    double? esfuerzo,
    double? cpue,
    double? longitudPez,
    double? peso,
    String? sexo,
    String? estadoOntogenetico,
    String? estadioVida,
    String? condicionReproductiva,
    String? comportamiento,
    String? anomalias,
    String? mortalidad,
    String? vouchers,
    int? nivelCerteza,
    double? anchoCauce,
    double? profundidadMedia,
    double? profundidadMaxima,
    double? caudalVelocidad,
    String? tipoHabitat,
    String? microhabitat,
    double? coberturaDosel,
    String? usoSueloRibereno,
    String? estabilidadOrillas,
    String? sustrato,
    String? clima,
    String? metodoCaptura,
    String? artePesca,
    String? codigoMuestreo,
    String? datum,
    String? observaciones,
  }) async {
    try {
      isSaving = true;
      errorMessage = null;
      notifyListeners();

      final request = OcurrenciaUpdateRequestModel(
        idEspecie: idEspecie,
        fechaHora: fechaHora,
        coordenadas: coordenadas,
        altitud: altitud,
        esfuerzo: esfuerzo,
        cpue: cpue,
        longitudPez: longitudPez,
        peso: peso,
        sexo: sexo,
        estadoOntogenetico: estadoOntogenetico,
        estadioVida: estadioVida,
        condicionReproductiva: condicionReproductiva,
        comportamiento: comportamiento,
        anomalias: anomalias,
        mortalidad: mortalidad,
        vouchers: vouchers,
        nivelCerteza: nivelCerteza,
        anchoCauce: anchoCauce,
        profundidadMedia: profundidadMedia,
        profundidadMaxima: profundidadMaxima,
        caudalVelocidad: caudalVelocidad,
        tipoHabitat: tipoHabitat,
        microhabitat: microhabitat,
        coberturaDosel: coberturaDosel,
        usoSueloRibereno: usoSueloRibereno,
        estabilidadOrillas: estabilidadOrillas,
        sustrato: sustrato,
        clima: clima,
        metodoCaptura: metodoCaptura,
        artePesca: artePesca,
        codigoMuestreo: codigoMuestreo,
        datum: datum,
        observaciones: observaciones,
      );

      final updated = await _repository.updateOcurrencia(ocurrenciaId, request);
      selectedOcurrencia = updated;

      final index = ocurrencias.indexWhere((item) => item.idOcurrencia == ocurrenciaId);
      if (index != -1) {
        ocurrencias[index] = OcurrenciaListItemModel(
          idOcurrencia: updated.idOcurrencia,
          idEspecie: updated.idEspecie,
          fechaHora: updated.fechaHora,
          sexo: updated.sexo,
          longitudPez: updated.longitudPez,
          peso: updated.peso,
          observaciones: updated.observaciones,
        );
      }

      return true;
    } on DioException catch (e) {
      errorMessage = e.response?.data.toString() ?? 'Error al actualizar ocurrencia';
      return false;
    } catch (_) {
      errorMessage = 'Error al actualizar ocurrencia';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
  //test eliminar
  Future<void> syncPendingOcurrencias() async {
    try {
      isLoading = true;
      notifyListeners();

      await _repository.syncPendingOcurrencias();

    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}