import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_final_synquid/screens/account/account_screen.dart';
import 'package:proyecto_final_synquid/screens/password/change_password_screen.dart';
import 'package:proyecto_final_synquid/screens/attendance/faltas_generales_screen.dart';
import 'package:proyecto_final_synquid/screens/password/forgot_password_screen.dart';
import 'package:proyecto_final_synquid/screens/home/home_student_screen.dart';
import 'package:proyecto_final_synquid/screens/auth/login_screen.dart';
import 'package:proyecto_final_synquid/screens/auth/register_screen.dart';
import 'package:proyecto_final_synquid/screens/account/settings_screen.dart';
import 'package:proyecto_final_synquid/screens/auth/validation_screen.dart';
import 'package:proyecto_final_synquid/screens/auth/validation_email_screen.dart';
import 'screens/auth/welcome_screen.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'screens/institution/select_institution_estudiante_screen.dart';
import 'screens/institution/select_institution_cole_screen.dart';

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
      home: const PantallaFaltasGenerales(), 
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