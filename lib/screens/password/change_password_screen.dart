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

class ChangePasswordScreen extends StatefulWidget {
  final String? resetToken;
  const ChangePasswordScreen({super.key, this.resetToken});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late final AuthService _authService;
  bool _hasMinChars = false;
  bool _hasSpecialChar = false;
  bool _showMismatch = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(ApiClient(), TokenStorage());
    _newPasswordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_checkMatch);
  }

  void _validatePassword() {
    final password = _newPasswordController.text;
    setState(() {
      _hasMinChars = password.length >= 8;
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  void _checkMatch() {
    final confirm = _confirmPasswordController.text;
    setState(() {
      _showMismatch =
          confirm.isNotEmpty && confirm != _newPasswordController.text;
    });
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

  Future<void> _doChange() async {
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (!_hasMinChars || !_hasSpecialChar) {
      _showMessage('password_requirements'.tr(), isError: true);
      return;
    }
    if (newPass != confirmPass) {
      _showMessage('passwords_mismatch'.tr(), isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.resetToken != null && widget.resetToken!.isNotEmpty) {
        await _authService.resetPassword(
          token: widget.resetToken!,
          newPassword: newPass,
        );
      }
      if (!mounted) return;
      _showMessage('password_changed'.tr(), isError: false);
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      context.go(AppRoutes.login);
    } on DioException catch (e) {
      if (!mounted) return;
      final status = e.response?.statusCode;
      String msg = 'error_change_password'.tr();
      if (status == 400) msg = 'error_invalid_code'.tr();
      if (status == 401) msg = 'error_code_expired'.tr();
      _showMessage(msg, isError: true);
    } catch (e) {
      if (!mounted) return;
      _showMessage('error_unexpected'.tr(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'change_password_title'.tr(),
                  style: GoogleFonts.rowdies(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: appGreen,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              _LabeledPasswordField(
                label: 'new_password'.tr(),
                controller: _newPasswordController,
                appGreen: appGreen,
              ),
              const SizedBox(height: 24),
              _LabeledPasswordField(
                label: 'confirm_new_password'.tr(),
                controller: _confirmPasswordController,
                appGreen: appGreen,
              ),
              const SizedBox(height: 4),
              if (_showMismatch)
                Text(
                  'passwords_mismatch'.tr(),
                  style: GoogleFonts.rowdies(
                    fontSize: 11,
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              const SizedBox(height: 24),
              _ValidationRow(
                label: 'password_min_chars'.tr(),
                isValid: _hasMinChars,
                appGreen: appGreen,
              ),
              const SizedBox(height: 8),
              _ValidationRow(
                label: 'password_special_char'.tr(),
                isValid: _hasSpecialChar,
                appGreen: appGreen,
              ),
              const SizedBox(height: 80),
              PrimaryButton(
                label: 'change'.tr(),
                isLoading: _isLoading,
                onPressed: _doChange,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabeledPasswordField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final Color appGreen;

  const _LabeledPasswordField({
    required this.label,
    required this.controller,
    required this.appGreen,
  });

  @override
  State<_LabeledPasswordField> createState() => _LabeledPasswordFieldState();
}

class _LabeledPasswordFieldState extends State<_LabeledPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final isDark = context.read<ThemeProvider>().isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.rowdies(
            color: widget.appGreen,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          obscureText: _obscure,
          enableSuggestions: false,
          autocorrect: false,
          style: GoogleFonts.rowdies(
            color: widget.appGreen,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white24
                    : widget.appGreen.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: widget.appGreen, width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: widget.appGreen,
                size: 20,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
        ),
      ],
    );
  }
}

class _ValidationRow extends StatelessWidget {
  final String label;
  final bool isValid;
  final Color appGreen;

  const _ValidationRow({
    required this.label,
    required this.isValid,
    required this.appGreen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isValid ? appGreen : Colors.transparent,
            border: Border.all(
              color: isValid ? appGreen : appGreen.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: isValid
              ? Icon(
                  Icons.check,
                  size: 12,
                  color: context.read<ThemeProvider>().isDark
                      ? AppColors.darkBg
                      : AppColors.homeLightBg,
                )
              : null,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.rowdies(
            fontSize: 12,
            color: isValid ? appGreen : appGreen.withValues(alpha: 0.6),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
