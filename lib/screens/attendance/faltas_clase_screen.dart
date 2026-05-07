import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/models/student.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';
import 'package:proyecto_final_synquid/services/attendance_service.dart';
import 'package:proyecto_final_synquid/services/teacher_service.dart';
import 'package:proyecto_final_synquid/widgets/legend_popup.dart';

// Agrupa un alumno con su conteo de faltas para la vista del profesor en FaltasClaseScreen
class _AlumnoData {
  final Student student;
  final int faltas;
  final int total;

  _AlumnoData({
    required this.student,
    required this.faltas,
    required this.total,
  });

  Color get tagColor {
    if (total == 0) return AppColors.tagGreen;
    final ratio = faltas / total;

    if (ratio >= 0.75) return AppColors.tagRed;
    if (ratio >= 0.50) return AppColors.tagYellow;
    return AppColors.tagGreen;
  }
}

// Pantalla del profesor: lista los alumnos de un grupo con su ratio de faltas
// Permite navegar a ReducirFaltasScreen para editar la asistencia día a día
class FaltasClaseScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  const FaltasClaseScreen({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  State<FaltasClaseScreen> createState() => _FaltasClaseScreenState();
}

class _FaltasClaseScreenState extends State<FaltasClaseScreen> {
  List<_AlumnoData> _alumnos = [];
  List<Student> _students = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Carga en paralelo los alumnos del grupo y el historial de asistencia del año
  // Luego cruza los datos en cliente para calcular faltas y total de clases por alumno
  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _error = null;
      _alumnos.clear();
    });

    try {
      final client = ApiClient();

      // Obtiene la lista de alumnos del grupo desde /teacher/groups/:id/students
      final studentsList = await TeacherService(client).getGroupStudents(widget.groupId);

      // Descarga todo el historial del grupo (hasta 1000 registros del último año)
      final historyResponse = await AttendanceService(client).getHistory(
        groupId: widget.groupId,
      );

      List<_AlumnoData> listaMapeada = [];

      for (var student in studentsList) {
        // Filtra los registros del historial global que pertenecen a este alumno
        final studentRecords = historyResponse.attendances
            .where((record) => record.userId == student.userId)
            .toList();

        int totalClases = studentRecords.length;
        int totalFaltas = studentRecords.where((r) => r.status == 1).length;

        listaMapeada.add(
          _AlumnoData(
            student: student,
            faltas: totalFaltas,
            total: totalClases,
          ),
        );
      }

      // Actualiza el estado con los datos construidos para renderizar la lista
      if (mounted) {
        setState(() {
          _students = studentsList;
          _alumnos = listaMapeada;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final appBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final headerBg = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final headerText = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final labelColor = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final dividerColor = isDark ? Colors.white24 : Colors.black26;
    final avatarBg = isDark ? AppColors.green : AppColors.green;

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
                child: Text(
                  widget.groupName,
                  style: GoogleFonts.rowdies(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: headerText,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => LegendPopup.show(
                      context,
                      items: LegendPopup.faltasItems,
                    ),
                    child: Text(
                      'ver_leyenda'.tr(),
                      style: GoogleFonts.rowdies(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: labelColor,
                      ),
                    ),
                  ),
                ),
                if (!_loading && _error == null)
                  GestureDetector(
                    onTap: () async {
                      await context.push(
                        AppRoutes.reducirFaltas,
                          extra: {
                            'groupId': widget.groupId,
                            'students': _students,
                          },
                      );
                      _fetchData();
                    },
                    child: Text(
                      '${'reducir_faltas'.tr()} →',
                      style: GoogleFonts.rowdies(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: labelColor,
                      ),
                    ),
                  ),
              ],
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
                              'error_load_students'.tr(),
                              style: GoogleFonts.rowdies(
                                color: labelColor,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: _fetchData,
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
                      )
                    : _alumnos.isEmpty
                        ? Center(
                            child: Text(
                              'no_students'.tr(),
                              style: GoogleFonts.rowdies(
                                color: labelColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: _alumnos.length,
                            separatorBuilder: (_, _) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Divider(color: dividerColor, height: 1),
                            ),
                            itemBuilder: (context, index) {
                              return _AlumnoRow(
                                alumno: _alumnos[index],
                                labelColor: labelColor,
                                avatarBg: avatarBg,
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

// Fila de un alumno en la lista: avatar, nombre completo y badge de faltas coloreado
class _AlumnoRow extends StatelessWidget {
  final _AlumnoData alumno;
  final Color labelColor;
  final Color avatarBg;

  const _AlumnoRow({
    required this.alumno,
    required this.labelColor,
    required this.avatarBg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: avatarBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: AppColors.homeDarkGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              alumno.student.fullName,
              style: GoogleFonts.rowdies(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: labelColor,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: alumno.tagColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${alumno.faltas}/${alumno.total}',
              style: GoogleFonts.rowdies(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.darkBg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
