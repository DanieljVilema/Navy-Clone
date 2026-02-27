import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navy_pfa_armada_ecuador/core/constants/constants.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(Spacing.m),
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.m),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(Radii.m),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recursos Sin Conexión',
                    style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.darkTextPrimary, letterSpacing: -0.3)),
                const SizedBox(height: Spacing.s),
                Text('Descarga materiales para utilizarlos cuando no tengas acceso a internet.',
                    style: GoogleFonts.inter(fontSize: 14, color: AppColors.darkTextSecondary, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: Spacing.m),
          _buildDownloadItem('Manual Completo PFA', '15MB - PDF', Icons.picture_as_pdf, AppColors.danger),
          const SizedBox(height: Spacing.s),
          _buildDownloadItem('Paquete de Videos de Pruebas', '250MB - MP4', Icons.video_library, AppColors.primary),
          const SizedBox(height: Spacing.s),
          _buildDownloadItem('Tabla de Baremos Oficial', '2MB - PDF', Icons.table_chart, AppColors.success),
          const SizedBox(height: Spacing.xl),
        ],
      ),
    );
  }

  Widget _buildDownloadItem(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(Spacing.m),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(Radii.m),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(Radii.m),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: Spacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppColors.darkTextSecondary)),
              ],
            ),
          ),
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(Radii.s),
            ),
            child: const Icon(Icons.download, size: 18, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
