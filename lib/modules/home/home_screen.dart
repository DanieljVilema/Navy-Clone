import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import '../simulator/simulator_screen.dart';
import '../training/training_screen.dart';
import '../services/services_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NavyPFAApp.navyPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ── HEADER con escudo/logo ──
              _buildHeader(context),
              const SizedBox(height: 8),
              // ── QUICK ACTIONS GRID ──
              _buildQuickActions(context),
              const SizedBox(height: 20),
              // ── SECCIÓN DE NOTICIAS / INFORMACIÓN ──
              _buildInfoSection(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            NavyPFAApp.navyDark,
            NavyPFAApp.navyPrimary,
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Escudo / Logo
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: NavyPFAApp.goldAccent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: NavyPFAApp.goldAccent.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
              color: NavyPFAApp.navyDark,
            ),
            child: const Icon(
              Icons.anchor_rounded,
              size: 50,
              color: Color(0xFFC5A44E),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'NAVY PFA',
            style: GoogleFonts.roboto(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ARMADA DEL ECUADOR',
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: NavyPFAApp.goldAccent,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 60,
            height: 2,
            decoration: BoxDecoration(
              color: NavyPFAApp.goldAccent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Physical Fitness Assessment',
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Colors.white60,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: NavyPFAApp.goldAccent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'ACCESO RÁPIDO',
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.15,
            children: [
              _QuickActionCard(
                icon: Icons.calculate_rounded,
                title: 'Calculadora\nPFA',
                subtitle: 'Simular puntaje',
                gradientColors: [
                  const Color(0xFF1A3A7A),
                  const Color(0xFF0D2555),
                ],
                accentColor: const Color(0xFF4A9FFF),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SimulatorScreen()),
                ),
              ),
              _QuickActionCard(
                icon: Icons.monitor_weight_rounded,
                title: 'Composición\nCorporal',
                subtitle: 'BCA Calculator',
                gradientColors: [
                  const Color(0xFF2A4A2A),
                  const Color(0xFF1A3A1A),
                ],
                accentColor: const Color(0xFF66BB6A),
                onTap: () {
                  // BCA screen placeholder
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('BCA Calculator - Próximamente'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              _QuickActionCard(
                icon: Icons.fitness_center_rounded,
                title: 'Entrenamientos\nNOFFS',
                subtitle: '75+ rutinas',
                gradientColors: [
                  const Color(0xFF4A2A1A),
                  const Color(0xFF3A1A0A),
                ],
                accentColor: const Color(0xFFFF7043),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TrainingScreen()),
                ),
              ),
              _QuickActionCard(
                icon: Icons.restaurant_menu_rounded,
                title: 'Nutrición\ny Salud',
                subtitle: 'Guía alimentaria',
                gradientColors: [
                  const Color(0xFF2A2A4A),
                  const Color(0xFF1A1A3A),
                ],
                accentColor: const Color(0xFFAB47BC),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nutrición - Próximamente'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Banner informativo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  NavyPFAApp.goldAccent.withOpacity(0.15),
                  NavyPFAApp.goldAccent.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: NavyPFAApp.goldAccent.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: NavyPFAApp.goldAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: NavyPFAApp.goldAccent,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Programa de Preparación Física',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Consulta los baremos actualizados y prepárate para tu próxima evaluación PFA.',
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: Colors.white60,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Row de stats rápidos
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.play_circle_outline_rounded,
                  value: 'Videos',
                  label: 'Tutoriales',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.menu_book_outlined,
                  value: 'Guías',
                  label: 'Reglamentos',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.smart_toy_outlined,
                  value: 'I.A.',
                  label: 'Consultas',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── TARJETA DE ACCIÓN RÁPIDA ──
class _QuickActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final Color accentColor;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.gradientColors,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.accentColor.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors[0].withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.accentColor,
                  size: 28,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: GoogleFonts.roboto(
                      fontSize: 10,
                      color: Colors.white38,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── TARJETA DE ESTADÍSTICAS ──
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: NavyPFAApp.goldAccent,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 10,
              color: Colors.white38,
            ),
          ),
        ],
      ),
    );
  }
}