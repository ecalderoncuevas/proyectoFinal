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
    required String groupId,
  }) async {
    try {
      final DateTime toDate = DateTime.now();
      final DateTime fromDate = toDate.subtract(const Duration(days: 365));

      final String fromStr = "${fromDate.year}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}";
      final String toStr = "${toDate.year}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}";
      
      final response = await _client.dio.get(
        ApiConstants.attendanceHistory,
        queryParameters: {
          'groupId': groupId,
          'from': fromStr,
          'to': toStr,
          'page': 1,
          'limit': 1000, // 👈 Límite alto para recibir las 7 clases (o más) sin cortes
        },
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
      for (final key in ['data', 'items', 'history', 'records', 'result', 'attendances']) {
        if (data[key] is List) return data[key] as List;
      }
    }
    return [];
  }

  Future<void> updateDailyAttendance({
    required String userId,
    required String scheduleId,
    required String groupId,
    required String date,
    required int status,
  }) async {
    try {
      await _client.dio.put(
        ApiConstants.attendanceDaily, // Puedes mover esto a ApiConstants.attendanceDaily si prefieres
        data: {
          'userId': userId,
          'scheduleId': scheduleId,
          'groupId': groupId,
          'date': date,
          'status': status,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  
  Future<List<Attendance>> getMyHistoryByGroup({required String groupId}) async {
    try {
      final response = await _client.dio.get(
        ApiConstants.attendanceMyHistory, // Usa el endpoint correcto para alumnos
        queryParameters: {'groupId': groupId}, // El backend saca el userId del token
      );
      
      // Reutilizamos tu función _toList que es súper segura
      final list = _toList(response.data);
      return list.map((e) => Attendance.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }


}
