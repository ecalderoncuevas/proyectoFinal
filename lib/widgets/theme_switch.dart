import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

// Toggle visual de tema claro/oscuro; usa flutter_advanced_switch para el efecto de deslizamiento
class ThemeSwitch extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const ThemeSwitch({
    super.key,
    required this.isDark,
    required this.onChanged,
  });

  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  // ValueNotifier requerido por AdvancedSwitch para controlar el estado del toggle
  late final ValueNotifier<bool> _controller;

  @override
  void initState() {
    super.initState();
    // Sincroniza el estado inicial del switch con el tema actual del ThemeProvider
    _controller = ValueNotifier<bool>(widget.isDark);
    // Propaga el cambio hacia arriba cuando el usuario desliza el switch
    _controller.addListener(() {
      widget.onChanged(_controller.value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  
@override
Widget build(BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(40),
    child: AdvancedSwitch(
      controller: _controller,
      // Verde claro cuando está en modo oscuro, gris cuando está en modo claro
      activeColor: const Color(0xFFC2D8C4),
      inactiveColor: const Color(0xFF444444),
      // Icono de luna en modo oscuro, sol en modo claro
      activeChild: const Icon(Icons.dark_mode, size: 15, color: Colors.black),
      inactiveChild: const Icon(Icons.light_mode, size: 15, color: Colors.white),
      width: 80,
      height: 36,
      thumb: Container(
        margin: const EdgeInsets.all(5),
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    ),
  );
}
}