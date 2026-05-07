// Modelo del usuario autenticado; devuelto por /user/me y cacheado en UserProvider
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;         // 'student' o 'professor'
  final String institutionId;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.institutionId,
  });

  // Concatena nombre y apellido para mostrarlo en pantallas de perfil
  String get fullName => '$firstName $lastName';

  // Deserializa el JSON del backend; usa ?? para tolerar campos nulos del servidor
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: (json['id'] ?? '').toString(),
        firstName: (json['firstName'] ?? '').toString(),
        lastName: (json['lastName'] ?? '').toString(),
        email: (json['email'] ?? '').toString(),
        role: (json['role'] ?? '').toString(),
        institutionId: (json['institutionId'] ?? '').toString(),
      );
}