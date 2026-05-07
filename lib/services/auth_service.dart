import 'package:proyecto_final_synquid/core/constants/api_constants.dart';
import 'package:proyecto_final_synquid/core/storage/token_storage.dart';
import 'package:proyecto_final_synquid/models/login_request.dart';
import 'package:proyecto_final_synquid/models/login_response.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';

// Gestiona todas las operaciones del ciclo de vida de autenticación
class AuthService {
  final ApiClient _client;
  final TokenStorage _tokenStorage;

  AuthService(this._client, this._tokenStorage);

  // Envía credenciales al backend y guarda el token si el login es exitoso
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
      // Solo persiste el token si el servidor indica errorCode == 0
      if (loginResponse.isSuccess) {
        await _tokenStorage.saveToken(loginResponse.token);
      }
      return loginResponse;
    } catch (e) {
      rethrow;
    }
  }

  // Solicita al backend que envíe un código OTP al email del usuario
  // Devuelve true si el servidor confirma errorCode == 0
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

  // Inicia el flujo de recuperación de contraseña enviando el email al backend
  // El servidor envía un correo con el código/token de reseteo
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

  // Cambia la contraseña usando el token de reseteo recibido por email
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

  // Cierra sesión: avisa al servidor para invalidar el token y lo borra localmente
  // El borrado local ocurre siempre aunque el servidor falle
  Future<void> logout() async {
    try {
      // Notifica al backend para que invalide el token en su registro
      await _client.dio.post(ApiConstants.logout);
    } catch (e) {
      // Si el servidor falla el logout local continúa de todas formas
    } finally {
      // Garantiza que el token se elimina del almacén seguro local
      await _tokenStorage.deleteToken();
    }
  }
}