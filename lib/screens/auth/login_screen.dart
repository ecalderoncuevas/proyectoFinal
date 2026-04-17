import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';
import 'package:proyecto_final_synquid/core/storage/token_storage.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';
import 'package:proyecto_final_synquid/services/auth_service.dart';
import 'package:proyecto_final_synquid/widgets/back_app_bar.dart';
import 'package:proyecto_final_synquid/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please enter email and password', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (!mounted) return;
      
      if (response.isSuccess) {
        _showMessage(response.message, isError: false);
        context.go(AppRoutes.homeStudent);
        }else {
          _showMessage(response.message, isError: true);
      }
    } on DioException catch (e) {
      if (!mounted) return;
      _showMessage(_friendlyDioError(e), isError: true);
    } catch (e) {
      if (!mounted) return;
      _showMessage('Unexpected error. Please try again.', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _friendlyDioError(DioException e) {
    final status = e.response?.statusCode;
    switch (status) {
      case 400:
        return 'Invalid email or password format';
      case 401:
        return 'Incorrect password';
      case 404:
        return 'No account found with this email';
      case 500:
      case 502:
      case 503:
        return 'Server error. Please try again later';
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection timeout. Check your internet';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      default:
        return 'Login failed. Please try again';
    }
  }

  void _showMessage(String text, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: isError ? Colors.redAccent : AppColors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
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
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              _InputField(
                label: 'Password',
                controller: _passwordController,
                isPassword: true,
              ),
              const Spacer(flex: 3),
              PrimaryButton(
                label: 'Sign in',
                isLoading: _isLoading,
                onPressed: _doLogin,
              ),
              const SizedBox(height: 12),
              _LinkText(
                label: 'Create account',
                fontWeight: FontWeight.w300,
                onTap: () {
                },
              ),
              const Spacer(flex: 2),
              _LinkText(
                label: 'forgot your password?',
                fontWeight: FontWeight.w700,
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

  const _InputField({
    required this.label,
    required this.controller,
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
      style: GoogleFonts.rowdies(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: GoogleFonts.rowdies(
          color: AppColors.green,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.green, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.green, width: 2),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.green,
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
  final VoidCallback onTap;

  const _LinkText({
    required this.label,
    required this.onTap,
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
          color: AppColors.green,
          fontWeight: widget.fontWeight,
          decoration: _pressed ? TextDecoration.underline : TextDecoration.none,
          decorationColor: AppColors.green,
          decorationThickness: 2,
        ),
      ),
    );
  }
}