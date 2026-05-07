import 'package:proyecto_final_synquid/core/constants/api_constants.dart';
import 'package:proyecto_final_synquid/models/user.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';

// Obtiene el perfil del usuario autenticado desde el backend
class UserService {
  final ApiClient _client;

  UserService(this._client);

  // Llama a /user/me y devuelve el objeto User con id, nombre, email, rol e institución
  // LoginScreen lo llama justo después de un login exitoso para poblar UserProvider
  Future<User> getMe() async {
    try {
      final response = await _client.dio.get(ApiConstants.userMe);
      return User.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}