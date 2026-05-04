import 'package:proyecto_final_synquid/core/constants/api_constants.dart';
import 'package:proyecto_final_synquid/models/schedule_item.dart';
import 'package:proyecto_final_synquid/models/student.dart';
import 'package:proyecto_final_synquid/models/teacher_group.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';

class TeacherService {
  final ApiClient _client;

  TeacherService(this._client);

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

  Future<List<TeacherScheduleItem>> getSchedule({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
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
