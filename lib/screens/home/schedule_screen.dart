import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
  late DateTime _currentWeekStart;
  late int _selectedDayIndex;

  static const _dayLabels = ['L', 'Mar', 'Mie', 'J', 'V'];

  static const _monthNames = [
        '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  static const _allClasses = {
    0: [
      _ClassItem(subject: 'Interfaces', time: '13:14', professor: 'Javier', days: 'Mar,Mie'),
      _ClassItem(subject: 'Programación', time: '15:00', professor: 'Ana', days: 'Lun,Mie'),
      _ClassItem(subject: 'Base de datos', time: '16:30', professor: 'Carlos', days: 'Lun'),
    ],
    1: [
      _ClassItem(subject: 'Interfaces', time: '13:14', professor: 'Javier', days: 'Mar,Mie'),
      _ClassItem(subject: 'Sistemas', time: '15:00', professor: 'Pedro', days: 'Mar,Jue'),
      _ClassItem(subject: 'Entorns', time: '16:30', professor: 'Laura', days: 'Mar'),
      _ClassItem(subject: 'FOL', time: '18:00', professor: 'María', days: 'Mar,Jue'),
    ],
    2: [
      _ClassItem(subject: 'Interfaces', time: '13:14', professor: 'Javier', days: 'Mar,Mie'),
      _ClassItem(subject: 'Programación', time: '15:00', professor: 'Ana', days: 'Lun,Mie'),
      _ClassItem(subject: 'Inglés tecnico', time: '16:30', professor: 'Sara', days: 'Mie,Vie'),
      _ClassItem(subject: 'Interfaces', time: '13:14', professor: 'Javier', days: 'Mar,Mie'),
      _ClassItem(subject: 'Interfaces', time: '13:14', professor: 'Javier', days: 'Mar,Mie'),
      _ClassItem(subject: 'Interfaces', time: '13:14', professor: 'Javier', days: 'Mar,Mie'),
    ],
    3: [
      _ClassItem(subject: 'Sistemas', time: '13:14', professor: 'Pedro', days: 'Mar,Jue'),
      _ClassItem(subject: 'FOL', time: '15:00', professor: 'María', days: 'Mar,Jue'),
      _ClassItem(subject: 'Empresa', time: '16:30', professor: 'Roberto', days: 'Jue'),
    ],
    4: [
      _ClassItem(subject: 'Inglés tecnico', time: '13:14', professor: 'Sara', days: 'Mie,Vie'),
      _ClassItem(subject: 'Sistemas de gestion', time: '15:00', professor: 'Luis', days: 'Vie'),
    ],
  };

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
    _selectedDayIndex = (now.weekday - 1).clamp(0, 4);
  }
  
  DateTime get _selectedDate =>
      _currentWeekStart.add(Duration(days: _selectedDayIndex));
      
      
  List<_ClassItem> get _selectedClasses =>
      _allClasses[_selectedDayIndex] ?? [];
  
  
  void _previousWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
    });
  }
  
  void _nextWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
    });
  }

    String _formatToday() {
    final date = _selectedDate;
    final month = _monthNames[date.month];
    return 'Hoy, $month ${date.day}';
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
            width: double.infinity,
            color: headerBg,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 56, 24, 20),
                child: _WeekSelector(
                  currentWeekStart: _currentWeekStart,
                  selectedDayIndex: _selectedDayIndex,
                  dayLabels: _dayLabels,
                  textColor: headerText,
                  selectedBgColor: selectedDayBg,
                  selectedTextColor: selectedDayText,
                  onDaySelected: (index) {
                    setState(() => _selectedDayIndex = index);
                  },
                  onPreviousWeek: _previousWeek,
                  onNextWeek: _nextWeek,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Text(
              _formatToday(),
              style: GoogleFonts.rowdies(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: labelColor,
              ),
            ),
          ),

          const SizedBox(height: 16),

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
                    separatorBuilder: (_, __) => Divider(
                      color: dividerColor,
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      return _ClassRow(
                        item: _selectedClasses[index],
                        textColor: labelColor,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _WeekSelector extends StatelessWidget {
  final DateTime currentWeekStart;
  final int selectedDayIndex;
  final List<String> dayLabels;
  final Color textColor;
  final Color selectedBgColor;
  final Color selectedTextColor;
  final ValueChanged<int> onDaySelected;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  const _WeekSelector({
    required this.currentWeekStart,
    required this.selectedDayIndex,
    required this.dayLabels,
    required this.textColor,
    required this.selectedBgColor,
    required this.selectedTextColor,
    required this.onDaySelected,
    required this.onPreviousWeek,
    required this.onNextWeek,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! > 0) {
            onPreviousWeek();
          } else if (details.primaryVelocity! < 0) {
            onNextWeek();
          }
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(5, (index) {
          final date = currentWeekStart.add(Duration(days: index));
          final isSelected = index == selectedDayIndex;

          return GestureDetector(
            onTap: () => onDaySelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? selectedBgColor : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dayLabels[index],
                    style: GoogleFonts.rowdies(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? selectedTextColor : textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: GoogleFonts.rowdies(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? selectedTextColor : textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 2,
                    width: isSelected ? 20 : 0,
                    decoration: BoxDecoration(
                      color: selectedTextColor,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
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

