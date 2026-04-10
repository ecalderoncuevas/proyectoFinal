import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'screens/institution/select_institution_estudiante_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const SynquidApp());
}

class SynquidApp extends StatelessWidget {
  const SynquidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synquid',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBg,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBg,
      ),
      home: const SelectInstitucionEstudianteScreen(), 
    );
  }
}

//SelectInstitucionEstudiante

//SelectInstitucionCole

//PantallaValidation

//PantallaRegister

//PantallaChangePassword

//PantallaLogin

//PantallaSettings

//PantallaHomeEstudiante