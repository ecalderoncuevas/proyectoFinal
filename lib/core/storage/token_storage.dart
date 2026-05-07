import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Abstrae el acceso seguro al access token usando el keychain/keystore del SO
class TokenStorage {
  // Clave bajo la que se guarda el token en el almacén seguro
  static const _tokenKey = 'access_token';
  final _storage = const FlutterSecureStorage();

  // Persiste el token recibido tras un login exitoso
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Recupera el token actual; devuelve null si no hay sesión activa
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Elimina el token del almacén (cierre de sesión local)
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // Indica si el usuario tiene una sesión activa con token válido
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}