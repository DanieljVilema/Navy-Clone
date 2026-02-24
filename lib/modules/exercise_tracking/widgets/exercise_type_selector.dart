import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants.dart';
import '../../../models/exercise_type.dart';

class ExerciseTypeSelector extends StatelessWidget {
  final List<ExerciseType> types;
  final String? selectedClave;
  final ValueChanged<String?> onSelected;

  const ExerciseTypeSelector({
    super.key,
    required this.types,
    required this.selectedClave,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.m),
        children: [
          _buildChip('Todos', null),
          const SizedBox(width: Spacing.s),
          ...types.map((t) => Padding(
                padding: const EdgeInsets.only(right: Spacing.s),
                child: _buildChip(t.nombre, t.clave),
              )),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String? clave) {
    final isActive = selectedClave == clave;
    return GestureDetector(
      onTap: () => onSelected(clave),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.darkCardSec,
          borderRadius: BorderRadius.circular(Radii.full),
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
    );
  }
}
