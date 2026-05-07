import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/screens/auth/login_screen.dart';
import 'package:proyecto_final_synquid/screens/auth/validation_screen.dart';
import 'package:proyecto_final_synquid/screens/auth/welcome_screen.dart';
import 'package:proyecto_final_synquid/screens/institution/select_institution_screen.dart';
import 'package:proyecto_final_synquid/screens/password/change_password_screen.dart';
import 'package:proyecto_final_synquid/screens/password/forgot_password_screen.dart';
import 'package:proyecto_final_synquid/screens/home/home_student_screen.dart';
import 'package:proyecto_final_synquid/widgets/app_shell.dart';
import 'package:proyecto_final_synquid/screens/acc/settings_screen.dart';
import 'package:proyecto_final_synquid/screens/attendance/faltas_generales_screen.dart';
import 'package:proyecto_final_synquid/screens/attendance/faltas_asignatura_screen.dart';
import 'package:proyecto_final_synquid/screens/home/schedule_screen.dart';
import 'package:proyecto_final_synquid/screens/home/home_professor_screen.dart';
import 'package:proyecto_final_synquid/screens/attendance/faltas_clase_screen.dart';
import 'package:proyecto_final_synquid/screens/home/clases_screen.dart';
import 'package:proyecto_final_synquid/screens/home/schedule_professor_screen.dart';
import 'package:proyecto_final_synquid/screens/attendance/reducir_faltas_screen.dart';
import 'package:proyecto_final_synquid/screens/acc/account_screen.dart';
import 'package:proyecto_final_synquid/models/student.dart';

// Catálogo centralizado de todas las rutas de la aplicación
// Usar estas constantes evita strings dispersos por el código al navegar con context.push/go
class AppRoutes {
  // Pantalla de selección de rol (alumno / profesor) — ruta inicial de la app
  static const welcome = '/';
  // Selección de institución en el flujo de registro de alumno
  static const selectInstitutionStudent = '/select-institution/student';
  // Selección de institución en el flujo de registro de profesor/cole
  static const selectInstitutionCole = '/select-institution/cole';
  // Login; recibe el rol ('student' | 'professor') como extra
  static const login = '/login';
  // Validación OTP por email (registro)
  static const validationEmail = '/validation-email';
  // Validación OTP para recordar el dispositivo
  static const validationDevice = '/validation-device';
  // Validación OTP dentro del flujo de recuperación de contraseña
  static const validationForgotPassword = '/validation-forgot-password';
  // Pantalla de solicitud de reset de contraseña (introduce email)
  static const forgotPassword = '/forgot-password';
  // Pantalla de cambio de contraseña; recibe el resetToken como extra
  static const changePassword = '/change-password';
  // Home del alumno — punto de entrada al ShellRoute autenticado
  static const homeStudent = '/home-student';
  // Ajustes de tema, idioma y fuente
  static const settings = '/settings';
  // Resumen global de faltas del alumno (todas las asignaturas)
  static const faltasGenerales = '/faltas-generales';
  // Detalle de faltas de una asignatura concreta; recibe groupId, subject, faltas, total, tagColor
  static const faltasAsignatura = '/faltas-asignatura';
  // Calendario semanal del alumno
  static const schedule = '/schedule';
  // Home del profesor
  static const homeProfessor = '/home-professor';
  // Faltas de toda la clase (vista del profesor); recibe groupId y groupName
  static const faltasClase = '/faltas-clase';
  // Lista de clases (alumno: sus grupos; profesor: sus grupos)
  static const clases = '/clases';
  // Agenda semanal del profesor con timeline sincronizado
  static const scheduleProfessor = '/schedule-professor';
  // Pantalla para editar la asistencia de un día concreto; recibe groupId y lista de Student
  static const reducirFaltas = '/reducir-faltas';
  // Perfil/cuenta del usuario
  static const account = '/account';

}

// Mapa vacío que se usa como fallback cuando state.extra es null en rutas que esperan un Map
Map<dynamic, dynamic> empty = <dynamic, dynamic>{};

