import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          // ── HEADER BANNER ──
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.grey.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Biblioteca de Entrenamiento NOFFS',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Serie de Acondicionamiento Físico Operacional Naval - Seleccione una categoría de entrenamiento a continuación.',
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),

          // ── WORKOUT CATEGORIES ──
          const _WorkoutExpandableCategory(
            title: 'Entrenamiento de Comando - Resistencia',
            workoutCount: '15 rutinas',
            exercises: [
              'Carrera Continua 30 min',
              'Intervalos 400m x 8',
              'Carrera Fartlek 40 min',
              'Carrera Progresiva',
              'Carrera Tempo 25 min',
            ],
          ),
          const _WorkoutExpandableCategory(
            title: 'FEP - Fuerza Tren Superior',
            workoutCount: '12 rutinas',
            exercises: [
              'Flexiones Progresivas',
              'Flexiones Diamante',
              'Plancha Militar',
              'Fondos en Barras Paralelas',
              'Flexiones Brazos Abiertos',
            ],
          ),
          const _WorkoutExpandableCategory(
            title: 'Core y Abdominales',
            workoutCount: '10 rutinas',
            exercises: [
              'Abdominales Estándar',
              'Sostener Plancha Frontal',
              'Escalada de Montaña',
              'Giros Rusos',
              'Abdominales Bicicleta',
            ],
          ),
          const _WorkoutExpandableCategory(
            title: 'Natación y Cardio',
            workoutCount: '8 rutinas',
            exercises: [
              'Técnica de Nado 450m',
              'Intervalos en Piscina',
              'Resistencia Acuática',
              'Cardio Combinado',
            ],
          ),
          const _WorkoutExpandableCategory(
            title: 'Flexibilidad y Movilidad',
            workoutCount: '8 rutinas',
            exercises: [
              'Estiramiento Dinámico',
              'Yoga Militar',
              'Movilidad Articular',
              'Vuelta a la Calma Completa',
            ],
          ),
          const _WorkoutExpandableCategory(
            title: 'Ciclismo y Remo',
            workoutCount: '6 rutinas',
            exercises: [
              'Prueba de Bici 12 min',
              'Preparación Remo 2000m',
              'Intervalos en Bici',
              'Resistencia Cardio Alt.',
            ],
          ),
          const _WorkoutExpandableCategory(
            title: 'Entrenamiento Cuerpo Completo',
            workoutCount: '10 rutinas',
            exercises: [
              'Circuito Cuerpo Total',
              'Resistencia de Fuerza',
              'Acondicionamiento de Combate',
              'Fitness Funcional',
            ],
          ),
          const _WorkoutExpandableCategory(
            title: 'Preparación Pre-Evaluación',
            workoutCount: '6 rutinas',
            exercises: [
              'Simulacro de Evaluación',
              'Entrenamiento Específico',
              'Protocolo Semana Pico',
              'Rutina de Recuperación',
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _WorkoutExpandableCategory extends StatefulWidget {
  final String title;
  final String workoutCount;
  final List<String> exercises;

  const _WorkoutExpandableCategory({
    required this.title,
    required this.workoutCount,
    required this.exercises,
  });

  @override
  State<_WorkoutExpandableCategory> createState() =>
      _WorkoutExpandableCategoryState();
}

class _WorkoutExpandableCategoryState
    extends State<_WorkoutExpandableCategory> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.white,
          child: InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.workoutCount,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.chevron_right,
                      size: 22,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            width: double.infinity,
            color: Colors.grey.shade50,
            padding: const EdgeInsets.fromLTRB(36, 4, 20, 12),
            child: Column(
              children: widget.exercises.map((exercise) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: NavyPFAApp.navyPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          exercise,
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }
}