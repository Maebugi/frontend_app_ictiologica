import 'package:dio/dio.dart';
import 'package:frontend/app/core/network/connectivity_service.dart';
import '../datasources/ocurrencia_remote_datasource.dart';
import '../datasources/species_local_datasource.dart';
import '../models/especie_model.dart';
import '../models/ocurrencia_create_request_model.dart';
import '../models/ocurrencia_detail_model.dart';
import '../models/ocurrencia_list_item_model.dart';
import '../models/ocurrencia_response_model.dart';
import '../models/ocurrencia_update_request_model.dart';
import 'package:frontend/app/core/sync/sync_status.dart';
import '../datasources/ocurrencia_local_datasource.dart';


class OcurrenciaRepository {
  final OcurrenciaRemoteDatasource remoteDatasource;
  final SpeciesLocalDatasource localSpeciesDatasource;
  final OcurrenciaLocalDatasource localOcurrenciaDatasource;
  final ConnectivityService connectivityService;

  OcurrenciaRepository({
    required this.remoteDatasource,
    required this.localSpeciesDatasource,
    required this.localOcurrenciaDatasource,
    required this.connectivityService,
  });
  bool _isNotFoundError(Object e) {
    if (e is DioException) {
      return e.response?.statusCode == 404;
    }
    return false;
  }
  Future<List<EspecieModel>> getSpecies({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final local = await localSpeciesDatasource.getSpecies();
      if (local.isNotEmpty) return local;
    }

    final hasConnection = await connectivityService.hasConnection();
    if (!hasConnection) {
      return localSpeciesDatasource.getSpecies();
    }

    final remote = await remoteDatasource.getSpecies();
    await localSpeciesDatasource.saveSpecies(remote);
    return remote;
  }

  Future<List<EspecieModel>> searchSpecies(String query) async {
    final local = await localSpeciesDatasource.searchSpecies(query);
    if (local.isNotEmpty) return local;

    final hasConnection = await connectivityService.hasConnection();
    if (!hasConnection) return [];

    final remote = await remoteDatasource.searchSpecies(query);
    await localSpeciesDatasource.saveSpecies(remote);
    return remote;
  }

  Future<List<OcurrenciaListItemModel>> getOcurrenciasBySalida(String salidaId) async {
    final local = await localOcurrenciaDatasource.getOcurrenciasBySalida(salidaId);
    final hasConnection = await connectivityService.hasConnection();

    if (!hasConnection) {
      return local;
    }

    try {
      final remote = await remoteDatasource.getOcurrenciasBySalida(salidaId);

      for (final item in remote) {
        final detail = OcurrenciaDetailModel(
          idOcurrencia: item.idOcurrencia,
          idEspecie: item.idEspecie,
          salidaId: salidaId,
          fechaHora: item.fechaHora,
          coordenadas: null,
          altitud: null,
          esfuerzo: null,
          cpue: null,
          longitudPez: item.longitudPez,
          peso: item.peso,
          sexo: item.sexo,
          estadoOntogenetico: null,
          estadioVida: null,
          condicionReproductiva: null,
          comportamiento: null,
          anomalias: null,
          mortalidad: null,
          vouchers: null,
          nivelCerteza: null,
          anchoCauce: null,
          profundidadMedia: null,
          profundidadMaxima: null,
          caudalVelocidad: null,
          tipoHabitat: null,
          microhabitat: null,
          coberturaDosel: null,
          usoSueloRibereno: null,
          estabilidadOrillas: null,
          sustrato: null,
          clima: null,
          metodoCaptura: null,
          artePesca: null,
          codigoMuestreo: null,
          datum: null,
          observaciones: item.observaciones,
          nombreComun: item.nombreComun,
          nombreCientifico: item.nombreCientifico,
          familia: item.familia,
        );

        await localOcurrenciaDatasource.saveOcurrencia(
          detail,
          syncStatus: SyncStatus.synced,
        );
      }

      return remote;
    } catch (_) {
      return local;
    }
  }

