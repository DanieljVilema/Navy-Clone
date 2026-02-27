import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:navy_pfa_armada_ecuador/core/constants/constants.dart';
import 'package:navy_pfa_armada_ecuador/features/exercise_tracking/providers/exercise_log_provider.dart';
import 'package:navy_pfa_armada_ecuador/shared/services/baremo_goals_service.dart';

class EvaluationSimulatorTab extends StatefulWidget {
  const EvaluationSimulatorTab({super.key});

  @override
  State<EvaluationSimulatorTab> createState() => _EvaluationSimulatorTabState();
}

class _EvaluationSimulatorTabState extends State<EvaluationSimulatorTab> {
  final BaremoGoalsService _goalsService = BaremoGoalsService();
  List<TablaInfo> _tablas = [];
  String _selectedTabla = 'tabla_1';
  String _selectedGenero = 'hombres';
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadTablas();
  }

  Future<void> _loadTablas() async {
    await _goalsService.load();
    if (!mounted) return;
    setState(() {
      _tablas = _goalsService.getTablaList();
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return Consumer<ExerciseLogProvider>(
      builder: (context, provider, _) {
        final goals = _goalsService.getGoals(_selectedTabla, _selectedGenero);
        final maxPoints = _goalsService.getMaxPoints(_selectedTabla);
        final latestLogs = provider.getLatestByExerciseType();

        // Calculate scores
        double totalPoints = 0;
        final exerciseResults = <_ExerciseResult>[];

        for (final goal in goals) {
          final log = latestLogs[goal.ejercicioClave];
          double? currentValue;
          DateTime? logDate;
          double earnedPoints = 0;
          double percentage = 0;

          if (log != null) {
            logDate = log.fecha;
            if (goal.isTimeBased) {
              currentValue = (log.duracionSegundos ?? 0).toDouble();
              if (currentValue > 0) {
                // For time-based: lower is better
                // If on or under meta → full points
                // If over meta → proportional decrease
                if (currentValue <= goal.meta) {
                  earnedPoints = goal.puntos.toDouble();
                  percentage = 100;
                } else {
                  // Linear decrease: at 2x the meta time = 0 points
                  final ratio = 1 - ((currentValue - goal.meta) / goal.meta);
                  earnedPoints = (ratio * goal.puntos).clamp(0, goal.puntos.toDouble());
                  percentage = (earnedPoints / goal.puntos * 100).clamp(0, 100);
                }
              }
            } else {
              currentValue = (log.repeticiones ?? 0).toDouble();
              if (currentValue > 0) {
                // For reps: higher is better
                if (currentValue >= goal.meta) {
                  earnedPoints = goal.puntos.toDouble();
                  percentage = 100;
                } else {
                  earnedPoints = (currentValue / goal.meta * goal.puntos)
                      .clamp(0, goal.puntos.toDouble());
                  percentage = (currentValue / goal.meta * 100).clamp(0, 100);
                }
              }
            }
            totalPoints += earnedPoints;
          }

          exerciseResults.add(_ExerciseResult(
            goal: goal,
            currentValue: currentValue,
            logDate: logDate,
            earnedPoints: earnedPoints,
            percentage: percentage,
          ));
        }

        final overallPercentage = maxPoints > 0 ? (totalPoints / maxPoints * 100) : 0.0;
        final nivel = _getLevelLabel(overallPercentage);
        final nivelColor = _getLevelColor(overallPercentage);

        return ListView(
          padding: const EdgeInsets.all(Spacing.m),
          children: [
            // ── TABLE & GENDER SELECTOR ──
            _buildSelectors(),
            const SizedBox(height: Spacing.m),

            // ── SCORE OVERVIEW CARD ──
            _buildScoreOverview(totalPoints, maxPoints, overallPercentage, nivel, nivelColor),
            const SizedBox(height: Spacing.m),

            // ── EXERCISE PROGRESS CARDS ──
            ...exerciseResults.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: Spacing.s),
              child: _buildExerciseCard(r),
            )),

            // ── ADVICE CARD ──
            const SizedBox(height: Spacing.s),
            _buildAdviceCard(exerciseResults, overallPercentage),
            const SizedBox(height: Spacing.l),
          ],
        );
      },
    );
  }

  Widget _buildSelectors() {
    return Container(
      padding: const EdgeInsets.all(Spacing.m),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(Radii.m),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configuración de Evaluación',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: Spacing.s),
          Row(
            children: [
              // Table selector
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tabla',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.darkTextSecondary)),
                    const SizedBox(height: 4),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.darkCardSec,
                        borderRadius: BorderRadius.circular(Radii.s),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedTabla,
                          isExpanded: true,
                          isDense: true,
                          dropdownColor: AppColors.darkCard,
                          style: GoogleFonts.inter(
                              fontSize: 12, color: AppColors.darkTextPrimary),
                          items: _tablas.map((t) {
                            return DropdownMenuItem(
                              value: t.key,
                              child: Text(t.label,
                                  overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _selectedTabla = v);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.s),
              // Gender selector
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Género',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.darkTextSecondary)),
                    const SizedBox(height: 4),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.darkCardSec,
                        borderRadius: BorderRadius.circular(Radii.s),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedGenero,
                          isExpanded: true,
                          isDense: true,
                          dropdownColor: AppColors.darkCard,
                          style: GoogleFonts.inter(
                              fontSize: 12, color: AppColors.darkTextPrimary),
                          items: const [
                            DropdownMenuItem(value: 'hombres', child: Text('Masculino')),
                            DropdownMenuItem(value: 'mujeres', child: Text('Femenino')),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => _selectedGenero = v);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreOverview(
      double totalPoints, int maxPoints, double percentage, String nivel, Color color) {
    return Container(
      padding: const EdgeInsets.all(Spacing.m),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Radii.m),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.military_tech, size: 28, color: color),
              const SizedBox(width: Spacing.s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Evaluación Simulada',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: color,
                        )),
                    Text('Basada en tus últimos registros',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.darkTextSecondary,
                        )),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(Radii.full),
                ),
                child: Text(
                  nivel,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.m),
          // Big score
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                totalPoints.toStringAsFixed(0),
                style: GoogleFonts.inter(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: color,
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  ' / $maxPoints pts',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.s),
          // Overall progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (percentage / 100).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.darkCardSec,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${percentage.toStringAsFixed(1)}% del puntaje máximo',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(_ExerciseResult result) {
    final goal = result.goal;
    final hasLog = result.currentValue != null && result.currentValue! > 0;
    final color = hasLog ? _getProgressColor(result.percentage) : AppColors.darkTextTertiary;

    String currentDisplay;
    String metaDisplay;

    if (goal.isTimeBased) {
      metaDisplay = _formatSeconds(goal.meta);
      currentDisplay = hasLog ? _formatSeconds(result.currentValue!.toInt()) : 'Sin registro';
    } else {
      metaDisplay = '${goal.meta} reps';
      currentDisplay = hasLog ? '${result.currentValue!.toInt()} reps' : 'Sin registro';
    }

    String dateLabel = '';
    if (result.logDate != null) {
      dateLabel = _formatDate(result.logDate!);
    }

    return Container(
      padding: const EdgeInsets.all(Spacing.s + 2),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(Radii.m),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_getExerciseIcon(goal.ejercicioClave),
                  size: 18, color: color),
              const SizedBox(width: Spacing.s),
              Expanded(
                child: Text(
                  goal.ejercicioNombre,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkTextPrimary,
                  ),
                ),
              ),
              if (dateLabel.isNotEmpty)
                Text(
                  dateLabel,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.darkTextTertiary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: Spacing.s),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: (result.percentage / 100).clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: AppColors.darkCardSec,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentDisplay,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: hasLog ? AppColors.darkTextPrimary : AppColors.darkTextTertiary,
                ),
              ),
              Text(
                'Meta: $metaDisplay',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.darkTextSecondary,
                ),
              ),
              Text(
                '${result.earnedPoints.toStringAsFixed(0)}/${goal.puntos} pts',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdviceCard(List<_ExerciseResult> results, double overallPct) {
    final advice = <_Advice>[];

    for (final r in results) {
      final goal = r.goal;
      if (r.currentValue == null || r.currentValue! <= 0) {
        advice.add(_Advice(
          icon: Icons.warning_amber_rounded,
          color: AppColors.warning,
          text: 'Sin registro de ${goal.ejercicioNombre}. ¡Registra tu ejercicio para ver tu progreso!',
        ));
        continue;
      }

      if (r.percentage >= 100) {
        advice.add(_Advice(
          icon: Icons.check_circle,
          color: AppColors.success,
          text: '${goal.ejercicioNombre}: ¡Meta alcanzada! Excelente rendimiento.',
        ));
      } else if (r.percentage >= 80) {
        if (goal.isTimeBased) {
          final diff = r.currentValue!.toInt() - goal.meta;
          advice.add(_Advice(
            icon: Icons.trending_up,
            color: const Color(0xFFFF9800),
            text: '${goal.ejercicioNombre}: ¡Casi llegas! Necesitas bajar ${_formatSeconds(diff)} para alcanzar la meta.',
          ));
        } else {
          final diff = goal.meta - r.currentValue!.toInt();
          advice.add(_Advice(
            icon: Icons.trending_up,
            color: const Color(0xFFFF9800),
            text: '${goal.ejercicioNombre}: ¡Casi llegas! Te faltan $diff repeticiones para la meta.',
          ));
        }
      } else {
        if (goal.isTimeBased) {
          final diff = r.currentValue!.toInt() - goal.meta;
          advice.add(_Advice(
            icon: Icons.fitness_center,
            color: AppColors.danger,
            text: '${goal.ejercicioNombre}: Necesitas mejorar tu tiempo en ${_formatSeconds(diff)}. Practica intervalos para ganar velocidad.',
          ));
        } else {
          final diff = goal.meta - r.currentValue!.toInt();
          advice.add(_Advice(
            icon: Icons.fitness_center,
            color: AppColors.danger,
            text: '${goal.ejercicioNombre}: Te faltan $diff reps. Practica series progresivas para subir tu marca.',
          ));
        }
      }
    }

    // Overall advice
    String overallAdvice;
    if (overallPct >= 100) {
      overallAdvice = '🏆 ¡Estás listo para la evaluación! Tu rendimiento cumple todas las metas.';
    } else if (overallPct >= 80) {
      overallAdvice = '💪 Muy buen progreso. Enfocate en los ejercicios pendientes para alcanzar el máximo.';
    } else if (overallPct >= 50) {
      overallAdvice = '📈 Vas por buen camino. Mantén la constancia y sube la intensidad gradualmente.';
    } else if (overallPct > 0) {
      overallAdvice = '🔧 Necesitas más entrenamiento. Establece una rutina diaria y registra cada sesión.';
    } else {
      overallAdvice = '⚠️ No tienes registros aún. Comienza registrando tus ejercicios con el botón +';
    }

    return Container(
      padding: const EdgeInsets.all(Spacing.m),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(Radii.m),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, size: 18, color: AppColors.warning),
              const SizedBox(width: Spacing.s),
              Text(
                'Consejos',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.s),
          // Overall
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Spacing.s),
            margin: const EdgeInsets.only(bottom: Spacing.s),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(Radii.s),
            ),
            child: Text(
              overallAdvice,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.darkTextPrimary,
                height: 1.4,
              ),
            ),
          ),
          // Per exercise
          ...advice.map((a) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(a.icon, size: 16, color: a.color),
                const SizedBox(width: Spacing.s),
                Expanded(
                  child: Text(
                    a.text,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.darkTextSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // ── Helpers ──

  String _getLevelLabel(double pct) {
    if (pct >= 90) return 'Sobresaliente';
    if (pct >= 75) return 'Bueno';
    if (pct >= 60) return 'Satisfactorio';
    if (pct >= 40) return 'Regular';
    if (pct > 0) return 'Insuficiente';
    return 'Sin datos';
  }

  Color _getLevelColor(double pct) {
    if (pct >= 90) return AppColors.success;
    if (pct >= 75) return AppColors.primary;
    if (pct >= 60) return AppColors.warning;
    if (pct >= 40) return const Color(0xFFFF9800);
    return AppColors.danger;
  }

  Color _getProgressColor(double pct) {
    if (pct >= 100) return AppColors.success;
    if (pct >= 80) return AppColors.primary;
    if (pct >= 50) return AppColors.warning;
    return AppColors.danger;
  }

  String _formatSeconds(int totalSec) {
    final min = totalSec ~/ 60;
    final sec = totalSec % 60;
    return '$min:${sec.toString().padLeft(2, '0')} min';
  }

  String _formatDate(DateTime date) {
    const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
                     'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return '${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]}';
  }

  IconData _getExerciseIcon(String clave) {
    switch (clave) {
      case 'flexiones': return Icons.fitness_center;
      case 'abdominales': return Icons.accessibility_new;
      case 'trote': return Icons.directions_run;
      case 'natacion': return Icons.pool;
      case 'cabo': return Icons.sports_gymnastics;
      default: return Icons.sports;
    }
  }
}

class _ExerciseResult {
  final GoalEntry goal;
  final double? currentValue;
  final DateTime? logDate;
  final double earnedPoints;
  final double percentage;

  const _ExerciseResult({
    required this.goal,
    this.currentValue,
    this.logDate,
    required this.earnedPoints,
    required this.percentage,
  });
}

class _Advice {
  final IconData icon;
  final Color color;
  final String text;

  const _Advice({
    required this.icon,
    required this.color,
    required this.text,
  });
}
