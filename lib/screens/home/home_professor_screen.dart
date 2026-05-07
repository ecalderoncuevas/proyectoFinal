import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/core/providers/user_provider.dart';
import 'package:proyecto_final_synquid/models/teacher_group.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';
import 'package:proyecto_final_synquid/services/teacher_service.dart';

// Pantalla principal del profesor: muestra la lista de grupos asignados con acceso a sus faltas
class HomeProfessorScreen extends StatefulWidget {
  const HomeProfessorScreen({super.key});

  @override
  State<HomeProfessorScreen> createState() => _HomeProfessorScreenState();
}

class _HomeProfessorScreenState extends State<HomeProfessorScreen> {
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadIfNeeded();
  }

  // Carga los grupos del profesor solo si aún no están cacheados en UserProvider
  Future<void> _loadIfNeeded() async {
    final provider = context.read<UserProvider>();
    if (provider.teacherGroups != null) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final groups = await TeacherService(ApiClient()).getMyGroups();
      if (!mounted) return;
      provider.cacheTeacherGroups(groups);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
    final groups = provider.teacherGroups ?? [];

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
                ? Center(child: CircularProgressIndicator(color: appGreen))
                : _error != null
                    ? _ErrorView(
                        error: _error!,
                        color: appGreen,
                        onRetry: _loadIfNeeded,
                      )
                    : groups.isEmpty
                        ? Center(
                            child: Text(
                              'no_classes_assigned'.tr(),
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
                                const SizedBox(height: 24),
                                ...groups.map(
                                  (group) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _ClassCard(
                                      group: group,
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

// Tarjeta de clase para la vista del profesor: nombre del grupo, nivel y enlace a sus faltas
class _ClassCard extends StatelessWidget {
  final TeacherGroup group;
  final Color cardBgColor;
  final Color cardTextColor;
  final Color bottomBgColor;
  final Color bottomTextColor;

  const _ClassCard({
    required this.group,
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
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    context.push(
                      AppRoutes.faltasClase,
                      extra: {
                        'groupId': group.groupId,
                        'groupName': group.groupName,
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
              'error_load_classes'.tr(),
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
