import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NavyPFAApp.navyPrimary,
      appBar: AppBar(
        backgroundColor: NavyPFAApp.navyDark,
        title: Text(
          'ENTRENAMIENTOS',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── HERO SECTION ──
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF4A2A1A),
                      const Color(0xFF3A1A0A),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFFF7043).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7043).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.fitness_center_rounded,
                        color: Color(0xFFFF7043),
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NOFFS Workout Library',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Naval Operational Fitness and Fueling Series - 75+ rutinas aprobadas',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.white54,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── CATEGORÍAS ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
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
                      'CATEGORÍAS',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: NavyPFAApp.goldAccent,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── WORKOUT CATEGORIES ──
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _WorkoutCategoryTile(
                    icon: Icons.directions_run_rounded,
                    title: 'Command PT - Resistencia',
                    workoutCount: '15 rutinas',
                    color: const Color(0xFF4A9FFF),
                    exercises: [
                      'Trote continuo 30 min',
                      'Intervalos 400m x 8',
                      'Fartlek 40 min',
                      'Carrera progresiva',
                    ],
                  ),
                  _WorkoutCategoryTile(
                    icon: Icons.accessibility_new_rounded,
                    title: 'FEP - Fuerza Superior',
                    workoutCount: '12 rutinas',
                    color: const Color(0xFFEF5350),
                    exercises: [
                      'Push-ups progresivos',
                      'Flexiones diamante',
                      'Plancha militar',
                      'Dips en paralelas',
                    ],
                  ),
                  _WorkoutCategoryTile(
                    icon: Icons.self_improvement_rounded,
                    title: 'Core & Abdominales',
                    workoutCount: '10 rutinas',
                    color: const Color(0xFF66BB6A),
                    exercises: [
                      'Curl-ups estándar',
                      'Plancha frontal',
                      'Mountain climbers',
                      'Russian twists',
                    ],
                  ),
                  _WorkoutCategoryTile(
                    icon: Icons.pool_rounded,
                    title: 'Natación & Cardio',
                    workoutCount: '8 rutinas',
                    color: const Color(0xFF26C6DA),
                    exercises: [
                      'Natación 450m técnica',
                      'Intervalos en piscina',
                      'Resistencia acuática',
                      'Cardio combinado',
                    ],
                  ),
                  _WorkoutCategoryTile(
                    icon: Icons.sports_gymnastics_rounded,
                    title: 'Flexibilidad & Movilidad',
                    workoutCount: '8 rutinas',
                    color: const Color(0xFFAB47BC),
                    exercises: [
                      'Estiramiento dinámico',
                      'Yoga militar',
                      'Movilidad articular',
                      'Cool-down completo',
                    ],
                  ),
                  _WorkoutCategoryTile(
                    icon: Icons.pedal_bike_rounded,
                    title: 'Bicicleta & Remo',
                    workoutCount: '6 rutinas',
                    color: const Color(0xFFFFA726),
                    exercises: [
                      'Bicicleta 12 min test',
                      'Remo 2000m preparación',
                      'Intervalos en bici',
                      'Resistencia cardio alt.',
                    ],
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutCategoryTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String workoutCount;
  final Color color;
  final List<String> exercises;

  const _WorkoutCategoryTile({
    required this.icon,
    required this.title,
    required this.workoutCount,
    required this.color,
    required this.exercises,
  });

  @override
  State<_WorkoutCategoryTile> createState() => _WorkoutCategoryTileState();
}

class _WorkoutCategoryTileState extends State<_WorkoutCategoryTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isExpanded
              ? widget.color.withOpacity(0.3)
              : Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.color,
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
                          widget.workoutCount,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: widget.color.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded exercises
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  Container(
                    height: 1,
                    color: Colors.white.withOpacity(0.06),
                  ),
                  const SizedBox(height: 12),
                  ...widget.exercises.map((exercise) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: widget.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              exercise,
                              style: GoogleFonts.roboto(
                                fontSize: 13,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}