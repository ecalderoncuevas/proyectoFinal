import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';

class SelectInstitucionEstudiante extends StatefulWidget {
  const SelectInstitucionEstudiante({super.key});

  @override
  State<SelectInstitucionEstudiante> createState() =>
    _SelectInstitucionEstudianteState();
}
  
  class _SelectInstitucionEstudianteState
        extends State<SelectInstitucionEstudiante> {
    String? _selectedInstitution;

    final List<String> _institutions = [
      'IES Example',
      'Escola Sagrada Familia',
      'IFP',
      'Salesians De Sarria',
    ];

    @override
    Widget build(BuildContext context) {
      const bgColor = AppColors.darkBg;
      const green = AppColors.green;
      
      return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const Icon(
                  Icons.school_rounded,
                  size: 90,
                  color: Colors.white,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Select your\ninstitution',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rowdies(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      decoration: BoxDecoration(
                        color: green,
                        borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedInstitution,
                            hint: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              child: Text(
                                'Selecciona un centro',
                                style: GoogleFonts.rowdies(
                                  color: AppColors.darkBg,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  ),
                                )
                              ),
                              isExpanded: true,
                              dropdownColor: green,
                              borderRadius: BorderRadius.circular(16),
                              icon: const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.darkBg,
                                  size: 28,
                                ),
                              ),
                              items: _institutions.map((String institution) {
                                return DropdownMenuItem<String>(
                                  value: institution,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Text(
                                      institution,
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
                                setState(() {
                                  _selectedInstitution = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          const Spacer(flex: 3),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }