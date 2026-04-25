import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';

class AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepository({required this.remoteDatasource});

  Future<void> register(RegisterRequestModel request) {
    return remoteDatasource.register(request);
  }

  Future<LoginResponseModel> login(LoginRequestModel request) {
    return remoteDatasource.login(request);
  }
}