import 'dart:io';

import 'package:dio/dio.dart';

import 'package:frontend/app/core/network/api_client.dart';
import '../models/evidencia_model.dart';
import '../models/evidencia_update_request_model.dart';

class EvidenciaRemoteDatasource {
  final Dio _dio = ApiClient.dio;

  Future<EvidenciaModel> uploadEvidencia({
    required String ocurrenciaId,
    required File file,
    String? observaciones,
  }) async {
    final formData = FormData.fromMap({
      'ocurrencia_id': ocurrenciaId,
      'observaciones': observaciones,
      'file': await MultipartFile.fromFile(file.path),
    });

    final response = await _dio.post(
      '/evidencias/upload',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    return EvidenciaModel.fromJson(response.data);
  }

  Future<List<EvidenciaModel>> getEvidenciasByOcurrencia(String ocurrenciaId) async {
    final response = await _dio.get('/evidencias/ocurrencia/$ocurrenciaId');
    final data = response.data as List;
    return data.map((item) => EvidenciaModel.fromJson(item)).toList();
  }
    Future<EvidenciaModel> updateEvidencia(
    String evidenciaId,
    EvidenciaUpdateRequestModel request,
    ) async {
    final response = await _dio.put(
        '/evidencias/$evidenciaId',
        data: request.toJson(),
    );

    return EvidenciaModel.fromJson(response.data);
    }

    Future<void> deleteEvidencia(String evidenciaId) async {
    await _dio.delete('/evidencias/$evidenciaId');
    }
}