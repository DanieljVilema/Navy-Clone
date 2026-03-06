import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navy_pfa_armada_ecuador/core/constants/constants.dart';
import 'package:navy_pfa_armada_ecuador/shared/models/training_plan.dart';

class TrainingWeekView extends StatelessWidget {
  final TrainingSemana semana;

  const TrainingWeekView({super.key, required this.semana});

  @override
  Widget build(BuildContext context) {
    if (semana.dias.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.darkCardSec,
                borderRadius: BorderRadius.circular(Radii.full),
              ),
              child: const Icon(Icons.event_busy_outlined,
                  size: 28, color: AppColors.darkTextTertiary),
            ),
            const SizedBox(height: Spacing.m),
            Text(
              'Sin contenido disponible',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.darkTextSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(Spacing.m),
      itemCount: semana.dias.length,
      separatorBuilder: (_, __) => const SizedBox(height: Spacing.m),
      itemBuilder: (_, i) => _DayCard(dia: semana.dias[i]),
    );
  }
}

class _DayCard extends StatelessWidget {
  final TrainingDia dia;

  const _DayCard({required this.dia});

  @override
  Widget build(BuildContext context) {
    // Group bloques by seccion
    final secciones = <String, List<TrainingBloque>>{};
    for (final bloque in dia.bloques) {
      final key = bloque.seccion.isNotEmpty ? bloque.seccion : 'ACTIVIDAD';
      secciones.putIfAbsent(key, () => []).add(bloque);
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(Radii.m),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.m,
              vertical: Spacing.s,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Radii.m),
                topRight: Radius.circular(Radii.m),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: Spacing.xs),
                Text(
                  dia.nombre,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          // Sections
          ...secciones.entries.map((entry) => _SectionBlock(
                seccion: entry.key,
                bloques: entry.value,
              )),
          const SizedBox(height: Spacing.xs),
        ],
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final String seccion;
  final List<TrainingBloque> bloques;

  const _SectionBlock({required this.seccion, required this.bloques});

  IconData get _sectionIcon {
    switch (seccion) {
      case 'PARTE INICIAL':
        return Icons.wb_sunny_outlined;
      case 'PARTE PRINCIPAL':
        return Icons.fitness_center;
      case 'PARTE FINAL':
        return Icons.nightlight_outlined;
      default:
        return Icons.list;
    }
  }

  Color get _sectionColor {
    switch (seccion) {
      case 'PARTE INICIAL':
        return const Color(0xFF4CAF50);
      case 'PARTE PRINCIPAL':
        return AppColors.primary;
      case 'PARTE FINAL':
        return const Color(0xFFFF9800);
      default:
        return AppColors.darkTextSecondary;
    }
  }

  String get _sectionLabel {
    switch (seccion) {
      case 'PARTE INICIAL':
        return 'Calentamiento';
      case 'PARTE PRINCIPAL':
        return 'Parte Principal';
      case 'PARTE FINAL':
        return 'Vuelta a la Calma';
      default:
        return seccion;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter out bloques that are just section titles (e.g. "ATLETISMO", "NATACIÓN")
    // and merge them as subtitle
    String? disciplina;
    final actividades = <TrainingBloque>[];

    for (final b in bloques) {
      final text = b.actividad.trim();
      // If it's a short ALL-CAPS word, treat as discipline label
      if (text == text.toUpperCase() && text.length < 30 && !text.contains('\n')) {
        disciplina = text;
      } else {
        actividades.add(b);
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.m, Spacing.s, Spacing.m, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Icon(_sectionIcon, size: 14, color: _sectionColor),
              const SizedBox(width: 6),
              Text(
                _sectionLabel,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _sectionColor,
                  letterSpacing: 0.5,
                ),
              ),
              if (bloques.isNotEmpty && bloques.first.hora.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  bloques.first.hora,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.darkTextTertiary,
                  ),
                ),
              ],
              if (disciplina != null) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _sectionColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(Radii.s),
                  ),
                  child: Text(
                    disciplina,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _sectionColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          // Activities
          if (actividades.isEmpty && disciplina == null)
            ...bloques.map((b) => _ActivityText(text: b.actividad))
          else
            ...actividades.map((b) => _ActivityText(text: b.actividad)),
          const Divider(
            color: AppColors.darkBorder,
            height: Spacing.m,
          ),
        ],
      ),
    );
  }
}

class _ActivityText extends StatelessWidget {
  final String text;

  const _ActivityText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text.trim(),
        style: GoogleFonts.inter(
          fontSize: 13,
          height: 1.5,
          color: AppColors.darkTextPrimary,
        ),
      ),
    );
  }
}
