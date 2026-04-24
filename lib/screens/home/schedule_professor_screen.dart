import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';

class _ClassItem {
  final String subject;
  final String startTime;
  final String endTime;

  const _ClassItem({
    required this.subject,
    required this.startTime,
    required this.endTime,
  });
}

// ─── Días laborables 2020-2035 (calculado una sola vez) ───────────────────────
List<DateTime> _buildWorkingDays() {
  final days = <DateTime>[];
  var d = DateTime.utc(2020, 1, 1);
  final end = DateTime.utc(2035, 12, 31);
  while (!d.isAfter(end)) {
    if (d.weekday <= 5) days.add(d);
    d = d.add(const Duration(days: 1));
  }
  return days;
}

// ─────────────────────────────────────────────────────────────────────────────

class ScheduleProfessorScreen extends StatefulWidget {
  const ScheduleProfessorScreen({super.key});

  @override
  State<ScheduleProfessorScreen> createState() =>
      _ScheduleProfessorScreenState();
}

class _ScheduleProfessorScreenState extends State<ScheduleProfessorScreen> {
  late final ScrollController _mainController;
  late final ScrollController _sidebarController;
  String _currentMonth = '';
  double _dayItemHeight = 130.0;
  bool _scrollInitialized = false;

  static final _workingDays = _buildWorkingDays();

  final _dayNameFormat = DateFormat('EEE', 'es_ES');
  final _monthYearFormat = DateFormat('MMMM yyyy', 'es_ES');

  static final _classesByWeekday = <int, List<_ClassItem>>{
    1: const [
      _ClassItem(subject: 'Interfaces DAM1', startTime: '08:00', endTime: '10:00'),
      _ClassItem(subject: 'Programación DAM1', startTime: '10:00', endTime: '12:00'),
      _ClassItem(subject: 'Sistemas', startTime: '14:00', endTime: '16:00'),
    ],
    2: const [
      _ClassItem(subject: 'Interfaces DAM2', startTime: '08:00', endTime: '10:00'),
      _ClassItem(subject: 'Inglés técnico', startTime: '12:00', endTime: '14:00'),
    ],
    3: const [
      _ClassItem(subject: 'Bases de datos', startTime: '08:00', endTime: '10:00'),
      _ClassItem(subject: 'Entornos de desarrollo', startTime: '10:00', endTime: '12:00'),
      _ClassItem(subject: 'Programación DAM2', startTime: '14:00', endTime: '16:00'),
      _ClassItem(subject: 'FOL', startTime: '16:00', endTime: '17:00'),
    ],
    4: const [
      _ClassItem(subject: 'Interfaces DAM1', startTime: '10:00', endTime: '12:00'),
      _ClassItem(subject: 'Sistemas de gestión', startTime: '14:00', endTime: '15:00'),
    ],
    5: const [
      _ClassItem(subject: 'Programación de Servicios', startTime: '08:00', endTime: '10:00'),
      _ClassItem(subject: 'Programación Multimedia', startTime: '10:00', endTime: '12:00'),
      _ClassItem(subject: 'Empresa e Iniciativa', startTime: '14:00', endTime: '15:00'),
    ],
  };

  static const _specialDay = 23;
  static const _specialDayClasses = [
    _ClassItem(subject: 'Interfaces DAM1', startTime: '08:00', endTime: '10:00'),
    _ClassItem(subject: 'Programación DAM1', startTime: '10:00', endTime: '12:00'),
    _ClassItem(subject: 'Bases de datos', startTime: '12:00', endTime: '14:00'),
    _ClassItem(subject: 'Sistemas', startTime: '14:00', endTime: '15:00'),
    _ClassItem(subject: 'Clase de recuperación', startTime: '15:00', endTime: '16:00'),
  ];

  // ─── Índice del primer día laborable a partir de hoy ──────────────────────
  int get _todayIndex {
    var today = DateTime.now();
    while (today.weekday > 5) today = today.add(const Duration(days: 1));
    final idx = _workingDays.indexWhere(
      (d) => d.year == today.year && d.month == today.month && d.day == today.day,
    );
    return idx >= 0 ? idx : (_workingDays.length ~/ 2);
  }

