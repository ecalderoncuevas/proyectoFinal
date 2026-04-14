import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';
import 'package:proyecto_final_synquid/models/institution.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';
import 'package:proyecto_final_synquid/services/institution_service.dart';
import 'package:proyecto_final_synquid/widgets/primary_button.dart';
import 'package:proyecto_final_synquid/widgets/back_app_bar.dart';

class SelectInstitutionScreen extends StatefulWidget {
  final IconData icon;
  final String title;
  final void Function(Institution institution) onContinue;

  const SelectInstitutionScreen({
    super.key,
    required this.icon,
    required this.onContinue,
    this.title = 'Select your\ninstitution',
  });

  @override
  State<SelectInstitutionScreen> createState() =>
      _SelectInstitutionScreenState();
}

class _SelectInstitutionScreenState extends State<SelectInstitutionScreen> {
  late final InstitutionService _service;
  late Future<List<Institution>> _institutionsFuture;
  Institution? _selectedInstitution;

  @override
  void initState() {
    super.initState();
    _service = InstitutionService(ApiClient());
    _institutionsFuture = _service.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: const BackAppBar(), 
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              FaIcon(widget.icon, size: 90, color: Colors.white),
              const SizedBox(height: 32),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.rowdies(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              FutureBuilder<List<Institution>>(
                future: _institutionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      color: AppColors.green,
                    );
                  }
                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.rowdies(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  final institutions = snapshot.data ?? [];
                  return _buildDropdown(institutions);
                },
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Continue',
                onPressed: _selectedInstitution == null
                    ? null
                    : () => widget.onContinue(_selectedInstitution!),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(List<Institution> institutions) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Institution>(
          value: _selectedInstitution,
          hint: const SizedBox.shrink(),
          isExpanded: true,
          dropdownColor: AppColors.green,
          borderRadius: BorderRadius.circular(16),
          icon: const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.darkBg,
              size: 28,
            ),
          ),
          items: institutions.map((institution) {
            return DropdownMenuItem<Institution>(
              value: institution,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  institution.name,
                  style: GoogleFonts.rowdies(
                    color: AppColors.darkBg,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (Institution? value) {
            setState(() {
              _selectedInstitution = value;
            });
          },
        ),
      ),
    );
  }
}