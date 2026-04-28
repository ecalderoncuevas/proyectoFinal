import 'package:flutter/material.dart';
import 'package:proyecto_final_synquid/models/attendance_record.dart';
import 'package:proyecto_final_synquid/models/student_group.dart';
import 'package:proyecto_final_synquid/models/user.dart';

class UserProvider extends ChangeNotifier {
  String _role = 'student';
  User? _user;
  List<StudentGroup>? _studentGroups;
  List<AttendanceRecord>? _attendanceHistory;
  List<StudentGroup>? _teacherGroups;

  String get role => _role;
  bool get isStudent => _role == 'student';
  bool get isProfessor => _role == 'professor';
  User? get user => _user;
  List<StudentGroup>? get studentGroups => _studentGroups;
  List<AttendanceRecord>? get attendanceHistory => _attendanceHistory;
  List<StudentGroup>? get teacherGroups => _teacherGroups;

  void setRole(String role) {
    _role = role;
    notifyListeners();
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void cacheStudentData({
    required List<StudentGroup> groups,
    required List<AttendanceRecord> history,
  }) {
    _studentGroups = groups;
    _attendanceHistory = history;
    notifyListeners();
  }

  void cacheTeacherGroups(List<StudentGroup> groups) {
    _teacherGroups = groups;
    notifyListeners();
  }

  void clear() {
    _role = 'student';
    _user = null;
    _studentGroups = null;
    _attendanceHistory = null;
    _teacherGroups = null;
    notifyListeners();
  }
}