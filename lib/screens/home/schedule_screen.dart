import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';
import 'package:proyecto_final_synquid/services/student_service.dart';

// Datos de una clase del horario del alumno para mostrar en la lista del día seleccionado
class _ClassSlot {
  final String groupName;
  final String startTime;
  final String endTime;

  _ClassSlot({
    required this.groupName,
    required this.startTime,
    required this.endTime,
  });
}

// Pantalla de horario del alumno: calendario semanal/mensual con las clases del día seleccionado
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  // Caché local: dayOfWeek (API: 0=Dom…6=Sáb) → lista de clases; evita repedir la API al cambiar de día
  final Map<int, List<_ClassSlot>> _cache = {};
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _loadSchedules();
  }

  // Convierte el weekday de Flutter (1=lun…7=dom) al formato de la API (0=dom…6=sáb)
  int _apiDow(DateTime date) => date.weekday % 7;

  // Descarga el horario del alumno y lo organiza en la caché por dayOfWeek
  Future<void> _loadSchedules() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items =
          await StudentService(ApiClient()).getSchedule(DateTime.now());

      final newCache = <int, List<_ClassSlot>>{};
      final seenIds = <String>{};
      for (final item in items) {
        if (seenIds.contains(item.scheduleId)) continue;
        seenIds.add(item.scheduleId);
        newCache.putIfAbsent(item.dayOfWeek, () => []).add(
          _ClassSlot(
            groupName: item.groupName,
            startTime: item.startTime,
            endTime: item.endTime,
          ),
        );
      }

      if (mounted) setState(() => _cache.addAll(newCache));
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<_ClassSlot> get _slotsForSelectedDay =>
      _cache[_apiDow(_selectedDay)] ?? [];

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  String _formatSelectedDate(String locale) {
    final date = _selectedDay;
    final month = DateFormat('MMMM', locale).format(date);
    if (isSameDay(date, DateTime.now())) {
      return '${'hoy'.tr()}, ${_capitalize(month)} ${date.day}';
    }
    final dayName = DateFormat('EEE', locale).format(date);
    return '${_capitalize(dayName)}, ${_capitalize(month)} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final appBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final headerBg = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final headerText = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final labelColor = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final dividerColor = isDark ? Colors.white24 : Colors.black26;
    final selectedDayBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final selectedDayText = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final locale = context.locale.toString();

    return Scaffold(
      backgroundColor: appBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: headerBg,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 56),
                child: _buildCalendar(
                  headerText: headerText,
                  selectedDayBg: selectedDayBg,
                  selectedDayText: selectedDayText,
                  locale: locale,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Text(
              _formatSelectedDate(locale),
              style: GoogleFonts.rowdies(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: labelColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator(color: labelColor))
                : _error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'error_load_schedule'.tr(),
                                style: GoogleFonts.rowdies(
                                  color: labelColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _error ?? '',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rowdies(
                                  color: labelColor.withValues(alpha: 0.7),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: _loadSchedules,
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
                        ),
                      )
                    : _slotsForSelectedDay.isEmpty
                        ? Center(
                            child: Text(
                              'no_classes_today'.tr(),
                              style: GoogleFonts.rowdies(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: labelColor,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: _slotsForSelectedDay.length,
                            separatorBuilder: (_, _) =>
                                Divider(color: dividerColor, height: 1),
                            itemBuilder: (context, index) => _ClassRow(
                              slot: _slotsForSelectedDay[index],
                              textColor: labelColor,
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar({
    required Color headerText,
    required Color selectedDayBg,
    required Color selectedDayText,
    required String locale,
  }) {
    return TableCalendar(
      locale: locale,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2035, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: _calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableCalendarFormats: {
        CalendarFormat.month: 'mes'.tr(),
        CalendarFormat.week: 'semana'.tr(),
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) => setState(() => _calendarFormat = format),
      onPageChanged: (focusedDay) => setState(() => _focusedDay = focusedDay),
      rowHeight: 40,
      daysOfWeekHeight: 24,
      headerStyle: HeaderStyle(
        formatButtonVisible: true,
        titleCentered: true,
        formatButtonDecoration: BoxDecoration(
          border: Border.all(color: headerText, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        formatButtonTextStyle: GoogleFonts.rowdies(
          color: headerText,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        formatButtonPadding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        titleTextStyle: GoogleFonts.rowdies(
          color: headerText,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        headerPadding:
            const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        leftChevronIcon: Icon(Icons.chevron_left, color: headerText, size: 22),
        rightChevronIcon:
            Icon(Icons.chevron_right, color: headerText, size: 22),
      ),
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          const labels = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
          final idx = day.weekday - 1;
          final isWeekend = day.weekday > 5;
          return Center(
            child: Text(
              labels[idx],
              style: GoogleFonts.rowdies(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isWeekend
                    ? headerText.withValues(alpha: 0.30)
                    : headerText.withValues(alpha: 0.65),
              ),
            ),
          );
        },
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        outsideDaysVisible: true,
        cellMargin: const EdgeInsets.all(3),
        defaultTextStyle: GoogleFonts.rowdies(color: headerText, fontSize: 13),
        weekendTextStyle: GoogleFonts.rowdies(
          color: headerText.withValues(alpha: 0.38),
          fontSize: 13,
        ),
        outsideTextStyle: GoogleFonts.rowdies(
          color: headerText.withValues(alpha: 0.28),
          fontSize: 13,
        ),
        selectedDecoration:
            BoxDecoration(color: selectedDayBg, shape: BoxShape.circle),
        selectedTextStyle: GoogleFonts.rowdies(
          color: selectedDayText,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        todayDecoration: BoxDecoration(
          color: selectedDayBg.withValues(alpha: 0.28),
          shape: BoxShape.circle,
        ),
        todayTextStyle: GoogleFonts.rowdies(
          color: headerText,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// Fila de una clase en la lista del día: muestra nombre del grupo y franja horaria
class _ClassRow extends StatelessWidget {
  final _ClassSlot slot;
  final Color textColor;

  const _ClassRow({required this.slot, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.groupName,
                  style: GoogleFonts.rowdies(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${slot.startTime} – ${slot.endTime}',
                  style: GoogleFonts.rowdies(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor,
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
