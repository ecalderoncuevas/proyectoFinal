import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_synquid/core/storage/token_storage.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/core/theme/theme_provider.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';
import 'package:proyecto_final_synquid/services/auth_service.dart';
import 'package:proyecto_final_synquid/widgets/back_app_bar.dart';
import 'package:proyecto_final_synquid/widgets/primary_button.dart';

// Pantalla de validación OTP de 6 dígitos; usada tanto para verificar email como para recuperar contraseña
// showRememberDevice controla si se muestra la opción "recordar dispositivo"
class ValidationScreen extends StatefulWidget {
  final String email;
  final bool showRememberDevice;
  final String title;
  final void Function(String code, bool rememberDevice) onValidate;

  const ValidationScreen({
    super.key,
    required this.email,
    required this.onValidate,
    this.showRememberDevice = false,
    this.title = 'verify_email',
  });

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  // Crea un controller y un FocusNode por cada una de las 6 casillas del OTP
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  late final AuthService _authService;
  bool _rememberDevice = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(ApiClient(), TokenStorage());
    WidgetsBinding.instance.addPostFrameCallback((_) => _sendCode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  // Concatena el contenido de las 6 casillas para obtener el código completo
  String get _code => _controllers.map((c) => c.text).join();

  Future<void> _sendCode() async {
    if (widget.email.isEmpty) {
      _showMessage('error_no_email'.tr(), isError: true);
      return;
    }
    setState(() => _isSending = true);
    try {
      final ok = await _authService.sendVerificationCode(widget.email);
      if (!mounted) return;
      _showMessage(
        ok
            ? 'code_sent'.tr(namedArgs: {'email': widget.email})
            : 'error_send_code'.tr(),
        isError: !ok,
      );
    } catch (e) {
      if (!mounted) return;
      _showMessage('error_send_code'.tr(), isError: true);
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _showMessage(String text, {required bool isError}) {
    final isDark = context.read<ThemeProvider>().isDark;
    final appGreen = isDark ? AppColors.green : AppColors.homeDarkGreen;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: isError ? Colors.redAccent : appGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final appGreen = isDark ? AppColors.green : AppColors.homeDarkGreen;
    final appBg = isDark ? AppColors.darkBg : AppColors.homeLightBg;

    return Scaffold(
      backgroundColor: appBg,
      appBar: const BackAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey.shade400,
              ),
              const SizedBox(height: 32),
              Text(
                widget.title.tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.rowdies(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: appGreen,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return _OtpBox(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    appGreen: appGreen,
                    appBg: appBg,
                    onChanged: (value) {
                      if (value.length == 1 && index < 5) {
                        _focusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: PrimaryButton(
                  label: 'send_again'.tr(),
                  isLoading: _isSending,
                  onPressed: _sendCode,
                  width: 160,
                  height: 42,
                  fontSize: 14,
                ),
              ),
              const Spacer(flex: 3),
              if (widget.showRememberDevice) ...[
                _RememberDeviceCheckbox(
                  value: _rememberDevice,
                  appGreen: appGreen,
                  appBg: appBg,
                  onChanged: (v) => setState(() => _rememberDevice = v),
                ),
                const SizedBox(height: 24),
              ],
              PrimaryButton(
                label: 'validate'.tr(),
                onPressed: () => widget.onValidate(_code, _rememberDevice),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// Casilla individual del código OTP: acepta solo un dígito y avanza el foco automáticamente
class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final Color appGreen;
  final Color appBg;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.appGreen,
    required this.appBg,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 58,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: GoogleFonts.rowdies(
          color: appBg,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: appGreen,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// Checkbox personalizado "Recordar este dispositivo" visible en el flujo de validación de dispositivo
class _RememberDeviceCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color appGreen;
  final Color appBg;

  const _RememberDeviceCheckbox({
    required this.value,
    required this.onChanged,
    required this.appGreen,
    required this.appBg,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: value ? appGreen : Colors.transparent,
              border: Border.all(color: appGreen, width: 1.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: value
                ? Icon(Icons.check, size: 14, color: appBg)
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'remember_device'.tr(),
          style: GoogleFonts.rowdies(
            fontSize: 13,
            color: appGreen,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
