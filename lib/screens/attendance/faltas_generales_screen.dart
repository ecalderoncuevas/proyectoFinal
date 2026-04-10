import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';

class PantallaFaltasGenerales extends StatelessWidget {
  const PantallaFaltasGenerales({super.key});

  @override
  Widget build(BuildContext context) {
    const bgColor = AppColors.homeLightBg;
    const darkGreen = AppColors.homeDarkGreen;
    const blockGreen = Color(0xFF385144); 

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: double.infinity,
            color: darkGreen,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
        
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.homeLightBg,
                            size: 48,
                          ),
                        ),
                        _HamburgerMenu(),
                      ],
                    ),

                    const SizedBox(height: 50),

 
                    Text(
                      'Faltas',
                      style: GoogleFonts.rowdies(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: AppColors.homeLightBg,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Ver leyenda',
                style: GoogleFonts.rowdies(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: darkGreen,
                  ),
                ),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: blockGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Align(
                  alignment: Alignment.centerLeft, 
                  child: Text(
                    'Interfaces',
                    style: GoogleFonts.rowdies(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.homeLightBg,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


class _HamburgerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _MenuLine(width: 24),
          SizedBox(height: 5),
          _MenuLine(width: 24),
          SizedBox(height: 5),
          _MenuLine(width: 24),
        ],
      ),
      color: AppColors.homeDarkGreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      offset: const Offset(0, 48),
      itemBuilder: (context) => [
        _buildMenuItem('Perfil'),
        _buildMenuItem('Configuración'),
        _buildMenuItem('Cerrar sesión'),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(String label) {
    return PopupMenuItem<String>(
      value: label,
      child: Text(
        label,
        style: GoogleFonts.rowdies(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: AppColors.homeLightBg,
        ),
      ),
    );
  }
}

class _MenuLine extends StatelessWidget {
  final double width;
  const _MenuLine({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 2.5,
      decoration: BoxDecoration(
        color: AppColors.homeLightBg,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}