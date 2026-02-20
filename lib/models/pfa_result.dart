class PfaResult {
  final int? id;
  final int userId;
  final DateTime fecha;
  final String tipoCardio;
  final int? flexionesRaw;
  final int? abdominalesRaw;
  final int? cardioSegundos;
  final double notaFlexiones;
  final double notaAbdominales;
  final double notaCardio;
  final double notaTotal;
  final String nivel;
  final double? cinturaRatio;
  final double? imc;
  final String? estadoBca;

  PfaResult({
    this.id,
    required this.userId,
    required this.fecha,
    required this.tipoCardio,
    this.flexionesRaw,
    this.abdominalesRaw,
    this.cardioSegundos,
    required this.notaFlexiones,
    required this.notaAbdominales,
    required this.notaCardio,
    required this.notaTotal,
    required this.nivel,
    this.cinturaRatio,
    this.imc,
    this.estadoBca,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'user_id': userId,
        'fecha': fecha.toIso8601String(),
        'tipo_cardio': tipoCardio,
        'flexiones_raw': flexionesRaw,
        'abdominales_raw': abdominalesRaw,
        'cardio_segundos': cardioSegundos,
        'nota_flexiones': notaFlexiones,
        'nota_abdominales': notaAbdominales,
        'nota_cardio': notaCardio,
        'nota_total': notaTotal,
        'nivel': nivel,
        'cintura_ratio': cinturaRatio,
        'imc': imc,
        'estado_bca': estadoBca,
      };

  factory PfaResult.fromMap(Map<String, dynamic> m) => PfaResult(
        id: m['id'] as int?,
        userId: m['user_id'] as int? ?? 1,
        fecha: DateTime.tryParse(m['fecha'] as String? ?? '') ?? DateTime.now(),
        tipoCardio: m['tipo_cardio'] as String? ?? '',
        flexionesRaw: m['flexiones_raw'] as int?,
        abdominalesRaw: m['abdominales_raw'] as int?,
        cardioSegundos: m['cardio_segundos'] as int?,
        notaFlexiones: (m['nota_flexiones'] as num?)?.toDouble() ?? 0,
        notaAbdominales: (m['nota_abdominales'] as num?)?.toDouble() ?? 0,
        notaCardio: (m['nota_cardio'] as num?)?.toDouble() ?? 0,
        notaTotal: (m['nota_total'] as num?)?.toDouble() ?? 0,
        nivel: m['nivel'] as String? ?? '',
        cinturaRatio: (m['cintura_ratio'] as num?)?.toDouble(),
        imc: (m['imc'] as num?)?.toDouble(),
        estadoBca: m['estado_bca'] as String?,
      );
}
