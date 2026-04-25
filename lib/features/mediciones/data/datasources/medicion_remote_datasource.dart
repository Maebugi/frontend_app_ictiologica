import 'package:dio/dio.dart';

import 'package:frontend/app/core/network/api_client.dart';
import '../models/medicion_create_request_model.dart';
import '../models/medicion_model.dart';
import '../models/medicion_update_request_model.dart';

class MedicionRemoteDatasource {
  final Dio _dio = ApiClient.dio;

  Future<void> createMedicion(MedicionCreateRequestModel request) async {
    await _dio.post(
      '/mediciones',
      data: request.toJson(),
    );
  }
  Future<MedicionModel?> getMedicionByOcurrencia(String ocurrenciaId) async {
    final response = await _dio.get('/mediciones/ocurrencia/$ocurrenciaId');

    final data = response.data;

    print('🔍 RESPUESTA BACKEND MEDICION: $data');

    // 🔥 SI ES LISTA
    if (data is List) {
      if (data.isEmpty) return null;

      return MedicionModel.fromJson(data.first);
    }

    // 🔥 SI ES OBJETO
    return MedicionModel.fromJson(data);
  }

  Future<MedicionModel> updateMedicionByOcurrencia(
    String ocurrenciaId,
    MedicionUpdateRequestModel request,
  ) async {
    final response = await _dio.put(
      '/mediciones/ocurrencia/$ocurrenciaId',
      data: request.toJson(),
    );
    return MedicionModel.fromJson(response.data);
  }
}