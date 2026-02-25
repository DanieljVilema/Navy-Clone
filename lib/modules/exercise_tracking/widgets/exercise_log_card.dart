import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants.dart';
import '../../../models/exercise_log.dart';

class ExerciseLogCard extends StatelessWidget {
  final ExerciseLog log;
  final VoidCallback? onDelete;
  final double? score; // 0–100, null = no badge shown

  const ExerciseLogCard({
    super.key,
    required this.log,
    this.onDelete,
    this.score,
  });

  IconData _getIcon() {
    switch (log.exerciseType?.icono) {
      case 'fitness_center':
        return Icons.fitness_center;
      case 'accessibility_new':
        return Icons.accessibility_new;
      case 'iron':
        return Icons.hardware;
      case 'sports_gymnastics':
        return Icons.sports_gymnastics;
      case 'directions_run':
        return Icons.directions_run;
      case 'pool':
        return Icons.pool;
      default:
        return Icons.fitness_center;
    }
  }

  Color _getCategoryColor() {
    switch (log.exerciseType?.categoria) {
      case 'fuerza_superior':
        return AppColors.primary;
      case 'fuerza_core':
        return AppColors.warning;
      case 'cardio':
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  String _levelLabel(double s) {
    if (s >= 90) return 'Sobresaliente';
    if (s >= 75) return 'Bueno';
    if (s >= 60) return 'Satisfactorio';
    if (s >= 45) return 'Regular';
    return 'Fallo';
  }

  Color _scoreColor(double s) {
    if (s >= 90) return AppColors.success;
    if (s >= 75) return AppColors.primary;
    if (s >= 60) return AppColors.warning;
    if (s >= 45) return const Color(0xFFFF9800);
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor();

    return Dismissible(
      key: Key('log_${log.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Spacing.m),
        decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(Radii.m),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Container(
        padding: const EdgeInsets.all(Spacing.s),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(Radii.m),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(Radii.s),
              ),
              child: Icon(_getIcon(), size: 20, color: color),
            ),
            const SizedBox(width: Spacing.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    log.exerciseType?.nombre ?? 'Ejercicio',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        log.displayValue,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.darkTextSecondary,
                        ),
                      ),
                      if (log.displayDuration != null &&
                          log.exerciseType?.isDistanceBased == true) ...[
                        const SizedBox(width: Spacing.s),
                        Text(
                          log.displayDuration!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.darkTextTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // ── SCORE BADGE ──
            if (score != null) ...[
              const SizedBox(width: Spacing.s),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _scoreColor(score!).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(Radii.s),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${score!.toStringAsFixed(0)} pts',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _scoreColor(score!),
                      ),
                    ),
                    Text(
                      _levelLabel(score!),
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        color: _scoreColor(score!),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // ── HEART RATE BADGE ──
            if (log.frecuenciaCardiaca != null) ...[
              const SizedBox(width: Spacing.xs),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(Radii.s),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite, size: 12, color: AppColors.danger),
                    const SizedBox(width: 4),
                    Text(
                      '${log.frecuenciaCardiaca}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
