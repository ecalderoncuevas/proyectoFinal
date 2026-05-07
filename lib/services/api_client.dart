import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:proyecto_final_synquid/core/constants/api_constants.dart';

// Cliente HTTP centralizado basado en Dio; todos los servicios usan esta instancia
class ApiClient {
  late final Dio dio;
  final _storage = const FlutterSecureStorage();

  ApiClient() {
    // Configura la URL base, timeouts y cabeceras comunes para todas las peticiones
    dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        // Evita la página de advertencia del túnel ngrok en peticiones directas
        'ngrok-skip-browser-warning': 'true',
      },
    ));

    // Interceptor que inyecta el token de autenticación y gestiona su renovación
    dio.interceptors.add(InterceptorsWrapper(
      // Antes de cada petición, lee el token del almacén seguro y lo añade al header
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },

      // Cuando el servidor devuelve 401 (token caducado), renueva el token automáticamente
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        if (error.response?.statusCode == 401) {
          try {
            // Lee el token caducado para enviarlo al endpoint de refresh
            final currentToken = await _storage.read(key: 'access_token');

            if (currentToken != null) {
              // Solicita un nuevo token usando el token caducado como credencial
              final refreshResponse = await dio.post(
                ApiConstants.refresh,
                data: {"token": currentToken},
              );

              final newToken = refreshResponse.data['token'];

              // Persiste el nuevo token para las siguientes peticiones
              await _storage.write(key: 'access_token', value: newToken);

              // Reintenta la petición original que había fallado con el nuevo token
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newToken';

              final retryResponse = await dio.fetch(opts);
              return handler.resolve(retryResponse);
            }
          } catch (_) {
            // Si el refresh falla (token inválido o expirado del todo), elimina la sesión local
            await _storage.delete(key: 'access_token');
          }
        }
        return handler.next(error);
      },
    ));
  }
}