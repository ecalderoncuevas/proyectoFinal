import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/widgets/primary_button.dart';
import 'package:proyecto_final_synquid/widgets/back_app_bar.dart';

class ValidationScreen extends StatefulWidget {
  
  final bool showRememberDevice;

  
  final String title;

  
  final void Function(String code, bool rememberDevice) onValidate;

  const ValidationScreen({
    super.key,
    required this.onValidate,
    this.showRememberDevice = false,
    this.title = 'Verify email',
  });

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _rememberDevice = false;

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

  String get _code => _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    const green = AppColors.green;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
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
                widget.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.rowdies(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return _OtpBox(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
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

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Send again',
                    style: GoogleFonts.rowdies(
                      fontSize: 13,
                      color: green,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 3),

              if (widget.showRememberDevice) ...[
                _RememberDeviceCheckbox(
                  value: _rememberDevice,
                  onChanged: (v) => setState(() => _rememberDevice = v),
                ),
                const SizedBox(height: 24),
              ],

              PrimaryButton(
                label: 'Validate',
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

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
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
          color: AppColors.darkBg,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.green,
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

class _RememberDeviceCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _RememberDeviceCheckbox({
    required this.value,
    required this.onChanged,
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
              color: value ? AppColors.green : Colors.transparent,
              border: Border.all(color: AppColors.green, width: 1.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: value
                ? const Icon(Icons.check, size: 14, color: AppColors.darkBg)
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Remember this device',
          style: GoogleFonts.rowdies(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}