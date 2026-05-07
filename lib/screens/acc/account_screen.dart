import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/providers/user_provider.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';
import 'package:proyecto_final_synquid/core/storage/token_storage.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/services/auth_service.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';


// Pantalla de perfil del usuario: muestra nombre, email, opción de cambiar contraseña y botón de logout
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  // Muestra un diálogo de confirmación animado antes de ejecutar el logout
  static Future<bool?> _showLogoutDialog(BuildContext context) {

    final isDark = context.read<ThemeProvider>().isDark;

    final bgColor = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    
    final accentColor = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final invertedText = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'close',
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInCubic,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curve),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 280,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'log_out'.tr(),
                    style: GoogleFonts.rowdies(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'logout_confirm'.tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rowdies(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(true),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.homeDarkGreen,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          'confirm'.tr(),
                          style: GoogleFonts.rowdies(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.homeLightBg : AppColors.homeLightBg,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: accentColor,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          'cancel'.tr(),
                          style: GoogleFonts.rowdies(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Ejecuta el flujo completo de logout: confirmación → llamada a la API → limpia el provider → navega a welcome
  Future<void> _logout(BuildContext context) async {
    final confirmed = await _showLogoutDialog(context);
    if (confirmed != true) return;

    
    final authService = AuthService(ApiClient(), TokenStorage());
    await authService.logout();

    if (!context.mounted) return;

   
    context.read<UserProvider>().clear();
    context.go(AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final provider = context.watch<UserProvider>();
    final bgColor = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final textColor = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final avatarInner = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final dividerColor = isDark ? Colors.white12 : Colors.black12;
    final iconColor = isDark ? Colors.white54 : Colors.black38;

    final user = provider.user;
    final fullName = user?.fullName ?? '—';
    final email = user?.email ?? '—';

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: double.infinity,
                color: isDark ? AppColors.green : AppColors.homeDarkGreen,
                child: SafeArea(
                  bottom: false,
                  child: const SizedBox(height: 60),
                ),
              ),
              Positioned(
                bottom: -50,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: bgColor,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundColor: avatarInner,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 62),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      fullName,
                      style: GoogleFonts.rowdies(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _InfoField(
                    label: 'correo'.tr(),
                    value: email,
                    textColor: textColor,
                  ),
                  _Divider(color: dividerColor),
                  _InfoFieldWithAction(
                    label: 'password'.tr(),
                    value: '····················',
                    actionIcon: Icons.lock_reset_rounded,
                    textColor: textColor,
                    iconColor: iconColor,
                    onActionTap: () => context.push(AppRoutes.forgotPassword),
                  ),
                  _Divider(color: dividerColor),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'delete_account'.tr(),
                      style: GoogleFonts.rowdies(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: GestureDetector(
              onTap: () => _logout(context),
              child: Text(
                'log_out'.tr(),
                style: GoogleFonts.rowdies(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Campo de solo lectura que muestra etiqueta y valor apilados verticalmente
class _InfoField extends StatelessWidget {
  final String label;
  final String value;
  final Color textColor;

  const _InfoField({
    required this.label,
    required this.value,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.rowdies(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.rowdies(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Campo con etiqueta/valor y un icono de acción a la derecha; usado para "Contraseña" con icono de reseteo
class _InfoFieldWithAction extends StatelessWidget {
  final String label;
  final String value;
  final IconData actionIcon;
  final Color textColor;
  final Color iconColor;
  final VoidCallback onActionTap;

  const _InfoFieldWithAction({
    required this.label,
    required this.value,
    required this.actionIcon,
    required this.textColor,
    required this.iconColor,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.rowdies(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.rowdies(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onActionTap,
            child: Icon(actionIcon, color: iconColor, size: 22),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final Color color;
  const _Divider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Divider(color: color, height: 1);
  }
}
