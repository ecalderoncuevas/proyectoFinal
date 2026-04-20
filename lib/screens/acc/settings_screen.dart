import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final isDark = theme.isDark;
    final appGreen = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final appBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;
    final textColor = appGreen;
    final subtleColor = isDark ? Colors.white24 : Colors.black26;

    return Scaffold(
      backgroundColor: appBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: appGreen,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
                child: Text(
                  'Configuration',
                  style: GoogleFonts.rowdies(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: appBg,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const SizedBox(height: 16),
              Divider(color: subtleColor, height: 1),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _SettingsNavItem(
                        icon: Icons.person_outline,
                        label: 'Account',
                        textColor: textColor,
                        onTap: () {},
                      ),
                      const SizedBox(height: 4),
                      _SettingsNavItem(
                        icon: Icons.lock_outline,
                        label: 'Privacy',
                        textColor: textColor,
                        onTap: () {},
                      ),
                      const SizedBox(height: 4),
                      _SettingsRow(
                        icon: Icons.contrast,
                        label: 'Theme',
                        textColor: textColor,
                        trailing: _ThemeToggle(
                          isDark: isDark,
                          onChanged: (_) => theme.toggleTheme(),
                        ),
                      ),
                      const SizedBox(height: 4),
                      _SettingsRow(
                        icon: Icons.translate,
                        label: 'Language',
                        textColor: textColor,
                        trailing: _LanguageDropdown(
                          value: theme.language,
                          onChanged: theme.setLanguage,
                          bgColor: appGreen,
                          labelColor: appBg,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _SettingsRow(
                        icon: Icons.notifications_none,
                        label: 'Notifications',
                        textColor: textColor,
                        trailing: Switch(
                          value: _notificationsEnabled,
                          onChanged: (value) {
                            setState(() => _notificationsEnabled = value);
                          },
                          activeColor: AppColors.darkBg,
                          activeTrackColor: AppColors.green,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _SettingsRow(
                        icon: null,
                        customIcon: Text(
                          'Aa',
                          style: GoogleFonts.rowdies(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        label: 'Font Size',
                        textColor: textColor,
                        trailing: null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: textColor,
                            inactiveTrackColor: subtleColor,
                            thumbColor: textColor,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8,
                            ),
                            trackHeight: 2,
                            overlayColor: textColor.withOpacity(0.1),
                          ),
                          child: Slider(
                            value: theme.fontSize,
                            min: 12,
                            max: 24,
                            divisions: 6,
                            onChanged: (value) => theme.setFontSize(value),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
        ],
      ),
    );
  }
}

class _SettingsNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color textColor;
  final VoidCallback onTap;

  const _SettingsNavItem({
    required this.icon,
    required this.label,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.rowdies(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: textColor,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: textColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData? icon;
  final Widget? customIcon;
  final String label;
  final Color textColor;
  final Widget? trailing;

  const _SettingsRow({
    this.icon,
    this.customIcon,
    required this.label,
    required this.textColor,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          if (customIcon != null)
            customIcon!
          else if (icon != null)
            Icon(icon, color: textColor, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.rowdies(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: textColor,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _LanguageDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final Color bgColor;
  final Color labelColor;

  static const _languages = ['Español', 'Català', 'English'];

  const _LanguageDropdown({
    required this.value,
    required this.onChanged,
    required this.bgColor,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: false,
          dropdownColor: bgColor,
          borderRadius: BorderRadius.circular(12),
          icon: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: labelColor,
              size: 22,
            ),
          ),
          items: _languages.map((lang) {
            return DropdownMenuItem<String>(
              value: lang,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Text(
                  lang,
                  style: GoogleFonts.rowdies(
                    color: labelColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? lang) {
            if (lang != null) onChanged(lang);
          },
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const _ThemeToggle({
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isDark),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 100,
        height: 36,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isDark ? AppColors.green : AppColors.homeDarkGreen,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Light',
                    style: GoogleFonts.rowdies(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.green.withOpacity(0.5)
                          : Colors.white,
                    ),
                  ),
                  Text(
                    'Dark',
                    style: GoogleFonts.rowdies(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkBg
                          : AppColors.homeDarkGreen.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment:
                  isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 44,
                height: 30,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBg : AppColors.homeLightBg,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    isDark ? 'Dark' : 'Light',
                    style: GoogleFonts.rowdies(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.green
                          : AppColors.homeDarkGreen,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}