import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_final_synquid/screens/auth/login_screen.dart';
import 'package:proyecto_final_synquid/screens/auth/validation_screen.dart';
import 'package:proyecto_final_synquid/screens/auth/welcome_screen.dart';
import 'package:proyecto_final_synquid/screens/institution/select_institution_screen.dart';
import 'package:proyecto_final_synquid/screens/password/change_password_screen.dart';
import 'package:proyecto_final_synquid/screens/password/forgot_password_screen.dart';

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
}

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
  ],
);