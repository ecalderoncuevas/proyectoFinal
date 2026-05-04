import 'package:proyecto_final_synquid/core/constants/api_constants.dart';
import 'package:proyecto_final_synquid/models/attendance_record.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';

class AttendanceService {
  final ApiClient _client;

  AttendanceService(this._client);

  Future<List<AttendanceRecord>> getMyHistory() async {
    try {
      final response = await _client.dio.get(ApiConstants.attendanceMyHistory);
      final list = _toList(response.data);
      return list
          .map((e) => AttendanceRecord.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<AttendanceResponse> getHistory({
    required String userId,
    required String groupId,
  }) async {
    try {
      final response = await _client.dio.get(
        ApiConstants.attendanceMyHistory,
        queryParameters: {'userId': userId, 'groupId': groupId},
      );

      return AttendanceResponse.fromJson(response.data as Map<String, dynamic>);
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
      final list = _toList(response.data);
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

  List<dynamic> _toList(dynamic data) {
    if (data == null) return [];
    if (data is List) return data;
    if (data is Map) {
      for (final key in ['data', 'items', 'history', 'records', 'result']) {
        if (data[key] is List) return data[key] as List;
      }
    }
    return [];
  }
}
