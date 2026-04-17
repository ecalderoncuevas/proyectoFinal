import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final_synquid/core/router/app_router.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';

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
    final isHome = location == AppRoutes.homeStudent;

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
                        color: _iconColor(location),
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
                        _MenuLine(color: _iconColor(location)),
                        const SizedBox(height: 6),
                        _MenuLine(color: _iconColor(location)),
                        const SizedBox(height: 6),
                        _MenuLine(color: _iconColor(location)),
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
                        onClose: _closeDrawer,
                        onNavigate: (route) {
                          _closeDrawer();
                          context.go(route);
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


  Color _iconColor(String location) {
    if (location == AppRoutes.homeStudent) {
      return AppColors.homeLightBg;
    }
    return AppColors.homeDarkGreen;
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
  final VoidCallback onClose;
  final void Function(String route) onNavigate;

  const _DrawerContent({
    required this.onClose,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.homeDarkGreen,
        borderRadius: BorderRadius.only(
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
                  child: const Icon(
                    Icons.close,
                    color: AppColors.homeLightBg,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'SynQuid',
                  style: GoogleFonts.rowdies(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.homeLightBg,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              _DrawerItem(
                label: 'Perfil',
                onTap: () => onNavigate(AppRoutes.homeStudent),

              ),
              const SizedBox(height: 24),
              _DrawerItem(
                label: 'Faltas',
                onTap: () => onNavigate(AppRoutes.homeStudent),

              ),
              const SizedBox(height: 24),
              _DrawerItem(
                label: 'Calendario',
                onTap: () => onNavigate(AppRoutes.homeStudent),
        
              ),
              const SizedBox(height: 24),
              _DrawerItem(
                label: 'Ajustes',
                onTap: () => onNavigate(AppRoutes.homeStudent),

              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({required this.label, required this.onTap});

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
          color: AppColors.homeLightBg,
        ),
      ),
    );
  }
}