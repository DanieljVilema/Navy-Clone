class NutritionItem {
  final String titulo;
  final String descripcion;
  final String? categoria;
  final List<String> alimentos;
  final String? caloriasAprox;
  final String? url;

  NutritionItem({
    required this.titulo,
    required this.descripcion,
    this.categoria,
    this.alimentos = const [],
    this.caloriasAprox,
    this.url,
  });

  factory NutritionItem.fromJson(Map<String, dynamic> j) => NutritionItem(
        titulo: j['titulo'] as String? ?? '',
        descripcion: j['descripcion'] as String? ?? '',
        categoria: j['categoria'] as String?,
        alimentos: (j['alimentos'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        caloriasAprox: j['calorias_aprox'] as String?,
        url: j['url'] as String?,
      );
}
