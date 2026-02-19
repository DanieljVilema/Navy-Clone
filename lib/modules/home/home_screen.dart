import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),

            // ── NAVY PFA LOGO ──
            _buildLogo(),
            const SizedBox(height: 28),

            // ── WELCOME TEXT ──
            _buildWelcomeText(),
            const SizedBox(height: 32),

          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        // Star logo with CULTURE AND FORCE RESILIENCE text
        SizedBox(
          width: 180,
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Star background
              Icon(
                Icons.star,
                size: 140,
                color: NavyPFAApp.goldAccent,
              ),
              // Anchor in center
              const Icon(
                Icons.anchor_rounded,
                size: 50,
                color: Color(0xFF001F5B),
              ),
              // Top text
              Positioned(
                top: 12,
                child: Text(
                  'CULTURA Y',
                  style: GoogleFonts.roboto(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: NavyPFAApp.navyPrimary,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              // Bottom text
              Positioned(
                bottom: 12,
                child: Text(
                  'RESILIENCIA NAVAL',
                  style: GoogleFonts.roboto(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: NavyPFAApp.navyPrimary,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ARMADA',
                style: GoogleFonts.roboto(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: NavyPFAApp.navyPrimary,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: NavyPFAApp.navyPrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'ECUADOR',
                  style: GoogleFonts.roboto(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenido a la Aplicación Oficial de Evaluación Física de la Armada del Ecuador',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.black54,
                height: 1.6,
              ),
              children: const [
                TextSpan(
                  text:
                      'Esta aplicación proporciona una herramienta integral para toda la información del Programa de Evaluación Física de la Armada del Ecuador.\n\nUtilice el menú lateral izquierdo para navegar a través de las diferentes secciones.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}