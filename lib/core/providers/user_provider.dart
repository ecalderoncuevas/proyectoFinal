import 'package:flutter/material.dart';
import 'package:proyecto_final_synquid/models/attendance_record.dart';
import 'package:proyecto_final_synquid/models/student_group.dart';
import 'package:proyecto_final_synquid/models/teacher_group.dart';
import 'package:proyecto_final_synquid/models/user.dart';

// Caché global en memoria del usuario autenticado y sus datos de sesión
// Evita llamadas repetidas a la API mientras la sesión esté activa
class UserProvider extends ChangeNotifier {
  // Estado interno: rol, perfil y datos cacheados por rol
  String _role = 'student';
  User? _user;
  List<StudentGroup>? _studentGroups;       // null = todavía no cargado
  List<AttendanceRecord>? _attendanceHistory;
  List<TeacherGroup>? _teacherGroups;

  // Getters de solo lectura expuestos a la UI
  String get role => _role;
  bool get isStudent => _role == 'student';
  bool get isProfessor => _role == 'professor';
  User? get user => _user;
  List<StudentGroup>? get studentGroups => _studentGroups;
  List<AttendanceRecord>? get attendanceHistory => _attendanceHistory;
  List<TeacherGroup>? get teacherGroups => _teacherGroups;

  // Fija el rol tras el login ('student' o 'professor') y reconstruye la UI
  void setRole(String role) {
    _role = role;
    notifyListeners();
  }

  // Almacena el perfil del usuario devuelto por /user/me
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  // Guarda en caché los grupos y el historial de asistencia del alumno
  // Una vez cacheados, HomeStudentScreen no vuelve a pedir la API
  void cacheStudentData({
    required List<StudentGroup> groups,
    required List<AttendanceRecord> history,
  }) {
    _studentGroups = groups;
    _attendanceHistory = history;
    notifyListeners();
  }

  // Guarda en caché los grupos del profesor tras llamar a /teacher/myGroups
  void cacheTeacherGroups(List<TeacherGroup> groups) {
    _teacherGroups = groups;
    notifyListeners();
  }

  // Restablece todos los datos al estado inicial (logout)
  void clear() {
    _role = 'student';
    _user = null;
    _studentGroups = null;
    _attendanceHistory = null;
    _teacherGroups = null;
    notifyListeners();
  }
}
