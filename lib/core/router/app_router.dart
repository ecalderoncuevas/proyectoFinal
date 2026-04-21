import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
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


class AppRoutes {
  static const welcome = '/';
  static const selectInstitutionStudent = '/select-institution/student';
  static const selectInstitutionCole = '/select-institution/cole';
  static const login = '/login';
  static const validationEmail = '/validation-email';
  static const validationDevice = '/validation-device';
  static const validationForgotPassword = '/validation-forgot-password';
  static const forgotPassword = '/forgot-password';
  static const changePassword = '/change-password';
  static const homeStudent = '/home-student';
  static const settings = '/settings';
  static const faltasGenerales = '/faltas-generales';
  static const faltasAsignatura = '/faltas-asignatura';
  static const schedule = '/schedule';
  
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.homeStudent,
  routes: [
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.selectInstitutionStudent,
      builder: (context, state) => SelectInstitutionScreen(
        icon: FontAwesomeIcons.userGraduate,
        onContinue: (institution) {
          debugPrint('Estudiante eligió: ${institution.name}');
          context.push(AppRoutes.login);
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.selectInstitutionCole,
      builder: (context, state) => SelectInstitutionScreen(
        icon: FontAwesomeIcons.schoolFlag,
        onContinue: (institution) {
          debugPrint('Cole eligió: ${institution.name}');
          context.push(AppRoutes.login);
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
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
    GoRoute(
      path: AppRoutes.validationForgotPassword,
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        return ValidationScreen(
          email: email,
          onValidate: (code, _) {
            debugPrint('Código forgot password: $code');
            context.push(AppRoutes.changePassword);
          },
        );
      },
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.changePassword,
      builder: (context, state) => const ChangePasswordScreen(),
    ),
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
          final data = state.extra as Map<String, dynamic>;
          return FaltasAsignaturaScreen(
            subject: data['subject'] as String,
            faltas: data['faltas'] as int,
            total: data['total'] as int,
            tagColor: data['tagColor'] as Color,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.schedule,
        builder: (context, state) => const ScheduleScreen(),
      ),
  ],
),


  ],
);