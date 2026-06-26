import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'package:frontend/app/core/network/api_client.dart';

class ExportacionService {

  Future<File> exportarDatos() async {

    final response = await ApiClient.dio.get(
      "/exportacion",
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );

    final directory =
        await getApplicationDocumentsDirectory();

    final archivo = File(
      "${directory.path}/Exportacion_Ictiologica.zip",
    );

    await archivo.writeAsBytes(
      response.data,
    );

    return archivo;
  }
}