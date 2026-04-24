import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/widgets/back_app_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';


class _StudentAbsence {
  final String name;
  final String timeRange;
  String status;


  _StudentAbsence({
    required this.name,
    required this.timeRange,
    this.status = 'Ausente',
  });
}

class ReducirFaltasScreen extends StatefulWidget {
  const ReducirFaltasScreen({super.key});

  @override
  State<ReducirFaltasScreen> createState() => _ReducirFaltasScreenState();

}

class _ReducirFaltasScreenState extends State<ReducirFaltasScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  final List<String> _statusOptions = [
    'Presente',
    'Ausente',
    'Justificado',
    'Tarde'
  ];

  // Lista simulada de estudiantes que faltaron ese dia
  final List<_StudentAbsence> _students = [
    _StudentAbsence(name: 'Alumno1', timeRange: '9:00 - 10:00 PM'),
    _StudentAbsence(name: 'Alumno2', timeRange: '9:00 - 10:00 PM'),
    _StudentAbsence(name: 'Alumno3', timeRange: '10:00 - 11:00 PM'),
    _StudentAbsence(name: 'Alumno4', timeRange: '11:00 - 12:00 PM'),
    _StudentAbsence(name: 'Alumno5', timeRange: '9:00 - 10:00 PM'),
  ];

  String _getMonthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
  }

  String _getWeekdayName(int weekday) {
    const days = [
      'Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes'
    ];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final appBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final appGreen = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final textColor = isDark ? Colors.white : AppColors.homeDarkGreen;
    final dropdownBgColor = isDark ? const Color(0xFFADC4A8) : appGreen.withOpacity(0.8);

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
                  //Aqui se haria un fetch a la api para traer a losm alumnos de la nueva fecha
                });
              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: GoogleFonts.rowdies(color: textColor, fontSize: 16),
                leftChevronIcon: Icon(Icons.chevron_left, color: textColor),
                rightChevronIcon: Icon(Icons.chevron_right, color: textColor),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: GoogleFonts.rowdies(color: textColor, fontSize: 12),
                weekendStyle: GoogleFonts.rowdies(color: textColor.withOpacity(0.6), fontSize: 12),
              ),
              calendarStyle: CalendarStyle(
                defaultTextStyle: GoogleFonts.rowdies(color: textColor),
                weekendTextStyle: GoogleFonts.rowdies(color: textColor.withOpacity(0.6)),
                selectedDecoration: BoxDecoration(
                  color: appGreen,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: appGreen.withOpacity(0.3),
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

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Divider(color: textColor, thickness: 1.5),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                itemCount: _students.length,
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(color: textColor.withOpacity(0.5), thickness: 1),
                ),
                itemBuilder: (context, index){
                  final student = _students[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.name,
                              style: GoogleFonts.rowdies(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              student.timeRange,
                              style: GoogleFonts.rowdies(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: textColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),

                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: student.status,
                          dropdownColor: dropdownBgColor,
                          borderRadius: BorderRadius.circular(16),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: textColor,
                              size: 20,
                            ),
                          ),
                          items: _statusOptions.map((String status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  status,
                                  style: GoogleFonts.rowdies(
                                    color: status == student.status ? textColor : AppColors.darkBg,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue){
                            if (newValue != null) {
                              setState(() {
                                student.status = newValue;
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
          ],
        ),
      ),
    );
  }
}
                              