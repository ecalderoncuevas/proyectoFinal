import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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

class ScheduleProfessorScreen extends StatefulWidget {
  const ScheduleProfessorScreen({super.key});

  @override
  State<ScheduleProfessorScreen> createState() =>
      _ScheduleProfessorScreenState();
}

class _ScheduleProfessorScreenState extends State<ScheduleProfessorScreen> {
  late final ScrollController _mainController;
  late final ScrollController _sidebarController;
  late final DateTime _today;
  String _currentMonth = '';

  static const _dayItemHeight = 220.0;

  // Formatters de intl en español
  final _dayNameFormat = DateFormat('EEE', 'es_ES');
  final _monthYearFormat = DateFormat('MMMM yyyy', 'es_ES');

  static final _classesByWeekday = <int, List<_ClassItem>>{
    1: const [
      _ClassItem(subject: 'Interfaces', startTime: '10', endTime: '11'),
      _ClassItem(subject: 'Interfaces', startTime: '10', endTime: '11'),
    ],
    2: const [
      _ClassItem(subject: 'Interfaces', startTime: '10', endTime: '11'),
      _ClassItem(subject: 'Interfaces', startTime: '10', endTime: '11'),
    ],
    3: const [
      _ClassItem(subject: 'Interfaces', startTime: '10', endTime: '11'),
      _ClassItem(subject: 'Interfaces', startTime: '10', endTime: '11'),
    ],
    4: const [
      _ClassItem(subject: 'Interfaces', startTime: '10', endTime: '11'),
      _ClassItem(subject: 'Interfaces', startTime: '10', endTime: '11'),
    ],
    5: const [
      _ClassItem(
          subject: 'Programación de Servicios',
          startTime: '10',
          endTime: '11'),
      _ClassItem(
          subject: 'Programación Multimedia', startTime: '10', endTime: '11'),
    ],
  };

  static const _specialDay = 23;
  static const _specialDayClasses = [
    _ClassItem(subject: 'Interfaces', startTime: '10', endTime: '11'),
    _ClassItem(subject: 'Interfaces', startTime: '10', endTime: '11'),
    _ClassItem(subject: 'Programación', startTime: '12', endTime: '13'),
    _ClassItem(subject: 'Sistemas', startTime: '14', endTime: '15'),
  ];

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _mainController = ScrollController();
    _sidebarController = ScrollController();

