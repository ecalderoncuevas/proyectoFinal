import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/widgets/legend_popup.dart';

class _FaltaItem {
  final String subject;
  final int faltas;
  final int total;


const _FaltaItem({
  required this.subject,
  required this.faltas,
  required this.total,
});

  Color get tagColor {
    final ratio = faltas / total;
    if (ratio >= 0.5) return AppColors.tagRed;
    if (ratio >= 0.25) return AppColors.tagYellow;
    return AppColors.tagGreen;
  }
}

class FaltasGeneralesScreen extends StatelessWidget {
  const FaltasGeneralesScreen({super.key});


  static const _faltas = [
    _FaltaItem(subject: 'Interfaces', faltas: 10, total: 17),
    _FaltaItem(subject: 'Programación', faltas: 12, total: 17),
    _FaltaItem(subject: 'Base de datos', faltas: 14, total: 17),
    _FaltaItem(subject: 'Sistemas', faltas: 7, total: 17),
    _FaltaItem(subject: 'Entorns', faltas: 8, total: 17),
    _FaltaItem(subject: 'Inglés tecnico', faltas: 7, total: 17),
    _FaltaItem(subject: 'FOL', faltas: 3, total: 17),
    _FaltaItem(subject: 'Empresa', faltas: 4, total: 17),
    _FaltaItem(subject: 'Sistemas de gestion', faltas: 2, total: 17),
  ];
  
  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final appBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final appGreen = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final cardTextColor = isDark ? AppColors.darkBg : AppColors.homeLightBg;

    return Scaffold(
      backgroundColor: appBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FaltasHeader(headerColor: appGreen, textColor: appBg),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => LegendPopup.show(context, items: LegendPopup.faltasItems),
                child: Text(
                  'Ver leyenda',
                  style: GoogleFonts.rowdies(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: appGreen,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _faltas.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return _FaltaCard(
                  item: _faltas[index],
                  cardBgColor: appGreen,
                  cardTextColor: cardTextColor,
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _FaltasHeader extends StatelessWidget {
  final Color headerColor;
  final Color textColor;

  const _FaltasHeader({required this.headerColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: headerColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 56, 24, 20),
          child: Text(
            'Faltas',
            style: GoogleFonts.rowdies(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _FaltaCard extends StatelessWidget {
  final _FaltaItem item;
  final Color cardBgColor;
  final Color cardTextColor;

  const _FaltaCard({
    required this.item,
    required this.cardBgColor,
    required this.cardTextColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
         
          Expanded(
            child: Container(
              color: cardBgColor,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                item.subject,
                style: GoogleFonts.rowdies(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: cardTextColor,
                ),
              ),
            ),
          ),
          
          Container(
            width: 72,
            color: item.tagColor,
            alignment: Alignment.center,
            child: Text(
              '${item.faltas}/${item.total}',
              style: GoogleFonts.rowdies(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.darkBg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
