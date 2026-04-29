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
import 'package:proyecto_final_synquid/core/providers/user_provider.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';
import 'package:proyecto_final_synquid/services/auth_service.dart';
import 'package:proyecto_final_synquid/services/user_service.dart';
import 'package:proyecto_final_synquid/widgets/back_app_bar.dart';
import 'package:proyecto_final_synquid/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, this.role = 'student'});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final AuthService _authService;
  late final UserService _userService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final client = ApiClient();
    _authService = AuthService(client, TokenStorage());
    _userService = UserService(client);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('login_error_empty'.tr(), isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authService.login(email: email, password: password);

      if (!mounted) return;

      if (response.isSuccess) {
        final userProvider = context.read<UserProvider>();
        userProvider.setRole(widget.role);

        try {
          final user = await _userService.getMe();
          if (mounted) userProvider.setUser(user);
        } catch (_) {}

        if (!mounted) return;
        if (widget.role == 'professor') {
          context.go(AppRoutes.homeProfessor);
        } else {
          context.go(AppRoutes.homeStudent);
        }
      } else {
        _showMessage(response.message, isError: true);
      }
    } on DioException catch (e) {
      if (!mounted) return;
      _showMessage(_friendlyDioError(e), isError: true);
    } catch (e) {
      if (!mounted) return;
      _showMessage('error_unexpected'.tr(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _friendlyDioError(DioException e) {
    final status = e.response?.statusCode;
    switch (status) {
      case 400:
        return 'login_error_invalid_format'.tr();
      case 401:
        return 'login_error_incorrect_password'.tr();
      case 404:
        return 'login_error_no_account'.tr();
      case 500:
      case 502:
      case 503:
        return 'login_error_server'.tr();
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'login_error_timeout'.tr();
      case DioExceptionType.connectionError:
        return 'login_error_no_internet'.tr();
      default:
        return 'login_error_generic'.tr();
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
            children: [
              const Spacer(flex: 2),
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey.shade400,
              ),
              const Spacer(flex: 2),
              _InputField(
                label: 'email'.tr(),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                appGreen: appGreen,
              ),
              const SizedBox(height: 24),
              _InputField(
                label: 'password'.tr(),
                controller: _passwordController,
                isPassword: true,
                appGreen: appGreen,
              ),
              const Spacer(flex: 3),
              PrimaryButton(
                label: 'sign_in'.tr(),
                isLoading: _isLoading,
                onPressed: _doLogin,
              ),
              const Spacer(flex: 2),
              _LinkText(
                label: 'forgot_password'.tr(),
                fontWeight: FontWeight.w700,
                color: appGreen,
                onTap: () => context.push(AppRoutes.forgotPassword),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final Color appGreen;

  const _InputField({
    required this.label,
    required this.controller,
    required this.appGreen,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscure,
      keyboardType: widget.keyboardType,
      style: GoogleFonts.rowdies(color: widget.appGreen, fontSize: 14),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: GoogleFonts.rowdies(
          color: widget.appGreen,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.appGreen, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.appGreen, width: 2),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: widget.appGreen,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
      ),
    );
  }
}

class _LinkText extends StatefulWidget {
  final String label;
  final FontWeight fontWeight;
  final Color color;
  final VoidCallback onTap;

  const _LinkText({
    required this.label,
    required this.onTap,
    required this.color,
    this.fontWeight = FontWeight.w300,
  });

  @override
  State<_LinkText> createState() => _LinkTextState();
}

class _LinkTextState extends State<_LinkText> {
  bool _pressed = false;

  void _handleTap() {
    setState(() => _pressed = true);
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _pressed = false);
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Text(
        widget.label,
        style: GoogleFonts.rowdies(
          fontSize: 13,
          color: widget.color,
          fontWeight: widget.fontWeight,
          decoration: _pressed ? TextDecoration.underline : TextDecoration.none,
          decorationColor: widget.color,
          decorationThickness: 2,
        ),
      ),
    );
  }
}
