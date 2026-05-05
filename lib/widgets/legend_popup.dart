import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';

class LegendItem {
  final String label;
  final Color color;

  const LegendItem({required this.label, required this.color});
}

class LegendPopup {
  static const _defaultItems = [
    LegendItem(label: 'dbiendd', color: AppColors.tagGreen),
    LegendItem(label: 'cuidado', color: AppColors.tagYellow),
    LegendItem(label: 'critico', color: AppColors.tagRed),
  ];

  static const faltasItems = [
    LegendItem(label: 'bien', color: AppColors.tagGreen),
    LegendItem(label: 'cuidado', color: AppColors.tagYellow),
    LegendItem(label: 'critico', color: AppColors.tagRed),
  ];

  static Future<void> show(
    BuildContext context, {
    List<LegendItem>? items,
  }) {
    final legendItems = items ?? _defaultItems;

    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'cerrar',
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInCubic,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curve),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 280,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.homeLightBg,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'leyenda'.tr(),
                    style: GoogleFonts.rowdies(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.homeDarkGreen,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...legendItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _LegendRow(label: item.label, color: item.color),
                  )),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.homeDarkGreen,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          'cerrar'.tr(),
                          style: GoogleFonts.rowdies(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.homeLightBg,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LegendRow extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendRow({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label.tr(),
          style: GoogleFonts.rowdies(
            fontSize: 15,
            fontWeight: FontWeight.w300,
            color: AppColors.homeDarkGreen,
          ),
        ),
        const Spacer(),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ],
    );
  }
}
