import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';
import 'package:proyecto_final_synquid/core/storage/token_storage.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';
import 'package:proyecto_final_synquid/services/auth_service.dart';
import 'package:proyecto_final_synquid/widgets/back_app_bar.dart';
import 'package:proyecto_final_synquid/widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  late final AuthService _authService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(ApiClient(), TokenStorage());
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showMessage('Por favor introduce tu email', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.forgotPassword(email);
      if (!mounted) return;
      context.push(AppRoutes.validationForgotPassword, extra: email);
    } on DioException catch (e) {
      if (!mounted) return;
      final status = e.response?.statusCode;
      String msg = 'Error al enviar el email';
      if (status == 404) msg = 'No se encontró ninguna cuenta con ese email';
      if (e.type == DioExceptionType.connectionError) {
        msg = 'Sin conexión a internet';
      }
      _showMessage(msg, isError: true);
    } catch (e) {
      if (!mounted) return;
      _showMessage('Error inesperado. Inténtalo de nuevo.', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String text, {required bool isError}) {
    final isDark = context.read<ThemeProvider>().isDark;
    final appGreen = isDark ? AppColors.green : AppColors.homeDarkGreen;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: isError ? Colors.redAccent : appGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final appGreen = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final appBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;

    return Scaffold(
      backgroundColor: appBg,
      appBar: const BackAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Text(
                'Forgot your\npassword?',
                textAlign: TextAlign.center,
                style: GoogleFonts.rowdies(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: appGreen,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Introduce tu email y te enviaremos\nun enlace para recuperar tu contraseña',
                textAlign: TextAlign.center,
                style: GoogleFonts.rowdies(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: appGreen,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.rowdies(color: appGreen, fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: GoogleFonts.rowdies(
                    color: appGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: appGreen, width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: appGreen, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'SEND',
                isLoading: _isLoading,
                onPressed: _sendReset,
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}