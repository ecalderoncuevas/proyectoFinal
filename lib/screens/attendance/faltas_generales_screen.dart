import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/providers/user_provider.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/widgets/legend_popup.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';

// Modelo local que agrupa el resumen de faltas de un grupo para la vista de lista
class _FaltaItem {
  final String groupId;
  final String subject;
  final int faltas;
  final int total;

  _FaltaItem({
    required this.groupId,
    required this.subject,
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

// Pantalla de resumen de faltas del alumno: lista todas las asignaturas con contador y tag de color
class FaltasGeneralesScreen extends StatelessWidget {
  const FaltasGeneralesScreen({super.key});

  // Construye la lista de _FaltaItem agrupando el historial cacheado en UserProvider por groupId
  List<_FaltaItem> _buildItems(UserProvider provider) {
    final history = provider.attendanceHistory ?? [];
    final map = <String, Map<String, dynamic>>{};
    for (final r in history) {
      map.putIfAbsent(
        r.groupId,
        () => {'name': r.groupName, 'faltas': 0, 'total': 0},
      );
      map[r.groupId]!['total'] = (map[r.groupId]!['total'] as int) + 1;
      if (r.status == 1) {
        map[r.groupId]!['faltas'] = (map[r.groupId]!['faltas'] as int) + 1;
      }
    }
    return map.entries
        .map((e) => _FaltaItem(
              groupId: e.key,
              subject: e.value['name'] as String,
              faltas: e.value['faltas'] as int,
              total: e.value['total'] as int,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final provider = context.watch<UserProvider>();
    final appBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final appGreen = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final cardTextColor = isDark ? AppColors.darkBg : AppColors.homeLightBg;

    final faltas = _buildItems(provider);

    return Scaffold(
      backgroundColor: appBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FaltasHeader(headerColor: appGreen, textColor: appBg),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () =>
                    LegendPopup.show(context, items: LegendPopup.faltasItems),
                child: Text(
                  'ver_leyenda'.tr(),
                  style: GoogleFonts.rowdies(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: appGreen,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: faltas.isEmpty
                ? Center(
                    child: Text(
                      provider.attendanceHistory == null
                          ? 'loading'.tr()
                          : 'no_attendance_records'.tr(),
                      style: GoogleFonts.rowdies(
                        color: appGreen,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: faltas.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = faltas[index];
                      return GestureDetector(
                        onTap: () {
                          context.push(
                            AppRoutes.faltasAsignatura,
                            extra: {
                              'groupId': item.groupId,
                              'subject': item.subject,
                              'faltas': item.faltas,
                              'total': item.total,
                              'tagColor': item.tagColor,
                            },
                          );
                        },
                        child: _FaltaCard(
                          item: item,
                          cardBgColor: appGreen,
                          cardTextColor: cardTextColor,
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _FaltasHeader extends StatelessWidget {
  final Color headerColor;
  final Color textColor;

  const _FaltasHeader({required this.headerColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: headerColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 56, 24, 20),
          child: Text(
            'faltas'.tr(),
            style: GoogleFonts.rowdies(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

// Fila de la lista de faltas: parte izquierda con nombre y parte derecha con contador coloreado
class _FaltaCard extends StatelessWidget {
  final _FaltaItem item;
  final Color cardBgColor;
  final Color cardTextColor;

  const _FaltaCard({
    required this.item,
    required this.cardBgColor,
    required this.cardTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52, 
      child: Row(
        children: [
         
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  topRight: Radius.circular(4), 
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Text(
                item.subject,
                style: GoogleFonts.rowdies(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: cardTextColor,
                ),
                maxLines: 1, 
                overflow: TextOverflow.ellipsis, 
              ),
            ),
          ),
          

          const SizedBox(width: 4),
          
       
          Container(
            width: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: item.tagColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4), 
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Text(
              '${item.faltas}/${item.total}',
              style: GoogleFonts.rowdies(
                fontSize: 16,
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
