import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Text(
                'Welcome to\nSynquid',
                textAlign: TextAlign.center,
                style: GoogleFonts.rowdies(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: AppColors.green,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Who are you?',
                textAlign: TextAlign.center,
                style: GoogleFonts.rowdies(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const Spacer(flex: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _RoleButton(
                    icon: FontAwesomeIcons.userGraduate,
                    label: 'student',
                    onTap: () {
                      debugPrint('>>> Student tocado');
                      context.push(AppRoutes.selectInstitutionStudent);
                      },
                    ),
                    _RoleButton(
                      icon: FontAwesomeIcons.schoolFlag,
                      label: 'institution',
                      onTap: () {
                        debugPrint('>>> Institution tocado');
                        context.push(AppRoutes.selectInstitutionCole);
                        },
                      ),
                ],
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _RoleButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: 70, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.rowdies(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}