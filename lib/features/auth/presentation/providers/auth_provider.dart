import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:frontend/app/core/storage/secure_storage_service.dart';
import 'package:frontend/app/core/utils/error_message_parser.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/register_request_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository(
    remoteDatasource: AuthRemoteDatasource(),
  );

  final SecureStorageService _storage = SecureStorageService();

  bool isLoading = false;
  bool isAuthenticated = false;
  String? errorMessage;

  Future<bool> register({
    required String nombre,
    required String correo,
    required String contrasena,
    String? institucion,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final request = RegisterRequestModel(
        nombre: nombre,
        correo: correo,
        contrasena: contrasena,
        institucion: institucion,
      );

      await _repository.register(request);
      return true;
    } on DioException catch (e) {
      print(e.response?.data);
        print(e.response?.statusCode);

        errorMessage = ErrorMessageParser.parse(
          e.response?.data,
        fallback: 'No se pudo registrar el usuario',
    );
      isAuthenticated = false;
      return false;
    } catch (e) {
      errorMessage = 'Error al registrar usuario';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String correo,
    required String contrasena,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final request = LoginRequestModel(
        correo: correo,
        contrasena: contrasena,
      );

      final response = await _repository.login(request);

      await _storage.saveAccessToken(response.accessToken);
      await _storage.saveUserId(response.user.usuarioId);

      if (response.user.correo != null) {
        await _storage.saveUserEmail(response.user.correo!);
      }

      if (response.user.nombre != null) {
        await _storage.saveUserName(response.user.nombre!);
      }

      isAuthenticated = true;
      return true;
    } on DioException catch (e) {
      errorMessage = ErrorMessageParser.parse
      (
        e.response?.data,
        fallback: 'No se pudo iniciar sesión',
      );

      isAuthenticated = false;
      return false;
    } catch (e) {
      errorMessage = 'Error al iniciar sesión';
      isAuthenticated = false;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkSession() async {
    final token = await _storage.getAccessToken();
    isAuthenticated = token != null && token.isNotEmpty;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.clearSession();
    isAuthenticated = false;
    errorMessage = null;
    notifyListeners();
  }
}