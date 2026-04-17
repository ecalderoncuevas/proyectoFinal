import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/widgets/back_app_bar.dart';
import 'package:proyecto_final_synquid/widgets/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';

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
  bool _showMismatch = false; 

  @override
  void initState() {
    super.initState();
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
    _showMismatch = confirm.isNotEmpty &&
        confirm != _newPasswordController.text;
  });
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
              _LabeledPasswordField(
                label: 'Current Password',
                controller: _currentPasswordController,
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
              _LabeledPasswordField(
                label: 'New Password',
                controller: _newPasswordController,
              ),
              const SizedBox(height: 24),

              _LabeledPasswordField(
                label: 'Confirm New Password',
                controller: _confirmPasswordController,
              ),
              const SizedBox(height: 4),
              if (_showMismatch)
                Text(
                  'No coinciden las contraseñas',
                  style: GoogleFonts.rowdies(
                    fontSize: 11,
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w700,
                  ),
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
                  final newPass = _newPasswordController.text;
                  final confirmPass = _confirmPasswordController.text;

                  if(_currentPasswordController.text.isEmpty) {
                    _showMessage('Please enter your current password', isError: true);
                  }
                  if (!_hasMinChars || !_hasSpecialChar) {
                    _showMessage('Password does not meet requirements', isError: true);
                    return;
                  }
                  if (newPass != confirmPass) {
                    _showMessage('Passwords do not match', isError: true);
                    return;
                  }

                  _showMessage('Password changed succesfully', isError: false);
                  context.go(AppRoutes.login);
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

class _LabeledPasswordField extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const _LabeledPasswordField({
    required this.label,
    required this.controller,
  });

  @override
  State<_LabeledPasswordField> createState() => _LabeledPasswordFieldState();
}

class _LabeledPasswordFieldState extends State<_LabeledPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.rowdies(
            color: AppColors.green,
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
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24, width: 1),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.green, width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.green,
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

  const _ValidationRow({
    required this.label,
    required this.isValid,
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
            color: isValid ? AppColors.green : Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}