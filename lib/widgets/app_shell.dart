import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';

class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _drawerController;
  late final Animation <Offset> _slideAnimation;
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
    final isHome = location == AppRoutes.homeStudent;
    final isDark = context.watch<ThemeProvider>().isDark;


    final iconColor = isDark ? AppColors.green : AppColors.homeLightBg;

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
                    onTap: () => context.pop(),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: iconColor,
                        size: 22,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 38),
                GestureDetector(
                  onTap: _openDrawer,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _MenuLine(color: iconColor),
                        const SizedBox(height: 6),
                        _MenuLine(color: iconColor),
                        const SizedBox(height: 6),
                        _MenuLine(color: iconColor),
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
                            .withOpacity(0.3 * _fadeAnimation.value),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _DrawerContent(
                        isDark: isDark,
                        onClose: _closeDrawer,
                        onNavigate: (route) {
                          _closeDrawer();
                          if (route == AppRoutes.homeStudent) {
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
      width: 28,
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
  final VoidCallback onClose;
  final void Function(String route) onNavigate;

  const _DrawerContent({
    required this.isDark,
    required this.onClose,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {

    final bgColor = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final textColor = isDark ? AppColors.darkBg : AppColors.homeLightBg;

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
                label: 'Perfil',
                color: textColor,
                onTap: () => onNavigate(AppRoutes.homeStudent),
              ),
              const SizedBox(height: 24),
              _DrawerItem(
                label: 'Faltas',
                color: textColor,
                underline: true,
                onTap: () => onNavigate(AppRoutes.homeStudent),
              ),
              const SizedBox(height: 24),
              _DrawerItem(
                label: 'Calendario',
                color: textColor,
                onTap: () => onNavigate(AppRoutes.homeStudent),
              ),
              const SizedBox(height: 24),
              _DrawerItem(
                label: 'Ajustes',
                color: textColor,
                onTap: () => onNavigate(AppRoutes.settings),
              ),
              const Spacer(),
          
              _FooterLink(label: 'Your Privacy', color: textColor),
              const SizedBox(height: 16),
              _FooterLink(label: 'Terms of Use', color: textColor),
              const SizedBox(height: 16),
              _FooterLink(label: 'Política y Privacidad', color: textColor),
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
  final bool underline;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.label,
    required this.color,
    required this.onTap,
    this.underline = false,
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
          decoration:
              underline ? TextDecoration.underline : TextDecoration.none,
          decorationColor: color,
          decorationThickness: 2,
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