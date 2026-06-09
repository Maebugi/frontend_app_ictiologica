import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      //baseUrl: 'http://p:8000/api/v1',
      baseUrl: 'http://192.168.1.10:8000/api/v1',
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
     )
        ..interceptors.add(
          LogInterceptor(
            request: true,
            requestBody: true,
            responseBody: true,
          ),
        );
    }