import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';
import 'package:proyecto_final_synquid/widgets/legend_popup.dart';

class _SubjectItem {
  final String name;
  final String group;
  final String date;
  final Color tagColor;

  const _SubjectItem({
    required this.name,
    required this.group,
    required this.date,
    required this.tagColor,
  });
}

class HomeStudentScreen extends StatelessWidget {
  const HomeStudentScreen({super.key});

  static const _subjects = [
    _SubjectItem(name: 'Interfaces', group: 'DAM1', date: '10-05', tagColor: AppColors.tagGreen),
    _SubjectItem(name: 'Interfaces', group: 'DAM2', date: '10-05', tagColor: AppColors.tagYellow),
    _SubjectItem(name: 'Interfaces', group: 'DAM2', date: '10-05', tagColor: AppColors.tagRed),
    _SubjectItem(name: 'Interfaces', group: 'DAM2', date: '10-05', tagColor: AppColors.tagGreen),
    _SubjectItem(name: 'Interfaces', group: 'DAM2', date: '10-05', tagColor: AppColors.tagYellow),
    _SubjectItem(name: 'Interfaces', group: 'DAM2', date: '10-05', tagColor: AppColors.tagRed),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final appGreen = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final appBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final cardTopBg = isDark ? AppColors.homeDarkGreen : AppColors.green;
    final cardTopText = isDark ? AppColors.homeLightBg : AppColors.homeDarkGreen;
    final cardBottomBg = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final cardBottomText = isDark ? AppColors.homeDarkGreen : AppColors.homeLightBg;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderSection(
            headerColor: appGreen,
            textColor: appBg,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => LegendPopup.show(context),
                      child: Text(
                        'Ver leyenda',
                        style: GoogleFonts.rowdies(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: appGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._subjects.map(
                    (subject) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _SubjectCard(
                        item: subject,
                        cardBgColor: cardTopBg,
                        cardTextColor: cardTopText,
                        bottomBgColor: cardBottomBg,
                        bottomTextColor: cardBottomText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final Color headerColor;
  final Color textColor;

  const _HeaderSection({
    required this.headerColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: headerColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NfcCardButton(onTap: () {}, color: textColor),
              const SizedBox(height: 24),
              Text(
                'Good Morning,\nname',
                style: GoogleFonts.rowdies(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NfcCardButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;

  const _NfcCardButton({required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2.5),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                width: 20,
                height: 14,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _CardLine(width: 16, color: color),
                  const SizedBox(height: 3),
                  _CardLine(width: 12, color: color),
                  const SizedBox(height: 3),
                  _CardLine(width: 8, color: color),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardLine extends StatelessWidget {
  final double width;
  final Color color;
  const _CardLine({required this.width, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 2,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final _SubjectItem item;
  final Color cardBgColor;
  final Color cardTextColor;
  final Color bottomBgColor;
  final Color bottomTextColor;

  const _SubjectCard({
    required this.item,
    required this.cardBgColor,
    required this.cardTextColor,
    required this.bottomBgColor,
    required this.bottomTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.rowdies(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: cardTextColor,
                  ),
                ),
                Text(
                  item.date,
                  style: GoogleFonts.rowdies(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: cardTextColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: bottomBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Text(
                  item.group,
                  style: GoogleFonts.rowdies(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: bottomTextColor,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: item.tagColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    context.push(
                      AppRoutes.faltasAsignatura,
                      extra: {
                        'subject': item.name,
                        'faltas': 5,
                        'total': 20,
                        'tagColor': item.tagColor,
                      },
                    );
                  },
                  child: Text(
                    'ver faltas  →',
                    style: GoogleFonts.rowdies(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: bottomTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