  Future<OcurrenciaResponseModel> createOcurrencia(
    OcurrenciaCreateRequestModel request,
  ) async {
    final hasConnection = await connectivityService.hasConnection();

    if (!hasConnection) {
      final localOcurrencia = OcurrenciaDetailModel(
        idOcurrencia: request.idOcurrencia,
        idEspecie: request.idEspecie,
        salidaId: request.salidaId,
        fechaHora: request.fechaHora,
        coordenadas: request.coordenadas,
        altitud: request.altitud,
        esfuerzo: request.esfuerzo,
        cpue: request.cpue,
        longitudPez: request.longitudPez,
        peso: request.peso,
        sexo: request.sexo,
        estadoOntogenetico: request.estadoOntogenetico,
        estadioVida: request.estadioVida,
        condicionReproductiva: request.condicionReproductiva,
        comportamiento: request.comportamiento,
        anomalias: request.anomalias,
        mortalidad: request.mortalidad,
        vouchers: request.vouchers,
        nivelCerteza: request.nivelCerteza,
        anchoCauce: request.anchoCauce,
        profundidadMedia: request.profundidadMedia,
        profundidadMaxima: request.profundidadMaxima,
        caudalVelocidad: request.caudalVelocidad,
        tipoHabitat: request.tipoHabitat,
        microhabitat: request.microhabitat,
        coberturaDosel: request.coberturaDosel,
        usoSueloRibereno: request.usoSueloRibereno,
        estabilidadOrillas: request.estabilidadOrillas,
        sustrato: request.sustrato,
        clima: request.clima,
        metodoCaptura: request.metodoCaptura,
        artePesca: request.artePesca,
        codigoMuestreo: request.codigoMuestreo,
        datum: request.datum,
        observaciones: request.observaciones,
        nombreComun: request.nombreComun,
        nombreCientifico: request.nombreCientifico,
        familia: request.familia,
      );

      await localOcurrenciaDatasource.saveOcurrencia(
        localOcurrencia,
        syncStatus: SyncStatus.pendingCreate,
      );

      return OcurrenciaResponseModel(
        idOcurrencia: request.idOcurrencia,
        idEspecie: request.idEspecie,
        salidaId: request.salidaId,
      );
    }

    final remote = await remoteDatasource.createOcurrencia(request);
    return remote;
  }

  Future<OcurrenciaDetailModel> getOcurrenciaDetail(String ocurrenciaId) async {
    final local = await localOcurrenciaDatasource.getOcurrenciaById(ocurrenciaId);
    final hasConnection = await connectivityService.hasConnection();

    if (!hasConnection) {
      if (local != null) return local;
      throw Exception('Ocurrencia no encontrada en almacenamiento local');
    }

    try {
      final remote = await remoteDatasource.getOcurrenciaDetail(ocurrenciaId);

      await localOcurrenciaDatasource.saveOcurrencia(
        remote,
        syncStatus: SyncStatus.synced,
      );

      return remote;
    } catch (_) {
      if (local != null) return local;
      rethrow;
    }
  }

