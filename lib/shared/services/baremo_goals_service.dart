import 'dart:convert';
import 'package:flutter/services.dart';

/// Represents a single exercise goal from a baremo table.
class GoalEntry {
  final String ejercicioClave;
  final String ejercicioNombre;
  final int meta; // reps or seconds
  final int puntos; // max points for this exercise
  final bool isTimeBased; // true = seconds (lower is better), false = reps (higher is better)

  const GoalEntry({
    required this.ejercicioClave,
    required this.ejercicioNombre,
    required this.meta,
    required this.puntos,
    required this.isTimeBased,
  });
}

/// Info about a baremo table.
class TablaInfo {
  final String key; // e.g. "tabla_1"
  final String label; // e.g. "Tabla 1 — 0 a 24 años"
  final String edades;
  final int puntosMaximos;

  const TablaInfo({
    required this.key,
    required this.label,
    required this.edades,
    required this.puntosMaximos,
  });
}

/// Service that parses baremos.json and provides exercise goals per table/gender.
class BaremoGoalsService {
  Map<String, dynamic>? _rawData;

  /// Loads baremos.json (cached after first call).
  Future<void> load() async {
    if (_rawData != null) return;
    final data = await rootBundle.loadString('assets/baremos.json');
    _rawData = jsonDecode(data) as Map<String, dynamic>;
  }

  /// Returns the list of available tables.
  List<TablaInfo> getTablaList() {
    if (_rawData == null) return [];
    final result = <TablaInfo>[];
    for (final entry in _rawData!.entries) {
      final tabla = entry.value;
      if (tabla is! Map<String, dynamic>) continue;
      final edades = tabla['edades'] as String? ?? '';
      final puntosMax = tabla['puntos_maximos'] as int? ?? 500;
      final numero = entry.key.replaceAll('tabla_', '');
      result.add(TablaInfo(
        key: entry.key,
        label: 'Tabla $numero — $edades',
        edades: edades,
        puntosMaximos: puntosMax,
      ));
    }
    return result;
  }

  /// Returns exercise goals for a given table and gender.
  /// [genero] should be 'hombres' or 'mujeres'.
  List<GoalEntry> getGoals(String tablaKey, String genero) {
    if (_rawData == null) return [];
    final tabla = _rawData![tablaKey] as Map<String, dynamic>?;
    if (tabla == null) return [];

    var genData = tabla[genero] as Map<String, dynamic>?;
    if (genData == null) return [];

    // Tables 11-13 have opcion_regular / opcion_alternativa
    if (genData.containsKey('opcion_regular')) {
      genData = genData['opcion_regular'] as Map<String, dynamic>?;
      if (genData == null) return [];
    }

    final goals = <GoalEntry>[];

    if (genData.containsKey('abdominales')) {
      final m = genData['abdominales'] as Map<String, dynamic>;
      goals.add(GoalEntry(
        ejercicioClave: 'abdominales',
        ejercicioNombre: 'Abdominales',
        meta: (m['meta'] as num).toInt(),
        puntos: (m['puntos'] as num).toInt(),
        isTimeBased: false,
      ));
    }

    if (genData.containsKey('flexiones')) {
      final m = genData['flexiones'] as Map<String, dynamic>;
      goals.add(GoalEntry(
        ejercicioClave: 'flexiones',
        ejercicioNombre: 'Flexiones',
        meta: (m['meta'] as num).toInt(),
        puntos: (m['puntos'] as num).toInt(),
        isTimeBased: false,
      ));
    }

    if (genData.containsKey('trote_segundos')) {
      final m = genData['trote_segundos'] as Map<String, dynamic>;
      goals.add(GoalEntry(
        ejercicioClave: 'trote',
        ejercicioNombre: 'Trote 2.4km',
        meta: (m['meta'] as num).toInt(),
        puntos: (m['puntos'] as num).toInt(),
        isTimeBased: true,
      ));
    }

    if (genData.containsKey('natacion_segundos')) {
      final m = genData['natacion_segundos'] as Map<String, dynamic>;
      goals.add(GoalEntry(
        ejercicioClave: 'natacion',
        ejercicioNombre: 'Natación 450m',
        meta: (m['meta'] as num).toInt(),
        puntos: (m['puntos'] as num).toInt(),
        isTimeBased: true,
      ));
    }

    if (genData.containsKey('cabo_segundos')) {
      final m = genData['cabo_segundos'] as Map<String, dynamic>;
      goals.add(GoalEntry(
        ejercicioClave: 'cabo',
        ejercicioNombre: 'Cabo',
        meta: (m['meta'] as num).toInt(),
        puntos: (m['puntos'] as num).toInt(),
        isTimeBased: true,
      ));
    }

    return goals;
  }

  /// Returns the max points for a given table.
  int getMaxPoints(String tablaKey) {
    if (_rawData == null) return 500;
    final tabla = _rawData![tablaKey] as Map<String, dynamic>?;
    return tabla?['puntos_maximos'] as int? ?? 500;
  }
}
