class ExerciseType {
  final int? id;
  final String nombre;
  final String clave;
  final String categoria;
  final String metricaPrincipal;
  final String icono;

  const ExerciseType({
    this.id,
    required this.nombre,
    required this.clave,
    required this.categoria,
    required this.metricaPrincipal,
    required this.icono,
  });

  bool get isRepsBased => metricaPrincipal == 'repeticiones';
  bool get isDistanceBased => metricaPrincipal == 'distancia';
  bool get isTimeBased => metricaPrincipal == 'tiempo';

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'clave': clave,
        'categoria': categoria,
        'metrica_principal': metricaPrincipal,
        'icono': icono,
      };

  factory ExerciseType.fromMap(Map<String, dynamic> map) => ExerciseType(
        id: map['id'] as int?,
        nombre: map['nombre'] as String,
        clave: map['clave'] as String,
        categoria: map['categoria'] as String,
        metricaPrincipal: map['metrica_principal'] as String,
        icono: map['icono'] as String,
      );
}