  Future<OcurrenciaDetailModel> updateOcurrencia(
    String ocurrenciaId,
    OcurrenciaUpdateRequestModel request,
  ) async {
    final hasConnection = await connectivityService.hasConnection();

    if (!hasConnection) {
      final current = await localOcurrenciaDatasource.getOcurrenciaById(ocurrenciaId);
      if (current == null) {
        throw Exception('No se encontró la ocurrencia local para editar');
      }

      final updated = OcurrenciaDetailModel(
        idOcurrencia: current.idOcurrencia,
        idEspecie: request.idEspecie ?? current.idEspecie,
        salidaId: current.salidaId,
        fechaHora: request.fechaHora ?? current.fechaHora,
        coordenadas: request.coordenadas ?? current.coordenadas,
        altitud: request.altitud ?? current.altitud,
        esfuerzo: request.esfuerzo ?? current.esfuerzo,
        cpue: request.cpue ?? current.cpue,
        longitudPez: request.longitudPez ?? current.longitudPez,
        peso: request.peso ?? current.peso,
        sexo: request.sexo ?? current.sexo,
        estadoOntogenetico: request.estadoOntogenetico ?? current.estadoOntogenetico,
        estadioVida: request.estadioVida ?? current.estadioVida,
        condicionReproductiva:
            request.condicionReproductiva ?? current.condicionReproductiva,
        comportamiento: request.comportamiento ?? current.comportamiento,
        anomalias: request.anomalias ?? current.anomalias,
        mortalidad: request.mortalidad ?? current.mortalidad,
        vouchers: request.vouchers ?? current.vouchers,
        nivelCerteza: request.nivelCerteza ?? current.nivelCerteza,
        anchoCauce: request.anchoCauce ?? current.anchoCauce,
        profundidadMedia: request.profundidadMedia ?? current.profundidadMedia,
        profundidadMaxima: request.profundidadMaxima ?? current.profundidadMaxima,
        caudalVelocidad: request.caudalVelocidad ?? current.caudalVelocidad,
        tipoHabitat: request.tipoHabitat ?? current.tipoHabitat,
        microhabitat: request.microhabitat ?? current.microhabitat,
        coberturaDosel: request.coberturaDosel ?? current.coberturaDosel,
        usoSueloRibereno: request.usoSueloRibereno ?? current.usoSueloRibereno,
        estabilidadOrillas: request.estabilidadOrillas ?? current.estabilidadOrillas,
        sustrato: request.sustrato ?? current.sustrato,
        clima: request.clima ?? current.clima,
        metodoCaptura: request.metodoCaptura ?? current.metodoCaptura,
        artePesca: request.artePesca ?? current.artePesca,
        codigoMuestreo: request.codigoMuestreo ?? current.codigoMuestreo,
        datum: request.datum ?? current.datum,
        observaciones: request.observaciones ?? current.observaciones,
        nombreComun: current.nombreComun,
        nombreCientifico: current.nombreCientifico,
        familia: current.familia,
      );

      await localOcurrenciaDatasource.saveOcurrencia(
        updated,
        syncStatus: SyncStatus.pendingUpdate,
      );

      return updated;
    }

    final remote = await remoteDatasource.updateOcurrencia(ocurrenciaId, request);
    await localOcurrenciaDatasource.saveOcurrencia(
      remote,
      syncStatus: SyncStatus.synced,
    );
    return remote;
  }

  Future<void> deleteOcurrencia(String ocurrenciaId) async {
    final hasConnection = await connectivityService.hasConnection();

    if (!hasConnection) {
      await localOcurrenciaDatasource.markOcurrenciaDeleted(ocurrenciaId);
      return;
    }

    await remoteDatasource.deleteOcurrencia(ocurrenciaId);
    await localOcurrenciaDatasource.markOcurrenciaDeleted(ocurrenciaId);
  }

