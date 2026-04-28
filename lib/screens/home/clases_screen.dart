import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/core/providers/user_provider.dart';
import 'package:proyecto_final_synquid/models/attendance_record.dart';
import 'package:proyecto_final_synquid/models/student_group.dart';
import 'package:proyecto_final_synquid/models/teacher_group.dart';

class ClasesScreen extends StatelessWidget {
  const ClasesScreen({super.key});

  Color _tagColor(int faltas, int total) {
    if (total == 0) return AppColors.tagGreen;
    final ratio = faltas / total;
    if (ratio >= 0.5) return AppColors.tagRed;
    if (ratio >= 0.25) return AppColors.tagYellow;
    return AppColors.tagGreen;
  }

  Map<String, Map<String, int>> _computeSummary(List<AttendanceRecord> history) {
    final map = <String, Map<String, int>>{};
    for (final r in history) {
      map.putIfAbsent(r.groupId, () => {'faltas': 0, 'total': 0});
      map[r.groupId]!['total'] = map[r.groupId]!['total']! + 1;
      if (r.status == 1) {
        map[r.groupId]!['faltas'] = map[r.groupId]!['faltas']! + 1;
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final provider = context.watch<UserProvider>();
    final appBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final headerBg = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final headerText = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final labelColor = isDark ? AppColors.green : AppColors.homeDarkGreen;

    final isProfessor = provider.isProfessor;

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
                  isProfessor ? 'Mis clases' : 'Tus clases',
                  style: GoogleFonts.rowdies(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: headerText,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: isProfessor
                ? _ProfessorView(labelColor: labelColor, isDark: isDark)
                : _StudentView(
                    labelColor: labelColor,
                    isDark: isDark,
                    groups: provider.studentGroups ?? [],
                    summary: _computeSummary(provider.attendanceHistory ?? []),
                    tagColorFn: _tagColor,
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Vista profesor ───────────────────────────────────────────────────────────

class _ProfessorView extends StatelessWidget {
  final Color labelColor;
  final bool isDark;

  const _ProfessorView({required this.labelColor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final groups = context.watch<UserProvider>().teacherGroups ?? [];
    final cardBg = isDark ? AppColors.homeDarkGreen : AppColors.green;
    final cardText = isDark ? AppColors.homeLightBg : AppColors.homeDarkGreen;

    if (groups.isEmpty) {
      return Center(
        child: Text(
          'No hay clases asignadas',
          style: GoogleFonts.rowdies(color: labelColor, fontSize: 16),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: groups.map((g) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _TeacherGroupCard(
              group: g,
              cardBg: cardBg,
              cardText: cardText,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TeacherGroupCard extends StatelessWidget {
  final TeacherGroup group;
  final Color cardBg;
  final Color cardText;

  const _TeacherGroupCard({
    required this.group,
    required this.cardBg,
    required this.cardText,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth =
        (MediaQuery.of(context).size.width - 24 * 2).toDouble();

    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.faltasClase, extra: {
          'groupId': group.groupId,
          'groupName': group.groupName,
        });
      },
      child: Container(
        width: cardWidth,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.groupName,
                  style: GoogleFonts.rowdies(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: cardText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  group.level,
                  style: GoogleFonts.rowdies(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: cardText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Vista alumno ─────────────────────────────────────────────────────────────

class _StudentView extends StatelessWidget {
  final Color labelColor;
  final bool isDark;
  final List<StudentGroup> groups;
  final Map<String, Map<String, int>> summary;
  final Color Function(int faltas, int total) tagColorFn;

  const _StudentView({
    required this.labelColor,
    required this.isDark,
    required this.groups,
    required this.summary,
    required this.tagColorFn,
  });

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return Center(
        child: Text(
          'No hay asignaturas',
          style: GoogleFonts.rowdies(color: labelColor, fontSize: 16),
        ),
      );
    }

    final placeholderColors = [
      const Color(0xFFF5F0EB),
      const Color(0xFFF0EBF5),
      const Color(0xFFEBF5F0),
      const Color(0xFFF5EBEB),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: groups.asMap().entries.map((entry) {
          final index = entry.key;
          final group = entry.value;
          final att = summary[group.groupId] ?? {'faltas': 0, 'total': 0};
          final faltas = att['faltas']!;
          final total = att['total']!;
          final tagColor = tagColorFn(faltas, total);
          final ph = placeholderColors[index % placeholderColors.length];
          return _StudentGroupCard(
            group: group,
            faltas: faltas,
            total: total,
            tagColor: tagColor,
            placeholderColor: ph,
            labelColor: labelColor,
          );
        }).toList(),
      ),
    );
  }
}

class _StudentGroupCard extends StatelessWidget {
  final StudentGroup group;
  final int faltas;
  final int total;
  final Color tagColor;
  final Color placeholderColor;
  final Color labelColor;

  const _StudentGroupCard({
    required this.group,
    required this.faltas,
    required this.total,
    required this.tagColor,
    required this.placeholderColor,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth =
        (MediaQuery.of(context).size.width - 24 * 2 - 16) / 2;

    return GestureDetector(
      onTap: () {
        context.push(
          AppRoutes.faltasAsignatura,
          extra: {
            'groupId': group.groupId,
            'subject': group.groupName,
            'faltas': faltas,
            'total': total,
            'tagColor': tagColor,
          },
        );
      },
      child: SizedBox(
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: cardWidth,
                  height: 170,
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: tagColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              group.groupName,
              style: GoogleFonts.rowdies(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: labelColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}