// Instancia global del router declarativo; la app lo consume en MaterialApp.router
final appRouter = GoRouter(
  initialLocation: AppRoutes.welcome,
  routes: [
    // ── Rutas públicas (sin autenticación) ──────────────────────────────────
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    // Flujo alumno: selección de institución → login con rol 'student'
    GoRoute(
      path: AppRoutes.selectInstitutionStudent,
      builder: (context, state) => SelectInstitutionScreen(
        icon: FontAwesomeIcons.userGraduate,
        onContinue: (institution) {
          debugPrint('Estudiante eligió: ${institution.name}');
          context.push(AppRoutes.login, extra: 'student');
        },
      ),
    ),
    // Flujo profesor: selección de institución → login con rol 'professor'
    GoRoute(
      path: AppRoutes.selectInstitutionCole,
      builder: (context, state) => SelectInstitutionScreen(
        icon: FontAwesomeIcons.schoolFlag,
        onContinue: (institution) {
          debugPrint('Cole eligió: ${institution.name}');
          context.push(AppRoutes.login, extra: 'professor');
        },
      ),
    ),
    // Login: recibe el rol del paso anterior para mostrar el flujo correcto
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state){
        final role = state.extra as String? ?? 'student';
        return LoginScreen(role: role);
      },
    ),
    // OTP de verificación de email en registro
    GoRoute(
      path: AppRoutes.validationEmail,
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        return ValidationScreen(
          email: email,
          onValidate: (code, _) {
            debugPrint('Código introducido: $code para email: $email');
          },
        );
      },
    ),
    // OTP para recordar el dispositivo (incluye checkbox "Recordar")
    GoRoute(
      path: AppRoutes.validationDevice,
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        return ValidationScreen(
          email: email,
          showRememberDevice: true,
          onValidate: (code, remember) {
            debugPrint('Código: $code, Remember: $remember');
          },
        );
      },
    ),
    // OTP dentro del flujo de recuperación: al validar navega a changePassword con el token
    GoRoute(
      path: AppRoutes.validationForgotPassword,
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        return ValidationScreen(
          email: email,
          onValidate: (code, _) {
            context.push(AppRoutes.changePassword, extra: code);
          },
        );
      },
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    // Cambio de contraseña: recibe el resetToken del paso de validación OTP
    GoRoute(
      path: AppRoutes.changePassword,
      builder: (context, state) {
        final resetToken = state.extra as String?;
        return ChangePasswordScreen(resetToken: resetToken);
      },
    ),
    // ── ShellRoute autenticado ───────────────────────────────────────────────
    // AppShell envuelve todas las rutas aquí dentro: superpone botón de menú,
    // flecha de retroceso y el drawer lateral animado
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.homeStudent,
          builder: (context, state) => const HomeStudentScreen(),
        ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.faltasGenerales,
        builder: (context, state) => const FaltasGeneralesScreen(),
      ),
      GoRoute(
        path: AppRoutes.faltasAsignatura,
        builder: (context, state) {
          // Usa el mapa vacío como fallback si se navega sin pasar extra
          final data = state.extra != null ? state.extra as Map<String, dynamic> : empty;
          return FaltasAsignaturaScreen(
            groupId: data['groupId'] ?? "" ,
            subject: data['subject']  ?? "",
            faltas: data['faltas'] ?? 0,
            total: data['total'] ?? 0,
            tagColor: data['tagColor'] ?? AppColors.homeDarkGreen,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.schedule,
        builder: (context, state) => const ScheduleScreen(),
      ),
      GoRoute(
        path: AppRoutes.homeProfessor,
        builder: (context, state) => const HomeProfessorScreen(),
      ),
      GoRoute(
        path: AppRoutes.faltasClase,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return FaltasClaseScreen(
            groupId: data['groupId'] as String,
            groupName: data['groupName'] as String,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.clases,
        builder: (context, state) => const ClasesScreen(),
      ),
      GoRoute(
        path: AppRoutes.scheduleProfessor,
        builder: (context, state) => const ScheduleProfessorScreen(),
      ),
      GoRoute(
        path: AppRoutes.reducirFaltas,
        builder: (context, state) {
          // Recibe groupId (String) y la lista de Student pre-cargados desde FaltasClaseScreen
          final data = state.extra as Map<String, dynamic>;
          return ReducirFaltasScreen(
            groupId: data['groupId'] as String,
            students: data['students'] as List<Student>,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.account,
        builder: (context, state) => const AccountScreen(),
      ),
  ],
),


  ],
);