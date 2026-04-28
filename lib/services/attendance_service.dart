import 'package:proyecto_final_synquid/core/constants/api_constants.dart';
import 'package:proyecto_final_synquid/models/attendance_record.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';

class AttendanceService {
  final ApiClient _client;

  AttendanceService(this._client);

  Future<List<AttendanceRecord>> getMyHistory() async {
    try {
      final response = await _client.dio.get(ApiConstants.attendanceMyHistory);
      final list = response.data as List<dynamic>;
      return list
          .map((e) => AttendanceRecord.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AttendanceHistoryItem>> getHistory({
    required String userId,
    required String groupId,
  }) async {
    try {
      final response = await _client.dio.get(
        ApiConstants.attendanceHistory,
        queryParameters: {'userId': userId, 'groupId': groupId},
      );
      final list = response.data as List<dynamic>;
      return list
          .map(
              (e) => AttendanceHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TodayAttendance>> getToday({
    required String groupId,
    required String institutionId,
  }) async {
    try {
      final response = await _client.dio.get(
        ApiConstants.attendanceToday,
        queryParameters: {'groupId': groupId, 'institutionId': institutionId},
      );
      final list = response.data as List<dynamic>;
      return list
          .map((e) => TodayAttendance.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postManual({
    required String userId,
    required int status,
    required String profesorId,
  }) async {
    try {
      await _client.dio.post(
        ApiConstants.attendanceManual,
        data: {'userId': userId, 'status': status, 'profesorId': profesorId},
      );
    } catch (e) {
      rethrow;
    }
  }
}