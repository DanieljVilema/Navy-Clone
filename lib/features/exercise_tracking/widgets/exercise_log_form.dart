import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navy_pfa_armada_ecuador/core/constants/constants.dart';
import 'package:navy_pfa_armada_ecuador/shared/models/exercise_type.dart';
import 'package:navy_pfa_armada_ecuador/features/exercise_tracking/models/exercise_log.dart';

class ExerciseLogForm extends StatefulWidget {
  final List<ExerciseType> exerciseTypes;
  final int userId;
  final ValueChanged<ExerciseLog> onSave;

  const ExerciseLogForm({
    super.key,
    required this.exerciseTypes,
    required this.userId,
    required this.onSave,
  });

  @override
  State<ExerciseLogForm> createState() => _ExerciseLogFormState();
}

class _ExerciseLogFormState extends State<ExerciseLogForm> {
  late ExerciseType _selectedType;
  DateTime _selectedDate = DateTime.now();
  final _repsController = TextEditingController();
  final _distanceController = TextEditingController();
  final _minutesController = TextEditingController();
  final _secondsController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedType = widget.exerciseTypes.first;
  }

  @override
  void dispose() {
    _repsController.dispose();
    _distanceController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    _heartRateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    int? reps;
    int? durationSec;
    double? distance;
    int? heartRate;

    if (_selectedType.isRepsBased) {
      reps = int.tryParse(_repsController.text);
      if (reps == null || reps <= 0) return;
    }

    if (_selectedType.isDistanceBased) {
      distance = double.tryParse(_distanceController.text);
      if (distance == null || distance <= 0) return;
    }

    final min = int.tryParse(_minutesController.text) ?? 0;
    final sec = int.tryParse(_secondsController.text) ?? 0;
    if (min > 0 || sec > 0) {
      durationSec = min * 60 + sec;
    }

    heartRate = int.tryParse(_heartRateController.text);

    final log = ExerciseLog(
      userId: widget.userId,
      exerciseTypeId: _selectedType.id!,
      fecha: _selectedDate,
      repeticiones: reps,
      duracionSegundos: durationSec,
      distanciaMetros: distance,
      frecuenciaCardiaca: heartRate,
      notas: _notesController.text.isEmpty ? null : _notesController.text,
      exerciseType: _selectedType,
    );

    widget.onSave(log);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.darkCard,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: Spacing.m,
        right: Spacing.m,
        top: Spacing.m,
        bottom: MediaQuery.of(context).viewInsets.bottom + Spacing.m,
      ),
      decoration: const BoxDecoration(
        color: AppColors.darkBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.l)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: Spacing.m),
                decoration: BoxDecoration(
                  color: AppColors.darkCardSec,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Text(
              'Registrar Ejercicio',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.darkTextPrimary,
              ),
            ),
            const SizedBox(height: Spacing.m),

            // Exercise type dropdown
            _buildLabel('Tipo de ejercicio'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.s),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(Radii.m),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ExerciseType>(
                  isExpanded: true,
                  value: _selectedType,
                  dropdownColor: AppColors.darkCard,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.darkTextPrimary,
                  ),
                  items: widget.exerciseTypes
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t.nombre),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedType = v);
                  },
                ),
              ),
            ),
            const SizedBox(height: Spacing.m),

            // Date picker
            _buildLabel('Fecha'),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.s, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(Radii.m),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 18, color: AppColors.darkTextSecondary),
                    const SizedBox(width: Spacing.s),
                    Text(
                      '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.darkTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Spacing.m),

            // Dynamic fields based on exercise type
            if (_selectedType.isRepsBased) ...[ // Ej: Flexiones, Abdominales
              _buildLabel('Repeticiones'),
              _buildTextField(_repsController, 'Ej: 30',
                  keyboardType: TextInputType.number),
            ] else if (_selectedType.isTimeBased) ...[ // Ej: Trote, Natación, Cabo, VO2 Rockport
              _buildLabel('Tiempo'),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(_minutesController, 'Min',
                        keyboardType: TextInputType.number),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.s),
                    child: Text(':',
                        style: GoogleFonts.inter(
                            fontSize: 20, color: AppColors.darkTextSecondary)),
                  ),
                  Expanded(
                    child: _buildTextField(_secondsController, 'Seg',
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
            ] else if (_selectedType.isDistanceBased) ...[ // Only if distance is explicitly the metric
              _buildLabel('Distancia (metros)'),
              _buildTextField(_distanceController, 'Ej: 2400',
                  keyboardType: TextInputType.number),
              const SizedBox(height: Spacing.m),
              _buildLabel('Tiempo (opcional)'),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(_minutesController, 'Min',
                        keyboardType: TextInputType.number),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.s),
                    child: Text(':',
                        style: GoogleFonts.inter(
                            fontSize: 20, color: AppColors.darkTextSecondary)),
                  ),
                  Expanded(
                    child: _buildTextField(_secondsController, 'Seg',
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
            ],
            const SizedBox(height: Spacing.m),

            // Heart rate (optional)
            _buildLabel('Frecuencia cardíaca (opcional)'),
            _buildTextField(_heartRateController, 'Ej: 145',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.favorite_outline),

            // Notes (optional)
            _buildLabel('Notas (opcional)'),
            _buildTextField(_notesController, 'Observaciones...', maxLines: 2),
            const SizedBox(height: Spacing.l),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.m),
                  ),
                ),
                child: Text(
                  'Guardar',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.s),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextSecondary,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType? keyboardType,
    IconData? prefixIcon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.s),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.darkTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.darkTextTertiary,
          ),
          filled: true,
          fillColor: AppColors.darkCard,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, size: 18, color: AppColors.darkTextSecondary)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Radii.m),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Spacing.s,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
