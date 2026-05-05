import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/core/providers/user_provider.dart';

class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _drawerController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _drawerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _drawerController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _drawerController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  void _openDrawer() => _drawerController.forward();
  void _closeDrawer() => _drawerController.reverse();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final isHome = location == AppRoutes.homeStudent ||
        location == AppRoutes.homeProfessor;
    final isDark = context.watch<ThemeProvider>().isDark;
    final isProfessor = context.watch<UserProvider>().isProfessor;

    final hamburgerColor = isDark ? AppColors.homeDarkGreen : AppColors.homeLightBg; // #385144
    final backArrowColor = isDark ? AppColors.darkBg : AppColors.homeLightBg; // #222222

    return Scaffold(
      body: Stack(
        children: [
          widget.child,
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isHome)
                  GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        final homeRoute = isProfessor
                            ? AppRoutes.homeProfessor
                            : AppRoutes.homeStudent;
                        context.go(homeRoute);
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: backArrowColor,
                        size: 20,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 40),
                GestureDetector(
                  onTap: _openDrawer,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _MenuLine(color: hamburgerColor),
                        const SizedBox(height: 5),
                        _MenuLine(color: hamburgerColor),
                        const SizedBox(height: 5),
                        _MenuLine(color: hamburgerColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _drawerController,
            builder: (context, _) {
              if (_drawerController.isDismissed) {
                return const SizedBox.shrink();
              }
              return Stack(
                children: [
                  GestureDetector(
                    onTap: _closeDrawer,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 6 * _fadeAnimation.value,
                        sigmaY: 6 * _fadeAnimation.value,
                      ),
                      child: Container(
                        color: Colors.black
                            .withValues(alpha: 0.3 * _fadeAnimation.value),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _DrawerContent(
                        isDark: isDark,
                        isProfessor: isProfessor,
                        onClose: _closeDrawer,
                        onNavigate: (route) {
                          _closeDrawer();
                          if (route == AppRoutes.homeStudent ||
                              route == AppRoutes.homeProfessor) {
                            context.go(route);
                          } else {
                            context.push(route);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MenuLine extends StatelessWidget {
  final Color color;
  const _MenuLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 2.5,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _DrawerContent extends StatelessWidget {
  final bool isDark;
  final bool isProfessor;
  final VoidCallback onClose;
  final void Function(String route) onNavigate;

  const _DrawerContent({
    required this.isDark,
    required this.isProfessor,
    required this.onClose,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final textColor = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final homeRoute =
        isProfessor ? AppRoutes.homeProfessor : AppRoutes.homeStudent;

    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      height: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: onClose,
                  child: Icon(Icons.close, color: textColor, size: 28),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'SYNQUID',
                  style: GoogleFonts.rowdies(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              _DrawerItem(
                label: 'perfil'.tr(),
                color: textColor,
                onTap: () => onNavigate(AppRoutes.account),
              ),
              const SizedBox(height: 24),
              if (isProfessor) ...[
                _DrawerItem(
                  label: 'clases'.tr(),
                  color: textColor,
                  onTap: () => onNavigate(AppRoutes.clases),
                ),
                const SizedBox(height: 24),
              ] else ...[
                _DrawerItem(
                  label: 'faltas'.tr(),
                  color: textColor,
                  onTap: () => onNavigate(AppRoutes.faltasGenerales),
                ),
                const SizedBox(height: 24),
              ],
              _DrawerItem(
                label: 'calendario'.tr(),
                color: textColor,
                onTap: () => onNavigate(
                  isProfessor ? AppRoutes.scheduleProfessor : AppRoutes.schedule,
                ),
              ),
              const SizedBox(height: 24),
              _DrawerItem(
                label: 'ajustes'.tr(),
                color: textColor,
                onTap: () => onNavigate(AppRoutes.settings),
              ),
              const Spacer(),
              _FooterLink(label: 'your_privacy'.tr(), color: textColor),
              const SizedBox(height: 16),
              _FooterLink(label: 'terms_of_use'.tr(), color: textColor),
              const SizedBox(height: 16),
              _FooterLink(label: 'politica_privacidad'.tr(), color: textColor),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Text(
        label,
        style: GoogleFonts.rowdies(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: color,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final Color color;

  const _FooterLink({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Text(
        label,
        style: GoogleFonts.rowdies(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: color,
          decoration: TextDecoration.underline,
          decorationColor: color,
          decorationThickness: 2,
        ),
      ),
    );
  }
}
