import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/providers/user_provider.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/models/student.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';
import 'package:proyecto_final_synquid/services/attendance_service.dart';
import 'package:proyecto_final_synquid/widgets/back_app_bar.dart';
import 'package:table_calendar/table_calendar.dart';

class _StudentRow {
  final Student student;
  int status; // 0=Presente 1=Ausente 2=Justificado 3=Tarde

  _StudentRow({required this.student, this.status = 1});
}

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

  late List<_StudentRow> _rows;
  bool _loadingToday = true;
  bool _saving = false;

  static const _statusOptions = ['Presente', 'Ausente', 'Justificado', 'Tarde'];

  static const _statusLabels = {
    0: 'Presente',
    1: 'Ausente',
    2: 'Justificado',
    3: 'Tarde',
  };

  static const _labelToStatus = {
    'Presente': 0,
    'Ausente': 1,
    'Justificado': 2,
    'Tarde': 3,
  };

  @override
  void initState() {
    super.initState();
    _rows = widget.students
        .map((s) => _StudentRow(student: s, status: 1))
        .toList();
    _fetchTodayAttendance();
  }

  Future<void> _fetchTodayAttendance() async {
    final institutionId =
        context.read<UserProvider>().user?.institutionId ?? '';
    setState(() => _loadingToday = true);
    try {
      final todayList = await AttendanceService(ApiClient()).getToday(
        groupId: widget.groupId,
        institutionId: institutionId,
      );
      final statusMap = {for (final t in todayList) t.userId: t.status};
      if (mounted) {
        setState(() {
          for (final row in _rows) {
            if (statusMap.containsKey(row.student.userId)) {
              row.status = statusMap[row.student.userId]!.clamp(0, 3);
            }
          }
        });
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loadingToday = false);
    }
  }

  Future<void> _saveAttendance() async {
    final profesorId = context.read<UserProvider>().user?.id ?? '';
    setState(() => _saving = true);
    try {
      final service = AttendanceService(ApiClient());
      await Future.wait(
        _rows.map(
          (row) => service.postManual(
            userId: row.student.userId,
            status: row.status,
            profesorId: profesorId,
          ),
        ),
      );
      if (!mounted) return;
      _showMessage('Asistencia guardada correctamente', isError: false);
    } on DioException {
      if (!mounted) return;
      _showMessage('Error al guardar la asistencia', isError: true);
    } catch (_) {
      if (!mounted) return;
      _showMessage('Error inesperado', isError: true);
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

  String _getMonthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
    ];
    return months[month - 1];
  }

  String _getWeekdayName(int weekday) {
    const days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final appBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final appGreen = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final textColor = isDark ? Colors.white : AppColors.homeDarkGreen;
    final dropdownBgColor =
        isDark ? const Color(0xFFADC4A8) : appGreen.withValues(alpha: 0.8);

    return Scaffold(
      backgroundColor: appBg,
      appBar: const BackAppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.week,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle:
                    GoogleFonts.rowdies(color: textColor, fontSize: 16),
                leftChevronIcon:
                    Icon(Icons.chevron_left, color: textColor),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: textColor),
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
                    '${_getMonthName(_selectedDay!.month)} ${_getWeekdayName(_selectedDay!.weekday)}',
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
                  : _rows.isEmpty
                      ? Center(
                          child: Text(
                            'No hay alumnos',
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
                          itemCount: _rows.length,
                          separatorBuilder: (_, _) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(
                              color: textColor.withValues(alpha: 0.5),
                              thickness: 1,
                            ),
                          ),
                          itemBuilder: (context, index) {
                            final row = _rows[index];
                            return Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    row.student.fullName,
                                    style: GoogleFonts.rowdies(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _statusLabels[row.status],
                                    dropdownColor: dropdownBgColor,
                                    borderRadius: BorderRadius.circular(16),
                                    icon: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 8.0),
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: textColor,
                                        size: 20,
                                      ),
                                    ),
                                    items: _statusOptions.map((s) {
                                      return DropdownMenuItem<String>(
                                        value: s,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Text(
                                            s,
                                            style: GoogleFonts.rowdies(
                                              color: s ==
                                                      _statusLabels[row.status]
                                                  ? textColor
                                                  : AppColors.darkBg,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() {
                                          row.status =
                                              _labelToStatus[val] ?? 1;
                                        });
                                      }
                                    },
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
                          'Guardar asistencia',
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