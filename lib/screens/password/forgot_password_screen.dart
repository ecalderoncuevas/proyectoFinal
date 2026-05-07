import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
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

// Pantalla de recuperación de contraseña: pide el email y redirige a la validación OTP
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

  // Envía el email al backend para iniciar el flujo de reseteo y navega a la pantalla de validación OTP
  Future<void> _sendReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showMessage('forgot_error_empty'.tr(), isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.forgotPassword(email);
      if (!mounted) return;
      context.push(AppRoutes.validationForgotPassword, extra: email);
    } on DioException catch (e) {
      if (!mounted) return;
      String msg = 'error_send_email'.tr();
      if (e.response?.statusCode == 404) msg = 'login_error_no_account'.tr();
      if (e.type == DioExceptionType.connectionError) {
        msg = 'login_error_no_internet'.tr();
      }
      _showMessage(msg, isError: true);
    } catch (e) {
      if (!mounted) return;
      _showMessage('error_unexpected'.tr(), isError: true);
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
                'forgot_password_title'.tr(),
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
                'forgot_password_subtitle'.tr(),
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
                  labelText: 'email'.tr(),
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
                label: 'send'.tr(),
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
