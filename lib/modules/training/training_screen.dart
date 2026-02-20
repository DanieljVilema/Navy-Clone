import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/content_provider.dart';
import '../../core/constants.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          // ── HEADER BANNER ──
          Container(
            padding: const EdgeInsets.all(Spacing.m),
            color: AppColors.darkCard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Biblioteca de Entrenamiento NOFFS',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkTextPrimary,
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
          ...context.watch<ContentProvider>().training.map((t) => _WorkoutExpandableCategory(
                title: t.titulo,
                workoutCount: t.cantidadRutinas,
                exercises: t.ejercicios,
              )).toList(),

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
                          color: AppColors.navyPrimary,
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