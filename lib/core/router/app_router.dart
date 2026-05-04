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
  static const homeProfessor = '/home-professor';
  static const faltasClase = '/faltas-clase';
  static const clases = '/clases';
  static const scheduleProfessor = '/schedule-professor';
  static const reducirFaltas = '/reducir-faltas';
  static const account = '/account';
  
}

Map<dynamic, dynamic> empty = <dynamic, dynamic>{};

final appRouter = GoRouter(
  initialLocation: AppRoutes.welcome,
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
          context.push(AppRoutes.login, extra: 'student');
        },
      ),
    ),
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
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state){
        final role = state.extra as String? ?? 'student';
        return LoginScreen(role: role);
      },
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
            context.push(AppRoutes.changePassword, extra: code);
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
      builder: (context, state) {
        final resetToken = state.extra as String?;
        return ChangePasswordScreen(resetToken: resetToken);
      },
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