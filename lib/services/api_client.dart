import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:proyecto_final_synquid/core/constants/api_constants.dart';

class ApiClient {
  late final Dio dio;
  final _storage = const FlutterSecureStorage();

  ApiClient() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      
      // 👇 AQUÍ HEMOS UNIFICADO EL ONERROR (Solo puede haber uno)
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        if (error.response?.statusCode == 401) {
          try {
            // 0. Recuperamos el token actual (caducado)
            final currentToken = await _storage.read(key: 'access_token');

            if (currentToken != null) {
              // 1. Pide token nuevo al servidor enviando el body requerido
              final refreshResponse = await dio.post(
                ApiConstants.refresh,
                data: {
                  "token": currentToken
                },
              );
              
              final newToken = refreshResponse.data['token'];

              // 2. Guarda el nuevo token
              await _storage.write(key: 'access_token', value: newToken);

              // 3. Reintenta la petición original con el token nuevo
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newToken';
              
              final retryResponse = await dio.fetch(opts);
              return handler.resolve(retryResponse);
            }
          } catch (_) {
            // Si el refresh también falla, forzamos el logout local
            await _storage.delete(key: 'access_token');
          }
        }
        return handler.next(error);
      },
    ));
  }
}