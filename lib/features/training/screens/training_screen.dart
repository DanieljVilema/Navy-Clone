import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navy_pfa_armada_ecuador/core/constants/constants.dart';
import 'package:navy_pfa_armada_ecuador/shared/models/training_plan.dart';
import 'package:navy_pfa_armada_ecuador/features/training/widgets/training_week_view.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  List<TrainingGroup> _groups = [];
  String? _selectedGroupId;
  String? _selectedMonthId;
  int? _selectedWeekIndex;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    try {
      final raw =
          await rootBundle.loadString('assets/training_plans_data.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final groups = (json['grupos'] as List)
          .map((g) => TrainingGroup.fromJson(g as Map<String, dynamic>))
          .toList();
      setState(() {
        _groups = groups;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  TrainingGroup? get _selectedGroup =>
      _groups.where((g) => g.id == _selectedGroupId).firstOrNull;

  TrainingMonth? get _selectedMonth =>
      _selectedGroup?.meses.where((m) => m.id == _selectedMonthId).firstOrNull;

  TrainingSemana? get _selectedWeek {
    if (_selectedWeekIndex == null || _selectedMonth == null) return null;
    if (_selectedWeekIndex! >= _selectedMonth!.semanas.length) return null;
    return _selectedMonth!.semanas[_selectedWeekIndex!];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : _groups.isEmpty
              ? _buildEmpty()
              : Column(
                  children: [
                    if (_selectedGroupId != null) _buildNavigationHeader(),
                    Expanded(child: _buildCurrentLevel()),
                  ],
                ),
    );
  }

  Widget _buildNavigationHeader() {
    bool canGoBack = _selectedGroupId != null;
    String title = 'Biblioteca';
    if (_selectedWeekIndex != null) {
      title = _selectedWeek?.titulo ?? 'Semana';
    } else if (_selectedMonthId != null) {
      title = _selectedMonth?.nombre ?? 'Mes';
    } else if (_selectedGroupId != null) {
      title = _selectedGroup?.nombre ?? 'Grupo';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.m, vertical: Spacing.s),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        border: Border(bottom: BorderSide(color: AppColors.darkCardSec, width: 1)),
      ),
      child: Row(
        children: [
          // BACK BUTTON
          if (canGoBack)
            Padding(
              padding: const EdgeInsets.only(right: Spacing.s),
              child: IconButton(
                onPressed: _onBack,
                icon: const Icon(Icons.arrow_back_ios, size: 18, color: AppColors.primary),
                tooltip: 'Atrás',
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(Spacing.s),
              ),
            ),
          
          // CURRENT TITLE
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.darkTextPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // HOME ACTION
          IconButton(
            onPressed: () => setState(() {
              _selectedGroupId = null;
              _selectedMonthId = null;
              _selectedWeekIndex = null;
            }),
            icon: const Icon(Icons.home_outlined, size: 22, color: AppColors.darkTextSecondary),
            tooltip: 'Inicio',
          ),
        ],
      ),
    );
  }

  void _onBack() {
    setState(() {
      if (_selectedWeekIndex != null) {
        _selectedWeekIndex = null;
      } else if (_selectedMonthId != null) {
        _selectedMonthId = null;
      } else if (_selectedGroupId != null) {
        _selectedGroupId = null;
      }
    });
  }

  Widget _buildCurrentLevel() {
    if (_selectedWeekIndex != null) return _buildWeekContent();
    if (_selectedMonthId != null) return _buildWeekList();
    if (_selectedGroupId != null) return _buildMonthList();
    return _buildGroupList();
  }

  Widget _buildEmpty() {
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
            child: const Icon(Icons.folder_open_outlined,
                size: 36, color: AppColors.darkTextTertiary),
          ),
          const SizedBox(height: Spacing.m),
          Text(
            'Sin planes disponibles',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            'Los planes de entrenamiento aparecerán aquí.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }





  // ── Level 1: Groups ──

  Widget _buildGroupList() {
    return ListView.separated(
      padding: const EdgeInsets.all(Spacing.m),
      itemCount: _groups.length,
      separatorBuilder: (_, __) => const SizedBox(height: Spacing.s),
      itemBuilder: (_, i) {
        final group = _groups[i];
        final totalMonths = group.meses.length;
        return _buildNavCard(
          icon: Icons.group_outlined,
          title: group.nombre,
          subtitle:
              '$totalMonths mes${totalMonths != 1 ? 'es' : ''} disponible${totalMonths != 1 ? 's' : ''}',
          onTap: () => setState(() {
            _selectedGroupId = group.id;
            _selectedMonthId = null;
            _selectedWeekIndex = null;
          }),
        );
      },
    );
  }

  // ── Level 2: Months ──

  Widget _buildMonthList() {
    final group = _selectedGroup;
    if (group == null) return const SizedBox.shrink();

    return ListView.separated(
      padding: const EdgeInsets.all(Spacing.m),
      itemCount: group.meses.length,
      separatorBuilder: (_, __) => const SizedBox(height: Spacing.s),
      itemBuilder: (_, i) {
        final month = group.meses[i];
        return _buildNavCard(
          icon: Icons.calendar_month_outlined,
          title: month.nombre,
          subtitle:
              '${month.semanas.length} semana${month.semanas.length != 1 ? 's' : ''}',
          onTap: () => setState(() {
            _selectedMonthId = month.id;
            _selectedWeekIndex = null;
          }),
        );
      },
    );
  }

  // ── Level 3: Weeks ──

  Widget _buildWeekList() {
    final month = _selectedMonth;
    if (month == null) return const SizedBox.shrink();

    return ListView.separated(
      padding: const EdgeInsets.all(Spacing.m),
      itemCount: month.semanas.length,
      separatorBuilder: (_, __) => const SizedBox(height: Spacing.s),
      itemBuilder: (_, i) {
        final semana = month.semanas[i];
        final hasContent = semana.hasContent;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(Radii.m),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Spacing.m,
              vertical: Spacing.xs,
            ),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: hasContent
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.darkCardSec,
                borderRadius: BorderRadius.circular(Radii.s),
              ),
              child: Center(
                child: Text(
                  '${semana.numero}',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: hasContent
                        ? AppColors.primary
                        : AppColors.darkTextTertiary,
                  ),
                ),
              ),
            ),
            title: Text(
              semana.titulo,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.darkTextPrimary,
              ),
            ),
            subtitle: Text(
              hasContent
                  ? '${semana.dias.length} días de entrenamiento'
                  : 'Sin contenido disponible',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: hasContent
                    ? AppColors.darkTextSecondary
                    : AppColors.darkTextTertiary,
              ),
            ),
            trailing: hasContent
                ? const Icon(Icons.chevron_right,
                    size: 20, color: AppColors.primary)
                : null,
            onTap: hasContent
                ? () => setState(() => _selectedWeekIndex = i)
                : null,
          ),
        );
      },
    );
  }

  // ── Level 4: Week Content ──

  Widget _buildWeekContent() {
    final week = _selectedWeek;
    if (week == null) return const SizedBox.shrink();
    return TrainingWeekView(semana: week);
  }

  // ── Shared Card ──

  Widget _buildNavCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Spacing.m),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(Radii.m),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Radii.s),
              ),
              child: Icon(icon, size: 24, color: AppColors.primary),
            ),
            const SizedBox(width: Spacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.darkTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.darkTextTertiary, size: 20),
          ],
        ),
      ),
    );
  }
}
