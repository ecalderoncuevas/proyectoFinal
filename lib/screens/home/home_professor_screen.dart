import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';

class _ClassItem {
  final String name;
  final String group;
  final String date;

  const _ClassItem({
    required this.name,
    required this.group,
    required this.date,
  });
}

class HomeProfessorScreen extends StatelessWidget {
  const HomeProfessorScreen({super.key});

  static const _classes = [
    _ClassItem(name: 'Interfaces', group: 'DAM1', date: '10-05'),
    _ClassItem(name: 'Interfaces', group: 'DAM2', date: '10-05'),
    _ClassItem(name: 'Interfaces', group: 'DAM2', date: '10-05'),
    _ClassItem(name: 'Interfaces', group: 'DAM2', date: '10-05'),
    _ClassItem(name: 'Interfaces', group: 'DAM2', date: '10-05'),
    _ClassItem(name: 'Interfaces', group: 'DAM2', date: '10-05'),
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
                  const SizedBox(height: 24),
                  ..._classes.map(
                    (classItem) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ClassCard(
                        item: classItem,
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

class _ClassCard extends StatelessWidget {
  final _ClassItem item;
  final Color cardBgColor;
  final Color cardTextColor;
  final Color bottomBgColor;
  final Color bottomTextColor;

  const _ClassCard({
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
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    context.push(
                      AppRoutes.faltasAsignatura,
                      extra: {
                        'subject': item.name,
                        'faltas': 5,
                        'total': 20,
                        'tagColor': AppColors.tagGreen,
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