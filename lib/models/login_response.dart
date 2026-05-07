// Respuesta del endpoint /Auth/login
class LoginResponse {
  final int errorCode;  // 0 = éxito; cualquier otro valor = error del servidor
  final String message;
  final String timestamp;
  final String token;   // JWT vacío si el login falla

  LoginResponse({
    required this.errorCode,
    required this.message,
    required this.timestamp,
    required this.token,
  });

  // Construye el objeto desde el JSON; usa valores por defecto si algún campo falta
  factory LoginResponse.fromJson(Map<String, dynamic> json){
    return LoginResponse(
      errorCode: json['errorCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      token: json['token'] as String? ?? '',
    );
  }

  // Conveniencia: true solo si el servidor indica éxito Y hay un token válido
  bool get isSuccess => errorCode == 0 && token.isNotEmpty;
}