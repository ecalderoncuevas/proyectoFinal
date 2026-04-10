import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final_synquid/core/theme/app_theme.dart';

class PantallaAccount extends StatelessWidget {
  const PantallaAccount({super.key});

  @override
  Widget build(BuildContext context) {
    const bgColor = AppColors.darkBg;
    const green = AppColors.green;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: double.infinity,
                color: green,
                child: SafeArea(
                  bottom: false,
                  child: const SizedBox(height: 60),
                ),
              ),
              Positioned(
                bottom: -50,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: bgColor,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 62),

          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Center(
                    child: Text(
                      'Nombre Persona',
                      style: GoogleFonts.rowdies(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: green,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  _InfoField(
                    label: 'Correo',
                    value: 'ceducalderon@gmail.com',
                  ),

                  const _Divider(),

                  _InfoFieldWithAction(
                    label: 'Password',
                    value: '····················',
                    actionIcon: Icons.key_outlined,
                    onActionTap: () {},
                  ),

                  const _Divider(),

                  const SizedBox(height: 8),

                  // Delete account
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Delete account',
                      style: GoogleFonts.rowdies(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Log out',
                style: GoogleFonts.rowdies(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: green,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class _InfoField extends StatelessWidget {
  final String label;
  final String value;

  const _InfoField({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.rowdies(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.rowdies(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: AppColors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoFieldWithAction extends StatelessWidget {
  final String label;
  final String value;
  final IconData actionIcon;
  final VoidCallback onActionTap;

  const _InfoFieldWithAction({
    required this.label,
    required this.value,
    required this.actionIcon,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.rowdies(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.rowdies(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onActionTap,
            child: Icon(
              actionIcon,
              color: Colors.white54,
              size: 22,
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
    return const Divider(color: Colors.white12, height: 1);
  }
}