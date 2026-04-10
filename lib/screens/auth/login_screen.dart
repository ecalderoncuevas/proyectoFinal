import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    const bgColor = AppColors.darkBg;
    const green = AppColors.green;

    return Scaffold(
      backgroundColor: bgColor,
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
                KeyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 24),

              _InputField(
                label: 'Password',
                controller: _passwordController,
                isPassword: true,
              ),

              const Spacer(flex: 3),

              _PrimaryButton(
                label: 'Sign in',
                onTap: () {},
              ),

              const SizedBox(height: 12),

              GestureDetector(
                onTap: () {},
                child: Text(
                  'Create account',
                  style: GoogleFonts.rowdies(
                    fontSize: 14,
                    color: green,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              GestureDetector(
                onTap: () {},
                child: Text(
                  'forgot your password?',
                  style: GoogleFonts.rowdies(
                    fontSize: 13,
                    color: green,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

            const SizedBox(height: 24),
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
  final TextInputType KeyboardType;

  const _InputField({
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.KeyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: KeyboardType,
      style: GoogleFonts.rowdies(
        color: Colors.white,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
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
      ),
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


        