import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:navy_pfa_armada_ecuador/core/constants/constants.dart';
import 'package:navy_pfa_armada_ecuador/features/exercise_tracking/models/exercise_log.dart';
import 'package:navy_pfa_armada_ecuador/features/exercise_tracking/providers/exercise_log_provider.dart';
import 'package:navy_pfa_armada_ecuador/shared/providers/user_provider.dart';
import 'package:navy_pfa_armada_ecuador/shared/services/scoring_service.dart';
import 'package:navy_pfa_armada_ecuador/features/exercise_tracking/widgets/exercise_type_selector.dart';
import 'package:navy_pfa_armada_ecuador/features/exercise_tracking/widgets/exercise_log_card.dart';
import 'package:navy_pfa_armada_ecuador/features/exercise_tracking/widgets/exercise_log_form.dart';
import 'package:navy_pfa_armada_ecuador/features/exercise_tracking/widgets/exercise_progress_chart.dart';
import 'package:navy_pfa_armada_ecuador/features/exercise_tracking/widgets/exercise_weekly_bar_chart.dart';
import 'package:navy_pfa_armada_ecuador/features/exercise_tracking/widgets/evaluation_simulator_tab.dart';

class ExerciseTrackingScreen extends StatefulWidget {
  const ExerciseTrackingScreen({super.key});

  @override
  State<ExerciseTrackingScreen> createState() => _ExerciseTrackingScreenState();
}

