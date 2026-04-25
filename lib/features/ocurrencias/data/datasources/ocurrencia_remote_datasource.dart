import 'package:dio/dio.dart';

import 'package:frontend/app/core/network/api_client.dart';
import '../models/especie_model.dart';
import '../models/ocurrencia_create_request_model.dart';
import '../models/ocurrencia_detail_model.dart';
import '../models/ocurrencia_list_item_model.dart';
import '../models/ocurrencia_response_model.dart';
import '../models/ocurrencia_update_request_model.dart';

class OcurrenciaRemoteDatasource {
  final Dio _dio = ApiClient.dio;

  Future<List<EspecieModel>> getSpecies() async {
    final response = await _dio.get('/species');
    final data = response.data as List;
    return data.map((item) => EspecieModel.fromJson(item)).toList();
  }

  Future<List<EspecieModel>> searchSpecies(String query) async {
    final response = await _dio.get(
      '/species/search',
      queryParameters: {'q': query},
    );
    final data = response.data as List;
    return data.map((item) => EspecieModel.fromJson(item)).toList();
  }

  Future<List<OcurrenciaListItemModel>> getOcurrenciasBySalida(
    String salidaId,
  ) async {
    final response = await _dio.get('/ocurrencias/salida/$salidaId');
    final data = response.data as List;
    return data.map((item) => OcurrenciaListItemModel.fromJson(item)).toList();
  }

  Future<OcurrenciaResponseModel> createOcurrencia(
    OcurrenciaCreateRequestModel request,
  ) async {
    final response = await _dio.post(
      '/ocurrencias',
      data: request.toJson(),
    );

    return OcurrenciaResponseModel.fromJson(response.data);
  }

  Future<OcurrenciaDetailModel> getOcurrenciaDetail(String ocurrenciaId) async {
    final response = await _dio.get('/ocurrencias/$ocurrenciaId');
    return OcurrenciaDetailModel.fromJson(response.data);
  }

  Future<void> deleteOcurrencia(String ocurrenciaId) async {
    await _dio.delete('/ocurrencias/$ocurrenciaId');
  }
  Future<OcurrenciaDetailModel> updateOcurrencia(
    String ocurrenciaId,
    OcurrenciaUpdateRequestModel request,
  ) async {
    final response = await _dio.put(
      '/ocurrencias/$ocurrenciaId',
      data: request.toJson(),
    );

    return OcurrenciaDetailModel.fromJson(response.data);
  }
}