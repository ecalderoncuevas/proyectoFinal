import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/widgets/back_app_bar.dart';
import 'package:proyecto_final_synquid/widgets/primary_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _hasMinChars = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    final password = _newPasswordController.text;
    setState(() {
      _hasMinChars = password.length >= 8;
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
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
                  'Change Password',
                  style: GoogleFonts.rowdies(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              _InputField(
                label: 'Current Password',
                controller: _currentPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Forgot your password?',
                  style: GoogleFonts.rowdies(
                    fontSize: 11,
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _InputField(
                label: 'New Password',
                controller: _newPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 24),
              _InputField(
                label: 'Confirm New Password',
                controller: _confirmPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 24),
              _ValidationRow(
                label: 'At least 8 Characters',
                isValid: _hasMinChars,
              ),
              const SizedBox(height: 8),
              _ValidationRow(
                label: 'At least 1 Special Character',
                isValid: _hasSpecialChar,
              ),
              const SizedBox(height: 80),
              PrimaryButton(
                label: 'Change',
                onPressed: () {
                  // TODO: validar passwords coinciden + llamar a /Auth/changePasword
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;

  const _InputField({
    required this.label,
    required this.controller,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      enableSuggestions: false,
      autocorrect: false,
      style: GoogleFonts.rowdies(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.rowdies(
          color: AppColors.green,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white24, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.green, width: 2),
        ),
      ),
    );
  }
}

class _ValidationRow extends StatelessWidget {
  final String label;
  final bool isValid;

  const _ValidationRow({
    required this.label,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isValid ? AppColors.green : Colors.transparent,
            border: Border.all(
              color: isValid ? AppColors.green : Colors.white54,
              width: 1.5,
            ),
          ),
          child: isValid
              ? const Icon(Icons.check, size: 12, color: AppColors.darkBg)
              : null,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.rowdies(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}