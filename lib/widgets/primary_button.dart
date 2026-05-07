import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';

// Botón principal de la app: verde oscuro en light / verde claro en dark, con spinner de carga
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  // Cuando true, deshabilita el botón y muestra un CircularProgressIndicator en lugar del texto
  final bool isLoading;
  final double height;
  final double fontSize;
  // Si es null, ocupa el ancho máximo disponible
  final double? width;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.height = 56,
    this.fontSize = 18,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    // Adapta fondo y texto al tema activo
    final bgColor = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final textColor = isDark ? AppColors.darkBg : AppColors.homeLightBg;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        // Bloquea el botón durante la carga para evitar doble envío
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          // Estado deshabilitado: misma bg con 40 % de opacidad
          disabledBackgroundColor: bgColor.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          elevation: 0,
        ),
        // Muestra spinner proporcional al fontSize cuando está cargando
        child: isLoading
            ? SizedBox(
                height: fontSize + 4,
                width: fontSize + 4,
                child: CircularProgressIndicator(
                  color: textColor,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                label,
                style: GoogleFonts.rowdies(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
