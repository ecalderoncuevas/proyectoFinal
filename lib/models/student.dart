// Alumno de un grupo; devuelto por /teacher/groups/:id/students
// Se usa en FaltasClaseScreen y ReducirFaltasScreen para listar los alumnos
class Student {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;

  Student({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  String get fullName => '$firstName $lastName';

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        userId: (json['userId'] ?? '').toString(),
        firstName: (json['firstName'] ?? '').toString(),
        lastName: (json['lastName'] ?? '').toString(),
        email: (json['email'] ?? '').toString(),
      );
}