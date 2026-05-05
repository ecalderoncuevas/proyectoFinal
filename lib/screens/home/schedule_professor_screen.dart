import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';
import 'package:proyecto_final_synquid/services/teacher_service.dart';

class _ClassSlot {
  final String groupName;
  final String level;
  final String startTime;
  final String endTime;

  _ClassSlot({
    required this.groupName,
    required this.level,
    required this.startTime,
    required this.endTime,
  });
}

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
  

  static final _workingDays = _buildWorkingDays();

  DateFormat _dayNameFormat = DateFormat('EEE', 'es');
  DateFormat _monthYearFormat = DateFormat('MMMM yyyy', 'es');

  // dayOfWeek (0=Sun,1=Mon,...,6=Sat) → slots for that weekday
  final Map<int, List<_ClassSlot>> _cache = {};
  bool _loadingSchedule = false;

  // DateTime.weekday: 1=Mon … 7=Sun  →  API: 0=Sun, 1=Mon … 6=Sat
  static int _apiDow(DateTime date) => date.weekday % 7;

  int get _todayIndex {
    var today = DateTime.now();
    while (today.weekday > 5) {
      today = today.add(const Duration(days: 1));
    }
    final idx = _workingDays.indexWhere(
      (d) =>
          d.year == today.year &&
          d.month == today.month &&
          d.day == today.day,
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

    _fetchSchedules();
  }

  Future<void> _fetchSchedules() async {
    setState(() => _loadingSchedule = true);
    try {
      final now = DateTime.now();
      final to = now.add(const Duration(days: 6));
      final items = await TeacherService(ApiClient()).getSchedule(
        from: now,
        to: to,
      );

      final newCache = <int, List<_ClassSlot>>{};
      final seenIds = <String>{};
      for (final item in items) {
        if (seenIds.contains(item.scheduleId)) continue;
        seenIds.add(item.scheduleId);
        newCache.putIfAbsent(item.dayOfWeek, () => []).add(
          _ClassSlot(
            groupName: item.groupName,
            level: item.level,
            startTime: item.startTime,
            endTime: item.endTime,
          ),
        );
      }

      if (mounted) setState(() => _cache.addAll(newCache));
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() => _loadingSchedule = false);

        WidgetsBinding.instance.addPostFrameCallback((_){
          if (_mainController.hasClients) {
            final offset = _todayIndex * _dayItemHeight;
            _mainController.jumpTo(offset);
            if (_sidebarController.hasClients) {
              _sidebarController.jumpTo(offset);
            }
            _updateMonthFromOffset();
          }
        });
      }
    }
  }

  List<_ClassSlot> _classesForDate(DateTime date) =>
      _cache[_apiDow(date)] ?? [];

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
    final idx =
        (offset / _dayItemHeight).floor().clamp(0, _workingDays.length - 1);
    final newMonth = _formatMonth(_workingDays[idx]);
    if (newMonth != _currentMonth) {
      setState(() => _currentMonth = newMonth);
    }
  }

  void _scrollToDate(DateTime date) {
    var target = date;
    if (target.weekday > 5) {
      target = target.add(Duration(days: 8 - target.weekday));
    }
    final idx = _workingDays.indexWhere(
      (d) =>
          d.year == target.year &&
          d.month == target.month &&
          d.day == target.day,
    );
    if (idx >= 0 && _mainController.hasClients) {
      _mainController.animateTo(
        idx * _dayItemHeight,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = context.locale.toString();
    _dayNameFormat = DateFormat('EEE', locale);
    _monthYearFormat = DateFormat('MMMM yyyy', locale);


    final screenHeight = MediaQuery.of(context).size.height;
    final computed = (screenHeight * 0.20).clamp(110.0, 155.0);
    if ((computed - _dayItemHeight).abs() > 1.0) {
      _dayItemHeight = computed;
    }

    if (_currentMonth.isEmpty) {
      _currentMonth = _formatMonth(DateTime.now());
    }
  }

  void _openCalendar(BuildContext context) {
    final idx = _mainController.hasClients
        ? (_mainController.offset / _dayItemHeight)
            .floor()
            .clamp(0, _workingDays.length - 1)
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
    final sidebarWidth = (screenWidth * 0.22).clamp(110.0, 140.0);

    return Scaffold(
      backgroundColor: appBg,
      body: Row(
        children: [
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
          Expanded(
            child: SafeArea(
              bottom: false,
              left: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 56),
                child: _loadingSchedule
                    ? Center(
                        child: CircularProgressIndicator(color: labelColor),
                      )
                    : ListView.builder(
                        controller: _mainController,
                        itemCount: _workingDays.length,
                        itemExtent: _dayItemHeight,
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

    final isDark = context.watch<ThemeProvider>().isDark;

    final sidebarBg = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final blockBg = isDark ? AppColors.darkBg : AppColors.green;
    final blockText = isDark ? AppColors.homeLightBg : AppColors.homeDarkGreen;
    final monthText = isDark ? AppColors.darkBg : AppColors.homeLightBg;


    return Container(
      width: width,
      height: double.infinity,
      decoration: BoxDecoration(
        color: sidebarBg,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
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
                      fontSize: 22,
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
          const SizedBox(width: 8),

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
                  itemExtent: itemHeight,
                  itemBuilder: (context, index) {
                    final date = dateForIndex(index);
                    return SizedBox(
                      height: itemHeight,
                      child: Center(
                        child: Container(
                          width: 58,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 12),
                          decoration: BoxDecoration(
                            color: blockBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                formatDayName(date),
                                style: GoogleFonts.rowdies(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: blockText,
                                ),
                                maxLines: 1,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${date.day}',
                                style: GoogleFonts.rowdies(
                                  fontSize: 18,
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
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _DayClassesBlock extends StatelessWidget {
  final List<_ClassSlot> classes;
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
        border: Border(bottom: BorderSide(color: lineColor, width: 1)),
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
                    child: Divider(color: lineColor, thickness: 0.5, height: 1),
                  ),
                ),
                itemBuilder: (context, index) => _ClassRow(
                  slot: classes[index],
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

class _ClassRow extends StatelessWidget {
  final _ClassSlot slot;
  final Color labelColor;
  final Color lineColor;
  final Color dotColor;
  final bool showDot;

  const _ClassRow({
    required this.slot,
    required this.labelColor,
    required this.lineColor,
    required this.dotColor,
    required this.showDot,
  });

  @override
  Widget build(BuildContext context) {
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
                    slot.groupName,
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
                        slot.startTime,
                        style: GoogleFonts.rowdies(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: labelColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        slot.endTime,
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
                color: textColor.withValues(alpha: 0.38),
                fontSize: 14,
              ),
              outsideTextStyle: GoogleFonts.rowdies(
                color: textColor.withValues(alpha: 0.25),
                fontSize: 14,
              ),
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
