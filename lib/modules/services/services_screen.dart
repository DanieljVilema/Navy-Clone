import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import '../simulator/simulator_screen.dart';
import '../training/training_screen.dart';
import '../performance/performance_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NavyPFAApp.navyPrimary,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── HEADER ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: NavyPFAApp.goldAccent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.grid_view_rounded,
                            color: NavyPFAApp.goldAccent,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'RECURSOS',
                              style: GoogleFonts.roboto(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 3,
                              ),
                            ),
                            Text(
                              'Programa de Preparación Física',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: Colors.white38,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 1,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ],
                ),
              ),
            ),

            // ── PROGRAM APPLICATION RESOURCES ──
            SliverToBoxAdapter(
              child: _buildSectionHeader('APLICACIÓN DEL PROGRAMA'),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _ResourceTile(
                      icon: Icons.calculate_rounded,
                      title: 'Calculadora PFA',
                      subtitle: 'Calcula tu puntaje de evaluación física',
                      accentColor: const Color(0xFF4A9FFF),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SimulatorScreen()),
                      ),
                    ),
                    _ResourceTile(
                      icon: Icons.monitor_weight_rounded,
                      title: 'BCA - Composición Corporal',
                      subtitle: 'Evaluación de índice de masa corporal',
                      accentColor: const Color(0xFF66BB6A),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SimulatorScreen()),
                      ),
                    ),
                    _ResourceTile(
                      icon: Icons.play_circle_filled_rounded,
                      title: 'Video Library',
                      subtitle: 'Videos instructivos para mediciones BCA y PRT',
                      accentColor: const Color(0xFFFF7043),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const TrainingScreen()),
                      ),
                    ),
                    _ResourceTile(
                      icon: Icons.menu_book_rounded,
                      title: 'Guías Operativas',
                      subtitle: 'Instrucciones basadas en directivas oficiales',
                      accentColor: const Color(0xFFAB47BC),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Guías Operativas - Próximamente'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ── NUTRITION RESOURCES ──
            SliverToBoxAdapter(
              child: _buildSectionHeader('NUTRICIÓN'),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _ResourceTile(
                      icon: Icons.restaurant_menu_rounded,
                      title: 'Guía Nutricional',
                      subtitle: 'Plan alimentario y recomendaciones',
                      accentColor: const Color(0xFF26C6DA),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nutrición - Próximamente'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    _ResourceTile(
                      icon: Icons.food_bank_rounded,
                      title: 'Constructor de Comidas',
                      subtitle: 'Virtual Meal Builder - NOFFS',
                      accentColor: const Color(0xFFFFA726),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Meal Builder - Próximamente'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ── WORKOUTS ──
            SliverToBoxAdapter(
              child: _buildSectionHeader('ENTRENAMIENTOS'),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  children: [
                    _ResourceTile(
                      icon: Icons.fitness_center_rounded,
                      title: 'Rutinas de Entrenamiento',
                      subtitle: '75+ rutinas aprobadas Command PT y FEP',
                      accentColor: const Color(0xFFEF5350),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const TrainingScreen()),
                      ),
                    ),
                    _ResourceTile(
                      icon: Icons.smart_toy_rounded,
                      title: 'Asistente I.A.',
                      subtitle: 'Consultas inteligentes sobre tu preparación',
                      accentColor: const Color(0xFF7C4DFF),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Chatbot I.A. - Próximamente'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    _ResourceTile(
                      icon: Icons.bar_chart_rounded,
                      title: 'Mi Rendimiento',
                      subtitle: 'Historial y progreso de evaluaciones',
                      accentColor: const Color(0xFF42A5F5),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PerformanceScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: NavyPFAApp.goldAccent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: NavyPFAApp.goldAccent,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  const _ResourceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_ResourceTile> createState() => _ResourceTileState();
}

class _ResourceTileState extends State<_ResourceTile> {
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
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.accentColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.2),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
