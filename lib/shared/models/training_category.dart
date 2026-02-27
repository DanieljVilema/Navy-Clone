class TrainingCategory {
  final String titulo;
  final String cantidadRutinas;
  final List<String> ejercicios;

  TrainingCategory({
    required this.titulo,
    required this.cantidadRutinas,
    this.ejercicios = const [],
  });

  factory TrainingCategory.fromJson(Map<String, dynamic> j) =>
      TrainingCategory(
        titulo: j['titulo'] as String? ?? '',
        cantidadRutinas: j['cantidadRutinas'] as String? ?? '',
        ejercicios: (j['ejercicios'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );
}
