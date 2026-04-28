import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';
import 'package:proyecto_final_synquid/services/student_service.dart';

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

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  // dayOfWeek (0=Sun,1=Mon,...,6=Sat) → slots
  final Map<int, List<_ClassSlot>> _cache = {};
  bool _loading = false;
  String? _error;

  static const _monthNames = [
    '',
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
  ];
  static const _weekdayNames = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _loadSchedules();
  }

  // DateTime.weekday: 1=Mon … 7=Sun  →  API: 0=Sun, 1=Mon … 6=Sat
  int _apiDow(DateTime date) => date.weekday % 7;

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

  String _formatSelectedDate() {
    final date = _selectedDay;
    final month = _monthNames[date.month];
    if (isSameDay(date, DateTime.now())) return 'Hoy, $month ${date.day}';
    final dayName = _weekdayNames[date.weekday - 1];
    return '$dayName, $month ${date.day}';
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
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Text(
              _formatSelectedDate(),
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Error al cargar horario',
                              style: GoogleFonts.rowdies(
                                color: labelColor,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: _loadSchedules,
                              child: Text(
                                'Reintentar',
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
                    : _slotsForSelectedDay.isEmpty
                        ? Center(
                            child: Text(
                              'No hay clases este día',
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
  }) {
    return TableCalendar(
      locale: 'es_ES',
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2035, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: _calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Mes',
        CalendarFormat.week: 'Semana',
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
