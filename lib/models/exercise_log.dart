import 'exercise_type.dart';

class ExerciseLog {
  final int? id;
  final int userId;
  final int exerciseTypeId;
  final DateTime fecha;
  final int? repeticiones;
  final int? duracionSegundos;
  final double? distanciaMetros;
  final int? frecuenciaCardiaca;
  final String? notas;
  final String fuente;
  final DateTime createdAt;
  final ExerciseType? exerciseType;

  ExerciseLog({
    this.id,
    required this.userId,
    required this.exerciseTypeId,
    required this.fecha,
    this.repeticiones,
    this.duracionSegundos,
    this.distanciaMetros,
    this.frecuenciaCardiaca,
    this.notas,
    this.fuente = 'manual',
    DateTime? createdAt,
    this.exerciseType,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Returns the primary metric value for charting
  double get numericValue {
    if (exerciseType == null) return 0;
    if (exerciseType!.isRepsBased) return (repeticiones ?? 0).toDouble();
    if (exerciseType!.isDistanceBased) return distanciaMetros ?? 0;
    return (duracionSegundos ?? 0).toDouble();
  }

  /// Returns a formatted display string for the primary metric
  String get displayValue {
    if (exerciseType == null) return '-';
    if (exerciseType!.isRepsBased) return '${repeticiones ?? 0} reps';
    if (exerciseType!.isDistanceBased) {
      final dist = distanciaMetros ?? 0;
      if (dist >= 1000) {
        return '${(dist / 1000).toStringAsFixed(2)} km';
      }
      return '${dist.toStringAsFixed(0)} m';
    }
    if (duracionSegundos != null) {
      final min = duracionSegundos! ~/ 60;
      final sec = duracionSegundos! % 60;
      return '$min:${sec.toString().padLeft(2, '0')}';
    }
    return '-';
  }

  /// Returns formatted duration if available
  String? get displayDuration {
    if (duracionSegundos == null) return null;
    final min = duracionSegundos! ~/ 60;
    final sec = duracionSegundos! % 60;
    return '$min:${sec.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'user_id': userId,
        'exercise_type_id': exerciseTypeId,
        'fecha': fecha.toIso8601String(),
        'repeticiones': repeticiones,
        'duracion_segundos': duracionSegundos,
        'distancia_metros': distanciaMetros,
        'frecuencia_cardiaca': frecuenciaCardiaca,
        'notas': notas,
        'fuente': fuente,
        'created_at': createdAt.toIso8601String(),
      };

  factory ExerciseLog.fromMap(Map<String, dynamic> map,
      {ExerciseType? exerciseType}) {
    return ExerciseLog(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      exerciseTypeId: map['exercise_type_id'] as int,
      fecha: DateTime.parse(map['fecha'] as String),
      repeticiones: map['repeticiones'] as int?,
      duracionSegundos: map['duracion_segundos'] as int?,
      distanciaMetros: map['distancia_metros'] != null
          ? (map['distancia_metros'] as num).toDouble()
          : null,
      frecuenciaCardiaca: map['frecuencia_cardiaca'] as int?,
      notas: map['notas'] as String?,
      fuente: map['fuente'] as String? ?? 'manual',
      createdAt: DateTime.parse(map['created_at'] as String),
      exerciseType: exerciseType,
    );
  }

  ExerciseLog copyWith({
    int? id,
    int? userId,
    int? exerciseTypeId,
    DateTime? fecha,
    int? repeticiones,
    int? duracionSegundos,
    double? distanciaMetros,
    int? frecuenciaCardiaca,
    String? notas,
    String? fuente,
    ExerciseType? exerciseType,
  }) {
    return ExerciseLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      exerciseTypeId: exerciseTypeId ?? this.exerciseTypeId,
      fecha: fecha ?? this.fecha,
      repeticiones: repeticiones ?? this.repeticiones,
      duracionSegundos: duracionSegundos ?? this.duracionSegundos,
      distanciaMetros: distanciaMetros ?? this.distanciaMetros,
      frecuenciaCardiaca: frecuenciaCardiaca ?? this.frecuenciaCardiaca,
      notas: notas ?? this.notas,
      fuente: fuente ?? this.fuente,
      createdAt: createdAt,
      exerciseType: exerciseType ?? this.exerciseType,
    );
  }
}
