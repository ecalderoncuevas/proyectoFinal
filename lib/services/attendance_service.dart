import 'package:proyecto_final_synquid/core/constants/api_constants.dart';
import 'package:proyecto_final_synquid/models/attendance_record.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';

class AttendanceService {
  final ApiClient _client;

  AttendanceService(this._client);

  Future<List<AttendanceRecord>> getMyHistory() async {
    try {
      final DateTime toDate = DateTime.now();
      final DateTime fromDate = toDate.subtract(const Duration(days: 365));
      final String fromStr = '${fromDate.year}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}';
      final String toStr = '${toDate.year}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}';

      final response = await _client.dio.get(
        ApiConstants.attendanceMyHistory,
        queryParameters: {
          'from': fromStr,
          'to': toStr,
          'page': 1,
          'limit': 1000,
        },
      );
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
          'limit': 1000, 
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
    String? date, 
  }) async {
    try {
      final response = await _client.dio.get(
        ApiConstants.attendanceToday,
        queryParameters: {
          'groupId': groupId, 
          'institutionId': institutionId,
          if (date != null) 'date': date, 
        },
      );
      final list = _toList(response.data);
      return list
          .map((e) => TodayAttendance.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Devuelve userId → status para una fecha concreta usando el endpoint de historial
  Future<Map<String, int>> getStatusByDate({
    required String groupId,
    required String date, // formato "YYYY-MM-DD"
  }) async {
    try {
      final response = await _client.dio.get(
        ApiConstants.attendanceHistory,
        queryParameters: {
          'groupId': groupId,
          'from': date,
          'to': date,
          'page': 1,
          'limit': 1000,
        },
      );
      final parsed = AttendanceResponse.fromJson(response.data as Map<String, dynamic>);
      return {for (final a in parsed.attendances) a.userId: a.status};
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
        ApiConstants.attendanceDaily,
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
      final DateTime toDate = DateTime.now();
      final DateTime fromDate = toDate.subtract(const Duration(days: 365));
      final String fromStr = '${fromDate.year}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}';
      final String toStr = '${toDate.year}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}';

      // myHistory no acepta groupId — el backend lo ignora.
      // Pedimos todo el historial con el mismo rango que usa el profesor
      // y filtramos por groupId en el cliente.
      final response = await _client.dio.get(
        ApiConstants.attendanceMyHistory,
        queryParameters: {
          'from': fromStr,
          'to': toStr,
          'page': 1,
          'limit': 1000,
        },
      );

      final list = _toList(response.data);
      final all = list.map((e) => Attendance.fromJson(e as Map<String, dynamic>)).toList();
      return all.where((a) => a.groupId == groupId).toList();
    } catch (e) {
      rethrow;
    }
  }


}
