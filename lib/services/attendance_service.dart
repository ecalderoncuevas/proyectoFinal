import 'package:proyecto_final_synquid/core/constants/api_constants.dart';
import 'package:proyecto_final_synquid/models/attendance_record.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';

// Encapsula todas las llamadas a la API relacionadas con el registro de asistencia
class AttendanceService {
  final ApiClient _client;

  AttendanceService(this._client);

  // Obtiene el historial completo de asistencia del alumno autenticado
  // Usado por HomeStudentScreen para construir el resumen de faltas por grupo
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

  // Obtiene el historial de asistencia de un grupo para los últimos 365 días
  // Devuelve AttendanceResponse con paginación; usado por FaltasClaseScreen (vista profesor)
  Future<AttendanceResponse> getHistory({
    required String groupId,
  }) async {
    try {
      final DateTime toDate = DateTime.now();
      final DateTime fromDate = toDate.subtract(const Duration(days: 365));

      // Formatea las fechas como "YYYY-MM-DD" que requiere la API
      final String fromStr = "${fromDate.year}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}";
      final String toStr = "${toDate.year}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}";

      final response = await _client.dio.get(
        ApiConstants.attendanceHistory,
        queryParameters: {
          'groupId': groupId,
          'from': fromStr,
          'to': toStr,
          'page': 1,
          'limit': 1000, // Límite alto para obtener todos los registros de una vez
        },
      );

      return AttendanceResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Obtiene el estado de asistencia de hoy para cada alumno del grupo
  // El parámetro date es opcional; si no se pasa, el backend usa la fecha actual
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

  // Obtiene un mapa userId → status para una fecha concreta
  // Usado por ReducirFaltasScreen para inicializar el dropdown de cada alumno por día
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
          'to': date, // from == to restringe la consulta a un solo día
          'page': 1,
          'limit': 1000,
        },
      );
      final parsed = AttendanceResponse.fromJson(response.data as Map<String, dynamic>);
      // Transforma la lista en un mapa para acceso O(1) por userId
      return {for (final a in parsed.attendances) a.userId: a.status};
    } catch (e) {
      rethrow;
    }
  }

  // Registra asistencia manual para un alumno (acción del profesor)
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

  // Normaliza la respuesta de la API a una List<dynamic> independientemente de la estructura
  // El backend puede devolver un array directo o un objeto con la lista bajo distintas claves
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

  // Actualiza el estado de asistencia de un alumno para una fecha específica (PUT)
  // Usado en ReducirFaltasScreen al pulsar "Guardar asistencia"
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

  // Obtiene el historial de asistencia del alumno autenticado filtrado por grupo en el cliente
  // El endpoint /Attendance/myHistory ignora groupId, por eso se filtra localmente tras la descarga
  Future<List<Attendance>> getMyHistoryByGroup({required String groupId}) async {
    try {
      final DateTime toDate = DateTime.now();
      final DateTime fromDate = toDate.subtract(const Duration(days: 365));
      final String fromStr = '${fromDate.year}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}';
      final String toStr = '${toDate.year}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}';

      // Descarga todo el historial del alumno con rango de un año
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
      // Filtra en cliente para devolver solo los registros del grupo solicitado
      return all.where((a) => a.groupId == groupId).toList();
    } catch (e) {
      rethrow;
    }
  }
}
