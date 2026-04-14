class LoginResponse {
  final int errorCode;
  final String message;
  final String timestamp;
  final String token;


  LoginResponse({
    required this.errorCode,
    required this.message,
    required this.timestamp,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json){
    return LoginResponse(
      errorCode: json['errorCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      token: json['token'] as String? ?? '',
    );
  }

  bool get isSuccess => errorCode == 0 && token.isNotEmpty;
}