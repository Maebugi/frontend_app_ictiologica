import 'dart:io';

import 'package:dio/dio.dart';

import 'package:frontend/app/core/network/api_client.dart';

import '../models/salida_evidencia_model.dart';
import '../models/salida_evidencia_update_request_model.dart';

class SalidaEvidenciaRemoteDatasource {
  final Dio _dio = ApiClient.dio;

  Future<SalidaEvidenciaModel> uploadEvidencia({
    required String salidaId,
    required File file,
    String? observaciones,
  }) async {
    final formData = FormData.fromMap({
      'salida_id': salidaId,
      'observaciones': observaciones,
      'file': await MultipartFile.fromFile(file.path),
    });

    final response = await _dio.post(
      '/salida-evidencias/upload',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    return SalidaEvidenciaModel.fromJson(response.data);
  }

  Future<List<SalidaEvidenciaModel>> getEvidenciasBySalida(
    String salidaId,
  ) async {
    final response = await _dio.get(
      '/salida-evidencias/salida/$salidaId',
    );

    final data = response.data as List;

    return data
        .map((item) => SalidaEvidenciaModel.fromJson(item))
        .toList();
  }

  Future<SalidaEvidenciaModel> updateEvidencia(
    String evidenciaId,
    SalidaEvidenciaUpdateRequestModel request,
  ) async {
    final response = await _dio.put(
      '/salida-evidencias/$evidenciaId',
      data: request.toJson(),
    );

    return SalidaEvidenciaModel.fromJson(
      response.data,
    );
  }

  Future<void> deleteEvidencia(
    String evidenciaId,
  ) async {
    await _dio.delete(
      '/salida-evidencias/$evidenciaId',
    );
  }
}