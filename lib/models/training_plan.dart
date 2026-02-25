class TrainingSemana {
  final int numero;
  final String titulo;
  final String? pdfAsset;

  const TrainingSemana({
    required this.numero,
    required this.titulo,
    this.pdfAsset,
  });

  factory TrainingSemana.fromJson(Map<String, dynamic> json) {
    return TrainingSemana(
      numero: json['numero'] as int,
      titulo: json['titulo'] as String,
      pdfAsset: json['pdfAsset'] as String?,
    );
  }
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
