import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/theme_switch.dart';

class PantallaSettings extends StatefulWidget {
  const PantallaSettings({super.key});

  @override
  State<PantallaSettings> createState() => _PantallaSettingsState();
}

class _PantallaSettingsState extends State<PantallaSettings> {
  bool _isDark = true;
  bool _notificationsEnabled = true;
  double _fontSize = 0.5;
  String? _selectedLanguage;

  final List<String> _languages = [
    'Català',
    'Español',
    'English',
    'Français',
  ];

  @override
  Widget build(BuildContext context) {
    const bgColor = AppColors.darkBg;
    const green = AppColors.green;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Header verde ──────────────────────────────────────────
          Container(
            width: double.infinity,
            color: green,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Configuration',
                      style: GoogleFonts.rowdies(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Contenido ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  _SettingsRow(
                    icon: Icons.person_outline,
                    label: 'Account',
                    onTap: () {},
                  ),
                  const _Divider(),

                  _SettingsRow(
                    icon: Icons.lock_outline,
                    label: 'Privacy',
                    onTap: () {},
                  ),
                  const _Divider(),


                  _SettingsRowWithWidget(
                    icon: Icons.palette_outlined,
                    label: 'Theme',
                    trailing: ThemeSwitch(
                      isDark: _isDark,
                      onChanged: (value) {
                        setState(() => _isDark = value);
                      },
                    ),
                  ),
                  const _Divider(),


                  _SettingsRowWithWidget(
                    icon: Icons.translate,
                    label: 'Language',
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedLanguage,
                        hint: Text(
                          'Select',
                          style: GoogleFonts.rowdies(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            ),
                            ),
                            dropdownColor: AppColors.green,
                            borderRadius: BorderRadius.circular(16),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.green,
                              size: 22,
                              ),
                              selectedItemBuilder: (BuildContext context) {
                                return _languages.map((String language) {
                                  return Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      language,
                                      style: GoogleFonts.rowdies(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                                items: _languages.map((String language) {
                                  return DropdownMenuItem<String>(
                                    value: language,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      child: Text(
                                        language,
                                        style: GoogleFonts.rowdies(
                                          color: AppColors.darkBg,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              onChanged: (String? value) {
                                setState(() => _selectedLanguage = value);
                              },
                            ),
                          ),
                        ),
                        const _Divider(),

                  _SettingsRowWithWidget(
                    icon: Icons.notifications_none,
                    label: 'Notifications',
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() => _notificationsEnabled = value);
                      },
                      activeColor: AppColors.darkBg,
                      activeTrackColor: green,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.white24,
                    ),
                  ),
                  const _Divider(),

                  // Font Size label
                  _SettingsRow(
                    icon: null,
                    label: 'Font Size',
                    customLeading: Text(
                      'Aa',
                      style: GoogleFonts.rowdies(
                        color: AppColors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: null,
                  ),

                  // Slider estilo Apple
                  _FontSizeSlider(
                    value: _fontSize,
                    onChanged: (value) {
                      setState(() => _fontSize = value);
                    },
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Widgets reutilizables ────────────────────────────────────────────────────

class _FontSizeSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _FontSizeSlider({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(
            'A',
            style: GoogleFonts.rowdies(
              color: Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.white54,
                inactiveTrackColor: Colors.white24,
                thumbColor: Colors.white,
                overlayColor: Colors.white12,
                trackHeight: 3,
                thumbShape: const RoundedRectangleSliderThumbShape(),
              ),
              child: Slider(
                value: value,
                min: 0.0,
                max: 1.0,
                divisions: 7,
                onChanged: onChanged,
              ),
            ),
          ),
          Text(
            'A',
            style: GoogleFonts.rowdies(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedRectangleSliderThumbShape extends SliderComponentShape {
  const RoundedRectangleSliderThumbShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(28, 28);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 28, height: 28),
      const Radius.circular(8),
    );
    canvas.drawRRect(rrect, paint);
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Widget? customLeading;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.label,
    this.icon,
    this.customLeading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            _IconBox(icon: icon, customChild: customLeading),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.rowdies(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsRowWithWidget extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Widget trailing;

  const _SettingsRowWithWidget({
    required this.label,
    required this.trailing,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          _IconBox(icon: icon),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.rowdies(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

// Icono con borde verde redondeado
class _IconBox extends StatelessWidget {
  final IconData? icon;
  final Widget? customChild;

  const _IconBox({this.icon, this.customChild});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.green, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: customChild ??
            (icon != null
                ? Icon(icon, color: AppColors.green, size: 18)
                : const SizedBox.shrink()),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: Colors.white12, height: 1);
  }
}