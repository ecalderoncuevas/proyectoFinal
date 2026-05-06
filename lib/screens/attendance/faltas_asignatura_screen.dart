import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/models/attendance_record.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';
import 'package:proyecto_final_synquid/services/attendance_service.dart';

class FaltasAsignaturaScreen extends StatefulWidget {
  final String groupId;
  final String subject;
  final int faltas;
  final int total;
  final Color tagColor;

  const FaltasAsignaturaScreen({
    super.key,
    required this.groupId,
    required this.subject,
    required this.faltas,
    required this.total,
    required this.tagColor,
  });

  @override
  State<FaltasAsignaturaScreen> createState() => _FaltasAsignaturaScreenState();
}

class _FaltasAsignaturaScreenState extends State<FaltasAsignaturaScreen> {
  List<Attendance> _absences = [];
  bool _loading = true;
  String? _error;

  late int _faltas;
  late int _total;
  late Color _currentTagColor;
  
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _faltas = widget.faltas;
    _total = widget.total;
    _currentTagColor = widget.tagColor;
    
    _fetchAbsences();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        _fetchAbsences(isSilent: true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateColors() {
    if (_total == 0) {
      _currentTagColor = AppColors.tagGreen;
    } else {
      final ratio = _faltas / _total;
      if (ratio >= 0.75) {
        _currentTagColor = AppColors.tagRed;
      } else if (ratio >= 0.50) {
        _currentTagColor = AppColors.tagYellow;
      } else {
        _currentTagColor = AppColors.tagGreen;
      }
    }
  }

  Future<void> _fetchAbsences({bool isSilent = false}) async {
    if (!isSilent) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final attendances = await AttendanceService(ApiClient()).getMyHistoryByGroup(
        groupId: widget.groupId,
      );
      
      if (mounted) {
        setState(() {
          _total = attendances.length;
          _absences = attendances.where((r) => r.status == 1).toList();
          _faltas = _absences.length;
          _updateColors();
        });
      }
    } catch (e) {
      if (!isSilent && mounted) {
        setState(() => _error = e.toString());
      }
    } finally {
      if (!isSilent && mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final appBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final headerBg = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final headerText = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final labelColor = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final dividerColor = isDark ? Colors.white24 : Colors.black26;

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
                  widget.subject,
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
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ausencias'.tr(),
                  style: GoogleFonts.rowdies(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: labelColor,
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
                    '$_faltas/$_total',
                    style: GoogleFonts.rowdies(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: _currentTagColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator(color: labelColor))
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'error_load_absences'.tr(),
                              style: GoogleFonts.rowdies(
                                color: labelColor,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _error ?? '',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.rowdies(
                                color: labelColor.withValues(alpha: 0.7),
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () => _fetchAbsences(),
                              child: Text(
                                'retry'.tr(),
                                style: GoogleFonts.rowdies(
                                  color: labelColor,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : _absences.isEmpty
                        ? Center(
                            child: Text(
                              'no_absences'.tr(),
                              style: GoogleFonts.rowdies(
                                color: labelColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: _absences.length,
                            separatorBuilder: (_, _) =>
                                Divider(color: dividerColor, height: 1),
                            itemBuilder: (context, index) {
                              final item = _absences[index];
                              return _FaltaDetalleRow(
                                hora: item.hora,
                                fecha: item.fecha,
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
          Container(width: 2, height: 24, color: dividerColor),
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