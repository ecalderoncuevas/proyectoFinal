import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _role = 'student';

  String get role => _role;
  bool get isStudent => _role == 'student';
  bool get isProfessor => _role == 'professor';

  void setRole(String role) {
    _role = role;
    notifyListeners();
  }
}