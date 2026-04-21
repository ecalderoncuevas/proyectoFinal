import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';

class _CursoData {
  final String profesor;
  final List<_AsignaturaData> asignaturas;

  const _CursoData({required this.profesor, required this.asignaturas});
}

class _AsignaturaData {
  final String name;
  final Color placeholderColor;

  const _AsignaturaData({required this.name, required this.placeholderColor});
}

class ClasesScreen extends StatelessWidget {
  const ClasesScreen({super.key});

  static const _cursos = [
    _CursoData(
      profesor: 'profesor',
      asignaturas: [
        _AsignaturaData(name: 'Interfaces', placeholderColor: Color(0xFFF5F0EB)),
        _AsignaturaData(name: 'Programación', placeholderColor: Color(0xFFF0EBF5)),
        _AsignaturaData(name: 'Base de datos', placeholderColor: Color(0xFFEBF5F0)),
        _AsignaturaData(name: 'Sistemas', placeholderColor: Color(0xFFF5EBEB)),
      ],
    ),
    _CursoData(
      profesor: 'profesor',
      asignaturas: [
        _AsignaturaData(name: 'Entorns', placeholderColor: Color(0xFFF5F0EB)),
        _AsignaturaData(name: 'FOL', placeholderColor: Color(0xFFF0EBF5)),
        _AsignaturaData(name: 'Empresa', placeholderColor: Color(0xFFEBF5F0)),
        _AsignaturaData(name: 'Inglés', placeholderColor: Color(0xFFF5EBEB)),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final appBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final headerBg = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final headerText = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final labelColor = isDark ? AppColors.green : AppColors.homeDarkGreen;

    return Scaffold(
      backgroundColor: appBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            color: headerBg,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 56, 24, 20),
                child: Text(
                  'Tus clases',
                  style: GoogleFonts.rowdies(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: headerText,
                  ),
                ),
              ),
            ),
          ),

          // Lista de cursos
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _cursos.map((curso) {
                  return _CursoSection(
                    curso: curso,
                    labelColor: labelColor,
                    isDark: isDark,
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

class _CursoSection extends StatelessWidget {
  final _CursoData curso;
  final Color labelColor;
  final bool isDark;

  const _CursoSection({
    required this.curso,
    required this.labelColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          curso.profesor,
          style: GoogleFonts.rowdies(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 12),
        // Grid de 2 columnas con carrusel horizontal
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: curso.asignaturas.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final asig = curso.asignaturas[index];
              return _AsignaturaCard(
                asignatura: asig,
                labelColor: labelColor,
                isDark: isDark,
              );
            },
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}

class _AsignaturaCard extends StatelessWidget {
  final _AsignaturaData asignatura;
  final Color labelColor;
  final bool isDark;

  const _AsignaturaCard({
    required this.asignatura,
    required this.labelColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.of(context).size.width - 24 * 2 - 16) / 2;

    return GestureDetector(
      onTap: () {
        context.push(
          AppRoutes.faltasClase,
          extra: asignatura.name,
        );
      },
      child: SizedBox(
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen placeholder
            Container(
              width: cardWidth,
              height: 170,
              decoration: BoxDecoration(
                color: asignatura.placeholderColor,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              asignatura.name,
              style: GoogleFonts.rowdies(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: labelColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}