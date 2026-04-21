import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/widgets/legend_popup.dart';

class _AlumnoItem {
  final String name;
  final int faltas;
  final int total;

  const _AlumnoItem({
    required this.name,
    required this.faltas,
    required this.total,
  });

  Color get tagColor {
    final ratio = faltas / total;
    if (ratio >= 0.5) return AppColors.tagRed;
    if (ratio >= 0.25) return AppColors.tagYellow;
    return AppColors.tagGreen;
  }
}

class FaltasClaseScreen extends StatelessWidget {
  final String subject;

  const FaltasClaseScreen({super.key, required this.subject});

  static const _alumnos = [
    _AlumnoItem(name: 'Alumno1', faltas: 19, total: 20),
    _AlumnoItem(name: 'Alumno2', faltas: 17, total: 20),
    _AlumnoItem(name: 'Alumno1', faltas: 16, total: 20),
    _AlumnoItem(name: 'Alumno2', faltas: 17, total: 20),
    _AlumnoItem(name: 'Alumno1', faltas: 19, total: 20),
    _AlumnoItem(name: 'Alumno2', faltas: 17, total: 20),
    _AlumnoItem(name: 'Alumno1', faltas: 19, total: 20),
    _AlumnoItem(name: 'Alumno2', faltas: 17, total: 20),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final appBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final headerBg = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final headerText = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final labelColor = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final dividerColor = isDark ? Colors.white24 : Colors.black26;
    final avatarBg = isDark ? AppColors.green.withOpacity(0.3) : AppColors.green;

   
    final grupos = <List<_AlumnoItem>>[];
    for (var i = 0; i < _alumnos.length; i += 2) {
      final end = (i + 2 > _alumnos.length) ? _alumnos.length : i + 2;
      grupos.add(_alumnos.sublist(i, end));
    }

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
                  subject,
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
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => LegendPopup.show(
                  context,
                  items: LegendPopup.faltasItems,
                ),
                child: Text(
                  'Ver leyenda',
                  style: GoogleFonts.rowdies(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: labelColor,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

        
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: grupos.length,
              separatorBuilder: (_, __) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(color: dividerColor, height: 1),
              ),
              itemBuilder: (context, index) {
                return _AlumnoGrupo(
                  alumnos: grupos[index],
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

class _AlumnoGrupo extends StatelessWidget {
  final List<_AlumnoItem> alumnos;
  final Color labelColor;
  final Color avatarBg;

  const _AlumnoGrupo({
    required this.alumnos,
    required this.labelColor,
    required this.avatarBg,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: alumnos.map((alumno) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: _AlumnoRow(
            alumno: alumno,
            labelColor: labelColor,
            avatarBg: avatarBg,
          ),
        );
      }).toList(),
    );
  }
}

class _AlumnoRow extends StatelessWidget {
  final _AlumnoItem alumno;
  final Color labelColor;
  final Color avatarBg;

  const _AlumnoRow({
    required this.alumno,
    required this.labelColor,
    required this.avatarBg,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
            color: AppColors.homeDarkGreen.withOpacity(0.5),
            size: 24,
          ),
        ),
        const SizedBox(width: 14),

        Expanded(
          child: Text(
            alumno.name,
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
    );
  }
}