import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/constants.dart';
import '../../models/training_plan.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  List<TrainingGroup> _groups = [];
  String? _selectedGroupId;
  String? _selectedMonthId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    try {
      final raw = await rootBundle.loadString('assets/training_plans_config.json');
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

  Future<void> _openPdf(String assetPath) async {
    try {
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final safeName = 'navy_training_${assetPath.hashCode.abs()}.pdf';
      final file = File('${tempDir.path}/$safeName');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo abrir el PDF: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  TrainingGroup? get _selectedGroup =>
      _groups.where((g) => g.id == _selectedGroupId).firstOrNull;

  TrainingMonth? get _selectedMonth =>
      _selectedGroup?.meses.where((m) => m.id == _selectedMonthId).firstOrNull;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _groups.isEmpty
              ? _buildEmpty()
              : Column(
                  children: [
                    if (_selectedGroupId != null) _buildBreadcrumb(),
                    Expanded(
                      child: _selectedMonthId != null
                          ? _buildWeekList()
                          : _selectedGroupId != null
                              ? _buildMonthList()
                              : _buildGroupList(),
                    ),
                  ],
                ),
    );
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
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.m, vertical: Spacing.s),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() {
              _selectedGroupId = null;
              _selectedMonthId = null;
            }),
            child: Text(
              'Grupos',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (_selectedGroupId != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.chevron_right,
                  size: 16, color: AppColors.darkTextTertiary),
            ),
            GestureDetector(
              onTap: () => setState(() => _selectedMonthId = null),
              child: Text(
                _selectedGroup?.nombre ?? '',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: _selectedMonthId != null
                      ? AppColors.primary
                      : AppColors.darkTextPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          if (_selectedMonthId != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.chevron_right,
                  size: 16, color: AppColors.darkTextTertiary),
            ),
            Text(
              _selectedMonth?.nombre ?? '',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.darkTextPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGroupList() {
    return ListView.separated(
      padding: const EdgeInsets.all(Spacing.m),
      itemCount: _groups.length,
      separatorBuilder: (_, __) => const SizedBox(height: Spacing.s),
      itemBuilder: (_, i) {
        final group = _groups[i];
        return _buildNavCard(
          icon: Icons.group_outlined,
          title: group.nombre,
          subtitle:
              '${group.meses.length} mes${group.meses.length != 1 ? 'es' : ''}',
          onTap: () => setState(() {
            _selectedGroupId = group.id;
            _selectedMonthId = null;
          }),
        );
      },
    );
  }

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
          onTap: () => setState(() => _selectedMonthId = month.id),
        );
      },
    );
  }

  Widget _buildWeekList() {
    final month = _selectedMonth;
    if (month == null) return const SizedBox.shrink();

    return ListView.separated(
      padding: const EdgeInsets.all(Spacing.m),
      itemCount: month.semanas.length,
      separatorBuilder: (_, __) => const SizedBox(height: Spacing.s),
      itemBuilder: (_, i) {
        final semana = month.semanas[i];
        final hasPdf = semana.pdfAsset != null;

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
                color: hasPdf
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.darkCardSec,
                borderRadius: BorderRadius.circular(Radii.s),
              ),
              child: Icon(
                hasPdf
                    ? Icons.picture_as_pdf_outlined
                    : Icons.lock_outline,
                size: 20,
                color: hasPdf
                    ? AppColors.primary
                    : AppColors.darkTextTertiary,
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
              hasPdf
                  ? 'Toca para abrir el PDF'
                  : 'PDF no disponible aún',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: hasPdf
                    ? AppColors.darkTextSecondary
                    : AppColors.darkTextTertiary,
              ),
            ),
            trailing: hasPdf
                ? const Icon(Icons.open_in_new,
                    size: 18, color: AppColors.primary)
                : null,
            onTap: hasPdf ? () => _openPdf(semana.pdfAsset!) : null,
          ),
        );
      },
    );
  }

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
