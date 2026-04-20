import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';

class _FaltaDetalle {
  final String hora;
  final String fecha;

  const _FaltaDetalle({required this.hora, required this.fecha});
}

class FaltasAsignaturaScreen extends StatelessWidget {
  final String subject;
  final int faltas;
  final int total;
  final Color tagColor;

  const FaltasAsignaturaScreen({
    super.key,
    required this.subject,
    required this.faltas,
    required this.total,
    required this.tagColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final appBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final headerBg = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final headerText = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final labelColor = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final dividerColor = isDark ? Colors.white24 : Colors.black26;

   
    final detalles = List.generate(
      8,
      (i) => const _FaltaDetalle(hora: '13:14', fecha: '10-12-2026'),
    );

    return Scaffold(
      backgroundColor: appBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Container(
            width: double.infinity,
            color: headerBg,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 56, 24, 20),
                child: Text(
                  subject,
                  style: GoogleFonts.rowdies(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: headerText,
                  ),
                ),
              ),
            ),
          ),
         
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 1, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Ver porciento',
                    style: GoogleFonts.rowdies(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: labelColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBg : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.green : AppColors.homeDarkGreen,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    '$faltas/$total',
                    style: GoogleFonts.rowdies(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.green : const Color(0xFF34C759),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: detalles.length,
              separatorBuilder: (_, __) => Divider(
                color: dividerColor,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final detalle = detalles[index];
                return _FaltaDetalleRow(
                  hora: detalle.hora,
                  fecha: detalle.fecha,
                  textColor: labelColor,
                  dividerColor: dividerColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FaltaDetalleRow extends StatelessWidget {
  final String hora;
  final String fecha;
  final Color textColor;
  final Color dividerColor;

  const _FaltaDetalleRow({
    required this.hora,
    required this.fecha,
    required this.textColor,
    required this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Text(
            hora,
            style: GoogleFonts.rowdies(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 2,
            height: 24,
            color: dividerColor,
          ),
          const Spacer(),
          Text(
            fecha,
            style: GoogleFonts.rowdies(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}