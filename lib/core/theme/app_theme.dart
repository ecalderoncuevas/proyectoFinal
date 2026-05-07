import 'package:flutter/material.dart';

// Paleta de colores global de la app; toda la UI debe referenciar estos valores
class AppColors {
  // ── Tema oscuro ────────────────────────────────────────────────────────────
  static const darkBg  = Color(0xFF222222); // Fondo principal en modo dark
  static const green   = Color(0xFFC2D8C4); // Verde claro usado en textos e iconos en dark
  static const white   = Color(0xFFFFFFFF);
  static const lightBg = Color(0xFFF0F4F1);

  // ── Tema claro (home) ──────────────────────────────────────────────────────
  static const homeDarkGreen = Color(0xFF385144); // Verde oscuro principal en light
  static const homeLightBg   = Color(0xFFF8F5F2); // Fondo cálido en modo light

  // ── Tags de estado de asistencia ──────────────────────────────────────────
  // Verde: ratio faltas/total < 50 % — situación normal
  static const tagGreen  = Color(0xFF84FF90);
  // Amarillo: ratio >= 50 % — aviso de acumulación de faltas
  static const tagYellow = Color(0xFFFFD484);
  // Rojo: ratio >= 75 % — situación crítica de faltas
  static const tagRed    = Color(0xFFFF8484);
}