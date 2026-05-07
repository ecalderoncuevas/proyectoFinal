import 'package:proyecto_final_synquid/core/constants/api_constants.dart';
import 'package:proyecto_final_synquid/models/schedule_item.dart';
import 'package:proyecto_final_synquid/models/student.dart';
import 'package:proyecto_final_synquid/models/teacher_group.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';

// Accede a los endpoints del profesor autenticado para grupos, horario y alumnos
class TeacherService {
  final ApiClient _client;

  TeacherService(this._client);

  // Devuelve los grupos asignados al profesor (/teacher/myGroups)
  // Usado por HomeProfessorScreen para mostrar la lista de clases
  Future<List<TeacherGroup>> getMyGroups() async {
    try {
      final response = await _client.dio.get(ApiConstants.teacherMyGroups);
      final list = _toList(response.data);
      return list
          .map((e) => TeacherGroup.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Devuelve las clases del profesor en un rango de fechas (/teacher/schedule?from=&to=)
  // ScheduleProfessorScreen pide los próximos 7 días para construir la vista de agenda
  Future<List<TeacherScheduleItem>> getSchedule({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      // Ambas fechas en formato "YYYY-MM-DD"
      final fromStr =
          '${from.year}-${from.month.toString().padLeft(2, '0')}-${from.day.toString().padLeft(2, '0')}';
      final toStr =
          '${to.year}-${to.month.toString().padLeft(2, '0')}-${to.day.toString().padLeft(2, '0')}';
      final response = await _client.dio.get(
        ApiConstants.teacherSchedule,
        queryParameters: {'from': fromStr, 'to': toStr},
      );
      final list = _toList(response.data);
      return list
          .map((e) => TeacherScheduleItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Devuelve la lista de alumnos matriculados en un grupo (/teacher/groups/:id/students)
  // Usado por FaltasClaseScreen y ReducirFaltasScreen para mostrar los alumnos del grupo
  Future<List<Student>> getGroupStudents(String groupId) async {
    try {
      final response =
          await _client.dio.get(ApiConstants.teacherGroupStudents(groupId));
      final list = _toList(response.data);
      return list
          .map((e) => Student.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Normaliza la respuesta de la API a List independientemente de la clave del JSON
  List<dynamic> _toList(dynamic data) {
    if (data == null) return [];
    if (data is List) return data;
    if (data is Map) {
      for (final key in ['data', 'items', 'groups', 'students', 'result']) {
        if (data[key] is List) return data[key] as List;
      }
    }
    return [];
  }
}
