import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navy_pfa_armada_ecuador/core/constants/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.m),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: Spacing.xl),
            _buildLogo(),
            const SizedBox(height: Spacing.xl),
            _buildWelcomeCard(),
            const SizedBox(height: Spacing.m),
            _buildQuickActions(),
            const SizedBox(height: Spacing.l),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(Radii.l),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: const Icon(Icons.anchor_rounded, color: Colors.white, size: 40),
        ),
        const SizedBox(height: Spacing.m),
        Text(
          'ArmadaFit',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.darkTextPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          'Evaluación Física • Armada del Ecuador',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.m),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(Radii.m),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(Radii.m),
                ),
                child: const Icon(Icons.info_outline, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: Spacing.m),
              Expanded(
                child: Text(
                  'Bienvenido',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkTextPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.m),
          Text(
            'Esta aplicación proporciona una herramienta integral para toda la información '
            'del Programa de Evaluación Física de la Armada del Ecuador.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.darkTextSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: Spacing.s),
          Text(
            'Utilice el menú lateral izquierdo para navegar a través de las diferentes secciones.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.darkTextTertiary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Simulador', Icons.calculate_outlined, AppColors.primary)),
        const SizedBox(width: Spacing.s),
        Expanded(child: _buildStatCard('I.A.', Icons.chat_bubble_outline, AppColors.success)),
        const SizedBox(width: Spacing.s),
        Expanded(child: _buildStatCard('Videos', Icons.play_circle_outline, AppColors.warning)),
      ],
    );
  }

  Widget _buildStatCard(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(Spacing.m),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(Radii.m),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(Radii.m),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: Spacing.s),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}