import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_final_synquid/pantallas/pantalla_change_password.dart';
import 'package:proyecto_final_synquid/pantallas/pantalla_login.dart';
import 'package:proyecto_final_synquid/pantallas/pantalla_register.dart';
import 'package:proyecto_final_synquid/pantallas/pantalla_validation.dart';
import 'pantallas/pantalla_Welcome.dart';
import 'theme/app_theme.dart';
import 'pantallas/pantalla_Select_Institucion_Estudiante.dart';
import 'pantallas/pantalla_Select_Institucion_Cole.dart';

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
      home: const PantallaChangePassword(), 
    );
  }
}

//SelectInstitucionEstudiante, SelectInstitucionCole

//PantallaValidation

//PantallaRegister

//PantallaChangePassword

//PantallaLogin