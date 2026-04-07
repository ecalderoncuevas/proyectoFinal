import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class _SubjectItem {
  final String name;
  final String date;
  final Color tagColor;

  const _SubjectItem({
    required this.name,
    required this.date,
    required this.tagColor,
  });
}


class PantallaHomeEstudiante extends StatelessWidget {
  const PantallaHomeEstudiante({super.key});

  static const _subjects = [
    _SubjectItem(name: 'Interfaces', date: '10-05', tagColor: AppColors.tagGreen),
    _SubjectItem(name: 'Interfaces', date: '10-05', tagColor: AppColors.tagYellow),
    _SubjectItem(name: 'Interfaces', date: '10-05', tagColor: AppColors.tagRed),
    _SubjectItem(name: 'Interfaces', date: '10-05', tagColor: AppColors.tagGreen),
    _SubjectItem(name: 'Interfaces', date: '10-05', tagColor: AppColors.tagYellow),
    _SubjectItem(name: 'Interfaces', date: '10-05', tagColor: AppColors.tagRed),
  ];

  @override
  Widget build(BuildContext context) {
    const bgColor   = AppColors.homeLightBg;
    const darkGreen = AppColors.homeDarkGreen;

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
                        const Icon(
                          Icons.credit_card_outlined,
                          color: AppColors.homeLightBg,
                          size: 48,
                        ),
                        _HamburgerMenu(),
                      ],
                    ),

                    const SizedBox(height: 28),

                    Text(
                      'Good Morning,\nname',
                      style: GoogleFonts.rowdies(
                        fontSize: 40,
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

 
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

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

                  const SizedBox(height: 12),

                  ..._subjects.map(
                    (subject) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _SubjectCard(item: subject),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
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

class _SubjectCard extends StatelessWidget {
  final _SubjectItem item;

  const _SubjectCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
      
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.rowdies(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.homeDarkGreen,
                  ),
                ),
                Text(
                  item.date,
                  style: GoogleFonts.rowdies(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.homeDarkGreen,
                  ),
                ),
              ],
            ),
          ),

    
          Container(
            decoration: BoxDecoration(
              color: AppColors.homeDarkGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: item.tagColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'ver faltas  →',
                    style: GoogleFonts.rowdies(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: AppColors.homeLightBg,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: Colors.black12, height: 1);
  }
}