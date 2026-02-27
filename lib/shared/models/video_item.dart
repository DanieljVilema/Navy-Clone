class VideoItem {
  final String id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String url;
  final String? thumbnailUrl;

  VideoItem({
    required this.id,
    required this.titulo,
    this.descripcion = '',
    required this.categoria,
    this.url = '',
    this.thumbnailUrl,
  });

  bool get hasVideo => url.isNotEmpty;

  factory VideoItem.fromJson(Map<String, dynamic> j) => VideoItem(
        id: j['id'] as String? ?? '',
        titulo: j['titulo'] as String? ?? '',
        descripcion: j['descripcion'] as String? ?? '',
        categoria: j['categoria'] as String? ?? '',
        url: j['url'] as String? ?? '',
        thumbnailUrl: j['thumbnailUrl'] as String?,
      );
}
