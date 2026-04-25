import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<void> saveUserId(String userId) async {
    await _storage.write(key: 'user_id', value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: 'user_email', value: email);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: 'user_email');
  }

  Future<void> saveUserName(String name) async {
    await _storage.write(key: 'user_name', value: name);
  }

  Future<String?> getUserName() async {
    return await _storage.read(key: 'user_name');
  }

  Future<void> clearSession() async {
    await _storage.deleteAll();
  }
}