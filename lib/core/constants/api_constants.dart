class ApiConstants {
  static const String baseUrl =
      'https://dentinal-uncompounded-erma.ngrok-free.dev/api';

  // Auth
  static const String login = '/Auth/login';
  static const String logout = '/Auth/logout';
  static const String refresh = '/Auth/refresh';
  static const String forgotPassword = '/Auth/forgotPassword';
  static const String resetPassword = '/Auth/resetPassword';
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
  static const String attendanceMyHistory = '/Attendance/myHistory';
  static const String attendanceHistory = '/Attendance/history';
  static const String attendanceToday = '/Attendance/today';
  static const String attendanceManual = '/Attendance/manual';
  static const String attendanceDaily = '/Attendance/daily';
}