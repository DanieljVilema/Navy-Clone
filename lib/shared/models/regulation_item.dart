class RegulationItem {
  final String titulo;
  final String subtitulo;
  final String? pdfAsset;
  final String? externalUrl;

  RegulationItem({
    required this.titulo,
    this.subtitulo = '',
    this.pdfAsset,
    this.externalUrl,
  });

  bool get hasLink => (pdfAsset?.isNotEmpty ?? false) || (externalUrl?.isNotEmpty ?? false);
  bool get isExternal => externalUrl?.isNotEmpty ?? false;

  factory RegulationItem.fromJson(Map<String, dynamic> j) => RegulationItem(
        titulo: j['titulo'] as String? ?? '',
        subtitulo: j['subtitulo'] as String? ?? '',
        pdfAsset: j['pdfAsset'] as String?,
        externalUrl: j['externalUrl'] as String?,
      );
}
