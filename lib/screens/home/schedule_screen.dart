import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';

class _ClassItem {
  final String subject;
  final String time;
  final String professor;
  final String days;

  const _ClassItem({
    required this.subject,
    required this.time,
    required this.professor,
    required this.days,
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

  static const _monthNames = [
    '',
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];

  static const _weekdayNames = [
    'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'
  ];

  static const _allClasses = {
    0: [
      _ClassItem(
          subject: 'Interfaces',
          time: '13:14',
          professor: 'Javier',
          days: 'Mar,Mie'),
      _ClassItem(
          subject: 'Programación',
          time: '15:00',
          professor: 'Ana',
          days: 'Lun,Mie'),
      _ClassItem(
          subject: 'Base de datos',
          time: '16:30',
          professor: 'Carlos',
          days: 'Lun'),
    ],
    1: [
      _ClassItem(
          subject: 'Interfaces',
          time: '13:14',
          professor: 'Javier',
          days: 'Mar,Mie'),
      _ClassItem(
          subject: 'Sistemas',
          time: '15:00',
          professor: 'Pedro',
          days: 'Mar,Jue'),
      _ClassItem(
          subject: 'Entorns',
          time: '16:30',
          professor: 'Laura',
          days: 'Mar'),
      _ClassItem(
          subject: 'FOL', time: '18:00', professor: 'María', days: 'Mar,Jue'),
    ],
    2: [
      _ClassItem(
          subject: 'Interfaces',
          time: '13:14',
          professor: 'Javier',
          days: 'Mar,Mie'),
      _ClassItem(
          subject: 'Programación',
          time: '15:00',
          professor: 'Ana',
          days: 'Lun,Mie'),
      _ClassItem(
          subject: 'Inglés técnico',
          time: '16:30',
          professor: 'Sara',
          days: 'Mie,Vie'),
      _ClassItem(
          subject: 'Interfaces',
          time: '17:00',
          professor: 'Javier',
          days: 'Mar,Mie'),
      _ClassItem(
          subject: 'Interfaces',
          time: '18:00',
          professor: 'Javier',
          days: 'Mar,Mie'),
      _ClassItem(
          subject: 'Interfaces',
          time: '19:00',
          professor: 'Javier',
          days: 'Mar,Mie'),
    ],
    3: [
      _ClassItem(
          subject: 'Sistemas',
          time: '13:14',
          professor: 'Pedro',
          days: 'Mar,Jue'),
      _ClassItem(
          subject: 'FOL', time: '15:00', professor: 'María', days: 'Mar,Jue'),
      _ClassItem(
          subject: 'Empresa',
          time: '16:30',
          professor: 'Roberto',
          days: 'Jue'),
    ],
    4: [
      _ClassItem(
          subject: 'Inglés técnico',
          time: '13:14',
          professor: 'Sara',
          days: 'Mie,Vie'),
      _ClassItem(
          subject: 'Sistemas de gestión',
          time: '15:00',
          professor: 'Luis',
          days: 'Vie'),
    ],
  };

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  List<_ClassItem> get _selectedClasses {
    final index = _selectedDay.weekday - 1; // 0=Lun … 6=Dom
    return _allClasses[index] ?? [];
  }

  String _formatSelectedDate() {
    final date = _selectedDay;
    final month = _monthNames[date.month];
    if (isSameDay(date, DateTime.now())) {
      return 'Hoy, $month ${date.day}';
    }
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
          // Cabecera con calendario
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
          // Etiqueta del día seleccionado
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
          // Lista de clases
          Expanded(
            child: _selectedClasses.isEmpty
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
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _selectedClasses.length,
                    separatorBuilder: (_, _) =>
                        Divider(color: dividerColor, height: 1),
                    itemBuilder: (context, index) => _ClassRow(
                      item: _selectedClasses[index],
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
        defaultTextStyle: GoogleFonts.rowdies(
          color: headerText,
          fontSize: 13,
        ),
        weekendTextStyle: GoogleFonts.rowdies(
          color: headerText.withValues(alpha: 0.38),
          fontSize: 13,
        ),
        outsideTextStyle: GoogleFonts.rowdies(
          color: headerText.withValues(alpha: 0.28),
          fontSize: 13,
        ),
        selectedDecoration: BoxDecoration(
          color: selectedDayBg,
          shape: BoxShape.circle,
        ),
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
  final _ClassItem item;
  final Color textColor;

  const _ClassRow({
    required this.item,
    required this.textColor,
  });

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
                  item.subject,
                  style: GoogleFonts.rowdies(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.time,
                  style: GoogleFonts.rowdies(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.professor,
                style: GoogleFonts.rowdies(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.days,
                style: GoogleFonts.rowdies(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
