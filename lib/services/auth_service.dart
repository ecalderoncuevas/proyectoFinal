import 'package:proyecto_final_synquid/core/constants/api_constants.dart';
import 'package:proyecto_final_synquid/core/storage/token_storage.dart';
import 'package:proyecto_final_synquid/models/login_request.dart';
import 'package:proyecto_final_synquid/models/login_response.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';

class AuthService {
  final ApiClient _client;
  final TokenStorage _tokenStorage;

  AuthService(this._client, this._tokenStorage);

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _client.dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );
      final loginResponse = LoginResponse.fromJson(response.data);
      if (loginResponse.isSuccess) {
        await _tokenStorage.saveToken(loginResponse.token);
      }
      return loginResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> sendVerificationCode(String email) async {
    try {
      final response = await _client.dio.post(
        ApiConstants.verifyEmail,
        data: {'email': email},
      );
      return response.data['errorCode'] == 0;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> forgotPassword(String email) async {
    try {
      final response = await _client.dio.post(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );
      return (response.data['message'] ?? '').toString();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _client.dio.post(
        ApiConstants.resetPassword,
        data: {'token': token, 'newPassword': newPassword},
      );
      return (response.data['message'] ?? '').toString();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
    // Avisa al servidor para que el token quede invalidado en backend
    await _client.dio.post(ApiConstants.logout);
  } catch (e) {
    // Ignoramos el error intencionadamente. Si el servidor falla,
    // queremos cerrar la sesión localmente de todas formas.
  } finally {
    // Borrado local garantizado
    await _tokenStorage.deleteToken();
  }
  }
}