  Future<void> syncPendingOcurrencias() async {
    final hasConnection = await connectivityService.hasConnection();
    if (!hasConnection) return;

    final pendingCreates = await localOcurrenciaDatasource.getPendingCreateOcurrencias();
    final pendingUpdates = await localOcurrenciaDatasource.getPendingUpdateOcurrencias();
    final pendingDeletes = await localOcurrenciaDatasource.getPendingDeleteOcurrenciaIds();

    // 1. Crear ocurrencias pendientes
    for (final ocurrencia in pendingCreates) {
      try {
        final request = OcurrenciaCreateRequestModel(
          idOcurrencia: ocurrencia.idOcurrencia,
          idEspecie: ocurrencia.idEspecie,
          salidaId: ocurrencia.salidaId,
          fechaHora: ocurrencia.fechaHora,
          coordenadas: ocurrencia.coordenadas,
          altitud: ocurrencia.altitud,
          esfuerzo: ocurrencia.esfuerzo,
          cpue: ocurrencia.cpue,
          longitudPez: ocurrencia.longitudPez,
          peso: ocurrencia.peso,
          sexo: ocurrencia.sexo,
          estadoOntogenetico: ocurrencia.estadoOntogenetico,
          estadioVida: ocurrencia.estadioVida,
          condicionReproductiva: ocurrencia.condicionReproductiva,
          comportamiento: ocurrencia.comportamiento,
          anomalias: ocurrencia.anomalias,
          mortalidad: ocurrencia.mortalidad,
          vouchers: ocurrencia.vouchers,
          nivelCerteza: ocurrencia.nivelCerteza,
          anchoCauce: ocurrencia.anchoCauce,
          profundidadMedia: ocurrencia.profundidadMedia,
          profundidadMaxima: ocurrencia.profundidadMaxima,
          caudalVelocidad: ocurrencia.caudalVelocidad,
          tipoHabitat: ocurrencia.tipoHabitat,
          microhabitat: ocurrencia.microhabitat,
          coberturaDosel: ocurrencia.coberturaDosel,
          usoSueloRibereno: ocurrencia.usoSueloRibereno,
          estabilidadOrillas: ocurrencia.estabilidadOrillas,
          sustrato: ocurrencia.sustrato,
          clima: ocurrencia.clima,
          metodoCaptura: ocurrencia.metodoCaptura,
          artePesca: ocurrencia.artePesca,
          codigoMuestreo: ocurrencia.codigoMuestreo,
          datum: ocurrencia.datum,
          observaciones: ocurrencia.observaciones,
          nombreComun: ocurrencia.nombreComun,
          nombreCientifico: ocurrencia.nombreCientifico,
          familia: ocurrencia.familia,
        );

        await remoteDatasource.createOcurrencia(request);
        await localOcurrenciaDatasource.markOcurrenciaSynced(ocurrencia.idOcurrencia);
      } catch (_) {
        // si falla, queda pendiente para siguiente intento
      }
    }

    // 2. Actualizar ocurrencias pendientes
    for (final ocurrencia in pendingUpdates) {
      try {
        final request = OcurrenciaUpdateRequestModel(
          idEspecie: ocurrencia.idEspecie,
          fechaHora: ocurrencia.fechaHora,
          coordenadas: ocurrencia.coordenadas,
          altitud: ocurrencia.altitud,
          esfuerzo: ocurrencia.esfuerzo,
          cpue: ocurrencia.cpue,
          longitudPez: ocurrencia.longitudPez,
          peso: ocurrencia.peso,
          sexo: ocurrencia.sexo,
          estadoOntogenetico: ocurrencia.estadoOntogenetico,
          estadioVida: ocurrencia.estadioVida,
          condicionReproductiva: ocurrencia.condicionReproductiva,
          comportamiento: ocurrencia.comportamiento,
          anomalias: ocurrencia.anomalias,
          mortalidad: ocurrencia.mortalidad,
          vouchers: ocurrencia.vouchers,
          nivelCerteza: ocurrencia.nivelCerteza,
          anchoCauce: ocurrencia.anchoCauce,
          profundidadMedia: ocurrencia.profundidadMedia,
          profundidadMaxima: ocurrencia.profundidadMaxima,
          caudalVelocidad: ocurrencia.caudalVelocidad,
          tipoHabitat: ocurrencia.tipoHabitat,
          microhabitat: ocurrencia.microhabitat,
          coberturaDosel: ocurrencia.coberturaDosel,
          usoSueloRibereno: ocurrencia.usoSueloRibereno,
          estabilidadOrillas: ocurrencia.estabilidadOrillas,
          sustrato: ocurrencia.sustrato,
          clima: ocurrencia.clima,
          metodoCaptura: ocurrencia.metodoCaptura,
          artePesca: ocurrencia.artePesca,
          codigoMuestreo: ocurrencia.codigoMuestreo,
          datum: ocurrencia.datum,
          observaciones: ocurrencia.observaciones,
        );

        await remoteDatasource.updateOcurrencia(
          ocurrencia.idOcurrencia,
          request,
        );

        await localOcurrenciaDatasource.markOcurrenciaSynced(ocurrencia.idOcurrencia);
      } catch (_) {
        // si falla, queda pendiente
      }
    }

    // 3. Eliminar ocurrencias pendientes
    for (final ocurrenciaId in pendingDeletes) {
      try {
        await remoteDatasource.deleteOcurrencia(ocurrenciaId);
        await localOcurrenciaDatasource.deleteOcurrenciaLocal(ocurrenciaId);
      } catch (e) {
        // si en remoto ya no existe, igual borramos local
        if (_isNotFoundError(e)) {
          await localOcurrenciaDatasource.deleteOcurrenciaLocal(ocurrenciaId);
        }
      }
    }
  }
}