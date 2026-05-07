// Centraliza todas las URLs de la API REST del backend para evitar strings dispersos
class ApiConstants {
  // URL base del servidor
  static const String baseUrl =
      'https://dentinal-uncompounded-erma.ngrok-free.dev/api';

  // ── Autenticación ──────────────────────────────────────────────────────────
  static const String login = '/Auth/login';
  static const String logout = '/Auth/logout';

  // Renueva el access token enviando el token caducado en el body
  static const String refresh = '/Auth/refresh';
  static const String forgotPassword = '/Auth/forgotPassword';
  static const String resetPassword = '/Auth/resetPassword';
  // Envía el código OTP de verificación al email del usuario
  static const String verifyEmail = '/Auth/verifyEmail';

  // ── Instituciones ──────────────────────────────────────────────────────────
  static const String institutions = '/Institutions';

  // ── Usuario ────────────────────────────────────────────────────────────────
  // Devuelve el perfil del usuario autenticado
  static const String userMe = '/user/me';

  // ── Alumno ─────────────────────────────────────────────────────────────────
  // Grupos en los que está matriculado el alumno autenticado
  static const String studentMyGroups = '/student/myGroups';
  // Horario semanal del alumno para una fecha dada
  static const String studentSchedule = '/student/schedule';

  // ── Profesor ───────────────────────────────────────────────────────────────
  // Grupos asignados al profesor autenticado
  static const String teacherMyGroups = '/teacher/myGroups';
  // Horario del profesor para un rango de fechas
  static const String teacherSchedule = '/teacher/schedule';
  // Lista de alumnos de un grupo concreto (parámetro dinámico en la URL)
  static String teacherGroupStudents(String groupId) =>
      '/teacher/groups/$groupId/students';

  // ── Asistencia ─────────────────────────────────────────────────────────────
  // Historial de asistencia del alumno autenticado 
  static const String attendanceMyHistory = '/Attendance/myHistory';
  // Historial global de asistencia con filtros de grupo, fechas y paginación
  static const String attendanceHistory = '/Attendance/history';
  // Estado de asistencia de hoy para un grupo e institución
  static const String attendanceToday = '/Attendance/today';
  // Registra asistencia manual por el profesor
  static const String attendanceManual = '/Attendance/manual';
  // Actualiza el estado de asistencia de un día concreto 
  static const String attendanceDaily = '/Attendance/daily';
}