class _ExerciseTrackingScreenState extends State<ExerciseTrackingScreen> {
  int _selectedTab = 0; // 0 = Progreso, 1 = Historial, 2 = Simulador

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<ExerciseLogProvider>();
      final userId = context.read<UserProvider>().userId;
      provider.loadExerciseTypes();
      provider.loadLogs(userId);
    });
  }

  void _openLogForm() {
    final provider = context.read<ExerciseLogProvider>();
    if (provider.exerciseTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cargando ejercicios, intenta de nuevo en un momento'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    final userId = context.read<UserProvider>().userId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExerciseLogForm(
        exerciseTypes: provider.exerciseTypes,
        userId: userId,
        onSave: (log) {
          provider.addLog(log);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ejercicio registrado')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseLogProvider>(
      builder: (context, provider, _) {
        final selectedClave = provider.selectedExerciseClave;
        final daysInMonth = DateTime(
          provider.selectedMonth.year,
          provider.selectedMonth.month + 1,
          0,
        ).day;

        return Scaffold(
          backgroundColor: AppColors.darkBg,
          floatingActionButton: FloatingActionButton(
            onPressed: _openLogForm,
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: Column(
            children: [
              // ── MONTH SELECTOR ──
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.m, vertical: Spacing.s),
                color: AppColors.darkCard,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left,
                          color: AppColors.darkTextSecondary),
                      onPressed: () {
                        provider.previousMonth();
                        final userId = context.read<UserProvider>().userId;
                        provider.loadLogs(userId);
                      },
                    ),
                    Text(
                      _formatMonth(provider.selectedMonth),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkTextPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right,
                          color: AppColors.darkTextSecondary),
                      onPressed: () {
                        provider.nextMonth();
                        final userId = context.read<UserProvider>().userId;
                        provider.loadLogs(userId);
                      },
                    ),
                  ],
                ),
              ),

              // ── STATS ROW ──
              Container(
                padding: const EdgeInsets.all(Spacing.m),
                child: Row(
                  children: [
                    _StatCard(
                      label: 'Este mes',
                      value: '${provider.totalSessionsThisMonth}',
                      unit: 'sesiones',
                    ),
                    const SizedBox(width: Spacing.s),
                    _StatCard(
                      label: 'Esta semana',
                      value: '${provider.totalSessionsThisWeek}',
                      unit: 'sesiones',
                    ),
                  ],
                ),
              ),

              // ── EXERCISE TYPE FILTER ──
              ExerciseTypeSelector(
                types: provider.exerciseTypes,
                selectedClave: selectedClave,
                onSelected: (clave) => provider.setSelectedExercise(clave),
              ),
              const SizedBox(height: Spacing.m),

              // ── TOGGLE TABS ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.m),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.darkCardSec,
                    borderRadius: BorderRadius.circular(Radii.m),
                  ),
                  child: Row(
                    children: [
                      _buildTab('Progreso', _selectedTab == 0, () {
                        setState(() => _selectedTab = 0);
                      }),
                      _buildTab('Historial', _selectedTab == 1, () {
                        setState(() => _selectedTab = 1);
                      }),
                      _buildTab('Simulador', _selectedTab == 2, () {
                        setState(() => _selectedTab = 2);
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Spacing.s),

              // ── CONTENT ──
              Expanded(
                child: _selectedTab == 0
                    ? _buildChartsView(provider, selectedClave, daysInMonth)
                    : _selectedTab == 1
                        ? _buildHistoryView(provider)
                        : const EvaluationSimulatorTab(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTab(String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(Radii.m),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? Colors.white : AppColors.darkTextSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartsView(
      ExerciseLogProvider provider, String? selectedClave, int daysInMonth) {
    if (selectedClave == null) {
      return ListView(
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
                Text(
                  'Selecciona un ejercicio',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkTextPrimary,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  'Usa los filtros de arriba para ver el progreso de un ejercicio específico.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final spots = provider.getSpotsForExercise(selectedClave);
    final weeklyTotals = provider.getWeeklyTotals(selectedClave);
    final type = provider.getTypeByKey(selectedClave);
    final metricLabel =
        type?.isRepsBased == true ? 'reps' : (type?.isDistanceBased == true ? 'm' : 'seg');

    return ListView(
      padding: const EdgeInsets.all(Spacing.m),
      children: [
        // Line chart
        Container(
          padding: const EdgeInsets.all(Spacing.s),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(Radii.m),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progreso Diario',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkTextPrimary,
                ),
              ),
              ExerciseProgressChart(
                spots: spots,
                metricLabel: metricLabel,
                daysInMonth: daysInMonth,
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.m),

        // Bar chart
        Container(
          padding: const EdgeInsets.all(Spacing.s),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(Radii.m),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Volumen Semanal',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkTextPrimary,
                ),
              ),
              ExerciseWeeklyBarChart(
                weeklyTotals: weeklyTotals,
                metricLabel: metricLabel,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryView(ExerciseLogProvider provider) {
    final logsByDate = provider.logsByDate;
    final userId = context.read<UserProvider>().userId;
    final userProvider = context.read<UserProvider>();
    final scorer = context.read<ScoringService>();

    if (logsByDate.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.darkCardSec,
                borderRadius: BorderRadius.circular(Radii.full),
              ),
              child: const Icon(Icons.fitness_center,
                  size: 36, color: AppColors.darkTextTertiary),
            ),
            const SizedBox(height: Spacing.m),
            Text(
              'Sin registros este mes',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkTextPrimary,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              'Presiona + para registrar tu primer ejercicio.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.darkTextSecondary,
              ),
            ),
          ],
        ),
      );
    }

    final genero = userProvider.profile?.genero ?? '';
    final grupoEdad = userProvider.profile?.grupoEdad ?? '';
    final hasProfile = genero.isNotEmpty && grupoEdad.isNotEmpty;

    final sortedDates = logsByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.all(Spacing.m),
      itemCount: sortedDates.length,
      itemBuilder: (_, i) {
        final date = sortedDates[i];
        final logs = logsByDate[date]!;

        // Get ALL logs for this date (unfiltered) to check PFA completeness
        final allLogsForDate = provider.getLogsForDate(date);
        final pfaSummary = hasProfile
            ? _buildPfaSummary(allLogsForDate, provider, scorer, genero, grupoEdad)
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.s, top: Spacing.s),
              child: Text(
                _formatDate(date),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkTextTertiary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            // PFA summary card if complete evaluation detected
            if (pfaSummary != null) ...[
              pfaSummary,
              const SizedBox(height: Spacing.s),
            ],
            ...logs.map((log) {
              final score = hasProfile
                  ? provider.getScoreForLog(log, scorer, genero, grupoEdad)
                  : null;
              return Padding(
                padding: const EdgeInsets.only(bottom: Spacing.s),
                child: ExerciseLogCard(
                  log: log,
                  score: score,
                  onDelete: () => provider.deleteLog(log.id!, userId),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  /// Returns a PFA summary card if flexiones + abdominales + cardio all present on the same date.
  Widget? _buildPfaSummary(
    List<ExerciseLog> allLogs,
    ExerciseLogProvider provider,
    ScoringService scorer,
    String genero,
    String grupoEdad,
  ) {
    final flex = allLogs.where((l) => l.exerciseType?.clave == 'flexiones').toList();
    final abd = allLogs.where((l) => l.exerciseType?.clave == 'abdominales').toList();
    final cardio = allLogs
        .where((l) =>
            l.exerciseType?.clave == 'trote' ||
            l.exerciseType?.clave == 'natacion')
        .toList();

    if (flex.isEmpty || abd.isEmpty || cardio.isEmpty) return null;

    // Use the best result for each event that day
    double? flexScore;
    double? abdScore;
    double? cardioScore;

    for (final log in flex) {
      final s = provider.getScoreForLog(log, scorer, genero, grupoEdad);
      if (s != null && (flexScore == null || s > flexScore)) flexScore = s;
    }
    for (final log in abd) {
      final s = provider.getScoreForLog(log, scorer, genero, grupoEdad);
      if (s != null && (abdScore == null || s > abdScore)) abdScore = s;
    }
    for (final log in cardio) {
      final s = provider.getScoreForLog(log, scorer, genero, grupoEdad);
      if (s != null && (cardioScore == null || s > cardioScore)) cardioScore = s;
    }

    if (flexScore == null || abdScore == null || cardioScore == null) return null;

    final total = (flexScore + abdScore + cardioScore) / 3;
    final nivel = _levelLabel(total);
    final levelColor = _scoreColor(total);

    return Container(
      padding: const EdgeInsets.all(Spacing.m),
      decoration: BoxDecoration(
        color: levelColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Radii.m),
        border: Border.all(color: levelColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.military_tech, size: 18, color: levelColor),
              const SizedBox(width: Spacing.xs),
              Text(
                'Evaluación PFA del día',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: levelColor,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: levelColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(Radii.full),
                ),
                child: Text(
                  '${total.toStringAsFixed(1)} pts · $nivel',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: levelColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.s),
          _pfaRow('Flexiones', flexScore),
          _pfaRow('Abdominales', abdScore),
          _pfaRow(cardio.first.exerciseType?.nombre ?? 'Cardio', cardioScore),
        ],
      ),
    );
  }

  Widget _pfaRow(String label, double score) {
    final color = _scoreColor(score);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.darkTextSecondary,
              ),
            ),
          ),
          Text(
            '${score.toStringAsFixed(1)} pts',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
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

  String _formatMonth(DateTime date) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatDate(DateTime date) {
    const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    return '${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(Spacing.s),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(Radii.m),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.darkTextTertiary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    unit,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.darkTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
