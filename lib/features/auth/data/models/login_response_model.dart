import 'user_model.dart';

class LoginResponseModel {
  final String accessToken;
  final String tokenType;
  final UserModel user;

  LoginResponseModel({
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      user: UserModel.fromJson(json['user']),
    );
  }
}