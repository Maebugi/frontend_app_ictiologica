import 'package:dio/dio.dart';

import 'package:frontend/app/core/network/api_client.dart';
import '../models/salida_create_request_model.dart';
import '../models/salida_finalize_request_model.dart';
import '../models/salida_model.dart';
import '../models/salida_update_request_model.dart';

class SalidaRemoteDatasource {
  final Dio _dio = ApiClient.dio;

  Future<List<SalidaModel>> getSalidas() async {
    final response = await _dio.get('/salidas');

    final data = response.data as List;
    return data.map((item) => SalidaModel.fromJson(item)).toList();
  }

  Future<SalidaModel> getSalidaDetail(String salidaId) async {
    final response = await _dio.get('/salidas/$salidaId');
    return SalidaModel.fromJson(response.data);
  }

  Future<SalidaModel> createSalida(SalidaCreateRequestModel request) async {
    final response = await _dio.post(
      '/salidas',
      data: request.toJson(),
    );

    return SalidaModel.fromJson(response.data);
  }

  Future<SalidaModel> finalizeSalida(
    String salidaId,
    SalidaFinalizeRequestModel request,
  ) async {
    final response = await _dio.put(
      '/salidas/$salidaId/finalizar',
      data: request.toJson(),
    );

    return SalidaModel.fromJson(response.data);
  }

  Future<SalidaModel> updateSalida(
  String salidaId,
  SalidaUpdateRequestModel request,
  ) async {
    final response = await _dio.put(
      '/salidas/$salidaId',
      data: request.toJson(),
    );

    return SalidaModel.fromJson(response.data);
  }

  Future<void> deleteSalida(String salidaId) async {
    await _dio.delete('/salidas/$salidaId');
  }
}


