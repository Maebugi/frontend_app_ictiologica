import 'package:dio/dio.dart';

import 'package:frontend/app/core/network/api_client.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';

class AuthRemoteDatasource {
  final Dio _dio = ApiClient.dio;

  Future<void> register(RegisterRequestModel request) async {
    await _dio.post(
      '/users/register',
      data: request.toJson(),
    );
  }

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await _dio.post(
      '/auth/login',
      data: request.toJson(),
    );

    return LoginResponseModel.fromJson(response.data);
  }
}