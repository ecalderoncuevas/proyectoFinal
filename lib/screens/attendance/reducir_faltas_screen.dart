import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/models/student.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';
import 'package:proyecto_final_synquid/services/attendance_service.dart';
import 'package:proyecto_final_synquid/widgets/back_app_bar.dart';
import 'package:table_calendar/table_calendar.dart';

class ReducirFaltasScreen extends StatefulWidget {
  final String groupId;
  final List<Student> students;

  const ReducirFaltasScreen({
    super.key,
    required this.groupId,
    required this.students,
  });

  @override
  State<ReducirFaltasScreen> createState() => _ReducirFaltasScreenState();
}

class _ReducirFaltasScreenState extends State<ReducirFaltasScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  // Cache por fecha: dateKey → (userId → status)
  // Cada día guarda su propio estado independientemente
  final Map<String, Map<String, int>> _statusByDate = {};
  bool _loadingToday = true;
  bool _saving = false;

  static const _statusOptions = ['presente', 'ausente', 'justificado', 'tarde'];
  static const _statusLabels = {
    0: 'presente',
    1: 'ausente',
    2: 'justificado',
    3: 'tarde',
  };
  static const _labelToStatus = {
    'presente': 0,
    'ausente': 1,
    'justificado': 2,
    'tarde': 3,
  };

  String get _dateKey {
    final d = _selectedDay!;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Map<String, int> get _currentStatus => _statusByDate[_dateKey] ?? {};

  @override
  void initState() {
    super.initState();
    _fetchTodayAttendance();
  }

  Future<void> _fetchTodayAttendance() async {
    final dateKey = _dateKey;

    // Si ya tenemos datos para este día, no hace falta llamar a la API
    if (_statusByDate.containsKey(dateKey)) {
      setState(() => _loadingToday = false);
      return;
    }

    setState(() => _loadingToday = true);
    try {
      // Usamos history con from=to=fecha para obtener la asistencia real de ese día
      // getToday solo devuelve datos de HOY; para días pasados necesitamos history
      final apiMap = await AttendanceService(ApiClient()).getStatusByDate(
        groupId: widget.groupId,
        date: dateKey,
      );

      final dayStatus = <String, int>{
        for (final s in widget.students)
          s.userId: (apiMap[s.userId] ?? 1).clamp(0, 3),
      };

      if (mounted) {
        setState(() => _statusByDate[dateKey] = dayStatus);
      }
    } catch (_) {
      // En caso de error inicializamos con ausente para no mostrar datos de otro día
      if (mounted) {
        setState(() {
          _statusByDate[dateKey] ??= {
            for (final s in widget.students) s.userId: 1,
          };
        });
      }
    } finally {
      if (mounted) setState(() => _loadingToday = false);
    }
  }

  Future<void> _saveAttendance() async {
    setState(() => _saving = true);
    try {
      final service = AttendanceService(ApiClient());
      final String formattedDate = _selectedDay!.toUtc().toIso8601String();

      for (final student in widget.students) {
        await service.updateDailyAttendance(
          userId: student.userId,
          scheduleId: '',
          groupId: widget.groupId,
          date: formattedDate,
          status: _currentStatus[student.userId] ?? 1,
        );
      }

      if (!mounted) return;
      _showMessage('attendance_saved'.tr(), isError: false);
    } on DioException {
      if (!mounted) return;
      _showMessage('error_save_attendance'.tr(), isError: true);
    } catch (_) {
      if (!mounted) return;
      _showMessage('error_unexpected'.tr(), isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showMessage(String text, {required bool isError}) {
    final isDark = context.read<ThemeProvider>().isDark;
    final color = isDark ? AppColors.green : AppColors.homeDarkGreen;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: isError ? Colors.redAccent : color,
      ),
    );
  }

  String _formatCurrentDate(String locale) {
    final date = _selectedDay!;
    final month = DateFormat('MMMM', locale).format(date);
    final weekday = DateFormat('EEEE', locale).format(date);
    final m = '${month[0].toUpperCase()}${month.substring(1)}';
    final w = '${weekday[0].toUpperCase()}${weekday.substring(1)}';
    return '$m $w';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final appBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final appGreen = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final textColor = isDark ? Colors.white : AppColors.homeDarkGreen;
    final dropdownBgColor =
        isDark ? const Color(0xFFADC4A8) : appGreen.withValues(alpha: 0.8);
    final locale = context.locale.toString();

    return Scaffold(
      backgroundColor: appBg,
      appBar: const BackAppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              locale: context.locale.toString(),
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.now(),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.week,
              enabledDayPredicate: (day) => !day.isAfter(DateTime.now()),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _fetchTodayAttendance();
              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle:
                    GoogleFonts.rowdies(color: textColor, fontSize: 16),
                leftChevronIcon: Icon(Icons.chevron_left, color: textColor),
                rightChevronIcon: Icon(Icons.chevron_right, color: textColor),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle:
                    GoogleFonts.rowdies(color: textColor, fontSize: 12),
                weekendStyle: GoogleFonts.rowdies(
                  color: textColor.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
              calendarStyle: CalendarStyle(
                defaultTextStyle: GoogleFonts.rowdies(color: textColor),
                weekendTextStyle: GoogleFonts.rowdies(
                  color: textColor.withValues(alpha: 0.6),
                ),
                selectedDecoration: BoxDecoration(
                  color: appGreen,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: appGreen.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatCurrentDate(locale),
                    style: GoogleFonts.rowdies(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    '${_selectedDay!.day}',
                    style: GoogleFonts.rowdies(
                      fontSize: 70,
                      fontWeight: FontWeight.w700,
                      color: dropdownBgColor,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Divider(color: textColor, thickness: 1.5),
            ),
            Expanded(
              child: _loadingToday
                  ? Center(child: CircularProgressIndicator(color: appGreen))
                  : widget.students.isEmpty
                      ? Center(
                          child: Text(
                            'no_students_short'.tr(),
                            style: GoogleFonts.rowdies(
                              color: appGreen,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 8.0,
                          ),
                          itemCount: widget.students.length,
                          separatorBuilder: (_, _) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(
                              color: textColor.withValues(alpha: 0.5),
                              thickness: 1,
                            ),
                          ),
                          itemBuilder: (context, index) {
                            final student = widget.students[index];
                            final status = _currentStatus[student.userId] ?? 1;
                            return Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    student.fullName,
                                    style: GoogleFonts.rowdies(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: appGreen,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _statusLabels[status],
                                      isDense: false,
                                      dropdownColor: appGreen,
                                      borderRadius: BorderRadius.circular(12),
                                      icon: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4),
                                        child: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: appBg,
                                          size: 22,
                                        ),
                                      ),
                                      items: _statusOptions.map((s) {
                                        return DropdownMenuItem<String>(
                                          value: s,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 6),
                                            child: Text(
                                              s.tr(),
                                              style: GoogleFonts.rowdies(
                                                color: appBg,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            _statusByDate[_dateKey] ??= {};
                                            _statusByDate[_dateKey]![student.userId] =
                                                _labelToStatus[val] ?? 1;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _saveAttendance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'save_attendance'.tr(),
                          style: GoogleFonts.rowdies(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.darkBg
                                : AppColors.homeLightBg,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
