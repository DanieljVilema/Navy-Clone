class TrainingBloque {
  final String hora;
  final String seccion;
  final String actividad;

  const TrainingBloque({
    required this.hora,
    required this.seccion,
    required this.actividad,
  });

  factory TrainingBloque.fromJson(Map<String, dynamic> json) {
    return TrainingBloque(
      hora: json['hora'] as String? ?? '',
      seccion: json['seccion'] as String? ?? '',
      actividad: json['actividad'] as String? ?? '',
    );
  }
}

class TrainingDia {
  final String nombre;
  final List<TrainingBloque> bloques;

  const TrainingDia({
    required this.nombre,
    required this.bloques,
  });

  factory TrainingDia.fromJson(Map<String, dynamic> json) {
    return TrainingDia(
      nombre: json['nombre'] as String,
      bloques: (json['bloques'] as List)
          .map((b) => TrainingBloque.fromJson(b as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TrainingSemana {
  final int numero;
  final String titulo;
  final String? pdfAsset;
  final List<TrainingDia> dias;

  const TrainingSemana({
    required this.numero,
    required this.titulo,
    this.pdfAsset,
    this.dias = const [],
  });

  factory TrainingSemana.fromJson(Map<String, dynamic> json) {
    return TrainingSemana(
      numero: json['numero'] as int,
      titulo: json['titulo'] as String,
      pdfAsset: json['pdfAsset'] as String?,
      dias: (json['dias'] as List?)
              ?.map((d) => TrainingDia.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get hasContent => dias.isNotEmpty;
}

class TrainingMonth {
  final String id;
  final String nombre;
  final List<TrainingSemana> semanas;

  const TrainingMonth({
    required this.id,
    required this.nombre,
    required this.semanas,
  });

  factory TrainingMonth.fromJson(Map<String, dynamic> json) {
    return TrainingMonth(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      semanas: (json['semanas'] as List)
          .map((s) => TrainingSemana.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TrainingGroup {
  final String id;
  final String nombre;
  final List<TrainingMonth> meses;

  const TrainingGroup({
    required this.id,
    required this.nombre,
    required this.meses,
  });

  factory TrainingGroup.fromJson(Map<String, dynamic> json) {
    return TrainingGroup(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      meses: (json['meses'] as List)
          .map((m) => TrainingMonth.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}
