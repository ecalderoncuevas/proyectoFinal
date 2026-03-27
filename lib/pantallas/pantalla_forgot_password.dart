import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class PantallaForgotPassword extends StatelessWidget {
  const PantallaForgotPassword({super.key});

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              Text(
                'Forgot your\npassword',
                textAlign: TextAlign.center,
                style: GoogleFonts.rowdies(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: green,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Try sending an email to change your password',
                textAlign: TextAlign.center,
                style: GoogleFonts.rowdies(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: green,
                ),
              ),

              const SizedBox(height: 32),

              _PrimaryButton(
                label: 'SEND',
                onTap: () {},
              ),

              const Spacer(flex: 2),
            ],
          ),
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

