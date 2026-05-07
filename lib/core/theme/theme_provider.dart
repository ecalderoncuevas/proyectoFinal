import 'package:flutter/material.dart';

// Gestiona el estado global de preferencias visuales (tema, fuente, idioma)
// y notifica a la UI cada vez que cambian
class ThemeProvider extends ChangeNotifier {
  // Estado interno con valores por defecto
  ThemeMode _themeMode = ThemeMode.light;
  double _fontSize = 16; // Tamaño base que se usa como multiplicador de escala
  String _language = 'Español';

  // Getters públicos para que la UI los consuma de forma reactiva
  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;
  double get fontSize => _fontSize;
  String get language => _language;

  // Alterna entre modo claro y oscuro y reconstruye los widgets que escuchan
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  // Actualiza el tamaño de fuente global; main.dart aplica la escala resultante
  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  // Guarda el idioma seleccionado para que SettingsScreen pueda mostrar el valor actual
  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }
}