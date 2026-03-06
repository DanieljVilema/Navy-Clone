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
                    if (_selectedGroupId != null) _buildBreadcrumb(),
                    Expanded(child: _buildCurrentLevel()),
                  ],
                ),
    );
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

  Widget _buildBreadcrumb() {
    return Container(
      color: AppColors.darkCard,
      padding:
          const EdgeInsets.symmetric(horizontal: Spacing.m, vertical: Spacing.s),
      child: Row(
        children: [
          _breadcrumbItem(
            label: 'Grupos',
            isLink: true,
            onTap: () => setState(() {
              _selectedGroupId = null;
              _selectedMonthId = null;
              _selectedWeekIndex = null;
            }),
          ),
          if (_selectedGroupId != null) ...[
            _breadcrumbChevron(),
            _breadcrumbItem(
              label: _selectedGroup?.nombre ?? '',
              isLink: _selectedMonthId != null,
              onTap: () => setState(() {
                _selectedMonthId = null;
                _selectedWeekIndex = null;
              }),
            ),
          ],
          if (_selectedMonthId != null) ...[
            _breadcrumbChevron(),
            _breadcrumbItem(
              label: _selectedMonth?.nombre ?? '',
              isLink: _selectedWeekIndex != null,
              onTap: () => setState(() => _selectedWeekIndex = null),
            ),
          ],
          if (_selectedWeekIndex != null) ...[
            _breadcrumbChevron(),
            _breadcrumbItem(
              label: _selectedWeek?.titulo ?? '',
              isLink: false,
              onTap: () {},
            ),
          ],
        ],
      ),
    );
  }

  Widget _breadcrumbItem({
    required String label,
    required bool isLink,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isLink ? onTap : null,
      child: Flexible(
        child: Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isLink ? AppColors.primary : AppColors.darkTextPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _breadcrumbChevron() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child:
          Icon(Icons.chevron_right, size: 16, color: AppColors.darkTextTertiary),
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
