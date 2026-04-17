import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/widgets/back_app_bar.dart';
import 'package:proyecto_final_synquid/widgets/primary_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
              const SizedBox(height: 32),
              Text(
                'Try sending an email to change your password',
                textAlign: TextAlign.center,
                style: GoogleFonts.rowdies(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: appGreen,
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'SEND',
                onPressed: () {
                  context.push(AppRoutes.validationForgotPassword);
                },
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
