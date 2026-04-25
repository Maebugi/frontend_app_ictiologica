import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      //baseUrl: 'http://10.0.2.2:8000/api/v1',
      baseUrl: 'http://192.168.0.100:8000/api/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final storage = SecureStorageService();
          final token = await storage.getAccessToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
      ),
    );
}