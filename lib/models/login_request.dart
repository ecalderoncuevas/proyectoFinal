// Payload que se envía al endpoint /Auth/login
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  // Serializa el objeto a JSON para incluirlo en el body de la petición POST
  Map<String, dynamic>toJson() => {
    'email' : email,
    'password': password,
  };
}