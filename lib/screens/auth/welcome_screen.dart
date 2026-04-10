import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';

class PantallaWelcome extends StatelessWidget {
  const PantallaWelcome({super.key});
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textColor = AppColors.green;
    final iconColor = isDark ? AppColors.white : AppColors.darkBg;
    
    return Scaffold(
      backgroundColor: bgColor,
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
                  color: textColor,
                  height: 1.2,
                  )
                ),
                
                const SizedBox(height: 16,),
                
                Text(
                  'Who are you?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rowdies(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: textColor,
                    ),
                    ),
                    const Spacer(flex: 2),
                                  Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _RoleCard(
                    icon: Icons.school_rounded,
                    label: 'student',
                    iconColor: iconColor,
                    textColor: textColor,
                    onTap: () {
                    },
                  ),
                  _RoleCard(
                    icon: Icons.account_balance_rounded,
                    label: 'institution',
                    iconColor: iconColor,
                    textColor: textColor,
                    onTap: () {

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

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color textColor;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 90,
            color: iconColor,
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.rowdies(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}