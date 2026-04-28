class ApiConstants {
  static const String baseUrl =
      'https://dentinal-uncompounded-erma.ngrok-free.dev/api';

  // Auth
  static const String login = '/Auth/login';
  static const String logout = '/Auth/logout';
  static const String refresh = '/Auth/refresh';
  static const String forgotPassword = '/auth/forgotPassword';
  static const String resetPassword = '/auth/resetPassword';
  static const String verifyEmail = '/Auth/verifyEmail';

  // Institutions
  static const String institutions = '/Institutions';

  // User
  static const String userMe = '/user/me';

  // Student
  static const String studentMyGroups = '/student/myGroups';
  static const String studentSchedule = '/student/schedule';

  // Teacher
  static const String teacherMyGroups = '/teacher/myGroups';
  static const String teacherSchedule = '/teacher/schedule';
  static String teacherGroupStudents(String groupId) =>
      '/teacher/groups/$groupId/students';

  // Attendance
  static const String attendanceMyHistory = '/attendance/myHistory';
  static const String attendanceHistory = '/attendance/history';
  static const String attendanceToday = '/attendance/today';
  static const String attendanceManual = '/attendance/manual';
}