import 'package:proyecto_final_synquid/core/constants/api_constants.dart';
import 'package:proyecto_final_synquid/models/schedule_item.dart';
import 'package:proyecto_final_synquid/models/student_group.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';

// Accede a los endpoints del alumno autenticado para grupos y horario
class StudentService {
  final ApiClient _client;

  StudentService(this._client);

  // Devuelve los grupos en los que está matriculado el alumno (/student/myGroups)
  // Usado por HomeStudentScreen para mostrar las tarjetas de asignatura
  Future<List<StudentGroup>> getMyGroups() async {
    try {
      final response = await _client.dio.get(ApiConstants.studentMyGroups);
      final list = _toList(response.data);
      return list
          .map((e) => StudentGroup.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Devuelve las clases del alumno para la fecha indicada (/student/schedule?date=)
  // ScheduleScreen llama a este método al cargar para construir la caché por dayOfWeek
  Future<List<ScheduleItem>> getSchedule(DateTime date) async {
    try {
      // Formatea la fecha como "YYYY-MM-DD" que espera el backend
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final response = await _client.dio.get(
        ApiConstants.studentSchedule,
        queryParameters: {'date': dateStr},
      );
      final list = _toList(response.data);
      return list
          .map((e) => ScheduleItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Normaliza la respuesta de la API a List independientemente de la estructura del JSON
  List<dynamic> _toList(dynamic data) {
    if (data == null) return [];
    if (data is List) return data;
    if (data is Map) {
      for (final key in ['data', 'items', 'groups', 'result', 'results']) {
        if (data[key] is List) return data[key] as List;
      }
    }
    return [];
  }
}
