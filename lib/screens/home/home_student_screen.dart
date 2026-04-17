import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';

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
    return Scaffold(
      backgroundColor: AppColors.homeLightBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderSection(),
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
                      onTap: () {},
                      child: Text(
                        'Ver leyenda',
                        style: GoogleFonts.rowdies(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.homeDarkGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._subjects.map(
                    (subject) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _SubjectCard(item: subject),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.homeDarkGreen,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NfcCardButton(onTap: () {}),
              const SizedBox(height: 24),
              Text(
                'Good Morning,\nname',
                style: GoogleFonts.rowdies(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: AppColors.homeLightBg,
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

  const _NfcCardButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.homeLightBg, width: 2.5),
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
                  color: AppColors.homeLightBg,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  _CardLine(width: 16),
                  SizedBox(height: 3),
                  _CardLine(width: 12),
                  SizedBox(height: 3),
                  _CardLine(width: 8),
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
  const _CardLine({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 2,
      decoration: BoxDecoration(
        color: AppColors.homeLightBg,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final _SubjectItem item;

  const _SubjectCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.green,
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
                    color: AppColors.homeDarkGreen,
                  ),
                ),
                Text(
                  item.date,
                  style: GoogleFonts.rowdies(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.homeDarkGreen,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.homeDarkGreen,
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
                    color: AppColors.homeLightBg,
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
                  onTap: () {},
                  child: Text(
                    'ver faltas  →',
                    style: GoogleFonts.rowdies(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: AppColors.homeLightBg,
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