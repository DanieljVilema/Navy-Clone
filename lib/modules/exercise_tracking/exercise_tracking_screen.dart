import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/exercise_log_provider.dart';
import '../../providers/user_provider.dart';
import 'widgets/exercise_type_selector.dart';
import 'widgets/exercise_log_card.dart';
import 'widgets/exercise_log_form.dart';
import 'widgets/exercise_progress_chart.dart';
import 'widgets/exercise_weekly_bar_chart.dart';

class ExerciseTrackingScreen extends StatefulWidget {
  const ExerciseTrackingScreen({super.key});

  @override
  State<ExerciseTrackingScreen> createState() => _ExerciseTrackingScreenState();
}

class _ExerciseTrackingScreenState extends State<ExerciseTrackingScreen> {
  bool _showCharts = true; // true = Progreso, false = Historial

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
            onPressed: provider.exerciseTypes.isNotEmpty ? _openLogForm : null,
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
                      _buildTab('Progreso', _showCharts, () {
                        setState(() => _showCharts = true);
                      }),
                      _buildTab('Historial', !_showCharts, () {
                        setState(() => _showCharts = false);
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Spacing.s),

              // ── CONTENT ──
              Expanded(
                child: _showCharts
                    ? _buildChartsView(provider, selectedClave, daysInMonth)
                    : _buildHistoryView(provider),
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

    final sortedDates = logsByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.all(Spacing.m),
      itemCount: sortedDates.length,
      itemBuilder: (_, i) {
        final date = sortedDates[i];
        final logs = logsByDate[date]!;

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
            ...logs.map((log) => Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.s),
                  child: ExerciseLogCard(
                    log: log,
                    onDelete: () => provider.deleteLog(log.id!, userId),
                  ),
                )),
          ],
        );
      },
    );
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