    _mainController.addListener(() {
      if (_sidebarController.hasClients) {
        _sidebarController.jumpTo(_mainController.offset);
      }
      _updateMonthFromOffset();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateMonthFromOffset();
    });
  }

  DateTime _dateForIndex(int index) {
    var date = _today;
    while (date.weekday > 5) {
      date = date.add(const Duration(days: 1));
    }
    if (index == 0) return date;

    var count = 0;
    while (count < index) {
      date = date.add(const Duration(days: 1));
      if (date.weekday <= 5) count++;
    }
    return date;
  }

  List<_ClassItem> _classesForDate(DateTime date) {
    if (date.day == _specialDay) return _specialDayClasses;
    return _classesByWeekday[date.weekday] ?? [];
  }

  String _formatDayName(DateTime date) {
    // Capitalizar primera letra: "lun" -> "Lun"
    final raw = _dayNameFormat.format(date);
    return raw[0].toUpperCase() + raw.substring(1);
  }

  String _formatMonth(DateTime date) {
    final raw = _monthYearFormat.format(date);
    return raw[0].toUpperCase() + raw.substring(1);
  }

  void _updateMonthFromOffset() {
    if (!_mainController.hasClients) return;
    final offset = _mainController.offset;
    final visibleIndex = (offset / _dayItemHeight).floor();
    final visibleDate = _dateForIndex(visibleIndex);
    final newMonth = _formatMonth(visibleDate);
    if (newMonth != _currentMonth) {
      setState(() => _currentMonth = newMonth);
    }
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
    const sidebarBg = AppColors.green;
    const sidebarText = AppColors.homeDarkGreen;
    const dayBlockBg = AppColors.homeDarkGreen;
    const dayBlockText = AppColors.homeLightBg;
    final labelColor = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final lineColor = isDark ? Colors.white24 : Colors.black26;
    final dotColor = isDark ? AppColors.green : AppColors.homeDarkGreen;

    // Sidebar responsive: ~22% del ancho de pantalla, mínimo 80px, máximo 110px
    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth = (screenWidth * 0.22).clamp(80.0, 110.0);

    return Scaffold(
      backgroundColor: appBg,
      body: Row(
        children: [
          // Sidebar lateral que ocupa TODA la altura de la pantalla
          _SidebarColumn(
            scrollController: _sidebarController,
            currentMonth: _currentMonth,
            bgColor: sidebarBg,
            textColor: sidebarText,
            dayBlockBg: dayBlockBg,
            dayBlockText: dayBlockText,
            dateForIndex: _dateForIndex,
            formatDayName: _formatDayName,
            itemHeight: _dayItemHeight,
            width: sidebarWidth,
          ),
          // Columna derecha: clases por día
          Expanded(
            child: SafeArea(
              bottom: false,
              left: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 56),
                child: ListView.builder(
                  controller: _mainController,
                  itemBuilder: (context, index) {
                    final date = _dateForIndex(index);
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

class _SidebarColumn extends StatelessWidget {
  final ScrollController scrollController;
  final String currentMonth;
  final Color bgColor;
  final Color textColor;
  final Color dayBlockBg;
  final Color dayBlockText;
  final DateTime Function(int) dateForIndex;
  final String Function(DateTime) formatDayName;
  final double itemHeight;
  final double width;

  const _SidebarColumn({
    required this.scrollController,
    required this.currentMonth,
    required this.bgColor,
    required this.textColor,
    required this.dayBlockBg,
    required this.dayBlockText,
    required this.dateForIndex,
    required this.formatDayName,
    required this.itemHeight,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // Mes vertical en una columna propia, separado de los días
          SizedBox(
            width: 32,
            child: IgnorePointer(
              child: Center(
                child: RotatedBox(
                  quarterTurns: -1,
                  child: Text(
                    currentMonth,
                    style: GoogleFonts.rowdies(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Bloques de días sincronizados con el scroll principal
          Expanded(
            child: SafeArea(
              bottom: false,
              right: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 56),
                child: ListView.builder(
                  controller: scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final date = dateForIndex(index);
                    return SizedBox(
                      height: itemHeight,
                      child: Center(
                        child: Container(
                          width: 52,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: dayBlockBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                formatDayName(date),
                                style: GoogleFonts.rowdies(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: dayBlockText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${date.day}',
                                style: GoogleFonts.rowdies(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: dayBlockText,
                                ),
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
    return Container(
      height: itemHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: lineColor, width: 1),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 32, 12),
            child: classes.isEmpty
                ? Center(
                    child: Text(
                      'Sin clases',
                      style: GoogleFonts.rowdies(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: labelColor.withOpacity(0.4),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: classes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _ClassRow(
                        classItem: classes[index],
                        labelColor: labelColor,
                        lineColor: lineColor,
                      );
                    },
                  ),
          ),
          Positioned(
            right: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: classes.map((_) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassRow extends StatelessWidget {
  final _ClassItem classItem;
  final Color labelColor;
  final Color lineColor;

  const _ClassRow({
    required this.classItem,
    required this.labelColor,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 2,
          height: 36,
          margin: const EdgeInsets.only(right: 12, top: 2),
          color: lineColor,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                classItem.subject,
                style: GoogleFonts.rowdies(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: labelColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    classItem.startTime,
                    style: GoogleFonts.rowdies(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: labelColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    classItem.endTime,
                    style: GoogleFonts.rowdies(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: labelColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}