import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/providers/user_provider.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';
import 'package:proyecto_final_synquid/core/storage/token_storage.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  static Future<bool?> _showLogoutDialog(BuildContext context) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cancelar logout',
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
                color: AppColors.homeLightBg,
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
                    'Cerrar sesión',
                    style: GoogleFonts.rowdies(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.homeDarkGreen,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '¿Estás seguro de que quieres salir?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rowdies(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: AppColors.homeDarkGreen,
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
                          'Confirmar',
                          style: GoogleFonts.rowdies(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.homeLightBg,
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
                          color: AppColors.homeDarkGreen,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.rowdies(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.homeDarkGreen,
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

  Future<void> _logout(BuildContext context) async {
    final confirmed = await _showLogoutDialog(context);
    if (confirmed != true) return;
    await TokenStorage().deleteToken();
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
                    label: 'Correo',
                    value: email,
                    textColor: textColor,
                  ),
                  _Divider(color: dividerColor),
                  _InfoFieldWithAction(
                    label: 'Password',
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
                      'Delete account',
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
                'Log out',
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