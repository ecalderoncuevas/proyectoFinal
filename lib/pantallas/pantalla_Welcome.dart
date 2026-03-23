import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';


class pantallas extends StatelessWidget {
  const pantallas({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textColor = AppColors.green;
    final iconColor = isDark ? AppColors.white : AppColors.darkBg;
    

    return const Placeholder();
  }
}