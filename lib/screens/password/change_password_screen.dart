import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';

class PantallaChangePassword extends StatefulWidget {
  const PantallaChangePassword({super.key});

  @override
  State<PantallaChangePassword> createState() => _PantallaChangePasswordState();
}

class _PantallaChangePasswordState extends State<PantallaChangePassword> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
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
    const bgColor = AppColors.darkBg;
    const green = AppColors.green;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              Text(
                'Change Password',
                style: GoogleFonts.rowdies(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: green,
                ),
              ),

              const SizedBox(height: 40),

              _InputField(
                label: 'Curent Password',
                controller: _currentPasswordController,
                isPassword: true,
                isBold: true,
              ),
              
              const SizedBox(height: 4),

              GestureDetector(
                onTap: () {},
                child: Text(
                  'Forgot your password',
                  style: GoogleFonts.rowdies(
                    fontSize: 12,
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _InputField(
                label: 'New Password',
                controller: _newPasswordController,
                isPassword: true,
                isBold: true,
              ),

              const SizedBox(height: 24),

              _InputField(
                label: 'Confirm New Password',
                controller: _confirmPasswordController,
                isPassword: true,
                isBold: true,
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

              const SizedBox(height: 40),

              _PrimaryButton(
                label: 'Change',
                onTap: () {},
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
  final bool isBold;
  final TextInputType keyboardType;

  const _InputField({
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.isBold = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      enableSuggestions: false,
      autocorrect: false,
      autofillHints: null,
      style: GoogleFonts.rowdies(
        color: Colors.white,
        fontSize: 14,
        fontWeight: isBold ? FontWeight.w700 : FontWeight.w300,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.rowdies(
          color: AppColors.green,
          fontSize: 14,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w300,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.green, width: 1),
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
          width: 20,
          height: 20,
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
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.onTap,
  });

  @override

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.green,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.rowdies(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.darkBg,
            ),
          ),
        ),
      ),
    );
  }
}
        