import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/core/providers/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';
import 'package:proyecto_final_synquid/models/attendance_record.dart';
import 'package:proyecto_final_synquid/models/student_group.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';
import 'package:proyecto_final_synquid/services/attendance_service.dart';
import 'package:proyecto_final_synquid/services/student_service.dart';
import 'package:proyecto_final_synquid/widgets/legend_popup.dart';

class HomeStudentScreen extends StatefulWidget {
  const HomeStudentScreen({super.key});

  @override
  State<HomeStudentScreen> createState() => _HomeStudentScreenState();
}

class _HomeStudentScreenState extends State<HomeStudentScreen> {
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadIfNeeded();
  }

  Future<void> _loadIfNeeded() async {
    final provider = context.read<UserProvider>();
    if (provider.studentGroups != null) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final client = ApiClient();
      final results = await Future.wait([
        StudentService(client).getMyGroups(),
        AttendanceService(client).getMyHistory(),
      ]);
      if (!mounted) return;
      provider.cacheStudentData(
        groups: results[0] as List<StudentGroup>,
        history: results[1] as List<AttendanceRecord>,
      );
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Color _tagColor(int faltas, int total) {
    if (total == 0) return AppColors.tagGreen;
    final ratio = faltas / total;
    if (ratio >= 0.5) return AppColors.tagRed;
    if (ratio >= 0.25) return AppColors.tagYellow;
    return AppColors.tagGreen;
  }

  Map<String, Map<String, int>> _computeAttendanceSummary(
      List<AttendanceRecord> history) {
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
    final bgColor = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final appGreen = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final appBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final cardTopBg = isDark ? AppColors.homeDarkGreen : AppColors.green;
    final cardTopText = isDark ? AppColors.homeLightBg : AppColors.homeDarkGreen;
    final cardBottomBg = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final cardBottomText =
        isDark ? AppColors.homeDarkGreen : AppColors.homeLightBg;

    final userName = provider.user?.firstName ?? '';
    final groups = provider.studentGroups ?? [];
    final history = provider.attendanceHistory ?? [];
    final summary = _computeAttendanceSummary(history);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderSection(
            headerColor: appGreen,
            textColor: appBg,
            userName: userName,
          ),
          Expanded(
            child: _loading
                ? Center(
                    child: CircularProgressIndicator(color: appGreen),
                  )
                : _error != null
                    ? _ErrorView(
                        error: _error!,
                        color: appGreen,
                        onRetry: _loadIfNeeded,
                      )
                    : groups.isEmpty
                        ? Center(
                            child: Text(
                              'no_subjects'.tr(),
                              style: GoogleFonts.rowdies(
                                color: appGreen,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () => LegendPopup.show(context),
                                    child: Text(
                                      'ver_leyenda'.tr(),
                                      style: GoogleFonts.rowdies(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: appGreen,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...groups.map((group) {
                                  final att = summary[group.groupId] ??
                                      {'faltas': 0, 'total': 0};
                                  final faltas = att['faltas']!;
                                  final total = att['total']!;
                                  final tag = _tagColor(faltas, total);
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _SubjectCard(
                                      group: group,
                                      faltas: faltas,
                                      total: total,
                                      tagColor: tag,
                                      cardBgColor: cardTopBg,
                                      cardTextColor: cardTopText,
                                      bottomBgColor: cardBottomBg,
                                      bottomTextColor: cardBottomText,
                                    ),
                                  );
                                }),
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
  final String userName;

  const _HeaderSection({
    required this.headerColor,
    required this.textColor,
    required this.userName,
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
                'good_morning'.tr(namedArgs: {'name': userName}),
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
  final StudentGroup group;
  final int faltas;
  final int total;
  final Color tagColor;
  final Color cardBgColor;
  final Color cardTextColor;
  final Color bottomBgColor;
  final Color bottomTextColor;

  const _SubjectCard({
    required this.group,
    required this.faltas,
    required this.total,
    required this.tagColor,
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
                  group.groupName,
                  style: GoogleFonts.rowdies(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: cardTextColor,
                  ),
                ),
                Text(
                  group.level,
                  style: GoogleFonts.rowdies(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
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
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const Spacer(),
                GestureDetector(
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
                  child: Text(
                    '${'ver_faltas'.tr()}  →',
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

class _ErrorView extends StatelessWidget {
  final String error;
  final Color color;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.error,
    required this.color,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'error_load_data'.tr(),
              style: GoogleFonts.rowdies(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: GoogleFonts.rowdies(
                fontSize: 11,
                fontWeight: FontWeight.w300,
                color: color.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onRetry,
              child: Text(
                'retry'.tr(),
                style: GoogleFonts.rowdies(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
