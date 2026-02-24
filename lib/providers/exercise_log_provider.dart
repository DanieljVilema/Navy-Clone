import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import '../models/exercise_type.dart';
import '../models/exercise_log.dart';
import '../services/database_service.dart';

class ExerciseLogProvider extends ChangeNotifier {
  final DatabaseService _db;

  List<ExerciseType> _exerciseTypes = [];
  List<ExerciseLog> _logs = [];
  DateTime _selectedMonth = DateTime.now();
  String? _selectedExerciseClave;

  ExerciseLogProvider(this._db);

  // ── Getters ──

  List<ExerciseType> get exerciseTypes => _exerciseTypes;
  List<ExerciseLog> get logs => _logs;
  DateTime get selectedMonth => _selectedMonth;
  String? get selectedExerciseClave => _selectedExerciseClave;

  List<ExerciseLog> get filteredLogs {
    if (_selectedExerciseClave == null) return _logs;
    return _logs
        .where((l) => l.exerciseType?.clave == _selectedExerciseClave)
        .toList();
  }

  /// Logs grouped by date for history list
  Map<DateTime, List<ExerciseLog>> get logsByDate {
    final map = <DateTime, List<ExerciseLog>>{};
    for (final log in filteredLogs) {
      final dateKey = DateTime(log.fecha.year, log.fecha.month, log.fecha.day);
      map.putIfAbsent(dateKey, () => []).add(log);
    }
    return map;
  }

  /// Line chart spots for a specific exercise type over selected month
  List<FlSpot> getSpotsForExercise(String clave) {
    final exerciseLogs =
        _logs.where((l) => l.exerciseType?.clave == clave).toList();
    if (exerciseLogs.isEmpty) return [];

    exerciseLogs.sort((a, b) => a.fecha.compareTo(b.fecha));

    return exerciseLogs.map((log) {
      return FlSpot(log.fecha.day.toDouble(), log.numericValue);
    }).toList();
  }

  /// Weekly totals for bar chart (week number → total value)
  Map<int, double> getWeeklyTotals(String clave) {
    final exerciseLogs =
        _logs.where((l) => l.exerciseType?.clave == clave).toList();
    final totals = <int, double>{};

    for (final log in exerciseLogs) {
      // Week of the month (1-5)
      final weekOfMonth = ((log.fecha.day - 1) ~/ 7) + 1;
      totals[weekOfMonth] = (totals[weekOfMonth] ?? 0) + log.numericValue;
    }
    return totals;
  }

  /// Total sessions this month
  int get totalSessionsThisMonth => _logs.length;

  /// Total sessions this week
  int get totalSessionsThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    return _logs.where((l) => l.fecha.isAfter(start)).length;
  }

  // ── Methods ──

  Future<void> loadExerciseTypes() async {
    _exerciseTypes = await _db.getExerciseTypes();
    notifyListeners();
  }

  Future<void> loadLogs(int userId) async {
    _logs = await _db.getExerciseLogsByMonth(
      userId,
      _selectedMonth.year,
      _selectedMonth.month,
    );
    notifyListeners();
  }

  Future<void> addLog(ExerciseLog log) async {
    await _db.insertExerciseLog(log);
    // Reload to get the full log with exercise type
    await loadLogs(log.userId);
  }

  Future<void> deleteLog(int id, int userId) async {
    await _db.deleteExerciseLog(id);
    await loadLogs(userId);
  }

  void setSelectedMonth(DateTime month) {
    _selectedMonth = month;
    notifyListeners();
  }

  void previousMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    notifyListeners();
  }

  void nextMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    notifyListeners();
  }

  void setSelectedExercise(String? clave) {
    _selectedExerciseClave = clave;
    notifyListeners();
  }

  ExerciseType? getTypeByKey(String clave) {
    return _exerciseTypes.where((t) => t.clave == clave).firstOrNull;
  }
}