  @override
  void initState() {
    super.initState();
    _mainController = ScrollController();
    _sidebarController = ScrollController();

    _mainController.addListener(() {
      if (_sidebarController.hasClients) {
        _sidebarController.jumpTo(_mainController.offset);
      }
      _updateMonthFromOffset();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenHeight = MediaQuery.of(context).size.height;
    final computed = (screenHeight * 0.20).clamp(110.0, 155.0);
    if ((computed - _dayItemHeight).abs() > 1.0) {
      _dayItemHeight = computed;
    }
    if (!_scrollInitialized) {
      _scrollInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_mainController.hasClients) {
          final offset = _todayIndex * _dayItemHeight;
          _mainController.jumpTo(offset);
          _sidebarController.jumpTo(offset);
          _updateMonthFromOffset();
        }
      });
    }
  }

  List<_ClassItem> _classesForDate(DateTime date) {
    if (date.day == _specialDay) return _specialDayClasses;
    return _classesByWeekday[date.weekday] ?? [];
  }

  String _formatDayName(DateTime date) {
    final raw = _dayNameFormat.format(date);
    return raw[0].toUpperCase() + raw.substring(1);
  }

  String _formatMonth(DateTime date) {
    final raw = _monthYearFormat.format(date);
    return raw[0].toUpperCase() + raw.substring(1);
  }

  void _updateMonthFromOffset() {
    if (!_mainController.hasClients || _workingDays.isEmpty) return;
    final offset = _mainController.offset;
    final idx = (offset / _dayItemHeight).floor().clamp(0, _workingDays.length - 1);
    final newMonth = _formatMonth(_workingDays[idx]);
    if (newMonth != _currentMonth) {
      setState(() => _currentMonth = newMonth);
    }
  }

  // Anima el scroll hasta la fecha seleccionada en el calendario.
  void _scrollToDate(DateTime date) {
    var target = date;
    if (target.weekday > 5) {
      target = target.add(Duration(days: 8 - target.weekday));
    }
    final idx = _workingDays.indexWhere(
      (d) => d.year == target.year && d.month == target.month && d.day == target.day,
    );
    if (idx >= 0 && _mainController.hasClients) {
      _mainController.animateTo(
        idx * _dayItemHeight,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    }
  }

  void _openCalendar(BuildContext context) {
    final idx = _mainController.hasClients
        ? (_mainController.offset / _dayItemHeight).floor().clamp(0, _workingDays.length - 1)
        : _todayIndex;
    final focused = _workingDays[idx];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CalendarBottomSheet(
        focusedDay: focused,
        onDaySelected: (date) {
          Navigator.of(context).pop();
          _scrollToDate(date);
        },
      ),
    );
  }

  @override
  void dispose() {
    _mainController.dispose();
    _sidebarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final appBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final labelColor = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final lineColor = isDark ? Colors.white24 : Colors.black26;
    final dotColor = isDark ? AppColors.green : AppColors.homeDarkGreen;

    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth = (screenWidth * 0.22).clamp(90.0, 120.0);

    return Scaffold(
      backgroundColor: appBg,
      body: Row(
        children: [
          // ── Sidebar izquierdo ──────────────────────────────────────────────
          _SidebarColumn(
            scrollController: _sidebarController,
            currentMonth: _currentMonth,
            dateForIndex: (i) => _workingDays[i],
            formatDayName: _formatDayName,
            itemHeight: _dayItemHeight,
            width: sidebarWidth,
            totalItems: _workingDays.length,
            onMonthTap: () => _openCalendar(context),
          ),
          // ── Contenido: bloques de asignaturas ─────────────────────────────
          Expanded(
            child: SafeArea(
              bottom: false,
              left: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 56),
                child: ListView.builder(
                  controller: _mainController,
                  itemCount: _workingDays.length,
                  itemBuilder: (context, index) {
                    final date = _workingDays[index];
                    final classes = _classesForDate(date);
                    return _DayClassesBlock(
                      classes: classes,
                      labelColor: labelColor,
                      lineColor: lineColor,
                      dotColor: dotColor,
                      itemHeight: _dayItemHeight,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sidebar izquierdo ────────────────────────────────────────────────────────

class _SidebarColumn extends StatelessWidget {
  final ScrollController scrollController;
  final String currentMonth;
  final DateTime Function(int) dateForIndex;
  final String Function(DateTime) formatDayName;
  final double itemHeight;
  final double width;
  final int totalItems;
  final VoidCallback onMonthTap;

  const _SidebarColumn({
    required this.scrollController,
    required this.currentMonth,
    required this.dateForIndex,
    required this.formatDayName,
    required this.itemHeight,
    required this.width,
    required this.totalItems,
    required this.onMonthTap,
  });

  @override
  Widget build(BuildContext context) {
    // El sidebar siempre usa homeDarkGreen (385144) independientemente del modo.
    const sidebarBg = AppColors.homeDarkGreen;
    // Los bloques de día usan green (C2D8C4) con texto homeDarkGreen.
    const blockBg = AppColors.green;
    const blockText = AppColors.homeDarkGreen;
    const monthText = AppColors.homeLightBg;

    return Container(
      width: width,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: sidebarBg,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // Columna del mes: tappable para abrir el calendario
          GestureDetector(
            onTap: onMonthTap,
            child: SizedBox(
              width: 34,
              child: Center(
                child: RotatedBox(
                  quarterTurns: -1,
                  child: Text(
                    currentMonth,
                    style: GoogleFonts.rowdies(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: monthText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
          // Separador sutil
          Container(
            width: 1,
            margin: const EdgeInsets.symmetric(vertical: 20),
            color: monthText.withValues(alpha: 0.15),
          ),
          // Lista de bloques de días (sincronizada con el scroll principal)
          Expanded(
            child: SafeArea(
              bottom: false,
              right: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 56),
                child: ListView.builder(
                  controller: scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: totalItems,
                  itemBuilder: (context, index) {
                    final date = dateForIndex(index);
                    return SizedBox(
                      height: itemHeight,
                      child: Center(
                        child: Container(
                          width: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 10),
                          decoration: BoxDecoration(
                            color: blockBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                formatDayName(date),
                                style: GoogleFonts.rowdies(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: blockText,
                                ),
                                maxLines: 1,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${date.day}',
                                style: GoogleFonts.rowdies(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: blockText,
                                ),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bloque de asignaturas de un día ─────────────────────────────────────────

class _DayClassesBlock extends StatelessWidget {
  final List<_ClassItem> classes;
  final Color labelColor;
  final Color lineColor;
  final Color dotColor;
  final double itemHeight;

  const _DayClassesBlock({
    required this.classes,
    required this.labelColor,
    required this.lineColor,
    required this.dotColor,
    required this.itemHeight,
  });

  @override
  Widget build(BuildContext context) {
    final showDots = classes.length > 1;

    return Container(
      height: itemHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: lineColor, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
        child: classes.isEmpty
            ? Center(
                child: Text(
                  'Sin clases',
                  style: GoogleFonts.rowdies(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: labelColor.withValues(alpha: 0.40),
                  ),
                ),
              )
            : ListView.separated(
                primary: false,
                physics: classes.length > 2
                    ? const ClampingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: classes.length,
                separatorBuilder: (_, _) => SizedBox(
                  height: 5,
                  child: Center(
                    child: Divider(
                        color: lineColor, thickness: 0.5, height: 1),
                  ),
                ),
                itemBuilder: (context, index) => _ClassRow(
                  classItem: classes[index],
                  labelColor: labelColor,
                  lineColor: lineColor,
                  dotColor: dotColor,
                  showDot: showDots,
                ),
              ),
      ),
    );
  }
}

// ─── Fila de una asignatura ───────────────────────────────────────────────────

class _ClassRow extends StatelessWidget {
  final _ClassItem classItem;
  final Color labelColor;
  final Color lineColor;
  final Color dotColor;
  final bool showDot;

  const _ClassRow({
    required this.classItem,
    required this.labelColor,
    required this.lineColor,
    required this.dotColor,
    required this.showDot,
  });

  @override
  Widget build(BuildContext context) {
    // IntrinsicHeight asegura que la barra vertical escala con el contenido
    // sin importar el tipo de fuente del sistema.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 2,
            margin: const EdgeInsets.only(right: 10),
            color: lineColor,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    classItem.subject,
                    style: GoogleFonts.rowdies(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: labelColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        classItem.startTime,
                        style: GoogleFonts.rowdies(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: labelColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        classItem.endTime,
                        style: GoogleFonts.rowdies(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: labelColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (showDot)
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 7,
                height: 7,
                margin: const EdgeInsets.only(left: 6),
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Bottom sheet con table_calendar ─────────────────────────────────────────

class _CalendarBottomSheet extends StatefulWidget {
  final DateTime focusedDay;
  final void Function(DateTime) onDaySelected;

  const _CalendarBottomSheet({
    required this.focusedDay,
    required this.onDaySelected,
  });

  @override
  State<_CalendarBottomSheet> createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<_CalendarBottomSheet> {
  late DateTime _focused;

  @override
  void initState() {
    super.initState();
    _focused = widget.focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    const bg = AppColors.homeDarkGreen;
    const textColor = AppColors.homeLightBg;

    return Container(
      decoration: const BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: TableCalendar(
            locale: 'es_ES',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2035, 12, 31),
            focusedDay: _focused,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableCalendarFormats: const {CalendarFormat.month: ''},
            onDaySelected: (selected, focused) {
              widget.onDaySelected(selected);
            },
            onPageChanged: (focused) => setState(() => _focused = focused),
            rowHeight: 44,
            daysOfWeekHeight: 26,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: GoogleFonts.rowdies(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              leftChevronIcon:
                  const Icon(Icons.chevron_left, color: textColor, size: 24),
              rightChevronIcon:
                  const Icon(Icons.chevron_right, color: textColor, size: 24),
              headerPadding: const EdgeInsets.symmetric(vertical: 6),
            ),
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                const labels = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
                final idx = day.weekday - 1;
                return Center(
                  child: Text(
                    labels[idx],
                    style: GoogleFonts.rowdies(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: day.weekday > 5
                          ? textColor.withValues(alpha: 0.30)
                          : textColor.withValues(alpha: 0.65),
                    ),
                  ),
                );
              },
            ),
            calendarStyle: CalendarStyle(
              cellMargin: const EdgeInsets.all(4),
              defaultTextStyle:
                  GoogleFonts.rowdies(color: textColor, fontSize: 14),
              weekendTextStyle: GoogleFonts.rowdies(
                  color: textColor.withValues(alpha: 0.38), fontSize: 14),
              outsideTextStyle: GoogleFonts.rowdies(
                  color: textColor.withValues(alpha: 0.25), fontSize: 14),
              selectedDecoration: const BoxDecoration(
                color: AppColors.green,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: GoogleFonts.rowdies(
                color: AppColors.homeDarkGreen,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
              todayTextStyle: GoogleFonts.rowdies(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
