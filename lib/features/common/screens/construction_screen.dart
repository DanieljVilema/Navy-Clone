import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navy_pfa_armada_ecuador/core/constants/constants.dart';

class ConstructionScreen extends StatelessWidget {
  final String title;
  const ConstructionScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: AppColors.darkCardSec,
                borderRadius: BorderRadius.circular(Radii.full),
              ),
              child: const Icon(Icons.construction, size: 36, color: AppColors.darkTextTertiary),
            ),
            const SizedBox(height: Spacing.m),
            Text(title, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary)),
            const SizedBox(height: Spacing.s),
            SizedBox(
              width: 280,
              child: Text('Esta sección está en desarrollo.', textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.darkTextSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}
