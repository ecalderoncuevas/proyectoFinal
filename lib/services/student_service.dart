import 'package:proyecto_final_synquid/core/constants/api_constants.dart';
import 'package:proyecto_final_synquid/models/schedule_item.dart';
import 'package:proyecto_final_synquid/models/student_group.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';

class StudentService {
  final ApiClient _client;

  StudentService(this._client);

  Future<List<StudentGroup>> getMyGroups() async {
    try {
      final response = await _client.dio.get(ApiConstants.studentMyGroups);
      final list = response.data as List<dynamic>;
      return list
          .map((e) => StudentGroup.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ScheduleItem>> getSchedule(DateTime date) async {
    try {
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final response = await _client.dio.get(
        ApiConstants.studentSchedule,
        queryParameters: {'date': dateStr},
      );
      final list = response.data as List<dynamic>;
      return list
          .map((e) => ScheduleItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}